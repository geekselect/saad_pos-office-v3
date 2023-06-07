import 'package:get/get.dart';
import 'package:pos/model/cart_master.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModifierDataController extends GetxController {
  Rx<ModifierModel> modifierDataModel = ModifierModel().obs;

  Future<BaseModel<ModifierModel>>? modifierDataApiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    ModifierModel response;
    try {
      response = await RestClient(await RetroApi().dioData())
          .modifiers(int.parse(vendorId.toString()));
      print("data of modifiers ${response.toJson()}");

      modifierDataModel.value = response;
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}