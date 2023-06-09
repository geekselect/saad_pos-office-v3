import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pos/controller/dining_cart_controller.dart';

import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/controller/shift_controller.dart';
import 'package:pos/model/cart_master.dart' as cartMasterModel;
import 'package:pos/model/order_history_list_model.dart';
import 'package:pos/model/single_restaurants_details_model.dart' as rest;
import 'package:pos/pages/OrderHistory/order_history.dart';
import 'package:pos/pages/order/OrderDetailScreen.dart';
import 'package:pos/pages/pos/Paymmmm/linkly_controller.dart';
import 'package:pos/pages/pos/pos_menu.dart';
import 'package:pos/printer/printer_controller.dart';
import 'package:pos/widgets/number_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../../controller/auto_printer_controller.dart';
import '../../controller/cart_controller.dart';
import '../../controller/order_history_controller.dart';
import '../../model/common_res.dart' as common;
import '../../retrofit/api_client.dart';
import '../../retrofit/api_header.dart';
import '../../retrofit/base_model.dart';
import '../../retrofit/server_error.dart';
import '../../utils/constants.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

import 'Core Payments/linkly_refund_response_model.dart';
import 'Paymmmm/linkly_model.dart';

class PosPayment extends StatefulWidget {
  double totalAmount;
  double strTaxAmount;
  final int? venderId, addressId, vendorDiscountId, tableNumber;
  final String? orderDate,
      orderTime,
      orderStatus,
      ordrePromoCode,
      orderDeliveryType,
      orderDeliveryCharge;
  final String? deliveryTime;
  final String? deliveryDate;
  final String? userName;
  final String? mobileNumber;
  final String? notes;

  // final double orderItem;
  final double? vendorDiscountAmount, subTotal;

  final List<Map<String, dynamic>>? allTax;

  PosPayment({
    Key? key,
    this.notes,
    this.userName,
    this.mobileNumber,
    required this.totalAmount,
    required this.venderId,
    required this.addressId,
    required this.vendorDiscountId,
    required this.tableNumber,
    required this.orderDate,
    required this.orderTime,
    required this.orderStatus,
    required this.ordrePromoCode,
    required this.orderDeliveryType,
    required this.strTaxAmount,
    required this.orderDeliveryCharge,
    required this.deliveryTime,
    required this.deliveryDate,
    required this.vendorDiscountAmount,
    required this.subTotal,
    required this.allTax,
  }) : super(key: key);

  @override
  State<PosPayment> createState() => _PosPaymentState();
}

class _PosPaymentState extends State<PosPayment> {
  final LinklyDataController _linklyDataController=  Get.put(LinklyDataController());
  final ShiftController shiftController = Get.find<ShiftController>();



  String input = "";
  String? orderPaymentType;
  String output = "";
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController receivedController = TextEditingController();
  TextEditingController changedController = TextEditingController();
    final TextEditingController posCashAmountController = TextEditingController();
    final TextEditingController posCardAmountController = TextEditingController();
  CartController _cartController = Get.find<CartController>();
  PrinterController _printerController = Get.find<PrinterController>();
  AutoPrinterController _autoPrinterController = Get.find<AutoPrinterController>();

  final DiningCartController _diningCartController = Get.find<DiningCartController>();


  // String? kitchenIp;
  // int? kitchenPort;
  // String? posIp;
  // int? posPort;

  bool isDisabled = false;

  final box = GetStorage();

  final _formKey = GlobalKey<FormState>();
  final _formDialogKey = GlobalKey<FormState>();
  final OrderCustimizationController _orderCustimizationController =
      Get.find<OrderCustimizationController>();
  dynamic number;
  dynamic discount = 0;
  dynamic date;

  @override
  void initState() {
    getDataShift();
    totalAmountController.text = widget.totalAmount.toString();
    // _printerController.getPrinterDetails();
    _linklyDataController.dialogTitle.value = '';
    _linklyDataController.dialogContent.value = '';
    super.initState();
  }

  getDataShift()async {
    final prefs = await SharedPreferences.getInstance();
    String shiftName = prefs.getString(Constants.shiftName.toString()) ?? '';
    String shiftCodeBefore = prefs.getString(Constants.shiftCode.toString()) ?? '';
    print("Shift Inner");
    print("Shift Name ${shiftName}");
    print("Shift Name Before ${shiftCodeBefore}");
  }


  void testPrintPOS(String printerIp, int port,
      OrderHistoryData orderData , OrderDataModel orderModel) async {
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
      rest.SingleRestaurantsDetailsModel restaurantDetails = _orderCustimizationController.response.value;
      if (restaurantDetails != null) {
        print("--------POS PRint-------");
        print(
            'Print ip pos result: ${_printerController.printerModel.value.ipPos}');
        print(
            'Print ip posport result: ${_printerController.printerModel.value.portPos}');
        print(
            'Print ip kitchen result: ${_printerController.printerModel.value.ipKitchen}');
        print(
            'Print ip kitchenport result: ${_printerController.printerModel.value.portKitchen}');
        print("---------------");
        print('Print ip kitchen result: ${printerIp}');
        print('Print ip kitchenport result: ${port}');
        print("---------------");
        printPOSReceipt(printer, restaurantDetails, orderData, orderModel);
        print(
            'restaurant details  ${restaurantDetails.data!.vendor!.name}');
      } else {
        print('Failed to fetch restaurant details');
      }
      // TEST PRINT
      // await testReceipt(printer);
      printer.disconnect();
    }

    // final snackBar =
    //     SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
    // ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
  }

  printPOSReceipt(
    NetworkPrinter printer,
      rest.SingleRestaurantsDetailsModel restaurantDetails,
      OrderHistoryData orderData,
      OrderDataModel orderModel
      ) {
    print("-----------------> ${orderData.toJson()}");

    List<Cart> cart = orderModel.cart!;
    // List<Cart> cart = cartMaster.cart;
    printer.text(restaurantDetails.data!.vendor!.name,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    printer.text(restaurantDetails.data!.vendor!.mapAddress.toString(),
        styles: PosStyles(align: PosAlign.center));
    // printer.text('New Braunfels, TX',
    //     styles: PosStyles(align: PosAlign.center));

    printer.text(
        "Phone : ${restaurantDetails.data!.vendor!.contact.toString()}",
        styles: PosStyles(align: PosAlign.left));

    printer.text("Order Id ${orderData.orderId.toString()}",
        styles: PosStyles(align: PosAlign.left));

    if (orderData.datumUserName != null && orderData.datumUserName!.isNotEmpty) {
      printer.text('Customer Name : ${orderData.datumUserName}',
          styles: PosStyles(align: PosAlign.left));
    }
    if (orderData.mobile != null && orderData.mobile!.isNotEmpty) {
      printer.text('Customer Phone No : ${orderData.mobile}',
          styles: PosStyles(align: PosAlign.left));
    }

    printer.text('${DateFormat('yyyy-MM-dd').format(orderData.date!)} ${orderData.time}',
        styles: PosStyles(align: PosAlign.left));

    if (orderData.tableNo != null && orderData.tableNo != 0) {
      printer.text('Table Number : ${orderData.tableNo}',
          styles: const PosStyles(align: PosAlign.left));
    }

    if (orderData.paymentType == "INCOMPLETE ORDER") {
      printer.text('Payment Status : UnPaid',
          styles: PosStyles(align: PosAlign.left));
    } else {
      if(orderData.paymentType == "POS CASH TAKEAWAY"){
        printer.text('Payment Status : POS CASH',
            styles: PosStyles(align: PosAlign.left));
      }else if(orderData.paymentType == "POS CARD TAKEAWAY"){
        printer.text('Payment Status : POS CARD',
            styles: PosStyles(align: PosAlign.left));
      } else {
        printer.text('Payment Status : ${orderData.paymentType}',
            styles: PosStyles(align: PosAlign.left));
      }
    }

    printer.text('Order Type :  ${orderData.deliveryType}',
        styles: PosStyles(align: PosAlign.left));


    printer.hr();
    printer.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Item', width: 9),
      PosColumn(
          text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    for (int itemIndex = 0; itemIndex < cart.length; itemIndex++) {
      String category = cart[itemIndex].category!;
      MenuCategory? menuCategory = cart[itemIndex].menuCategory;
      List<Menu> menu = cart[itemIndex].menu!;
      if (category == 'SINGLE') {
        Cart cartItem = cart[itemIndex];
        // printer.row([
        //   PosColumn(
        //       text: "-SINGLE-",
        //       width: 12,
        //       styles: PosStyles(
        //           width: PosTextSize.size1,
        //           height: PosTextSize.size1,
        //           align: PosAlign.center))
        // ]);

        // var price;
        // if(_cartController.diningValue) {
        //   price =  cart[
        //   itemIndex]
        //       .diningAmount;
        // } else {
        //   price =  cart[
        //   itemIndex]
        //       .totalAmount;
        // }

        for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
          Menu menuItem = menu[menuIndex];
          if(widget.orderDeliveryType == 'DINING') {
            print("dining row");
            printer.row([
              PosColumn(text: cartItem.quantity.toString(), width: 1),
              PosColumn(
                text: menu[menuIndex].name! +
                    (cart[itemIndex].size != null
                        ? '(${cart[itemIndex].size['size_name']})'
                        : ''),
                width: 9,
              ),
              PosColumn(
                  text: double.parse(cartItem.diningAmount.toString()).toStringAsFixed(2),
                  width: 2,
                  styles: PosStyles(align: PosAlign.right)),
            ]);
          } else {
            print("takeaway row");
            printer.row([
              PosColumn(text: cartItem.quantity.toString(), width: 1),
              PosColumn(
                text: menu[menuIndex].name! +
                    (cart[itemIndex].size != null
                        ? '(${cart[itemIndex].size['size_name']})'
                        : ''),
                width: 9,
              ),
              PosColumn(
                  text:  double.parse(cartItem.totalAmount.toString()).toStringAsFixed(2),
                  width: 2,
                  styles: PosStyles(align: PosAlign.right)),
            ]);
          }
          for (int addonIndex = 0;
              addonIndex < menuItem.addons!.length;
              addonIndex++) {
            Addon addonItem = menuItem.addons![addonIndex];
            // if (addonIndex == 0) {
            //   printer.row([
            //     PosColumn(
            //         text: "-ADDONS-",
            //         width: 12,
            //         styles: PosStyles(
            //             width: PosTextSize.size1,
            //             height: PosTextSize.size1,
            //             align: PosAlign.center))
            //   ]);
            // }
            printer.row([
              PosColumn(text: '', width: 1),
              PosColumn(text: " ${addonItem.name} (ADDON)", width: 9),
              // PosColumn(
              // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
              PosColumn(
                  // text:  double.parse(addonItem.price.toString()).toStringAsFixed(2),
                  text:  '',
                  width: 2,
                  styles: PosStyles(align: PosAlign.right)),
            ]);
          }

          for (int modifierIndex = 0;
          modifierIndex < menuItem.modifiers!.length;
          modifierIndex++) {
            cartMasterModel.Modifier modifierItem = menuItem.modifiers![modifierIndex];
            // if (addonIndex == 0) {
            //   printer.row([
            //     PosColumn(
            //         text: "-ADDONS-",
            //         width: 12,
            //         styles: PosStyles(
            //             width: PosTextSize.size1,
            //             height: PosTextSize.size1,
            //             align: PosAlign.center))
            //   ]);
            // }
            for (int modifierDetailIndex = 0;
            modifierDetailIndex < modifierItem.modifierDetails!.length;
            modifierDetailIndex++) {
              cartMasterModel.ModifierDetail modifierDetailItem = modifierItem.modifierDetails![modifierDetailIndex];
              // if (addonIndex == 0) {
              //   printer.row([
              //     PosColumn(
              //         text: "-ADDONS-",
              //         width: 12,
              //         styles: PosStyles(
              //             width: PosTextSize.size1,
              //             height: PosTextSize.size1,
              //             align: PosAlign.center))
              //   ]);
              // }
              printer.row([
                PosColumn(text: '', width: 1),
                PosColumn(text: " ${modifierDetailItem.modifierName} (Modifier)", width: 9),
                // PosColumn(
                // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
                PosColumn(
                  // text:  double.parse(addonItem.price.toString()).toStringAsFixed(2),
                    text:  '',
                    width: 2,
                    styles: PosStyles(align: PosAlign.right)),
              ]);
            }
          }
        }
      }
      // else if (category == 'HALF_N_HALF') {
      //   Cart cartItem = cart[itemIndex];
      //   printer.row([
      //     PosColumn(
      //         text: "-HALF & HALF-",
      //         width: 12,
      //         styles: PosStyles(
      //             width: PosTextSize.size1,
      //             height: PosTextSize.size1,
      //             align: PosAlign.center))
      //   ]);
      //   printer.row([
      //     PosColumn(text: cartItem.quantity.toString(), width: 1),
      //     PosColumn(
      //         text: menuCategory!.name +
      //             (cartItem.size != null ? '(${cartItem.size?.sizeName})' : ''),
      //         width: 9,
      //         styles: PosStyles(
      //             width: PosTextSize.size1, height: PosTextSize.size1)),
      //     // PosColumn(
      //     // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //     PosColumn(
      //         text: cartItem.totalAmount.toString(),
      //         width: 2,
      //         styles: PosStyles(align: PosAlign.right)),
      //   ]);
      //
      //   for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
      //     Menu menuItem = menu[menuIndex];
      //     printer.row([
      //       PosColumn(
      //           text: ' ${menuIndex == 0 ? '-1st Half-' : "-2nd Half-"}',
      //           width: 12,
      //           styles: PosStyles(
      //               width: PosTextSize.size1,
      //               height: PosTextSize.size1,
      //               align: PosAlign.center))
      //     ]);
      //     printer.row([
      //       PosColumn(text: '', width: 1),
      //       PosColumn(text: menuItem.name! + '', width: 9),
      //       // PosColumn(
      //       // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //       PosColumn(
      //           text: '', width: 2, styles: PosStyles(align: PosAlign.right)),
      //     ]);
      //
      //     for (int addonIndex = 0;
      //         addonIndex < menuItem.addons!.length;
      //         addonIndex++) {
      //       Addon addonItem = menuItem.addons![addonIndex];
      //       if (addonIndex == 0) {
      //         printer.row([
      //           PosColumn(
      //               text: "-ADDONS-",
      //               width: 12,
      //               styles: PosStyles(
      //                   width: PosTextSize.size1,
      //                   height: PosTextSize.size1,
      //                   align: PosAlign.center))
      //         ]);
      //       }
      //       printer.row([
      //         PosColumn(text: '', width: 1),
      //         PosColumn(text: addonItem.name, width: 9),
      //         // PosColumn(
      //         // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //         PosColumn(
      //             text: addonItem.price.toString(),
      //             width: 2,
      //             styles: PosStyles(align: PosAlign.right)),
      //       ]);
      //     }
      //   }
      // } else if (category == 'DEALS') {
      //   Cart cartItem = cart[itemIndex];
      //
      //   printer.row([
      //     PosColumn(
      //         text: "-DEALS-",
      //         width: 12,
      //         styles: PosStyles(
      //             width: PosTextSize.size1,
      //             height: PosTextSize.size1,
      //             align: PosAlign.center))
      //   ]);
      //   printer.row([
      //     PosColumn(text: cartItem.quantity.toString(), width: 1),
      //     PosColumn(
      //         text: menuCategory!.name +
      //             (cartItem.size != null ? '(${cartItem.size?.sizeName})' : ''),
      //         width: 9,
      //         styles: PosStyles(
      //             width: PosTextSize.size1, height: PosTextSize.size1)),
      //     // PosColumn(
      //     // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //     PosColumn(
      //         text: cartItem.totalAmount.toString(),
      //         width: 2,
      //         styles: PosStyles(align: PosAlign.right)),
      //   ]);
      //   for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
      //     Menu menuItem = menu[menuIndex];
      //     DealsItems dealsItems = menu[menuIndex].dealsItems!;
      //     printer.row([
      //       PosColumn(
      //           text: "-${menuItem.name}(${dealsItems.name})-",
      //           width: 12,
      //           styles: PosStyles(
      //               width: PosTextSize.size1,
      //               height: PosTextSize.size1,
      //               align: PosAlign.center))
      //     ]);
      //     for (int addonIndex = 0;
      //         addonIndex < menuItem.addons!.length;
      //         addonIndex++) {
      //       Addon addonItem = menuItem.addons![addonIndex];
      //       if (addonIndex == 0) {
      //         printer.row([
      //           PosColumn(width: 1),
      //           PosColumn(
      //               text: "        -ADDONS-",
      //               width: 9,
      //               styles: PosStyles(
      //                   width: PosTextSize.size1,
      //                   height: PosTextSize.size1,
      //                   align: PosAlign.center)),
      //           PosColumn(width: 2),
      //         ]);
      //       }
      //       printer.row([
      //         PosColumn(text: '', width: 1),
      //         PosColumn(text: addonItem.name!, width: 9),
      //         // PosColumn(
      //         // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //         PosColumn(
      //             text: addonItem.price.toString(),
      //             width: 2,
      //             styles: PosStyles(align: PosAlign.right)),
      //       ]);
      //     }
      //   }
      // }
    }
    printer.hr();

    printer.row([
      PosColumn(
          text: 'SubTotal',
          width: 6,
          styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: "$currencySymbol${double.parse(orderData.subTotal!).toStringAsFixed(2)}",
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    if (double.parse(orderData.tax!)
        .toStringAsFixed(2) != "0.00") {
      printer.row([
        PosColumn(
            text: 'Tax',
            width: 6,
            styles: PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
        PosColumn(
            text: "$currencySymbol${double.parse(orderData.tax!)
                .toStringAsFixed(2)}",
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
      ]);
    }

    if (orderData.discounts != null) {
      printer.row([
        PosColumn(
            text: 'Discount',
            width: 6,
            styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
        PosColumn(
            text:
            "$currencySymbol${double.parse(orderData.discounts!.toString()).toStringAsFixed(2)}",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
      ]);
    }

    printer.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: "$currencySymbol${double.parse(orderData.amount.toString()).toStringAsFixed(2)}",
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

    printer.hr();

    if (orderData.notes != null &&
        orderData.notes!.isNotEmpty &&
        orderData.notes != '') {
      printer.text(
        "Instructions: ${orderData.notes!}",
      );
    }

    printer.hr(ch: '=', linesAfter: 1);

    printer.feed(2);
    printer.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    // Print QR Code from image
    // try {
    //   const String qrData = 'example.com';
    //   const double qrSize = 200;
    //   final uiImg = await QrPainter(
    //     data: qrData,
    //     version: QrVersions.auto,
    //     gapless: false,
    //   ).toImageData(qrSize);
    //   final dir = await getTemporaryDirectory();
    //   final pathName = '${dir.path}/qr_tmp.png';
    //   final qrFile = File(pathName);
    //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
    //   final img = decodeImage(imgFile.readAsBytesSync());

    //   printer.image(img);
    // } catch (e) {
    //   print(e);
    // }

    // Print QR Code using native function
    // printer.qrcode('example.com');

    printer.feed(1);
    printer.cut();
    printer.beep();
  }

  void testPrintKitchen(String printerIp, int port,
      OrderHistoryData orderData, OrderDataModel orderModel ) async {
    // TODO Don't forget to choose printer's paper size
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final PosPrintResult res = await printer.connect(
      printerIp,
      port: port,
    );
    Get.snackbar("", res.msg);

    // final snackBar =
    // SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
    // ScaffoldMessenger.of(ctx).showSnackBar(snackBar);

    // print('Print result: ${res.msg}');

    if (res == PosPrintResult.success) {
      // DEMO RECEIPT
      print("--------Kithcen PRint-------");
      print(
          'Print ip pos result: ${_printerController.printerModel.value.ipPos}');
      print(
          'Print ip posport result: ${_printerController.printerModel.value.portPos}');
      print(
          'Print ip kitchen result: ${_printerController.printerModel.value.ipKitchen}');
      print(
          'Print ip kitchenport result: ${_printerController.printerModel.value.portKitchen}');
      print("---------------");
      print('Print ip kitchen result: ${printerIp}');
      print('Print ip kitchenport result: ${port}');
      print("---------------");
      printKitchenReceipt(printer, orderData, orderModel);

      // TEST PRINT
      // await testReceipt(printer);
      printer.disconnect();
    } else {
      print("--------NO-------");
      print("--------$printerIp-------");
      print("--------$port-------");
    }
  }

  printKitchenReceipt(NetworkPrinter printer,OrderHistoryData orderData , OrderDataModel orderModel) {

    List<Cart> cart = orderModel.cart!;
    // printer.text("*** PRINT ***",
    //     styles: PosStyles(
    //       align: PosAlign.center,
    //       height: PosTextSize.size2,
    //       width: PosTextSize.size2,
    //       reverse: true
    //     ),);

    printer.text("*** Kitchen ***",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    // printer.text('${cartMaster.oldOrderId?.toString()}',
    //     styles: PosStyles(
    //       align: PosAlign.center,
    //       height: PosTextSize.size2,
    //       width: PosTextSize.size2,
    //     ));

    if (orderData.tableNo != null && orderData.tableNo != 0) {
      printer.text('Table ${orderData.tableNo}',
          styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ),
          linesAfter: 1);
    }

    if (orderData.datumUserName != null && orderData.datumUserName!.isNotEmpty) {
      printer.text('Customer Name : ${orderData.datumUserName}',
          styles: PosStyles(align: PosAlign.left));
    }
    if (orderData.mobile != null && orderData.mobile!.isNotEmpty) {
      printer.text('Customer Phone No : ${orderData.mobile}',
          styles: PosStyles(align: PosAlign.left));
    }


    printer.text("Order Id ${orderData.orderId.toString()}",
        styles: PosStyles(align: PosAlign.left));

    printer.text('${DateFormat('yyyy-MM-dd').format(orderData.date!)} ${orderData.time}',
        styles: PosStyles(align: PosAlign.left));

    if (orderData.paymentType == "INCOMPLETE ORDER") {
      printer.text('Payment Status : UnPaid',
          styles: PosStyles(align: PosAlign.left));
    } else {
      if(orderData.paymentType == "POS CASH TAKEAWAY"){
        printer.text('Payment Status : POS CASH',
            styles: PosStyles(align: PosAlign.left));
      }else if(orderData.paymentType == "POS CARD TAKEAWAY"){
        printer.text('Payment Status : POS CARD',
            styles: PosStyles(align: PosAlign.left));
      } else {
        printer.text('Payment Status : ${orderData.paymentType}',
            styles: PosStyles(align: PosAlign.left));
      }
    }

    printer.text("Order Type : ${orderData.deliveryType}",
        styles: PosStyles(align: PosAlign.left));

    // printer.text('Web: www.example.com',
    //     styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    // printer.hr();
    // printer.text(widget.orderDeliveryType!,
    //   styles: PosStyles(
    //     align: PosAlign.center,
    //     height: PosTextSize.size3,
    //     width: PosTextSize.size3,
    //   ),);
    printer.hr();
    printer.row([
      PosColumn(text: 'Qty', width: 2),
      PosColumn(text: 'Item', width: 10),
    ]);
    for (int itemIndex = 0; itemIndex < cart.length; itemIndex++) {
      String category = cart[itemIndex].category!;
      MenuCategory? menuCategory = cart[itemIndex].menuCategory;
      List<Menu> menu = cart[itemIndex].menu!;
      if (category == 'SINGLE') {
        Cart cartItem = cart[itemIndex];

        for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
          Menu menuItem = menu[menuIndex];
          printer.row([
            PosColumn(
                text: cartItem.quantity.toString(),
                width: 2,
                styles: PosStyles(bold: true)),
            PosColumn(
                text: menu[menuIndex].name! +
                    (cart[itemIndex].size != null
                        ? '(${cart[itemIndex].size['size_name']})'
                        : ''),
                width: 10,
                styles: PosStyles(
                    width: PosTextSize.size1,
                    height: PosTextSize.size1,
                    align: PosAlign.left,
                    bold: true)),
          ]);
          for (int addonIndex = 0;
              addonIndex < menuItem.addons!.length;
              addonIndex++) {
            Addon addonItem = menuItem.addons![addonIndex];
            // if (addonIndex == 0) {
            //   printer.row([
            //     PosColumn(
            //         text: "-ADDONS-",
            //         width: 12,
            //         styles: PosStyles(
            //             width: PosTextSize.size1,
            //             height: PosTextSize.size1,
            //             align: PosAlign.center))
            //   ]);
            // }
            printer.row([
              PosColumn(text: '', width: 2),
              PosColumn(text: " ${addonItem.name} (ADDON)", width: 10),
              // PosColumn(
              // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
            ]);
          }

          for (int modifierIndex = 0;
          modifierIndex < menuItem.modifiers!.length;
          modifierIndex++) {
            cartMasterModel.Modifier modifierItem = menuItem.modifiers![modifierIndex];
            // if (addonIndex == 0) {
            //   printer.row([
            //     PosColumn(
            //         text: "-ADDONS-",
            //         width: 12,
            //         styles: PosStyles(
            //             width: PosTextSize.size1,
            //             height: PosTextSize.size1,
            //             align: PosAlign.center))
            //   ]);
            // }
            for (int modifierDetailIndex = 0;
            modifierDetailIndex < modifierItem.modifierDetails!.length;
            modifierDetailIndex++) {
              cartMasterModel.ModifierDetail modifierDetailItem = modifierItem.modifierDetails![modifierDetailIndex];
              // if (addonIndex == 0) {
              //   printer.row([
              //     PosColumn(
              //         text: "-ADDONS-",
              //         width: 12,
              //         styles: PosStyles(
              //             width: PosTextSize.size1,
              //             height: PosTextSize.size1,
              //             align: PosAlign.center))
              //   ]);
              // }
              printer.row([
                PosColumn(text: '', width: 2),
                PosColumn(text: " ${modifierDetailItem.modifierName} (Modifier)", width: 10),
              ]);
            }
          }
        }
      }
      // else if (category == 'HALF_N_HALF') {
      //   Cart cartItem = cart[itemIndex];
      //   printer.row([
      //     PosColumn(
      //         text: "-HALF & HALF-",
      //         width: 12,
      //         styles: PosStyles(
      //             width: PosTextSize.size1,
      //             height: PosTextSize.size1,
      //             align: PosAlign.center))
      //   ]);
      //   printer.row([
      //     PosColumn(text: cartItem.quantity.toString(), width: 1),
      //     PosColumn(
      //         text: menuCategory!.name +
      //             (cartItem.size != null ? '(${cartItem.size?.sizeName})' : ''),
      //         width: 9,
      //         styles: PosStyles(
      //             width: PosTextSize.size1, height: PosTextSize.size1)),
      //     // PosColumn(
      //     // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //     PosColumn(
      //         text: cartItem.totalAmount.toString(),
      //         width: 2,
      //         styles: PosStyles(align: PosAlign.right)),
      //   ]);
      //   for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
      //     Menu menuItem = menu[menuIndex];
      //     printer.row([
      //       PosColumn(
      //           text: ' ${menuIndex == 0 ? '-1st Half-' : "-2nd Half-"}',
      //           width: 12,
      //           styles: PosStyles(
      //               width: PosTextSize.size1,
      //               height: PosTextSize.size1,
      //               align: PosAlign.center))
      //     ]);
      //     printer.row([
      //       PosColumn(text: '', width: 1),
      //       PosColumn(text: menuItem.name! + '', width: 9),
      //       // PosColumn(
      //       // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //       PosColumn(
      //           text: '', width: 2, styles: PosStyles(align: PosAlign.right)),
      //     ]);
      //
      //     for (int addonIndex = 0;
      //         addonIndex < menuItem.addons!.length;
      //         addonIndex++) {
      //       Addon addonItem = menuItem.addons![addonIndex];
      //       if (addonIndex == 0) {
      //         printer.row([
      //           PosColumn(
      //               text: "-ADDONS-",
      //               width: 12,
      //               styles: PosStyles(
      //                   width: PosTextSize.size1,
      //                   height: PosTextSize.size1,
      //                   align: PosAlign.center))
      //         ]);
      //       }
      //       printer.row([
      //         PosColumn(text: '', width: 1),
      //         PosColumn(text: addonItem.name!, width: 9),
      //         // PosColumn(
      //         // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //         PosColumn(
      //             text: addonItem.price.toString(),
      //             width: 2,
      //             styles: PosStyles(align: PosAlign.right)),
      //       ]);
      //     }
      //   }
      // } else if (category == 'DEALS') {
      //   Cart cartItem = cart[itemIndex];
      //
      //   printer.row([
      //     PosColumn(
      //         text: "-DEALS-",
      //         width: 12,
      //         styles: PosStyles(
      //             width: PosTextSize.size1,
      //             height: PosTextSize.size1,
      //             align: PosAlign.center))
      //   ]);
      //   printer.row([
      //     PosColumn(text: cartItem.quantity.toString(), width: 1),
      //     PosColumn(
      //         text: menuCategory!.name +
      //             (cartItem.size != null ? '(${cartItem.size?.sizeName})' : ''),
      //         width: 9,
      //         styles: PosStyles(
      //             width: PosTextSize.size1, height: PosTextSize.size1)),
      //     // PosColumn(
      //     // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //     PosColumn(
      //         text: cartItem.totalAmount.toString(),
      //         width: 2,
      //         styles: PosStyles(align: PosAlign.right)),
      //   ]);
      //   for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
      //     Menu menuItem = menu[menuIndex];
      //     // DealsItems dealsItems = menu[menuIndex].dealsItems!;
      //     printer.row([
      //       PosColumn(
      //           text: "-${menuItem.name}(${dealsItems.name})-",
      //           width: 12,
      //           styles: PosStyles(
      //               width: PosTextSize.size1,
      //               height: PosTextSize.size1,
      //               align: PosAlign.center))
      //     ]);
      //     for (int addonIndex = 0;
      //         addonIndex < menuItem.addons!.length;
      //         addonIndex++) {
      //       Addon addonItem = menuItem.addons![addonIndex];
      //       if (addonIndex == 0) {
      //         printer.row([
      //           PosColumn(width: 1),
      //           PosColumn(
      //               text: "        -ADDONS-",
      //               width: 9,
      //               styles: PosStyles(
      //                   width: PosTextSize.size1,
      //                   height: PosTextSize.size1,
      //                   align: PosAlign.center)),
      //           PosColumn(width: 2),
      //         ]);
      //       }
      //       printer.row([
      //         PosColumn(text: '', width: 1),
      //         PosColumn(text: addonItem.name!, width: 9),
      //         // PosColumn(
      //         // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //         PosColumn(
      //             text: addonItem.price.toString(),
      //             width: 2,
      //             styles: PosStyles(align: PosAlign.right)),
      //       ]);
      //     }
      //   }
      // }
    }
    // printer.hr();

    // printer.row([
    //   PosColumn(
    //       text: 'TOTAL',
    //       width: 6,
    //       styles: PosStyles(
    //         height: PosTextSize.size2,
    //         width: PosTextSize.size2,
    //       )),
    //   PosColumn(
    //       text: "$currencySymbol${totalAmountController.text}",
    //       width: 6,
    //       styles: PosStyles(
    //         align: PosAlign.right,
    //         height: PosTextSize.size2,
    //         width: PosTextSize.size2,
    //       )),
    // ]);
    printer.hr();

    if (orderData.notes != null &&
        orderData.notes!.isNotEmpty &&
        orderData.notes != '') {
      printer.text(
        "Instructions: ${orderData.notes!}",
      );
    }

    printer.hr(ch: '=', linesAfter: 1);

    printer.feed(2);
    printer.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    // Print QR Code from image
    // try {
    //   const String qrData = 'example.com';
    //   const double qrSize = 200;
    //   final uiImg = await QrPainter(
    //     data: qrData,
    //     version: QrVersions.auto,
    //     gapless: false,
    //   ).toImageData(qrSize);
    //   final dir = await getTemporaryDirectory();
    //   final pathName = '${dir.path}/qr_tmp.png';
    //   final qrFile = File(pathName);
    //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
    //   final img = decodeImage(imgFile.readAsBytesSync());

    //   printer.image(img);
    // } catch (e) {
    //   print(e);
    // }

    // Print QR Code using native function
    // printer.qrcode('example.com');

    printer.feed(1);
    printer.cut();
    printer.beep();
  }

  ///vv
  // void testPrintPOS(String printerIp, int port, BuildContext ctx,
  //     OrderData orderData ) async {
  //   // TODO Don't forget to choose printer's paper size
  //   const PaperSize paper = PaperSize.mm80;
  //   final profile = await CapabilityProfile.load();
  //   final printer = NetworkPrinter(paper, profile);
  //   final PosPrintResult res = await printer.connect(
  //     printerIp,
  //     port: port,
  //   );
  //
  //   print('Print result: ${res.msg}');
  //   Get.snackbar("", res.msg);
  //
  //   if (res == PosPrintResult.success) {
  //     // DEMO RECEIPT
  //     BaseModel<rest.SingleRestaurantsDetailsModel>? restaurantDetails =
  //         await callGetResturantDetailsRef;
  //     if (restaurantDetails != null) {
  //       print("--------POS PRint-------");
  //       print(
  //           'Print ip pos result: ${_printerController.printerModel.value.ipPos}');
  //       print(
  //           'Print ip posport result: ${_printerController.printerModel.value.portPos}');
  //       print(
  //           'Print ip kitchen result: ${_printerController.printerModel.value.ipKitchen}');
  //       print(
  //           'Print ip kitchenport result: ${_printerController.printerModel.value.portKitchen}');
  //       print("---------------");
  //       print('Print ip kitchen result: ${printerIp}');
  //       print('Print ip kitchenport result: ${port}');
  //       print("---------------");
  //       printPOSReceipt(printer, restaurantDetails, orderData);
  //       print(
  //           'restaurant details  ${restaurantDetails.data!.data!.vendor!.name}');
  //     } else {
  //       print('Failed to fetch restaurant details');
  //     }
  //     // TEST PRINT
  //     // await testReceipt(printer);
  //     printer.disconnect();
  //   }
  //
  //   // final snackBar =
  //   //     SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
  //   // ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
  // }
  //
  // printPOSReceipt(
  //   NetworkPrinter printer,
  //   BaseModel<rest.SingleRestaurantsDetailsModel>? restaurantDetails,
  //     OrderData orderData
  //     ) {
  //
  //
  //   List<Cart> cart = orderData.item!.cart!;
  //   // List<Cart> cart = cartMaster.cart;
  //   printer.text(restaurantDetails!.data!.data!.vendor!.name,
  //       styles: PosStyles(
  //         align: PosAlign.center,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ),
  //       linesAfter: 1);
  //
  //   printer.text(restaurantDetails.data!.data!.vendor!.mapAddress.toString(),
  //       styles: PosStyles(align: PosAlign.center));
  //   // printer.text('New Braunfels, TX',
  //   //     styles: PosStyles(align: PosAlign.center));
  //
  //   printer.text(
  //       "Phone : ${restaurantDetails.data!.data!.vendor!.contact.toString()}",
  //       styles: PosStyles(align: PosAlign.left));
  //
  //   printer.text("Order Id ${orderData.orderId.toString()}",
  //       styles: PosStyles(align: PosAlign.left));
  //
  //   if (orderData.userName != null && orderData.mobile != null) {
  //     printer.text('Customer Name : ${orderData.userName}',
  //         styles: PosStyles(align: PosAlign.left));
  //
  //     printer.text('Customer Phone No : ${orderData.mobile}',
  //         styles: PosStyles(align: PosAlign.left));
  //   }
  //
  //   printer.text('${DateFormat('yyyy-MM-dd').format(orderData.date!)} ${orderData.time}',
  //       styles: PosStyles(align: PosAlign.left));
  //
  //   if (orderData.tableNo != null && orderData.tableNo != 0 && orderData.tableNo!.isNotEmpty) {
  //     printer.text('Table Number : ${orderData.tableNo}',
  //         styles: const PosStyles(align: PosAlign.left));
  //   }
  //
  //   if (orderData.paymentType == "INCOMPLETE ORDER") {
  //     printer.text('Payment Status : UnPaid',
  //         styles: PosStyles(align: PosAlign.left));
  //   } else {
  //     printer.text('Payment Status : ${orderData.paymentType}',
  //         styles: PosStyles(align: PosAlign.left));
  //   }
  //
  //   printer.text('Order Type :  ${orderData.deliveryType}',
  //       styles: PosStyles(align: PosAlign.left));
  //
  //
  //   printer.hr();
  //   printer.row([
  //     PosColumn(text: 'Qty', width: 1),
  //     PosColumn(text: 'Item', width: 9),
  //     PosColumn(
  //         text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   for (int itemIndex = 0; itemIndex < cart.length; itemIndex++) {
  //     String category = cart[itemIndex].category!;
  //     MenuCategory? menuCategory = cart[itemIndex].menuCategory;
  //     List<Menu> menu = cart[itemIndex].menu!;
  //     if (category == 'SINGLE') {
  //       Cart cartItem = cart[itemIndex];
  //       // printer.row([
  //       //   PosColumn(
  //       //       text: "-SINGLE-",
  //       //       width: 12,
  //       //       styles: PosStyles(
  //       //           width: PosTextSize.size1,
  //       //           height: PosTextSize.size1,
  //       //           align: PosAlign.center))
  //       // ]);
  //
  //       // var price;
  //       // if(_cartController.diningValue) {
  //       //   price =  cart[
  //       //   itemIndex]
  //       //       .diningAmount;
  //       // } else {
  //       //   price =  cart[
  //       //   itemIndex]
  //       //       .totalAmount;
  //       // }
  //
  //       for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
  //         Menu menuItem = menu[menuIndex];
  //         if(widget.orderDeliveryType == 'DINING') {
  //           print("dining row");
  //           printer.row([
  //             PosColumn(text: cartItem.quantity.toString(), width: 1),
  //             PosColumn(
  //               text: menu[menuIndex].name! +
  //                   (cart[itemIndex].size != null
  //                       ? '(${cart[itemIndex].size?.sizeName})'
  //                       : ''),
  //               width: 9,
  //             ),
  //             PosColumn(
  //                 text: double.parse(cartItem.diningAmount.toString()).toStringAsFixed(2),
  //                 width: 2,
  //                 styles: PosStyles(align: PosAlign.right)),
  //           ]);
  //         } else {
  //           print("takeaway row");
  //           printer.row([
  //             PosColumn(text: cartItem.quantity.toString(), width: 1),
  //             PosColumn(
  //               text: menu[menuIndex].name! +
  //                   (cart[itemIndex].size != null
  //                       ? '(${cart[itemIndex].size?.sizeName})'
  //                       : ''),
  //               width: 9,
  //             ),
  //             PosColumn(
  //                 text:  double.parse(cartItem.totalAmount.toString()).toStringAsFixed(2),
  //                 width: 2,
  //                 styles: PosStyles(align: PosAlign.right)),
  //           ]);
  //         }
  //         for (int addonIndex = 0;
  //             addonIndex < menuItem.addons!.length;
  //             addonIndex++) {
  //           Addon addonItem = menuItem.addons![addonIndex];
  //           if (addonIndex == 0) {
  //             printer.row([
  //               PosColumn(
  //                   text: "-ADDONS-",
  //                   width: 12,
  //                   styles: PosStyles(
  //                       width: PosTextSize.size1,
  //                       height: PosTextSize.size1,
  //                       align: PosAlign.center))
  //             ]);
  //           }
  //           printer.row([
  //             PosColumn(text: '', width: 1),
  //             PosColumn(text: addonItem.name!, width: 9),
  //             // PosColumn(
  //             // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //             PosColumn(
  //                 text:  double.parse(addonItem.price.toString()).toStringAsFixed(2),
  //                 width: 2,
  //                 styles: PosStyles(align: PosAlign.right)),
  //           ]);
  //         }
  //       }
  //     } else if (category == 'HALF_N_HALF') {
  //       Cart cartItem = cart[itemIndex];
  //       printer.row([
  //         PosColumn(
  //             text: "-HALF & HALF-",
  //             width: 12,
  //             styles: PosStyles(
  //                 width: PosTextSize.size1,
  //                 height: PosTextSize.size1,
  //                 align: PosAlign.center))
  //       ]);
  //       printer.row([
  //         PosColumn(text: cartItem.quantity.toString(), width: 1),
  //         PosColumn(
  //             text: menuCategory!.name +
  //                 (cartItem.size != null ? '(${cartItem.size?.sizeName})' : ''),
  //             width: 9,
  //             styles: PosStyles(
  //                 width: PosTextSize.size1, height: PosTextSize.size1)),
  //         // PosColumn(
  //         // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //         PosColumn(
  //             text: cartItem.totalAmount.toString(),
  //             width: 2,
  //             styles: PosStyles(align: PosAlign.right)),
  //       ]);
  //
  //       for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
  //         Menu menuItem = menu[menuIndex];
  //         printer.row([
  //           PosColumn(
  //               text: ' ${menuIndex == 0 ? '-1st Half-' : "-2nd Half-"}',
  //               width: 12,
  //               styles: PosStyles(
  //                   width: PosTextSize.size1,
  //                   height: PosTextSize.size1,
  //                   align: PosAlign.center))
  //         ]);
  //         printer.row([
  //           PosColumn(text: '', width: 1),
  //           PosColumn(text: menuItem.name! + '', width: 9),
  //           // PosColumn(
  //           // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //           PosColumn(
  //               text: '', width: 2, styles: PosStyles(align: PosAlign.right)),
  //         ]);
  //
  //         for (int addonIndex = 0;
  //             addonIndex < menuItem.addons!.length;
  //             addonIndex++) {
  //           Addon addonItem = menuItem.addons![addonIndex];
  //           if (addonIndex == 0) {
  //             printer.row([
  //               PosColumn(
  //                   text: "-ADDONS-",
  //                   width: 12,
  //                   styles: PosStyles(
  //                       width: PosTextSize.size1,
  //                       height: PosTextSize.size1,
  //                       align: PosAlign.center))
  //             ]);
  //           }
  //           printer.row([
  //             PosColumn(text: '', width: 1),
  //             PosColumn(text: addonItem.name!, width: 9),
  //             // PosColumn(
  //             // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //             PosColumn(
  //                 text: addonItem.price.toString(),
  //                 width: 2,
  //                 styles: PosStyles(align: PosAlign.right)),
  //           ]);
  //         }
  //       }
  //     } else if (category == 'DEALS') {
  //       Cart cartItem = cart[itemIndex];
  //
  //       printer.row([
  //         PosColumn(
  //             text: "-DEALS-",
  //             width: 12,
  //             styles: PosStyles(
  //                 width: PosTextSize.size1,
  //                 height: PosTextSize.size1,
  //                 align: PosAlign.center))
  //       ]);
  //       printer.row([
  //         PosColumn(text: cartItem.quantity.toString(), width: 1),
  //         PosColumn(
  //             text: menuCategory!.name +
  //                 (cartItem.size != null ? '(${cartItem.size?.sizeName})' : ''),
  //             width: 9,
  //             styles: PosStyles(
  //                 width: PosTextSize.size1, height: PosTextSize.size1)),
  //         // PosColumn(
  //         // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //         PosColumn(
  //             text: cartItem.totalAmount.toString(),
  //             width: 2,
  //             styles: PosStyles(align: PosAlign.right)),
  //       ]);
  //       for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
  //         Menu menuItem = menu[menuIndex];
  //         DealsItems dealsItems = menu[menuIndex].dealsItems!;
  //         printer.row([
  //           PosColumn(
  //               text: "-${menuItem.name}(${dealsItems.name})-",
  //               width: 12,
  //               styles: PosStyles(
  //                   width: PosTextSize.size1,
  //                   height: PosTextSize.size1,
  //                   align: PosAlign.center))
  //         ]);
  //         for (int addonIndex = 0;
  //             addonIndex < menuItem.addons!.length;
  //             addonIndex++) {
  //           Addon addonItem = menuItem.addons![addonIndex];
  //           if (addonIndex == 0) {
  //             printer.row([
  //               PosColumn(width: 1),
  //               PosColumn(
  //                   text: "        -ADDONS-",
  //                   width: 9,
  //                   styles: PosStyles(
  //                       width: PosTextSize.size1,
  //                       height: PosTextSize.size1,
  //                       align: PosAlign.center)),
  //               PosColumn(width: 2),
  //             ]);
  //           }
  //           printer.row([
  //             PosColumn(text: '', width: 1),
  //             PosColumn(text: addonItem.name!, width: 9),
  //             // PosColumn(
  //             // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //             PosColumn(
  //                 text: addonItem.price.toString(),
  //                 width: 2,
  //                 styles: PosStyles(align: PosAlign.right)),
  //           ]);
  //         }
  //       }
  //     }
  //   }
  //   printer.hr();
  //
  //   printer.row([
  //     PosColumn(
  //         text: 'SubTotal',
  //         width: 6,
  //         styles: PosStyles(
  //           height: PosTextSize.size1,
  //           width: PosTextSize.size1,
  //         )),
  //     PosColumn(
  //         text: "$currencySymbol${orderData.subTotal!.toStringAsFixed(2)}",
  //         width: 6,
  //         styles: PosStyles(
  //           align: PosAlign.right,
  //           height: PosTextSize.size1,
  //           width: PosTextSize.size1,
  //         )),
  //   ]);
  //
  //   printer.row([
  //     PosColumn(
  //         text: 'Tax',
  //         width: 6,
  //         styles: PosStyles(
  //           height: PosTextSize.size1,
  //           width: PosTextSize.size1,
  //         )),
  //     PosColumn(
  //         text: "$currencySymbol${orderData.tax!.toStringAsFixed(2)}",
  //         width: 6,
  //         styles: PosStyles(
  //           align: PosAlign.right,
  //           height: PosTextSize.size1,
  //           width: PosTextSize.size1,
  //         )),
  //   ]);
  //
  //   if (double.parse(orderData.amount.toString()) != double.parse(totalAmountController.text)) {
  //     printer.row([
  //       PosColumn(
  //           text:
  //               'Discount ${_selectedButton == 0 ? "5%" : _selectedButton == 1 ? "10%" : _selectedButton == 2 ? "15%" : ''}',
  //           width: 6,
  //           styles: PosStyles(
  //             height: PosTextSize.size1,
  //             width: PosTextSize.size1,
  //           )),
  //       PosColumn(
  //           text:
  //               "$currencySymbol${((double.parse(orderData.amount.toString())) - (double.parse(totalAmountController.text.toString()))).toStringAsFixed(2)}",
  //           width: 6,
  //           styles: PosStyles(
  //             align: PosAlign.right,
  //             height: PosTextSize.size1,
  //             width: PosTextSize.size1,
  //           )),
  //     ]);
  //   }
  //
  //   printer.row([
  //     PosColumn(
  //         text: 'TOTAL',
  //         width: 6,
  //         styles: PosStyles(
  //           height: PosTextSize.size2,
  //           width: PosTextSize.size2,
  //         )),
  //     PosColumn(
  //         text: "$currencySymbol${double.parse(orderData.amount.toString()).toStringAsFixed(2)}",
  //         width: 6,
  //         styles: PosStyles(
  //           align: PosAlign.right,
  //           height: PosTextSize.size2,
  //           width: PosTextSize.size2,
  //         )),
  //   ]);
  //
  //   printer.hr();
  //
  //   if (orderData.notes != null &&
  //       orderData.notes!.isNotEmpty &&
  //       orderData.notes != '') {
  //     printer.text(
  //       "Instructions: ${orderData.notes!}",
  //     );
  //   }
  //
  //   printer.hr(ch: '=', linesAfter: 1);
  //
  //   printer.feed(2);
  //   printer.text('Thank you!',
  //       styles: PosStyles(align: PosAlign.center, bold: true));
  //
  //   // Print QR Code from image
  //   // try {
  //   //   const String qrData = 'example.com';
  //   //   const double qrSize = 200;
  //   //   final uiImg = await QrPainter(
  //   //     data: qrData,
  //   //     version: QrVersions.auto,
  //   //     gapless: false,
  //   //   ).toImageData(qrSize);
  //   //   final dir = await getTemporaryDirectory();
  //   //   final pathName = '${dir.path}/qr_tmp.png';
  //   //   final qrFile = File(pathName);
  //   //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
  //   //   final img = decodeImage(imgFile.readAsBytesSync());
  //
  //   //   printer.image(img);
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  //
  //   // Print QR Code using native function
  //   // printer.qrcode('example.com');
  //
  //   printer.feed(1);
  //   printer.cut();
  //   printer.beep();
  // }
  //
  // void testPrintKitchen(String printerIp, int port, BuildContext ctx,
  //     OrderData orderData ) async {
  //   // TODO Don't forget to choose printer's paper size
  //   const PaperSize paper = PaperSize.mm80;
  //   final profile = await CapabilityProfile.load();
  //   final printer = NetworkPrinter(paper, profile);
  //   final PosPrintResult res = await printer.connect(
  //     printerIp,
  //     port: port,
  //   );
  //   Get.snackbar("", res.msg);
  //
  //   // final snackBar =
  //   // SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
  //   // ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
  //
  //   // print('Print result: ${res.msg}');
  //
  //   if (res == PosPrintResult.success) {
  //     // DEMO RECEIPT
  //     print("--------Kithcen PRint-------");
  //     print(
  //         'Print ip pos result: ${_printerController.printerModel.value.ipPos}');
  //     print(
  //         'Print ip posport result: ${_printerController.printerModel.value.portPos}');
  //     print(
  //         'Print ip kitchen result: ${_printerController.printerModel.value.ipKitchen}');
  //     print(
  //         'Print ip kitchenport result: ${_printerController.printerModel.value.portKitchen}');
  //     print("---------------");
  //     print('Print ip kitchen result: ${printerIp}');
  //     print('Print ip kitchenport result: ${port}');
  //     print("---------------");
  //     printKitchenReceipt(printer, orderData);
  //
  //     // TEST PRINT
  //     // await testReceipt(printer);
  //     printer.disconnect();
  //   } else {
  //     print("--------NO-------");
  //     print("--------$printerIp-------");
  //     print("--------$port-------");
  //   }
  // }
  //
  // printKitchenReceipt(NetworkPrinter printer,OrderData orderData ) {
  //   // // Print image
  //   // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
  //   // final Uint8List bytes = data.buffer.asUint8List();
  //   // final img.Image? image = img.decodeImage(bytes);
  //   // printer.image(image!);
  //   List<Cart> cart = orderData.item!.cart!;
  //   // printer.text("*** PRINT ***",
  //   //     styles: PosStyles(
  //   //       align: PosAlign.center,
  //   //       height: PosTextSize.size2,
  //   //       width: PosTextSize.size2,
  //   //       reverse: true
  //   //     ),);
  //
  //   printer.text("*** Kitchen ***",
  //       styles: PosStyles(
  //         align: PosAlign.center,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ),
  //       linesAfter: 1);
  //
  //   // printer.text('${cartMaster.oldOrderId?.toString()}',
  //   //     styles: PosStyles(
  //   //       align: PosAlign.center,
  //   //       height: PosTextSize.size2,
  //   //       width: PosTextSize.size2,
  //   //     ));
  //
  //   if (orderData.tableNo != null && orderData.tableNo != 0 && orderData.tableNo!.isNotEmpty) {
  //     printer.text('Table ${orderData.tableNo}',
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //           height: PosTextSize.size2,
  //           width: PosTextSize.size2,
  //         ),
  //         linesAfter: 1);
  //   }
  //
  //   if (orderData.userName != null  && orderData.mobile != null) {
  //     printer.text('Customer Name : ${orderData.userName }',
  //         styles: PosStyles(align: PosAlign.left));
  //
  //     printer.text('Customer Phone No : ${orderData.mobile}',
  //         styles: PosStyles(align: PosAlign.left));
  //   }
  //
  //   printer.text("Order Id ${orderData.orderId.toString()}",
  //       styles: PosStyles(align: PosAlign.left));
  //
  //   printer.text('${DateFormat('yyyy-MM-dd').format(orderData.date!)} ${orderData.time}',
  //       styles: PosStyles(align: PosAlign.left));
  //
  //   if (orderData.paymentType == "INCOMPLETE ORDER") {
  //     printer.text('Payment Status : Unpaid',
  //         styles: PosStyles(align: PosAlign.left));
  //   } else {
  //     printer.text('Payment Status : ${orderData.paymentType}',
  //         styles: PosStyles(align: PosAlign.left));
  //     // printer.text('Payment Status : Paid',
  //     //     styles: PosStyles(align: PosAlign.left));
  //   }
  //
  //   printer.text("Order Type : ${orderData.deliveryType}",
  //       styles: PosStyles(align: PosAlign.left));
  //
  //   // printer.text('Web: www.example.com',
  //   //     styles: PosStyles(align: PosAlign.center), linesAfter: 1);
  //
  //   // printer.hr();
  //   // printer.text(widget.orderDeliveryType!,
  //   //   styles: PosStyles(
  //   //     align: PosAlign.center,
  //   //     height: PosTextSize.size3,
  //   //     width: PosTextSize.size3,
  //   //   ),);
  //   printer.hr();
  //   printer.row([
  //     PosColumn(text: 'Qty', width: 2),
  //     PosColumn(text: 'Item', width: 10),
  //   ]);
  //   for (int itemIndex = 0; itemIndex < cart.length; itemIndex++) {
  //     String category = cart[itemIndex].category!;
  //     MenuCategory? menuCategory = cart[itemIndex].menuCategory;
  //     List<Menu> menu = cart[itemIndex].menu!;
  //     if (category == 'SINGLE') {
  //       Cart cartItem = cart[itemIndex];
  //
  //       for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
  //         Menu menuItem = menu[menuIndex];
  //         printer.row([
  //           PosColumn(
  //               text: cartItem.quantity.toString(),
  //               width: 2,
  //               styles: PosStyles(bold: true)),
  //           PosColumn(
  //               text: menu[menuIndex].name! +
  //                   (cart[itemIndex].size != null
  //                       ? '(${cart[itemIndex].size?.sizeName})'
  //                       : ''),
  //               width: 10,
  //               styles: PosStyles(
  //                   width: PosTextSize.size1,
  //                   height: PosTextSize.size1,
  //                   align: PosAlign.left,
  //                   bold: true)),
  //         ]);
  //         for (int addonIndex = 0;
  //             addonIndex < menuItem.addons!.length;
  //             addonIndex++) {
  //           Addon addonItem = menuItem.addons![addonIndex];
  //           if (addonIndex == 0) {
  //             printer.row([
  //               PosColumn(
  //                   text: "-ADDONS-",
  //                   width: 12,
  //                   styles: PosStyles(
  //                       width: PosTextSize.size1,
  //                       height: PosTextSize.size1,
  //                       align: PosAlign.center))
  //             ]);
  //           }
  //           printer.row([
  //             PosColumn(text: '', width: 2),
  //             PosColumn(text: addonItem.name!, width: 10),
  //             // PosColumn(
  //             // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //           ]);
  //         }
  //       }
  //     } else if (category == 'HALF_N_HALF') {
  //       Cart cartItem = cart[itemIndex];
  //       printer.row([
  //         PosColumn(
  //             text: "-HALF & HALF-",
  //             width: 12,
  //             styles: PosStyles(
  //                 width: PosTextSize.size1,
  //                 height: PosTextSize.size1,
  //                 align: PosAlign.center))
  //       ]);
  //       printer.row([
  //         PosColumn(text: cartItem.quantity.toString(), width: 1),
  //         PosColumn(
  //             text: menuCategory!.name +
  //                 (cartItem.size != null ? '(${cartItem.size?.sizeName})' : ''),
  //             width: 9,
  //             styles: PosStyles(
  //                 width: PosTextSize.size1, height: PosTextSize.size1)),
  //         // PosColumn(
  //         // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //         PosColumn(
  //             text: cartItem.totalAmount.toString(),
  //             width: 2,
  //             styles: PosStyles(align: PosAlign.right)),
  //       ]);
  //       for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
  //         Menu menuItem = menu[menuIndex];
  //         printer.row([
  //           PosColumn(
  //               text: ' ${menuIndex == 0 ? '-1st Half-' : "-2nd Half-"}',
  //               width: 12,
  //               styles: PosStyles(
  //                   width: PosTextSize.size1,
  //                   height: PosTextSize.size1,
  //                   align: PosAlign.center))
  //         ]);
  //         printer.row([
  //           PosColumn(text: '', width: 1),
  //           PosColumn(text: menuItem.name! + '', width: 9),
  //           // PosColumn(
  //           // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //           PosColumn(
  //               text: '', width: 2, styles: PosStyles(align: PosAlign.right)),
  //         ]);
  //
  //         for (int addonIndex = 0;
  //             addonIndex < menuItem.addons!.length;
  //             addonIndex++) {
  //           Addon addonItem = menuItem.addons![addonIndex];
  //           if (addonIndex == 0) {
  //             printer.row([
  //               PosColumn(
  //                   text: "-ADDONS-",
  //                   width: 12,
  //                   styles: PosStyles(
  //                       width: PosTextSize.size1,
  //                       height: PosTextSize.size1,
  //                       align: PosAlign.center))
  //             ]);
  //           }
  //           printer.row([
  //             PosColumn(text: '', width: 1),
  //             PosColumn(text: addonItem.name!, width: 9),
  //             // PosColumn(
  //             // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //             PosColumn(
  //                 text: addonItem.price.toString(),
  //                 width: 2,
  //                 styles: PosStyles(align: PosAlign.right)),
  //           ]);
  //         }
  //       }
  //     } else if (category == 'DEALS') {
  //       Cart cartItem = cart[itemIndex];
  //
  //       printer.row([
  //         PosColumn(
  //             text: "-DEALS-",
  //             width: 12,
  //             styles: PosStyles(
  //                 width: PosTextSize.size1,
  //                 height: PosTextSize.size1,
  //                 align: PosAlign.center))
  //       ]);
  //       printer.row([
  //         PosColumn(text: cartItem.quantity.toString(), width: 1),
  //         PosColumn(
  //             text: menuCategory!.name +
  //                 (cartItem.size != null ? '(${cartItem.size?.sizeName})' : ''),
  //             width: 9,
  //             styles: PosStyles(
  //                 width: PosTextSize.size1, height: PosTextSize.size1)),
  //         // PosColumn(
  //         // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //         PosColumn(
  //             text: cartItem.totalAmount.toString(),
  //             width: 2,
  //             styles: PosStyles(align: PosAlign.right)),
  //       ]);
  //       for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
  //         Menu menuItem = menu[menuIndex]!;
  //         DealsItems dealsItems = menu[menuIndex].dealsItems!;
  //         printer.row([
  //           PosColumn(
  //               text: "-${menuItem.name}(${dealsItems.name})-",
  //               width: 12,
  //               styles: PosStyles(
  //                   width: PosTextSize.size1,
  //                   height: PosTextSize.size1,
  //                   align: PosAlign.center))
  //         ]);
  //         for (int addonIndex = 0;
  //             addonIndex < menuItem.addons!.length;
  //             addonIndex++) {
  //           Addon addonItem = menuItem.addons![addonIndex];
  //           if (addonIndex == 0) {
  //             printer.row([
  //               PosColumn(width: 1),
  //               PosColumn(
  //                   text: "        -ADDONS-",
  //                   width: 9,
  //                   styles: PosStyles(
  //                       width: PosTextSize.size1,
  //                       height: PosTextSize.size1,
  //                       align: PosAlign.center)),
  //               PosColumn(width: 2),
  //             ]);
  //           }
  //           printer.row([
  //             PosColumn(text: '', width: 1),
  //             PosColumn(text: addonItem.name!, width: 9),
  //             // PosColumn(
  //             // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //             PosColumn(
  //                 text: addonItem.price.toString(),
  //                 width: 2,
  //                 styles: PosStyles(align: PosAlign.right)),
  //           ]);
  //         }
  //       }
  //     }
  //   }
  //   // printer.hr();
  //
  //   // printer.row([
  //   //   PosColumn(
  //   //       text: 'TOTAL',
  //   //       width: 6,
  //   //       styles: PosStyles(
  //   //         height: PosTextSize.size2,
  //   //         width: PosTextSize.size2,
  //   //       )),
  //   //   PosColumn(
  //   //       text: "$currencySymbol${totalAmountController.text}",
  //   //       width: 6,
  //   //       styles: PosStyles(
  //   //         align: PosAlign.right,
  //   //         height: PosTextSize.size2,
  //   //         width: PosTextSize.size2,
  //   //       )),
  //   // ]);
  //   printer.hr();
  //
  //   if (orderData.notes != null &&
  //       orderData.notes!.isNotEmpty &&
  //       orderData.notes != '') {
  //     printer.text(
  //       "Instructions: ${orderData.notes!}",
  //     );
  //   }
  //
  //   printer.hr(ch: '=', linesAfter: 1);
  //
  //   printer.feed(2);
  //   printer.text('Thank you!',
  //       styles: PosStyles(align: PosAlign.center, bold: true));
  //
  //   // Print QR Code from image
  //   // try {
  //   //   const String qrData = 'example.com';
  //   //   const double qrSize = 200;
  //   //   final uiImg = await QrPainter(
  //   //     data: qrData,
  //   //     version: QrVersions.auto,
  //   //     gapless: false,
  //   //   ).toImageData(qrSize);
  //   //   final dir = await getTemporaryDirectory();
  //   //   final pathName = '${dir.path}/qr_tmp.png';
  //   //   final qrFile = File(pathName);
  //   //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
  //   //   final img = decodeImage(imgFile.readAsBytesSync());
  //
  //   //   printer.image(img);
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  //
  //   // Print QR Code using native function
  //   // printer.qrcode('example.com');
  //
  //   printer.feed(1);
  //   printer.cut();
  //   printer.beep();
  // }

  // int _selectedButton = -1;
  // void _updatePrice(int buttonIndex) {
  //     setState(() {
  //       _selectedButton = buttonIndex;
  //       switch (buttonIndex) {
  //         case 0:
  //           calculateDiscount(0.05, 0);
  //           break;
  //         case 1:
  //           calculateDiscount(0.10, 1);
  //           break;
  //         case 2:
  //           calculateDiscount(0.15, 2);
  //           break;
  //       }
  //     });
  //
  // }

  int _selectedButton = -1;

  void _updatePrice(int buttonIndex) {
    if (_cartController
        .cartMaster?.oldOrderId ==
        null &&
        widget.orderDeliveryType == 'DINING') {
      Get.snackbar("Message", 'Discounts available at the end of the order');
    } else {
      setState(() {
        // If the same button is selected again, unselect it
        if (_selectedButton == buttonIndex || _selectedButton == 3) {
          _selectedButton = -1;
          // Restore original total price and clear text field
          totalAmountController.text = widget.totalAmount.toStringAsFixed(2);
          discount = 0;
        } else {
          if (_selectedButton != -1 && _selectedButton != 3) {
            // Subtract the previous discount from original total price
            double discountedTotal = double.parse(totalAmountController.text) +
                (widget.totalAmount * getDiscountPercentage(_selectedButton));
            // Save the discounted total as the new original total price
            widget.totalAmount = discountedTotal;
            totalAmountController.text = widget.totalAmount.toStringAsFixed(2);
          } else {
            // Save the original total price
            widget.totalAmount = double.parse(totalAmountController.text);
          }
          _selectedButton = buttonIndex;
          // Apply the new discount to the total price
          double discountedPrice = widget.totalAmount -
              (widget.totalAmount * getDiscountPercentage(_selectedButton));
          totalAmountController.text = discountedPrice.toStringAsFixed(2);
          discount =
              widget.totalAmount * getDiscountPercentage(_selectedButton);
        }
      });
    }
  }

  double getDiscountPercentage(int selectedButton) {
    switch (selectedButton) {
      case 0:
        return 0.05;
      case 1:
        return 0.10;
      case 2:
        return 0.15;
      case 3:
        return 0.00;
      default:
        return 0.0;
    }
  }

  // int _selectedButton = -1;
  // void _updatePrice(int buttonIndex) {
  //   setState(() {
  //     // If the same button is selected again, unselect it
  //     // if (_selectedButton == buttonIndex) {
  //     //   _selectedButton = -1;
  //     // } else {
  //     //   _selectedButton = buttonIndex;
  //     // }
  //     // Call calculateDiscount function with the selected button index
  //     if (_selectedButton == buttonIndex) {
  //       // Deselect the button and add the discounted amount back to the total amount
  //       _selectedButton = -1;
  //        double discountedAmount = widget.totalAmount - double.parse(totalAmountController.text);
  //       widget.totalAmount += discountedAmount;
  //     } else {
  //       // Select a button and subtract the discount from the total amount
  //       if (_selectedButton != -1) {
  //         // If another button is already selected, add the discounted amount back to the total amount
  //         double discountedAmount = widget.totalAmount -
  //             double.parse(totalAmountController.text);
  //         widget.totalAmount += discountedAmount;
  //       }
  //       _selectedButton = buttonIndex;
  //       double discountPercentageValue = 0.0;
  //       switch (buttonIndex) {
  //         case 0:
  //           discountPercentageValue = 0.05;
  //           break;
  //         case 1:
  //           discountPercentageValue = 0.10;
  //           break;
  //         case 2:
  //           discountPercentageValue = 0.15;
  //           break;
  //       }
  //       widget.totalAmount = double.parse(totalAmountController.text);
  //       double discountAmount = widget.totalAmount * discountPercentageValue;
  //       double discountedTotal = widget.totalAmount - discountAmount;
  //       widget.totalAmount -= discountAmount;
  //       totalAmountController.text = discountedTotal.toStringAsFixed(2);
  //       // calculateDiscount(_selectedButton);
  //     }
  //   });
  // }
  //
  // calculateDiscount(int selectedButton) {
  //   double discountPercentageValue = 0.0;
  //   switch (selectedButton) {
  //     case 0:
  //       discountPercentageValue = 0.05;
  //       break;
  //     case 1:
  //       discountPercentageValue = 0.10;////
  //       break;
  //     case 2:
  //       discountPercentageValue = 0.15;
  //       break;
  //   }

  //   double totalAmount = double.parse(totalAmountController.text);
  //   double discountAmount = totalAmount * discountPercentageValue;
  //   double discountedTotal = totalAmount - discountAmount;
  //   // Update the total amount with the discounted value
  //   totalAmountController.text = discountedTotal.toStringAsFixed(2);
  // }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _linklyDataController.timer?.cancel();
    _linklyDataController.resetVariables();
    _linklyDataController.showDialogvalue.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
          resizeToAvoidBottomInset: false,
          body:  Stack(
                alignment: Alignment.center,
                children: [

            LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: constraints.maxWidth > 600
                  ?
                        Container(
                            margin: EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                   child: Row(
                                     children: [
                                       Flexible(
                                         child: Obx(() => SwitchListTile(
                                           title: Text(_autoPrinterController.autoPrintKitchen.value == true ? 'Kitchen Print ON' : 'Kitchen OFF'),
                                           value: _autoPrinterController.autoPrintKitchen.value,
                                           onChanged: (bool value) {
                                             _autoPrinterController.saveAutoPrintKitchen(value);
                                           },
                                         )),
                                       ),
                                       Flexible(
                                            child: Obx(() => SwitchListTile(
                                           title: Text(_autoPrinterController.autoPrint.value == true ? 'POS Print ON' : 'POS OFF'),
                                           value: _autoPrinterController.autoPrint.value,
                                           onChanged: (bool value) {
                                             _autoPrinterController.saveAutoPrint(value);
                                           },
                                         )),
                                       ),
                                     ],
                                   ),
                                 ),
                                      // Text("Old...${_cartController.cartMaster!.oldOrderId}"),
                                      Expanded(
                                   flex: 5,
                                   child: Container(),
                                 ),

                                 GestureDetector(
                                   onTap: () {
                                     Get.back();
                                   },

                                   child: Container(
                                       decoration: BoxDecoration(
                                         shape: BoxShape.circle,
                                         color: Color(0xFFff6565),
                                       ),
                                       child: Padding(
                                         padding: const EdgeInsets.all(3),
                                         child: Icon(
                                           Icons.clear,
                                           grade: 3,
                                           size: 16,
                                           color: Colors.white,
                                         ),
                                       )),
                                 ),
                                    ],
                                  ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Row(children: [
                                      Expanded(
                                        flex: 1,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(Constants.colorTheme)),
                                          onPressed: () {},
                                          child: Text(
                                            "Total",
                                            style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: TextFormField(
                                          style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          readOnly: true,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                                          ],
                                          decoration: InputDecoration(),
                                          controller: totalAmountController,
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Expanded(
                                        flex: 1,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(Constants.colorTheme)),
                                          onPressed: () {},
                                          child: Text(
                                            'Received',
                                            style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: TextFormField(
                                          style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                                          ],
                                          decoration: InputDecoration(),
                                          onChanged: (String? val) {
                                            calculateChanged();
                                          },
                                          // validator: (String? value) {
                                          //   // if (value!.isEmpty) {
                                          //   //   return 'Please Enter Amount';
                                          //   // }
                                          // },
                                          controller: receivedController,
                                        ),
                                      ),
                                    ]),
                                    Row(children: [
                                      Expanded(
                                        flex: 1,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(Constants.colorTheme)),
                                          onPressed: () {},
                                          child: Text(
                                            'Changed',
                                            style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: TextFormField(
                                          style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          readOnly: true,

                                          decoration: InputDecoration(),
                                          controller: changedController,
                                        ),
                                      ),
                                    ]),

                                    // SizedBox(
                                    //   width: Get.width * 0.3,
                                    //   child: Text(
                                    //     'Total',
                                    //     maxLines: 2,
                                    //     style: TextStyle(
                                    //         fontSize: 35,
                                    //         color: Color(Constants.colorTheme)),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              NumberButton(
                                                  height: 0.09,
                                                  btnColor: Colors.red.shade600,
                                                  value: '5',
                                                  onTapped: () {
                                                    receivedController.text =
                                                        addStringIntoInt(5);
                                                    calculateChanged();
                                                  }),
                                              NumberButton(
                                                  height: 0.09,
                                                  btnColor: Colors.red.shade600,
                                                  value: '10',
                                                  onTapped: () {
                                                    receivedController.text =
                                                        addStringIntoInt(10);
                                                    calculateChanged();
                                                  }),
                                              NumberButton(
                                                  height: 0.09,
                                                  btnColor: Colors.red.shade600,
                                                  value: '20',
                                                  onTapped: () {
                                                    receivedController.text =
                                                        addStringIntoInt(20);
                                                    calculateChanged();
                                                  }),
                                              NumberButton(
                                                  height: 0.09,
                                                  btnColor: Colors.red.shade600,
                                                  value: '50',
                                                  onTapped: () {
                                                    receivedController.text =
                                                        addStringIntoInt(50);
                                                    calculateChanged();
                                                  }),
                                              NumberButton(
                                                  height: 0.09,
                                                  btnColor: Colors.red.shade600,
                                                  value: '100',
                                                  onTapped: () {
                                                    receivedController.text =
                                                        addStringIntoInt(100);
                                                    calculateChanged();
                                                  }),

                                              // ElevatedButton(
                                              //   onPressed: () {
                                              //     receivedController.text =
                                              //         addStringIntoInt(10);
                                              //     calculateChanged();
                                              //   },
                                              //   child: const Text(
                                              //     "10",
                                              //     textAlign: TextAlign.center,
                                              //     style: TextStyle(
                                              //         fontSize: 28,
                                              //         fontFamily: 'Dosis',
                                              //         color: Colors.white,
                                              //         fontWeight: FontWeight.normal),
                                              //   ),
                                              // ),
                                              // ElevatedButton(
                                              //   onPressed: () {
                                              //     receivedController.text =
                                              //         addStringIntoInt(20);
                                              //     calculateChanged();
                                              //   },
                                              //   child: const Text(
                                              //     "20",
                                              //     textAlign: TextAlign.center,
                                              //     style: TextStyle(
                                              //         fontSize: 28,
                                              //         fontFamily: 'Dosis',
                                              //         color: Colors.white,
                                              //         fontWeight: FontWeight.normal),
                                              //   ),
                                              // ),
                                              // ElevatedButton(
                                              //   onPressed: () {
                                              //     receivedController.text =
                                              //         addStringIntoInt(50);
                                              //     calculateChanged();
                                              //   },
                                              //   child: const Text(
                                              //     '50',
                                              //     textAlign: TextAlign.center,
                                              //     style: TextStyle(
                                              //         fontSize: 28,
                                              //         fontFamily: 'Dosis',
                                              //         color: Colors.white,
                                              //         fontWeight: FontWeight.normal),
                                              //   ),
                                              // ),
                                              // ElevatedButton(
                                              //   onPressed: () {
                                              //     receivedController.text =
                                              //         addStringIntoInt(100);
                                              //     calculateChanged();
                                              //   },
                                              //   child: const Text(
                                              //     "100",
                                              //     textAlign: TextAlign.center,
                                              //     style: TextStyle(
                                              //         fontSize: 28,
                                              //         fontFamily: 'Dosis',
                                              //         color: Colors.white,
                                              //         fontWeight: FontWeight.normal),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: NumberButton(
                                                          value: '1',
                                                          onTapped: () {
                                                            receivedController.text +=
                                                                "1";
                                                            calculateChanged();
                                                          }),
                                                    ),
                                                    Expanded(
                                                      child: NumberButton(
                                                          value: '2',
                                                          onTapped: () {
                                                            receivedController.text +=
                                                                "2";
                                                            calculateChanged();
                                                          }),
                                                    ),
                                                    Expanded(
                                                      child: NumberButton(
                                                          value: '3',
                                                          onTapped: () {
                                                            receivedController.text +=
                                                                "3";
                                                            calculateChanged();
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: NumberButton(
                                                          value: '4',
                                                          onTapped: () {
                                                            receivedController.text +=
                                                                "4";
                                                            calculateChanged();
                                                          }),
                                                    ),
                                                    Expanded(
                                                      child: NumberButton(
                                                          value: '5',
                                                          onTapped: () {
                                                            receivedController.text +=
                                                                "5";
                                                            calculateChanged();
                                                          }),
                                                    ),
                                                    Expanded(
                                                      child: NumberButton(
                                                          value: '6',
                                                          onTapped: () {
                                                            receivedController.text +=
                                                                "6";
                                                            calculateChanged();
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: NumberButton(
                                                          value: '7',
                                                          onTapped: () {
                                                            receivedController.text +=
                                                                "7";
                                                            calculateChanged();
                                                          }),
                                                    ),
                                                    Expanded(
                                                      child: NumberButton(
                                                          value: '8',
                                                          onTapped: () {
                                                            receivedController.text +=
                                                                "8";
                                                            calculateChanged();
                                                          }),
                                                    ),
                                                    Expanded(
                                                      child: NumberButton(
                                                          value: '9',
                                                          onTapped: () {
                                                            receivedController.text +=
                                                                "9";
                                                            calculateChanged();
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: NumberButton(
                                                          value: '.',
                                                          onTapped: () {
                                                            receivedController.text +=
                                                                ".";
                                                            calculateChanged();
                                                          }),
                                                    ),
                                                    Expanded(
                                                      child: NumberButton(
                                                          value: '0',
                                                          onTapped: () {
                                                            receivedController.text +=
                                                                "0";
                                                            calculateChanged();
                                                          }),
                                                    ),
                                                    Expanded(
                                                      child: NumberButton(
                                                          value: 'X',
                                                          onTapped: () {
                                                            if (receivedController
                                                                .text.isNotEmpty) {
                                                              receivedController.text =
                                                                  receivedController.text
                                                                      .substring(
                                                                          0,
                                                                          receivedController
                                                                                  .text
                                                                                  .length -
                                                                              1);
                                                              calculateChanged();
                                                            }
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                NumberButton(
                                                    value: '5% Discount',
                                                    btnColor: _selectedButton == 0 ||
                                                            _selectedButton == -1
                                                        ? Colors.black
                                                        : Colors.grey,
                                                    onTapped: _selectedButton == 0
                                                        ? () {}
                                                        : () => _updatePrice(0)),
                                                NumberButton(
                                                    value: '10% Discount',
                                                    btnColor: _selectedButton == 1 ||
                                                            _selectedButton == -1
                                                        ? Colors.black
                                                        : Colors.grey,
                                                    onTapped: _selectedButton == 1
                                                        ? () {}
                                                        : () => _updatePrice(1)),
                                                NumberButton(
                                                    value: '15% Discount',
                                                    btnColor: _selectedButton == 2 ||
                                                            _selectedButton == -1
                                                        ? Colors.black
                                                        : Colors.grey,
                                                    onTapped: _selectedButton == 2
                                                        ? () {}
                                                        : () => _updatePrice(2)),
                                                NumberButton(
                                                    value: 'Clear Discount',
                                                    btnColor: _selectedButton == 3 ||
                                                            _selectedButton == -1
                                                        ? Colors.black
                                                        : Colors.grey,
                                                    onTapped: _selectedButton == 3 ||
                                                            _selectedButton == -1
                                                        ? () {}
                                                        : () => _updatePrice(3)),
                                              ],
                                            ),),
                                        Expanded(
                                            flex: 1,
                                            child: () {
                                              // if (_cartController
                                              //             .cartMaster?.oldOrderId ==
                                              //         null &&
                                              //     widget.orderDeliveryType == 'DINING') {
                                              //   return Column(
                                              //     children: [
                                              //
                                              //       NumberButton(
                                              //           value: 'Pay Later',
                                              //           btnColor:
                                              //               Color(Constants.colorTheme),
                                              //           onTapped: paymentButtonSelect == true ? (){} :  () {
                                              //             setState(() {
                                              //               paymentButtonSelect = true;
                                              //             });
                                              //             orderPaymentType =
                                              //                 'INCOMPLETE ORDER';
                                              //             placeOrder(1,'');
                                              //             // if (kitchenPort != null) {
                                              //             //   print("kitchen Added");
                                              //             //   if (kitchenIp == '' &&
                                              //             //       kitchenPort == '' ||
                                              //             //       kitchenIp == null &&
                                              //             //           kitchenPort == null) {
                                              //             //     print("kitchen ip empty");
                                              //             //   } else {
                                              //             //     print(
                                              //             //         " kitchen ip not empty");
                                              //             //     testPrintKitchen(
                                              //             //         kitchenIp!,
                                              //             //         kitchenPort!,
                                              //             //         context,
                                              //             //         _cartController
                                              //             //             .cartMaster!);
                                              //             //   }
                                              //             // }
                                              //           }),
                                              //     ],
                                              //   );
                                              // } else


                                                if (
                                                // _cartController
                                                //           .cartMaster?.oldOrderId !=
                                                //       null &&
                                                  widget.orderDeliveryType == 'DINING') {
                                                return Column(
                                                  children: [
                                                    NumberButton(
                                                        value: 'POS CASH',
                                                        btnColor: Colors.black,
                                                        onTapped: () {
                                                          if (_formKey.currentState!
                                                              .validate()) {

                                                            orderPaymentType = 'POS CASH';
                                                            placeOrder(0,'');
                                                          }

                                                          ///Last Changing
                                                          // if (posPort != null) {
                                                          //   print("POS ADDED");
                                                          //   if (posIp == '' &&
                                                          //       posPort == '' ||
                                                          //       posIp == null &&
                                                          //           posPort == null) {
                                                          //     print("pos ip empty");
                                                          //   } else {
                                                          //     print("pos ip not empty");
                                                          //     testPrintPOS(
                                                          //         posIp!,
                                                          //         posPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                          // _cartController.cartMaster = null;
                                                          // _cartController.cartTotalQuantity.value = 0;

                                                          ///fazool
                                                          // if (kitchenPort != null) {
                                                          //   print("kitchen Added");
                                                          //   if (kitchenIp == '' &&
                                                          //           kitchenPort == '' ||
                                                          //       kitchenIp == null &&
                                                          //           kitchenPort == null) {
                                                          //     print("kitchen ip empty");
                                                          //   } else {
                                                          //     print(" kitchen ip not empty");
                                                          //     testPrintKitchen(
                                                          //         kitchenIp!,
                                                          //         kitchenPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                        }),
                                                    NumberButton(
                                                        value: 'POS CARD',
                                                        btnColor:
                                                            Color(Constants.colorTheme),
                                                        onTapped:  () {
                                                          orderPaymentType = 'POS CARD';
                                                          if(_orderCustimizationController.strRestaurantLinkly.value == 1) {
                                                            _linklyDataController.resetVariables();
                                                            var id = _linklyDataController
                                                                .uuid.v4();
                                                            _linklyDataController
                                                                .placeValue
                                                                .value = 0;
                                                            _linklyDataController
                                                                .transactionPayment(
                                                                totalAmountController
                                                                    .text, id,
                                                                placeOrder,
                                                                context).then((
                                                                value) {
                                                              _linklyDataController
                                                                  .dialogTitle
                                                                  .value = '';
                                                              _linklyDataController
                                                                  .dialogContent
                                                                  .value = '';
                                                            });
                                                          } else {
                                                            placeOrder(0, '');
                                                          }



                                                          ///Last Changing
                                                          // if (posPort != null) {
                                                          //   print("POS ADDED");
                                                          //   if (posIp == '' &&
                                                          //           posPort == '' ||
                                                          //       posIp == null &&
                                                          //           posPort == null) {
                                                          //     print("pos ip empty");
                                                          //   } else {
                                                          //     print("pos ip not empty");
                                                          //     testPrintPOS(
                                                          //         posIp!,
                                                          //         posPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                          // _cartController.cartMaster = null;
                                                          // _cartController
                                                          //     .cartTotalQuantity.value = 0;

                                                          ///Fazool
                                                          // if (kitchenPort != null) {
                                                          //   print("kitchen Added");
                                                          //   if (kitchenIp == '' &&
                                                          //           kitchenPort == '' ||
                                                          //       kitchenIp == null &&
                                                          //           kitchenPort == null) {
                                                          //     print("kitchen ip empty");
                                                          //   } else {
                                                          //     print(" kitchen ip not empty");
                                                          //     testPrintKitchen(
                                                          //         kitchenIp!,
                                                          //         kitchenPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                        }),
                                                    NumberButton(
                                                        value: 'CASH + CARD',
                                                        btnColor:
                                                            Color(Constants.colorTheme),
                                                        onTapped:  () {

                                                          orderPaymentType = 'CASH+CARD';
                                                          showMyDialog(context, posCashAmountController,posCardAmountController);

                                                        }),
                                                    NumberButton(
                                                        value: 'Pay Later',
                                                        btnColor:
                                                            Color(Constants.colorTheme),
                                                        onTapped:  () {

                                                          orderPaymentType =
                                                              'INCOMPLETE ORDER';
                                                          placeOrder(1, '');
                                                          // if (kitchenPort != null) {
                                                          //   print("kitchen Added");
                                                          //   if (kitchenIp == '' &&
                                                          //       kitchenPort == '' ||
                                                          //       kitchenIp == null &&
                                                          //           kitchenPort == null) {
                                                          //     print("kitchen ip empty");
                                                          //   } else {
                                                          //     print(
                                                          //         " kitchen ip not empty");
                                                          //     testPrintKitchen(
                                                          //         kitchenIp!,
                                                          //         kitchenPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                          // _cartController.cartMaster = null;
                                                          // _cartController.cartTotalQuantity.value = 0;
                                                        }),
                                                  ],
                                                );
                                              } else if (_cartController
                                                          .cartMaster?.oldOrderId !=
                                                      null &&
                                                  widget.orderDeliveryType ==
                                                      'TAKEAWAY') {
                                                return Column(
                                                  children: [

                                                    NumberButton(
                                                        value: 'POS CASH',
                                                        btnColor: Colors.black,
                                                        onTapped:  () {

                                                          if (_formKey.currentState!
                                                              .validate()) {

                                                            orderPaymentType =
                                                                'POS CASH TAKEAWAY';
                                                            placeOrder(0, '');
                                                          }

                                                          ///Last Changing
                                                          // if (posPort != null) {
                                                          //   print("POS ADDED");
                                                          //   if (posIp == '' &&
                                                          //       posPort == '' ||
                                                          //       posIp == null &&
                                                          //           posPort == null) {
                                                          //     print("pos ip empty");
                                                          //   } else {
                                                          //     print("pos ip not empty");
                                                          //     testPrintPOS(
                                                          //         posIp!,
                                                          //         posPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                          // _cartController.cartMaster = null;
                                                          // _cartController.cartTotalQuantity.value = 0;

                                                          ///fazool
                                                          // if (kitchenPort != null) {
                                                          //   print("kitchen Added");
                                                          //   if (kitchenIp == '' &&
                                                          //           kitchenPort == '' ||
                                                          //       kitchenIp == null &&
                                                          //           kitchenPort == null) {
                                                          //     print("kitchen ip empty");
                                                          //   } else {
                                                          //     print(" kitchen ip not empty");
                                                          //     testPrintKitchen(
                                                          //         kitchenIp!,
                                                          //         kitchenPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                        }),
                                                    NumberButton(
                                                        value: 'POS CARD',
                                                        btnColor:
                                                            Color(Constants.colorTheme),
                                                        onTapped:   () {

                                                          orderPaymentType =
                                                              'POS CARD TAKEAWAY';
                                                          if(_orderCustimizationController.strRestaurantLinkly.value == 1){
                                                          var id = _linklyDataController.uuid.v4();
                                                          _linklyDataController.placeValue.value = 0;
                                                          _linklyDataController.transactionPayment(totalAmountController.text, id, placeOrder, context);
                                                          } else {
                                                            placeOrder(0, '');
                                                          }
                                                          ///Last Changing
                                                          // if (posPort != null) {
                                                          //   print("POS ADDED");
                                                          //   if (posIp == '' &&
                                                          //           posPort == '' ||
                                                          //       posIp == null &&
                                                          //           posPort == null) {
                                                          //     print("pos ip empty");
                                                          //   } else {
                                                          //     print("pos ip not empty");
                                                          //     testPrintPOS(
                                                          //         posIp!,
                                                          //         posPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                          // _cartController.cartMaster = null;
                                                          // _cartController
                                                          //     .cartTotalQuantity.value = 0;

                                                          ///Fazool
                                                          // if (kitchenPort != null) {
                                                          //   print("kitchen Added");
                                                          //   if (kitchenIp == '' &&
                                                          //           kitchenPort == '' ||
                                                          //       kitchenIp == null &&
                                                          //           kitchenPort == null) {
                                                          //     print("kitchen ip empty");
                                                          //   } else {
                                                          //     print(" kitchen ip not empty");
                                                          //     testPrintKitchen(
                                                          //         kitchenIp!,
                                                          //         kitchenPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                        }),
                                                    NumberButton(
                                                        value: 'CASH + CARD',
                                                        btnColor:
                                                        Color(Constants.colorTheme),
                                                        onTapped:  () {

                                                          orderPaymentType = 'CASH+CARD';
                                                          showMyDialog(context, posCashAmountController,posCardAmountController);

                                                        }),
                                                    NumberButton(
                                                        value: 'Pay Later',
                                                        btnColor:
                                                            Color(Constants.colorTheme),
                                                        onTapped:  () {

                                                          print("Takeaway older id");
                                                          orderPaymentType =
                                                              'INCOMPLETE ORDER';
                                                          placeOrder(1, '');
                                                          // testPrintKitchen(
                                                          //     "203.175.78.102",
                                                          //     8888,
                                                          //     context,
                                                          //     _cartController
                                                          //         .cartMaster!);
                                                          // if (kitchenPort != null) {
                                                          //   print("kitchen Added");
                                                          //   if (kitchenIp == '' &&
                                                          //       kitchenPort == '' ||
                                                          //       kitchenIp == null &&
                                                          //           kitchenPort == null) {
                                                          //     print("kitchen ip empty");
                                                          //   } else {
                                                          //     print(
                                                          //         " kitchen ip not empty");
                                                          //     testPrintKitchen(
                                                          //         kitchenIp!,
                                                          //         kitchenPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                          // _cartController.cartMaster = null;
                                                          // _cartController.cartTotalQuantity.value = 0;
                                                        }),
                                                  ],
                                                );
                                              } else {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    // ElevatedButton(
                                                    //   onPressed: () {
                                                    //     receivedController.text =
                                                    //         addStringIntoInt(5);
                                                    //     calculateChanged();
                                                    //   },
                                                    //   child: const Text(
                                                    //     "5",
                                                    //     textAlign: TextAlign.center,
                                                    //     style: TextStyle(
                                                    //         fontSize: 28,
                                                    //         fontFamily: 'Dosis',
                                                    //         color: Colors.white,
                                                    //         fontWeight:
                                                    //             FontWeight.normal),
                                                    //   ),
                                                    // ),
                                                    // ElevatedButton(
                                                    //   onPressed: () {
                                                    //     receivedController.text =
                                                    //         addStringIntoInt(10);
                                                    //     calculateChanged();
                                                    //   },
                                                    //   child: const Text(
                                                    //     "10",
                                                    //     textAlign: TextAlign.center,
                                                    //     style: TextStyle(
                                                    //         fontSize: 28,
                                                    //         fontFamily: 'Dosis',
                                                    //         color: Colors.white,
                                                    //         fontWeight:
                                                    //             FontWeight.normal),
                                                    //   ),
                                                    // ),
                                                    // ElevatedButton(
                                                    //   onPressed: () {
                                                    //     receivedController.text =
                                                    //         addStringIntoInt(20);
                                                    //     calculateChanged();
                                                    //   },
                                                    //   child: const Text(
                                                    //     "20",
                                                    //     textAlign: TextAlign.center,
                                                    //     style: TextStyle(
                                                    //         fontSize: 28,
                                                    //         fontFamily: 'Dosis',
                                                    //         color: Colors.white,
                                                    //         fontWeight:
                                                    //             FontWeight.normal),
                                                    //   ),
                                                    // ),

                                                    NumberButton(
                                                        value: 'POS CASH',
                                                        btnColor: Colors.black,
                                                        onTapped:   () {

                                                          if (_formKey.currentState!
                                                              .validate()) {

                                                            orderPaymentType = 'POS CASH';
                                                            placeOrder(2, '');
                                                          }
                                                          print("********");

                                                          ///Last Changing
                                                          // if (posPort != null) {
                                                          //   print("POS ADDED");
                                                          //   if (posIp == '' &&
                                                          //           posPort == '' ||
                                                          //       posIp == null &&
                                                          //           posPort == null) {
                                                          //     print("pos ip empty");
                                                          //   } else {
                                                          //     print("pos ip not empty");
                                                          //     testPrintPOS(
                                                          //         posIp!,
                                                          //         posPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                          // if (kitchenPort != null) {
                                                          //   print("kitchen Added");
                                                          //   if (kitchenIp == '' &&
                                                          //           kitchenPort == '' ||
                                                          //       kitchenIp == null &&
                                                          //           kitchenPort == null) {
                                                          //     print("kitchen ip empty");
                                                          //   } else {
                                                          //     print(" kitchen ip not empty");
                                                          //     testPrintKitchen(
                                                          //         kitchenIp!,
                                                          //         kitchenPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                          // _cartController.cartMaster = null;
                                                          // _cartController
                                                          //     .cartTotalQuantity.value = 0;

                                                          /// Fazool
                                                          // }
                                                          //
                                                          //     const PaperSize paper = PaperSize.mm80;
                                                          //     final profile = await CapabilityProfile.load();
                                                          //     final printer = NetworkPrinter(paper, profile);
                                                          //
                                                          //     final PosPrintResult res = await printer.connect('192.168.18.62', port: 9100);
                                                          //
                                                          //     if (res == PosPrintResult.success) {
                                                          //       testReceipt(printer);
                                                          //       printer.disconnect();
                                                          //     }
                                                          //
                                                          //     print('Print result: ${res.msg}');
                                                        }),
                                                    NumberButton(
                                                        value: 'POS CARD',
                                                        btnColor:
                                                            Color(Constants.colorTheme),
                                                        onTapped:  () {

                                                          orderPaymentType = 'POS CARD';
                                                          if(_orderCustimizationController.strRestaurantLinkly.value == 1){
                                                          var id = _linklyDataController.uuid.v4();
                                                          _linklyDataController.placeValue.value = 2;
                                                          _linklyDataController.transactionPayment(totalAmountController.text, id, placeOrder, context);
                                                          } else {
                                                            placeOrder(2, '');
                                                          }

                                                          ///Last Changing
                                                          // if (posPort != null) {
                                                          //   print("POS ADDED");
                                                          //   if (posIp == '' &&
                                                          //           posPort == '' ||
                                                          //       posIp == null &&
                                                          //           posPort == null) {
                                                          //     print("pos ip empty");
                                                          //   } else {
                                                          //     print("pos ip not empty");
                                                          //     testPrintPOS(
                                                          //         posIp!,
                                                          //         posPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                          // if (kitchenPort != null) {
                                                          //   print("kitchen Added");
                                                          //   if (kitchenIp == '' &&
                                                          //           kitchenPort == '' ||
                                                          //       kitchenIp == null &&
                                                          //           kitchenPort == null) {
                                                          //     print("kitchen ip empty");
                                                          //   } else {
                                                          //     print(" kitchen ip not empty");
                                                          //     testPrintKitchen(
                                                          //         kitchenIp!,
                                                          //         kitchenPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                          // _cartController.cartMaster = null;
                                                          // _cartController
                                                          //     .cartTotalQuantity.value = 0;
                                                        }),
                                                    NumberButton(
                                                        value: 'CASH + CARD',
                                                        btnColor:
                                                        Color(Constants.colorTheme),
                                                        onTapped:  () {

                                                          orderPaymentType = 'CASH+CARD';
                                                         showMyDialog(context, posCashAmountController,posCardAmountController);

                                                        }),
                                                    NumberButton(
                                                        value: 'Pay Later',
                                                        btnColor:
                                                            Color(Constants.colorTheme),
                                                        onTapped:  () {

                                                          print("Takeaway first older");
                                                          orderPaymentType =
                                                              'INCOMPLETE ORDER';
                                                          placeOrder(1, '');

                                                          ///Last Changing
                                                          // if (kitchenPort != null) {
                                                          //   print("kitchen Added");
                                                          //   if (kitchenIp == '' &&
                                                          //           kitchenPort == '' ||
                                                          //       kitchenIp == null &&
                                                          //           kitchenPort == null) {
                                                          //     print("kitchen ip empty");
                                                          //   } else {
                                                          //     print(" kitchen ip not empty");
                                                          //     testPrintKitchen(
                                                          //         kitchenIp!,
                                                          //         kitchenPort!,
                                                          //         context,
                                                          //         _cartController
                                                          //             .cartMaster!);
                                                          //   }
                                                          // }
                                                          // _cartController.cartMaster = null;
                                                          // _cartController
                                                          //     .cartTotalQuantity.value = 0;
                                                        }),
                                                  ],
                                                );
                                              }
                                            }()),
                                        ///Column
                                        // SizedBox(
                                        //   width: Get.width * 0.1,
                                        //   child: Column(
                                        //     children: [
                                        //       // SizedBox(height: Get.height*0.02,),
                                        //       ShortCutButton(
                                        //         value: '5',
                                        //         onTapped: () {
                                        //           receivedController.text =
                                        //               addStringIntoInt(5);
                                        //           calculateChanged();
                                        //         },
                                        //       ),
                                        //       ShortCutButton(
                                        //         value: '10',
                                        //         onTapped: () {
                                        //           receivedController.text =
                                        //               addStringIntoInt(10);
                                        //           calculateChanged();
                                        //         },
                                        //       ),
                                        //       ShortCutButton(
                                        //         value: '20',
                                        //         onTapped: () {
                                        //           receivedController.text =
                                        //               addStringIntoInt(20);
                                        //           calculateChanged();
                                        //         },
                                        //       ),
                                        //       ShortCutButton(
                                        //         value: '50',
                                        //         onTapped: () {
                                        //           receivedController.text =
                                        //               addStringIntoInt(50);
                                        //           calculateChanged();
                                        //         },
                                        //       ),
                                        //       ShortCutButton(
                                        //         value: '100',
                                        //         onTapped: () {
                                        //           receivedController.text =
                                        //               addStringIntoInt(100);
                                        //           calculateChanged();
                                        //         },
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        ///Changed
                                        // Align(
                                        //   alignment: Alignment.topCenter,
                                        //   child: SizedBox(
                                        //     width: Get.width * 0.9 - 64,
                                        //     child:
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                //       Container(
                                //         child: Row(
                                //           children: [
                                //             Expanded(
                                //               child:  NumberButton(
                                //                   value: '5% Discount',
                                //                   btnColor: isDisabled == true ? Colors.grey : Colors.red.shade500,
                                //                   onTapped: isDisabled == true ? (){} : () {
                                // setState(() {
                                // isDisabled = true;
                                // });
                                // calculateDiscount(0.05);
                                // }),
                                //             ),
                                //             Expanded(
                                //               child:  NumberButton(
                                //                   value: '10% Discount',
                                //                   btnColor: isDisabled == true ? Colors.grey : Colors.red.shade500,
                                //                   onTapped: isDisabled == true ? (){} : () {
                                //                     setState(() {
                                //                       isDisabled = true;
                                //                     });
                                //                     calculateDiscount(0.010);
                                //                   }),
                                //             ),
                                //             Expanded(
                                //               child:  NumberButton(
                                //                   value: '15% Discount',
                                //                   btnColor: isDisabled == true ? Colors.grey : Colors.red.shade500,
                                //                   onTapped: isDisabled == true ? (){} : () {
                                //                     setState(() {
                                //                       isDisabled = true;
                                //                     });
                                //                     calculateDiscount(0.015);
                                //                   }),
                                //             ),
                                //           ],
                                //         ),
                                //       )
                                // totalAmountController
                              ],
                            ),
                          )
                  : Container(
                      margin: EdgeInsets.symmetric(vertical: 32.0, horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFff6565),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Icon(
                                      Icons.clear,
                                      grade: 3,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Row(children: [
                                Expanded(
                                  flex: 8,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color(Constants.colorTheme)),
                                    onPressed: () {},
                                    child: Text(
                                      "Total",
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 9,
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    readOnly: true,
                                    decoration: InputDecoration(),
                                    controller: totalAmountController,
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Expanded(
                                  flex: 8,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color(Constants.colorTheme)),
                                    onPressed: () {},
                                    child: Text(
                                      'Received',
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 9,
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    inputFormatters: [
                                      DecimalTextInputFormatter(decimalRange: 2)
                                    ],
                                    decoration: InputDecoration(),
                                    onChanged: (String? val) {
                                      calculateChanged();
                                    },
                                    // validator: (String? value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Please Enter Amount';
                                    //   }
                                    // },
                                    controller: receivedController,
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Expanded(
                                  flex: 8,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color(Constants.colorTheme)),
                                    onPressed: () {},
                                    child: Text(
                                      "Change",
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 9,
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    readOnly: true,
                                    decoration: InputDecoration(),
                                    controller: changedController,
                                  ),
                                ),
                              ]),

                              // SizedBox(
                              //   width: Get.width * 0.3,
                              //   child: Text(
                              //     'Total',
                              //     maxLines: 2,
                              //     style: TextStyle(
                              //         fontSize: 35,
                              //         color: Color(Constants.colorTheme)),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        NumberButton(
                                            height: 0.09,
                                            btnColor: Colors.red.shade600,
                                            value: '5',
                                            onTapped: () {
                                              receivedController.text =
                                                  addStringIntoInt(5);
                                              calculateChanged();
                                            }),
                                        NumberButton(
                                            height: 0.09,
                                            btnColor: Colors.red.shade600,
                                            value: '10',
                                            onTapped: () {
                                              receivedController.text =
                                                  addStringIntoInt(10);
                                              calculateChanged();
                                            }),
                                        NumberButton(
                                            height: 0.09,
                                            btnColor: Colors.red.shade600,
                                            value: '20',
                                            onTapped: () {
                                              receivedController.text =
                                                  addStringIntoInt(20);
                                              calculateChanged();
                                            }),
                                        NumberButton(
                                            height: 0.09,
                                            btnColor: Colors.red.shade600,
                                            value: '50',
                                            onTapped: () {
                                              receivedController.text =
                                                  addStringIntoInt(50);
                                              calculateChanged();
                                            }),
                                        NumberButton(
                                            height: 0.09,
                                            btnColor: Colors.red.shade600,
                                            value: '100',
                                            onTapped: () {
                                              receivedController.text =
                                                  addStringIntoInt(100);
                                              calculateChanged();
                                            }),

                                        // ElevatedButton(
                                        //   onPressed: () {
                                        //     receivedController.text =
                                        //         addStringIntoInt(10);
                                        //     calculateChanged();
                                        //   },
                                        //   child: const Text(
                                        //     "10",
                                        //     textAlign: TextAlign.center,
                                        //     style: TextStyle(
                                        //         fontSize: 28,
                                        //         fontFamily: 'Dosis',
                                        //         color: Colors.white,
                                        //         fontWeight: FontWeight.normal),
                                        //   ),
                                        // ),
                                        // ElevatedButton(
                                        //   onPressed: () {
                                        //     receivedController.text =
                                        //         addStringIntoInt(20);
                                        //     calculateChanged();
                                        //   },
                                        //   child: const Text(
                                        //     "20",
                                        //     textAlign: TextAlign.center,
                                        //     style: TextStyle(
                                        //         fontSize: 28,
                                        //         fontFamily: 'Dosis',
                                        //         color: Colors.white,
                                        //         fontWeight: FontWeight.normal),
                                        //   ),
                                        // ),
                                        // ElevatedButton(
                                        //   onPressed: () {
                                        //     receivedController.text =
                                        //         addStringIntoInt(50);
                                        //     calculateChanged();
                                        //   },
                                        //   child: const Text(
                                        //     '50',
                                        //     textAlign: TextAlign.center,
                                        //     style: TextStyle(
                                        //         fontSize: 28,
                                        //         fontFamily: 'Dosis',
                                        //         color: Colors.white,
                                        //         fontWeight: FontWeight.normal),
                                        //   ),
                                        // ),
                                        // ElevatedButton(
                                        //   onPressed: () {
                                        //     receivedController.text =
                                        //         addStringIntoInt(100);
                                        //     calculateChanged();
                                        //   },
                                        //   child: const Text(
                                        //     "100",
                                        //     textAlign: TextAlign.center,
                                        //     style: TextStyle(
                                        //         fontSize: 28,
                                        //         fontFamily: 'Dosis',
                                        //         color: Colors.white,
                                        //         fontWeight: FontWeight.normal),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: NumberButton(
                                                    value: '1',
                                                    onTapped: () {
                                                      receivedController.text +=
                                                          "1";
                                                      calculateChanged();
                                                    }),
                                              ),
                                              Expanded(
                                                child: NumberButton(
                                                    value: '2',
                                                    onTapped: () {
                                                      receivedController.text +=
                                                          "2";
                                                      calculateChanged();
                                                    }),
                                              ),
                                              Expanded(
                                                child: NumberButton(
                                                    value: '3',
                                                    onTapped: () {
                                                      receivedController.text +=
                                                          "3";
                                                      calculateChanged();
                                                    }),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: NumberButton(
                                                    value: '4',
                                                    onTapped: () {
                                                      receivedController.text +=
                                                          "4";
                                                      calculateChanged();
                                                    }),
                                              ),
                                              Expanded(
                                                child: NumberButton(
                                                    value: '5',
                                                    onTapped: () {
                                                      receivedController.text +=
                                                          "5";
                                                      calculateChanged();
                                                    }),
                                              ),
                                              Expanded(
                                                child: NumberButton(
                                                    value: '6',
                                                    onTapped: () {
                                                      receivedController.text +=
                                                          "6";
                                                      calculateChanged();
                                                    }),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: NumberButton(
                                                    value: '7',
                                                    onTapped: () {
                                                      receivedController.text +=
                                                          "7";
                                                      calculateChanged();
                                                    }),
                                              ),
                                              Expanded(
                                                child: NumberButton(
                                                    value: '8',
                                                    onTapped: () {
                                                      receivedController.text +=
                                                          "8";
                                                      calculateChanged();
                                                    }),
                                              ),
                                              Expanded(
                                                child: NumberButton(
                                                    value: '9',
                                                    onTapped: () {
                                                      receivedController.text +=
                                                          "9";
                                                      calculateChanged();
                                                    }),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: NumberButton(
                                                    value: '.',
                                                    onTapped: () {
                                                      receivedController.text +=
                                                          ".";
                                                      calculateChanged();
                                                    }),
                                              ),
                                              Expanded(
                                                child: NumberButton(
                                                    value: '0',
                                                    onTapped: () {
                                                      receivedController.text +=
                                                          "0";
                                                      calculateChanged();
                                                    }),
                                              ),
                                              Expanded(
                                                child: NumberButton(
                                                    value: 'X',
                                                    onTapped: () {
                                                      if (receivedController
                                                          .text.isNotEmpty) {
                                                        receivedController.text =
                                                            receivedController.text
                                                                .substring(
                                                                    0,
                                                                    receivedController
                                                                            .text
                                                                            .length -
                                                                        1);
                                                        calculateChanged();
                                                      }
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  // Expanded(
                                  //     flex: 1,
                                  //     child: Column(
                                  //       children: [
                                  //         NumberButton(
                                  //             value: '5% Discount',
                                  //             btnColor: _selectedButton == 0 ||
                                  //                     _selectedButton == -1
                                  //                 ? Colors.black
                                  //                 : Colors.grey,
                                  //             onTapped: _selectedButton == 0
                                  //                 ? () {}
                                  //                 : () => _updatePrice(0)),
                                  //         NumberButton(
                                  //             value: '10% Discount',
                                  //             btnColor: _selectedButton == 1 ||
                                  //                     _selectedButton == -1
                                  //                 ? Colors.black
                                  //                 : Colors.grey,
                                  //             onTapped: _selectedButton == 1
                                  //                 ? () {}
                                  //                 : () => _updatePrice(1)),
                                  //         NumberButton(
                                  //             value: '15% Discount',
                                  //             btnColor: _selectedButton == 2 ||
                                  //                     _selectedButton == -1
                                  //                 ? Colors.black
                                  //                 : Colors.grey,
                                  //             onTapped: _selectedButton == 2
                                  //                 ? () {}
                                  //                 : () => _updatePrice(2)),
                                  //         NumberButton(
                                  //             value: 'Clear Discount',
                                  //             btnColor: _selectedButton == 3 ||
                                  //                     _selectedButton == -1
                                  //                 ? Colors.black
                                  //                 : Colors.grey,
                                  //             onTapped: _selectedButton == 3 ||
                                  //                     _selectedButton == -1
                                  //                 ? () {}
                                  //                 : () => _updatePrice(3)),
                                  //       ],
                                  //     )),
                                  ///COulumn

                                  ///
                                  // SizedBox(
                                  //   width: Get.width * 0.1,
                                  //   child: Column(
                                  //     children: [
                                  //       // SizedBox(height: Get.height*0.02,),
                                  //       ShortCutButton(
                                  //         value: '5',
                                  //         onTapped: () {
                                  //           receivedController.text =
                                  //               addStringIntoInt(5);
                                  //           calculateChanged();
                                  //         },
                                  //       ),
                                  //       ShortCutButton(
                                  //         value: '10',
                                  //         onTapped: () {
                                  //           receivedController.text =
                                  //               addStringIntoInt(10);
                                  //           calculateChanged();
                                  //         },
                                  //       ),
                                  //       ShortCutButton(
                                  //         value: '20',
                                  //         onTapped: () {
                                  //           receivedController.text =
                                  //               addStringIntoInt(20);
                                  //           calculateChanged();
                                  //         },
                                  //       ),
                                  //       ShortCutButton(
                                  //         value: '50',
                                  //         onTapped: () {
                                  //           receivedController.text =
                                  //               addStringIntoInt(50);
                                  //           calculateChanged();
                                  //         },
                                  //       ),
                                  //       ShortCutButton(
                                  //         value: '100',
                                  //         onTapped: () {
                                  //           receivedController.text =
                                  //               addStringIntoInt(100);
                                  //           calculateChanged();
                                  //         },
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  ///Chenged
                                  // Align(
                                  //   alignment: Alignment.topCenter,
                                  //   child: SizedBox(
                                  //     width: Get.width * 0.9 - 64,
                                  //     child:
                                  //   ),
                                  // )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: NumberButton(
                                    height: 0.12,
                                    value: '5% Discount',
                                    btnColor: _selectedButton == 0 ||
                                            _selectedButton == -1
                                        ? Colors.black
                                        : Colors.grey,
                                    onTapped: _selectedButton == 0
                                        ? () {}
                                        : () => _updatePrice(0)),
                              ),
                              Expanded(
                                child: NumberButton(
                                    height: 0.12,
                                    value: '10% Discount',
                                    btnColor: _selectedButton == 1 ||
                                            _selectedButton == -1
                                        ? Colors.black
                                        : Colors.grey,
                                    onTapped: _selectedButton == 1
                                        ? () {}
                                        : () => _updatePrice(1)),
                              ),
                              Expanded(
                                child: NumberButton(
                                    height: 0.12,
                                    value: '15% Discount',
                                    btnColor: _selectedButton == 2 ||
                                            _selectedButton == -1
                                        ? Colors.black
                                        : Colors.grey,
                                    onTapped: _selectedButton == 2
                                        ? () {}
                                        : () => _updatePrice(2)),
                              ),
                              Expanded(
                                child: NumberButton(
                                    height: 0.12,
                                    value: 'Clear Discount',
                                    btnColor: _selectedButton == 3 ||
                                            _selectedButton == -1
                                        ? Colors.black
                                        : Colors.grey,
                                    onTapped: _selectedButton == 3 ||
                                            _selectedButton == -1
                                        ? () {}
                                        : () => _updatePrice(3)),
                              )
                            ],
                          ),
                          () {
                            if (_cartController.cartMaster?.oldOrderId == null &&
                                widget.orderDeliveryType == 'DINING') {
                              return Row(
                                children: [
                                  Expanded(
                                    child: NumberButton(
                                        height: 0.08,
                                        value: 'Pay Later',
                                        btnColor: Color(Constants.colorTheme),
                                        onTapped: () {
                                          orderPaymentType = 'INCOMPLETE ORDER';
                                          placeOrder(1, '');
                                          // if (kitchenPort != null) {
                                          //   print("kitchen Added");
                                          //   if (kitchenIp == '' &&
                                          //       kitchenPort == '' ||
                                          //       kitchenIp == null &&
                                          //           kitchenPort == null) {
                                          //     print("kitchen ip empty");
                                          //   } else {
                                          //     print(
                                          //         " kitchen ip not empty");
                                          //     testPrintKitchen(
                                          //         kitchenIp!,
                                          //         kitchenPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                        }),
                                  ),
                                ],
                              );
                            } else if (_cartController.cartMaster?.oldOrderId !=
                                    null &&
                                widget.orderDeliveryType == 'DINING') {
                              return Row(
                                children: [
                                  Expanded(
                                    child: NumberButton(
                                        height: 0.08,
                                        value: 'POS CASH',
                                        btnColor: Colors.black,
                                        onTapped: () {
                                          if (_formKey.currentState!.validate()) {
                                            orderPaymentType = 'POS CASH';
                                            placeOrder(0, '');
                                          }

                                          ///Last Changing
                                          // if (posPort != null) {
                                          //   print("POS ADDED");
                                          //   if (posIp == '' &&
                                          //       posPort == '' ||
                                          //       posIp == null &&
                                          //           posPort == null) {
                                          //     print("pos ip empty");
                                          //   } else {
                                          //     print("pos ip not empty");
                                          //     testPrintPOS(
                                          //         posIp!,
                                          //         posPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                          // _cartController.cartMaster = null;
                                          // _cartController.cartTotalQuantity.value = 0;

                                          ///fazool
                                          // if (kitchenPort != null) {
                                          //   print("kitchen Added");
                                          //   if (kitchenIp == '' &&
                                          //           kitchenPort == '' ||
                                          //       kitchenIp == null &&
                                          //           kitchenPort == null) {
                                          //     print("kitchen ip empty");
                                          //   } else {
                                          //     print(" kitchen ip not empty");
                                          //     testPrintKitchen(
                                          //         kitchenIp!,
                                          //         kitchenPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                        }),
                                  ),
                                  Expanded(
                                    child: NumberButton(
                                        height: 0.08,
                                        value: 'POS CARD',
                                        btnColor: Color(Constants.colorTheme),
                                        onTapped: () {
                                          orderPaymentType = 'POS CARD';
                                          var id = _linklyDataController.uuid.v4();
                                          if(_orderCustimizationController.strRestaurantLinkly.value == 1){
                                          _linklyDataController.placeValue.value = 0;
                                          _linklyDataController.transactionPayment(totalAmountController.text, id, placeOrder, context);
                                          } else {
                                            placeOrder(0, '');
                                          }
                                          ///Last Changing
                                          // if (posPort != null) {
                                          //   print("POS ADDED");
                                          //   if (posIp == '' &&
                                          //           posPort == '' ||
                                          //       posIp == null &&
                                          //           posPort == null) {
                                          //     print("pos ip empty");
                                          //   } else {
                                          //     print("pos ip not empty");
                                          //     testPrintPOS(
                                          //         posIp!,
                                          //         posPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                          // _cartController.cartMaster = null;
                                          // _cartController
                                          //     .cartTotalQuantity.value = 0;

                                          ///Fazool
                                          // if (kitchenPort != null) {
                                          //   print("kitchen Added");
                                          //   if (kitchenIp == '' &&
                                          //           kitchenPort == '' ||
                                          //       kitchenIp == null &&
                                          //           kitchenPort == null) {
                                          //     print("kitchen ip empty");
                                          //   } else {
                                          //     print(" kitchen ip not empty");
                                          //     testPrintKitchen(
                                          //         kitchenIp!,
                                          //         kitchenPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                        }),
                                  ),
                                  Expanded(
                                    child: NumberButton(
                                        height: 0.08,
                                        value: 'Cash + Card',
                                        btnColor: Color(Constants.colorTheme),
                                        onTapped: () {
                                          orderPaymentType = 'Cash+Card';
                                          showMyDialog(context, posCashAmountController,posCardAmountController);
                                        }),
                                  ),
                                  Expanded(
                                    child: NumberButton(
                                        height: 0.08,
                                        value: 'Pay Later',
                                        btnColor: Color(Constants.colorTheme),
                                        onTapped: () {
                                          orderPaymentType = 'INCOMPLETE ORDER';
                                          placeOrder(1, '');
                                          // if (kitchenPort != null) {
                                          //   print("kitchen Added");
                                          //   if (kitchenIp == '' &&
                                          //       kitchenPort == '' ||
                                          //       kitchenIp == null &&
                                          //           kitchenPort == null) {
                                          //     print("kitchen ip empty");
                                          //   } else {
                                          //     print(
                                          //         " kitchen ip not empty");
                                          //     testPrintKitchen(
                                          //         kitchenIp!,
                                          //         kitchenPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                          // _cartController.cartMaster = null;
                                          // _cartController.cartTotalQuantity.value = 0;
                                        }),
                                  ),

                                ],
                              );
                            } else if (_cartController.cartMaster?.oldOrderId !=
                                    null &&
                                widget.orderDeliveryType == 'TAKEAWAY') {
                              return Row(
                                children: [
                                  Expanded(
                                    child: NumberButton(
                                        height: 0.08,
                                        value: 'POS CASH',
                                        btnColor: Colors.black,
                                        onTapped: () {
                                          if (_formKey.currentState!.validate()) {
                                            orderPaymentType = 'POS CASH TAKEAWAY';
                                            placeOrder(0, '');
                                          }

                                          ///Last Changing
                                          // if (posPort != null) {
                                          //   print("POS ADDED");
                                          //   if (posIp == '' &&
                                          //       posPort == '' ||
                                          //       posIp == null &&
                                          //           posPort == null) {
                                          //     print("pos ip empty");
                                          //   } else {
                                          //     print("pos ip not empty");
                                          //     testPrintPOS(
                                          //         posIp!,
                                          //         posPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                          // _cartController.cartMaster = null;
                                          // _cartController.cartTotalQuantity.value = 0;

                                          ///fazool
                                          // if (kitchenPort != null) {
                                          //   print("kitchen Added");
                                          //   if (kitchenIp == '' &&
                                          //           kitchenPort == '' ||
                                          //       kitchenIp == null &&
                                          //           kitchenPort == null) {
                                          //     print("kitchen ip empty");
                                          //   } else {
                                          //     print(" kitchen ip not empty");
                                          //     testPrintKitchen(
                                          //         kitchenIp!,
                                          //         kitchenPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                        }),
                                  ),
                                  Expanded(
                                    child: NumberButton(
                                        height: 0.08,
                                        value: 'POS CARD',
                                        btnColor: Color(Constants.colorTheme),
                                        onTapped: () {
                                          orderPaymentType = 'POS CARD TAKEAWAY';
                                          if(_orderCustimizationController.strRestaurantLinkly.value == 1){
                                          var id = _linklyDataController.uuid.v4();
                                          _linklyDataController.placeValue.value = 2;
                                          _linklyDataController.transactionPayment(totalAmountController.text, id, placeOrder, context);
                                          } else {
                                            placeOrder(2, '');
                                          }
                                          ///Last Changing
                                          // if (posPort != null) {
                                          //   print("POS ADDED");
                                          //   if (posIp == '' &&
                                          //           posPort == '' ||
                                          //       posIp == null &&
                                          //           posPort == null) {
                                          //     print("pos ip empty");
                                          //   } else {
                                          //     print("pos ip not empty");
                                          //     testPrintPOS(
                                          //         posIp!,
                                          //         posPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                          // _cartController.cartMaster = null;
                                          // _cartController
                                          //     .cartTotalQuantity.value = 0;

                                          ///Fazool
                                          // if (kitchenPort != null) {
                                          //   print("kitchen Added");
                                          //   if (kitchenIp == '' &&
                                          //           kitchenPort == '' ||
                                          //       kitchenIp == null &&
                                          //           kitchenPort == null) {
                                          //     print("kitchen ip empty");
                                          //   } else {
                                          //     print(" kitchen ip not empty");
                                          //     testPrintKitchen(
                                          //         kitchenIp!,
                                          //         kitchenPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                        }),
                                  ),
                                  Expanded(
                                    child: NumberButton(
                                        height: 0.08,
                                        value: 'Cash + Card',
                                        btnColor: Color(Constants.colorTheme),
                                        onTapped: () {
                                          orderPaymentType = 'Cash+Card';
                                          showMyDialog(context, posCashAmountController,posCardAmountController);
                                        }),
                                  ),
                                  Expanded(
                                    child: NumberButton(
                                        height: 0.08,
                                        value: 'Pay Later',
                                        btnColor: Color(Constants.colorTheme),
                                        onTapped: () {
                                          print("lllllll");
                                          orderPaymentType = 'INCOMPLETE ORDER';
                                          placeOrder(1, '');
                                          // if (kitchenPort != null) {
                                          //   print("kitchen Added");
                                          //   if (kitchenIp == '' &&
                                          //       kitchenPort == '' ||
                                          //       kitchenIp == null &&
                                          //           kitchenPort == null) {
                                          //     print("kitchen ip empty");
                                          //   } else {
                                          //     print(
                                          //         " kitchen ip not empty");
                                          //     testPrintKitchen(
                                          //         kitchenIp!,
                                          //         kitchenPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                          // _cartController.cartMaster = null;
                                          // _cartController.cartTotalQuantity.value = 0;
                                        }),
                                  ),
                                ],
                              );
                            } else {
                              return Row(
                                children: [
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     receivedController.text =
                                  //         addStringIntoInt(5);
                                  //     calculateChanged();
                                  //   },
                                  //   child: const Text(
                                  //     "5",
                                  //     textAlign: TextAlign.center,
                                  //     style: TextStyle(
                                  //         fontSize: 28,
                                  //         fontFamily: 'Dosis',
                                  //         color: Colors.white,
                                  //         fontWeight:
                                  //             FontWeight.normal),
                                  //   ),
                                  // ),
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     receivedController.text =
                                  //         addStringIntoInt(10);
                                  //     calculateChanged();
                                  //   },
                                  //   child: const Text(
                                  //     "10",
                                  //     textAlign: TextAlign.center,
                                  //     style: TextStyle(
                                  //         fontSize: 28,
                                  //         fontFamily: 'Dosis',
                                  //         color: Colors.white,
                                  //         fontWeight:
                                  //             FontWeight.normal),
                                  //   ),
                                  // ),
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     receivedController.text =
                                  //         addStringIntoInt(20);
                                  //     calculateChanged();
                                  //   },
                                  //   child: const Text(
                                  //     "20",
                                  //     textAlign: TextAlign.center,
                                  //     style: TextStyle(
                                  //         fontSize: 28,
                                  //         fontFamily: 'Dosis',
                                  //         color: Colors.white,
                                  //         fontWeight:
                                  //             FontWeight.normal),
                                  //   ),
                                  // ),
                                  Expanded(
                                    child: NumberButton(
                                        height: 0.08,
                                        value: 'POS CASH',
                                        btnColor: Colors.black,
                                        onTapped: () {
                                          if (_formKey.currentState!.validate()) {
                                            orderPaymentType = 'POS CASH';
                                            placeOrder(2, '');
                                          }
                                          print("********");

                                          ///Last Changing
                                          // if (posPort != null) {
                                          //   print("POS ADDED");
                                          //   if (posIp == '' &&
                                          //           posPort == '' ||
                                          //       posIp == null &&
                                          //           posPort == null) {
                                          //     print("pos ip empty");
                                          //   } else {
                                          //     print("pos ip not empty");
                                          //     testPrintPOS(
                                          //         posIp!,
                                          //         posPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                          // if (kitchenPort != null) {
                                          //   print("kitchen Added");
                                          //   if (kitchenIp == '' &&
                                          //           kitchenPort == '' ||
                                          //       kitchenIp == null &&
                                          //           kitchenPort == null) {
                                          //     print("kitchen ip empty");
                                          //   } else {
                                          //     print(" kitchen ip not empty");
                                          //     testPrintKitchen(
                                          //         kitchenIp!,
                                          //         kitchenPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                          // _cartController.cartMaster = null;
                                          // _cartController
                                          //     .cartTotalQuantity.value = 0;

                                          /// Fazool
                                          // }
                                          //
                                          //     const PaperSize paper = PaperSize.mm80;
                                          //     final profile = await CapabilityProfile.load();
                                          //     final printer = NetworkPrinter(paper, profile);
                                          //
                                          //     final PosPrintResult res = await printer.connect('192.168.18.62', port: 9100);
                                          //
                                          //     if (res == PosPrintResult.success) {
                                          //       testReceipt(printer);
                                          //       printer.disconnect();
                                          //     }
                                          //
                                          //     print('Print result: ${res.msg}');
                                        }),
                                  ),
                                  Expanded(
                                    child: NumberButton(
                                        height: 0.08,
                                        value: 'POS CARD',
                                        btnColor: Color(Constants.colorTheme),
                                        onTapped: () {
                                          orderPaymentType = 'POS CARD';
                                          if(_orderCustimizationController.strRestaurantLinkly.value == 1){
                                          var id = _linklyDataController.uuid.v4();
                                          _linklyDataController.placeValue.value = 2;
                                          _linklyDataController.transactionPayment(totalAmountController.text, id, placeOrder, context);
                                          } else {
                                            placeOrder(2, '');
                                          }
                                          ///Last Changing
                                          // if (posPort != null) {
                                          //   print("POS ADDED");
                                          //   if (posIp == '' &&
                                          //           posPort == '' ||
                                          //       posIp == null &&
                                          //           posPort == null) {
                                          //     print("pos ip empty");
                                          //   } else {
                                          //     print("pos ip not empty");
                                          //     testPrintPOS(
                                          //         posIp!,
                                          //         posPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                          // if (kitchenPort != null) {
                                          //   print("kitchen Added");
                                          //   if (kitchenIp == '' &&
                                          //           kitchenPort == '' ||
                                          //       kitchenIp == null &&
                                          //           kitchenPort == null) {
                                          //     print("kitchen ip empty");
                                          //   } else {
                                          //     print(" kitchen ip not empty");
                                          //     testPrintKitchen(
                                          //         kitchenIp!,
                                          //         kitchenPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                          // _cartController.cartMaster = null;
                                          // _cartController
                                          //     .cartTotalQuantity.value = 0;
                                        }),
                                  ),
                                  Expanded(
                                    child: NumberButton(
                                        height: 0.08,
                                        value: 'Cash + Card',
                                        btnColor: Color(Constants.colorTheme),
                                        onTapped: () {
                                          orderPaymentType = 'Cash+Card';
                                          showMyDialog(context, posCashAmountController,posCardAmountController);
                                        }),
                                  ),
                                  Expanded(
                                    child: NumberButton(
                                        height: 0.08,
                                        value: 'Pay Later',
                                        btnColor: Color(Constants.colorTheme),
                                        onTapped: () {
                                          orderPaymentType = 'INCOMPLETE ORDER';
                                          placeOrder(1, '');

                                          ///Last Changing
                                          // if (kitchenPort != null) {
                                          //   print("kitchen Added");
                                          //   if (kitchenIp == '' &&
                                          //           kitchenPort == '' ||
                                          //       kitchenIp == null &&
                                          //           kitchenPort == null) {
                                          //     print("kitchen ip empty");
                                          //   } else {
                                          //     print(" kitchen ip not empty");
                                          //     testPrintKitchen(
                                          //         kitchenIp!,
                                          //         kitchenPort!,
                                          //         context,
                                          //         _cartController
                                          //             .cartMaster!);
                                          //   }
                                          // }
                                          // _cartController.cartMaster = null;
                                          // _cartController
                                          //     .cartTotalQuantity.value = 0;
                                        }),
                                  ),
                                ],
                              );
                            }
                          }(),
                          SizedBox(
                            height: 30,
                          ),

                          //       Container(
                          //         child: Row(
                          //           children: [
                          //             Expanded(
                          //               child:  NumberButton(
                          //                   value: '5% Discount',
                          //                   btnColor: isDisabled == true ? Colors.grey : Colors.red.shade500,
                          //                   onTapped: isDisabled == true ? (){} : () {
                          // setState(() {
                          // isDisabled = true;
                          // });
                          // calculateDiscount(0.05);
                          // }),
                          //             ),
                          //             Expanded(
                          //               child:  NumberButton(
                          //                   value: '10% Discount',
                          //                   btnColor: isDisabled == true ? Colors.grey : Colors.red.shade500,
                          //                   onTapped: isDisabled == true ? (){} : () {
                          //                     setState(() {
                          //                       isDisabled = true;
                          //                     });
                          //                     calculateDiscount(0.010);
                          //                   }),
                          //             ),
                          //             Expanded(
                          //               child:  NumberButton(
                          //                   value: '15% Discount',
                          //                   btnColor: isDisabled == true ? Colors.grey : Colors.red.shade500,
                          //                   onTapped: isDisabled == true ? (){} : () {
                          //                     setState(() {
                          //                       isDisabled = true;
                          //                     });
                          //                     calculateDiscount(0.015);
                          //                   }),
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          // totalAmountController
                        ],
                      ),
                    ),
            ),
        );
      }),

                  // if (_linklyDataController.showDialogvalue.value == true &&
                  //     (_linklyDataController.linklyModel.value.data is DataLinkly &&
                  //         (_linklyDataController.linklyModel.value.data!.request?.response?.displayText?.isNotEmpty == true ||
                  //             _linklyDataController.linklyModel.value.data?.request.responseType == 'receipt')))

                    if (_linklyDataController.showDialogvalue.value == true &&
                        _linklyDataController.linklyModel.value.data is DataLinkly &&
                        (
                            (_linklyDataController.linklyModel.value.data!.request?.response is AboveResponse &&
                                _linklyDataController.linklyModel.value.data!.request?.response?.displayText?.isNotEmpty == true) ||
                                (_linklyDataController.linklyModel.value.data!.request?.response is BeneathResponse &&
                                    _linklyDataController.linklyModel.value.data!.request?.responseType == 'transaction')
                        )
                    )
                    Stack(
          children: [
            // Black background overlay
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
              ),
            ),
            // Dialog content
            AlertDialog(
              title: Text(
                _linklyDataController.dialogTitle.value,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24
                ),
              ),
              content: Container(
                height: 140,
                child: Text(
                  _linklyDataController.dialogContent.value,
                  style: TextStyle(
                      fontSize: 18
                  ),
                ),
              ),
            )
          ],

     ),




          ])),
    );
  }

  ///Form
  //Form(
  //           key: _formKey,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               SizedBox(
  //                 height: 30,
  //               ),
  //               Container(
  //                 margin: EdgeInsets.only(left: 4.0),
  //                 child: Column(
  //                   children: [
  //                     Row(
  //                       children: [
  //                         SizedBox(
  //                           width: Get.width * 0.3,
  //                           child: Text(
  //                             'Total',
  //                             maxLines: 2,
  //                             style: TextStyle(
  //                                 fontSize: 35,
  //                                 color: Color(Constants.colorTheme)),
  //                           ),
  //                         ),
  //                         Expanded(
  //                           child: TextFormField(
  //                             readOnly: true,
  //                             decoration: InputDecoration(),
  //                             controller: totalAmountController,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         SizedBox(
  //                           width: Get.width * 0.3,
  //                           child: Text(
  //                             'Recieved',
  //                             maxLines: 2,
  //                             style: TextStyle(
  //                               fontSize: 35,
  //                               color: Color(Constants.colorTheme),
  //                             ),
  //                           ),
  //                         ),
  //                         Expanded(
  //                           child: TextFormField(
  //                             inputFormatters: [
  //                               DecimalTextInputFormatter(decimalRange: 2)
  //                             ],
  //                             decoration: InputDecoration(),
  //                             onChanged: (String? val) {
  //                               calculateChanged();
  //                             },
  //                             validator: (String? value) {
  //                               if (value!.isEmpty) {
  //                                 return 'Please Enter Amount';
  //                               }
  //                             },
  //                             controller: receivedController,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     Row(
  //                       children: [
  //                         SizedBox(
  //                           width: Get.width * 0.3,
  //                           child: Text(
  //                             'Changed',
  //                             maxLines: 2,
  //                             style: TextStyle(
  //                                 fontSize: 35,
  //                                 color: Color(Constants.colorTheme)),
  //                           ),
  //                         ),
  //                         Expanded(
  //                           child: TextFormField(
  //                             readOnly: true,
  //                             decoration: InputDecoration(),
  //                             controller: changedController,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Flexible(
  //                 fit: FlexFit.loose,
  //                 child: Row(
  //                   children: [
  //                     SizedBox(
  //                       width: Get.width * 0.1,
  //                       child: Column(
  //                         children: [
  //                           // SizedBox(height: Get.height*0.02,),
  //                           ShortCutButton(
  //                             value: '5',
  //                             onTapped: () {
  //                               receivedController.text = addStringIntoInt(5);
  //                               calculateChanged();
  //                             },
  //                           ),
  //                           ShortCutButton(
  //                             value: '10',
  //                             onTapped: () {
  //                               receivedController.text = addStringIntoInt(10);
  //                               calculateChanged();
  //                             },
  //                           ),
  //                           ShortCutButton(
  //                             value: '20',
  //                             onTapped: () {
  //                               receivedController.text = addStringIntoInt(20);
  //                               calculateChanged();
  //                             },
  //                           ),
  //                           ShortCutButton(
  //                             value: '50',
  //                             onTapped: () {
  //                               receivedController.text = addStringIntoInt(50);
  //                               calculateChanged();
  //                             },
  //                           ),
  //                           ShortCutButton(
  //                             value: '100',
  //                             onTapped: () {
  //                               receivedController.text = addStringIntoInt(100);
  //                               calculateChanged();
  //                             },
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     Align(
  //                       alignment: Alignment.topCenter,
  //                       child: SizedBox(
  //                         width: Get.width * 0.9 - 64,
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NumberButton(
  //                                       value: '1',
  //                                       onTapped: () {
  //                                         receivedController.text += "1";
  //                                         calculateChanged();
  //                                       }),
  //                                 ),
  //                                 Expanded(
  //                                   child: NumberButton(
  //                                       value: '2',
  //                                       onTapped: () {
  //                                         receivedController.text += "2";
  //                                         calculateChanged();
  //                                       }),
  //                                 ),
  //                                 Expanded(
  //                                   child: NumberButton(
  //                                       value: '3',
  //                                       onTapped: () {
  //                                         receivedController.text += "3";
  //                                         calculateChanged();
  //                                       }),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NumberButton(
  //                                       value: '4',
  //                                       onTapped: () {
  //                                         receivedController.text += "4";
  //                                         calculateChanged();
  //                                       }),
  //                                 ),
  //                                 Expanded(
  //                                   child: NumberButton(
  //                                       value: '5',
  //                                       onTapped: () {
  //                                         receivedController.text += "5";
  //                                         calculateChanged();
  //                                       }),
  //                                 ),
  //                                 Expanded(
  //                                   child: NumberButton(
  //                                       value: '6',
  //                                       onTapped: () {
  //                                         receivedController.text += "6";
  //                                         calculateChanged();
  //                                       }),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NumberButton(
  //                                       value: '7',
  //                                       onTapped: () {
  //                                         receivedController.text += "7";
  //                                         calculateChanged();
  //                                       }),
  //                                 ),
  //                                 Expanded(
  //                                   child: NumberButton(
  //                                       value: '8',
  //                                       onTapped: () {
  //                                         receivedController.text += "8";
  //                                         calculateChanged();
  //                                       }),
  //                                 ),
  //                                 Expanded(
  //                                   child: NumberButton(
  //                                       value: '9',
  //                                       onTapped: () {
  //                                         receivedController.text += "9";
  //                                         calculateChanged();
  //                                       }),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NumberButton(
  //                                       value: '.',
  //                                       onTapped: () {
  //                                         receivedController.text += ".";
  //                                         calculateChanged();
  //                                       }),
  //                                 ),
  //                                 Expanded(
  //                                   child: NumberButton(
  //                                       value: '0',
  //                                       onTapped: () {
  //                                         receivedController.text += "0";
  //                                         calculateChanged();
  //                                       }),
  //                                 ),
  //                                 Expanded(
  //                                   child: NumberButton(
  //                                       value: 'X',
  //                                       onTapped: () {
  //                                         if (receivedController
  //                                             .text.isNotEmpty) {
  //                                           receivedController.text =
  //                                               receivedController.text.substring(
  //                                                   0,
  //                                                   receivedController
  //                                                           .text.length -
  //                                                       1);
  //                                           calculateChanged();
  //                                         }
  //                                       }),
  //                                 ),
  //                               ],
  //                             ),
  //                             () {
  //                               if (_cartController.cartMaster?.oldOrderId ==
  //                                       null &&
  //                                   widget.orderDeliveryType == 'DINING') {
  //                                 return Row(
  //                                   children: [
  //                                     Expanded(
  //                                       child: NumberButton(
  //                                           value: 'Pay Later',
  //                                           btnColor: Colors.green,
  //                                           onTapped: () {
  //                                             orderPaymentType =
  //                                                 'INCOMPLETE ORDER';
  //                                             placeOrder(1);
  //                                             // if (kitchenPort != null) {
  //                                             //   print("kitchen Added");
  //                                             //   if (kitchenIp == '' &&
  //                                             //       kitchenPort == '' ||
  //                                             //       kitchenIp == null &&
  //                                             //           kitchenPort == null) {
  //                                             //     print("kitchen ip empty");
  //                                             //   } else {
  //                                             //     print(
  //                                             //         " kitchen ip not empty");
  //                                             //     testPrintKitchen(
  //                                             //         kitchenIp!,
  //                                             //         kitchenPort!,
  //                                             //         context,
  //                                             //         _cartController
  //                                             //             .cartMaster!);
  //                                             //   }
  //                                             // }
  //                                           }),
  //                                     ),
  //                                   ],
  //                                 );
  //                               } else if (_cartController
  //                                           .cartMaster?.oldOrderId !=
  //                                       null &&
  //                                   widget.orderDeliveryType == 'DINING') {
  //                                 return Row(
  //                                   children: [
  //                                     Expanded(
  //                                       child: NumberButton(
  //                                           value: 'Pay Later',
  //                                           btnColor: Colors.green,
  //                                           onTapped: () {
  //                                             orderPaymentType =
  //                                                 'INCOMPLETE ORDER';
  //                                             placeOrder(1);
  //                                             // if (kitchenPort != null) {
  //                                             //   print("kitchen Added");
  //                                             //   if (kitchenIp == '' &&
  //                                             //       kitchenPort == '' ||
  //                                             //       kitchenIp == null &&
  //                                             //           kitchenPort == null) {
  //                                             //     print("kitchen ip empty");
  //                                             //   } else {
  //                                             //     print(
  //                                             //         " kitchen ip not empty");
  //                                             //     testPrintKitchen(
  //                                             //         kitchenIp!,
  //                                             //         kitchenPort!,
  //                                             //         context,
  //                                             //         _cartController
  //                                             //             .cartMaster!);
  //                                             //   }
  //                                             // }
  //                                             // _cartController.cartMaster = null;
  //                                             // _cartController.cartTotalQuantity.value = 0;
  //                                           }),
  //                                     ),
  //                                     Expanded(
  //                                         child: NumberButton(
  //                                             value: 'POS CASH',
  //                                             btnColor: Colors.green,
  //                                             onTapped: () {
  //                                               if (_formKey.currentState!
  //                                                   .validate()) {
  //                                                 orderPaymentType = 'POS CASH';
  //                                                 placeOrder(0);
  //                                               }
  //
  //                                               ///Last Changing
  //                                               // if (posPort != null) {
  //                                               //   print("POS ADDED");
  //                                               //   if (posIp == '' &&
  //                                               //       posPort == '' ||
  //                                               //       posIp == null &&
  //                                               //           posPort == null) {
  //                                               //     print("pos ip empty");
  //                                               //   } else {
  //                                               //     print("pos ip not empty");
  //                                               //     testPrintPOS(
  //                                               //         posIp!,
  //                                               //         posPort!,
  //                                               //         context,
  //                                               //         _cartController
  //                                               //             .cartMaster!);
  //                                               //   }
  //                                               // }
  //                                               // _cartController.cartMaster = null;
  //                                               // _cartController.cartTotalQuantity.value = 0;
  //
  //                                               ///fazool
  //                                               // if (kitchenPort != null) {
  //                                               //   print("kitchen Added");
  //                                               //   if (kitchenIp == '' &&
  //                                               //           kitchenPort == '' ||
  //                                               //       kitchenIp == null &&
  //                                               //           kitchenPort == null) {
  //                                               //     print("kitchen ip empty");
  //                                               //   } else {
  //                                               //     print(" kitchen ip not empty");
  //                                               //     testPrintKitchen(
  //                                               //         kitchenIp!,
  //                                               //         kitchenPort!,
  //                                               //         context,
  //                                               //         _cartController
  //                                               //             .cartMaster!);
  //                                               //   }
  //                                               // }
  //                                             })),
  //                                     Expanded(
  //                                       child: NumberButton(
  //                                           value: 'POS CARD',
  //                                           btnColor: Colors.green,
  //                                           onTapped: () {
  //                                             orderPaymentType = 'POS CARD';
  //                                             placeOrder(0);
  //
  //                                             ///Last Changing
  //                                             // if (posPort != null) {
  //                                             //   print("POS ADDED");
  //                                             //   if (posIp == '' &&
  //                                             //           posPort == '' ||
  //                                             //       posIp == null &&
  //                                             //           posPort == null) {
  //                                             //     print("pos ip empty");
  //                                             //   } else {
  //                                             //     print("pos ip not empty");
  //                                             //     testPrintPOS(
  //                                             //         posIp!,
  //                                             //         posPort!,
  //                                             //         context,
  //                                             //         _cartController
  //                                             //             .cartMaster!);
  //                                             //   }
  //                                             // }
  //                                             // _cartController.cartMaster = null;
  //                                             // _cartController
  //                                             //     .cartTotalQuantity.value = 0;
  //
  //                                             ///Fazool
  //                                             // if (kitchenPort != null) {
  //                                             //   print("kitchen Added");
  //                                             //   if (kitchenIp == '' &&
  //                                             //           kitchenPort == '' ||
  //                                             //       kitchenIp == null &&
  //                                             //           kitchenPort == null) {
  //                                             //     print("kitchen ip empty");
  //                                             //   } else {
  //                                             //     print(" kitchen ip not empty");
  //                                             //     testPrintKitchen(
  //                                             //         kitchenIp!,
  //                                             //         kitchenPort!,
  //                                             //         context,
  //                                             //         _cartController
  //                                             //             .cartMaster!);
  //                                             //   }
  //                                             // }
  //                                           }),
  //                                     ),
  //                                   ],
  //                                 );
  //                               } else if (_cartController
  //                                           .cartMaster?.oldOrderId !=
  //                                       null &&
  //                                   widget.orderDeliveryType == 'TAKEAWAY') {
  //                                 return Row(
  //                                   children: [
  //                                     Expanded(
  //                                       child: NumberButton(
  //                                           value: 'Pay Later',
  //                                           btnColor: Colors.green,
  //                                           onTapped: () {
  //                                             print("lllllll");
  //                                             orderPaymentType =
  //                                                 'INCOMPLETE ORDER';
  //                                             // placeOrder(1);
  //                                             testPrintKitchen(
  //                                                 "203.175.78.102",
  //                                                 8888,
  //                                                 context,
  //                                                 _cartController.cartMaster!);
  //                                             // if (kitchenPort != null) {
  //                                             //   print("kitchen Added");
  //                                             //   if (kitchenIp == '' &&
  //                                             //       kitchenPort == '' ||
  //                                             //       kitchenIp == null &&
  //                                             //           kitchenPort == null) {
  //                                             //     print("kitchen ip empty");
  //                                             //   } else {
  //                                             //     print(
  //                                             //         " kitchen ip not empty");
  //                                             //     testPrintKitchen(
  //                                             //         kitchenIp!,
  //                                             //         kitchenPort!,
  //                                             //         context,
  //                                             //         _cartController
  //                                             //             .cartMaster!);
  //                                             //   }
  //                                             // }
  //                                             // _cartController.cartMaster = null;
  //                                             // _cartController.cartTotalQuantity.value = 0;
  //                                           }),
  //                                     ),
  //                                     Expanded(
  //                                         child: NumberButton(
  //                                             value: 'POS CASH',
  //                                             btnColor: Colors.green,
  //                                             onTapped: () {
  //                                               if (_formKey.currentState!
  //                                                   .validate()) {
  //                                                 orderPaymentType =
  //                                                     'POS CASH TAKEAWAY';
  //                                                 placeOrder(0);
  //                                               }
  //
  //                                               ///Last Changing
  //                                               // if (posPort != null) {
  //                                               //   print("POS ADDED");
  //                                               //   if (posIp == '' &&
  //                                               //       posPort == '' ||
  //                                               //       posIp == null &&
  //                                               //           posPort == null) {
  //                                               //     print("pos ip empty");
  //                                               //   } else {
  //                                               //     print("pos ip not empty");
  //                                               //     testPrintPOS(
  //                                               //         posIp!,
  //                                               //         posPort!,
  //                                               //         context,
  //                                               //         _cartController
  //                                               //             .cartMaster!);
  //                                               //   }
  //                                               // }
  //                                               // _cartController.cartMaster = null;
  //                                               // _cartController.cartTotalQuantity.value = 0;
  //
  //                                               ///fazool
  //                                               // if (kitchenPort != null) {
  //                                               //   print("kitchen Added");
  //                                               //   if (kitchenIp == '' &&
  //                                               //           kitchenPort == '' ||
  //                                               //       kitchenIp == null &&
  //                                               //           kitchenPort == null) {
  //                                               //     print("kitchen ip empty");
  //                                               //   } else {
  //                                               //     print(" kitchen ip not empty");
  //                                               //     testPrintKitchen(
  //                                               //         kitchenIp!,
  //                                               //         kitchenPort!,
  //                                               //         context,
  //                                               //         _cartController
  //                                               //             .cartMaster!);
  //                                               //   }
  //                                               // }
  //                                             })),
  //                                     Expanded(
  //                                       child: NumberButton(
  //                                           value: 'POS CARD',
  //                                           btnColor: Colors.green,
  //                                           onTapped: () {
  //                                             orderPaymentType =
  //                                                 'POS CARD TAKEAWAY';
  //                                             placeOrder(0);
  //
  //                                             ///Last Changing
  //                                             // if (posPort != null) {
  //                                             //   print("POS ADDED");
  //                                             //   if (posIp == '' &&
  //                                             //           posPort == '' ||
  //                                             //       posIp == null &&
  //                                             //           posPort == null) {
  //                                             //     print("pos ip empty");
  //                                             //   } else {
  //                                             //     print("pos ip not empty");
  //                                             //     testPrintPOS(
  //                                             //         posIp!,
  //                                             //         posPort!,
  //                                             //         context,
  //                                             //         _cartController
  //                                             //             .cartMaster!);
  //                                             //   }
  //                                             // }
  //                                             // _cartController.cartMaster = null;
  //                                             // _cartController
  //                                             //     .cartTotalQuantity.value = 0;
  //
  //                                             ///Fazool
  //                                             // if (kitchenPort != null) {
  //                                             //   print("kitchen Added");
  //                                             //   if (kitchenIp == '' &&
  //                                             //           kitchenPort == '' ||
  //                                             //       kitchenIp == null &&
  //                                             //           kitchenPort == null) {
  //                                             //     print("kitchen ip empty");
  //                                             //   } else {
  //                                             //     print(" kitchen ip not empty");
  //                                             //     testPrintKitchen(
  //                                             //         kitchenIp!,
  //                                             //         kitchenPort!,
  //                                             //         context,
  //                                             //         _cartController
  //                                             //             .cartMaster!);
  //                                             //   }
  //                                             // }
  //                                           }),
  //                                     ),
  //                                   ],
  //                                 );
  //                               } else {
  //                                 return Row(
  //                                   children: [
  //                                     Expanded(
  //                                       child: NumberButton(
  //                                           value: 'Pay Later',
  //                                           btnColor: Colors.green,
  //                                           onTapped: () {
  //                                             orderPaymentType =
  //                                                 'INCOMPLETE ORDER';
  //                                             placeOrder(1);
  //
  //                                             ///Last Changing
  //                                             // if (kitchenPort != null) {
  //                                             //   print("kitchen Added");
  //                                             //   if (kitchenIp == '' &&
  //                                             //           kitchenPort == '' ||
  //                                             //       kitchenIp == null &&
  //                                             //           kitchenPort == null) {
  //                                             //     print("kitchen ip empty");
  //                                             //   } else {
  //                                             //     print(" kitchen ip not empty");
  //                                             //     testPrintKitchen(
  //                                             //         kitchenIp!,
  //                                             //         kitchenPort!,
  //                                             //         context,
  //                                             //         _cartController
  //                                             //             .cartMaster!);
  //                                             //   }
  //                                             // }
  //                                             // _cartController.cartMaster = null;
  //                                             // _cartController
  //                                             //     .cartTotalQuantity.value = 0;
  //                                           }),
  //                                     ),
  //                                     Expanded(
  //                                       child: NumberButton(
  //                                           value: 'POS CASH',
  //                                           btnColor: Colors.green,
  //                                           onTapped: () {
  //                                             if (_formKey.currentState!
  //                                                 .validate()) {
  //                                               orderPaymentType = 'POS CASH';
  //                                               placeOrder(2);
  //                                             }
  //                                             print("********");
  //
  //                                             ///Last Changing
  //                                             // if (posPort != null) {
  //                                             //   print("POS ADDED");
  //                                             //   if (posIp == '' &&
  //                                             //           posPort == '' ||
  //                                             //       posIp == null &&
  //                                             //           posPort == null) {
  //                                             //     print("pos ip empty");
  //                                             //   } else {
  //                                             //     print("pos ip not empty");
  //                                             //     testPrintPOS(
  //                                             //         posIp!,
  //                                             //         posPort!,
  //                                             //         context,
  //                                             //         _cartController
  //                                             //             .cartMaster!);
  //                                             //   }
  //                                             // }
  //                                             // if (kitchenPort != null) {
  //                                             //   print("kitchen Added");
  //                                             //   if (kitchenIp == '' &&
  //                                             //           kitchenPort == '' ||
  //                                             //       kitchenIp == null &&
  //                                             //           kitchenPort == null) {
  //                                             //     print("kitchen ip empty");
  //                                             //   } else {
  //                                             //     print(" kitchen ip not empty");
  //                                             //     testPrintKitchen(
  //                                             //         kitchenIp!,
  //                                             //         kitchenPort!,
  //                                             //         context,
  //                                             //         _cartController
  //                                             //             .cartMaster!);
  //                                             //   }
  //                                             // }
  //                                             // _cartController.cartMaster = null;
  //                                             // _cartController
  //                                             //     .cartTotalQuantity.value = 0;
  //
  //                                             /// Fazool
  //                                             // }
  //                                             //
  //                                             //     const PaperSize paper = PaperSize.mm80;
  //                                             //     final profile = await CapabilityProfile.load();
  //                                             //     final printer = NetworkPrinter(paper, profile);
  //                                             //
  //                                             //     final PosPrintResult res = await printer.connect('192.168.18.62', port: 9100);
  //                                             //
  //                                             //     if (res == PosPrintResult.success) {
  //                                             //       testReceipt(printer);
  //                                             //       printer.disconnect();
  //                                             //     }
  //                                             //
  //                                             //     print('Print result: ${res.msg}');
  //                                           }),
  //                                     ),
  //                                     Expanded(
  //                                       child: NumberButton(
  //                                           value: 'POS CARD',
  //                                           btnColor: Colors.green,
  //                                           onTapped: () {
  //                                             orderPaymentType = 'POS CARD';
  //                                             placeOrder(2);
  //
  //                                             ///Last Changing
  //                                             // if (posPort != null) {
  //                                             //   print("POS ADDED");
  //                                             //   if (posIp == '' &&
  //                                             //           posPort == '' ||
  //                                             //       posIp == null &&
  //                                             //           posPort == null) {
  //                                             //     print("pos ip empty");
  //                                             //   } else {
  //                                             //     print("pos ip not empty");
  //                                             //     testPrintPOS(
  //                                             //         posIp!,
  //                                             //         posPort!,
  //                                             //         context,
  //                                             //         _cartController
  //                                             //             .cartMaster!);
  //                                             //   }
  //                                             // }
  //                                             // if (kitchenPort != null) {
  //                                             //   print("kitchen Added");
  //                                             //   if (kitchenIp == '' &&
  //                                             //           kitchenPort == '' ||
  //                                             //       kitchenIp == null &&
  //                                             //           kitchenPort == null) {
  //                                             //     print("kitchen ip empty");
  //                                             //   } else {
  //                                             //     print(" kitchen ip not empty");
  //                                             //     testPrintKitchen(
  //                                             //         kitchenIp!,
  //                                             //         kitchenPort!,
  //                                             //         context,
  //                                             //         _cartController
  //                                             //             .cartMaster!);
  //                                             //   }
  //                                             // }
  //                                             // _cartController.cartMaster = null;
  //                                             // _cartController
  //                                             //     .cartTotalQuantity.value = 0;
  //                                           }),
  //                                     ),
  //                                   ],
  //                                 );
  //                               }
  //                             }(),
  //                           ],
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //
  //               //       Container(
  //               //         child: Row(
  //               //           children: [
  //               //             Expanded(
  //               //               child:  NumberButton(
  //               //                   value: '5% Discount',
  //               //                   btnColor: isDisabled == true ? Colors.grey : Colors.red.shade500,
  //               //                   onTapped: isDisabled == true ? (){} : () {
  //               // setState(() {
  //               // isDisabled = true;
  //               // });
  //               // calculateDiscount(0.05);
  //               // }),
  //               //             ),
  //               //             Expanded(
  //               //               child:  NumberButton(
  //               //                   value: '10% Discount',
  //               //                   btnColor: isDisabled == true ? Colors.grey : Colors.red.shade500,
  //               //                   onTapped: isDisabled == true ? (){} : () {
  //               //                     setState(() {
  //               //                       isDisabled = true;
  //               //                     });
  //               //                     calculateDiscount(0.010);
  //               //                   }),
  //               //             ),
  //               //             Expanded(
  //               //               child:  NumberButton(
  //               //                   value: '15% Discount',
  //               //                   btnColor: isDisabled == true ? Colors.grey : Colors.red.shade500,
  //               //                   onTapped: isDisabled == true ? (){} : () {
  //               //                     setState(() {
  //               //                       isDisabled = true;
  //               //                     });
  //               //                     calculateDiscount(0.015);
  //               //                   }),
  //               //             ),
  //               //           ],
  //               //         ),
  //               //       )
  //               // totalAmountController
  //
  //               Container(
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                       child: NumberButton(
  //                           value: '5% Discount',
  //                           btnColor:
  //                               _selectedButton == 0 || _selectedButton == -1
  //                                   ? Colors.red.shade500
  //                                   : Colors.grey,
  //                           onTapped: _selectedButton == 0
  //                               ? () {}
  //                               : () => _updatePrice(0)),
  //                     ),
  //                     Expanded(
  //                       child: NumberButton(
  //                           value: '10% Discount',
  //                           btnColor:
  //                               _selectedButton == 1 || _selectedButton == -1
  //                                   ? Colors.red.shade500
  //                                   : Colors.grey,
  //                           onTapped: _selectedButton == 1
  //                               ? () {}
  //                               : () => _updatePrice(1)),
  //                     ),
  //                     Expanded(
  //                       child: NumberButton(
  //                           value: '15% Discount',
  //                           btnColor:
  //                               _selectedButton == 2 || _selectedButton == -1
  //                                   ? Colors.red.shade500
  //                                   : Colors.grey,
  //                           onTapped: _selectedButton == 2
  //                               ? () {}
  //                               : () => _updatePrice(2)),
  //                     ),
  //                     Expanded(
  //                       child: NumberButton(
  //                           value: 'Clear Discount',
  //                           btnColor:
  //                               _selectedButton == 3 || _selectedButton == -1
  //                                   ? Colors.red.shade500
  //                                   : Colors.grey,
  //                           onTapped:
  //                               _selectedButton == 3 || _selectedButton == -1
  //                                   ? () {}
  //                                   : () => _updatePrice(3)),
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),

  calculateChanged() {
    if (receivedController.text.isNotEmpty) {
      if (double.parse(receivedController.text) >=
          double.parse(totalAmountController.text)) {
        changedController.text = (double.parse(receivedController.text) -
                double.parse(totalAmountController.text))
            .toStringAsFixed(2);
      } else {
        changedController.text = 'Received Amount is less than total amount';
      }
    } else {
      changedController.text = '0';
    }
  }

  // if (response.orderId == 0.toString()) {
  //   print("Number ${number.toString()}");
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int? savedOrderId = prefs.getInt(Constants.order_main_id.toString());
  //   print("saved ${savedOrderId.toString()}");
  //   number = "#${savedOrderId}";
  //   if(mounted) {
  //     setState(() {
  //       orderId = number;
  //     });
  //   }
  // } else {
  //   if(mounted) {
  //     setState(() {
  //       orderId = response.order_id;
  //     });
  //   }
  // }

  Future<BaseModel<common.CommenRes>> placeOrder(int value, String id) async {
    final prefs = await SharedPreferences.getInstance();
    // String shiftName = prefs.getString(Constants.shiftName.toString()) ?? '';
    String shiftCode = prefs.getString(Constants.shiftCode.toString()) ?? '';
    // if(shiftName.isEmpty && shiftCodeBefore.isEmpty){
    //   var response = await shiftController.createShiftDetails(context, 'auto_generated_shift_code');
    // }
    // String shiftCode = prefs.getString(Constants.shiftCode.toString()) ?? '';
    common.CommenRes res;
    try {
      Constants.onLoading(context);
      var random = Random();
      var uniqueId = '';
      print("value id $value");
      if(value == 0 || value == 2){
         uniqueId = random.nextInt(999999999).toString().padRight(10, '0');
         print("unique id $uniqueId");
      }
      print(uniqueId);
      Map<String, dynamic> body = {
        'notes': widget.notes,
        'discounts': _selectedButton == -1
            ? null
            : _selectedButton == 0
                ? discount
                : _selectedButton == 1
                    ? discount
                    : _selectedButton == 2
                        ? discount
                        : null,
        'vendor_id': widget.venderId.toString(),
        'linkly_id': uniqueId,
        'date': widget.orderDate,
        'shift_code': shiftCode,
        'time': widget.orderTime,
        'delivery_time': widget.deliveryTime,
        'delivery_date': widget.deliveryDate,
        'item': json.encode(_cartController.cartMaster!.toMap()),
        'amount': totalAmountController.text,
        'cash_amount': orderPaymentType == 'CASH+CARD' ? posCashAmountController.text : orderPaymentType == 'POS CASH' || orderPaymentType == 'POS CASH TAKEAWAY' ? totalAmountController.text : '',
        'card_amount': orderPaymentType == 'CASH+CARD' ? posCardAmountController.text : orderPaymentType == 'POS CARD' || orderPaymentType == 'POS CARD TAKEAWAY' ? totalAmountController.text : '',
        'delivery_type': widget.orderDeliveryType,
        'delivery_charge': widget.orderDeliveryCharge,
        'payment_type': orderPaymentType,
        'payment_status': '0',
        'order_status': 'APPROVE',
        // 'order_status': widget.orderStatus,
        'user_name': widget.userName,
        'mobile': widget.mobileNumber,
        'custimization': '',
        'promocode_id': _cartController.strAppiedPromocodeId,
        'promocode_price': widget.vendorDiscountAmount != 0
            ? widget.vendorDiscountAmount.toString()
            : '',
        'tax': widget.strTaxAmount.toStringAsFixed(2),
        'sub_total': widget.subTotal!.toStringAsFixed(2),
        'table_no': widget.tableNumber?.toString(),
        'old_order_id': _cartController.cartMaster!.oldOrderId?.toString(),
      };
      res = await RestClient(await RetroApi().dioData()).bookOrder(body);



      if (res.success!) {
        _linklyDataController.dialogTitle.value = '';
        _linklyDataController.dialogContent.value = '';
        Constants.toastMessage(res.data!);
        Map<String, dynamic> jsonMap =
        jsonDecode(res.orderData!.orderData!);
        OrderDataModel orderData =
        OrderDataModel.fromJson(jsonMap);
        print("old_order_id ${_cartController.cartMaster!.oldOrderId.toString()}");
        print("orderData ${orderData.oldOrderId}");
        if (value == 0) {
          if(_autoPrinterController.autoPrint.value == true) {
            if (_printerController.printerModel.value.portPos != null) {
              print("POS ADDED");
              if (_printerController.printerModel.value.ipPos == '' &&
                  _printerController.printerModel.value.portPos == '' ||
                  _printerController.printerModel.value.ipPos == null &&
                      _printerController.printerModel.value.portPos == null) {
                print("pos ip empty");
              } else {
                print("pos ip not empty");
                print("test pos ip not empty");
                print("Cart ${_cartController.cartMaster!.toMap()}");
                testPrintPOS(
                    _printerController.printerModel.value.ipPos!,
                    int.parse(
                        _printerController.printerModel.value.portPos
                            .toString()),

                    res.orderData!,
                    orderData
                    );
              }
            }
          }
        } else if (value == 1) {
          if(_autoPrinterController.autoPrintKitchen.value == true) {
            if (_printerController.printerModel.value.portKitchen != null) {
              print("kitchen Added");
              if (_printerController.printerModel.value.ipKitchen == '' &&
                  _printerController.printerModel.value.portKitchen == '' ||
                  _printerController.printerModel.value.ipKitchen == null &&
                      _printerController.printerModel.value.portKitchen ==
                          null) {
                print("kitchen ip empty");
              } else {
                print(" kitchen ip not empty");
                testPrintKitchen(
                    _printerController.printerModel.value.ipKitchen!,
                    int.parse(_printerController.printerModel.value.portKitchen
                        .toString()),

                    res.orderData!,
                    orderData);
              }
            }
          }
        } else if (value == 2) {
          if(_autoPrinterController.autoPrint.value == true) {
            if (_printerController.printerModel.value.portPos != null) {
              print("POS ADDED");
              if (_printerController.printerModel.value.ipPos == '' &&
                  _printerController.printerModel.value.portPos == '' ||
                  _printerController.printerModel.value.ipPos == null &&
                      _printerController.printerModel.value.portPos == null) {
                print("pos ip empty");
              } else {
                print("pos ip not empty");
                testPrintPOS(
                    _printerController.printerModel.value.ipPos!,
                    int.parse(
                        _printerController.printerModel.value.portPos
                            .toString()),

                    res.orderData!,
                    orderData);
              }
            }
          }
          if(_autoPrinterController.autoPrintKitchen.value == true) {
            if (_printerController.printerModel.value.portKitchen != null) {
              print("kitchen Added");
              if (_printerController.printerModel.value.ipKitchen == '' &&
                  _printerController.printerModel.value.portKitchen == '' ||
                  _printerController.printerModel.value.ipKitchen == null &&
                      _printerController.printerModel.value.portKitchen ==
                          null) {
                print("kitchen ip empty");
              } else {
                print(" kitchen ip not empty");
                testPrintKitchen(
                    _printerController.printerModel.value.ipKitchen!,
                    int.parse(_printerController.printerModel.value.portKitchen
                        .toString()),
                    res.orderData!,
                    orderData);
              }
            }
          }
        } else {}
        if(widget.orderDeliveryType == "DINING"){
          widget.notes == '' ?  _diningCartController.diningNotes = '' : widget.notes;
          widget.userName == '' ?  _diningCartController.diningUserName = '' : widget.userName;
          widget.mobileNumber == '' ?  _diningCartController.diningUserMobileNumber = '' : widget.mobileNumber;
        } else {
          widget.notes == '' ?  _cartController.notes = '' : widget.notes;
          widget.userName == '' ?  _cartController.userName = '' : widget.userName;
          widget.mobileNumber == '' ?  _cartController.userMobileNumber = '' : widget.mobileNumber;
        }
        _diningCartController.diningNotes = '';
        _diningCartController.diningUserName = '';
        _diningCartController.diningUserMobileNumber = '';
        _cartController.notes = '';
        _cartController.userName = '';
        _cartController.userMobileNumber = '';
        _diningCartController.phoneNoController.clear();
        _diningCartController.nameController.clear();
        _diningCartController.notesController.clear();
        _cartController.phoneNoController.clear();
        _cartController.nameController.clear();
        _cartController.notesController.clear();
        widget.orderDeliveryType == "DINING"
            ? _cartController.diningValue = true
            : false;
        _cartController.cartMaster = null;
        _cartController.cartTotalQuantity.value = 0;
        // _orderHistoryController.callGetOrderHistoryList();

        // Future.delayed(Duration(seconds: 3), () {
        Get.offAll(
          () => PosMenu(isDining: false),
          //   Get.offAll(
          // () => OrderHistory(),
        );
        // });
      } else {
        Constants.toastMessage('Errow while place order.');
      }
    } catch (error, stacktrace) {
      print("catch");

      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = res;
  }


  String addStringIntoInt(int number) {
    String stringNumber = receivedController.text;
    if (stringNumber.isEmpty) {
      return number.toString();
    } else {
      return (double.parse(stringNumber) + number).toString();
    }
  }

    void showMyDialog(BuildContext context, TextEditingController poscashController,TextEditingController poscardController ) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('Split Payment Method')),
            content: Form(
              key: _formDialogKey,
              child: Container(
                height: Get.height / 5,
                width: Get.width / 4,
                child: Column(

                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'please enter amount';
                                }
                              },
                              controller: poscashController,
                              decoration: InputDecoration(labelText: 'Pos Cash'),
                              inputFormatters: [
                                DecimalTextInputFormatter(decimalRange: 2)
                              ],
                              onChanged: (String? val) {
                                calculateCashToCardChanged();
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'please enter amount';
                                }
                              },
                              controller: poscardController,
                              inputFormatters: [
                                DecimalTextInputFormatter(decimalRange: 2)
                              ],
                              onChanged: (String? val) {
                                calculateCardToCardChanged();
                              },
                              decoration: InputDecoration(labelText: 'Pos Card'),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Customize padding// Customize minimum size
                      ),
                      onPressed: () {
                        print("card main ${posCardAmountController.text} cash main ${posCashAmountController.text}");
                        print("card ${poscardController.text} cash ${poscashController.text}");
                        if(_formDialogKey.currentState!.validate()) {
                          Constants.onLoading(context);
                          placeOrder(0, '');
                          // Constants.hideDialog(context);
                        }// Go back to the previous screen
                      },
                      child: Text('Ok'),
                    ),
                  ],
                ),
              ),
            ),
            // actions: [
            //
            // ],
          );
        },
      );
    }

    calculateCashToCardChanged() {
      if (totalAmountController.text.isNotEmpty) {
        if(posCashAmountController.text.isEmpty){
          posCashAmountController.text = '0.00';
        }
        if (double.parse(totalAmountController.text.toString()) >=
            double.parse(posCashAmountController.text.toString())) {
          posCardAmountController.text =
              (double.parse(totalAmountController.text.toString()) -
                      double.parse(posCashAmountController.text.toString()))
                  .toStringAsFixed(2);
        } else {
            posCardAmountController.text =
            'Excessive amount';
          }

      } else {
        posCardAmountController.text = '0';
      }
    }

    calculateCardToCardChanged() {
      if (totalAmountController.text.isNotEmpty) {
        if(posCardAmountController.text.isEmpty){
          posCardAmountController.text = '0.00';
        }
          if (double.parse(totalAmountController.text.toString()) >=
              double.parse(posCardAmountController.text.toString())) {
            posCashAmountController.text =
                (double.parse(totalAmountController.text.toString()) -
                    double.parse(posCardAmountController.text.toString()))
                    .toStringAsFixed(2);
          } else {
            posCashAmountController.text =
            'Excessive amount';
          }

      } else {
        posCashAmountController.text = '0';
      }
    }

// calculateDiscount(double discountPercentageValue, int _selectedButton) {
//     print("total amount ${widget.totalAmount.toString()}");

//     print("total amount controller ${totalAmountController.text}");
//       double discountAmount = (double.parse(totalAmountController.text) *
//           discountPercentageValue);
//       double discountedTotal = double.parse(totalAmountController.text) -
//           discountAmount;
//       totalAmountController.text = discountedTotal.toStringAsFixed(2);
//
// }
}

// Buttons
///
// Unit Test
class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}



