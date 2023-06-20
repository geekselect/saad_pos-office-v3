import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/pages/pos/Paymmmm/linkly_controller.dart';
import 'package:pos/pages/pos/Paymmmm/pay_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePayPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePayPage> {
  final LinklyDataController _linklyDataController=  Get.find<LinklyDataController>();
  TextEditingController pairCodeController = TextEditingController();

  Future<void> connectLinkly() async {
    var url = Uri.parse('https://auth.sandbox.cloud.pceftpos.com/v1/pairing/cloudpos');
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var body = jsonEncode({
      "username": _linklyDataController.linklyDataModel.value.data!.userName ?? '',
      "password": _linklyDataController.linklyDataModel.value.data!.password ?? '',
      // "username": '53400785001',
      // "password": 'Y96LBF4NP52MLVX3',
      "paircode": pairCodeController.text,
    });
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      var response = await http.post(url, headers: headers, body: body);
      print("response status ${response.statusCode}");
      print("response ${response.body}");
      if (response.statusCode == 200) {
        // var responseBody = jsonDecode(response.body);
        // var Secret = SecretModel.fromJson(responseBody);
        // sharedPreferences.setString('secret', Secret.secret.toString());
        Get.to(()=> SecretKeyScreen());
      } else {
        print("status code not same");
      }
    } catch (e) {
      print("server error $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Linkly Connection'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Username')),
            // TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password')),
            TextField(controller: pairCodeController, decoration: InputDecoration(labelText: 'Pair Code')),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: connectLinkly,
              child: Text('Connect Linkly'),
            ),
          ],
        ),
      ),
    );
  }
}




SecretModel secretModelFromJson(String str) => SecretModel.fromJson(json.decode(str));

String secretModelToJson(SecretModel data) => json.encode(data.toJson());

class SecretModel {
  String secret;

  SecretModel({
    required this.secret,
  }
      );

  factory SecretModel.fromJson(Map<String, dynamic> json) => SecretModel(
    secret: json["secret"],
  );

  Map<String, dynamic> toJson() => {
    "secret": secret,
  };
}