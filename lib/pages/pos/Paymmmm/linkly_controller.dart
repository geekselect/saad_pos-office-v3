import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/controller/order_history_controller.dart';
import 'package:pos/model/cart_master.dart';
import 'package:pos/pages/pos/Core%20Payments/linkly_refund_response_model.dart';
import 'package:pos/pages/pos/Paymmmm/linkly_model.dart';
import 'package:pos/printer/printer_controller.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../Core Payments/linkly_purchase_response_model.dart';
import 'linkly_pair_model.dart';
import 'package:http/http.dart' as http;


class LinklyDataController extends GetxController {
  final OrderCustimizationController _orderCustimizationController =
  Get.find<OrderCustimizationController>();
  final OrderHistoryController _orderHistoryMainController = Get.put(OrderHistoryController());
  final PrinterController _printerController = Get.put(PrinterController());
  RxInt placeValue = 0.obs;
  Timer? delayedCall;
  Rx<LinklyPairModel> linklyDataModel = LinklyPairModel().obs;
  Rx<LinklyPurchaseResponseModel> linklyPurchaseResponseModel = LinklyPurchaseResponseModel().obs;


  Future<BaseModel<LinklyPairModel>>? linklyDataApiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    print("vendorId ${vendorId}");
    LinklyPairModel response;
    try {
      response = await RestClient(await RetroApi().dioData())
          .linklyGet(int.parse(vendorId.toString()));
      print("data of linkly ${response.toJson()}");

      linklyDataModel.value = response;
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<LinklyPairModel>> calllinklyUpdate(BuildContext context) async {
    LinklyPairModel response;
    try {

      Map<String, String> body = {
        'vendorId': linklyDataModel.value.data!.vendorId.toString(),
        'user_name': linklyDataModel.value.data!.userName.toString(),
        'password': linklyDataModel.value.data!.password.toString(),
        'token': linklyDataModel.value.data!.token ?? '',
        'secret_key': linklyDataModel.value.data!.secretKey ?? '',
      };
      response = await RestClient(await RetroApi().dioData()).linklyUpdate(body);

      linklyDataModel.value = response;
    } catch (error, stacktrace) {
      Constants.hideDialog(context);
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  RxString dialogTitle = ''.obs;
  RxString dialogContent = ''.obs;

  @override
  void onClose() {
    super.onClose();
    timer?.cancel();
  }

  var uuid = Uuid();
  Future<void> transactionPayment(String Amount, dynamic id,  Function(int, String) onApproved, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String appToken = prefs.getString(Constants.headerToken.toString()) ?? '';
    var completer = Completer<void>();

    var newAmount = (double.parse(Amount) * 100).toInt();
    print(id);
    print(linklyDataModel.value.data!.token);// Convert string to double, multiply by 100, and convert to integer
    print(newAmount);
    var url = Uri.parse(
        'https://rest.pos.sandbox.cloud.pceftpos.com/v1/sessions/$id/transaction?async=true');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${linklyDataModel.value.data!.token.toString()}',
      'Accept': 'application/json',
    };
    var body = jsonEncode({
      "Request": {
        "Merchant": "99",
        "TxnType": "P",
        "AmtPurchase": newAmount.toString(),
        "TxnRef": "0123456789",
        "CurrencyCode": "AUD",
        "CutReceipt": "0",
        "ReceiptAutoPrint": "0",
        "Application": "02",
        "PurchaseAnalysisData": {
          "OPR": "00766|test",
          "AMT": "0042000",
          "PCM": "0000"
        },
        "Basket": {
          "id": "t39kq18134553",
          "amt": newAmount.toString(),
          "tax": 0,
          "dis": 0,
          "sur": 0,
          "items": [
            {
              "id": "t39kq002",
              "sku": "k24086723",
              "qty": 0,
              "amt": newAmount.toString(),
              "tax": 0,
              "dis": 0,
              "name": "OzPos Item"
            }
          ]
        }
      },
      "Notification": {
        "Uri": "https://v4.ozfoodz.com.au/api/pos/Linkly/$id/transaction",
        "AuthorizationHeader": "Bearer $appToken"
      }
    });

    var responseMessage;
    dialogTitle.value = 'Check Pin Pad';
    dialogContent.value = 'Please follow the instructions on the pin pad';
    try {
      Constants.onLoading(context);
      var response = await http.post(url, headers: headers, body: body);
      print('res body ${response.body}');
      print('res status ${response.statusCode}');
      if (response.statusCode == 202) {
        Constants.hideDialog(context);
        linklyModel.value = LinklyModel(
          success: null,
          data: null,
        );
        fetchDataRepeatedly(id, onApproved);
      }  else {
        linklyDataModel.value.data!.secretKey = null;
        linklyDataModel.value.data!.token = null;
        calllinklyUpdate(context);
        Constants.toastMessage('please pair again');
        Constants.hideDialog(context);
      }
      completer.complete();
    } catch (e) {
      responseMessage = 'Error: $e';
      completer.complete();
    }



    // Do something with the response message
    print(responseMessage);
    return completer.future;
  }
  Rx<LinklyModel> linklyModel = LinklyModel().obs;
  Rx<LinklyRefundResponseModel> linklyRefundResponseModel = LinklyRefundResponseModel().obs;
  RxBool showDialogvalue = false.obs;
  RxBool showDialogRefundValue = false.obs;
  Timer? timer;
  void fetchDataRepeatedly(String sessionId, Function(int, String) onApproved) {
    print("linkly Model data ${linklyModel.value.toJson()}");
    fetchData(sessionId);
    showDialogvalue.value = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchData(sessionId);
      if (linklyModel.value.data is DataLinkly) {
        DataLinkly data = linklyModel.value.data;
        if(linklyModel.value.success != null) {
  // if (data.request?.response?.displayText?.isNotEmpty == true &&
  //     data.request!.response!.displayText![0] == 'APPROVED') {
  //   print("timer cancel");
  //   timer.cancel();
  //   showDialogvalue.value = false;
  //   resetVariables();
  //   onApproved(placeValue.value, sessionId);
  //   return;
  // } else if (data.request?.response?.displayText?.isNotEmpty == true &&
  //     data.request!.response!.displayText![0] == 'TRANSACTION DECLINED'){
  //   print("timer cancel");
  //   timer.cancel();
  //   showDialogvalue.value = false;
  //   resetVariables();
  //   Get.snackbar("Order Status", "Your request has not been approved!\nplease try again");
  // }

          if(data.request!.responseType == 'display'){
            print("display");
            if( data.request!.response is AboveResponse) {
              AboveResponse aboveResponse = data.request!.response;
              if (aboveResponse.displayText?.isNotEmpty == true) {
                // Map display text values to variable values
                dialogTitle.value =
                    mapDisplayTextToTitle(
                        aboveResponse.displayText?[0]);
                dialogContent.value =
                    mapDisplayTextToVariable(
                        aboveResponse.displayText?[0]);
              }
            }
          } else {
            print("transaction");
            BeneathResponse beneathResponse = data.request!.response;
            if(beneathResponse.responseText == 'APPROVED'){
              dialogTitle.value =
                  mapDisplayTextToTitle(beneathResponse.responseText);
              dialogContent.value = mapDisplayTextToVariable(beneathResponse.responseText);
              onApproved(placeValue.value, sessionId);
            } else if(beneathResponse.responseText == 'OPERATOR TIMEOUT'){
              dialogTitle.value =
                  mapDisplayTextToTitle(beneathResponse.responseText);
              dialogContent.value = mapDisplayTextToVariable(beneathResponse.responseText);
            } else if(beneathResponse.responseText == 'SYSTEM ERROR'){
              dialogTitle.value =
                  mapDisplayTextToTitle(beneathResponse.responseText);
              dialogContent.value = mapDisplayTextToVariable(beneathResponse.responseText);
            } else {
              dialogTitle.value =
                  mapDisplayTextToTitle(beneathResponse.responseText);
              dialogContent.value = mapDisplayTextToVariable("your transaction has been declined");
            }
            timer.cancel();
            Future.delayed(Duration(seconds: 3), () {
              print("F");
              showDialogvalue.value = false;
              resetVariables();
              return;
            });
          }

}
      }
      print("-------------------------");
      print(linklyModel.value.toJson());
      print("-------------------------");
    });
  }
  Future<void> fetchData(String sessionId) async {
    final url = 'https://v4.ozfoodz.com.au/api/pos/getLinklydata/$sessionId';
    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        // Check if the response body is a JSON object

        // Handle the case where success is true
        LinklyModel linklyModelNew =
        LinklyModel.fromJson(jsonDecode(response.body));
        linklyModel.value = linklyModelNew;
        print("*************************");
        print(linklyModelNew.toJson());
        print("*************************");


        if (linklyModelNew.data is DataRefundLinkly) {
          DataRefundLinkly dataRefundLinkly = linklyModelNew.data!;
          if(dataRefundLinkly.request!.responseType == "display") {
            AboveResponse aboveResponse = dataRefundLinkly.request!.response;
            dialogTitle.value =
                mapDisplayTextToTitle(aboveResponse.displayText?[0]);
            dialogContent.value = mapDisplayTextToVariable(aboveResponse.displayText?[0]);
          }
          // else {
          //   BeneathResponse beneathResponse = dataRefundLinkly.request!.response;
          //   if(beneathResponse.responseText == 'APPROVED'){
          //     dialogTitle.value =
          //         mapDisplayTextToTitle(beneathResponse.responseText);
          //     dialogContent.value = mapDisplayTextToVariable(beneathResponse.responseText);
          //   } else if(beneathResponse.responseText == 'OPERATOR TIMEOUT'){
          //     dialogTitle.value =
          //         mapDisplayTextToTitle(beneathResponse.responseText);
          //     dialogContent.value = mapDisplayTextToVariable(beneathResponse.responseText);
          //     Get.snackbar("Order Status", "Your request has not been declined due to timeout!\nplease try again");
          //   } else if(beneathResponse.responseText == 'SYSTEM ERROR'){
          //     dialogTitle.value =
          //         mapDisplayTextToTitle(beneathResponse.responseText);
          //     dialogContent.value = mapDisplayTextToVariable(beneathResponse.responseText);
          //     Get.snackbar("Order Status", "Your request has not been declined from pin pad!");
          //   } else {
          //     dialogTitle.value =
          //         mapDisplayTextToTitle(beneathResponse.responseText);
          //     dialogContent.value = mapDisplayTextToVariable("your transaction has been declined");
          //     Get.snackbar("Order Status", "Your request has not been declined from pin pad!");
          //   }
          // }
        }

      } else {
        print("Error: HTTP request failed with status code ${response.statusCode}");
      }
    } catch (e) {
      print("Error: Failed to parse response body");
    }
  }
  void resetVariables() {
    dialogContent.value = '';
    dialogTitle.value = '';
  }
  String mapDisplayTextToTitle(String? displayText) {
    if (displayText == "SWIPE CARD") {
      return "SWIPE CARD";
    } else if (displayText == "ENTER ACCOUNT") {
      return "ENTER ACCOUNT";
    } else if (displayText == "ENTER PIN") {
      return "ENTER PIN";
    } else if (displayText == "PROCESSING") {
      return "PROCESSING";
    } else if (displayText == "APPROVED") {
      return "APPROVED";
    } else if (displayText == "TRANSACTION DECLINED") {
      return "DECLINED";
    } else if (displayText == "OPERATOR TIMEOUT") {
      return "Transaction Timeout";
    } else if (displayText == "SYSTEM ERROR") {
      return "Transaction DECLINED";
    } else {
      return "";
    }
  }
  String mapDisplayTextToVariable(String? displayText) {
    if (displayText == "SWIPE CARD") {
      return "Please swipe a card";
    } else if (displayText == "ENTER ACCOUNT") {
      return "Please enter an account";
    } else if (displayText == "ENTER PIN") {
      return "Please enter a pin";
    } else if (displayText == "PROCESSING") {
      return "Processing... Please wait";
    } else if (displayText == "APPROVED") {
      return "Transaction approved";
    } else if (displayText == "TRANSACTION DECLINED") {
      return "Transaction declined";
    } else if (displayText == "OPERATOR TIMEOUT") {
      return "Your request has been declined due to timeout!";
    } else if (displayText == "SYSTEM ERROR") {
      return "Your request has been declined from pin pad";
    } else {
      return "";
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    linklyDataApiCall();
  }


  ///Core Payments
  // // POS Capabilities Matrix (first byte = POS can scan Barcode)
  //
  //
  // Future<void> sendPurchaseRequest(dynamic newId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String appToken = prefs.getString(Constants.headerToken.toString()) ?? '';
  //   // var completer = Completer<void>();
  //   var id = uuid.v4();
  //
  //   // var newAmount = (double.parse(Amount) * 100).toInt();
  //   print(id);// Convert string to double, multiply by 100, and convert to integer
  //   // print(newAmount);
  //   var url = Uri.parse(
  //       'https://rest.pos.sandbox.cloud.pceftpos.com/v1/sessions/$id/transaction?async=true');
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer ${linklyDataModel.value.data!.token.toString()}',
  //     'Accept': 'application/json',
  //   };
  //
  //   var body = jsonEncode({
  //       "Request": {
  //         "Merchant": "00",
  //         "TxnType": "P",
  //         "AmtPurchase": 1000,
  //         "TxnRef": "1234567890",
  //         "CurrencyCode": "AUD",
  //         "CutReceipt": "0",
  //         "ReceiptAutoPrint": "0",
  //         "Application": "00",
  //         "PurchaseAnalysisData":
  //         {
  //           "OPR": "00766|test",
  //           "AMT": "0042000",
  //           "PCM": "0000"
  //         },
  //         "Basket":
  //         {
  //           "id": "t39kq18134553",
  //           "amt": 2145,
  //           "tax": 200,
  //           "dis": 50,
  //           "sur": 0,
  //           "items": [{
  //             "id": "t39kq002",
  //             "sku": "k24086723",
  //             "qty": 2,
  //             "amt": 2145,
  //             "tax": 200,
  //             "dis": 50,
  //             "name": "XData USB Drive"
  //           }]
  //         }
  //       },
  //     "Notification": {
  //       "Uri": "https://v4.ozfoodz.com.au/api/pos/Linkly/$id/transaction",
  //       "AuthorizationHeader": "Bearer $appToken"
  //     }
  //   });
  //   var response = await http.post(url, headers: headers, body: body);
  //   print('res status ${response.statusCode}');
  //   print('res body ${response.body}');
  //
  //   // Process the response as needed
  //   if (response.statusCode == 202) {
  //     // Purchase request successful
  //     // var responseData = jsonDecode(response.body);
  //     Map<String, dynamic> userMap = jsonDecode(response.body);
  //     var user = LinklyPurchaseResponseModel.fromJson(userMap);
  //     // String rfn = responseData['PurchaseAnalysisData']['RFN'];
  //     // Store the 'RFN' value in your POS system for future refund matching
  //     print("rfn ${user.response!.purchaseAnalysisData!.rfn.toString()}");
  //   } else {
  //     // Purchase request failed
  //     print('Purchase request failed. Status code: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //   }
  // }

  Future<void> sendRefundRequest(String newid, String Amount, dynamic orderId, dynamic order, BuildContext contextMain) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String appToken = prefs.getString(Constants.headerToken.toString()) ?? '';
    // var completer = Completer<void>();
    var id = uuid.v4();
    var newAmount = (double.parse(Amount) * 100).toInt();

    // Make a refund request using the stored 'TxnRef'
    Future<void> makeRefundRequest(String txnRef) async {
      var refundUrl = Uri.parse('https://rest.pos.sandbox.cloud.pceftpos.com/v1/sessions/$id/transaction?async=true');
      var refundHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${linklyDataModel.value.data!.token.toString()}',
        'Accept': 'application/json',
      };
      var refundBody = jsonEncode({
        "Request": {
          "Merchant": "00",
          "TxnType": "R",
          "AmtPurchase": newAmount.toString(),
          "TxnRef": txnRef,
          "CurrencyCode": "AUD",
          "CutReceipt": "0",
          "ReceiptAutoPrint": "0",
          "App": "00",
        },
        "Notification": {
          "Uri": "https://v4.ozfoodz.com.au/api/pos/Linkly/$id/transaction",
          "AuthorizationHeader": "Bearer $appToken"
        }
      });
      dialogTitle.value = 'Check Pin Pad';
      dialogContent.value = 'Please follow the instructions on the pin pad';
      try {
        var refundResponse = await http.post(refundUrl, headers: refundHeaders, body: refundBody);
        print('refundResponse body ${refundResponse.body}');
        print('refundResponse status ${refundResponse.statusCode}');
        if (refundResponse.statusCode == 202) {
          fetchRefundDataRepeatedly(id, orderId, order, contextMain);
        } else {
          print('Refund request failed with status code ${refundResponse.statusCode}');
          print('Refund request failed with body code ${refundResponse.body}');
        }
      } catch (e) {
        print('Error making refund request: $e');
      }
    }

    // Call the makeRefundRequest function with the stored 'TxnRef'
    makeRefundRequest(newid);

  }

  void fetchRefundDataRepeatedly(String sessionId, dynamic orderId, dynamic order, BuildContext context)  {
    fetchRefundData(sessionId);
    showDialogRefundValue.value = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      fetchRefundData(sessionId);
      if (linklyRefundResponseModel.value.data is DataRefundLinkly) {
        DataRefundLinkly data = linklyRefundResponseModel.value.data;
        print("daaaa ${data.type}");
        if (linklyRefundResponseModel.value.success != null) {
          if (data.request!.responseType == "display") {
            AboveResponse aboveResponse = data.request!.response;
            if (aboveResponse.displayText?.isNotEmpty == true &&
                aboveResponse.displayText![0] == 'APPROVED') {
              print("timer cancel");
              timer.cancel();
              showDialogRefundValue.value = false;
              resetVariables();
                await _orderHistoryMainController.callCancelOrder(
                    orderId,
                    'Refund By Linkly',
                    context);
                if ((_printerController.printerModel.value
                    .ipKitchen !=
                    null &&
                    _printerController.printerModel.value
                        .ipKitchen!.isNotEmpty) &&
                    (_printerController.printerModel.value
                        .portKitchen !=
                        null &&
                        _printerController.printerModel.value
                            .portKitchen!.isNotEmpty)) {
                  _orderHistoryMainController.testPrintKitchen(
                      _printerController
                          .printerModel.value.ipKitchen!,
                      int.parse(_printerController
                          .printerModel.value.portKitchen
                          .toString()),
                      context,
                      order,
                      true);
                } else {
                  Get.snackbar("Error",
                      "Please add kitchen printer ip and port");
                }

              return;
            } else if (aboveResponse.displayText?.isNotEmpty == true &&
                aboveResponse.displayText![0] == 'TRANSACTION DECLINED'){
              print("timer cancel");
              timer.cancel();
              showDialogRefundValue.value = false;
              resetVariables();
              Get.snackbar("Order Status", "Your request has not been approved!\nplease try again");
            }

            if(aboveResponse.displayText?.isNotEmpty == true) {
              // Map display text values to variable values
              dialogTitle.value =
                  mapDisplayTextToTitle(aboveResponse.displayText?[0]);
              dialogContent.value =
                  mapDisplayTextToVariable(aboveResponse.displayText?[0]);
            }

            // Print the updated values
            print('Variable 1 fetchDataRepeatedly: $dialogTitle');
            print('Variable 2 fetchDataRepeatedly: $dialogContent');

        }
      }

      }
      print("-------------------------");
      print(linklyRefundResponseModel.value.toJson());
      print("-------------------------");
    });
  }

  Future<void> fetchRefundData(String sessionId) async {
    final url = 'https://v4.ozfoodz.com.au/api/pos/getLinklydata/$sessionId';
    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {

        // print("response fetchRefundData ${response.body}");
        // Check if the response body is a JSON object
        //
        // Handle the case where success is true
        var responseBody = jsonDecode(response.body);
        LinklyRefundResponseModel linklyRefundModelNew = LinklyRefundResponseModel.fromJson(responseBody);
        linklyRefundResponseModel.value = linklyRefundModelNew;
        print("*************************");
        print(linklyRefundModelNew.toJson());
        print("*************************");

        if (linklyRefundModelNew.data is DataRefundLinkly) {
          DataRefundLinkly dataRefundLinkly = linklyRefundModelNew.data!;
          if(dataRefundLinkly.request!.responseType == "display") {
            AboveResponse aboveResponse = dataRefundLinkly.request!.response;
                dialogTitle.value =
                    mapDisplayTextToTitle(aboveResponse.displayText?[0]);
                dialogContent.value = mapDisplayTextToVariable(aboveResponse.displayText?[0]);

                // Print the updated values
                print('Variable 1: $dialogTitle');
                print('Variable 2: $dialogContent');
                // Perform any additional logic or actions with the updated variables
          }
        }
      } else {
        print("Error: HTTP request failed with status code ${response.statusCode}");
      }

    } catch (e) {
      print("Error: $e");
    }
  }
}

///Old last with linkly but not best fazool
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pos/controller/order_custimization_controller.dart';
// import 'package:pos/controller/order_history_controller.dart';
// import 'package:pos/model/cart_master.dart';
// import 'package:pos/pages/pos/Core%20Payments/linkly_refund_response_model.dart';
// import 'package:pos/pages/pos/Paymmmm/linkly_model.dart';
// import 'package:pos/printer/printer_controller.dart';
// import 'package:pos/retrofit/api_client.dart';
// import 'package:pos/retrofit/api_header.dart';
// import 'package:pos/retrofit/base_model.dart';
// import 'package:pos/retrofit/server_error.dart';
// import 'package:pos/utils/constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
// import '../Core Payments/linkly_purchase_response_model.dart';
// import 'linkly_pair_model.dart';
// import 'package:http/http.dart' as http;
//
//
// class LinklyDataController extends GetxController {
//   final OrderCustimizationController _orderCustimizationController =
//   Get.find<OrderCustimizationController>();
//   final OrderHistoryController _orderHistoryMainController = Get.put(OrderHistoryController());
//   final PrinterController _printerController = Get.put(PrinterController());
//   RxInt placeValue = 0.obs;
//   Timer? delayedCall;
//   Rx<LinklyPairModel> linklyDataModel = LinklyPairModel().obs;
//   Rx<LinklyPurchaseResponseModel> linklyPurchaseResponseModel = LinklyPurchaseResponseModel().obs;
//
//
//   Future<BaseModel<LinklyPairModel>>? linklyDataApiCall() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
//     print("vendorId ${vendorId}");
//     LinklyPairModel response;
//     try {
//       response = await RestClient(await RetroApi().dioData())
//           .linklyGet(int.parse(vendorId.toString()));
//       print("data of linkly ${response.toJson()}");
//
//       linklyDataModel.value = response;
//     } catch (error, stacktrace) {
//       print("Exception occurred: $error stackTrace: $stacktrace");
//       return BaseModel()..setException(ServerError.withError(error: error));
//     }
//     return BaseModel()..data = response;
//   }
//
//   Future<BaseModel<LinklyPairModel>> calllinklyUpdate(BuildContext context) async {
//     LinklyPairModel response;
//     try {
//
//       Map<String, String> body = {
//         'vendorId': linklyDataModel.value.data!.vendorId.toString(),
//         'user_name': linklyDataModel.value.data!.userName.toString(),
//         'password': linklyDataModel.value.data!.password.toString(),
//         'token': linklyDataModel.value.data!.token ?? '',
//         'secret_key': linklyDataModel.value.data!.secretKey ?? '',
//       };
//       response = await RestClient(await RetroApi().dioData()).linklyUpdate(body);
//
//       linklyDataModel.value = response;
//     } catch (error, stacktrace) {
//       Constants.hideDialog(context);
//       print("Exception occurred: $error stackTrace: $stacktrace");
//       return BaseModel()..setException(ServerError.withError(error: error));
//     }
//     return BaseModel()..data = response;
//   }
//
//   RxString dialogTitle = ''.obs;
//   RxString dialogContent = ''.obs;
//
//   @override
//   void onClose() {
//     super.onClose();
//     timer?.cancel();
//   }
//
//   var uuid = Uuid();
//   Future<void> transactionPayment(String Amount, dynamic id,  Function(int, String) onApproved, BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String appToken = prefs.getString(Constants.headerToken.toString()) ?? '';
//     var completer = Completer<void>();
//
//     var newAmount = (double.parse(Amount) * 100).toInt();
//     print(id);
//     print(linklyDataModel.value.data!.token);// Convert string to double, multiply by 100, and convert to integer
//     print(newAmount);
//     var url = Uri.parse(
//         'https://rest.pos.sandbox.cloud.pceftpos.com/v1/sessions/$id/transaction?async=true');
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${linklyDataModel.value.data!.token.toString()}',
//       'Accept': 'application/json',
//     };
//     var body = jsonEncode({
//       "Request": {
//         "Merchant": "99",
//         "TxnType": "P",
//         "AmtPurchase": newAmount.toString(),
//         "TxnRef": "0123456789",
//         "CurrencyCode": "AUD",
//         "CutReceipt": "0",
//         "ReceiptAutoPrint": "0",
//         "Application": "02",
//         "PurchaseAnalysisData": {
//           "OPR": "00766|test",
//           "AMT": "0042000",
//           "PCM": "0000"
//         },
//         "Basket": {
//           "id": "t39kq18134553",
//           "amt": newAmount.toString(),
//           "tax": 0,
//           "dis": 0,
//           "sur": 0,
//           "items": [
//             {
//               "id": "t39kq002",
//               "sku": "k24086723",
//               "qty": 0,
//               "amt": newAmount.toString(),
//               "tax": 0,
//               "dis": 0,
//               "name": "OzPos Item"
//             }
//           ]
//         }
//       },
//       "Notification": {
//         "Uri": "https://v4.ozfoodz.com.au/api/pos/Linkly/$id/transaction",
//         "AuthorizationHeader": "Bearer $appToken"
//       }
//     });
//
//     var responseMessage;
//     dialogTitle.value = 'Check Pin Pad';
//     dialogContent.value = 'Please follow the instructions on the pin pad';
//     try {
//       Constants.onLoading(context);
//       var response = await http.post(url, headers: headers, body: body);
//       print('res body ${response.body}');
//       print('res status ${response.statusCode}');
//       if (response.statusCode == 202) {
//         Constants.hideDialog(context);
//         linklyModel.value = LinklyModel(
//           success: null,
//           data: null,
//         );
//         fetchDataRepeatedly(id, onApproved);
//       }  else {
//         linklyDataModel.value.data!.secretKey = null;
//         linklyDataModel.value.data!.token = null;
//         calllinklyUpdate(context);
//         Constants.toastMessage('please pair again');
//         Constants.hideDialog(context);
//       }
//       completer.complete();
//     } catch (e) {
//       responseMessage = 'Error: $e';
//       completer.complete();
//     }
//
//
//
//     // Do something with the response message
//     print(responseMessage);
//     return completer.future;
//   }
//   Rx<LinklyModel> linklyModel = LinklyModel().obs;
//   Rx<LinklyRefundResponseModel> linklyRefundResponseModel = LinklyRefundResponseModel().obs;
//   RxBool showDialogvalue = false.obs;
//   RxBool showDialogRefundValue = false.obs;
//   Timer? timer;
//   void fetchDataRepeatedly(String sessionId, Function(int, String) onApproved) {
//     print("linkly Model data ${linklyModel.value.toJson()}");
//     fetchData(sessionId);
//     showDialogvalue.value = true;
//     timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       fetchData(sessionId);
//       if (linklyModel.value.data is DataLinkly) {
//         DataLinkly data = linklyModel.value.data;
//         if(linklyModel.value.success != null) {
//           // if (data.request?.response?.displayText?.isNotEmpty == true &&
//           //     data.request!.response!.displayText![0] == 'APPROVED') {
//           //   print("timer cancel");
//           //   timer.cancel();
//           //   showDialogvalue.value = false;
//           //   resetVariables();
//           //   onApproved(placeValue.value, sessionId);
//           //   return;
//           // } else if (data.request?.response?.displayText?.isNotEmpty == true &&
//           //     data.request!.response!.displayText![0] == 'TRANSACTION DECLINED'){
//           //   print("timer cancel");
//           //   timer.cancel();
//           //   showDialogvalue.value = false;
//           //   resetVariables();
//           //   Get.snackbar("Order Status", "Your request has not been approved!\nplease try again");
//           // }
//
//           if(data.request!.responseType == 'display'){
//             print("display");
//             if( data.request!.response is AboveResponse) {
//               AboveResponse aboveResponse = data.request!.response;
//               if (data.request!.responseType == 'display' &&
//                   aboveResponse.displayText![0] == 'TRANSACTION DECLINED') {
//                 print("DDDDDDD");
//                 dialogTitle.value =
//                     mapDisplayTextToTitle('SYSTEM ERROR');
//                 dialogContent.value = mapDisplayTextToVariable('SYSTEM ERROR');
//                 timer.cancel();
//                 Future.delayed(Duration(seconds: 3), () {
//                   print("F");
//                   showDialogvalue.value = false;
//                   resetVariables();
//                   return;
//                 });
//               } else {
//                 if (aboveResponse.displayText?.isNotEmpty == true) {
//                   // Map display text values to variable values
//                   dialogTitle.value =
//                       mapDisplayTextToTitle(
//                           aboveResponse.displayText?[0]);
//                   dialogContent.value =
//                       mapDisplayTextToVariable(
//                           aboveResponse.displayText?[0]);
//                 }
//               }
//             } else {
//               BeneathResponse beneathResponse = data.request!.response;
//               dialogTitle.value =
//                   mapDisplayTextToTitle(beneathResponse.responseText);
//               dialogContent.value =
//                   mapDisplayTextToVariable(beneathResponse.responseText);
//               timer.cancel();
//               Future.delayed(Duration(seconds: 3), () {
//                 print("F fuul else");
//                 showDialogvalue.value = false;
//                 resetVariables();
//                 return;
//               });
//             }
//           } else  if(data.request!.responseType == 'transaction'){
//             print("transaction");
//             BeneathResponse beneathResponse = data.request!.response;
//             if(beneathResponse.responseText == 'APPROVED'){
//               dialogTitle.value =
//                   mapDisplayTextToTitle(beneathResponse.responseText);
//               dialogContent.value = mapDisplayTextToVariable(beneathResponse.responseText);
//               onApproved(placeValue.value, sessionId);
//             } else if(beneathResponse.responseText == 'OPERATOR TIMEOUT'){
//               dialogTitle.value =
//                   mapDisplayTextToTitle(beneathResponse.responseText);
//               dialogContent.value = mapDisplayTextToVariable(beneathResponse.responseText);
//             } else if(beneathResponse.responseText == 'SYSTEM ERROR'){
//               dialogTitle.value =
//                   mapDisplayTextToTitle(beneathResponse.responseText);
//               dialogContent.value = mapDisplayTextToVariable(beneathResponse.responseText);
//             } else {
//               dialogTitle.value =
//                   mapDisplayTextToTitle(beneathResponse.responseText);
//               dialogContent.value = mapDisplayTextToVariable("your transaction has been declined");
//             }
//             timer.cancel();
//             Future.delayed(Duration(seconds: 3), () {
//               print("F");
//               showDialogvalue.value = false;
//               resetVariables();
//               return;
//             });
//             // showDialogvalue.value = false;
//             // resetVariables();
//             // return;
//           }
//
//         }
//       }
//       print("-------------------------");
//       print(linklyModel.value.toJson());
//       print("-------------------------");
//     });
//   }
//   Future<void> fetchData(String sessionId) async {
//     final url = 'https://v4.ozfoodz.com.au/api/pos/getLinklydata/$sessionId';
//     final response = await http.get(Uri.parse(url));
//     try {
//       if (response.statusCode == 200) {
//         // Check if the response body is a JSON object
//
//         // Handle the case where success is true
//         LinklyModel linklyModelNew =
//         LinklyModel.fromJson(jsonDecode(response.body));
//         linklyModel.value = linklyModelNew;
//         print("*************************");
//         print(linklyModelNew.toJson());
//         print("*************************");
//
//
//         if (linklyModelNew.data is DataRefundLinkly) {
//           DataRefundLinkly dataRefundLinkly = linklyModelNew.data!;
//           if(dataRefundLinkly.request!.responseType == "display") {
//             AboveResponse aboveResponse = dataRefundLinkly.request!.response;
//             dialogTitle.value =
//                 mapDisplayTextToTitle(aboveResponse.displayText?[0]);
//             dialogContent.value = mapDisplayTextToVariable(aboveResponse.displayText?[0]);
//
//             // Print the updated values
//             print('Variable 1: $dialogTitle');
//             print('Variable 2: $dialogContent');
//             // Perform any additional logic or actions with the updated variables
//           }
//           // else {
//           //   BeneathResponse beneathResponse = dataRefundLinkly.request!.response;
//           //   if(beneathResponse.responseText == 'APPROVED'){
//           //     dialogTitle.value =
//           //         mapDisplayTextToTitle(beneathResponse.responseText);
//           //     dialogContent.value = mapDisplayTextToVariable(beneathResponse.responseText);
//           //   } else if(beneathResponse.responseText == 'OPERATOR TIMEOUT'){
//           //     dialogTitle.value =
//           //         mapDisplayTextToTitle(beneathResponse.responseText);
//           //     dialogContent.value = mapDisplayTextToVariable(beneathResponse.responseText);
//           //     Get.snackbar("Order Status", "Your request has not been declined due to timeout!\nplease try again");
//           //   } else if(beneathResponse.responseText == 'SYSTEM ERROR'){
//           //     dialogTitle.value =
//           //         mapDisplayTextToTitle(beneathResponse.responseText);
//           //     dialogContent.value = mapDisplayTextToVariable(beneathResponse.responseText);
//           //     Get.snackbar("Order Status", "Your request has not been declined from pin pad!");
//           //   } else {
//           //     dialogTitle.value =
//           //         mapDisplayTextToTitle(beneathResponse.responseText);
//           //     dialogContent.value = mapDisplayTextToVariable("your transaction has been declined");
//           //     Get.snackbar("Order Status", "Your request has not been declined from pin pad!");
//           //   }
//           // }
//         }
//
//       } else {
//         print("Error: HTTP request failed with status code ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error: Failed to parse response body");
//     }
//   }
//   void resetVariables() {
//     dialogContent.value = '';
//     dialogTitle.value = '';
//   }
//   String mapDisplayTextToTitle(String? displayText) {
//     if (displayText == "SWIPE CARD") {
//       return "SWIPE CARD";
//     } else if (displayText == "ENTER ACCOUNT") {
//       return "ENTER ACCOUNT";
//     } else if (displayText == "ENTER PIN") {
//       return "ENTER PIN";
//     } else if (displayText == "PROCESSING") {
//       return "PROCESSING";
//     } else if (displayText == "APPROVED") {
//       return "APPROVED";
//     } else if (displayText == "TRANSACTION DECLINED") {
//       return "DECLINED";
//     } else if (displayText == "OPERATOR TIMEOUT") {
//       return "Transaction Timeout";
//     } else if (displayText == "SYSTEM ERROR") {
//       return "Transaction DECLINED";
//     } else {
//       return "";
//     }
//   }
//   String mapDisplayTextToVariable(String? displayText) {
//     if (displayText == "SWIPE CARD") {
//       return "Please swipe a card";
//     } else if (displayText == "ENTER ACCOUNT") {
//       return "Please enter an account";
//     } else if (displayText == "ENTER PIN") {
//       return "Please enter a pin";
//     } else if (displayText == "PROCESSING") {
//       return "Processing... Please wait";
//     } else if (displayText == "APPROVED") {
//       return "Transaction approved";
//     } else if (displayText == "TRANSACTION DECLINED") {
//       return "Transaction declined";
//     } else if (displayText == "OPERATOR TIMEOUT") {
//       return "Your request has been declined due to timeout!";
//     } else if (displayText == "SYSTEM ERROR") {
//       return "Your request has been declined from pin pad";
//     } else {
//       return "";
//     }
//   }
//
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     linklyDataApiCall();
//   }
//
//
//   ///Core Payments
//   // // POS Capabilities Matrix (first byte = POS can scan Barcode)
//   //
//   //
//   // Future<void> sendPurchaseRequest(dynamic newId) async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String appToken = prefs.getString(Constants.headerToken.toString()) ?? '';
//   //   // var completer = Completer<void>();
//   //   var id = uuid.v4();
//   //
//   //   // var newAmount = (double.parse(Amount) * 100).toInt();
//   //   print(id);// Convert string to double, multiply by 100, and convert to integer
//   //   // print(newAmount);
//   //   var url = Uri.parse(
//   //       'https://rest.pos.sandbox.cloud.pceftpos.com/v1/sessions/$id/transaction?async=true');
//   //   var headers = {
//   //     'Content-Type': 'application/json',
//   //     'Authorization': 'Bearer ${linklyDataModel.value.data!.token.toString()}',
//   //     'Accept': 'application/json',
//   //   };
//   //
//   //   var body = jsonEncode({
//   //       "Request": {
//   //         "Merchant": "00",
//   //         "TxnType": "P",
//   //         "AmtPurchase": 1000,
//   //         "TxnRef": "1234567890",
//   //         "CurrencyCode": "AUD",
//   //         "CutReceipt": "0",
//   //         "ReceiptAutoPrint": "0",
//   //         "Application": "00",
//   //         "PurchaseAnalysisData":
//   //         {
//   //           "OPR": "00766|test",
//   //           "AMT": "0042000",
//   //           "PCM": "0000"
//   //         },
//   //         "Basket":
//   //         {
//   //           "id": "t39kq18134553",
//   //           "amt": 2145,
//   //           "tax": 200,
//   //           "dis": 50,
//   //           "sur": 0,
//   //           "items": [{
//   //             "id": "t39kq002",
//   //             "sku": "k24086723",
//   //             "qty": 2,
//   //             "amt": 2145,
//   //             "tax": 200,
//   //             "dis": 50,
//   //             "name": "XData USB Drive"
//   //           }]
//   //         }
//   //       },
//   //     "Notification": {
//   //       "Uri": "https://v4.ozfoodz.com.au/api/pos/Linkly/$id/transaction",
//   //       "AuthorizationHeader": "Bearer $appToken"
//   //     }
//   //   });
//   //   var response = await http.post(url, headers: headers, body: body);
//   //   print('res status ${response.statusCode}');
//   //   print('res body ${response.body}');
//   //
//   //   // Process the response as needed
//   //   if (response.statusCode == 202) {
//   //     // Purchase request successful
//   //     // var responseData = jsonDecode(response.body);
//   //     Map<String, dynamic> userMap = jsonDecode(response.body);
//   //     var user = LinklyPurchaseResponseModel.fromJson(userMap);
//   //     // String rfn = responseData['PurchaseAnalysisData']['RFN'];
//   //     // Store the 'RFN' value in your POS system for future refund matching
//   //     print("rfn ${user.response!.purchaseAnalysisData!.rfn.toString()}");
//   //   } else {
//   //     // Purchase request failed
//   //     print('Purchase request failed. Status code: ${response.statusCode}');
//   //     print('Response body: ${response.body}');
//   //   }
//   // }
//
//   Future<void> sendRefundRequest(String newid, String Amount, dynamic orderId, dynamic order, BuildContext contextMain) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String appToken = prefs.getString(Constants.headerToken.toString()) ?? '';
//     // var completer = Completer<void>();
//     var id = uuid.v4();
//     var newAmount = (double.parse(Amount) * 100).toInt();
//
//     // Make a refund request using the stored 'TxnRef'
//     Future<void> makeRefundRequest(String txnRef) async {
//       var refundUrl = Uri.parse('https://rest.pos.sandbox.cloud.pceftpos.com/v1/sessions/$id/transaction?async=true');
//       var refundHeaders = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${linklyDataModel.value.data!.token.toString()}',
//         'Accept': 'application/json',
//       };
//       var refundBody = jsonEncode({
//         "Request": {
//           "Merchant": "00",
//           "TxnType": "R",
//           "AmtPurchase": newAmount.toString(),
//           "TxnRef": txnRef,
//           "CurrencyCode": "AUD",
//           "CutReceipt": "0",
//           "ReceiptAutoPrint": "0",
//           "App": "00",
//         },
//         "Notification": {
//           "Uri": "https://v4.ozfoodz.com.au/api/pos/Linkly/$id/transaction",
//           "AuthorizationHeader": "Bearer $appToken"
//         }
//       });
//       dialogTitle.value = 'Check Pin Pad';
//       dialogContent.value = 'Please follow the instructions on the pin pad';
//       try {
//         var refundResponse = await http.post(refundUrl, headers: refundHeaders, body: refundBody);
//         print('refundResponse body ${refundResponse.body}');
//         print('refundResponse status ${refundResponse.statusCode}');
//         if (refundResponse.statusCode == 202) {
//           fetchRefundDataRepeatedly(id, orderId, order, contextMain);
//         } else {
//           print('Refund request failed with status code ${refundResponse.statusCode}');
//           print('Refund request failed with body code ${refundResponse.body}');
//         }
//       } catch (e) {
//         print('Error making refund request: $e');
//       }
//     }
//
//     // Call the makeRefundRequest function with the stored 'TxnRef'
//     makeRefundRequest(newid);
//
//   }
//
//   void fetchRefundDataRepeatedly(String sessionId, dynamic orderId, dynamic order, BuildContext context)  {
//     fetchRefundData(sessionId);
//     showDialogRefundValue.value = true;
//     timer = Timer.periodic(Duration(seconds: 1), (timer) async {
//       fetchRefundData(sessionId);
//       if (linklyRefundResponseModel.value.data is DataRefundLinkly) {
//         DataRefundLinkly data = linklyRefundResponseModel.value.data;
//         print("daaaa ${data.type}");
//         if (linklyRefundResponseModel.value.success != null) {
//           if (data.request!.responseType == "display") {
//             AboveResponse aboveResponse = data.request!.response;
//             if (aboveResponse.displayText?.isNotEmpty == true &&
//                 aboveResponse.displayText![0] == 'APPROVED') {
//               print("timer cancel");
//               timer.cancel();
//               showDialogRefundValue.value = false;
//               resetVariables();
//               await _orderHistoryMainController.callCancelOrder(
//                   orderId,
//                   'Refund By Linkly',
//                   context);
//               if ((_printerController.printerModel.value
//                   .ipKitchen !=
//                   null &&
//                   _printerController.printerModel.value
//                       .ipKitchen!.isNotEmpty) &&
//                   (_printerController.printerModel.value
//                       .portKitchen !=
//                       null &&
//                       _printerController.printerModel.value
//                           .portKitchen!.isNotEmpty)) {
//                 _orderHistoryMainController.testPrintKitchen(
//                     _printerController
//                         .printerModel.value.ipKitchen!,
//                     int.parse(_printerController
//                         .printerModel.value.portKitchen
//                         .toString()),
//                     context,
//                     order,
//                     true);
//               } else {
//                 Get.snackbar("Error",
//                     "Please add kitchen printer ip and port");
//               }
//
//               return;
//             } else if (aboveResponse.displayText?.isNotEmpty == true &&
//                 aboveResponse.displayText![0] == 'TRANSACTION DECLINED'){
//               print("timer cancel");
//               timer.cancel();
//               showDialogRefundValue.value = false;
//               resetVariables();
//               Get.snackbar("Order Status", "Your request has not been approved!\nplease try again");
//             }
//
//             if(aboveResponse.displayText?.isNotEmpty == true) {
//               // Map display text values to variable values
//               dialogTitle.value =
//                   mapDisplayTextToTitle(aboveResponse.displayText?[0]);
//               dialogContent.value =
//                   mapDisplayTextToVariable(aboveResponse.displayText?[0]);
//             }
//
//             // Print the updated values
//             print('Variable 1 fetchDataRepeatedly: $dialogTitle');
//             print('Variable 2 fetchDataRepeatedly: $dialogContent');
//
//           }
//         }
//
//       }
//       print("-------------------------");
//       print(linklyRefundResponseModel.value.toJson());
//       print("-------------------------");
//     });
//   }
//
//   Future<void> fetchRefundData(String sessionId) async {
//     final url = 'https://v4.ozfoodz.com.au/api/pos/getLinklydata/$sessionId';
//     final response = await http.get(Uri.parse(url));
//     try {
//       if (response.statusCode == 200) {
//
//         // print("response fetchRefundData ${response.body}");
//         // Check if the response body is a JSON object
//         //
//         // Handle the case where success is true
//         var responseBody = jsonDecode(response.body);
//         LinklyRefundResponseModel linklyRefundModelNew = LinklyRefundResponseModel.fromJson(responseBody);
//         linklyRefundResponseModel.value = linklyRefundModelNew;
//         print("*************************");
//         print(linklyRefundModelNew.toJson());
//         print("*************************");
//
//         if (linklyRefundModelNew.data is DataRefundLinkly) {
//           DataRefundLinkly dataRefundLinkly = linklyRefundModelNew.data!;
//           if(dataRefundLinkly.request!.responseType == "display") {
//             AboveResponse aboveResponse = dataRefundLinkly.request!.response;
//             dialogTitle.value =
//                 mapDisplayTextToTitle(aboveResponse.displayText?[0]);
//             dialogContent.value = mapDisplayTextToVariable(aboveResponse.displayText?[0]);
//
//             // Print the updated values
//             print('Variable 1: $dialogTitle');
//             print('Variable 2: $dialogContent');
//             // Perform any additional logic or actions with the updated variables
//           }
//         }
//       } else {
//         print("Error: HTTP request failed with status code ${response.statusCode}");
//       }
//
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
// }
