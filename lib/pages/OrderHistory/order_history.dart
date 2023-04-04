import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/controller/auth_controller.dart';
import 'package:pos/controller/cart_controller.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/controller/order_history_controller.dart';
import 'package:pos/controller/order_history_controller.dart';
import 'package:pos/model/cart_master.dart';
import 'package:pos/model/common_res.dart';
import 'package:pos/model/order_history_list_model.dart';
import 'package:pos/model/vendor/common_response.dart';
import 'package:pos/pages/cart_screen.dart';
import 'package:pos/pages/pos/pos_menu.dart';
import 'package:pos/printer/printer_controller.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/screen_animation_utils/transitions.dart';

// import 'package:pos/screens/order_tracking/trackingScreen.dart';
// import 'package:pos/utils/SharedPreferenceUtil.dart';
import 'package:pos/utils/app_toolbar_with_btn_clr.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/app_strings.dart';
import '../order_review_screen.dart';
import '../vendor_menu.dart';

enum FilterType { TakeAway, DineIn, None }

class OrderHistory extends StatefulWidget {
  final bool isFromProfile;

  const OrderHistory({Key? key, required this.isFromProfile}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  PrinterController _printerController = Get.find<PrinterController>();
  OrderHistoryController _orderHistoryController =
      Get.find<OrderHistoryController>();
  OrderCustimizationController _orderCustimizationController =
      Get.find<OrderCustimizationController>();

  DatabaseReference _firebaseRef = FirebaseDatabase.instance.reference();
  Future<BaseModel<OrderHistoryListModel>>? orderHistoryRef;
  TextEditingController _textOrderCancelReason = new TextEditingController();
  StreamSubscription<DatabaseEvent>? firebaseListener;
  CartController _cartController = Get.find<CartController>();
  RxList<dynamic> dynamicList = RxList<dynamic>();

  // RxList<OrderHistoryData> _totalOrders = RxList<OrderHistoryData>();
  // RxList<OrderHistoryData> _takeAwayOrders = RxList<OrderHistoryData>();
  // RxList<OrderHistoryData> _DineInOrders = RxList<OrderHistoryData>();
  // FilterType _filterType = FilterType.None;

  @override
  void initState() {
    // orderHistoryRef = _orderHistoryController.refreshOrderHistory(context);
    // orderHistoryRef!.then((value) {
    //   _totalOrders.value = value.data!.data!;
    //   value.data!.data!.forEach((element) {
    //   if(element.deliveryType == "TAKEAWAY"){
    //     _takeAwayOrders.add(element);
    //   } else if(element.deliveryType == "DINING"){
    //     _DineInOrders.add(element);
    //   }
    //   });
    //
    // });

    _getOrders();
    initAsync();
    print("<><><><><><><><><><>");
    // print(_printerController.printerModel.value.ipPos!);
    // print(_printerController.printerModel.value.portPos);
    print("<><><><><><><><><><>");

    super.initState();
  }

  void testPrintPOS(String printerIp, int port, BuildContext ctx,
      OrderHistoryData order) async {
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
      if (order != null) {
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
        printPOSReceipt(printer, order);
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
    OrderHistoryData order,
  ) {
    // // Print image
    // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
    // final Uint8List bytes = data.buffer.asUint8List();
    // final img.Image? image = img.decodeImage(bytes);
    // printer.image(image!);
    printer.text(order.vendor!.name!,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    printer.text(order.vendor!.mapAddress.toString(),
        styles: PosStyles(align: PosAlign.center));
    // printer.text('New Braunfels, TX',
    //     styles: PosStyles(align: PosAlign.center));

    printer.text("Phone : ${order.vendor!.contact.toString()}",
        styles: PosStyles(align: PosAlign.left));

    printer.text("Order Id ${order.order_id.toString()}",
        styles: PosStyles(align: PosAlign.left));

    if (order.user!.name.isNotEmpty && order.user!.phone.isNotEmpty) {
      printer.text('Customer Name : ${order.user!.name}',
          styles: PosStyles(align: PosAlign.left));

      printer.text('Customer Phone No : ${order.user!.phone}',
          styles: PosStyles(align: PosAlign.left));
    }

    // printer.text('${order.time} ${widget.orderTime}',
    //     styles: PosStyles(align: PosAlign.left));
    printer.text('${order.time}', styles: PosStyles(align: PosAlign.left));

    // printer.text('Customer Name : ${restaurantDetails.data!.data!.vendor!.name}',
    //     styles: PosStyles(align: PosAlign.center));
    // printer.text('Customer Phone : ${restaurantDetails.data!.data!.vendor!.contact}',
    //     styles: PosStyles(align: PosAlign.center));
    // printer.text('Vendor type : ${restaurantDetails.data!.data!.vendor!.vendorType}',
    //     styles: PosStyles(align: PosAlign.center));
    if (order.tableNo != null && order.tableNo != 0) {
      printer.text('Table Number : ${order.tableNo}',
          styles: PosStyles(align: PosAlign.left));
    }

    if (order.payment_type.toString() == "INCOMPLETE ORDER") {
      printer.text('Payment Status : INCOMPLETE PAYMENT',
          styles: PosStyles(align: PosAlign.left));
    } else {
      printer.text('Payment Status : ${order.payment_type.toString()}',
          styles: PosStyles(align: PosAlign.left));
    }

    printer.text('Order Type :  ${order.deliveryType.toString()}',
        styles: PosStyles(align: PosAlign.left));

    // printer.text('Web: www.example.com',
    //     styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    printer.hr();
    printer.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Item', width: 9),
      PosColumn(
          text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    for (int itemIndex = 0; itemIndex < order.orderItems!.length; itemIndex++) {
      OrderItems orderItem = order.orderItems![itemIndex];
      printer.row([
        PosColumn(text: orderItem.qty.toString(), width: 1),
        PosColumn(
          text: orderItem.itemName.toString(),
          width: 9,
        ),
        PosColumn(
            text: orderItem.price.toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]);

      ///Addons
      // for (int addonIndex = 0; addonIndex < order; addonIndex++) {
      //   AddonCartMaster addonItem = menuItem.addons[addonIndex];
      //   if (addonIndex == 0) {
      //     printer.row([
      //       PosColumn(
      //           text: "-ADDONS-",
      //           width: 12,
      //           styles: PosStyles(
      //               width: PosTextSize.size1,
      //               height: PosTextSize.size1,
      //               align: PosAlign.center))
      //     ]);
      //   }
      //   printer.row([
      //     PosColumn(text: '', width: 1),
      //     PosColumn(text: addonItem.name, width: 9),
      //     // PosColumn(
      //     // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //     PosColumn(
      //         text: addonItem.price.toString(),
      //         width: 2,
      //         styles: PosStyles(align: PosAlign.right)),
      //   ]);
      // }

      ///Chening deals and half and half
      //if (category == 'SINGLE') {
      //         Cart cartItem = cart[itemIndex];
      //         printer.row([
      //           PosColumn(
      //               text: "-SINGLE-",
      //               width: 12,
      //               styles: PosStyles(
      //                   width: PosTextSize.size1,
      //                   height: PosTextSize.size1,
      //                   align: PosAlign.center))
      //         ]);
      //
      //         for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
      //           MenuCartMaster menuItem = menu[menuIndex];
      //           printer.row([
      //             PosColumn(text: cartItem.quantity.toString(), width: 1),
      //             PosColumn(
      //               text: menu[menuIndex].name +
      //                   (cart[itemIndex].size != null
      //                       ? '(${cart[itemIndex].size?.sizeName})'
      //                       : ''),
      //               width: 9,
      //             ),
      //             PosColumn(
      //                 text: cartItem.totalAmount.toString(),
      //                 width: 2,
      //                 styles: PosStyles(align: PosAlign.right)),
      //           ]);
      //           for (int addonIndex = 0;
      //               addonIndex < menuItem.addons.length;
      //               addonIndex++) {
      //             AddonCartMaster addonItem = menuItem.addons[addonIndex];
      //             if (addonIndex == 0) {
      //               printer.row([
      //                 PosColumn(
      //                     text: "-ADDONS-",
      //                     width: 12,
      //                     styles: PosStyles(
      //                         width: PosTextSize.size1,
      //                         height: PosTextSize.size1,
      //                         align: PosAlign.center))
      //               ]);
      //             }
      //             printer.row([
      //               PosColumn(text: '', width: 1),
      //               PosColumn(text: addonItem.name, width: 9),
      //               // PosColumn(
      //               // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //               PosColumn(
      //                   text: addonItem.price.toString(),
      //                   width: 2,
      //                   styles: PosStyles(align: PosAlign.right)),
      //             ]);
      //           }
      //         }
      //       } else if (category == 'HALF_N_HALF') {
      //         Cart cartItem = cart[itemIndex];
      //         printer.row([
      //           PosColumn(
      //               text: "-HALF & HALF-",
      //               width: 12,
      //               styles: PosStyles(
      //                   width: PosTextSize.size1,
      //                   height: PosTextSize.size1,
      //                   align: PosAlign.center))
      //         ]);
      //         printer.row([
      //           PosColumn(text: cartItem.quantity.toString(), width: 1),
      //           PosColumn(
      //               text: menuCategory!.name +
      //                   (cartItem.size != null ? '(${cartItem.size?.sizeName})' : ''),
      //               width: 9,
      //               styles: PosStyles(
      //                   width: PosTextSize.size1, height: PosTextSize.size1)),
      //           // PosColumn(
      //           // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //           PosColumn(
      //               text: cartItem.totalAmount.toString(),
      //               width: 2,
      //               styles: PosStyles(align: PosAlign.right)),
      //         ]);
      //
      //         for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
      //           MenuCartMaster menuItem = menu[menuIndex];
      //           printer.row([
      //             PosColumn(
      //                 text: ' ${menuIndex == 0 ? '-1st Half-' : "-2nd Half-"}',
      //                 width: 12,
      //                 styles: PosStyles(
      //                     width: PosTextSize.size1,
      //                     height: PosTextSize.size1,
      //                     align: PosAlign.center))
      //           ]);
      //           printer.row([
      //             PosColumn(text: '', width: 1),
      //             PosColumn(text: menuItem.name + '', width: 9),
      //             // PosColumn(
      //             // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //             PosColumn(
      //                 text: '', width: 2, styles: PosStyles(align: PosAlign.right)),
      //           ]);
      //
      //           for (int addonIndex = 0;
      //               addonIndex < menuItem.addons.length;
      //               addonIndex++) {
      //             AddonCartMaster addonItem = menuItem.addons[addonIndex];
      //             if (addonIndex == 0) {
      //               printer.row([
      //                 PosColumn(
      //                     text: "-ADDONS-",
      //                     width: 12,
      //                     styles: PosStyles(
      //                         width: PosTextSize.size1,
      //                         height: PosTextSize.size1,
      //                         align: PosAlign.center))
      //               ]);
      //             }
      //             printer.row([
      //               PosColumn(text: '', width: 1),
      //               PosColumn(text: addonItem.name, width: 9),
      //               // PosColumn(
      //               // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //               PosColumn(
      //                   text: addonItem.price.toString(),
      //                   width: 2,
      //                   styles: PosStyles(align: PosAlign.right)),
      //             ]);
      //           }
      //         }
      //       } else if (category == 'DEALS') {
      //         Cart cartItem = cart[itemIndex];
      //
      //         printer.row([
      //           PosColumn(
      //               text: "-DEALS-",
      //               width: 12,
      //               styles: PosStyles(
      //                   width: PosTextSize.size1,
      //                   height: PosTextSize.size1,
      //                   align: PosAlign.center))
      //         ]);
      //         printer.row([
      //           PosColumn(text: cartItem.quantity.toString(), width: 1),
      //           PosColumn(
      //               text: menuCategory!.name +
      //                   (cartItem.size != null ? '(${cartItem.size?.sizeName})' : ''),
      //               width: 9,
      //               styles: PosStyles(
      //                   width: PosTextSize.size1, height: PosTextSize.size1)),
      //           // PosColumn(
      //           // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //           PosColumn(
      //               text: cartItem.totalAmount.toString(),
      //               width: 2,
      //               styles: PosStyles(align: PosAlign.right)),
      //         ]);
      //         for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
      //           MenuCartMaster menuItem = menu[menuIndex];
      //           DealsItems dealsItems = menu[menuIndex].dealsItems!;
      //           printer.row([
      //             PosColumn(
      //                 text: "-${menuItem.name}(${dealsItems.name})-",
      //                 width: 12,
      //                 styles: PosStyles(
      //                     width: PosTextSize.size1,
      //                     height: PosTextSize.size1,
      //                     align: PosAlign.center))
      //           ]);
      //           for (int addonIndex = 0;
      //               addonIndex < menuItem.addons.length;
      //               addonIndex++) {
      //             AddonCartMaster addonItem = menuItem.addons[addonIndex];
      //             if (addonIndex == 0) {
      //               printer.row([
      //                 PosColumn(width: 1),
      //                 PosColumn(
      //                     text: "        -ADDONS-",
      //                     width: 9,
      //                     styles: PosStyles(
      //                         width: PosTextSize.size1,
      //                         height: PosTextSize.size1,
      //                         align: PosAlign.center)),
      //                 PosColumn(width: 2),
      //               ]);
      //             }
      //             printer.row([
      //               PosColumn(text: '', width: 1),
      //               PosColumn(text: addonItem.name, width: 9),
      //               // PosColumn(
      //               // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
      //               PosColumn(
      //                   text: addonItem.price.toString(),
      //                   width: 2,
      //                   styles: PosStyles(align: PosAlign.right)),
      //             ]);
      //           }
      //         }
      //       }
    }
    printer.hr();

    ///Tax and Subtotal
    // printer.row([
    //   PosColumn(
    //       text: 'SubTotal',
    //       width: 6,
    //       styles: PosStyles(
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    //   PosColumn(
    //       text: "$currencySymbol${widget.subTotal}",
    //       width: 6,
    //       styles: PosStyles(
    //         align: PosAlign.right,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    // ]);
    //
    // printer.row([
    //   PosColumn(
    //       text: 'Tax',
    //       width: 6,
    //       styles: PosStyles(
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    //   PosColumn(
    //       text: "$currencySymbol${widget.strTaxAmount}",
    //       width: 6,
    //       styles: PosStyles(
    //         align: PosAlign.right,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1,
    //       )),
    // ]);

    ///Discount
    // if (order.amount != double.parse(totalAmountController.text)) {
    //   printer.row([
    //     PosColumn(
    //         text:
    //             'Discount ${_selectedButton == 0 ? "5%" : _selectedButton == 1 ? "10%" : _selectedButton == 2 ? "15%" : ''}',
    //         width: 6,
    //         styles: PosStyles(
    //           height: PosTextSize.size1,
    //           width: PosTextSize.size1,
    //         )),
    //     PosColumn(
    //         text:
    //             "$currencySymbol${widget.totalAmount - double.parse(totalAmountController.text)}",
    //         width: 6,
    //         styles: PosStyles(
    //           align: PosAlign.right,
    //           height: PosTextSize.size1,
    //           width: PosTextSize.size1,
    //         )),
    //   ]);
    // }

    printer.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: "${order.amount}",
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

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

  // void _applyFilter(FilterType filterType) {
  //   setState(() {
  //     _filterType = filterType;
  //   });
  // }

  // List<OrderHistoryData> _getFilteredOrders() {
  //   if (_filterType == FilterType.TakeAway) {
  //     return _takeAwayOrders;
  //   } else if (_filterType == FilterType.DineIn) {
  //     return _DineInOrders;
  //   } else {
  //     return _totalOrders;
  //   }
  // }

  initAsync() async {
    firebaseListener = _firebaseRef
        .child('orders')
        .child((await SharedPreferences.getInstance())
                .getString(Constants.loginUserId) ??
            '144')
        .onChildChanged
        .listen((event) {
      _orderHistoryController.refreshOrderHistory(context);
    });
  }

  // initAsync() async {
  //   firebaseListener = _firebaseRef
  //       .child('orders')
  //       .child((await SharedPreferences.getInstance())
  //               .getString(Constants.loginUserId) ??
  //           '144')
  //       .onChildChanged
  //       .listen((event) {
  //     _orderHistoryController.refreshOrderHistory(context);
  //   });
  // }

  final _totalOrders = <OrderHistoryData>[].obs;
  final _takeAwayOrders = <OrderHistoryData>[].obs;
  final _DineInOrders = <OrderHistoryData>[].obs;
  FilterType _filterType = FilterType.None;

  Future<void> _getOrders() async {
    orderHistoryRef = _orderHistoryController.refreshOrderHistory(context);
    final value = await orderHistoryRef;
    if (value!.data!.data!.isNotEmpty) {
      setState(() {
        _totalOrders.addAll(value.data!.data!);
        for (final element in value.data!.data!) {
          if (element.deliveryType == "TAKEAWAY") {
            _takeAwayOrders.add(element);
          } else if (element.deliveryType == "DINING") {
            _DineInOrders.add(element);
          }
        }
      });
    } else {
      // handle error case
    }
  }

  List<OrderHistoryData> _getFilteredOrders() {
    List<OrderHistoryData> filteredOrders = [];

    // get the orders based on the selected filter
    if (_filterType == FilterType.TakeAway) {
      filteredOrders = _takeAwayOrders;
    } else if (_filterType == FilterType.DineIn) {
      filteredOrders = _DineInOrders;
    } else {
      filteredOrders = _totalOrders;
    }

    if (_searchQuery.isNotEmpty) {
      filteredOrders = filteredOrders
          .where((order) =>
              (order.user_name != null &&
                  order.user_name
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase())) ||
              (order.order_id
                  .toLowerCase()
                  .contains('#${_searchQuery.toLowerCase()}')))
          .toList();
    }

    // filter the orders based on the search query
    // if (_searchQuery.isNotEmpty) {
    //   filteredOrders = filteredOrders
    //       .where((order) =>
    //       order.user_name
    //           .toLowerCase()
    //           .contains(_searchQuery.toLowerCase()) ||
    //   order.order_id
    //       .toLowerCase()
    //       .contains('#${_searchQuery.toLowerCase()}'))
    //       .toList();
    // }

    return filteredOrders;
  }

  void _applyFilter(FilterType filterType) {
    setState(() {
      _filterType = filterType;
    });
  }

  // List<OrderHistoryData> _getFilteredOrders() {
  //   if (_filterType == FilterType.TakeAway) {
  //     return _takeAwayOrders;
  //   } else if (_filterType == FilterType.DineIn) {
  //     return _DineInOrders;
  //   } else {
  //     return _totalOrders;
  //   }
  // }

  showCancelOrderDialog(int? orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                    bottom: 0,
                    top: ScreenUtil().setHeight(20)),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.42,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cancel Order',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(18),
                                fontWeight: FontWeight.w900,
                                fontFamily: Constants.appFontBold,
                              ),
                            ),
                            GestureDetector(
                              child: Icon(Icons.close),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      Divider(
                        thickness: 1,
                        color: Color(0xffcccccc),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      Text(
                        'Order Cancel Reason',
                        style: TextStyle(
                            fontFamily: Constants.appFontBold, fontSize: 16),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _textOrderCancelReason,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10),
                                hintText: 'Type Order Cancel Reason',
                                border: InputBorder.none),
                            maxLines: 5,
                            style: TextStyle(
                                fontFamily: Constants.appFont,
                                fontSize: 16,
                                color: Color(
                                  Constants.colorGray,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      Divider(
                        thickness: 1,
                        color: Color(0xffcccccc),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'No Go Back',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(14),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constants.appFontBold,
                                    color: Color(Constants.colorGray)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(12)),
                              child: GestureDetector(
                                onTap: () async {
                                  if (_textOrderCancelReason.text.isNotEmpty) {
                                    await callCancelOrder(
                                        orderId, _textOrderCancelReason.text);
                                  } else {
                                    Constants.toastMessage(
                                        'Please Enter Cancel Reason');
                                  }
                                },
                                child: Text(
                                  'Yes Cancel It',
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(14),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Constants.appFontBold,
                                      color: Color(Constants.colorBlue)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<BaseModel<CommenRes>> callCancelOrder(
      int? orderId, String cancelReason) async {
    CommenRes response;
    try {
      Constants.onLoading(context);
      Map<String, String> body = {
        'id': orderId.toString(),
        'cancel_reason': cancelReason,
      };
      response = await RestClient(await RetroApi().dioData()).cancelOrder(body);
      Constants.hideDialog(context);
      if (response.success!) {
        await getTakeAwayValue(orderId!).then((value) {
          print("value ${value.data}");
        });
        setState(() {
          orderHistoryRef =
              _orderHistoryController.refreshOrderHistory(context);
        });
        Navigator.pop(context);
        Constants.toastMessage(response.data!);
      } else {
        Constants.toastMessage(response.data!);
      }
    } catch (error, stacktrace) {
      Constants.hideDialog(context);
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _orderCustimizationController.callGetRestaurantsDetails(5);
        Get.off(() => PosMenu(
              isDining: _cartController.diningValue,
            ));
        return Future.value(true);
      },
      child: Scaffold(
        appBar: ApplicationToolbarWithClrBtn(
          appbarTitle: 'Order History',
          // str_button_title: Languages.of(context).labelClearList,
          strButtonTitle: "",
          btnColor: Color(Constants.colorLike),
          onBtnPress: () {},
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Color(Constants.colorScreenBackGround),
                image: DecorationImage(
                  image: AssetImage('images/ic_background_image.png'),
                  fit: BoxFit.cover,
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        delieveryTypeButton(
                            onTap: () => _applyFilter(FilterType.DineIn),
                            icon: Icons.card_travel,
                            title: "Dine In",
                            style: TextStyle(
                                color: _filterType == FilterType.DineIn
                                    ? Colors.white
                                    : Colors.black),
                            color: _filterType == FilterType.DineIn
                                ? Colors.white
                                : Colors.black,
                            buttonColor: _filterType == FilterType.DineIn
                                ? Colors.red.shade500
                                : Colors.white),
                        SizedBox(
                          width: 5,
                        ),
                        delieveryTypeButton(
                            onTap: () => _applyFilter(FilterType.TakeAway),
                            icon: Icons.table_bar,
                            title: "TakeAway",
                            style: TextStyle(
                                color: _filterType == FilterType.TakeAway
                                    ? Colors.white
                                    : Colors.black),
                            color: _filterType == FilterType.TakeAway
                                ? Colors.white
                                : Colors.black,
                            buttonColor: _filterType == FilterType.TakeAway
                                ? Colors.red.shade500
                                : Colors.white),
                      ],
                    ),
                    Container(
                      width: 180,
                      margin: EdgeInsets.only(right: 10),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Search',
                            labelStyle: TextStyle(color: Colors.black)
                            // border: OutlineInputBorder(),
                            ),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () => _applyFilter(FilterType.TakeAway),
                    //   child: Text('Takeaway'),
                    // ),
                    // ElevatedButton(
                    //   onPressed: () => _applyFilter(FilterType.DineIn),
                    //   child: Text('Dining'),
                    // ),
                  ],
                ),
                Expanded(
                  child: FutureBuilder<BaseModel<OrderHistoryListModel>>(
                    future: orderHistoryRef,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // show a CircularProgressIndicator while data is being fetched
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          padding:
                              EdgeInsets.only(bottom: 100, left: 10, right: 10),
                          scrollDirection: Axis.vertical,
                          itemCount: _getFilteredOrders().length,
                          itemBuilder: (BuildContext context, int index) {
                            // build the list item here
                            final order = _getFilteredOrders()[index];
                            print("order...${order.toJson()}");
                            // print("order data ${order.toJson()}");
                            // print("order.orderStatus ${order.orderStatus}");
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 10),
                                  child: Text(
                                    (() {
                                          if (order.addressId != null) {
                                            if (order.orderStatus ==
                                                'PENDING') {
                                              return '${'Ordered On'} ${order.date}, ${order.time}';
                                            } else if (order.orderStatus ==
                                                'ACCEPT') {
                                              return '${'Accepted On'} ${order.date}, ${order.time}';
                                            } else if (order.orderStatus ==
                                                'APPROVE') {
                                              return '${'Approve On'} ${order.date}, ${order.time}';
                                            } else if (order.orderStatus ==
                                                'REJECT') {
                                              return '${'Rejected On'} ${order.date}, ${order.time}';
                                            } else if (order.orderStatus ==
                                                'PICKUP') {
                                              return '${'Pickedup On'} ${order.date}, ${order.time}';
                                            } else if (order.orderStatus ==
                                                'DELIVERED') {
                                              return '${'Delivered On'} ${order.date}, ${order.time}';
                                            } else if (order.orderStatus ==
                                                'CANCEL') {
                                              return 'Canceled On ${order.date}, ${order.time}';
                                            } else if (order.orderStatus ==
                                                'COMPLETE') {
                                              return 'Delivered On ${order.date}, ${order.time}';
                                            }
                                          } else {
                                            if (order.orderStatus ==
                                                'PENDING') {
                                              return 'Ordered On ${order.date}, ${order.time}';
                                            } else if (order.orderStatus ==
                                                'ACCEPT') {
                                              return 'Accepted On ${order.date}, ${order.time}';
                                            } else if (order.orderStatus ==
                                                'APPROVE') {
                                              return 'Approve On ${order.date}, ${order.time}';
                                            } else if (order.orderStatus ==
                                                'REJECT') {
                                              return 'Rejected On ${order.date}, ${order.time}';
                                            } else if (order.orderStatus ==
                                                'PREPARE_FOR_ORDER') {
                                              return 'PREPARE FOR ORDER ${order.date}, ${order.time}';
                                            } else if (order.orderStatus ==
                                                'READY_FOR_ORDER') {
                                              return 'READY FOR ORDER ${order.date}, ${order.time}';
                                            } else if (order.orderStatus ==
                                                'CANCEL') {
                                              return 'Canceled On ${order.date}, ${order.time}';
                                            } else if (order.orderStatus ==
                                                'COMPLETE') {
                                              return 'Delivered On ${order.date}, ${order.time}';
                                            }
                                          }
                                        }()) ??
                                        '',
                                    style: TextStyle(
                                        color: Color(Constants.colorGray),
                                        fontFamily: Constants.appFont,
                                        fontSize: 12),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print(
                                        " orderData is .. ${order.deliveryType}");
                                    // // Constants.toastMessage(_orderHistoryController.listOrderHistory[index].id.toString());
                                    // Navigator.of(context).push(
                                    //     Transitions(
                                    //         transitionType:
                                    //         TransitionType.fade,
                                    //         curve:
                                    //         Curves.bounceInOut,
                                    //         reverseCurve: Curves
                                    //             .fastLinearToSlowEaseIn,
                                    //         widget:
                                    //         OrderDetailsScreen(
                                    //           orderId:
                                    //           _orderHistoryController.listOrderHistory[
                                    //           index]
                                    //               .id,
                                    //           orderDate:
                                    //           _orderHistoryController.listOrderHistory[
                                    //           index]
                                    //               .date,
                                    //           orderTime:
                                    //           _orderHistoryController.listOrderHistory[
                                    //           index]
                                    //               .time,
                                    //         )));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    margin: EdgeInsets.only(
                                        top: 20,
                                        left: 16,
                                        right: 16,
                                        bottom: 20),
                                    child: Column(
                                      children: [
                                        // (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' || _orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE')?
                                        //
                                        // GestureDetector(
                                        //   onTap: (){
                                        //     showCancelOrderDialog(_orderHistoryController.listOrderHistory[index].id);
                                        //   },
                                        //   child: Padding(
                                        //     padding: const EdgeInsets
                                        //         .only(
                                        //         top: 10,
                                        //         right:
                                        //         20),
                                        //     child:
                                        //     RichText(
                                        //       text:
                                        //       TextSpan(
                                        //         children: [
                                        //           WidgetSpan(
                                        //             child:
                                        //             Padding(
                                        //               padding: const EdgeInsets.only(right: 5),
                                        //               child: SvgPicture.asset('images/ic_cancel.svg',
                                        //
                                        //                 //  color: Color(Constants.colorTheme),
                                        //                 width: 15,
                                        //                 height: ScreenUtil().setHeight(15),
                                        //               ),
                                        //             ),
                                        //           ),
                                        //           TextSpan(
                                        //               text: 'Cancel this order',
                                        //               style: TextStyle(
                                        //                   color: Color(Constants.colorLike),
                                        //                   fontFamily: Constants.appFont,
                                        //                   fontSize: 12)),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ):Container(),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Padding(
                                            //   padding:
                                            //   const EdgeInsets
                                            //       .all(5.0),
                                            //   child: ClipRRect(
                                            //     borderRadius:
                                            //     BorderRadius
                                            //         .circular(
                                            //         15.0),
                                            //     child: CachedNetworkImage(
                                            //       height:
                                            //       100,
                                            //       width:
                                            //       100,
                                            //       imageUrl:
                                            //       _orderHistoryController.listOrderHistory[
                                            //       index]
                                            //           .vendor!
                                            //           .image!,
                                            //       fit: BoxFit.cover,
                                            //       placeholder: (context,
                                            //           url) =>
                                            //           SpinKitFadingCircle(
                                            //               color: Color(
                                            //                   Constants
                                            //                       .colorTheme)),
                                            //       errorWidget:
                                            //           (context, url,
                                            //           error) =>
                                            //           Container(
                                            //             child: Center(
                                            //                 child: Image.asset('images/noimage.png')),
                                            //           ),
                                            //     ),
                                            //   ),
                                            // ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10, top: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Order ${order.order_id.toString()} | ${order.user!.name} | ${order.vendor!.name!} | ${order.payment_type.toString()} | ${order.deliveryType} | ${order.user!.name} | ${order.user_name != null ? order.user_name : ''} | ${order.mobile != null ? order.mobile : ""}",
                                                          style: TextStyle(
                                                            fontFamily: Constants
                                                                .appFontBold,
                                                            fontSize: 12,
                                                            color: Color(
                                                                Constants
                                                                    .colorGray),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            // if (_printerController
                                                            //         .printerModel
                                                            //         .value
                                                            //         .ipPos! !=
                                                            //     null) {
                                                            //   print(_printerController
                                                            //       .printerModel
                                                            //       .value
                                                            //       .ipPos!);
                                                            //   print(_printerController
                                                            //       .printerModel
                                                            //       .value
                                                            //       .portPos);
                                                            // }

                                                            if (_printerController
                                                                    .printerModel
                                                                    .value
                                                                    .ipPos !=
                                                                null) {
                                                              testPrintPOS(
                                                                  _printerController
                                                                      .printerModel
                                                                      .value
                                                                      .ipPos!,
                                                                  int.parse(_printerController
                                                                      .printerModel
                                                                      .value
                                                                      .portPos
                                                                      .toString()),
                                                                  context,
                                                                  order);
                                                            } else {
                                                              Get.snackbar(
                                                                  "Error",
                                                                  "Please add printer ip and port");
                                                            }
                                                          },
                                                          icon:
                                                              Icon(Icons.print),
                                                        )
                                                      ],
                                                    ),

                                                    // child: Row(
                                                    //   children: [
                                                    //     // Expanded(
                                                    //     //   flex: 4,
                                                    //     //   child:
                                                    //     //   Padding(
                                                    //     //     padding: const EdgeInsets
                                                    //     //         .only(
                                                    //     //         left:
                                                    //     //         10,
                                                    //     //         top:
                                                    //     //         10),
                                                    //     //     child: Text(
                                                    //     //       "Order # ${_orderHistoryController.listOrderHistory[index].id.toString()}",
                                                    //     //       style: TextStyle(
                                                    //     //           fontFamily:
                                                    //     //           Constants.appFontBold,
                                                    //     //           fontSize: 16),
                                                    //     //     ),
                                                    //     //     // Text(
                                                    //     //     //   _orderHistoryController.listOrderHistory[index]
                                                    //     //     //       .vendor!
                                                    //     //     //       .name!,
                                                    //     //     //   style: TextStyle(
                                                    //     //     //       fontFamily:
                                                    //     //     //       Constants.appFontBold,
                                                    //     //     //       fontSize: 16),
                                                    //     //     // ),
                                                    //     //   ),
                                                    //     // ),
                                                    //     Text(
                                                    //       "Order # ${_orderHistoryController.listOrderHistory[index].id.toString()} | ${_orderHistoryController.listOrderHistory[index].user!.name}",
                                                    //       style: TextStyle(
                                                    //           fontFamily:
                                                    //           Constants.appFontBold,
                                                    //           fontSize: 12,
                                                    //       color: Color(Constants.colorGray),
                                                    //       ),
                                                    //     ),
                                                    //     Text(
                                                    //       ,
                                                    //       style: TextStyle(
                                                    //           fontFamily:
                                                    //           Constants.appFontBold,
                                                    //           fontSize: 12,
                                                    //         color: Color(Constants.colorGray),
                                                    //       ),
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                  ),
                                                  // Padding(
                                                  //   padding:
                                                  //   const EdgeInsets
                                                  //       .only(
                                                  //       top: 3,
                                                  //       left:
                                                  //       10,
                                                  //       right:
                                                  //       5),
                                                  //   child: Text(
                                                  //    _orderHistoryController.listOrderHistory[index].user!.name,
                                                  //     style: TextStyle(
                                                  //         fontFamily:
                                                  //         Constants.appFontBold,
                                                  //         fontSize: 12),
                                                  //   ),
                                                  // ),
                                                  ///Start vendor name
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets
                                                  //               .only(
                                                  //           top: 3,
                                                  //           left: 10,
                                                  //           right: 5),
                                                  //   child: Text(
                                                  //     _orderHistoryController
                                                  //         .listOrderHistory[
                                                  //             index]
                                                  //         .vendor!
                                                  //         .name!,
                                                  //     style: TextStyle(
                                                  //         fontFamily:
                                                  //             Constants
                                                  //                 .appFontBold,
                                                  //         fontSize: 10),
                                                  //   ),
                                                  // ),
                                                  ///End vendor Name
                                                  // Padding(
                                                  //   padding:
                                                  //   const EdgeInsets
                                                  //       .only(
                                                  //       top: 3,
                                                  //       left:
                                                  //       10,
                                                  //       right:
                                                  //       5),
                                                  //   child: Text(
                                                  //     _orderHistoryController.listOrderHistory[
                                                  //     index]
                                                  //         .vendor!
                                                  //         .mapAddress ?? '',
                                                  //     overflow:
                                                  //     TextOverflow
                                                  //         .ellipsis,
                                                  //     style: TextStyle(
                                                  //         fontFamily:
                                                  //         Constants
                                                  //             .appFont,
                                                  //         color: Color(
                                                  //             Constants
                                                  //                 .colorGray),
                                                  //         fontSize:
                                                  //         13),
                                                  //   ),
                                                  // ),
                                                  order.tableNo == 0
                                                      ? SizedBox()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 3,
                                                                  left: 10,
                                                                  right: 5),
                                                          child: Text(
                                                            "Table No ${order.tableNo.toString()}" ??
                                                                '',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    Constants
                                                                        .appFontBold,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                  SizedBox(
                                                    height: ScreenUtil()
                                                        .setHeight(5),
                                                  ),
                                                  ListView.builder(
                                                      padding: EdgeInsets.zero,
                                                      physics:
                                                          ClampingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount: order
                                                          .orderItems!.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int innerindex) {
                                                        print(
                                                            "order Items..${order.orderItems![innerindex].toJson()}");
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 1),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        order
                                                                            .orderItems![innerindex]
                                                                            .itemName
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                Constants.appFont,
                                                                            fontSize: 12),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(left: 5),
                                                                        child: Text(
                                                                            (() {
                                                                              String qty = '';
                                                                              if (order.orderItems!.length > 0 && order.orderItems != null) {
                                                                                // for (int i = 0; i < _orderHistoryController.listOrderHistory[index].orderItems.length; i++) {
                                                                                qty = ' X ${order.orderItems![innerindex].qty.toString()}';
                                                                                // }
                                                                                return qty;
                                                                              } else {
                                                                                return '';
                                                                              }
                                                                            }()),
                                                                            style: TextStyle(color: Color(Constants.colorTheme), fontFamily: Constants.appFont, fontSize: 12)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Text(order
                                                                      .orderItems![
                                                                          innerindex]
                                                                      .price
                                                                      .toString())
                                                                ],
                                                              ),
                                                              // order.addons!
                                                              //             .isEmpty ||
                                                              //         order.addons! ==
                                                              //             null
                                                              //     ? Container()
                                                              //     : Container(
                                                              //         height: 40,
                                                              //         child: ListView.builder(
                                                              //             // the number of items in the list
                                                              //             itemCount: order.addons!.length,
                                                              //             // display each item of the product list
                                                              //             itemBuilder: (context, addonsIndex) {
                                                              //               return Text(order
                                                              //                   .addons![addonsIndex]
                                                              //                   .toString());
                                                              //             }),
                                                              //       )
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5, top: 10),
                                          child: DottedLine(
                                            dashColor: Color(0xffcccccc),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 5,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                                text:
                                                                    'Total Amount : ${AuthController.sharedPreferences?.getString(Constants.appSettingCurrencySymbol) ?? ''}${order.amount} ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        Constants
                                                                            .appFont,
                                                                    fontSize:
                                                                        14),
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                    text: order.payment_type == "POS CASH" ||
                                                                            order.payment_type ==
                                                                                "POS CARD" ||
                                                                            order.payment_type ==
                                                                                "POS CASH TAKEAWAY" ||
                                                                            order.payment_type ==
                                                                                "POS CARD TAKEAWAY"
                                                                        ? '( Paid )'
                                                                        : '( Unpaid )',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red
                                                                            .shade500,
                                                                        fontFamily:
                                                                            Constants
                                                                                .appFont,
                                                                        fontSize:
                                                                            16),
                                                                  )
                                                                ]),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                WidgetSpan(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            5),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      (() {
                                                                            if (_orderHistoryController.listOrderHistory[index].addressId !=
                                                                                null) {
                                                                              if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
                                                                                return 'images/ic_pending.svg';
                                                                              } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
                                                                                return 'images/ic_accept.svg';
                                                                              } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
                                                                                return 'images/ic_accept.svg';
                                                                              } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
                                                                                return 'images/ic_cancel.svg';
                                                                              } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
                                                                                return 'images/ic_pickup.svg';
                                                                              } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
                                                                                return 'images/ic_completed.svg';
                                                                              } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
                                                                                return 'images/ic_cancel.svg';
                                                                              } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
                                                                                return 'images/ic_completed.svg';
                                                                              } else {
                                                                                return 'images/ic_accept.svg';
                                                                              }
                                                                            } else {
                                                                              if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
                                                                                return 'images/ic_pending.svg';
                                                                              } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
                                                                                return 'images/ic_accept.svg';
                                                                              } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
                                                                                return 'images/ic_pickup.svg';
                                                                              } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
                                                                                return 'images/ic_completed.svg';
                                                                              } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
                                                                                return 'images/ic_cancel.svg';
                                                                              } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
                                                                                return 'images/ic_cancel.svg';
                                                                              } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
                                                                                return 'images/ic_completed.svg';
                                                                              }
                                                                            }
                                                                          }()) ??
                                                                          '',
                                                                      color:
                                                                          (() {
                                                                        // your code here
                                                                        // _orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' ? 'Ordered on ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}' : 'Delivered on October 10,2020, 09:23pm',
                                                                        if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                            'PENDING') {
                                                                          return Color(
                                                                              Constants.colorOrderPending);
                                                                        } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                            'ACCEPT') {
                                                                          return Color(
                                                                              Constants.colorBlack);
                                                                        } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                            'PICKUP') {
                                                                          return Color(
                                                                              Constants.colorOrderPickup);
                                                                        }
                                                                      }()),
                                                                      width: 15,
                                                                      height: ScreenUtil()
                                                                          .setHeight(
                                                                              15),
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                    text: (() {
                                                                      if (_orderHistoryController
                                                                              .listOrderHistory[index]
                                                                              .deliveryType ==
                                                                          'TAKEAWAY') {
                                                                        if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                            'READY TO PICKUP') {
                                                                          return 'Waiting For User To Pickup';
                                                                        }
                                                                      } else {
                                                                        if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'READY TO PICKUP' ||
                                                                            _orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'ACCEPT') {
                                                                          return 'Waiting For Driver To Pickup';
                                                                        }
                                                                      }
                                                                      return _orderHistoryController
                                                                          .listOrderHistory[
                                                                              index]
                                                                          .orderStatus;
                                                                      // if (_orderHistoryController.listOrderHistory[index].addressId != null) {
                                                                      //
                                                                      //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
                                                                      //     return Languages.of(context)!.labelOrderPending;
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
                                                                      //     return Languages.of(context)!.labelOrderAccepted;
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
                                                                      //     return Languages.of(context)!.labelOrderAccepted;
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
                                                                      //     return Languages.of(context)!.labelOrderRejected;
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
                                                                      //     return 'PREPARING FOOD';
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
                                                                      //     return 'READY TO PICKUP';
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
                                                                      //     return Languages.of(context)!.labelOrderPickedUp;
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
                                                                      //     return Languages.of(context)!.labelDeliveredSuccess;
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
                                                                      //     return Languages.of(context)!.labelOrderCanceled;
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
                                                                      //     return Languages.of(context)!.labelOrderCompleted;
                                                                      //   }
                                                                      // } else {
                                                                      //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
                                                                      //     return Languages.of(context)!.labelOrderPending;
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
                                                                      //     return Languages.of(context)!.labelOrderAccepted;
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
                                                                      //     return Languages.of(context)!.labelOrderAccepted;
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
                                                                      //     return 'PREPARING FOOD';
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
                                                                      //     return 'READY TO PICKUP';
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
                                                                      //     return Languages.of(context)!.labelOrderRejected;
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
                                                                      //     return Languages.of(context)!.labelOrderCompleted;
                                                                      //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
                                                                      //     return Languages.of(context)!.labelOrderCanceled;
                                                                      //   }
                                                                      // }
                                                                    }()),
                                                                    style: TextStyle(
                                                                        color: (() {
                                                                          if (_orderHistoryController.listOrderHistory[index].addressId !=
                                                                              null) {
                                                                            if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'PENDING') {
                                                                              return Color(Constants.colorOrderPending);
                                                                            } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'APPROVE') {
                                                                              return Color(Constants.colorBlack);
                                                                            } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'ACCEPT') {
                                                                              return Color(Constants.colorBlack);
                                                                            } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'REJECT') {
                                                                              return Color(Constants.colorLike);
                                                                            } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'PICKUP') {
                                                                              return Color(Constants.colorOrderPickup);
                                                                            } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'DELIVERED') {
                                                                              // return Color(0xffffffff);

                                                                              return Color(Constants.colorTheme);
                                                                            } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'CANCEL') {
                                                                              return Color(Constants.colorTheme);
                                                                              // return Color(0xffffffff);
                                                                            } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'COMPLETE') {
                                                                              return Color(Constants.colorTheme);
                                                                              // return Color(0xffffffff);
                                                                            } else {
                                                                              // return Color(0xffffffff);
                                                                              return Color(Constants.colorTheme);
                                                                            }
                                                                          } else {
                                                                            if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'PENDING') {
                                                                              return Color(Constants.colorOrderPending);
                                                                            } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'APPROVE') {
                                                                              return Color(Constants.colorBlack);
                                                                            } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'ACCEPT') {
                                                                              return Color(Constants.colorBlack);
                                                                            } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'REJECT') {
                                                                              return Color(Constants.colorLike);
                                                                            } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'PREPARING FOOD') {
                                                                              return Color(Constants.colorOrderPickup);
                                                                            } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'READY TO PICKUP') {
                                                                              // return Color(0xffffffff);

                                                                              return Color(Constants.colorTheme);
                                                                            } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'CANCEL') {
                                                                              // return Color(0xffffffff);
                                                                              return Color(Constants.colorTheme);
                                                                            } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                                                'COMPLETE') {
                                                                              return Color(Constants.colorTheme);
                                                                              // return Color(0xffffffff);
                                                                            } else {
                                                                              // return Color(0xffffffff);
                                                                              return Color(Constants.colorTheme);
                                                                            }
                                                                          }
                                                                        }()),
                                                                        fontFamily: Constants.appFont,
                                                                        fontSize: 12)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    // Row(
                                                    //   mainAxisAlignment:
                                                    //       MainAxisAlignment
                                                    //           .center,
                                                    //   children: [
                                                    //     Text(
                                                    //       order.payment_type ==
                                                    //                   "POS CASH" ||
                                                    //               order.payment_type ==
                                                    //                   "POS CARD" ||
                                                    //               order.payment_type ==
                                                    //                   "POS CASH TAKEAWAY" ||
                                                    //               order.payment_type ==
                                                    //                   "POS CARD TAKEAWAY"
                                                    //           ? '( Paid )'
                                                    //           : '( Unpaid )',
                                                    //       style: TextStyle(
                                                    //           color: Colors
                                                    //               .red.shade500,
                                                    //           // fontWeight: FontWeight.bold,
                                                    //           fontFamily:
                                                    //               Constants
                                                    //                   .appFont,
                                                    //           fontSize: 18),
                                                    //     ),
                                                    //     // Expanded(
                                                    //     //   child: Padding(
                                                    //     //     padding:
                                                    //     //     const EdgeInsets
                                                    //     //         .only(
                                                    //     //         left: 10,
                                                    //     //         top: 10),
                                                    //     //     child: RichText(
                                                    //     //       text: TextSpan(
                                                    //     //         // text: order.amount,
                                                    //     //           text: AuthController
                                                    //     //               .sharedPreferences
                                                    //     //               ?.getString(
                                                    //     //               Constants
                                                    //     //                   .appSettingCurrencySymbol) ??
                                                    //     //               '' +
                                                    //     //                   '${order.amount} ',
                                                    //     //           style: TextStyle(
                                                    //     //               color: Colors.black,
                                                    //     //               fontFamily:
                                                    //     //               Constants
                                                    //     //                   .appFont,
                                                    //     //               fontSize:
                                                    //     //               14),
                                                    //     //           children: <
                                                    //     //               TextSpan>[
                                                    //     //             TextSpan(
                                                    //     //               text:
                                                    //     //               order.payment_type == "POS CASH" || order.payment_type == "POS CARD" ?  '( Payment Completed )' : '( Payment Incomplete )',
                                                    //     //               style: TextStyle(
                                                    //     //                   color: Colors.red.shade500,
                                                    //     //                   // fontWeight: FontWeight.bold,
                                                    //     //                   fontFamily:
                                                    //     //                   Constants
                                                    //     //                       .appFont,
                                                    //     //                   fontSize:
                                                    //     //                   14),
                                                    //     //             )
                                                    //     //           ]),
                                                    //     //     ),
                                                    //     //     // child: Text(
                                                    //     //     //   AuthController
                                                    //     //     //       .sharedPreferences
                                                    //     //     //       ?.getString(Constants
                                                    //     //     //       .appSettingCurrencySymbol) ??
                                                    //     //     //       '' +
                                                    //     //     //           '${order.amount}',
                                                    //     //     //   style: TextStyle(
                                                    //     //     //       fontFamily:
                                                    //     //     //       Constants
                                                    //     //     //           .appFont,
                                                    //     //     //       fontSize:
                                                    //     //     //       14),
                                                    //     //     // ),
                                                    //     //   ),
                                                    //     // ),
                                                    //     SizedBox(
                                                    //       width: 5,
                                                    //     ),
                                                    //     Padding(
                                                    //       padding:
                                                    //           const EdgeInsets
                                                    //                   .only(
                                                    //               // top: 10,
                                                    //               right: 20),
                                                    //       child: RichText(
                                                    //         text: TextSpan(
                                                    //           children: [
                                                    //             WidgetSpan(
                                                    //               child: Padding(
                                                    //                 padding: const EdgeInsets
                                                    //                         .only(
                                                    //                     right: 5),
                                                    //                 child:
                                                    //                     SvgPicture
                                                    //                         .asset(
                                                    //                   (() {
                                                    //                         if (_orderHistoryController.listOrderHistory[index].addressId !=
                                                    //                             null) {
                                                    //                           if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'PENDING') {
                                                    //                             return 'images/ic_pending.svg';
                                                    //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'APPROVE') {
                                                    //                             return 'images/ic_accept.svg';
                                                    //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'ACCEPT') {
                                                    //                             return 'images/ic_accept.svg';
                                                    //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'REJECT') {
                                                    //                             return 'images/ic_cancel.svg';
                                                    //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'PICKUP') {
                                                    //                             return 'images/ic_pickup.svg';
                                                    //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'DELIVERED') {
                                                    //                             return 'images/ic_completed.svg';
                                                    //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'CANCEL') {
                                                    //                             return 'images/ic_cancel.svg';
                                                    //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'COMPLETE') {
                                                    //                             return 'images/ic_completed.svg';
                                                    //                           } else {
                                                    //                             return 'images/ic_accept.svg';
                                                    //                           }
                                                    //                         } else {
                                                    //                           if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'PENDING') {
                                                    //                             return 'images/ic_pending.svg';
                                                    //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'APPROVE') {
                                                    //                             return 'images/ic_accept.svg';
                                                    //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'PREPARING FOOD') {
                                                    //                             return 'images/ic_pickup.svg';
                                                    //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'READY TO PICKUP') {
                                                    //                             return 'images/ic_completed.svg';
                                                    //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'REJECT') {
                                                    //                             return 'images/ic_cancel.svg';
                                                    //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'CANCEL') {
                                                    //                             return 'images/ic_cancel.svg';
                                                    //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                               'COMPLETE') {
                                                    //                             return 'images/ic_completed.svg';
                                                    //                           }
                                                    //                         }
                                                    //                       }()) ??
                                                    //                       '',
                                                    //                   color: (() {
                                                    //                     // your code here
                                                    //                     // _orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' ? 'Ordered on ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}' : 'Delivered on October 10,2020, 09:23pm',
                                                    //                     if (_orderHistoryController
                                                    //                             .listOrderHistory[
                                                    //                                 index]
                                                    //                             .orderStatus ==
                                                    //                         'PENDING') {
                                                    //                       return Color(
                                                    //                           Constants.colorOrderPending);
                                                    //                     } else if (_orderHistoryController
                                                    //                             .listOrderHistory[
                                                    //                                 index]
                                                    //                             .orderStatus ==
                                                    //                         'ACCEPT') {
                                                    //                       return Color(
                                                    //                           Constants.colorBlack);
                                                    //                     } else if (_orderHistoryController
                                                    //                             .listOrderHistory[index]
                                                    //                             .orderStatus ==
                                                    //                         'PICKUP') {
                                                    //                       return Color(
                                                    //                           Constants.colorOrderPickup);
                                                    //                     }
                                                    //                   }()),
                                                    //                   width: 15,
                                                    //                   height: ScreenUtil()
                                                    //                       .setHeight(
                                                    //                           15),
                                                    //                 ),
                                                    //               ),
                                                    //             ),
                                                    //             TextSpan(
                                                    //                 text: (() {
                                                    //                   if (_orderHistoryController
                                                    //                           .listOrderHistory[index]
                                                    //                           .deliveryType ==
                                                    //                       'TAKEAWAY') {
                                                    //                     if (_orderHistoryController
                                                    //                             .listOrderHistory[index]
                                                    //                             .orderStatus ==
                                                    //                         'READY TO PICKUP') {
                                                    //                       return 'Waiting For User To Pickup';
                                                    //                     }
                                                    //                   } else {
                                                    //                     if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'READY TO PICKUP' ||
                                                    //                         _orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'ACCEPT') {
                                                    //                       return 'Waiting For Driver To Pickup';
                                                    //                     }
                                                    //                   }
                                                    //                   return _orderHistoryController
                                                    //                       .listOrderHistory[
                                                    //                           index]
                                                    //                       .orderStatus;
                                                    //                   // if (_orderHistoryController.listOrderHistory[index].addressId != null) {
                                                    //                   //
                                                    //                   //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
                                                    //                   //     return Languages.of(context)!.labelOrderPending;
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
                                                    //                   //     return Languages.of(context)!.labelOrderAccepted;
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
                                                    //                   //     return Languages.of(context)!.labelOrderAccepted;
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
                                                    //                   //     return Languages.of(context)!.labelOrderRejected;
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
                                                    //                   //     return 'PREPARING FOOD';
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
                                                    //                   //     return 'READY TO PICKUP';
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
                                                    //                   //     return Languages.of(context)!.labelOrderPickedUp;
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
                                                    //                   //     return Languages.of(context)!.labelDeliveredSuccess;
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
                                                    //                   //     return Languages.of(context)!.labelOrderCanceled;
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
                                                    //                   //     return Languages.of(context)!.labelOrderCompleted;
                                                    //                   //   }
                                                    //                   // } else {
                                                    //                   //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
                                                    //                   //     return Languages.of(context)!.labelOrderPending;
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
                                                    //                   //     return Languages.of(context)!.labelOrderAccepted;
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
                                                    //                   //     return Languages.of(context)!.labelOrderAccepted;
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
                                                    //                   //     return 'PREPARING FOOD';
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
                                                    //                   //     return 'READY TO PICKUP';
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
                                                    //                   //     return Languages.of(context)!.labelOrderRejected;
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
                                                    //                   //     return Languages.of(context)!.labelOrderCompleted;
                                                    //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
                                                    //                   //     return Languages.of(context)!.labelOrderCanceled;
                                                    //                   //   }
                                                    //                   // }
                                                    //                 }()),
                                                    //                 style: TextStyle(
                                                    //                     color: (() {
                                                    //                       if (_orderHistoryController.listOrderHistory[index].addressId !=
                                                    //                           null) {
                                                    //                         if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'PENDING') {
                                                    //                           return Color(Constants.colorOrderPending);
                                                    //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'APPROVE') {
                                                    //                           return Color(Constants.colorBlack);
                                                    //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'ACCEPT') {
                                                    //                           return Color(Constants.colorBlack);
                                                    //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'REJECT') {
                                                    //                           return Color(Constants.colorLike);
                                                    //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'PICKUP') {
                                                    //                           return Color(Constants.colorOrderPickup);
                                                    //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'DELIVERED') {
                                                    //                           return Color(0xffffffff);
                                                    //
                                                    //                           // return Color(Constants.colorTheme);
                                                    //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'CANCEL') {
                                                    //                           return Color(0xffffffff);
                                                    //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'COMPLETE') {
                                                    //                           // return Color(Constants.colorTheme);
                                                    //                           return Color(0xffffffff);
                                                    //                         } else {
                                                    //                           return Color(0xffffffff);
                                                    //                           // return Color(Constants.colorTheme);
                                                    //                         }
                                                    //                       } else {
                                                    //                         if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'PENDING') {
                                                    //                           return Color(Constants.colorOrderPending);
                                                    //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'APPROVE') {
                                                    //                           return Color(Constants.colorBlack);
                                                    //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'ACCEPT') {
                                                    //                           return Color(Constants.colorBlack);
                                                    //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'REJECT') {
                                                    //                           return Color(Constants.colorLike);
                                                    //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'PREPARING FOOD') {
                                                    //                           return Color(Constants.colorOrderPickup);
                                                    //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'READY TO PICKUP') {
                                                    //                           return Color(0xffffffff);
                                                    //
                                                    //                           // return Color(Constants.colorTheme);
                                                    //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'CANCEL') {
                                                    //                           return Color(0xffffffff);
                                                    //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
                                                    //                             'COMPLETE') {
                                                    //                           // return Color(Constants.colorTheme);
                                                    //                           return Color(0xffffffff);
                                                    //                         } else {
                                                    //                           return Color(0xffffffff);
                                                    //                           // return Color(Constants.colorTheme);
                                                    //                         }
                                                    //                       }
                                                    //                     }()),
                                                    //                     fontFamily: Constants.appFont,
                                                    //                     fontSize: 12)),
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //     )
                                                    //   ],
                                                    // ),

                                                    // SizedBox(
                                                    //   height: ScreenUtil()
                                                    //       .setHeight(10),
                                                    // ),
                                                    //Order Cancel
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          constraints.maxWidth >
                                                                  600
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    ///Complete this order button start
                                                                    order.orderStatus != 'COMPLETE' &&
                                                                            order.deliveryType ==
                                                                                'TAKEAWAY' &&
                                                                            order.deliveryType !=
                                                                                'DINING' &&
                                                                            (order.payment_type == 'POS CASH' ||
                                                                                order.payment_type == 'POS CARD')
                                                                        ? ElevatedButton(
                                                                            onPressed:
                                                                                () async {
                                                                              await getTakeAwayValue(order.id!).then((value) {
                                                                                print("value ${value.data}");
                                                                                Get.to(() => PosMenu(isDining: false));
                                                                              });
                                                                            },
                                                                            child:
                                                                                RichText(
                                                                              textAlign: TextAlign.center,
                                                                              text: TextSpan(
                                                                                children: [
                                                                                  WidgetSpan(
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
                                                                                      child: SvgPicture.asset(
                                                                                        'images/ic_completed.svg',
                                                                                        width: ScreenUtil().setWidth(20),
                                                                                        //color: Color(Constants.colorRate),
                                                                                        height: ScreenUtil().setHeight(20),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: 'Complete this order',
                                                                                    style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: Constants.appFont),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),

                                                                    ///Complete this order button end

                                                                    ///Edit Order Button Start
                                                                    order.payment_type ==
                                                                            "INCOMPLETE ORDER"
                                                                        ? order.orderStatus ==
                                                                                'CANCEL'
                                                                            ? Container()
                                                                            : ElevatedButton(
                                                                                onPressed: () {
                                                                                  _cartController.cartMaster = CartMaster.fromMap(jsonDecode(order.orderData!));
                                                                                  _cartController.cartMaster?.oldOrderId = order.id;
                                                                                  _cartController.tableNumber = order.tableNo!;
                                                                                  String colorCode = order.order_id.toString();
                                                                                  int colorInt = int.parse(colorCode.substring(1));
                                                                                  print("color int ${colorInt}");
                                                                                  SharedPreferences.getInstance().then((value) {
                                                                                    value.setInt(Constants.order_main_id.toString(), colorInt);
                                                                                  });
                                                                                  order.deliveryType == "TAKEAWAY" ? _cartController.diningValue = false : _cartController.diningValue = true;
                                                                                  order.user_name == null ? _cartController.userName = '' : _cartController.userName = order.user_name;
                                                                                  order.mobile == null ? _cartController.userMobileNumber = '' : _cartController.userMobileNumber = order.mobile;
                                                                                  // Constants.order_main_id = order.order_id.toString()
                                                                                  print("server order id ${order.order_id.toString()}");
                                                                                  Get.to(() => PosMenu(isDining: _cartController.diningValue));
                                                                                },
                                                                                child: Text(
                                                                                  "Edit this order",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                    fontSize: 18,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                        : Container(),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),

                                                                    ///End Edit Order Button

                                                                    /// Cancel Order Button Start
                                                                    order.orderStatus ==
                                                                                'PENDING' ||
                                                                            order.orderStatus ==
                                                                                'APPROVE'
                                                                        ? ElevatedButton(
                                                                            // style: ElevatedButton
                                                                            //     .styleFrom(
                                                                            //   primary: Colors.white,
                                                                            //   shape: RoundedRectangleBorder(
                                                                            //       borderRadius: BorderRadius.only(
                                                                            //           bottomLeft: Radius
                                                                            //               .circular(
                                                                            //                   20),
                                                                            //           bottomRight: Radius
                                                                            //               .circular(
                                                                            //                   20)),
                                                                            //       side: BorderSide
                                                                            //           .none),
                                                                            // ),
                                                                            onPressed:
                                                                                () async {
                                                                              await showCancelOrderDialog(order.id);
                                                                              setState(() {
                                                                                orderHistoryRef = _orderHistoryController.refreshOrderHistory(context);
                                                                              });
                                                                            },
                                                                            child:
                                                                                RichText(
                                                                              textAlign: TextAlign.center,
                                                                              text: TextSpan(
                                                                                children: [
                                                                                  WidgetSpan(
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
                                                                                      child: SvgPicture.asset(
                                                                                        'images/ic_cancel.svg',
                                                                                        width: ScreenUtil().setWidth(20),
                                                                                        //color: Color(Constants.colorRate),
                                                                                        height: ScreenUtil().setHeight(20),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: 'Cancel this order',
                                                                                    style: TextStyle(
                                                                                        color: Colors.white,
                                                                                        // color: Color(Constants
                                                                                        //     .colorLike),
                                                                                        fontSize: 18,
                                                                                        fontFamily: Constants.appFont),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )
                                                                        // ? Column(
                                                                        //     children: [
                                                                        //       Container(
                                                                        //         // height: ScreenUtil()
                                                                        //         //     .setHeight(50),
                                                                        //         // width: double.minPositive,
                                                                        //         child:
                                                                        //             ElevatedButton(
                                                                        //           // style: ElevatedButton
                                                                        //           //     .styleFrom(
                                                                        //           //   primary: Colors.white,
                                                                        //           //   shape: RoundedRectangleBorder(
                                                                        //           //       borderRadius: BorderRadius.only(
                                                                        //           //           bottomLeft: Radius
                                                                        //           //               .circular(
                                                                        //           //                   20),
                                                                        //           //           bottomRight: Radius
                                                                        //           //               .circular(
                                                                        //           //                   20)),
                                                                        //           //       side: BorderSide
                                                                        //           //           .none),
                                                                        //           // ),
                                                                        //           onPressed:
                                                                        //               () async {
                                                                        //             await showCancelOrderDialog(
                                                                        //                 order.id);
                                                                        //             setState(
                                                                        //                 () {
                                                                        //               orderHistoryRef =
                                                                        //                   _orderHistoryController.refreshOrderHistory(context);
                                                                        //             });
                                                                        //           },
                                                                        //           child:
                                                                        //               RichText(
                                                                        //             text:
                                                                        //                 TextSpan(
                                                                        //               children: [
                                                                        //                 WidgetSpan(
                                                                        //                   child: Padding(
                                                                        //                     padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
                                                                        //                     child: SvgPicture.asset(
                                                                        //                       'images/ic_cancel.svg',
                                                                        //                       width: ScreenUtil().setWidth(20),
                                                                        //                       //color: Color(Constants.colorRate),
                                                                        //                       height: ScreenUtil().setHeight(20),
                                                                        //                     ),
                                                                        //                   ),
                                                                        //                 ),
                                                                        //                 TextSpan(
                                                                        //                   text: 'Cancel this order',
                                                                        //                   style: TextStyle(
                                                                        //                       color: Colors.white,
                                                                        //                       // color: Color(Constants
                                                                        //                       //     .colorLike),
                                                                        //                       fontSize: 18,
                                                                        //                       fontFamily: Constants.appFont),
                                                                        //                 ),
                                                                        //               ],
                                                                        //             ),
                                                                        //           ),
                                                                        //         ),
                                                                        //       ),
                                                                        //     ],
                                                                        //   )
                                                                        : Container(),

                                                                    ///CAncel Order button End
                                                                  ],
                                                                )
                                                              : Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    ///Complete this order button start
                                                                    order.orderStatus != 'COMPLETE' &&
                                                                            order.deliveryType ==
                                                                                'TAKEAWAY' &&
                                                                            order.deliveryType !=
                                                                                'DINING' &&
                                                                            (order.payment_type == 'POS CASH' ||
                                                                                order.payment_type == 'POS CARD')
                                                                        ? Expanded(
                                                                            child:
                                                                                ElevatedButton(
                                                                              onPressed: () async {
                                                                                await getTakeAwayValue(order.id!).then((value) {
                                                                                  print("value ${value.data}");
                                                                                  Get.to(() => PosMenu(isDining: false));
                                                                                });
                                                                              },
                                                                              child: RichText(
                                                                                textAlign: TextAlign.center,
                                                                                text: TextSpan(
                                                                                  children: [
                                                                                    WidgetSpan(
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
                                                                                        child: SvgPicture.asset(
                                                                                          'images/ic_completed.svg',
                                                                                          width: ScreenUtil().setWidth(20),
                                                                                          //color: Color(Constants.colorRate),
                                                                                          height: ScreenUtil().setHeight(20),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: 'Complete this order',
                                                                                      style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: Constants.appFont),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),

                                                                    ///Complete this order button end

                                                                    ///Edit Order Button Start
                                                                    order.payment_type ==
                                                                            "INCOMPLETE ORDER"
                                                                        ? order.orderStatus ==
                                                                                'CANCEL'
                                                                            ? Container()
                                                                            : Expanded(
                                                                                child: ElevatedButton(
                                                                                  onPressed: () {
                                                                                    _cartController.cartMaster = CartMaster.fromMap(jsonDecode(order.orderData!));
                                                                                    _cartController.cartMaster?.oldOrderId = order.id;
                                                                                    _cartController.tableNumber = order.tableNo!;
                                                                                    String colorCode = order.order_id.toString();
                                                                                    int colorInt = int.parse(colorCode.substring(1));
                                                                                    print("color int ${colorInt}");
                                                                                    SharedPreferences.getInstance().then((value) {
                                                                                      value.setInt(Constants.order_main_id.toString(), colorInt);
                                                                                    });
                                                                                    order.deliveryType == "TAKEAWAY" ? _cartController.diningValue = false : _cartController.diningValue = true;
                                                                                    order.user_name == null ? _cartController.userName = '' : _cartController.userName = order.user_name;
                                                                                    order.mobile == null ? _cartController.userMobileNumber = '' : _cartController.userMobileNumber = order.mobile;
                                                                                    // Constants.order_main_id = order.order_id.toString()
                                                                                    print("server order id ${order.order_id.toString()}");
                                                                                    Get.to(() => PosMenu(isDining: _cartController.diningValue));
                                                                                  },
                                                                                  child: Text(
                                                                                    "Edit this order",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(
                                                                                      fontSize: 18,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                        : Container(),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),

                                                                    ///End Edit Order Button

                                                                    /// Cancel Order Button Start
                                                                    order.orderStatus ==
                                                                                'PENDING' ||
                                                                            order.orderStatus ==
                                                                                'APPROVE'
                                                                        ? Expanded(
                                                                            child:
                                                                                ElevatedButton(
                                                                              // style: ElevatedButton
                                                                              //     .styleFrom(
                                                                              //   primary: Colors.white,
                                                                              //   shape: RoundedRectangleBorder(
                                                                              //       borderRadius: BorderRadius.only(
                                                                              //           bottomLeft: Radius
                                                                              //               .circular(
                                                                              //                   20),
                                                                              //           bottomRight: Radius
                                                                              //               .circular(
                                                                              //                   20)),
                                                                              //       side: BorderSide
                                                                              //           .none),
                                                                              // ),
                                                                              onPressed: () async {
                                                                                await showCancelOrderDialog(order.id);
                                                                                setState(() {
                                                                                  orderHistoryRef = _orderHistoryController.refreshOrderHistory(context);
                                                                                });
                                                                              },
                                                                              child: RichText(
                                                                                textAlign: TextAlign.center,
                                                                                text: TextSpan(
                                                                                  children: [
                                                                                    WidgetSpan(
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
                                                                                        child: SvgPicture.asset(
                                                                                          'images/ic_cancel.svg',
                                                                                          width: ScreenUtil().setWidth(20),
                                                                                          //color: Color(Constants.colorRate),
                                                                                          height: ScreenUtil().setHeight(20),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: 'Cancel this order',
                                                                                      style: TextStyle(
                                                                                          color: Colors.white,
                                                                                          // color: Color(Constants
                                                                                          //     .colorLike),
                                                                                          fontSize: 18,
                                                                                          fontFamily: Constants.appFont),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        // ? Column(
                                                                        //     children: [
                                                                        //       Container(
                                                                        //         // height: ScreenUtil()
                                                                        //         //     .setHeight(50),
                                                                        //         // width: double.minPositive,
                                                                        //         child:
                                                                        //             ElevatedButton(
                                                                        //           // style: ElevatedButton
                                                                        //           //     .styleFrom(
                                                                        //           //   primary: Colors.white,
                                                                        //           //   shape: RoundedRectangleBorder(
                                                                        //           //       borderRadius: BorderRadius.only(
                                                                        //           //           bottomLeft: Radius
                                                                        //           //               .circular(
                                                                        //           //                   20),
                                                                        //           //           bottomRight: Radius
                                                                        //           //               .circular(
                                                                        //           //                   20)),
                                                                        //           //       side: BorderSide
                                                                        //           //           .none),
                                                                        //           // ),
                                                                        //           onPressed:
                                                                        //               () async {
                                                                        //             await showCancelOrderDialog(
                                                                        //                 order.id);
                                                                        //             setState(
                                                                        //                 () {
                                                                        //               orderHistoryRef =
                                                                        //                   _orderHistoryController.refreshOrderHistory(context);
                                                                        //             });
                                                                        //           },
                                                                        //           child:
                                                                        //               RichText(
                                                                        //             text:
                                                                        //                 TextSpan(
                                                                        //               children: [
                                                                        //                 WidgetSpan(
                                                                        //                   child: Padding(
                                                                        //                     padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
                                                                        //                     child: SvgPicture.asset(
                                                                        //                       'images/ic_cancel.svg',
                                                                        //                       width: ScreenUtil().setWidth(20),
                                                                        //                       //color: Color(Constants.colorRate),
                                                                        //                       height: ScreenUtil().setHeight(20),
                                                                        //                     ),
                                                                        //                   ),
                                                                        //                 ),
                                                                        //                 TextSpan(
                                                                        //                   text: 'Cancel this order',
                                                                        //                   style: TextStyle(
                                                                        //                       color: Colors.white,
                                                                        //                       // color: Color(Constants
                                                                        //                       //     .colorLike),
                                                                        //                       fontSize: 18,
                                                                        //                       fontFamily: Constants.appFont),
                                                                        //                 ),
                                                                        //               ],
                                                                        //             ),
                                                                        //           ),
                                                                        //         ),
                                                                        //       ),
                                                                        //     ],
                                                                        //   )
                                                                        : Container(),

                                                                    ///CAncel Order button End
                                                                  ],
                                                                ),
                                                    ),

                                                    // order.orderStatus !=
                                                    //             'COMPLETE' &&
                                                    //         order.deliveryType ==
                                                    //             'TAKEAWAY' &&
                                                    //         order.deliveryType !=
                                                    //             'DINING' &&
                                                    //         (order.payment_type ==
                                                    //                 'POS CASH' ||
                                                    //             order.payment_type ==
                                                    //                 'POS CARD')
                                                    //     ? Column(
                                                    //         children: [
                                                    //           ElevatedButton(
                                                    //             onPressed:
                                                    //                 () async {
                                                    //               await getTakeAwayValue(
                                                    //                       order
                                                    //                           .id!)
                                                    //                   .then(
                                                    //                       (value) {
                                                    //                 print(
                                                    //                     "value ${value.data}");
                                                    //                 Get.to(() => PosMenu(
                                                    //                     isDining:
                                                    //                         false));
                                                    //               });
                                                    //             },
                                                    //             child: RichText(
                                                    //               text: TextSpan(
                                                    //                 children: [
                                                    //                   WidgetSpan(
                                                    //                     child:
                                                    //                         Padding(
                                                    //                       padding:
                                                    //                           EdgeInsets.only(right: ScreenUtil().setHeight(10)),
                                                    //                       child: SvgPicture
                                                    //                           .asset(
                                                    //                         'images/ic_completed.svg',
                                                    //                         width:
                                                    //                             ScreenUtil().setWidth(20),
                                                    //                         //color: Color(Constants.colorRate),
                                                    //                         height:
                                                    //                             ScreenUtil().setHeight(20),
                                                    //                       ),
                                                    //                     ),
                                                    //                   ),
                                                    //                   TextSpan(
                                                    //                     text:
                                                    //                         'Complete this order',
                                                    //                     style: TextStyle(
                                                    //                         color: Colors
                                                    //                             .white,
                                                    //                         fontSize:
                                                    //                             18,
                                                    //                         fontFamily:
                                                    //                             Constants.appFont),
                                                    //                   ),
                                                    //                 ],
                                                    //               ),
                                                    //             ),
                                                    //           )
                                                    //           // GestureDetector(
                                                    //           //   onTap: () async {
                                                    //           //
                                                    //           //   },
                                                    //           //   child: Align(
                                                    //           //     alignment:
                                                    //           //         Alignment
                                                    //           //             .center,
                                                    //           //     child:
                                                    //           //   ),
                                                    //           // ),
                                                    //         ],
                                                    //       )
                                                    //     : Container(),
                                                    // if (order.orderStatus ==
                                                    //         'PENDING' ||
                                                    //     order.orderStatus ==
                                                    //         'APPROVE')
                                                    //   Column(
                                                    //     children: [
                                                    //       Container(
                                                    //         // height: ScreenUtil()
                                                    //         //     .setHeight(50),
                                                    //         // width: double.minPositive,
                                                    //         child: ElevatedButton(
                                                    //           // style: ElevatedButton
                                                    //           //     .styleFrom(
                                                    //           //   primary: Colors.white,
                                                    //           //   shape: RoundedRectangleBorder(
                                                    //           //       borderRadius: BorderRadius.only(
                                                    //           //           bottomLeft: Radius
                                                    //           //               .circular(
                                                    //           //                   20),
                                                    //           //           bottomRight: Radius
                                                    //           //               .circular(
                                                    //           //                   20)),
                                                    //           //       side: BorderSide
                                                    //           //           .none),
                                                    //           // ),
                                                    //           onPressed:
                                                    //               () async {
                                                    //             await showCancelOrderDialog(
                                                    //                 order.id);
                                                    //             setState(() {
                                                    //               orderHistoryRef =
                                                    //                   _orderHistoryController
                                                    //                       .refreshOrderHistory(
                                                    //                           context);
                                                    //             });
                                                    //           },
                                                    //           child: RichText(
                                                    //             text: TextSpan(
                                                    //               children: [
                                                    //                 WidgetSpan(
                                                    //                   child:
                                                    //                       Padding(
                                                    //                     padding: EdgeInsets.only(
                                                    //                         right:
                                                    //                             ScreenUtil().setHeight(10)),
                                                    //                     child: SvgPicture
                                                    //                         .asset(
                                                    //                       'images/ic_cancel.svg',
                                                    //                       width: ScreenUtil()
                                                    //                           .setWidth(20),
                                                    //                       //color: Color(Constants.colorRate),
                                                    //                       height:
                                                    //                           ScreenUtil().setHeight(20),
                                                    //                     ),
                                                    //                   ),
                                                    //                 ),
                                                    //                 TextSpan(
                                                    //                   text:
                                                    //                       'Cancel this order',
                                                    //                   style: TextStyle(
                                                    //                       color: Colors.white,
                                                    //                       // color: Color(Constants
                                                    //                       //     .colorLike),
                                                    //                       fontSize: 18,
                                                    //                       fontFamily: Constants.appFont),
                                                    //                 ),
                                                    //               ],
                                                    //             ),
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // (() {
                                                    //   if (order.orderStatus ==
                                                    //           'CANCEL' ||
                                                    //       order.orderStatus ==
                                                    //           'COMPLETE') {
                                                    //     return Container();
                                                    //     // return Container(
                                                    //     //   height: ScreenUtil()
                                                    //     //       .setHeight(
                                                    //     //       40),
                                                    //     //   child:
                                                    //     //   ElevatedButton(
                                                    //     //     style: ElevatedButton.styleFrom(
                                                    //     //       primary: Colors.white,
                                                    //     //       shape: RoundedRectangleBorder(
                                                    //     //           borderRadius:
                                                    //     //           BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                                    //     //           side: BorderSide.none),
                                                    //     //     ),
                                                    //     //     onPressed:
                                                    //     //         () {
                                                    //     //       Navigator.of(context).push(Transitions(
                                                    //     //           transitionType: TransitionType.fade,
                                                    //     //           curve: Curves.bounceInOut,
                                                    //     //           reverseCurve: Curves.fastLinearToSlowEaseIn,
                                                    //     //           widget: OrderReviewScreen(
                                                    //     //             orderId: _orderHistoryController.listOrderHistory[index].id,
                                                    //     //           )));
                                                    //     //     },
                                                    //     //     child: RichText(
                                                    //     //       text:
                                                    //     //       TextSpan(
                                                    //     //         children: [
                                                    //     //           WidgetSpan(
                                                    //     //             child: Padding(
                                                    //     //               padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
                                                    //     //               child: SvgPicture.asset(
                                                    //     //                 'images/ic_star.svg',
                                                    //     //                 width: ScreenUtil().setWidth(20),
                                                    //     //                 color: Color(Constants.colorRate),
                                                    //     //                 height: ScreenUtil().setHeight(20),
                                                    //     //               ),
                                                    //     //             ),
                                                    //     //           ),
                                                    //     //           TextSpan(
                                                    //     //             text: (() {
                                                    //     //               // your code here
                                                    //     //               // _orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' ? 'Ordered on ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}' : 'Delivered on October 10,2020, 09:23pm',
                                                    //     //               if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL' || _orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
                                                    //     //                 return 'Rate Now';
                                                    //     //               } else {
                                                    //     //                 return '';
                                                    //     //               }
                                                    //     //             }()),
                                                    //     //             style: TextStyle(color: Color(Constants.colorRate), fontSize: 18, fontFamily: Constants.appFont),
                                                    //     //           ),
                                                    //     //         ],
                                                    //     //       ),
                                                    //     //     ),
                                                    //     //
                                                    //     //   ),
                                                    //     // );
                                                    //   } else {
                                                    //     return Container();
                                                    //   }
                                                    // }()),
                                                    if (order.orderStatus !=
                                                            'COMPLETE' &&
                                                        order.orderStatus !=
                                                            'CANCEL' &&
                                                        order.deliveryType ==
                                                            'DINING')
                                                      Container(
                                                        height: ScreenUtil()
                                                            .setHeight(40),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: Color(
                                                                Constants
                                                                    .colorTheme),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            20),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            20)),
                                                                side: BorderSide
                                                                    .none),
                                                          ),
                                                          onPressed: () {
                                                            // showCancelOrderDialog(_orderHistoryController.listOrderHistory[index].id);
                                                          },
                                                          child: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      'Live Order',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                            // return ListTile(
                            //   title: Text(order.amount.toString()),
                            //   subtitle: Text(order.deliveryType.toString()),
                            // );
                          },
                        );
                      } else if (snapshot.hasError) {
                        // handle the error here
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Center(child: Text('No Orders History'));
                      }
                    },
                  ),
                ),
                // Expanded(
                //   child: Obx(
                //         () => ListView.builder(
                //           padding: EdgeInsets.only(
                //               bottom: 100, left: 10, right: 10),
                //           scrollDirection: Axis.vertical,
                //       itemCount: _getFilteredOrders().length,
                //       itemBuilder: (BuildContext context, int index) {
                //         final order = _getFilteredOrders()[index];
                //
                //         return  ListTile(
                //           title: Text("${order.amount}"),
                //           subtitle: Text(order.deliveryType!),
                //         );
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
          );
          // body: FutureBuilder<BaseModel<OrderHistoryListModel>>(
          //     future: orderHistoryRef,
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         return ListView.builder(
          //             padding: EdgeInsets.only(
          //                 bottom: 100, left: 10, right: 10),
          //             scrollDirection: Axis.vertical,
          //             itemCount: _getFilteredOrders().length,
          //             itemBuilder:
          //                 (BuildContext context, int index) {
          //               OrderHistoryData order = _getFilteredOrders()[index];
          //               return ListTile(
          //                 title: Text(order.deliveryType!),
          //               );
          //             }
          //         );
          //       }
          //
          //       else {
          //         return Container();
          //       }
          //     }),
        }),
      ),
    );
  }

  ///Container Main Code]
  //                 return Container(
  //                 height: MediaQuery.of(context).size.height,
  //                 decoration: BoxDecoration(
  //                     color: Color(Constants.colorScreenBackGround),
  //                     image: DecorationImage(
  //                       image: AssetImage('images/ic_background_image.png'),
  //                       fit: BoxFit.cover,
  //                     )),
  //                 child: _orderHistoryController.listOrderHistory.length == 0
//                       ? Center(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image(
//                                 width: 150,
//                                 height: 180,
//                                 image: AssetImage(
//                                     'images/ic_no_order_history.png'),
//                               ),
//                               Text(
//                                 'No Order History',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: ScreenUtil().setSp(18),
//                                   fontFamily: Constants.appFontBold,
//                                   color: Color(Constants.colorTheme),
//                                 ),
//                               )
//                             ],
//                           ),
//                         )
//                       : Column(
//                           children: [
//                             SizedBox(height: 5),
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 delieveryTypeButton(
//                                     onTap: () =>
//                                         _applyFilter(FilterType.DineIn),
//                                     icon: Icons.card_travel,
//                                     title: "Dine In",
//                                     style: TextStyle(
//                                         color: _filterType == FilterType.DineIn
//                                             ? Colors.white
//                                             : Colors.black),
//                                     color: _filterType == FilterType.DineIn
//                                         ? Colors.white
//                                         : Colors.black,
//                                     buttonColor:
//                                         _filterType == FilterType.DineIn
//                                             ? Colors.red.shade500
//                                             : Colors.white),
//                                 // ElevatedButton(
//                                 //     style: ElevatedButton.styleFrom(
//                                 //       backgroundColor:_filterType == FilterType.DineIn ?  Colors.red.shade500  :  Colors.white, // Background color
//                                 //     ),
//                                 //     onPressed:  () => _applyFilter(FilterType.DineIn), child: Text("Dine In", style: TextStyle(
//                                 //   color:  _filterType == FilterType.DineIn ? Colors.white  :  Colors.black
//                                 // ),)),
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 delieveryTypeButton(
//                                     onTap: () =>
//                                         _applyFilter(FilterType.TakeAway),
//                                     icon: Icons.table_bar,
//                                     title: "TakeAway",
//                                     style: TextStyle(
//                                         color:
//                                             _filterType == FilterType.TakeAway
//                                                 ? Colors.white
//                                                 : Colors.black),
//                                     color: _filterType == FilterType.TakeAway
//                                         ? Colors.white
//                                         : Colors.black,
//                                     buttonColor:
//                                         _filterType == FilterType.TakeAway
//                                             ? Colors.red.shade500
//                                             : Colors.white),
//                                 // ElevatedButton(
//                                 //     style: ElevatedButton.styleFrom(
//                                 //       backgroundColor: _filterType == FilterType.TakeAway ? Colors.red.shade500  :  Colors.white, // Background color
//                                 //     ),
//                                 //     onPressed:  () => _applyFilter(FilterType.TakeAway), child: Text("TakeAway", style: TextStyle(
//                                 //     color:  _filterType == FilterType.TakeAway ? Colors.white  :  Colors.black
//                                 // ),)),
//                               ],
//                             ),
//
//                             Expanded(
//                               child: Obx(() => ListView.builder(
//                                   padding: EdgeInsets.only(
//                                       bottom: 100, left: 10, right: 10),
//                                   scrollDirection: Axis.vertical,
//                                   itemCount: _getFilteredOrders().length,
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     return Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.stretch,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 10, right: 10),
//                                           child: Text(
//                                             (() {
//                                                   if (_orderHistoryController
//                                                           .listOrderHistory[
//                                                               index]
//                                                           .addressId !=
//                                                       null) {
//                                                     if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'PENDING') {
//                                                       return '${'Ordered On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     } else if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'ACCEPT') {
//                                                       return '${'Accepted On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     } else if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'APPROVE') {
//                                                       return '${'Approve On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     } else if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'REJECT') {
//                                                       return '${'Rejected On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     } else if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'PICKUP') {
//                                                       return '${'Pickedup On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     } else if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'DELIVERED') {
//                                                       return '${'Delivered On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     } else if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'CANCEL') {
//                                                       return 'Canceled On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     } else if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'COMPLETE') {
//                                                       return 'Delivered On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     }
//                                                   } else {
//                                                     if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'PENDING') {
//                                                       return 'Ordered On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     } else if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'ACCEPT') {
//                                                       return 'Accepted On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     } else if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'APPROVE') {
//                                                       return 'Approve On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     } else if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'REJECT') {
//                                                       return 'Rejected On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     } else if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'PREPARE_FOR_ORDER') {
//                                                       return 'PREPARE FOR ORDER ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     } else if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'READY_FOR_ORDER') {
//                                                       return 'READY FOR ORDER ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     } else if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'CANCEL') {
//                                                       return 'Canceled On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     } else if (_orderHistoryController
//                                                             .listOrderHistory[
//                                                                 index]
//                                                             .orderStatus ==
//                                                         'COMPLETE') {
//                                                       return 'Delivered On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//                                                     }
//                                                   }
//                                                 }()) ??
//                                                 '',
//                                             style: TextStyle(
//                                                 color:
//                                                     Color(Constants.colorGray),
//                                                 fontFamily: Constants.appFont,
//                                                 fontSize: 12),
//                                             textAlign: TextAlign.end,
//                                           ),
//                                         ),
//                                         GestureDetector(
//                                           onTap: () {
//                                             print(
//                                                 " orderData is .. ${_orderHistoryController.listOrderHistory[index].deliveryType}");
//                                             // // Constants.toastMessage(_orderHistoryController.listOrderHistory[index].id.toString());
//                                             // Navigator.of(context).push(
//                                             //     Transitions(
//                                             //         transitionType:
//                                             //         TransitionType.fade,
//                                             //         curve:
//                                             //         Curves.bounceInOut,
//                                             //         reverseCurve: Curves
//                                             //             .fastLinearToSlowEaseIn,
//                                             //         widget:
//                                             //         OrderDetailsScreen(
//                                             //           orderId:
//                                             //           _orderHistoryController.listOrderHistory[
//                                             //           index]
//                                             //               .id,
//                                             //           orderDate:
//                                             //           _orderHistoryController.listOrderHistory[
//                                             //           index]
//                                             //               .date,
//                                             //           orderTime:
//                                             //           _orderHistoryController.listOrderHistory[
//                                             //           index]
//                                             //               .time,
//                                             //         )));
//                                           },
//                                           child: Card(
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(20.0),
//                                             ),
//                                             margin: EdgeInsets.only(
//                                                 top: 20,
//                                                 left: 16,
//                                                 right: 16,
//                                                 bottom: 20),
//                                             child: Column(
//                                               children: [
//                                                 // (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' || _orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE')?
//                                                 //
//                                                 // GestureDetector(
//                                                 //   onTap: (){
//                                                 //     showCancelOrderDialog(_orderHistoryController.listOrderHistory[index].id);
//                                                 //   },
//                                                 //   child: Padding(
//                                                 //     padding: const EdgeInsets
//                                                 //         .only(
//                                                 //         top: 10,
//                                                 //         right:
//                                                 //         20),
//                                                 //     child:
//                                                 //     RichText(
//                                                 //       text:
//                                                 //       TextSpan(
//                                                 //         children: [
//                                                 //           WidgetSpan(
//                                                 //             child:
//                                                 //             Padding(
//                                                 //               padding: const EdgeInsets.only(right: 5),
//                                                 //               child: SvgPicture.asset('images/ic_cancel.svg',
//                                                 //
//                                                 //                 //  color: Color(Constants.colorTheme),
//                                                 //                 width: 15,
//                                                 //                 height: ScreenUtil().setHeight(15),
//                                                 //               ),
//                                                 //             ),
//                                                 //           ),
//                                                 //           TextSpan(
//                                                 //               text: 'Cancel this order',
//                                                 //               style: TextStyle(
//                                                 //                   color: Color(Constants.colorLike),
//                                                 //                   fontFamily: Constants.appFont,
//                                                 //                   fontSize: 12)),
//                                                 //         ],
//                                                 //       ),
//                                                 //     ),
//                                                 //   ),
//                                                 // ):Container(),
//
//                                                 Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     // Padding(
//                                                     //   padding:
//                                                     //   const EdgeInsets
//                                                     //       .all(5.0),
//                                                     //   child: ClipRRect(
//                                                     //     borderRadius:
//                                                     //     BorderRadius
//                                                     //         .circular(
//                                                     //         15.0),
//                                                     //     child: CachedNetworkImage(
//                                                     //       height:
//                                                     //       100,
//                                                     //       width:
//                                                     //       100,
//                                                     //       imageUrl:
//                                                     //       _orderHistoryController.listOrderHistory[
//                                                     //       index]
//                                                     //           .vendor!
//                                                     //           .image!,
//                                                     //       fit: BoxFit.cover,
//                                                     //       placeholder: (context,
//                                                     //           url) =>
//                                                     //           SpinKitFadingCircle(
//                                                     //               color: Color(
//                                                     //                   Constants
//                                                     //                       .colorTheme)),
//                                                     //       errorWidget:
//                                                     //           (context, url,
//                                                     //           error) =>
//                                                     //           Container(
//                                                     //             child: Center(
//                                                     //                 child: Image.asset('images/noimage.png')),
//                                                     //           ),
//                                                     //     ),
//                                                     //   ),
//                                                     // ),
//                                                     Expanded(
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     left: 10,
//                                                                     top: 10),
//                                                             child: Text(
//                                                               "Order # ${_orderHistoryController.listOrderHistory[index].id.toString()} | ${_orderHistoryController.listOrderHistory[index].user!.name} | ${_orderHistoryController.listOrderHistory[index].vendor!.name!}",
//                                                               style: TextStyle(
//                                                                 fontFamily:
//                                                                     Constants
//                                                                         .appFontBold,
//                                                                 fontSize: 12,
//                                                                 color: Color(
//                                                                     Constants
//                                                                         .colorGray),
//                                                               ),
//                                                             ),
//
//                                                             // child: Row(
//                                                             //   children: [
//                                                             //     // Expanded(
//                                                             //     //   flex: 4,
//                                                             //     //   child:
//                                                             //     //   Padding(
//                                                             //     //     padding: const EdgeInsets
//                                                             //     //         .only(
//                                                             //     //         left:
//                                                             //     //         10,
//                                                             //     //         top:
//                                                             //     //         10),
//                                                             //     //     child: Text(
//                                                             //     //       "Order # ${_orderHistoryController.listOrderHistory[index].id.toString()}",
//                                                             //     //       style: TextStyle(
//                                                             //     //           fontFamily:
//                                                             //     //           Constants.appFontBold,
//                                                             //     //           fontSize: 16),
//                                                             //     //     ),
//                                                             //     //     // Text(
//                                                             //     //     //   _orderHistoryController.listOrderHistory[index]
//                                                             //     //     //       .vendor!
//                                                             //     //     //       .name!,
//                                                             //     //     //   style: TextStyle(
//                                                             //     //     //       fontFamily:
//                                                             //     //     //       Constants.appFontBold,
//                                                             //     //     //       fontSize: 16),
//                                                             //     //     // ),
//                                                             //     //   ),
//                                                             //     // ),
//                                                             //     Text(
//                                                             //       "Order # ${_orderHistoryController.listOrderHistory[index].id.toString()} | ${_orderHistoryController.listOrderHistory[index].user!.name}",
//                                                             //       style: TextStyle(
//                                                             //           fontFamily:
//                                                             //           Constants.appFontBold,
//                                                             //           fontSize: 12,
//                                                             //       color: Color(Constants.colorGray),
//                                                             //       ),
//                                                             //     ),
//                                                             //     Text(
//                                                             //       ,
//                                                             //       style: TextStyle(
//                                                             //           fontFamily:
//                                                             //           Constants.appFontBold,
//                                                             //           fontSize: 12,
//                                                             //         color: Color(Constants.colorGray),
//                                                             //       ),
//                                                             //     ),
//                                                             //   ],
//                                                             // ),
//                                                           ),
//                                                           // Padding(
//                                                           //   padding:
//                                                           //   const EdgeInsets
//                                                           //       .only(
//                                                           //       top: 3,
//                                                           //       left:
//                                                           //       10,
//                                                           //       right:
//                                                           //       5),
//                                                           //   child: Text(
//                                                           //    _orderHistoryController.listOrderHistory[index].user!.name,
//                                                           //     style: TextStyle(
//                                                           //         fontFamily:
//                                                           //         Constants.appFontBold,
//                                                           //         fontSize: 12),
//                                                           //   ),
//                                                           // ),
// ///Start vendor name
//                                                           // Padding(
//                                                           //   padding:
//                                                           //       const EdgeInsets
//                                                           //               .only(
//                                                           //           top: 3,
//                                                           //           left: 10,
//                                                           //           right: 5),
//                                                           //   child: Text(
//                                                           //     _orderHistoryController
//                                                           //         .listOrderHistory[
//                                                           //             index]
//                                                           //         .vendor!
//                                                           //         .name!,
//                                                           //     style: TextStyle(
//                                                           //         fontFamily:
//                                                           //             Constants
//                                                           //                 .appFontBold,
//                                                           //         fontSize: 10),
//                                                           //   ),
//                                                           // ),
//                                                           ///End vendor Name
//                                                           // Padding(
//                                                           //   padding:
//                                                           //   const EdgeInsets
//                                                           //       .only(
//                                                           //       top: 3,
//                                                           //       left:
//                                                           //       10,
//                                                           //       right:
//                                                           //       5),
//                                                           //   child: Text(
//                                                           //     _orderHistoryController.listOrderHistory[
//                                                           //     index]
//                                                           //         .vendor!
//                                                           //         .mapAddress ?? '',
//                                                           //     overflow:
//                                                           //     TextOverflow
//                                                           //         .ellipsis,
//                                                           //     style: TextStyle(
//                                                           //         fontFamily:
//                                                           //         Constants
//                                                           //             .appFont,
//                                                           //         color: Color(
//                                                           //             Constants
//                                                           //                 .colorGray),
//                                                           //         fontSize:
//                                                           //         13),
//                                                           //   ),
//                                                           // ),
//                                                           _orderHistoryController
//                                                                           .listOrderHistory[
//                                                                               index]
//                                                                           .tableNo ==
//                                                                       0 ||
//                                                                   _orderHistoryController
//                                                                           .listOrderHistory[
//                                                                               index]
//                                                                           .tableNo ==
//                                                                       null
//                                                               ? SizedBox()
//                                                               : Padding(
//                                                                   padding: const EdgeInsets
//                                                                           .only(
//                                                                       top: 3,
//                                                                       left: 10,
//                                                                       right: 5),
//                                                                   child: Text(
//                                                                     "Table No ${_orderHistoryController.listOrderHistory[index].tableNo.toString()}" ??
//                                                                         '',
//                                                                     overflow:
//                                                                         TextOverflow
//                                                                             .ellipsis,
//                                                                     style: TextStyle(
//                                                                         fontFamily:
//                                                                             Constants
//                                                                                 .appFontBold,
//                                                                         fontSize:
//                                                                             16),
//                                                                   ),
//                                                                 ),
//                                                           SizedBox(
//                                                             height: ScreenUtil()
//                                                                 .setHeight(10),
//                                                           ),
//
//                                                           Row(
//                                                             children: [
//                                                               Expanded(
//                                                                 child: Padding(
//                                                                   padding: const EdgeInsets
//                                                                           .only(
//                                                                       left: 10,
//                                                                       top: 10),
//                                                                   child: Text(
//                                                                     AuthController
//                                                                             .sharedPreferences
//                                                                             ?.getString(Constants
//                                                                                 .appSettingCurrencySymbol) ??
//                                                                         '' +
//                                                                             '${_orderHistoryController.listOrderHistory[index].amount}',
//                                                                     style: TextStyle(
//                                                                         fontFamily:
//                                                                             Constants
//                                                                                 .appFont,
//                                                                         fontSize:
//                                                                             14),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               Padding(
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                             .only(
//                                                                         top: 10,
//                                                                         right:
//                                                                             20),
//                                                                 child: RichText(
//                                                                   text:
//                                                                       TextSpan(
//                                                                     children: [
//                                                                       WidgetSpan(
//                                                                         child:
//                                                                             Padding(
//                                                                           padding:
//                                                                               const EdgeInsets.only(right: 5),
//                                                                           child:
//                                                                               SvgPicture.asset(
//                                                                             (() {
//                                                                                   if (_orderHistoryController.listOrderHistory[index].addressId != null) {
//                                                                                     if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//                                                                                       return 'images/ic_pending.svg';
//                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
//                                                                                       return 'images/ic_accept.svg';
//                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//                                                                                       return 'images/ic_accept.svg';
//                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
//                                                                                       return 'images/ic_cancel.svg';
//                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
//                                                                                       return 'images/ic_pickup.svg';
//                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
//                                                                                       return 'images/ic_completed.svg';
//                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
//                                                                                       return 'images/ic_cancel.svg';
//                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//                                                                                       return 'images/ic_completed.svg';
//                                                                                     } else {
//                                                                                       return 'images/ic_accept.svg';
//                                                                                     }
//                                                                                   } else {
//                                                                                     if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//                                                                                       return 'images/ic_pending.svg';
//                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
//                                                                                       return 'images/ic_accept.svg';
//                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
//                                                                                       return 'images/ic_pickup.svg';
//                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
//                                                                                       return 'images/ic_completed.svg';
//                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
//                                                                                       return 'images/ic_cancel.svg';
//                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
//                                                                                       return 'images/ic_cancel.svg';
//                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//                                                                                       return 'images/ic_completed.svg';
//                                                                                     }
//                                                                                   }
//                                                                                 }()) ??
//                                                                                 '',
//                                                                             color:
//                                                                                 (() {
//                                                                               // your code here
//                                                                               // _orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' ? 'Ordered on ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}' : 'Delivered on October 10,2020, 09:23pm',
//                                                                               if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//                                                                                 return Color(Constants.colorOrderPending);
//                                                                               } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//                                                                                 return Color(Constants.colorBlack);
//                                                                               } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
//                                                                                 return Color(Constants.colorOrderPickup);
//                                                                               }
//                                                                             }()),
//                                                                             width:
//                                                                                 15,
//                                                                             height:
//                                                                                 ScreenUtil().setHeight(15),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                       TextSpan(
//                                                                           text:
//                                                                               (() {
//                                                                             if (_orderHistoryController.listOrderHistory[index].deliveryType ==
//                                                                                 'TAKEAWAY') {
//                                                                               if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
//                                                                                 return 'Waiting For User To Pickup';
//                                                                               }
//                                                                             } else {
//                                                                               if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP' || _orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//                                                                                 return 'Waiting For Driver To Pickup';
//                                                                               }
//                                                                             }
//                                                                             return _orderHistoryController.listOrderHistory[index].orderStatus;
//                                                                             // if (_orderHistoryController.listOrderHistory[index].addressId != null) {
//                                                                             //
//                                                                             //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//                                                                             //     return Languages.of(context)!.labelOrderPending;
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
//                                                                             //     return Languages.of(context)!.labelOrderAccepted;
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//                                                                             //     return Languages.of(context)!.labelOrderAccepted;
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
//                                                                             //     return Languages.of(context)!.labelOrderRejected;
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
//                                                                             //     return 'PREPARING FOOD';
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
//                                                                             //     return 'READY TO PICKUP';
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
//                                                                             //     return Languages.of(context)!.labelOrderPickedUp;
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
//                                                                             //     return Languages.of(context)!.labelDeliveredSuccess;
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
//                                                                             //     return Languages.of(context)!.labelOrderCanceled;
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//                                                                             //     return Languages.of(context)!.labelOrderCompleted;
//                                                                             //   }
//                                                                             // } else {
//                                                                             //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//                                                                             //     return Languages.of(context)!.labelOrderPending;
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
//                                                                             //     return Languages.of(context)!.labelOrderAccepted;
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//                                                                             //     return Languages.of(context)!.labelOrderAccepted;
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
//                                                                             //     return 'PREPARING FOOD';
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
//                                                                             //     return 'READY TO PICKUP';
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
//                                                                             //     return Languages.of(context)!.labelOrderRejected;
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//                                                                             //     return Languages.of(context)!.labelOrderCompleted;
//                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
//                                                                             //     return Languages.of(context)!.labelOrderCanceled;
//                                                                             //   }
//                                                                             // }
//                                                                           }()),
//                                                                           style: TextStyle(
//                                                                               color: (() {
//                                                                                 if (_orderHistoryController.listOrderHistory[index].addressId != null) {
//                                                                                   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//                                                                                     return Color(Constants.colorOrderPending);
//                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
//                                                                                     return Color(Constants.colorBlack);
//                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//                                                                                     return Color(Constants.colorBlack);
//                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
//                                                                                     return Color(Constants.colorLike);
//                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
//                                                                                     return Color(Constants.colorOrderPickup);
//                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
//                                                                                     return Color(Constants.colorTheme);
//                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
//                                                                                     return Color(Constants.colorLike);
//                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//                                                                                     return Color(Constants.colorTheme);
//                                                                                   } else {
//                                                                                     return Color(Constants.colorTheme);
//                                                                                   }
//                                                                                 } else {
//                                                                                   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//                                                                                     return Color(Constants.colorOrderPending);
//                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
//                                                                                     return Color(Constants.colorBlack);
//                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//                                                                                     return Color(Constants.colorBlack);
//                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
//                                                                                     return Color(Constants.colorLike);
//                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
//                                                                                     return Color(Constants.colorOrderPickup);
//                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
//                                                                                     return Color(Constants.colorTheme);
//                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
//                                                                                     return Color(Constants.colorLike);
//                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//                                                                                     return Color(Constants.colorTheme);
//                                                                                   } else {
//                                                                                     return Color(Constants.colorTheme);
//                                                                                   }
//                                                                                 }
//                                                                               }()),
//                                                                               fontFamily: Constants.appFont,
//                                                                               fontSize: 12)),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               )
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           left: 5,
//                                                           right: 5,
//                                                           top: 20),
//                                                   child: DottedLine(
//                                                     dashColor:
//                                                         Color(0xffcccccc),
//                                                   ),
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     Expanded(
//                                                         flex: 5,
//                                                         child: Column(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .stretch,
//                                                           children: [
//                                                             ListView.builder(
//                                                               physics:
//                                                                   ClampingScrollPhysics(),
//                                                               shrinkWrap: true,
//                                                               scrollDirection:
//                                                                   Axis.vertical,
//                                                               itemCount:
//                                                                   _orderHistoryController
//                                                                       .listOrderHistory[
//                                                                           index]
//                                                                       .orderItems!
//                                                                       .length,
//                                                               itemBuilder: (BuildContext
//                                                                           context,
//                                                                       int innerindex) =>
//                                                                   Padding(
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                             .only(
//                                                                         left:
//                                                                             20,
//                                                                         top:
//                                                                             20),
//                                                                 child: Column(
//                                                                   children: [
//                                                                     Row(
//                                                                       children: [
//                                                                         Text(
//                                                                           _orderHistoryController
//                                                                               .listOrderHistory[index]
//                                                                               .orderItems![innerindex]
//                                                                               .itemName
//                                                                               .toString(),
//                                                                           style: TextStyle(
//                                                                               fontFamily: Constants.appFont,
//                                                                               fontSize: 12),
//                                                                         ),
//                                                                         Padding(
//                                                                           padding:
//                                                                               const EdgeInsets.only(left: 5),
//                                                                           child: Text(
//                                                                               (() {
//                                                                                 String qty = '';
//                                                                                 if (_orderHistoryController.listOrderHistory[index].orderItems!.length > 0 && _orderHistoryController.listOrderHistory[index].orderItems != null) {
//                                                                                   // for (int i = 0; i < _orderHistoryController.listOrderHistory[index].orderItems.length; i++) {
//                                                                                   qty = ' X ${_orderHistoryController.listOrderHistory[index].orderItems![innerindex].qty.toString()}';
//                                                                                   // }
//                                                                                   return qty;
//                                                                                 } else {
//                                                                                   return '';
//                                                                                 }
//                                                                               }()),
//                                                                               style: TextStyle(color: Color(Constants.colorTheme), fontFamily: Constants.appFont, fontSize: 12)),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             SizedBox(
//                                                               height:
//                                                                   ScreenUtil()
//                                                                       .setHeight(
//                                                                           10),
//                                                             ),
//                                                             //Order Cancel
//                                                             if (_orderHistoryController
//                                                                         .listOrderHistory[
//                                                                             index]
//                                                                         .deliveryType ==
//                                                                     'DINING' &&
//                                                                 _orderHistoryController
//                                                                         .listOrderHistory[
//                                                                             index]
//                                                                         .orderStatus !=
//                                                                     'COMPLETE')
//                                                               Column(
//                                                                 children: [
//                                                                   Container(
//                                                                       height: ScreenUtil()
//                                                                           .setHeight(
//                                                                               40),
//                                                                       child:
//                                                                           GestureDetector(
//                                                                         onTap:
//                                                                             () {
//                                                                           _cartController.cartMaster = CartMaster.fromMap(jsonDecode(_orderHistoryController
//                                                                               .listOrderHistory[index]
//                                                                               .orderData!));
//                                                                           _cartController
//                                                                               .cartMaster
//                                                                               ?.oldOrderId = _orderHistoryController.listOrderHistory[index].id;
//                                                                           _cartController.tableNumber = _orderHistoryController
//                                                                               .listOrderHistory[index]
//                                                                               .tableNo;
//                                                                           Get.to(() =>
//                                                                               PosMenu(isDining: true));
//                                                                         },
//                                                                         child: Align(
//                                                                             alignment:
//                                                                                 Alignment.center,
//                                                                             child: Text('Edit This Order')),
//                                                                       )),
//                                                                 ],
//                                                               ),
//                                                             if (_orderHistoryController
//                                                                         .listOrderHistory[
//                                                                             index]
//                                                                         .orderStatus ==
//                                                                     'PENDING' ||
//                                                                 _orderHistoryController
//                                                                         .listOrderHistory[
//                                                                             index]
//                                                                         .orderStatus ==
//                                                                     'APPROVE')
//                                                               Container(
//                                                                 height:
//                                                                     ScreenUtil()
//                                                                         .setHeight(
//                                                                             50),
//                                                                 child:
//                                                                     ElevatedButton(
//                                                                   style: ElevatedButton
//                                                                       .styleFrom(
//                                                                     primary: Colors
//                                                                         .white,
//                                                                     shape: RoundedRectangleBorder(
//                                                                         borderRadius: BorderRadius.only(
//                                                                             bottomLeft: Radius.circular(
//                                                                                 20),
//                                                                             bottomRight: Radius.circular(
//                                                                                 20)),
//                                                                         side: BorderSide
//                                                                             .none),
//                                                                   ),
//                                                                   onPressed:
//                                                                       () async {
//                                                                     await showCancelOrderDialog(_orderHistoryController
//                                                                         .listOrderHistory[
//                                                                             index]
//                                                                         .id);
//                                                                     setState(
//                                                                         () {
//                                                                       orderHistoryRef =
//                                                                           _orderHistoryController
//                                                                               .refreshOrderHistory(context);
//                                                                     });
//                                                                   },
//                                                                   child:
//                                                                       RichText(
//                                                                     text:
//                                                                         TextSpan(
//                                                                       children: [
//                                                                         WidgetSpan(
//                                                                           child:
//                                                                               Padding(
//                                                                             padding:
//                                                                                 EdgeInsets.only(right: ScreenUtil().setHeight(10)),
//                                                                             child:
//                                                                                 SvgPicture.asset(
//                                                                               'images/ic_cancel.svg',
//                                                                               width: ScreenUtil().setWidth(20),
//                                                                               //color: Color(Constants.colorRate),
//                                                                               height: ScreenUtil().setHeight(20),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                         TextSpan(
//                                                                           text:
//                                                                               'Cancel this order',
//                                                                           style: TextStyle(
//                                                                               color: Color(Constants.colorLike),
//                                                                               fontSize: 18,
//                                                                               fontFamily: Constants.appFont),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             (() {
//                                                               if (_orderHistoryController
//                                                                           .listOrderHistory[
//                                                                               index]
//                                                                           .orderStatus ==
//                                                                       'CANCEL' ||
//                                                                   _orderHistoryController
//                                                                           .listOrderHistory[
//                                                                               index]
//                                                                           .orderStatus ==
//                                                                       'COMPLETE') {
//                                                                 return Container();
//                                                                 // return Container(
//                                                                 //   height: ScreenUtil()
//                                                                 //       .setHeight(
//                                                                 //       40),
//                                                                 //   child:
//                                                                 //   ElevatedButton(
//                                                                 //     style: ElevatedButton.styleFrom(
//                                                                 //       primary: Colors.white,
//                                                                 //       shape: RoundedRectangleBorder(
//                                                                 //           borderRadius:
//                                                                 //           BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
//                                                                 //           side: BorderSide.none),
//                                                                 //     ),
//                                                                 //     onPressed:
//                                                                 //         () {
//                                                                 //       Navigator.of(context).push(Transitions(
//                                                                 //           transitionType: TransitionType.fade,
//                                                                 //           curve: Curves.bounceInOut,
//                                                                 //           reverseCurve: Curves.fastLinearToSlowEaseIn,
//                                                                 //           widget: OrderReviewScreen(
//                                                                 //             orderId: _orderHistoryController.listOrderHistory[index].id,
//                                                                 //           )));
//                                                                 //     },
//                                                                 //     child: RichText(
//                                                                 //       text:
//                                                                 //       TextSpan(
//                                                                 //         children: [
//                                                                 //           WidgetSpan(
//                                                                 //             child: Padding(
//                                                                 //               padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
//                                                                 //               child: SvgPicture.asset(
//                                                                 //                 'images/ic_star.svg',
//                                                                 //                 width: ScreenUtil().setWidth(20),
//                                                                 //                 color: Color(Constants.colorRate),
//                                                                 //                 height: ScreenUtil().setHeight(20),
//                                                                 //               ),
//                                                                 //             ),
//                                                                 //           ),
//                                                                 //           TextSpan(
//                                                                 //             text: (() {
//                                                                 //               // your code here
//                                                                 //               // _orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' ? 'Ordered on ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}' : 'Delivered on October 10,2020, 09:23pm',
//                                                                 //               if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL' || _orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//                                                                 //                 return 'Rate Now';
//                                                                 //               } else {
//                                                                 //                 return '';
//                                                                 //               }
//                                                                 //             }()),
//                                                                 //             style: TextStyle(color: Color(Constants.colorRate), fontSize: 18, fontFamily: Constants.appFont),
//                                                                 //           ),
//                                                                 //         ],
//                                                                 //       ),
//                                                                 //     ),
//                                                                 //
//                                                                 //   ),
//                                                                 // );
//                                                               } else {
//                                                                 return Container();
//                                                               }
//                                                             }()),
//                                                             if (_orderHistoryController
//                                                                         .listOrderHistory[
//                                                                             index]
//                                                                         .orderStatus !=
//                                                                     'COMPLETE' &&
//                                                                 _orderHistoryController
//                                                                         .listOrderHistory[
//                                                                             index]
//                                                                         .orderStatus !=
//                                                                     'CANCEL' &&
//                                                                 _orderHistoryController
//                                                                         .listOrderHistory[
//                                                                             index]
//                                                                         .deliveryType ==
//                                                                     'DINING')
//                                                               Container(
//                                                                 height:
//                                                                     ScreenUtil()
//                                                                         .setHeight(
//                                                                             40),
//                                                                 child:
//                                                                     ElevatedButton(
//                                                                   style: ElevatedButton
//                                                                       .styleFrom(
//                                                                     primary: Color(
//                                                                         Constants
//                                                                             .colorTheme),
//                                                                     shape: RoundedRectangleBorder(
//                                                                         borderRadius: BorderRadius.only(
//                                                                             bottomLeft: Radius.circular(
//                                                                                 20),
//                                                                             bottomRight: Radius.circular(
//                                                                                 20)),
//                                                                         side: BorderSide
//                                                                             .none),
//                                                                   ),
//                                                                   onPressed:
//                                                                       () {
//                                                                     // showCancelOrderDialog(_orderHistoryController.listOrderHistory[index].id);
//                                                                   },
//                                                                   child:
//                                                                       RichText(
//                                                                     text:
//                                                                         TextSpan(
//                                                                       children: [
//                                                                         TextSpan(
//                                                                           text:
//                                                                               'Live Order',
//                                                                           style:
//                                                                               TextStyle(
//                                                                             color:
//                                                                                 Colors.white,
//                                                                             fontSize:
//                                                                                 18,
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                           ],
//                                                         )),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   })),
//                             ),
//                           ],
//                         ),
//                 );

  ///Center Circle code
  // return Center(
  //   child: SpinKitFadingCircle(
  //     color: Color(Constants.colorTheme),
  //   ),
  // );

  Widget delieveryTypeButton(
      {required void Function()? onTap,
      required IconData icon,
      required String title,
      required TextStyle style,
      required Color buttonColor,
      required Color color}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(4.0),
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
              ),
              Text(
                title,
                style: style,
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    firebaseListener?.cancel();
    super.dispose();
  }

  Future<CommenRes> getTakeAwayValue(int id) async {
    final _data = <String, dynamic>{
      "old_takaway_id": id,
      "order_status": "COMPLETE"
    };
    return await RestClient(await RetroApi().dioData())
        .completeTakeawayOrder(_data);
  }
}
