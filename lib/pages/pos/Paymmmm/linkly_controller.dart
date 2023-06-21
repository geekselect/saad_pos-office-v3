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
    try {
      Constants.onLoading(context);
      var response = await http.post(url, headers: headers, body: body);
      print('res body ${response.body}');
      print('res status ${response.statusCode}');
      if (response.statusCode == 202) {
        Constants.hideDialog(context);
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

  RxString dialogTitle = 'Dialog Title'.obs;
  RxString dialogContent = 'Dialog Desc'.obs;

   fetchDataRepeatedly(String sessionId,
       Function(int) onApproved) {
    fetchData(sessionId);

    Future.delayed(Duration(seconds: 1), () {
      if (linklyModel.value.data != null) {
        List<String>? displayText = linklyModel.value.data!.request!.response!.displayText
            ?.map((text) => text ?? '') // Replace null values with empty strings
            .toList();
        if (displayText != null && displayText.isNotEmpty) {
          String responseText = displayText[0].toString();
          String responseType = linklyModel.value.data!.request!.responseType.toString();
          print("res text ${responseText}");

          if (responseText.isNotEmpty && responseText.toUpperCase() == 'APPROVED') {
            linklyModel.value.data!.request!.response!.displayText![0] = '';
            dialogTitle.value = 'Approved';
            dialogContent.value = 'Please take your items and receipt. Thank you for shopping with us.';
            Future.delayed(Duration(seconds: 2), (){
              onApproved(placeValue.value);
              dialogTitle.value = 'Check Pin Pad';
              dialogContent.value = 'Please follow the instructions on the pin pad';
              showDialogvalue.value = false;
            });
          } else {
            if(responseText== 'SWIPE CARD') {
              Future.delayed(Duration(seconds: 2), (){
                dialogTitle.value = 'Swipe Card';
                dialogContent.value = 'Please swipe the card';
              });
            }
            if(responseText== 'ENTER ACCOUNT') {
              dialogTitle.value = 'Enter Account Title';
              dialogContent.value = 'Please select the account title';
            }
            if(responseText== 'ENTER PIN') {
              dialogTitle.value = 'Enter Pin';
              dialogContent.value = 'Please enter the pin';
            }
            if(responseText== 'PROCESSING') {
              dialogTitle.value = 'PROCESSING';
              dialogContent.value = 'Please wait, payment finalisation is in progress';
            }
            if(responseType== 'receipt') {
              dialogTitle.value = 'PROCESSING';
              dialogContent.value = 'Please wait, payment finalisation is in progress';
            }

            fetchDataRepeatedly(sessionId, onApproved);
          }
        } else {
          fetchDataRepeatedly(sessionId, onApproved);
        }
      } else {
        dialogTitle.value = 'Check Pin Pad';
        dialogContent.value = 'Please follow the instructions on the pin pad';
        fetchDataRepeatedly(sessionId, onApproved);
      }
    });
  }

  Future<void> fetchData(String sessionId) async {
    final url = 'https://v4.ozfoodz.com.au/api/pos/getLinklydata/$sessionId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Check if the response body is a JSON object
      try {
        final responseBody = jsonDecode(response.body);
        print('response $responseBody');
        if (responseBody['success'] == true) {
          // Handle the case where success is true
          LinklyModel linklyModelNew = LinklyModel.fromJson(responseBody);
          linklyModel.value = linklyModelNew;
          showDialogvalue.value = true;

        } else {
          // Handle the case where success is false
          print("success is false");
        }
      } catch (e) {
        print("Error: Failed to parse response body");
      }
    } else {
      print("Error: HTTP request failed with status code ${response.statusCode}");
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    linklyDataApiCall();
  }
}