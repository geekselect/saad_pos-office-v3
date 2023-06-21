import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pos/pages/pos/Paymmmm/linkly_controller.dart';
import 'package:pos/pages/pos/Paymmmm/transaction_screen.dart';
import 'package:pos/pages/pos/pos_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecretKeyScreen extends StatefulWidget {

  @override
  _SecretKeyScreenState createState() => _SecretKeyScreenState();
}

class _SecretKeyScreenState extends State<SecretKeyScreen> {
  final LinklyDataController _linklyDataController=  Get.find<LinklyDataController>();
  Future<void> GetToken() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String secretKey = prefs.getString('secret') ?? '';
    var url = Uri.parse('https://auth.sandbox.cloud.pceftpos.com/v1/tokens/cloudpos'); // Replace with the actual payment API endpoint provided by Linkly
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var body = jsonEncode({
      "secret": _linklyDataController.linklyDataModel.value.data!.secretKey ?? '',
      "posName": "OzPos",
      "posVersion": "4.6.80.17",
      "posId": "3e7f5001-58a3-43fa-9129-6e84a7b4f123",
      "posVendorId": "a256b7ec-709d-4c7d-8ffe-57cc7ca1f321"
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        _linklyDataController.linklyDataModel.value.data!.token = responseBody['token'].toString();
        _linklyDataController.calllinklyUpdate(context).then((value) {
          Get.offAll(()=> PosMenu(isDining: false));
        });
      } else {
        print("status code not same");
      }
    } catch (e) {
      print("server error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ON INIT ${_linklyDataController.linklyDataModel.value.toJson()}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Secret Payment')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: GetToken,
              child: Text('Get Token'),
            ),
          ],
        ),
      ),
    );
  }
}