import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/model/customer_data_model.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';

import '../retrofit/api_client.dart';

class CustomerDataController extends GetxController {
  Rx<CustomerDataModel> customerDataModel = CustomerDataModel().obs;

  Future<BaseModel<CustomerDataModel>>? customerDataApiCall(
      int vendorId, int user_id) async {
    CustomerDataModel response;
    try {
      response = await RestClient(await RetroApi().dioData())
          .customerDataCall(vendorId, user_id);
      print("data of reports ${response.toJson()}");

      customerDataModel.value = response;
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
