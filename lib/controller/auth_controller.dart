import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/model/check_otp_model_for_forgot_password.dart';
import 'package:pos/model/common_msg_model.dart';
import 'package:pos/model/login_model.dart';
import 'package:pos/model/vendor/vendor.dart';
import 'package:pos/pages/pos/pos_menu.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../pages/order/OrdersScreen.dart';
import 'order_controller.dart';

class AuthController extends GetxController {
  static SharedPreferences? sharedPreferences;
  final OrderCustimizationController _orderCustimizationController =
      Get.find<OrderCustimizationController>();
  Future<void> callUserLogin(
      String email, String password, BuildContext context) async {
    LoginModel loginModel;
    try {
      Constants.onLoading(context);
      Map<String, String> body = {
        'email_id': email,
        'password': password,
        'provider': 'LOCAL',
        'vendor_id': Constants.vendorId.toString(),
        'device_token': '',
      };
      print(body);
      Uri loginLink = Uri.parse('${Constants.baseLink}/pos/user_login');
      print(loginLink);
      var response = await http.post(loginLink, body: body);
      print(response.body);
      if (response.statusCode == 200) {
        loginModel = LoginModel.fromJson(jsonDecode(response.body));
        Constants.hideDialog(context);
        if (loginModel.success!) {
          Constants.toastMessage('Login Successfully');
          sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences?.setString(
              Constants.headerToken, loginModel.data!.token!);
          sharedPreferences?.setString(
              Constants.loginUserId, loginModel.data!.id!.toString());

          sharedPreferences?.setBool(Constants.isLoggedIn, true);
          AuthController.sharedPreferences = sharedPreferences;
          //Constants.onLoading(context);
          // await _orderCustimizationController.callGetRestaurantsDetails(Constants.vendorId);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PosMenu(
                      isDining: false,
                    )),
          );
          AuthController.sharedPreferences?.setString(
              Constants.loginUserId, loginModel.data!.id.toString());
        } else {
          Constants.toastMessage(jsonDecode(response.body)['message']);
        }
      } else {
        print(jsonDecode(response.body));
        CommonMsgModel commonMsgModel =
            CommonMsgModel.fromJson(jsonDecode(response.body));

        if (!commonMsgModel.success!) {
          Get.snackbar('ALERT', commonMsgModel.message!);
        }
        Constants.hideDialog(context);
      }
    } catch (error, stacktrace) {
      Constants.hideDialog(context);
      print("Exception occurred: $error stackTrace: $stacktrace");
    }
  }

  Future<void> callVendorLogin(
      String email, String password, BuildContext context) async {
    try {
      Constants.onLoading(context);
      Uri loginLink = Uri.parse('${Constants.vendorBaseLink}login');
      var response = await http.post(
        loginLink,
        body: {
          'email_id': email,
          'password': password,
          'deviceToken': '',
        },
      );
      // print(response.statusCode);
      if (response.statusCode == 200) {
        Vendor vendor = Vendor.fromJson(jsonDecode(response.body));
        print(vendor.toJson());
        sharedPreferences = await SharedPreferences.getInstance();
        AuthController.sharedPreferences = sharedPreferences;
        sharedPreferences?.setString(
            Constants.vendorBearerToken, vendor.data!.token!);
        sharedPreferences!.setString(Constants.vendorName, vendor.data!.name!);
        sharedPreferences?.setBool(Constants.isKitchenLoggedIn, true);

        OrderController orderController = Get.find<OrderController>();
        Constants.hideDialog(context);
        await orderController.getOrders('NewOrders');
        Get.to(() => OrderScreen(title: 'Kitchen', apiName: 'NewOrders'));
        // Get.to()
      } else {
        CommonMsgModel commonMsgModel =
            CommonMsgModel.fromJson(jsonDecode(response.body));
        if (!commonMsgModel.success!) {
          Get.snackbar('ALERT', commonMsgModel.message!);
        }
        Constants.hideDialog(context);
      }
    } on Exception catch (e, stk) {
      print(e);
      print(stk);
    }
  }
}
