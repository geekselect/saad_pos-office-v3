// import 'package:get/get.dart';
//
// class ReportController extends GetxController{
//   // Future<BaseModel<OrderHistoryListModel>>? orderHistoryRef;
//   // @override
//   // void onInit() {
//   //   // TODO: implement onInit
//   //   super.onInit();
//   //   orderHistoryRef=_orderHistoryController.refreshOrderHistory(context);
//   //
//   // }
//   //
//   // Future<BaseModel<OrderHistoryListModel>> refreshOrderHistory(BuildContext context)async{
//   //   OrderHistoryListModel response;
//   //   try{
//   //     response  = await  RestClient(await RetroApi().dioData()).showOrder();
//   //     if (response.success!) {
//   //       listOrderHistory.value=response.data!;
//   //     } else {
//   //       Constants.toastMessage('No Data');
//   //     }
//   //
//   //   }catch (error, stacktrace) {
//   //     print("Exception occurred: $error stackTrace: $stacktrace");
//   //     return BaseModel()..setException(ServerError.withError(error: error));
//   //   }
//   //   return BaseModel()..data = response;
//   // }
// }

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pos/controller/order_custimization_controller.dart';
// import 'package:pos/model/common_res.dart';
import 'package:pos/model/report_model.dart';
import 'package:pos/model/single_restaurants_details_model.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../retrofit/base_model.dart';

///For both calls pos cash and pos card
// class ReportController extends GetxController{
//
//   Future<BaseModel<SingleRestaurantsDetailsModel>>? callGetResturantDetailsRef;
//   final OrderCustimizationController _orderCustimizationController =
//   Get.find<OrderCustimizationController>();
//
//   Rx<ReportCashModel> posCashdata = ReportCashModel().obs;
//   Rx<ReportCardModel> posCarddata = ReportCardModel().obs;
//
//   String? posIp;
//   int? posPort;
//
//
//   final box = GetStorage();
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     posIp = box.read(Constants.posIp);
//     posPort = box.read(Constants.posPort);
//     callGetResturantDetailsRef = _orderCustimizationController
//         .callGetRestaurantsDetails(Constants.vendorId);
//   }
//
//    posCashCall(int id)async{
//      var response;
//     try{
//       response  = await  RestClient(await RetroApi().dioData()).cashPosCashAmount(id);
//       print("data pos cash ${response.data!.toJson()}");
//
//       // if (response.success!) {
//       //   var data = response.data!;
//       //   print("data pos cash ${response.data!}");
//       // } else {
//       //   Constants.toastMessage('No Data');
//       // }
//
//     }catch (error, stacktrace) {
//       print("Exception occurred: $error stackTrace: $stacktrace");
//       return BaseModel()..setException(ServerError.withError(error: error));
//     }
//     return [response]  ;
//   }
//
//    posCardCall(int id)async{
//     var response;
//     try{
//       response  = await  RestClient(await RetroApi().dioData()).cashPosCardAmount(id);
//       print("data pos card ${response.data!.toJson()}");
//
//
//     }catch (error, stacktrace) {
//       print("Exception occurred: $error stackTrace: $stacktrace");
//       return BaseModel()..setException(ServerError.withError(error: error));
//     }
//     return [response];
//   }
//
//   void testPrintPOS(String printerIp, int port, BuildContext ctx,
//       ) async {
//     // TODO Don't forget to choose printer's paper size
//     const PaperSize paper = PaperSize.mm80;
//     final profile = await CapabilityProfile.load();
//     final printer = NetworkPrinter(paper, profile);
//     final PosPrintResult res = await printer.connect(
//       printerIp,
//       port: port,
//     );
//
//     print('Print result: ${res.msg}');
//     Get.snackbar("", res.msg);
//
//     if (res == PosPrintResult.success) {
//       // DEMO RECEIPT
//       BaseModel<SingleRestaurantsDetailsModel>? restaurantDetails =
//       await callGetResturantDetailsRef;
//       if (restaurantDetails != null) {
//         var newDate = DateFormat('hh:mm a').format(DateTime.now());
//         var date = DateTime.parse(DateTime.now().toString());
//         var formattedDate = "${date.day}-${date.month}-${date.year} ${newDate}";
//         print("date ${formattedDate}");
//         printPOSReceipt(printer, restaurantDetails, formattedDate);
//         print(
//             'restaurant details  ${restaurantDetails.data!.data!.vendor!.name}');
//       } else {
//         print('Failed to fetch restaurant details');
//       }
//       printer.disconnect();
//     }
//   }
//
//
//
//   printPOSReceipt(
//       NetworkPrinter printer,
//       BaseModel<SingleRestaurantsDetailsModel>? restaurantDetails,
//       String date
//       ) {
//     // // Print image
//     // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
//     // final Uint8List bytes = data.buffer.asUint8List();
//     // final img.Image? image = img.decodeImage(bytes);
//     // printer.image(image!);
//     printer.text(restaurantDetails!.data!.data!.vendor!.name,
//         styles: PosStyles(
//           align: PosAlign.center,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ),
//         linesAfter: 1);
//
//     printer.text("${date}",
//         styles: PosStyles(align: PosAlign.center));
//     // printer.text('New Braunfels, TX',
//     //     styles: PosStyles(align: PosAlign.center));
//
//     // printer.text(
//     //     "Phone : ${restaurantDetails.data!.data!.vendor!.contact.toString()}",
//     //     styles: PosStyles(align: PosAlign.left));
//
//
//     // printer.text('Web: www.example.com',
//     //     styles: PosStyles(align: PosAlign.center), linesAfter: 1);
//
//     printer.hr();
//     printer.row([
//       PosColumn(text: 'Name', width: 4),
//       PosColumn(text: 'Amount', width: 8, styles: PosStyles(align: PosAlign.right)),
//     ]);
//     for (int index = 0; index < posCashdata.value.data!.names!.length; index++) {
//       ReportDetailModel reportDetailModel = posCashdata.value.data!;
//       printer.row([
//         PosColumn(text: reportDetailModel.names![0].toString(), width: 4),
//         PosColumn(
//             text: "Pos Cash Amount : ${reportDetailModel.amount![0].toString()}",
//             width: 8,
//             styles: PosStyles(align: PosAlign.right)),
//       ]);
//     }
//     // printer.hr();
//     // printer.row([
//     //   PosColumn(text: 'Name', width: 3),
//     //   PosColumn(text: 'Pos Card Amount', width: 3, styles: PosStyles(align: PosAlign.right)),
//     // ]);
//     for (int index = 0; index < posCarddata.value.data!.names!.length; index++) {
//       ReportDetailModel reportDetailModel = posCarddata.value.data!;
//       printer.row([
//         PosColumn(text: reportDetailModel.names![0].toString(), width: 4),
//         PosColumn(
//             text: "Pos Card Amount : ${reportDetailModel.amount![0].toString()}",
//             width: 8,
//             styles: PosStyles(align: PosAlign.right)),
//       ]);
//     }
//
//
//     printer.hr(ch: '=', linesAfter: 1);
//
//     printer.feed(2);
//     printer.text('Thank you!',
//         styles: PosStyles(align: PosAlign.center, bold: true));
//
//     // Print QR Code from image
//     // try {
//     //   const String qrData = 'example.com';
//     //   const double qrSize = 200;
//     //   final uiImg = await QrPainter(
//     //     data: qrData,
//     //     version: QrVersions.auto,
//     //     gapless: false,
//     //   ).toImageData(qrSize);
//     //   final dir = await getTemporaryDirectory();
//     //   final pathName = '${dir.path}/qr_tmp.png';
//     //   final qrFile = File(pathName);
//     //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
//     //   final img = decodeImage(imgFile.readAsBytesSync());
//
//     //   printer.image(img);
//     // } catch (e) {
//     //   print(e);
//     // }
//
//     // Print QR Code using native function
//     // printer.qrcode('example.com');
//
//     printer.feed(1);
//     printer.cut();
//   }
// }
///End

class ReportController extends GetxController {
  Future<BaseModel<SingleRestaurantsDetailsModel>>? callGetResturantDetailsRef;
  final OrderCustimizationController _orderCustimizationController =
      Get.find<OrderCustimizationController>();
  Rx<Order> reportModelOrderData = Order().obs;
  Rx<CancelledOrdersDetail> reportModelCancelledOrdersData = CancelledOrdersDetail().obs;
  Rx<IncompleteOrdersDetail> reportModelIncompleteOrdersData = IncompleteOrdersDetail().obs;
  Rx<ReportModel> reportModelData = ReportModel().obs;

  String? posIp;
  int? posPort;


  final box = GetStorage();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    posIp = box.read(Constants.posIp);
    posPort = box.read(Constants.posPort);
    callGetResturantDetailsRef = _orderCustimizationController
        .callGetRestaurantsDetails();
  }

  Future<BaseModel<ReportModel>>? reportsApiCall() async {
    final prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    String userId = prefs.getString(Constants.loginUserId.toString()) ?? '';
    ReportModel response;
    try {
      response = await RestClient(await RetroApi().dioData()).reportsCall(int.parse(vendorId.toString()), int.parse(userId.toString()));
      print("data of reports by Date screen ${response.toJson()}");

      reportModelData.value = response;
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
        printPOSReceipt(printer, restaurantDetails, formattedDate);
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
      String date) {
    // // Print image
    // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
    // final Uint8List bytes = data.buffer.asUint8List();
    // final img.Image? image = img.decodeImage(bytes);
    // printer.image(image!);
    printer.text(restaurantDetails!.data!.data!.vendor!.name,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    printer.text("${date}", styles: PosStyles(align: PosAlign.left));
    // printer.text('New Braunfels, TX',
    //     styles: PosStyles(align: PosAlign.center));

    // printer.text(
    //     "Phone : ${restaurantDetails.data!.data!.vendor!.contact.toString()}",
    //     styles: PosStyles(align: PosAlign.left));

    // printer.text('Web: www.example.com',
    //     styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    printer.hr();
    printer.row([
      PosColumn(text: 'Sold Item Names', width: 7),
      PosColumn(
          text: 'Total Quantity',
          width: 5,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    for (int index = 0; index < reportModelData.value.orders!.length; index++) {
      Order reportDetailOrderModel = reportModelData.value.orders![index];
      printer.row([
        PosColumn(text: reportDetailOrderModel.itemName.toString(), width: 11),
        PosColumn(
            text: reportDetailOrderModel.quantity.toString(),
            width: 1,
            styles: PosStyles(align: PosAlign.right)),
      ]);
    }

    printer.hr(ch: '=', linesAfter: 1);
    printer.row([
      PosColumn(text: 'User Name', width: 3),
      PosColumn(
          text: 'Type', width: 6, styles: PosStyles(align: PosAlign.center)),
      PosColumn(
          text: 'Amount', width: 3, styles: PosStyles(align: PosAlign.right)),
    ]);
    // for (int index = 0;
    //     index < reportModelData.value.payments!.posCash!.name!.length;
    //     index++) {
      // Payments reportDetailModel = reportModelData.value.payments!.posCash.name;
    reportModelData.value.payments!.posCash!.name != null ?  printer.row([
        PosColumn(
            text: reportModelData.value.payments!.posCash!.name!.toString(),
            width: 4),
        PosColumn(
            text: "Pos Cash Amount",
            width: 5,
            styles: PosStyles(align: PosAlign.center)),
        PosColumn(
            text:
                "${reportModelData.value.payments!.posCash!.amount!.toString()}",
            width: 3,
            styles: PosStyles(align: PosAlign.right)),
      ]): printer.row([
      PosColumn(
          text: 'No data',
          width: 4),
      PosColumn(
          text: "Pos Cash Amount",
          width: 5,
          styles: PosStyles(align: PosAlign.center)),
      PosColumn(
          text:
          "${reportModelData.value.payments!.posCash!.amount!.toString()}",
          width: 3,
          styles: PosStyles(align: PosAlign.right)),
    ]);

    reportModelData.value.payments!.posCard!.name != null ? printer.row([
        PosColumn(
            text: reportModelData.value.payments!.posCard!.name!.toString(),
            width: 4),
        PosColumn(
            text: "Pos Card Amount",
            width: 5,
            styles: PosStyles(align: PosAlign.center)),
        PosColumn(
            text:
                "${reportModelData.value.payments!.posCard!.amount!.toString()}",
            width: 3,
            styles: PosStyles(align: PosAlign.right)),
      ]) : printer.row([
      PosColumn(
          text: 'No data',
          width: 4),
      PosColumn(
          text: "Pos Card Amount",
          width: 5,
          styles: PosStyles(align: PosAlign.center)),
      PosColumn(
          text:
          "${reportModelData.value.payments!.posCard!.amount!.toString()}",
          width: 3,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    // }

    ///For Pos cash and pos card
    // for (int index = 0; index < posCashdata.value.data!.names!.length; index++) {
    //   ReportDetailModel reportDetailModel = posCashdata.value.data!;
    //   printer.row([
    //     PosColumn(text: reportDetailModel.names![0].toString(), width: 4),
    //     PosColumn(
    //         text: "Pos Cash Amount : ${reportDetailModel.amount![0].toString()}",
    //         width: 8,
    //         styles: PosStyles(align: PosAlign.right)),
    //   ]);
    // }
    // for (int index = 0; index < posCarddata.value.data!.names!.length; index++) {
    //   ReportDetailModel reportDetailModel = posCarddata.value.data!;
    //   printer.row([
    //     PosColumn(text: reportDetailModel.names![0].toString(), width: 4),
    //     PosColumn(
    //         text: "Pos Card Amount : ${reportDetailModel.amount![0].toString()}",
    //         width: 8,
    //         styles: PosStyles(align: PosAlign.right)),
    //   ]);
    // }
    ///End

    printer.hr(ch: '=', linesAfter: 1);

    printer.row([
      PosColumn(text: 'Todays Total Order', width: 8),
      PosColumn(
          text: reportModelData.value.totalOrders.toString(),
          width: 4,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.row([
      PosColumn(text: 'Todays Total Takeaway', width: 8),
      PosColumn(
          text: reportModelData.value.totalTakeaway.toString(),
          width: 4,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.row([
      PosColumn(text: 'Todays Total Dining', width: 8),
      PosColumn(
          text: reportModelData.value.totalDining.toString(),
          width: 4,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.row([
      PosColumn(text: 'Todays Total Discounts', width: 8),
      PosColumn(
          text: reportModelData.value.totalDiscounts!.toStringAsFixed(2),
          width: 4,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.row([
      PosColumn(text: 'Todays Total Cancel Orders', width: 8),
      PosColumn(
          text: reportModelData.value.totalCanceled!.toStringAsFixed(2),
          width: 4,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.row([
      PosColumn(text: 'Todays Total Incomplete Orders', width: 8),
      PosColumn(
          text: reportModelData.value.totalIncomplete!.toStringAsFixed(2),
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
