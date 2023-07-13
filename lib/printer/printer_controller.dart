import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/model/common_res.dart';
import 'package:pos/printer/printer_model.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  TextEditingController posIpEditingController = TextEditingController();
  TextEditingController posPortEditingController = TextEditingController();
  TextEditingController kitchenIpEditingController = TextEditingController();
  TextEditingController kitchenPortEditingController = TextEditingController();

  var printerModel = PrinterModel().obs;

  @override
  void onInit() {
    super.onInit();
    getPrinterDetails();
  }

  // Future callGetRestaurantsDetails(int? vendorId) async {
  //   var response;
  //   try {
  //     response = await RestClient(await RetroApi().dioData(),
  //             baseUrl: "https://v3.ozfoodz.com.au/api/")
  //         .printerData(
  //       vendorId,
  //     );
  //     print("response printer ${response}");
  //   } catch (error, stacktrace) {
  //     print("Exception occurred printer: $error stackTrace: $stacktrace");
  //     return BaseModel()..setException(ServerError.withError(error: error));
  //   }
  //   return BaseModel()..data = response;
  // }

  Future<BaseModel<PrinterModel>> getPrinterDetails() async {
    PrinterModel response;
    final prefs = await SharedPreferences.getInstance();

    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    try {
      response = await RestClient(await RetroApi().dioData()).printerData(
        int.parse(vendorId.toString()),
      );
      print("VVVV");
      printerModel.value = response;
      posIpEditingController.text = printerModel.value.ipPos ?? '';
      kitchenIpEditingController.text = printerModel.value.ipKitchen ?? '';
      posPortEditingController.text = printerModel.value.portPos ?? '';
      kitchenPortEditingController.text = printerModel.value.portKitchen ?? '';
    } catch (error, stacktrace) {
      print("Exception occurred printer: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<CommenRes>> updatePrinterDetails(int id) async {
    CommenRes response;

    Map<String, dynamic> body = {
      "IP_POS": posIpEditingController.text,
      "port_pos": posPortEditingController.text,
      "IP_Kitchen": kitchenIpEditingController.text,
      "port_kitchen": kitchenPortEditingController.text,
    };
    try {
      response = await RestClient(await RetroApi().dioData())
          .updatePrinterData(body, id);
      printerModel.value = PrinterModel(
        ipPos: posIpEditingController.text,
        ipKitchen: kitchenIpEditingController.text,
        portKitchen: kitchenPortEditingController.text,
        portPos: posPortEditingController.text,
        autoStatusKitchen: null,
        autoStatusPos: ''
      );
    } catch (error, stacktrace) {
      print("Exception occurred printer: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
