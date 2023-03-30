import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/model/common_res.dart';
import 'package:pos/printer/printer_model.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';

class PrinterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  TextEditingController posIpEditingController = TextEditingController();
  TextEditingController posPortEditingController = TextEditingController();
  TextEditingController kitchenIpEditingController = TextEditingController();
  TextEditingController kitchenPortEditingController = TextEditingController();
  // RxString printerIp = ''.obs;
  // RxString printerPort = ''.obs;
  // RxString kitchenIp = ''.obs;
  // RxString kitchenPort = ''.obs;

  var printerModel = PrinterModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getPrinterDetails(Constants.vendorId);
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

  Future<BaseModel<PrinterModel>> getPrinterDetails(int? vendorId) async {
    PrinterModel response;
    try {
      response = await RestClient(await RetroApi().dioData(),
              baseUrl: "https://v3.ozfoodz.com.au/api/")
          .printerData(
        vendorId,
      );
      printerModel.value = response;
      posIpEditingController.text = printerModel.value.ipPos ?? '';
      kitchenIpEditingController.text = printerModel.value.ipKitchen ?? '';
      posPortEditingController.text = printerModel.value.portPos ?? '';
      kitchenPortEditingController.text = printerModel.value.portKitchen ?? '';
      print("response printer ${response.toJson()}");
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
      response = await RestClient(await RetroApi().dioData(),
              baseUrl: "https://v3.ozfoodz.com.au/api/")
          .updatePrinterData(body, id);
      print("response printer ${response.toJson()}");
    } catch (error, stacktrace) {
      print("Exception occurred printer: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
