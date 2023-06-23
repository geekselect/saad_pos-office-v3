import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/pages/pos/Paymmmm/linkly_controller.dart';
import 'package:pos/pages/pos/Paymmmm/pay_screen.dart';
import 'package:pos/pages/pos/pos_menu.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePayPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePayPage> {

  @override
  void initState() {
    // TODO: implement initState
    usernameController.text = _linklyDataController.linklyDataModel.value.data!.userName ?? '';
    passwordController.text = _linklyDataController.linklyDataModel.value.data!.password ?? '';
    super.initState();
  }
  final LinklyDataController _linklyDataController=  Get.find<LinklyDataController>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController pairCodeController = TextEditingController();

  Future<void> connectLinkly(BuildContext context) async {
    var url = Uri.parse('https://auth.sandbox.cloud.pceftpos.com/v1/pairing/cloudpos');
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var body = jsonEncode({
      "username": _linklyDataController.linklyDataModel.value.data!.userName ?? '',
      "password": _linklyDataController.linklyDataModel.value.data!.password ?? '',
      "paircode": pairCodeController.text,
    });
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Constants.onLoading(context);
    try {
      var response = await http.post(url, headers: headers, body: body);
      print("response status ${response.statusCode}");
      print("response ${response.body}");
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var Secret = SecretModel.fromJson(responseBody);
        _linklyDataController.linklyDataModel.value.data!.secretKey = Secret.secret.toString();
        GetToken( Secret.secret.toString()).then((value) {
          Constants.hideDialog(context);
        });
      } else {
        print("status code not same");
      }
    } catch (e) {
      print("server error $e");
    }
  }

  Future<void> GetToken(String secretKey) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String secretKey = prefs.getString('secret') ?? '';
    var url = Uri.parse('https://auth.sandbox.cloud.pceftpos.com/v1/tokens/cloudpos'); // Replace with the actual payment API endpoint provided by Linkly
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var body = jsonEncode({
      "secret": secretKey,
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
          usernameController.clear();
          passwordController.clear();
          pairCodeController.clear();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Linkly Connection'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Terminal Pairing', style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),),
                  SizedBox(height: 2.0),
                  Text('Enter Linkly Cloud Details for this POS', style: TextStyle(
                    fontSize: 18,
                  ),)
                ],
              ),
              SizedBox(height: 24.0),
              TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Username')),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password')),
              TextField(controller: pairCodeController, decoration: InputDecoration(labelText: 'Pair Code')),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: (){
                  connectLinkly(context);},
                child: Text('Pair'),
              ),
            ],
          ),
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


