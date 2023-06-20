// import 'package:flutter/material.dart';
// import 'package:pos/pages/pos/Paymmmm/home_pay.dart';
// import 'package:pos/pages/pos/Paymmmm/pay_screen.dart';
// import 'package:pos/pages/pos/Paymmmm/transaction_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class MyAppPay extends StatefulWidget {
//
//
//   @override
//   State<MyAppPay> createState() => _MyAppPayState();
// }
//
// class _MyAppPayState extends State<MyAppPay> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     // Check if the first value is empty
//     SharedPreferences.getInstance().then((prefs) {
//       String secretKey = prefs.getString('secret') ?? '';
//       String token = prefs.getString('token') ?? '';
//
//       if (secretKey.isEmpty) {
//         // Go to the first screen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomePayPage()),
//         );
//       } else if (secretKey.isNotEmpty && token.isEmpty) {
//         // Go to the second screen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => SecretKeyScreen()),
//         );
//       } else {
//         // Go to the third screen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => TransactionScreen()),
//         );
//       }
//     });
//
//     return Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//
//   }
// }