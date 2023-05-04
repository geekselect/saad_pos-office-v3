import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/model/customer_data_model.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../retrofit/api_client.dart';

class CustomerDataController extends GetxController {
  Rx<CustomerDataModel> customerDataModel = CustomerDataModel().obs;

  Future<BaseModel<CustomerDataModel>>? customerDataApiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.get(Constants.loginUserId);
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    CustomerDataModel response;
    try {
      response = await RestClient(await RetroApi().dioData())
          .customerDataCall(int.parse(vendorId.toString()), int.parse(id.toString()));
      print("data of reports ${response.toJson()}");

      customerDataModel.value = response;
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
