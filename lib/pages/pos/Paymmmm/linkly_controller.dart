import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/model/cart_master.dart';
import 'package:pos/pages/pos/Paymmmm/linkly_model.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'linkly_pair_model.dart';
import 'package:http/http.dart' as http;


class LinklyDataController extends GetxController {
  final OrderCustimizationController _orderCustimizationController =
  Get.find<OrderCustimizationController>();
  RxInt placeValue = 0.obs;
  Timer? delayedCall;
  Rx<LinklyPairModel> linklyDataModel = LinklyPairModel().obs;

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
      Constants.onLoading(context);
      Map<String, String> body = {
        'vendorId': linklyDataModel.value.data!.vendorId.toString(),
        'user_name': linklyDataModel.value.data!.userName.toString(),
        'password': linklyDataModel.value.data!.password.toString(),
        'token': linklyDataModel.value.data!.token ?? '',
        'secret_key': linklyDataModel.value.data!.secretKey ?? '',
      };
      response = await RestClient(await RetroApi().dioData()).linklyUpdate(body);
      Constants.hideDialog(context);
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
  Future<void> transactionPayment(String Amount, dynamic id,  Function(int) onApproved, BuildContext context) async {
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
        "Merchant": "00",
        "TxnType": "P",
        "AmtPurchase": newAmount.toString(),
        "TxnRef": "1234567890",
        "CurrencyCode": "AUD",
        "CutReceipt": "0",
        "ReceiptAutoPrint": "0",
        "Application": "00",
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
  RxBool showDialogvalue = false.obs;
  Timer? timer;
  void fetchDataRepeatedly(String sessionId, Function(int) onApproved) {
    print("linkly Model data ${linklyModel.value.toJson()}");
    fetchData(sessionId);
    showDialogvalue.value = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchData(sessionId);
      if (linklyModel.value.data is DataLinkly) {
        DataLinkly data = linklyModel.value.data;
        print("daaaa ${data.type}");
        if(linklyModel.value.success != null) {
  if (data.request?.response?.displayText?.isNotEmpty == true &&
      data.request!.response!.displayText![0] == 'APPROVED' ||
          data.request?.responseType == 'receipt') {
    print("timer cancel");
    timer.cancel();
    showDialogvalue.value = false;
    resetVariables();
    onApproved(placeValue.value);
    return;
  }


  // Map display text values to variable values
  dialogTitle.value =
      mapDisplayTextToTitle(data.request?.response?.displayText?[0]);
  dialogContent.value =
      mapDisplayTextToVariable(data.request?.response?.displayText?[0]);

  // Print the updated values
  print('Variable 1 fetchDataRepeatedly: $dialogTitle');
  print('Variable 2 fetchDataRepeatedly: $dialogContent');
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

        if (linklyModelNew.data is DataLinkly) {
          DataLinkly data = linklyModelNew.data!;
          dialogTitle.value = mapDisplayTextToTitle(data.request?.response?.displayText?[0]);
          dialogContent.value = mapDisplayTextToVariable(data.request?.response?.displayText?[0]);

          // Print the updated values
          print('Variable 1: $dialogTitle');
          print('Variable 2: $dialogContent');

          // Perform any additional logic or actions with the updated variables
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
}

///Old