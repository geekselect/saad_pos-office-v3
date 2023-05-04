import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pos/controller/auth_controller.dart';
import 'package:pos/model/vendor/common_response.dart';
import 'package:pos/model/vendor/orders_response.dart' as order;
import 'package:pos/pages/order/OrdersScreen.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class OrderController extends GetxController {
  RxList<order.Data> orderList = <order.Data>[].obs;

  Future<void> getOrders(String apiName) async {
    final prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    try {
      order.OrdersResponse ordersResponse;
      Uri orderLink = Uri.parse('${Constants.vendorBaseLink}order/$apiName/${int.parse(vendorId.toString())}');
      print('get order link');
      print(orderLink);
      var response = await http.get(
        orderLink,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${(await SharedPreferences.getInstance()).getString(Constants.vendorBearerToken)}',
        },
      );

      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        ordersResponse = order.OrdersResponse.fromJson(jsonDecode(response.body));
        orderList.value = ordersResponse.data!;
      }
    } on Exception catch (e, stk) {
      print(e);
      print(stk);
    }
  }

  Future<BaseModel<CommonResponse>> changeOrderStatus(
      Map<String, String?> param) async {
    CommonResponse commonResponse;
    try {

      Uri changeOrderLink = Uri.parse(
          '${Constants.vendorBaseLink}change_status');

      print(AuthController.sharedPreferences!.getString(
          Constants.vendorBearerToken));
      print('aaaaaaaaaaa');
      var response = await http.post(
        changeOrderLink,
        body: param,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${
              AuthController.sharedPreferences!.getString(
                  Constants.vendorBearerToken)
          }',
        },
      );
      print(response.body);
      commonResponse = CommonResponse.fromJson(jsonDecode(response.body));
      Constants.toastMessage(commonResponse.data.toString());
    } catch (error, stacktrace) {
      print('catch error on status change');
      print('Exception occurred: $error stackTrace: $stacktrace');

      return BaseModel()
        ..setException(ServerError.withError(error: error));
    }
    return BaseModel()
      ..data = commonResponse;
  }
}