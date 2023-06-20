import 'package:get/get.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/model/cart_master.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'linkly_pair_model.dart';

class LinklyDataController extends GetxController {
  final OrderCustimizationController _orderCustimizationController =
  Get.find<OrderCustimizationController>();
  Rx<LinklyPairModel> linklyDataModel = LinklyPairModel().obs;

  Future<BaseModel<LinklyPairModel>>? linklyDataApiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    LinklyPairModel response;
    try {
      response = await RestClient(await RetroApi().dioData())
          .linklyGet(int.parse(vendorId.toString()));
      print("data of modifiers ${response.toJson()}");

      linklyDataModel.value = response;
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    linklyDataApiCall();
  }
}