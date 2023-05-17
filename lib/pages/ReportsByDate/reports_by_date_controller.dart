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

import '../../retrofit/base_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


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
  RxBool isValue = false.obs;

  RxString selectedDate = ''.obs;

  RxString dateCount = ''.obs;

  RxString range = ''.obs;

  RxString rangeCount = ''.obs;

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {

      if (args.value is PickerDateRange) {
        startDate.value = DateFormat('yyyy-MM-dd').format(args.value.startDate);
        endDate.value = DateFormat('yyyy-MM-dd').format(
            args.value.endDate ?? args.value.startDate);
        range.value =
        '${DateFormat('yyyy-MM-dd').format(args.value.startDate)} -'
            ' ${DateFormat('yyyy-MM-dd').format(
            args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        selectedDate.value = args.value.toString();
      } else if (args.value is List<DateTime>) {
        dateCount.value = args.value.length.toString();
      } else {
        rangeCount.value = args.value.length.toString();
      }
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
    callGetResturantDetailsRef = _orderCustimizationController
        .callGetRestaurantsDetails();
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
      bool value
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

        printPOSReceipt(printer, restaurantDetails, value);
        print(
            'restaurant details  ${restaurantDetails.data!.data!.vendor!.name}');
      } else {
        print('Failed to fetch restaurant details');
      }
      printer.disconnect();
    }
  }

  printPOSReceipt(
      NetworkPrinter printer,
      BaseModel<SingleRestaurantsDetailsModel>? restaurantDetails,
      bool value
      ) {
    printer.text(restaurantDetails!.data!.data!.vendor!.name,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    printer.text("From ${DateFormat('yyyy-MM-dd').format(reportByDateModelData.value.from!)} to ${DateFormat('yyyy-MM-dd').format(reportByDateModelData.value.to!)}", styles: PosStyles(align: PosAlign.left));
    printer.hr();
    for (int index = 0; index < reportByDateModelData.value.data!.length; index++) {
      Datum datum = reportByDateModelData.value.data![index];
      printer.text("${DateFormat('yyyy-MM-dd').format(datum.date!)}", styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),);
      datum.posCash!.name != null ?  printer.row([
        PosColumn(text: "${datum.posCash!.name!} (Pos Cash)" , width: 10),
        PosColumn(
            text: double.parse(datum.posCash!.amount.toString()).toStringAsFixed(2),
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]) : printer.row([
        PosColumn(text: "No Name" , width: 10),
        PosColumn(
            text: double.parse(datum.posCash!.amount.toString()).toStringAsFixed(2),
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      datum.posCard!.name != null ?  printer.row([
        PosColumn(text: "${datum.posCard!.name!} (Pos Card)" , width: 10),
        PosColumn(
            text: double.parse(datum.posCard!.amount.toString()).toStringAsFixed(2),
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]) : printer.row([
        PosColumn(text: "No Name" , width: 10),
        PosColumn(
            text: double.parse(datum.posCard!.amount.toString()).toStringAsFixed(2),
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      printer.row([
        PosColumn(text: "Total TakeAway" , width: 10),
        PosColumn(
            text: datum.orderPlaced!.totalTakeaway.toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      printer.row([
        PosColumn(text: "Total Dining" , width: 10),
        PosColumn(
            text: datum.orderPlaced!.totalTotalDining.toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      printer.row([
        PosColumn(text: "Total Discounts" , width: 10),
        PosColumn(
            text: datum.orderPlaced!.totalTotalDiscounts.toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      printer.row([
        PosColumn(text: "Total Orders" , width: 10),
        PosColumn(
            text: datum.orderPlaced!.totalOrders.toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      if (value == true) { printer.text('\n');}
      if (value == true) {  printer.row([
        PosColumn(text: 'Sold Items Names', width: 7, ),
        PosColumn(
            text: 'Sold Items Quantity',
            width: 5,
            styles: PosStyles(align: PosAlign.right)),
      ]) ;}
      if(value == true){
        for (int i = 0; i < datum.orders!.length; i++) {
          Order orderData = datum.orders![i];
          printer.row([
            PosColumn(text: orderData.itemName.toString(), width: 5),
            PosColumn(
                text: orderData.quantity.toString(),
                width: 7,
                styles: PosStyles(align: PosAlign.right)),
          ]);
        }
      }
      printer.hr();
    }
    if (value == true) {
      printer.text("Total Items Sold",
          styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2,
            width: PosTextSize.size2,));
    }
    if (value == true) {printer.row([
      PosColumn(text: 'Total Items Names', width: 6),
      PosColumn(
          text: 'Total Items Quantity',
          width: 6,
          styles: PosStyles(align: PosAlign.right)),
    ]);}
    if (value == true) {
      for (int n = 0; n <
          reportByDateModelData.value.totalItemSold!.length; n++) {
        TotalItemSold totalItemSold = reportByDateModelData.value
            .totalItemSold![n];
        printer.row([
          PosColumn(text: totalItemSold.itemName.toString(), width: 5),
          PosColumn(
              text: totalItemSold.quantity.toString(),
              width: 7,
              styles: PosStyles(align: PosAlign.right)),
        ]);
      }
      printer.hr();
    }

      // value == true ? for (int n = 0; n <reportByDateModelData.value.totalItemSold!.length; n++) {
      //   TotalItemSold totalItemSold = reportByDateModelData.value.totalItemSold![n];
      //   printer.row([
      //     PosColumn(text: totalItemSold.itemName.toString(), width: 5),
      //     PosColumn(
      //         text: totalItemSold.quantity.toString(),
      //         width: 7,
      //         styles: PosStyles(align: PosAlign.right)),
      //   ]);
      // } : printer.text('');

      printer.row([
        PosColumn(text: 'Sum Pos Cash', width: 8),
        PosColumn(
            text: double.parse(reportByDateModelData.value.sumPosCash.toString()).toStringAsFixed(2),
            width: 4,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      printer.row([
        PosColumn(text: 'Sum Pos Card', width: 8),
        PosColumn(
            text: double.parse(reportByDateModelData.value.sumPosCard.toString()).toStringAsFixed(2),
            width: 4,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      printer.row([
        PosColumn(text: 'Sum Total Takeaway', width: 8),
        PosColumn(
            text: reportByDateModelData.value.sumTotalTakeaway.toString(),
            width: 4,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      printer.row([
        PosColumn(text: 'Sum Total Dining', width: 8),
        PosColumn(
            text: reportByDateModelData.value.sumTotalDining.toString(),
            width: 4,
            styles: PosStyles(align: PosAlign.right)),
      ]);
      printer.row([
      PosColumn(text: 'Sum Total Discounts', width: 8),
      PosColumn(
          text: reportByDateModelData.value.sumTotalDiscounts.toString(),
          width: 4,
          styles: PosStyles(align: PosAlign.right)),
    ]);
      printer.row([
        PosColumn(text: 'Sum Total Orders', width: 8),
        PosColumn(
            text: reportByDateModelData.value.sumTotalOrders.toString(),
            width: 4,
            styles: PosStyles(align: PosAlign.right)),
      ]);


      printer.hr(ch: '=', linesAfter: 1);

      printer.feed(2);
      printer.text('Thank you!',
          styles: PosStyles(align: PosAlign.center, bold: true));

      printer.feed(1);
      printer.cut();
      printer.beep();
    }
}