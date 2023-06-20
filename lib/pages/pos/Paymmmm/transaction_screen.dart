import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pos/pages/pos/Paymmmm/linkly_model.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TransactionScreen extends StatefulWidget {

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {

  TextEditingController amountController = TextEditingController();
  var uuid = Uuid();
  Future<void> transactionPayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String appToken = prefs.getString(Constants.headerToken.toString()) ?? '';
    var id = uuid.v4();
    print(token);
    print(id);
    var url = Uri.parse(
        'https://rest.pos.sandbox.cloud.pceftpos.com/v1/sessions/$id/transaction?async=true');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    var body = jsonEncode({
      "Request": {
        "Merchant": "00",
        "TxnType": "P",
        "AmtPurchase": amountController.text,
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
          "amt": amountController.text,
          "tax": 200,
          "dis": 50,
          "sur": 0,
          "items": [
            {
              "id": "t39kq002",
              "sku": "k24086723",
              "qty": 2,
              "amt": amountController.text,
              "tax": 200,
              "dis": 50,
              "name": "XData USB Drive"
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
      var response = await http.post(url, headers: headers, body: body);
      print('res body ${response.body}');
      print('res status ${response.statusCode}');
      if (response.statusCode == 202) {
        fetchDataRepeatedly(id);
      } else {
        responseMessage = 'Request failed with status: ${response.statusCode}';
        print("resp ${response.body.toString()}");
      }
    } catch (e) {
      responseMessage = 'Error: $e';
    }

    // Do something with the response message
    print(responseMessage);
  }

  Rx<LinklyModel> linklyModel = LinklyModel().obs;
  RxBool showDialogvalue = false.obs;

  RxString dialogTitle = 'Dialog Title'.obs;
  RxString dialogContent = 'Dialog Desc'.obs;

  void fetchDataRepeatedly(String sessionId) {
    fetchData(sessionId);

    Future.delayed(Duration(seconds: 2), () {
      if (linklyModel.value.data != null) {
        List<String>? displayText = linklyModel.value.data!.request!.response!.displayText
            ?.map((text) => text ?? '') // Replace null values with empty strings
            .toList();
        if (displayText != null && displayText.isNotEmpty) {
          String responseText = displayText[0].toString();
          String? responseType = linklyModel.value.data!.request!.responseType;
print("res ${responseText}");
          // if (responseType != null && responseType == 'receipt') {
          //   dialogTitle.value = 'Printing Receipt';
          //   dialogContent.value = 'Please Wait';
          //   fetchDataRepeatedly(sessionId);
          // } else
            if (responseText != null && responseText.toUpperCase() == 'APPROVED') {
            dialogTitle.value = 'Approved';
            dialogContent.value = 'Please take your items and receipt. Thank you for shopping with us.';
            Future.delayed(Duration(seconds: 3), (){
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

            fetchDataRepeatedly(sessionId);
          }
        } else {
          fetchDataRepeatedly(sessionId);
        }
      } else {
        dialogTitle.value = 'Check Pin Pad';
        dialogContent.value = 'Please follow the instructions on the pin pad';
          fetchDataRepeatedly(sessionId);

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
        if (responseBody.containsKey('success') &&
            responseBody['success'] == true) {
          // Handle the case where success is true
          LinklyModel linklyModelNew = LinklyModel.fromJson(responseBody);
          linklyModel.value = linklyModelNew;
          showDialogvalue.value = true;

          amountController.clear();
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
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(title: Text('Transaction Payment')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Stack(
          alignment: Alignment.topCenter, // Align the dialog at the top center
          children: [
            showDialogvalue.value == true && linklyModel.value.data?.request?.response?.displayText?.isNotEmpty == true
                ? AlertDialog(
              title:  Text(dialogTitle.value, style: TextStyle(
                color: Colors.black
              ),),
              content: Container(
                height: 140,
                child: Text(
                  // linklyModel.value.data!.request!.response!.displayText![0].toString() ?? '',
                    dialogContent.value,
                ),
              ),
              // actions: [
              //   ElevatedButton(
              //     onPressed: () {
              //       showDialogvalue.value = false;
              //     },
              //     child: Text('Close'),
              //   ),
              // ],
            )
                : SizedBox.shrink(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: transactionPayment,
                  child: Text('Pay'),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

//   Rx<LinklyModel> linklyModel = LinklyModel().obs;
//
//   void fetchDataRepeatedly(String sessionId) {
//     fetchData(sessionId);
//
//     Future.delayed(Duration(seconds: 3), () {
//         print("r ${linklyModel.value.success}");
//           fetchDataRepeatedly(sessionId);
//
//     });
//   }
//
// Future<void> fetchData(String sessionId) async {
//   final url = 'https://v4.ozfoodz.com.au/api/pos/getLinklydata/$sessionId';
//   final response = await http.get(Uri.parse(url));
//
//   if (response.statusCode == 200) {
//     print("response ---- ${response.body}");
//
//     // Check if the response body is a JSON object
//     try {
//       final responseBody = jsonDecode(response.body);
//         // Assuming the response has a "success" field indicating success or failure
//         if (responseBody.containsKey('success') && responseBody['success'] == true) {
//           // Handle the case where success is false
//           // final data = responseBody['data'];
//           // Parse the successful response into your model
//           LinklyModel linklyModelNew = LinklyModel.fromJson(responseBody);
//           linklyModel.value = linklyModelNew;
//           print("Linkly data ---- $linklyModelNew");
//       } else {
//         print("Error: Invalid response format");
//       }
//     } catch (e) {
//       print("Error: Failed to parse response body");
//     }
//   }
// }
///
//   Rx<LinklyModel> linklyModel = LinklyModel().obs;
//
//   void fetchDataRepeatedly(String sessionId) {
//     fetchData(sessionId);
//
//     Future.delayed(Duration(seconds: 3), () {
//       if(linklyModel.value.data != null) {
//         print("ww ${linklyModel.value.data.toString()}");
//         // if(linklyModel.value.data!.request!.response!.displayText!.first.toString() != 'Approved') {
//           fetchDataRepeatedly(sessionId);
//         // }
//       } else {
//         print("ee null");
//       }
//     });
//   }
//
//   Future<void> fetchData(String sessionId) async {
//     final url = 'https://v4.ozfoodz.com.au/api/pos/getLinklydata/$sessionId';
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       print("response ---- ${response.body}");
//
//       // Check if the response body is a JSON object
//       try {
//         final responseBody = jsonDecode(response.body);
//         // Assuming the response has a "success" field indicating success or failure
//         if (responseBody.containsKey('success') && responseBody['success'] == true) {
//           // Handle the case where success is true
//           LinklyModel linklyModelNew = LinklyModel.fromJson(responseBody);
//           linklyModel.value = linklyModelNew;
//         } else {
//           // Handle the case where success is false
//           print("success is false");
//         }
//       } catch (e) {
//         print("Error: Failed to parse response body");
//       }
//     } else {
//       print("Error: HTTP request failed with status code ${response.statusCode}");
//     }
//   }

/// perfect answer without dialog
// Rx<LinklyModel> linklyModel = LinklyModel().obs;
//
// void fetchDataRepeatedly(String sessionId) {
//   fetchData(sessionId);
//
//   Future.delayed(Duration(seconds: 1), () {
//     if (linklyModel.value.data != null) {
//       print("ww ${linklyModel.value.data!.request!.response!.displayText!.first.toString()}");
//       String responseType = linklyModel.value.data!.request!.responseType.toString();
//       if (responseType != null && responseType == 'receipt') {
//         fetchDataRepeatedly(sessionId);
//       } else {
//         String responseText = linklyModel.value.data!.request!.response!.displayText!.first.toString();
//         if (responseText != null && responseText.toUpperCase() == 'APPROVED') {
//           // The response is 'APPROVED', do not repeat the action
//           return;
//         } else {
//           fetchDataRepeatedly(sessionId);
//         }
//       }
//     } else {
//       print("ee null");
//       fetchDataRepeatedly(sessionId);
//     }
//   });
// }
//
// Future<void> fetchData(String sessionId) async {
//   final url = 'https://v4.ozfoodz.com.au/api/pos/getLinklydata/$sessionId';
//   final response = await http.get(Uri.parse(url));
//
//   if (response.statusCode == 200) {
//     print("response ---- ${response.body}");
//
//     // Check if the response body is a JSON object
//     try {
//       final responseBody = jsonDecode(response.body);
//       // Assuming the response has a "success" field indicating success or failure
//       if (responseBody.containsKey('success') && responseBody['success'] == true) {
//         // Handle the case where success is true
//         LinklyModel linklyModelNew = LinklyModel.fromJson(responseBody);
//         linklyModel.value = linklyModelNew;
//       } else {
//         // Handle the case where success is false
//         print("success is false");
//       }
//     } catch (e) {
//       print("Error: Failed to parse response body");
//     }
//   } else {
//     print("Error: HTTP request failed with status code ${response.statusCode}");
//   }
// }