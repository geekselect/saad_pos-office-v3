// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:pos/pages/pos/Paymmmm/linkly_controller.dart';
// import 'package:pos/pages/pos/Paymmmm/transaction_screen.dart';
// import 'package:pos/pages/pos/pos_menu.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SecretKeyScreen extends StatefulWidget {
//
//   @override
//   _SecretKeyScreenState createState() => _SecretKeyScreenState();
// }
//
// class _SecretKeyScreenState extends State<SecretKeyScreen> {
//   final LinklyDataController _linklyDataController=  Get.find<LinklyDataController>();
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print("ON INIT ${_linklyDataController.linklyDataModel.value.toJson()}");
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Secret Payment')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton(
//               onPressed: GetToken,
//               child: Text('Get Token'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }