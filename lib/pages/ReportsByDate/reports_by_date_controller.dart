import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/model/reports_by_date_model.dart';
import 'package:pos/model/single_restaurants_details_model.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/base_model.dart';

class ReportByDateController extends GetxController {
  Future<BaseModel<SingleRestaurantsDetailsModel>>? callGetResturantDetailsRef;
  final OrderCustimizationController _orderCustimizationController =
  Get.find<OrderCustimizationController>();
  Rx<Order> reportModelOrderData = Order().obs;
  Rx<ReportByDateModel> reportByDateModelData = ReportByDateModel().obs;
  RxBool startDateSelect = false.obs;
  RxBool endDateSelect = false.obs;
  Rx<String> startDate = ''.obs;
  Rx<String> endDate = ''.obs;
  String? posIp;
  int? posPort;


  void onStartDateSelected(DateTime date) {
    final startDateStr = DateFormat('yyyy-MM-dd').format(date);
    startDate.value = startDateStr;
  }

  void onEndDateSelected(DateTime date) {
    final endDateStr = DateFormat('yyyy-MM-dd').format(date);
    endDate.value = endDateStr;
  }
  final box = GetStorage();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    startDateSelect = false.obs;
    endDateSelect = false.obs;
    posIp = box.read(Constants.posIp);
    posPort = box.read(Constants.posPort);
    // callGetResturantDetailsRef = _orderCustimizationController
    //     .callGetRestaurantsDetails();
  }

  Future<BaseModel<ReportByDateModel>>? reportsApiByDateCall() async {
    final prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    String userId = prefs.getString(Constants.loginUserId.toString()) ?? '';
    Map<String, dynamic> body = {
      "dateRangeStart": startDate.value,
      "dateRangeEnd": endDate.value,
      "vendor_id": vendorId,
      "user_id": userId,
    };
    ReportByDateModel response;
    try {
      response = await RestClient(await RetroApi().dioData()).reportsApiByDate(body);
      print("data of reports ${response.toJson()}");

      reportByDateModelData.value = response;
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  void testPrintPOS(
      String printerIp,
      int port,
      BuildContext ctx,
      ) async {
    // TODO Don't forget to choose printer's paper size
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final PosPrintResult res = await printer.connect(
      printerIp,
      port: port,
    );

    print('Print result: ${res.msg}');
    Get.snackbar("", res.msg);

    if (res == PosPrintResult.success) {
      // DEMO RECEIPT
      BaseModel<SingleRestaurantsDetailsModel>? restaurantDetails =
      await callGetResturantDetailsRef;
      if (restaurantDetails != null) {
        var newDate = DateFormat('hh:mm a').format(DateTime.now());
        var date = DateTime.parse(DateTime.now().toString());
        var formattedDate = "${date.day}-${date.month}-${date.year} ${newDate}";
        print("date ${formattedDate}");
        // printPOSReceipt(printer, restaurantDetails, formattedDate);
        print(
            'restaurant details  ${restaurantDetails.data!.data!.vendor!.name}');
      } else {
        print('Failed to fetch restaurant details');
      }
      printer.disconnect();
    }
  }

  // printPOSReceipt(
  //     NetworkPrinter printer,
  //     BaseModel<SingleRestaurantsDetailsModel>? restaurantDetails,
  //     String date) {
  //   // // Print image
  //   // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
  //   // final Uint8List bytes = data.buffer.asUint8List();
  //   // final img.Image? image = img.decodeImage(bytes);
  //   // printer.image(image!);
  //   printer.text(restaurantDetails!.data!.data!.vendor!.name,
  //       styles: PosStyles(
  //         align: PosAlign.center,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ),
  //       linesAfter: 1);
  //
  //   printer.text("${date}", styles: PosStyles(align: PosAlign.left));
  //   // printer.text('New Braunfels, TX',
  //   //     styles: PosStyles(align: PosAlign.center));
  //
  //   // printer.text(
  //   //     "Phone : ${restaurantDetails.data!.data!.vendor!.contact.toString()}",
  //   //     styles: PosStyles(align: PosAlign.left));
  //
  //   // printer.text('Web: www.example.com',
  //   //     styles: PosStyles(align: PosAlign.center), linesAfter: 1);
  //   printer.hr();
  //   printer.row([
  //     PosColumn(text: 'Sold Item Names', width: 7),
  //     PosColumn(
  //         text: 'Total Quantity',
  //         width: 5,
  //         styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   for (int index = 0; index < reportModelData.value.orders!.length; index++) {
  //     Order reportDetailOrderModel = reportModelData.value.orders![index];
  //     printer.row([
  //       PosColumn(text: reportDetailOrderModel.itemName.toString(), width: 10),
  //       PosColumn(
  //           text: reportDetailOrderModel.quantity.toString(),
  //           width: 2,
  //           styles: PosStyles(align: PosAlign.right)),
  //     ]);
  //   }
  //
  //   printer.hr(ch: '=', linesAfter: 1);
  //   printer.row([
  //     PosColumn(text: 'User Name', width: 3),
  //     PosColumn(
  //         text: 'Type', width: 6, styles: PosStyles(align: PosAlign.center)),
  //     PosColumn(
  //         text: 'Amount', width: 3, styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   // for (int index = 0;
  //   //     index < reportModelData.value.payments!.posCash!.name!.length;
  //   //     index++) {
  //   // Payments reportDetailModel = reportModelData.value.payments!.posCash.name;
  //   printer.row([
  //     PosColumn(
  //         text: reportModelData.value.payments!.posCash!.name!.toString(),
  //         width: 4),
  //     PosColumn(
  //         text: "Pos Cash Amount",
  //         width: 5,
  //         styles: PosStyles(align: PosAlign.center)),
  //     PosColumn(
  //         text:
  //         "${reportModelData.value.payments!.posCash!.amount!.toString()}",
  //         width: 3,
  //         styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   // }
  //   // for (int index = 0;
  //   //     index < reportModelData.value.payments!.posCard!.name!.length;
  //   //     index++) {
  //   // ReportDetailModel reportDetailModel = posCashdata.value.data!;
  //   printer.row([
  //     PosColumn(
  //         text: reportModelData.value.payments!.posCard!.name!.toString(),
  //         width: 4),
  //     PosColumn(
  //         text: "Pos Card Amount",
  //         width: 5,
  //         styles: PosStyles(align: PosAlign.center)),
  //     PosColumn(
  //         text:
  //         "${reportModelData.value.payments!.posCard!.amount!.toString()}",
  //         width: 3,
  //         styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   // }
  //
  //   ///For Pos cash and pos card
  //   // for (int index = 0; index < posCashdata.value.data!.names!.length; index++) {
  //   //   ReportDetailModel reportDetailModel = posCashdata.value.data!;
  //   //   printer.row([
  //   //     PosColumn(text: reportDetailModel.names![0].toString(), width: 4),
  //   //     PosColumn(
  //   //         text: "Pos Cash Amount : ${reportDetailModel.amount![0].toString()}",
  //   //         width: 8,
  //   //         styles: PosStyles(align: PosAlign.right)),
  //   //   ]);
  //   // }
  //   // for (int index = 0; index < posCarddata.value.data!.names!.length; index++) {
  //   //   ReportDetailModel reportDetailModel = posCarddata.value.data!;
  //   //   printer.row([
  //   //     PosColumn(text: reportDetailModel.names![0].toString(), width: 4),
  //   //     PosColumn(
  //   //         text: "Pos Card Amount : ${reportDetailModel.amount![0].toString()}",
  //   //         width: 8,
  //   //         styles: PosStyles(align: PosAlign.right)),
  //   //   ]);
  //   // }
  //   ///End
  //
  //   printer.hr(ch: '=', linesAfter: 1);
  //
  //   printer.row([
  //     PosColumn(text: 'Todays Total Order', width: 8),
  //     PosColumn(
  //         text: reportModelData.value.totalOrders.toString(),
  //         width: 4,
  //         styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   printer.row([
  //     PosColumn(text: 'Todays Total Takeaway', width: 8),
  //     PosColumn(
  //         text: reportModelData.value.totalTakeaway.toString(),
  //         width: 4,
  //         styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   printer.row([
  //     PosColumn(text: 'Todays Total Dining', width: 8),
  //     PosColumn(
  //         text: reportModelData.value.totalDining.toString(),
  //         width: 4,
  //         styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   printer.row([
  //     PosColumn(text: 'Todays Total Discounts', width: 8),
  //     PosColumn(
  //         text: reportModelData.value.totalDiscounts!.toStringAsFixed(2),
  //         width: 4,
  //         styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //
  //   printer.hr(ch: '=', linesAfter: 1);
  //
  //   printer.feed(2);
  //   printer.text('Thank you!',
  //       styles: PosStyles(align: PosAlign.center, bold: true));
  //
  //   printer.feed(1);
  //   printer.cut();
  //   printer.beep();
  // }
}