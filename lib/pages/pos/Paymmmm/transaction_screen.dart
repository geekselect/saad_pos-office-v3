// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pos/pages/pos/Paymmmm/linkly_model.dart';
// import 'package:pos/utils/constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
//
// class TransactionScreen extends StatefulWidget {
//
//   @override
//   _TransactionScreenState createState() => _TransactionScreenState();
// }
//
// class _TransactionScreenState extends State<TransactionScreen> {
//
//   TextEditingController amountController = TextEditingController();
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Scaffold(
//       appBar: AppBar(title: Text('Transaction Payment')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Stack(
//           alignment: Alignment.topCenter, // Align the dialog at the top center
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextField(
//                   controller: amountController,
//                   decoration: InputDecoration(labelText: 'Amount'),
//                 ),
//                 SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: transactionPayment,
//                   child: Text('Pay'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }
//
// //   Rx<LinklyModel> linklyModel = LinklyModel().obs;
// //
// //   void fetchDataRepeatedly(String sessionId) {
// //     fetchData(sessionId);
// //
// //     Future.delayed(Duration(seconds: 3), () {
// //         print("r ${linklyModel.value.success}");
// //           fetchDataRepeatedly(sessionId);
// //
// //     });
// //   }
// //
// // Future<void> fetchData(String sessionId) async {
// //   final url = 'https://v4.ozfoodz.com.au/api/pos/getLinklydata/$sessionId';
// //   final response = await http.get(Uri.parse(url));
// //
// //   if (response.statusCode == 200) {
// //     print("response ---- ${response.body}");
// //
// //     // Check if the response body is a JSON object
// //     try {
// //       final responseBody = jsonDecode(response.body);
// //         // Assuming the response has a "success" field indicating success or failure
// //         if (responseBody.containsKey('success') && responseBody['success'] == true) {
// //           // Handle the case where success is false
// //           // final data = responseBody['data'];
// //           // Parse the successful response into your model
// //           LinklyModel linklyModelNew = LinklyModel.fromJson(responseBody);
// //           linklyModel.value = linklyModelNew;
// //           print("Linkly data ---- $linklyModelNew");
// //       } else {
// //         print("Error: Invalid response format");
// //       }
// //     } catch (e) {
// //       print("Error: Failed to parse response body");
// //     }
// //   }
// // }
// ///
// //   Rx<LinklyModel> linklyModel = LinklyModel().obs;
// //
// //   void fetchDataRepeatedly(String sessionId) {
// //     fetchData(sessionId);
// //
// //     Future.delayed(Duration(seconds: 3), () {
// //       if(linklyModel.value.data != null) {
// //         print("ww ${linklyModel.value.data.toString()}");
// //         // if(linklyModel.value.data!.request!.response!.displayText!.first.toString() != 'Approved') {
// //           fetchDataRepeatedly(sessionId);
// //         // }
// //       } else {
// //         print("ee null");
// //       }
// //     });
// //   }
// //
// //   Future<void> fetchData(String sessionId) async {
// //     final url = 'https://v4.ozfoodz.com.au/api/pos/getLinklydata/$sessionId';
// //     final response = await http.get(Uri.parse(url));
// //
// //     if (response.statusCode == 200) {
// //       print("response ---- ${response.body}");
// //
// //       // Check if the response body is a JSON object
// //       try {
// //         final responseBody = jsonDecode(response.body);
// //         // Assuming the response has a "success" field indicating success or failure
// //         if (responseBody.containsKey('success') && responseBody['success'] == true) {
// //           // Handle the case where success is true
// //           LinklyModel linklyModelNew = LinklyModel.fromJson(responseBody);
// //           linklyModel.value = linklyModelNew;
// //         } else {
// //           // Handle the case where success is false
// //           print("success is false");
// //         }
// //       } catch (e) {
// //         print("Error: Failed to parse response body");
// //       }
// //     } else {
// //       print("Error: HTTP request failed with status code ${response.statusCode}");
// //     }
// //   }
//
// /// perfect answer without dialog
// // Rx<LinklyModel> linklyModel = LinklyModel().obs;
// //
// // void fetchDataRepeatedly(String sessionId) {
// //   fetchData(sessionId);
// //
// //   Future.delayed(Duration(seconds: 1), () {
// //     if (linklyModel.value.data != null) {
// //       print("ww ${linklyModel.value.data!.request!.response!.displayText!.first.toString()}");
// //       String responseType = linklyModel.value.data!.request!.responseType.toString();
// //       if (responseType != null && responseType == 'receipt') {
// //         fetchDataRepeatedly(sessionId);
// //       } else {
// //         String responseText = linklyModel.value.data!.request!.response!.displayText!.first.toString();
// //         if (responseText != null && responseText.toUpperCase() == 'APPROVED') {
// //           // The response is 'APPROVED', do not repeat the action
// //           return;
// //         } else {
// //           fetchDataRepeatedly(sessionId);
// //         }
// //       }
// //     } else {
// //       print("ee null");
// //       fetchDataRepeatedly(sessionId);
// //     }
// //   });
// // }
// //
// // Future<void> fetchData(String sessionId) async {
// //   final url = 'https://v4.ozfoodz.com.au/api/pos/getLinklydata/$sessionId';
// //   final response = await http.get(Uri.parse(url));
// //
// //   if (response.statusCode == 200) {
// //     print("response ---- ${response.body}");
// //
// //     // Check if the response body is a JSON object
// //     try {
// //       final responseBody = jsonDecode(response.body);
// //       // Assuming the response has a "success" field indicating success or failure
// //       if (responseBody.containsKey('success') && responseBody['success'] == true) {
// //         // Handle the case where success is true
// //         LinklyModel linklyModelNew = LinklyModel.fromJson(responseBody);
// //         linklyModel.value = linklyModelNew;
// //       } else {
// //         // Handle the case where success is false
// //         print("success is false");
// //       }
// //     } catch (e) {
// //       print("Error: Failed to parse response body");
// //     }
// //   } else {
// //     print("Error: HTTP request failed with status code ${response.statusCode}");
// //   }
// // }