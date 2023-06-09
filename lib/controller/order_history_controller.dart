// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:pos/model/order_history_list_model.dart';
// import 'package:pos/retrofit/api_client.dart';
// import 'package:pos/retrofit/api_header.dart';
// import 'package:pos/retrofit/base_model.dart';
// import 'package:pos/retrofit/server_error.dart';
// import 'package:pos/utils/constants.dart';
// class OrderHistoryController extends GetxController{
//   RxList<OrderHistoryData> listOrderHistory = <OrderHistoryData>[].obs;
//
//
//   Future<BaseModel<OrderHistoryListModel>> callGetOrderHistoryList() async {
//     OrderHistoryListModel response;
//     try{
//       response  = await  RestClient(await RetroApi().dioData()).showOrder();
//       if (response.success!) {
//         listOrderHistory.value=response.data!;
//       } else {
//         Constants.toastMessage('No Data');
//       }
//
//     }catch (error, stacktrace) {
//       print("Exception occurred: $error stackTrace: $stacktrace");
//       return BaseModel()..setException(ServerError.withError(error: error));
//     }
//     return BaseModel()..data = response;
//   }
//
//   Future<BaseModel<OrderHistoryListModel>> refreshOrderHistory(BuildContext context)async{
//     OrderHistoryListModel response;
//     try{
//       response  = await  RestClient(await RetroApi().dioData()).showOrder();
//       if (response.success!) {
//         listOrderHistory.value=response.data!;
//       } else {
//         Constants.toastMessage('No Data');
//       }
//
//     }catch (error, stacktrace) {
//       print("Exception occurred: $error stackTrace: $stacktrace");
//       return BaseModel()..setException(ServerError.withError(error: error));
//     }
//     return BaseModel()..data = response;
//   }
// }

///Changes after
import 'dart:async';
import 'dart:convert';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/model/cart_master.dart' as cartMasterModel;
import 'package:pos/model/common_res.dart' as commonRes;
import 'package:pos/model/order_history_list_model.dart';
import 'package:pos/pages/order/OrderDetailScreen.dart';
import 'package:pos/pages/pos/Paymmmm/linkly_controller.dart';
import 'package:pos/printer/printer_controller.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FilterType { TakeAway, DineIn, None }

class OrderHistoryController extends GetxController {
  // final LinklyDataController _linklyDataController=  Get.put(LinklyDataController());
  Rx<Future<BaseModel<OrderHistoryListModel>>?> orderHistoryRef =
      Rx<Future<BaseModel<OrderHistoryListModel>>?>(null);
  RxList<OrderHistoryData> listOrderHistory = <OrderHistoryData>[].obs;
  final DatabaseReference firebaseRef = FirebaseDatabase.instance.ref();
  final TextEditingController _textOrderCancelReason = TextEditingController();
  StreamSubscription<DatabaseEvent>? firebaseListener;
  final RxString searchQuery = ''.obs;
  List<OrderHistoryData> totalOrders = <OrderHistoryData>[];
  List<OrderHistoryData> takeAwayOrders = <OrderHistoryData>[];
  List<OrderHistoryData> DineInOrders = <OrderHistoryData>[];
  RxBool disableCompleteButton = false.obs;
  final PrinterController _printerController = Get.find<PrinterController>();

  @override
  void onInit() {
    getOrders();
    initAsync();
    super.onInit();
  }



  Future<void> getOrders() async {
    print("get orders ");
    final value = await callGetOrderHistoryList();
    if (value.data!.data!.isNotEmpty) {
      totalOrders.addAll(value.data!.data!);
      for (final element in value.data!.data!) {
        if (element.deliveryType == "TAKEAWAY") {
          takeAwayOrders.add(element);
        } else if (element.deliveryType == "DINING") {
          DineInOrders.add(element);
        }
      }
    } else {
      // handle error case
    }
  }

  initAsync() async {
    firebaseListener = firebaseRef
        .child('orders')
        .child((await SharedPreferences.getInstance())
                .getString(Constants.loginUserId) ??
            '144')
        .onChildChanged
        .listen((event) {
      print("Event Trigger ${event.snapshot.value}");
      getOrders();
    });
  }

  Future<BaseModel<OrderHistoryListModel>> callGetOrderHistoryList() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(Constants.loginUserId.toString()) ?? '';
    OrderHistoryListModel response;
    try {
      response = await RestClient(await RetroApi().dioData()).showOrder(
        int.parse(userId.toString()),
      );
      if (response.success!) {
        listOrderHistory.value = response.data!;
      } else {
        Constants.toastMessage('No Data');
      }
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  void testPrintPOS(String printerIp, int port, BuildContext ctx,
      OrderHistoryData order) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final PosPrintResult res = await printer.connect(
      printerIp,
      port: port,
    );
    if (res == PosPrintResult.success) {
      printPOSReceipt(printer, order);
      printer.disconnect();
    }
  }

  printPOSReceipt(
    NetworkPrinter printer,
    OrderHistoryData order,
  ) {

    printer.text(order.vendorName!,
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));



    printer.text(order.vendorAddress.toString(),
        styles: const PosStyles(align: PosAlign.center));

    printer.text("Phone : ${order.vendorContact.toString()}",
        styles: const PosStyles(align: PosAlign.left));

    printer.text("Order Id ${order.orderId.toString()} (Duplicate Bill)",
        styles: const PosStyles(align: PosAlign.left));

    if (order.datumUserName != null && order.datumUserName!.isNotEmpty) {
      printer.text('Customer Name : ${order.datumUserName}',
          styles: PosStyles(align: PosAlign.left));
    }
    if (order.mobile != null && order.mobile!.isNotEmpty) {
      printer.text('Customer Phone No : ${order.mobile}',
          styles: PosStyles(align: PosAlign.left));
    }



    printer.text('${DateFormat('yyyy-MM-dd').format(order.date!)} ${order.time}',
        styles: const PosStyles(align: PosAlign.left));

    if (order.tableNo != null && order.tableNo != 0) {
      printer.text('Table Number : ${order.tableNo}',
          styles: const PosStyles(align: PosAlign.left));
    }

    if (order.paymentType == "INCOMPLETE ORDER") {
      printer.text('Payment Status : UnPaid',
          styles: PosStyles(align: PosAlign.left));
    } else {
      if(order.paymentType == "POS CASH TAKEAWAY"){
        printer.text('Payment Status : POS CASH',
            styles: PosStyles(align: PosAlign.left));
      }else if(order.paymentType == "POS CARD TAKEAWAY"){
        printer.text('Payment Status : POS CARD',
            styles: PosStyles(align: PosAlign.left));
      } else {
        printer.text('Payment Status : ${order.paymentType}',
            styles: PosStyles(align: PosAlign.left));
      }
    }

    printer.text('Order Type :  ${order.deliveryType.toString()}',
        styles: const PosStyles(align: PosAlign.left));

    printer.hr();
    printer.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Item', width: 9),
      PosColumn(
          text: 'Total',
          width: 2,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    Map<String, dynamic> jsonMap = jsonDecode(order.orderData!);
    OrderDataModel orderData = OrderDataModel.fromJson(jsonMap);
    for (int itemIndex = 0; itemIndex < orderData.cart!.length; itemIndex++) {
      String category = orderData.cart![itemIndex].category!;
      List<Menu> menu = orderData.cart![itemIndex].menu!;
      var price;
      if (order.deliveryType == 'DINING') {
        price = orderData.cart![itemIndex].diningAmount;
      } else {
        price = orderData.cart![itemIndex].totalAmount;
      }

      if (category == 'SINGLE') {
        for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
          Menu menuItem = menu[menuIndex];
          printer.row([
            PosColumn(
                text: orderData.cart![itemIndex].quantity.toString(), width: 1),
            PosColumn(
              text: orderData.cart![itemIndex].menu!.first.name.toString() +
                  (orderData.cart![itemIndex].size != null
                      ? '(${orderData.cart![itemIndex].size['size_name']})'
                      : ''),
              width: 9,
            ),
            PosColumn(
                text: double.parse(price.toString()).toStringAsFixed(2),
                width: 2,
                styles: const PosStyles(align: PosAlign.right)),
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
            //         styles: const PosStyles(
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
                  text: '',
                  width: 2,
                  styles: const PosStyles(align: PosAlign.right)),
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
    }
    printer.hr();

    printer.row([
      PosColumn(
          text: 'SubTotal',
          width: 6,
          styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: double.parse(order.subTotal.toString()).toStringAsFixed(2),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    if (double.parse(order.tax!)
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
            text: "$currencySymbol${double.parse(order.tax!)
                .toStringAsFixed(2)}",
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
      ]);
    }

    if (order.discounts != null) {
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
                "$currencySymbol${double.parse(order.discounts!.toString()).toStringAsFixed(2)}",
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
          styles: const PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: double.parse(order.amount!.toString()).toStringAsFixed(2),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);

    printer.hr();

    if (order.notes != null) {
      printer.text(
        "Instructions: ${order.notes}",
      );
    }

    printer.hr(ch: '=', linesAfter: 1);

    printer.feed(2);
    printer.text('Thank you!',
        styles: const PosStyles(align: PosAlign.center, bold: true));

    printer.feed(1);
    printer.cut();
    printer.beep();
  }

  void testPrintKitchen(String printerIp, int port, BuildContext ctx,
      OrderHistoryData order, bool orderCheck) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final PosPrintResult res = await printer.connect(
      printerIp,
      port: port,
    );

    if (res == PosPrintResult.success) {
      printKitchenReceipt(printer, order, orderCheck);
      printer.disconnect();
    }
  }

  printKitchenReceipt(NetworkPrinter printer, OrderHistoryData order,  bool orderCheck) {
    Map<String, dynamic> jsonMap = jsonDecode(order.orderData!);
    OrderDataModel orderData = OrderDataModel.fromJson(jsonMap);


    if(orderCheck == false) {
      printer.text("*** Kitchen ***",
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));
    } else {
      printer.text("Order Cancelled \nOrder Id ${order.orderId.toString()}",
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ),
      linesAfter: 1);

    }




    if (order.tableNo != null && order.tableNo != 0) {
      printer.text('Table Number : ${order.tableNo}',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ),
          linesAfter: 1);
    }
    if(orderCheck == false) {
      printer.text("Order Id ${order.orderId.toString()} (Duplicate Bill)",
          styles: const PosStyles(align: PosAlign.left));
    } else{
      printer.text("Order Id ${order.orderId.toString()}",
          styles: const PosStyles(align: PosAlign.left));
    }

    if (order.datumUserName != null && order.datumUserName!.isNotEmpty) {
      printer.text('Customer Name : ${order.datumUserName}',
          styles: PosStyles(align: PosAlign.left));
    }
    if (order.mobile != null && order.mobile!.isNotEmpty) {
      printer.text('Customer Phone No : ${order.mobile}',
          styles: PosStyles(align: PosAlign.left));
    }

    printer.text('${DateFormat('yyyy-MM-dd').format(order.date!)} ${order.time}',
        styles: const PosStyles(align: PosAlign.left));
    if(orderCheck == false) {
      if (order.paymentType == "INCOMPLETE ORDER") {
        printer.text('Payment Status : UnPaid',
            styles: PosStyles(align: PosAlign.left));
      } else {
        if (order.paymentType == "POS CASH TAKEAWAY") {
          printer.text('Payment Status : POS CASH',
              styles: PosStyles(align: PosAlign.left));
        } else if (order.paymentType == "POS CARD TAKEAWAY") {
          printer.text('Payment Status : POS CARD',
              styles: PosStyles(align: PosAlign.left));
        } else {
          printer.text('Payment Status : ${order.paymentType}',
              styles: PosStyles(align: PosAlign.left));
        }
      }
    } else {
      printer.text('Payment Status : Refunded',
          styles: PosStyles(align: PosAlign.left));
    }
    printer.text('Order Type :  ${order.deliveryType.toString()}',
        styles: const PosStyles(align: PosAlign.left));

    printer.hr();
    printer.row([
      PosColumn(text: 'Qty', width: 2),
      PosColumn(text: 'Item', width: 10),
    ]);
    for (int itemIndex = 0; itemIndex < orderData.cart!.length; itemIndex++) {
      String category = orderData.cart![itemIndex].category!;
      List<Menu> menu = orderData.cart![itemIndex].menu!;
      if (category == 'SINGLE') {
        for (int menuIndex = 0; menuIndex < menu.length; menuIndex++) {
          Menu menuItem = menu[menuIndex];
          printer.row([
            PosColumn(
                text: orderData.cart![itemIndex].quantity.toString(), width: 2),
            PosColumn(
              text: orderData.cart![itemIndex].menu!.first.name.toString() +
                  (orderData.cart![itemIndex].size != null
                      ? '(${orderData.cart![itemIndex].size['size_name']})'
                      : ''),
              width: 10,
            ),
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
            //         styles: const PosStyles(
            //             width: PosTextSize.size1,
            //             height: PosTextSize.size1,
            //             align: PosAlign.center))
            //   ]);
            // }
            printer.row([
              PosColumn(text: '', width: 2),
              PosColumn(text: ' ${addonItem.name} (ADDON)', width: 10),
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
    }
    printer.hr();



    if (order.notes != null) {
      printer.text(
        "Instructions: ${order.notes}",
      );
    }

    printer.hr(ch: '=', linesAfter: 1);

    printer.feed(2);
    printer.text('Thank you!',
        styles: const PosStyles(align: PosAlign.center, bold: true));

    printer.feed(1);
    printer.cut();
    printer.beep();
  }

  List<OrderHistoryData> getFilteredOrders() {
    totalOrders = [];
    takeAwayOrders = [];
    DineInOrders = [];
    final value = listOrderHistory;
    if (value.isNotEmpty) {
      totalOrders.addAll(value);
      for (final element in value) {
        if (element.deliveryType == "TAKEAWAY") {
          takeAwayOrders.add(element);
        } else if (element.deliveryType == "DINING") {
          DineInOrders.add(element);
        }
      }
    } else {
      // handle error case
    }
    RxList<OrderHistoryData> filteredOrders = <OrderHistoryData>[].obs;
    if (filterType.value == FilterType.TakeAway) {
      filteredOrders.value = takeAwayOrders;
    } else if (filterType.value == FilterType.DineIn) {
      filteredOrders.value = DineInOrders;
    } else {
      filteredOrders.value = totalOrders;
    }

    if (searchQuery.isNotEmpty) {
      filteredOrders.value = filteredOrders
          .where((order) =>
              (order.datumUserName != null &&
                  order.datumUserName!
                      .toLowerCase()
                      .contains(searchQuery.value.toLowerCase())) ||
              (order.orderId!
                  .toLowerCase()
                  .contains('#${searchQuery.value.toLowerCase()}')))
          .toList();
    }
    return filteredOrders.value;
  }

  final Rx<FilterType> filterType = FilterType.None.obs;

  applyFilterType(FilterType value) {
    filterType.value = value;
  }


  showCancelOrderDialog(OrderHistoryData order, int? orderId, BuildContext context) {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return StatefulBuilder(
    //       builder: (context, setState) {
    //         return Center(
    //           child: Dialog(
    //             child: Padding(
    //               padding: EdgeInsets.all(20),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.stretch,
    //                 children: [
    //                   InkWell(
    //                     onTap: () {
    //                       Navigator.of(context).pop();
    //                     },
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Text(
    //                           'Cancel Order',
    //                           overflow: TextOverflow.ellipsis,
    //                           maxLines: 1,
    //                           style: TextStyle(
    //                             fontSize: ScreenUtil().setSp(18),
    //                             fontWeight: FontWeight.w900,
    //                             fontFamily: Constants.appFontBold,
    //                           ),
    //                         ),
    //                         GestureDetector(
    //                           child: Icon(Icons.close),
    //                           onTap: () {
    //                             Navigator.pop(context);
    //                           },
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: ScreenUtil().setHeight(10),
    //                   ),
    //                   const Divider(
    //                     thickness: 1,
    //                     color: Color(0xffcccccc),
    //                   ),
    //                   SizedBox(
    //                     height: ScreenUtil().setHeight(10),
    //                   ),
    //                   Text(
    //                     'Order Cancel Reason',
    //                     style: TextStyle(
    //                         fontFamily: Constants.appFontBold, fontSize: 16),
    //                   ),
    //                   SizedBox(
    //                     height: ScreenUtil().setHeight(10),
    //                   ),
    //                   Card(
    //                     elevation: 3,
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(10.0),
    //                     ),
    //                     child: Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: TextField(
    //                         controller: _textOrderCancelReason,
    //                         keyboardType: TextInputType.text,
    //                         decoration: const InputDecoration(
    //                             contentPadding: EdgeInsets.only(left: 10),
    //                             hintText: 'Type Order Cancel Reason',
    //                             border: InputBorder.none),
    //                         maxLines: 5,
    //                         style: TextStyle(
    //                             fontFamily: Constants.appFont,
    //                             fontSize: 16,
    //                             color: Color(
    //                               Constants.colorGray,
    //                             )),
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: ScreenUtil().setHeight(10),
    //                   ),
    //                   const Divider(
    //                     thickness: 1,
    //                     color: Color(0xffcccccc),
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.end,
    //                     children: [
    //                       ElevatedButton(
    //                         style: ButtonStyle(
    //                           backgroundColor: MaterialStateProperty.all<Color>(Color(Constants.colorTheme)),
    //                           // set the height to 50
    //                           fixedSize: MaterialStateProperty.all<Size>(const Size(130, 40)),
    //                         ),
    //                         onPressed: (){
    //                         _textOrderCancelReason.clear();
    //                         Navigator.pop(context);
    //                       }, child: Text(
    //                         'No Go Back',
    //                         style: TextStyle(
    //                             fontSize: ScreenUtil().setSp(14),
    //                             fontWeight: FontWeight.bold,
    //                             fontFamily: Constants.appFontBold,
    //                             color: Colors.white),
    //                       ),),
    //
    //                       Padding(
    //                         padding: EdgeInsets.only(
    //                             left: ScreenUtil().setWidth(12)),
    //                         child: ElevatedButton(
    //                           style: ButtonStyle(
    //                             backgroundColor: MaterialStateProperty.all<Color>(Color(Constants.colorTheme)),
    //                             // set the height to 50
    //                             fixedSize: MaterialStateProperty.all<Size>(const Size(130, 40)),
    //                           ),
    //                           onPressed: () async {
    //                           if (_textOrderCancelReason.text.isNotEmpty) {
    //                             await callCancelOrder(orderId,
    //                                 _textOrderCancelReason.text, context);
    //                             if ((_printerController.printerModel.value.ipKitchen !=
    //                                 null &&
    //                                 _printerController
    //                                     .printerModel
    //                                     .value
    //                                     .ipKitchen!
    //                                     .isNotEmpty) &&
    //                                 (_printerController.printerModel.value.portKitchen !=
    //                                     null &&
    //                                     _printerController
    //                                         .printerModel
    //                                         .value
    //                                         .portKitchen!
    //                                         .isNotEmpty)) {
    //                               testPrintKitchen(
    //                                   _printerController
    //                                       .printerModel
    //                                       .value
    //                                       .ipKitchen!,
    //                                   int.parse(_printerController
    //                                       .printerModel
    //                                       .value
    //                                       .portKitchen
    //                                       .toString()),
    //                                   context,
    //                                   order,
    //                                   true
    //                               );
    //                             } else {
    //                               Get.snackbar(
    //                                   "Error",
    //                                   "Please add kitchen printer ip and port");
    //                             }
    //                           } else {
    //                             Constants.toastMessage(
    //                                 'Please Enter Cancel Reason');
    //                           }
    //                         }, child: Text(
    //                           'Yes Cancel It',
    //                           style: TextStyle(
    //                               fontSize: ScreenUtil().setSp(14),
    //                               fontWeight: FontWeight.bold,
    //                               fontFamily: Constants.appFontBold,
    //                               color: Colors.white),
    //                         ),),
    //                       ),
    //                     ],
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );

    ///Second
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return StatefulBuilder(
    //       builder: (context, setState) {
    //         return Center(
    //           child: FractionallySizedBox(
    //             widthFactor: 0.8, // Adjust the width as needed
    //             child: Dialog(
    //               child: Padding(
    //                 padding: EdgeInsets.all(20),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.stretch,
    //                   children: [
    //                     InkWell(
    //                       onTap: () {
    //                         Navigator.of(context).pop();
    //                       },
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Text(
    //                             'Cancel Order',
    //                             overflow: TextOverflow.ellipsis,
    //                             maxLines: 1,
    //                             style: TextStyle(
    //                               fontSize: ScreenUtil().setSp(18),
    //                               fontWeight: FontWeight.w900,
    //                               fontFamily: Constants.appFontBold,
    //                             ),
    //                           ),
    //                           GestureDetector(
    //                             child: Icon(Icons.close),
    //                             onTap: () {
    //                               Navigator.pop(context);
    //                             },
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: ScreenUtil().setHeight(10),
    //                     ),
    //                     const Divider(
    //                       thickness: 1,
    //                       color: Color(0xffcccccc),
    //                     ),
    //                     SizedBox(
    //                       height: ScreenUtil().setHeight(10),
    //                     ),
    //                     Text(
    //                       'Order Cancel Reason',
    //                       style: TextStyle(
    //                           fontFamily: Constants.appFontBold, fontSize: 16),
    //                     ),
    //                     SizedBox(
    //                       height: ScreenUtil().setHeight(10),
    //                     ),
    //                     Card(
    //                       elevation: 3,
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(10.0),
    //                       ),
    //                       child: Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: TextField(
    //                           controller: _textOrderCancelReason,
    //                           keyboardType: TextInputType.text,
    //                           decoration: const InputDecoration(
    //                               contentPadding: EdgeInsets.only(left: 10),
    //                               hintText: 'Type Order Cancel Reason',
    //                               border: InputBorder.none),
    //                           maxLines: 5,
    //                           style: TextStyle(
    //                               fontFamily: Constants.appFont,
    //                               fontSize: 16,
    //                               color: Color(
    //                                 Constants.colorGray,
    //                               )),
    //                         ),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: ScreenUtil().setHeight(10),
    //                     ),
    //                     const Divider(
    //                       thickness: 1,
    //                       color: Color(0xffcccccc),
    //                     ),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.end,
    //                       children: [
    //                         ElevatedButton(
    //                           style: ButtonStyle(
    //                             backgroundColor:
    //                             MaterialStateProperty.all<Color>(
    //                                 Color(Constants.colorTheme)),
    //                             // set the height to 50
    //                             fixedSize: MaterialStateProperty.all<Size>(
    //                                 const Size(130, 40)),
    //                           ),
    //                           onPressed: () {
    //                             _textOrderCancelReason.clear();
    //                             Navigator.pop(context);
    //                           },
    //                           child: Text(
    //                             'No Go Back',
    //                             style: TextStyle(
    //                                 fontSize: ScreenUtil().setSp(14),
    //                                 fontWeight: FontWeight.bold,
    //                                 fontFamily: Constants.appFontBold,
    //                                 color: Colors.white),
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding: EdgeInsets.only(
    //                               left: ScreenUtil().setWidth(12)),
    //                           child: ElevatedButton(
    //                             style: ButtonStyle(
    //                               backgroundColor:
    //                               MaterialStateProperty.all<Color>(
    //                                   Color(Constants.colorTheme)),
    //                               // set the height to 50
    //                               fixedSize: MaterialStateProperty.all<Size>(
    //                                   const Size(130, 40)),
    //                             ),
    //                             onPressed: () async {
    //                               if (_textOrderCancelReason.text.isNotEmpty) {
    //                                 await callCancelOrder(
    //                                     orderId,
    //                                     _textOrderCancelReason.text,
    //                                     context);
    //                                 if ((_printerController
    //                                     .printerModel.value.ipKitchen !=
    //                                     null &&
    //                                     _printerController
    //                                         .printerModel.value.ipKitchen!
    //                                         .isNotEmpty) &&
    //                                     (_printerController
    //                                         .printerModel.value.portKitchen !=
    //                                         null &&
    //                                         _printerController
    //                                             .printerModel.value.portKitchen!
    //                                             .isNotEmpty)) {
    //                                   testPrintKitchen(
    //                                       _printerController
    //                                           .printerModel.value.ipKitchen!,
    //                                       int.parse(_printerController
    //                                           .printerModel.value.portKitchen
    //                                           .toString()),
    //                                       context,
    //                                       order,
    //                                       true);
    //                                 } else {
    //                                   Get.snackbar("Error",
    //                                       "Please add kitchen printer ip and port");
    //                                 }
    //                               } else {
    //                                 Constants.toastMessage(
    //                                     'Please Enter Cancel Reason');
    //                               }
    //                             },
    //                             child: Text(
    //                               'Yes Cancel It',
    //                               style: TextStyle(
    //                                   fontSize: ScreenUtil().setSp(14),
    //                                   fontWeight: FontWeight.bold,
    //                                   fontFamily: Constants.appFontBold,
    //                                   color: Colors.white),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );

    ///Third
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: FractionallySizedBox(
                widthFactor: 0.8, // Adjust the width as needed
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5, // Adjust the height as needed
                  ),
                  child: Dialog(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
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
                            const Divider(
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
                                  decoration: const InputDecoration(
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
                            const Divider(
                              thickness: 1,
                              color: Color(0xffcccccc),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(Constants.colorTheme)),
                                    // set the height to 50
                                    fixedSize: MaterialStateProperty.all<Size>(
                                        const Size(130, 40)),
                                  ),
                                  onPressed: () {
                                    _textOrderCancelReason.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'No Go Back',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(14),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: Constants.appFontBold,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(12)),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(Constants.colorTheme)),
                                      // set the height to 50
                                      fixedSize: MaterialStateProperty.all<Size>(
                                          const Size(130, 40)),
                                    ),
                                    onPressed: () async {
                                      if (_textOrderCancelReason.text.isNotEmpty) {
                                        await callCancelOrder(
                                            orderId,
                                            _textOrderCancelReason.text,
                                            context);
                                        if ((_printerController.printerModel.value
                                            .ipKitchen !=
                                            null &&
                                            _printerController.printerModel.value
                                                .ipKitchen!.isNotEmpty) &&
                                            (_printerController.printerModel.value
                                                .portKitchen !=
                                                null &&
                                                _printerController.printerModel.value
                                                    .portKitchen!.isNotEmpty)) {
                                          testPrintKitchen(
                                              _printerController
                                                  .printerModel.value.ipKitchen!,
                                              int.parse(_printerController
                                                  .printerModel.value.portKitchen
                                                  .toString()),
                                              context,
                                              order,
                                              true);
                                        } else {
                                          Get.snackbar("Error",
                                              "Please add kitchen printer ip and port");
                                        }
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
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );


  }

  showSwitchOrderDialog(dynamic orderId, dynamic paymentType, BuildContext context) {
    var payment = '';
    if(paymentType.toString() == 'POS CASH'){
      payment = 'POS CARD';
    } else if(paymentType.toString() == 'POS CARD'){
      payment = 'POS CASH';
    }  else if(paymentType.toString() == 'POS CASH TAKEAWAY'){
      payment = 'POS CARD TAKEAWAY';
    } else if(paymentType.toString() == 'POS CARD TAKEAWAY'){
      payment = 'POS CASH TAKEAWAY';
    } else {
      payment = '';
    }
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return StatefulBuilder(
    //       builder: (context, setState) {
    //         return Dialog(
    //           insetPadding: EdgeInsets.all(15),
    //           child: Padding(
    //             padding: EdgeInsets.only(
    //                 left: ScreenUtil().setWidth(20),
    //                 right: ScreenUtil().setWidth(20),
    //                 bottom: 0,
    //                 top: ScreenUtil().setHeight(20)),
    //             child: Container(
    //               height: MediaQuery.of(context).size.height * 0.42,
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.stretch,
    //                 children: [
    //                   InkWell(
    //                     onTap: () {
    //                       Navigator.of(context).pop();
    //                     },
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Text(
    //                           'Cancel Order',
    //                           overflow: TextOverflow.ellipsis,
    //                           maxLines: 1,
    //                           style: TextStyle(
    //                             fontSize: ScreenUtil().setSp(18),
    //                             fontWeight: FontWeight.w900,
    //                             fontFamily: Constants.appFontBold,
    //                           ),
    //                         ),
    //                         GestureDetector(
    //                           child: Icon(Icons.close),
    //                           onTap: () {
    //                             Navigator.pop(context);
    //                           },
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: ScreenUtil().setHeight(10),
    //                   ),
    //                   const Divider(
    //                     thickness: 1,
    //                     color: Color(0xffcccccc),
    //                   ),
    //                   SizedBox(
    //                     height: ScreenUtil().setHeight(10),
    //                   ),
    //                   Text(
    //                     'Order Cancel Reason',
    //                     style: TextStyle(
    //                         fontFamily: Constants.appFontBold, fontSize: 16),
    //                   ),
    //                   SizedBox(
    //                     height: ScreenUtil().setHeight(10),
    //                   ),
    //                   Card(
    //                     elevation: 3,
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(10.0),
    //                     ),
    //                     child: Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: TextField(
    //                         controller: _textOrderCancelReason,
    //                         keyboardType: TextInputType.text,
    //                         decoration: const InputDecoration(
    //                             contentPadding: EdgeInsets.only(left: 10),
    //                             hintText: 'Type Order Cancel Reason',
    //                             border: InputBorder.none),
    //                         maxLines: 5,
    //                         style: TextStyle(
    //                             fontFamily: Constants.appFont,
    //                             fontSize: 16,
    //                             color: Color(
    //                               Constants.colorGray,
    //                             )),
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: ScreenUtil().setHeight(10),
    //                   ),
    //                   const Divider(
    //                     thickness: 1,
    //                     color: Color(0xffcccccc),
    //                   ),
    //                   Padding(
    //                     padding:
    //                     EdgeInsets.only(top: ScreenUtil().setHeight(15)),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.end,
    //                       children: [
    //                         GestureDetector(
    //                           onTap: () {
    //                             _textOrderCancelReason.clear();
    //                             Navigator.pop(context);
    //                           },
    //                           child: Text(
    //                             'No Go Back',
    //                             style: TextStyle(
    //                                 fontSize: ScreenUtil().setSp(14),
    //                                 fontWeight: FontWeight.bold,
    //                                 fontFamily: Constants.appFontBold,
    //                                 color: Color(Constants.colorGray)),
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding: EdgeInsets.only(
    //                               left: ScreenUtil().setWidth(12)),
    //                           child: GestureDetector(
    //                             onTap: () async {
    //                               if (_textOrderCancelReason.text.isNotEmpty) {
    //                                 await callCancelOrder(
    //                                     orderId, _textOrderCancelReason.text, context);
    //                               } else {
    //                                 Constants.toastMessage(
    //                                     'Please Enter Cancel Reason');
    //                               }
    //                             },
    //                             child: Text(
    //                               'Yes Cancel It',
    //                               style: TextStyle(
    //                                   fontSize: ScreenUtil().setSp(14),
    //                                   fontWeight: FontWeight.bold,
    //                                   fontFamily: Constants.appFontBold,
    //                                   color: Color(Constants.colorBlue)),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );
    Get.dialog(
      AlertDialog(
        title: Text('Switch Confirmation'),
        content: Text('Do you want to switch ${paymentType.toString()} to $payment?'),
        actions: [
          ElevatedButton(
            onPressed: () async {

              await callSwitchPaymentOrder(
                  orderId, payment, context);
            },
            child: Text('Yes'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  Future<BaseModel<commonRes.CommenPaymentSwitchRes>> callSwitchPaymentOrder(
      dynamic orderId, dynamic paymentType, BuildContext context) async {
    commonRes.CommenPaymentSwitchRes response;
    try {
      Constants.onLoading(context);
      Map<String, String> body = {
        'orderId': orderId.toString(),
        'newPaymentType': paymentType.toString(),
      };
      response = await RestClient(await RetroApi().dioData()).paymentSwitchOrder(body);
      Constants.hideDialog(context);
      // if (response.success!) {
      orderHistoryRef.value = callGetOrderHistoryList();
      Get.back();
      Constants.toastMessage(response.success!);
      print("status updated");
      // } else {
      //   Constants.toastMessage(response.data!);
      // }
    } catch (error, stacktrace) {
      Constants.hideDialog(context);
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<commonRes.CommenRes>> callCancelOrder(
      int? orderId, String cancelReason, BuildContext context) async {
    commonRes.CommenRes response;
    try {
      Constants.onLoading(context);
      Map<String, String> body = {
        'id': orderId.toString(),
        'cancel_reason': cancelReason,
      };
      response = await RestClient(await RetroApi().dioData()).cancelOrder(body);
      Constants.hideDialog(context);
      if (response.success!) {
        orderHistoryRef.value = callGetOrderHistoryList();
        _textOrderCancelReason.clear();
        // Navigator.pop(context);
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

  Future<commonRes.CommenRes> getTakeAwayValue(int id) async {
    final _data = <String, dynamic>{
      "old_takaway_id": id,
      "order_status": "COMPLETE"
    };
    return await RestClient(await RetroApi().dioData())
        .completeSpecificTakeawayOrder(_data);
  }

  Future<commonRes.CommenRes> completeOrders() async {
    final prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    String userId = prefs.getString(Constants.loginUserId.toString()) ?? '';
    final _data = <String, dynamic>{"vendor_id": vendorId, "user_id": userId};
    return await RestClient(await RetroApi().dioData())
        .completeTakeawayOrder(_data);
  }



  Widget deliveryTypeButton(
      {required void Function()? onTap,
      required String icon,
      required String title,
      required TextStyle style,
      required Color buttonColor,
      required Color color}) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
        // set the height to 50
        fixedSize: MaterialStateProperty.all<Size>(const Size(200, 50)),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            color: color,
            height: 20,
          ),
          Text(
            title,
            style: style,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    firebaseListener?.cancel();
    // _linklyDataController.timer?.cancel();
    // _linklyDataController.resetVariables();
    // _linklyDataController.showDialogvalue.value = false;
    super.dispose();
  }
}
