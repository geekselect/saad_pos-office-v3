import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controller/customer_data_controller.dart';
import 'package:pos/model/customer_data_model.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/utils/app_toolbar_with_btn_clr.dart';
import 'package:pos/utils/constants.dart';

class CustomerDataScreen extends StatelessWidget {
  var customerDataController = Get.put(CustomerDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolbarWithClrBtn(
        appbarTitle: 'Customer Data',
        // str_button_title: Languages.of(context).labelClearList,
        strButtonTitle: "",
        btnColor: Color(Constants.colorLike),
        onBtnPress: () {},
      ),
      body: FutureBuilder<BaseModel<CustomerDataModel>>(
        future: customerDataController.customerDataApiCall(11, 245),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // show a CircularProgressIndicator while data is being fetched
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            // return ListView.builder(
            //   padding: EdgeInsets.only(bottom: 100, left: 10, right: 10),
            //   scrollDirection: Axis.vertical,
            //   itemCount: _getFilteredOrders().length,
            //   itemBuilder: (BuildContext context, int index) {
            //     // build the list item here
            //     final order = _getFilteredOrders()[index];
            //     print("order...${order.toJson()}");
            //     // print("order data ${order.toJson()}");
            //     // print("order.orderStatus ${order.orderStatus}");
            //     return Column(
            //       crossAxisAlignment: CrossAxisAlignment.stretch,
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.only(top: 10, right: 10),
            //           child: Text(
            //             (() {
            //                   if (order.addressId != null) {
            //                     if (order.orderStatus == 'PENDING') {
            //                       return '${'Ordered On'} ${order.date}, ${order.time}';
            //                     } else if (order.orderStatus == 'ACCEPT') {
            //                       return '${'Accepted On'} ${order.date}, ${order.time}';
            //                     } else if (order.orderStatus == 'APPROVE') {
            //                       return '${'Approve On'} ${order.date}, ${order.time}';
            //                     } else if (order.orderStatus == 'REJECT') {
            //                       return '${'Rejected On'} ${order.date}, ${order.time}';
            //                     } else if (order.orderStatus == 'PICKUP') {
            //                       return '${'Pickedup On'} ${order.date}, ${order.time}';
            //                     } else if (order.orderStatus == 'DELIVERED') {
            //                       return '${'Delivered On'} ${order.date}, ${order.time}';
            //                     } else if (order.orderStatus == 'CANCEL') {
            //                       return 'Canceled On ${order.date}, ${order.time}';
            //                     } else if (order.orderStatus == 'COMPLETE') {
            //                       return 'Delivered On ${order.date}, ${order.time}';
            //                     }
            //                   } else {
            //                     if (order.orderStatus == 'PENDING') {
            //                       return 'Ordered On ${order.date}, ${order.time}';
            //                     } else if (order.orderStatus == 'ACCEPT') {
            //                       return 'Accepted On ${order.date}, ${order.time}';
            //                     } else if (order.orderStatus == 'APPROVE') {
            //                       return 'Approve On ${order.date}, ${order.time}';
            //                     } else if (order.orderStatus == 'REJECT') {
            //                       return 'Rejected On ${order.date}, ${order.time}';
            //                     } else if (order.orderStatus ==
            //                         'PREPARE_FOR_ORDER') {
            //                       return 'PREPARE FOR ORDER ${order.date}, ${order.time}';
            //                     } else if (order.orderStatus ==
            //                         'READY_FOR_ORDER') {
            //                       return 'READY FOR ORDER ${order.date}, ${order.time}';
            //                     } else if (order.orderStatus == 'CANCEL') {
            //                       return 'Canceled On ${order.date}, ${order.time}';
            //                     } else if (order.orderStatus == 'COMPLETE') {
            //                       return 'Delivered On ${order.date}, ${order.time}';
            //                     }
            //                   }
            //                 }()) ??
            //                 '',
            //             style: TextStyle(
            //                 color: Color(Constants.colorGray),
            //                 fontFamily: Constants.appFont,
            //                 fontSize: 12),
            //             textAlign: TextAlign.end,
            //           ),
            //         ),
            //         GestureDetector(
            //           onTap: () {
            //             print(" orderData is .. ${order.deliveryType}");
            //             // // Constants.toastMessage(_orderHistoryController.listOrderHistory[index].id.toString());
            //             // Navigator.of(context).push(
            //             //     Transitions(
            //             //         transitionType:
            //             //         TransitionType.fade,
            //             //         curve:
            //             //         Curves.bounceInOut,
            //             //         reverseCurve: Curves
            //             //             .fastLinearToSlowEaseIn,
            //             //         widget:
            //             //         OrderDetailsScreen(
            //             //           orderId:
            //             //           _orderHistoryController.listOrderHistory[
            //             //           index]
            //             //               .id,
            //             //           orderDate:
            //             //           _orderHistoryController.listOrderHistory[
            //             //           index]
            //             //               .date,
            //             //           orderTime:
            //             //           _orderHistoryController.listOrderHistory[
            //             //           index]
            //             //               .time,
            //             //         )));
            //           },
            //           child: Card(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(20.0),
            //             ),
            //             margin: EdgeInsets.only(
            //                 top: 20, left: 16, right: 16, bottom: 20),
            //             child: Column(
            //               children: [
            //                 // (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' || _orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE')?
            //                 //
            //                 // GestureDetector(
            //                 //   onTap: (){
            //                 //     showCancelOrderDialog(_orderHistoryController.listOrderHistory[index].id);
            //                 //   },
            //                 //   child: Padding(
            //                 //     padding: const EdgeInsets
            //                 //         .only(
            //                 //         top: 10,
            //                 //         right:
            //                 //         20),
            //                 //     child:
            //                 //     RichText(
            //                 //       text:
            //                 //       TextSpan(
            //                 //         children: [
            //                 //           WidgetSpan(
            //                 //             child:
            //                 //             Padding(
            //                 //               padding: const EdgeInsets.only(right: 5),
            //                 //               child: SvgPicture.asset('images/ic_cancel.svg',
            //                 //
            //                 //                 //  color: Color(Constants.colorTheme),
            //                 //                 width: 15,
            //                 //                 height: ScreenUtil().setHeight(15),
            //                 //               ),
            //                 //             ),
            //                 //           ),
            //                 //           TextSpan(
            //                 //               text: 'Cancel this order',
            //                 //               style: TextStyle(
            //                 //                   color: Color(Constants.colorLike),
            //                 //                   fontFamily: Constants.appFont,
            //                 //                   fontSize: 12)),
            //                 //         ],
            //                 //       ),
            //                 //     ),
            //                 //   ),
            //                 // ):Container(),
            //                 Row(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     // Padding(
            //                     //   padding:
            //                     //   const EdgeInsets
            //                     //       .all(5.0),
            //                     //   child: ClipRRect(
            //                     //     borderRadius:
            //                     //     BorderRadius
            //                     //         .circular(
            //                     //         15.0),
            //                     //     child: CachedNetworkImage(
            //                     //       height:
            //                     //       100,
            //                     //       width:
            //                     //       100,
            //                     //       imageUrl:
            //                     //       _orderHistoryController.listOrderHistory[
            //                     //       index]
            //                     //           .vendor!
            //                     //           .image!,
            //                     //       fit: BoxFit.cover,
            //                     //       placeholder: (context,
            //                     //           url) =>
            //                     //           SpinKitFadingCircle(
            //                     //               color: Color(
            //                     //                   Constants
            //                     //                       .colorTheme)),
            //                     //       errorWidget:
            //                     //           (context, url,
            //                     //           error) =>
            //                     //           Container(
            //                     //             child: Center(
            //                     //                 child: Image.asset('images/noimage.png')),
            //                     //           ),
            //                     //     ),
            //                     //   ),
            //                     // ),
            //                     Expanded(
            //                       child: Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Padding(
            //                             padding: const EdgeInsets.only(
            //                                 left: 10, top: 10),
            //                             child: Row(
            //                               mainAxisAlignment:
            //                                   MainAxisAlignment.spaceBetween,
            //                               children: [
            //                                 Expanded(
            //                                   child: Text(
            //                                     "Order ${order.order_id.toString()} | ${order.user!.name} | ${order.vendor!.name!} | ${order.payment_type.toString()} | ${order.deliveryType} | ${order.user!.name} | ${order.user_name != null ? order.user_name : ''} | ${order.mobile != null ? order.mobile : ""}",
            //                                     style: TextStyle(
            //                                       fontFamily:
            //                                           Constants.appFontBold,
            //                                       fontSize: 12,
            //                                       color: Color(
            //                                           Constants.colorGray),
            //                                     ),
            //                                   ),
            //                                 ),
            //                                 IconButton(
            //                                   onPressed: () {
            //                                     // if (_printerController
            //                                     //         .printerModel
            //                                     //         .value
            //                                     //         .ipPos! !=
            //                                     //     null) {
            //                                     //   print(_printerController
            //                                     //       .printerModel
            //                                     //       .value
            //                                     //       .ipPos!);
            //                                     //   print(_printerController
            //                                     //       .printerModel
            //                                     //       .value
            //                                     //       .portPos);
            //                                     // }
            //
            //                                     if (_printerController
            //                                             .printerModel
            //                                             .value
            //                                             .ipPos !=
            //                                         null) {
            //                                       testPrintPOS(
            //                                           _printerController
            //                                               .printerModel
            //                                               .value
            //                                               .ipPos!,
            //                                           int.parse(
            //                                               _printerController
            //                                                   .printerModel
            //                                                   .value
            //                                                   .portPos
            //                                                   .toString()),
            //                                           context,
            //                                           order);
            //                                     } else {
            //                                       Get.snackbar("Error",
            //                                           "Please add printer ip and port");
            //                                     }
            //                                   },
            //                                   icon: Icon(Icons.print),
            //                                 )
            //                               ],
            //                             ),
            //
            //                             // child: Row(
            //                             //   children: [
            //                             //     // Expanded(
            //                             //     //   flex: 4,
            //                             //     //   child:
            //                             //     //   Padding(
            //                             //     //     padding: const EdgeInsets
            //                             //     //         .only(
            //                             //     //         left:
            //                             //     //         10,
            //                             //     //         top:
            //                             //     //         10),
            //                             //     //     child: Text(
            //                             //     //       "Order # ${_orderHistoryController.listOrderHistory[index].id.toString()}",
            //                             //     //       style: TextStyle(
            //                             //     //           fontFamily:
            //                             //     //           Constants.appFontBold,
            //                             //     //           fontSize: 16),
            //                             //     //     ),
            //                             //     //     // Text(
            //                             //     //     //   _orderHistoryController.listOrderHistory[index]
            //                             //     //     //       .vendor!
            //                             //     //     //       .name!,
            //                             //     //     //   style: TextStyle(
            //                             //     //     //       fontFamily:
            //                             //     //     //       Constants.appFontBold,
            //                             //     //     //       fontSize: 16),
            //                             //     //     // ),
            //                             //     //   ),
            //                             //     // ),
            //                             //     Text(
            //                             //       "Order # ${_orderHistoryController.listOrderHistory[index].id.toString()} | ${_orderHistoryController.listOrderHistory[index].user!.name}",
            //                             //       style: TextStyle(
            //                             //           fontFamily:
            //                             //           Constants.appFontBold,
            //                             //           fontSize: 12,
            //                             //       color: Color(Constants.colorGray),
            //                             //       ),
            //                             //     ),
            //                             //     Text(
            //                             //       ,
            //                             //       style: TextStyle(
            //                             //           fontFamily:
            //                             //           Constants.appFontBold,
            //                             //           fontSize: 12,
            //                             //         color: Color(Constants.colorGray),
            //                             //       ),
            //                             //     ),
            //                             //   ],
            //                             // ),
            //                           ),
            //                           // Padding(
            //                           //   padding:
            //                           //   const EdgeInsets
            //                           //       .only(
            //                           //       top: 3,
            //                           //       left:
            //                           //       10,
            //                           //       right:
            //                           //       5),
            //                           //   child: Text(
            //                           //    _orderHistoryController.listOrderHistory[index].user!.name,
            //                           //     style: TextStyle(
            //                           //         fontFamily:
            //                           //         Constants.appFontBold,
            //                           //         fontSize: 12),
            //                           //   ),
            //                           // ),
            //                           ///Start vendor name
            //                           // Padding(
            //                           //   padding:
            //                           //       const EdgeInsets
            //                           //               .only(
            //                           //           top: 3,
            //                           //           left: 10,
            //                           //           right: 5),
            //                           //   child: Text(
            //                           //     _orderHistoryController
            //                           //         .listOrderHistory[
            //                           //             index]
            //                           //         .vendor!
            //                           //         .name!,
            //                           //     style: TextStyle(
            //                           //         fontFamily:
            //                           //             Constants
            //                           //                 .appFontBold,
            //                           //         fontSize: 10),
            //                           //   ),
            //                           // ),
            //                           ///End vendor Name
            //                           // Padding(
            //                           //   padding:
            //                           //   const EdgeInsets
            //                           //       .only(
            //                           //       top: 3,
            //                           //       left:
            //                           //       10,
            //                           //       right:
            //                           //       5),
            //                           //   child: Text(
            //                           //     _orderHistoryController.listOrderHistory[
            //                           //     index]
            //                           //         .vendor!
            //                           //         .mapAddress ?? '',
            //                           //     overflow:
            //                           //     TextOverflow
            //                           //         .ellipsis,
            //                           //     style: TextStyle(
            //                           //         fontFamily:
            //                           //         Constants
            //                           //             .appFont,
            //                           //         color: Color(
            //                           //             Constants
            //                           //                 .colorGray),
            //                           //         fontSize:
            //                           //         13),
            //                           //   ),
            //                           // ),
            //                           order.tableNo == 0
            //                               ? SizedBox()
            //                               : Padding(
            //                                   padding: const EdgeInsets.only(
            //                                       top: 3, left: 10, right: 5),
            //                                   child: Text(
            //                                     "Table No ${order.tableNo.toString()}" ??
            //                                         '',
            //                                     overflow: TextOverflow.ellipsis,
            //                                     style: TextStyle(
            //                                         fontFamily:
            //                                             Constants.appFontBold,
            //                                         fontSize: 16),
            //                                   ),
            //                                 ),
            //                           SizedBox(
            //                             height: ScreenUtil().setHeight(5),
            //                           ),
            //                           ListView.builder(
            //                               padding: EdgeInsets.zero,
            //                               physics: ClampingScrollPhysics(),
            //                               shrinkWrap: true,
            //                               scrollDirection: Axis.vertical,
            //                               itemCount: order.orderItems!.length,
            //                               itemBuilder: (BuildContext context,
            //                                   int innerindex) {
            //                                 print(
            //                                     "order Items..${order.orderItems![innerindex].toJson()}");
            //                                 return Padding(
            //                                   padding:
            //                                       const EdgeInsets.symmetric(
            //                                           horizontal: 10,
            //                                           vertical: 1),
            //                                   child: Column(
            //                                     children: [
            //                                       Row(
            //                                         mainAxisAlignment:
            //                                             MainAxisAlignment
            //                                                 .spaceBetween,
            //                                         children: [
            //                                           Row(
            //                                             children: [
            //                                               Text(
            //                                                 order
            //                                                     .orderItems![
            //                                                         innerindex]
            //                                                     .itemName
            //                                                     .toString(),
            //                                                 style: TextStyle(
            //                                                     fontFamily:
            //                                                         Constants
            //                                                             .appFont,
            //                                                     fontSize: 12),
            //                                               ),
            //                                               Padding(
            //                                                 padding:
            //                                                     const EdgeInsets
            //                                                             .only(
            //                                                         left: 5),
            //                                                 child: Text(
            //                                                     (() {
            //                                                       String qty =
            //                                                           '';
            //                                                       if (order.orderItems!
            //                                                                   .length >
            //                                                               0 &&
            //                                                           order.orderItems !=
            //                                                               null) {
            //                                                         // for (int i = 0; i < _orderHistoryController.listOrderHistory[index].orderItems.length; i++) {
            //                                                         qty =
            //                                                             ' X ${order.orderItems![innerindex].qty.toString()}';
            //                                                         // }
            //                                                         return qty;
            //                                                       } else {
            //                                                         return '';
            //                                                       }
            //                                                     }()),
            //                                                     style: TextStyle(
            //                                                         color: Color(
            //                                                             Constants
            //                                                                 .colorTheme),
            //                                                         fontFamily:
            //                                                             Constants
            //                                                                 .appFont,
            //                                                         fontSize:
            //                                                             12)),
            //                                               ),
            //                                             ],
            //                                           ),
            //                                           Text(order
            //                                               .orderItems![
            //                                                   innerindex]
            //                                               .price
            //                                               .toString())
            //                                         ],
            //                                       ),
            //                                       // order.addons!
            //                                       //             .isEmpty ||
            //                                       //         order.addons! ==
            //                                       //             null
            //                                       //     ? Container()
            //                                       //     : Container(
            //                                       //         height: 40,
            //                                       //         child: ListView.builder(
            //                                       //             // the number of items in the list
            //                                       //             itemCount: order.addons!.length,
            //                                       //             // display each item of the product list
            //                                       //             itemBuilder: (context, addonsIndex) {
            //                                       //               return Text(order
            //                                       //                   .addons![addonsIndex]
            //                                       //                   .toString());
            //                                       //             }),
            //                                       //       )
            //                                     ],
            //                                   ),
            //                                 );
            //                               }),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.only(
            //                       left: 5, right: 5, top: 10),
            //                   child: DottedLine(
            //                     dashColor: Color(0xffcccccc),
            //                   ),
            //                 ),
            //                 Row(
            //                   children: [
            //                     Expanded(
            //                         flex: 5,
            //                         child: Column(
            //                           crossAxisAlignment:
            //                               CrossAxisAlignment.stretch,
            //                           children: [
            //                             SizedBox(
            //                               height: 5,
            //                             ),
            //                             Padding(
            //                               padding: const EdgeInsets.symmetric(
            //                                   horizontal: 10),
            //                               child: Row(
            //                                 mainAxisAlignment:
            //                                     MainAxisAlignment.spaceBetween,
            //                                 children: [
            //                                   RichText(
            //                                     text: TextSpan(
            //                                         text:
            //                                             'Total Amount : ${AuthController.sharedPreferences?.getString(Constants.appSettingCurrencySymbol) ?? ''}${order.amount} ',
            //                                         style: TextStyle(
            //                                             color: Colors.black,
            //                                             fontFamily:
            //                                                 Constants.appFont,
            //                                             fontSize: 14),
            //                                         children: <TextSpan>[
            //                                           TextSpan(
            //                                             text: order
            //                                                             .payment_type ==
            //                                                         "POS CASH" ||
            //                                                     order.payment_type ==
            //                                                         "POS CARD" ||
            //                                                     order.payment_type ==
            //                                                         "POS CASH TAKEAWAY" ||
            //                                                     order.payment_type ==
            //                                                         "POS CARD TAKEAWAY"
            //                                                 ? '( Paid )'
            //                                                 : '( Unpaid )',
            //                                             style: TextStyle(
            //                                                 color: Colors
            //                                                     .red.shade500,
            //                                                 fontFamily:
            //                                                     Constants
            //                                                         .appFont,
            //                                                 fontSize: 16),
            //                                           )
            //                                         ]),
            //                                   ),
            //                                   RichText(
            //                                     text: TextSpan(
            //                                       children: [
            //                                         WidgetSpan(
            //                                           child: Padding(
            //                                             padding:
            //                                                 const EdgeInsets
            //                                                     .only(right: 5),
            //                                             child: SvgPicture.asset(
            //                                               (() {
            //                                                     if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .addressId !=
            //                                                         null) {
            //                                                       if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'PENDING') {
            //                                                         return 'images/ic_pending.svg';
            //                                                       } else if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'APPROVE') {
            //                                                         return 'images/ic_accept.svg';
            //                                                       } else if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'ACCEPT') {
            //                                                         return 'images/ic_accept.svg';
            //                                                       } else if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'REJECT') {
            //                                                         return 'images/ic_cancel.svg';
            //                                                       } else if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'PICKUP') {
            //                                                         return 'images/ic_pickup.svg';
            //                                                       } else if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'DELIVERED') {
            //                                                         return 'images/ic_completed.svg';
            //                                                       } else if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'CANCEL') {
            //                                                         return 'images/ic_cancel.svg';
            //                                                       } else if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'COMPLETE') {
            //                                                         return 'images/ic_completed.svg';
            //                                                       } else {
            //                                                         return 'images/ic_accept.svg';
            //                                                       }
            //                                                     } else {
            //                                                       if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'PENDING') {
            //                                                         return 'images/ic_pending.svg';
            //                                                       } else if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'APPROVE') {
            //                                                         return 'images/ic_accept.svg';
            //                                                       } else if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'PREPARING FOOD') {
            //                                                         return 'images/ic_pickup.svg';
            //                                                       } else if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'READY TO PICKUP') {
            //                                                         return 'images/ic_completed.svg';
            //                                                       } else if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'REJECT') {
            //                                                         return 'images/ic_cancel.svg';
            //                                                       } else if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'CANCEL') {
            //                                                         return 'images/ic_cancel.svg';
            //                                                       } else if (_orderHistoryController
            //                                                               .listOrderHistory[
            //                                                                   index]
            //                                                               .orderStatus ==
            //                                                           'COMPLETE') {
            //                                                         return 'images/ic_completed.svg';
            //                                                       }
            //                                                     }
            //                                                   }()) ??
            //                                                   '',
            //                                               color: (() {
            //                                                 // your code here
            //                                                 // _orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' ? 'Ordered on ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}' : 'Delivered on October 10,2020, 09:23pm',
            //                                                 if (_orderHistoryController
            //                                                         .listOrderHistory[
            //                                                             index]
            //                                                         .orderStatus ==
            //                                                     'PENDING') {
            //                                                   return Color(Constants
            //                                                       .colorOrderPending);
            //                                                 } else if (_orderHistoryController
            //                                                         .listOrderHistory[
            //                                                             index]
            //                                                         .orderStatus ==
            //                                                     'ACCEPT') {
            //                                                   return Color(
            //                                                       Constants
            //                                                           .colorBlack);
            //                                                 } else if (_orderHistoryController
            //                                                         .listOrderHistory[
            //                                                             index]
            //                                                         .orderStatus ==
            //                                                     'PICKUP') {
            //                                                   return Color(Constants
            //                                                       .colorOrderPickup);
            //                                                 }
            //                                               }()),
            //                                               width: 15,
            //                                               height: ScreenUtil()
            //                                                   .setHeight(15),
            //                                             ),
            //                                           ),
            //                                         ),
            //                                         TextSpan(
            //                                             text: (() {
            //                                               if (_orderHistoryController
            //                                                       .listOrderHistory[
            //                                                           index]
            //                                                       .deliveryType ==
            //                                                   'TAKEAWAY') {
            //                                                 if (_orderHistoryController
            //                                                         .listOrderHistory[
            //                                                             index]
            //                                                         .orderStatus ==
            //                                                     'READY TO PICKUP') {
            //                                                   return 'Waiting For User To Pickup';
            //                                                 }
            //                                               } else {
            //                                                 if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'READY TO PICKUP' ||
            //                                                     _orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'ACCEPT') {
            //                                                   return 'Waiting For Driver To Pickup';
            //                                                 }
            //                                               }
            //                                               return _orderHistoryController
            //                                                   .listOrderHistory[
            //                                                       index]
            //                                                   .orderStatus;
            //                                               // if (_orderHistoryController.listOrderHistory[index].addressId != null) {
            //                                               //
            //                                               //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
            //                                               //     return Languages.of(context)!.labelOrderPending;
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
            //                                               //     return Languages.of(context)!.labelOrderAccepted;
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
            //                                               //     return Languages.of(context)!.labelOrderAccepted;
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
            //                                               //     return Languages.of(context)!.labelOrderRejected;
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
            //                                               //     return 'PREPARING FOOD';
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
            //                                               //     return 'READY TO PICKUP';
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
            //                                               //     return Languages.of(context)!.labelOrderPickedUp;
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
            //                                               //     return Languages.of(context)!.labelDeliveredSuccess;
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
            //                                               //     return Languages.of(context)!.labelOrderCanceled;
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
            //                                               //     return Languages.of(context)!.labelOrderCompleted;
            //                                               //   }
            //                                               // } else {
            //                                               //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
            //                                               //     return Languages.of(context)!.labelOrderPending;
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
            //                                               //     return Languages.of(context)!.labelOrderAccepted;
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
            //                                               //     return Languages.of(context)!.labelOrderAccepted;
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
            //                                               //     return 'PREPARING FOOD';
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
            //                                               //     return 'READY TO PICKUP';
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
            //                                               //     return Languages.of(context)!.labelOrderRejected;
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
            //                                               //     return Languages.of(context)!.labelOrderCompleted;
            //                                               //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
            //                                               //     return Languages.of(context)!.labelOrderCanceled;
            //                                               //   }
            //                                               // }
            //                                             }()),
            //                                             style: TextStyle(
            //                                                 color: (() {
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
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorOrderPending);
            //                                                     } else if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'APPROVE') {
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorBlack);
            //                                                     } else if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'ACCEPT') {
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorBlack);
            //                                                     } else if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'REJECT') {
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorLike);
            //                                                     } else if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'PICKUP') {
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorOrderPickup);
            //                                                     } else if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'DELIVERED') {
            //                                                       // return Color(0xffffffff);
            //
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorTheme);
            //                                                     } else if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'CANCEL') {
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorTheme);
            //                                                       // return Color(0xffffffff);
            //                                                     } else if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'COMPLETE') {
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorTheme);
            //                                                       // return Color(0xffffffff);
            //                                                     } else {
            //                                                       // return Color(0xffffffff);
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorTheme);
            //                                                     }
            //                                                   } else {
            //                                                     if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'PENDING') {
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorOrderPending);
            //                                                     } else if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'APPROVE') {
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorBlack);
            //                                                     } else if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'ACCEPT') {
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorBlack);
            //                                                     } else if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'REJECT') {
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorLike);
            //                                                     } else if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'PREPARING FOOD') {
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorOrderPickup);
            //                                                     } else if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'READY TO PICKUP') {
            //                                                       // return Color(0xffffffff);
            //
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorTheme);
            //                                                     } else if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'CANCEL') {
            //                                                       // return Color(0xffffffff);
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorTheme);
            //                                                     } else if (_orderHistoryController
            //                                                             .listOrderHistory[
            //                                                                 index]
            //                                                             .orderStatus ==
            //                                                         'COMPLETE') {
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorTheme);
            //                                                       // return Color(0xffffffff);
            //                                                     } else {
            //                                                       // return Color(0xffffffff);
            //                                                       return Color(
            //                                                           Constants
            //                                                               .colorTheme);
            //                                                     }
            //                                                   }
            //                                                 }()),
            //                                                 fontFamily:
            //                                                     Constants
            //                                                         .appFont,
            //                                                 fontSize: 12)),
            //                                       ],
            //                                     ),
            //                                   )
            //                                 ],
            //                               ),
            //                             ),
            //                             SizedBox(
            //                               height: 5,
            //                             ),
            //                             // Row(
            //                             //   mainAxisAlignment:
            //                             //       MainAxisAlignment
            //                             //           .center,
            //                             //   children: [
            //                             //     Text(
            //                             //       order.payment_type ==
            //                             //                   "POS CASH" ||
            //                             //               order.payment_type ==
            //                             //                   "POS CARD" ||
            //                             //               order.payment_type ==
            //                             //                   "POS CASH TAKEAWAY" ||
            //                             //               order.payment_type ==
            //                             //                   "POS CARD TAKEAWAY"
            //                             //           ? '( Paid )'
            //                             //           : '( Unpaid )',
            //                             //       style: TextStyle(
            //                             //           color: Colors
            //                             //               .red.shade500,
            //                             //           // fontWeight: FontWeight.bold,
            //                             //           fontFamily:
            //                             //               Constants
            //                             //                   .appFont,
            //                             //           fontSize: 18),
            //                             //     ),
            //                             //     // Expanded(
            //                             //     //   child: Padding(
            //                             //     //     padding:
            //                             //     //     const EdgeInsets
            //                             //     //         .only(
            //                             //     //         left: 10,
            //                             //     //         top: 10),
            //                             //     //     child: RichText(
            //                             //     //       text: TextSpan(
            //                             //     //         // text: order.amount,
            //                             //     //           text: AuthController
            //                             //     //               .sharedPreferences
            //                             //     //               ?.getString(
            //                             //     //               Constants
            //                             //     //                   .appSettingCurrencySymbol) ??
            //                             //     //               '' +
            //                             //     //                   '${order.amount} ',
            //                             //     //           style: TextStyle(
            //                             //     //               color: Colors.black,
            //                             //     //               fontFamily:
            //                             //     //               Constants
            //                             //     //                   .appFont,
            //                             //     //               fontSize:
            //                             //     //               14),
            //                             //     //           children: <
            //                             //     //               TextSpan>[
            //                             //     //             TextSpan(
            //                             //     //               text:
            //                             //     //               order.payment_type == "POS CASH" || order.payment_type == "POS CARD" ?  '( Payment Completed )' : '( Payment Incomplete )',
            //                             //     //               style: TextStyle(
            //                             //     //                   color: Colors.red.shade500,
            //                             //     //                   // fontWeight: FontWeight.bold,
            //                             //     //                   fontFamily:
            //                             //     //                   Constants
            //                             //     //                       .appFont,
            //                             //     //                   fontSize:
            //                             //     //                   14),
            //                             //     //             )
            //                             //     //           ]),
            //                             //     //     ),
            //                             //     //     // child: Text(
            //                             //     //     //   AuthController
            //                             //     //     //       .sharedPreferences
            //                             //     //     //       ?.getString(Constants
            //                             //     //     //       .appSettingCurrencySymbol) ??
            //                             //     //     //       '' +
            //                             //     //     //           '${order.amount}',
            //                             //     //     //   style: TextStyle(
            //                             //     //     //       fontFamily:
            //                             //     //     //       Constants
            //                             //     //     //           .appFont,
            //                             //     //     //       fontSize:
            //                             //     //     //       14),
            //                             //     //     // ),
            //                             //     //   ),
            //                             //     // ),
            //                             //     SizedBox(
            //                             //       width: 5,
            //                             //     ),
            //                             //     Padding(
            //                             //       padding:
            //                             //           const EdgeInsets
            //                             //                   .only(
            //                             //               // top: 10,
            //                             //               right: 20),
            //                             //       child: RichText(
            //                             //         text: TextSpan(
            //                             //           children: [
            //                             //             WidgetSpan(
            //                             //               child: Padding(
            //                             //                 padding: const EdgeInsets
            //                             //                         .only(
            //                             //                     right: 5),
            //                             //                 child:
            //                             //                     SvgPicture
            //                             //                         .asset(
            //                             //                   (() {
            //                             //                         if (_orderHistoryController.listOrderHistory[index].addressId !=
            //                             //                             null) {
            //                             //                           if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'PENDING') {
            //                             //                             return 'images/ic_pending.svg';
            //                             //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'APPROVE') {
            //                             //                             return 'images/ic_accept.svg';
            //                             //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'ACCEPT') {
            //                             //                             return 'images/ic_accept.svg';
            //                             //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'REJECT') {
            //                             //                             return 'images/ic_cancel.svg';
            //                             //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'PICKUP') {
            //                             //                             return 'images/ic_pickup.svg';
            //                             //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'DELIVERED') {
            //                             //                             return 'images/ic_completed.svg';
            //                             //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'CANCEL') {
            //                             //                             return 'images/ic_cancel.svg';
            //                             //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'COMPLETE') {
            //                             //                             return 'images/ic_completed.svg';
            //                             //                           } else {
            //                             //                             return 'images/ic_accept.svg';
            //                             //                           }
            //                             //                         } else {
            //                             //                           if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'PENDING') {
            //                             //                             return 'images/ic_pending.svg';
            //                             //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'APPROVE') {
            //                             //                             return 'images/ic_accept.svg';
            //                             //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'PREPARING FOOD') {
            //                             //                             return 'images/ic_pickup.svg';
            //                             //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'READY TO PICKUP') {
            //                             //                             return 'images/ic_completed.svg';
            //                             //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'REJECT') {
            //                             //                             return 'images/ic_cancel.svg';
            //                             //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'CANCEL') {
            //                             //                             return 'images/ic_cancel.svg';
            //                             //                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                               'COMPLETE') {
            //                             //                             return 'images/ic_completed.svg';
            //                             //                           }
            //                             //                         }
            //                             //                       }()) ??
            //                             //                       '',
            //                             //                   color: (() {
            //                             //                     // your code here
            //                             //                     // _orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' ? 'Ordered on ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}' : 'Delivered on October 10,2020, 09:23pm',
            //                             //                     if (_orderHistoryController
            //                             //                             .listOrderHistory[
            //                             //                                 index]
            //                             //                             .orderStatus ==
            //                             //                         'PENDING') {
            //                             //                       return Color(
            //                             //                           Constants.colorOrderPending);
            //                             //                     } else if (_orderHistoryController
            //                             //                             .listOrderHistory[
            //                             //                                 index]
            //                             //                             .orderStatus ==
            //                             //                         'ACCEPT') {
            //                             //                       return Color(
            //                             //                           Constants.colorBlack);
            //                             //                     } else if (_orderHistoryController
            //                             //                             .listOrderHistory[index]
            //                             //                             .orderStatus ==
            //                             //                         'PICKUP') {
            //                             //                       return Color(
            //                             //                           Constants.colorOrderPickup);
            //                             //                     }
            //                             //                   }()),
            //                             //                   width: 15,
            //                             //                   height: ScreenUtil()
            //                             //                       .setHeight(
            //                             //                           15),
            //                             //                 ),
            //                             //               ),
            //                             //             ),
            //                             //             TextSpan(
            //                             //                 text: (() {
            //                             //                   if (_orderHistoryController
            //                             //                           .listOrderHistory[index]
            //                             //                           .deliveryType ==
            //                             //                       'TAKEAWAY') {
            //                             //                     if (_orderHistoryController
            //                             //                             .listOrderHistory[index]
            //                             //                             .orderStatus ==
            //                             //                         'READY TO PICKUP') {
            //                             //                       return 'Waiting For User To Pickup';
            //                             //                     }
            //                             //                   } else {
            //                             //                     if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'READY TO PICKUP' ||
            //                             //                         _orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'ACCEPT') {
            //                             //                       return 'Waiting For Driver To Pickup';
            //                             //                     }
            //                             //                   }
            //                             //                   return _orderHistoryController
            //                             //                       .listOrderHistory[
            //                             //                           index]
            //                             //                       .orderStatus;
            //                             //                   // if (_orderHistoryController.listOrderHistory[index].addressId != null) {
            //                             //                   //
            //                             //                   //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
            //                             //                   //     return Languages.of(context)!.labelOrderPending;
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
            //                             //                   //     return Languages.of(context)!.labelOrderAccepted;
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
            //                             //                   //     return Languages.of(context)!.labelOrderAccepted;
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
            //                             //                   //     return Languages.of(context)!.labelOrderRejected;
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
            //                             //                   //     return 'PREPARING FOOD';
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
            //                             //                   //     return 'READY TO PICKUP';
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
            //                             //                   //     return Languages.of(context)!.labelOrderPickedUp;
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
            //                             //                   //     return Languages.of(context)!.labelDeliveredSuccess;
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
            //                             //                   //     return Languages.of(context)!.labelOrderCanceled;
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
            //                             //                   //     return Languages.of(context)!.labelOrderCompleted;
            //                             //                   //   }
            //                             //                   // } else {
            //                             //                   //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
            //                             //                   //     return Languages.of(context)!.labelOrderPending;
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
            //                             //                   //     return Languages.of(context)!.labelOrderAccepted;
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
            //                             //                   //     return Languages.of(context)!.labelOrderAccepted;
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
            //                             //                   //     return 'PREPARING FOOD';
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
            //                             //                   //     return 'READY TO PICKUP';
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
            //                             //                   //     return Languages.of(context)!.labelOrderRejected;
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
            //                             //                   //     return Languages.of(context)!.labelOrderCompleted;
            //                             //                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
            //                             //                   //     return Languages.of(context)!.labelOrderCanceled;
            //                             //                   //   }
            //                             //                   // }
            //                             //                 }()),
            //                             //                 style: TextStyle(
            //                             //                     color: (() {
            //                             //                       if (_orderHistoryController.listOrderHistory[index].addressId !=
            //                             //                           null) {
            //                             //                         if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'PENDING') {
            //                             //                           return Color(Constants.colorOrderPending);
            //                             //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'APPROVE') {
            //                             //                           return Color(Constants.colorBlack);
            //                             //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'ACCEPT') {
            //                             //                           return Color(Constants.colorBlack);
            //                             //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'REJECT') {
            //                             //                           return Color(Constants.colorLike);
            //                             //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'PICKUP') {
            //                             //                           return Color(Constants.colorOrderPickup);
            //                             //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'DELIVERED') {
            //                             //                           return Color(0xffffffff);
            //                             //
            //                             //                           // return Color(Constants.colorTheme);
            //                             //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'CANCEL') {
            //                             //                           return Color(0xffffffff);
            //                             //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'COMPLETE') {
            //                             //                           // return Color(Constants.colorTheme);
            //                             //                           return Color(0xffffffff);
            //                             //                         } else {
            //                             //                           return Color(0xffffffff);
            //                             //                           // return Color(Constants.colorTheme);
            //                             //                         }
            //                             //                       } else {
            //                             //                         if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'PENDING') {
            //                             //                           return Color(Constants.colorOrderPending);
            //                             //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'APPROVE') {
            //                             //                           return Color(Constants.colorBlack);
            //                             //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'ACCEPT') {
            //                             //                           return Color(Constants.colorBlack);
            //                             //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'REJECT') {
            //                             //                           return Color(Constants.colorLike);
            //                             //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'PREPARING FOOD') {
            //                             //                           return Color(Constants.colorOrderPickup);
            //                             //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'READY TO PICKUP') {
            //                             //                           return Color(0xffffffff);
            //                             //
            //                             //                           // return Color(Constants.colorTheme);
            //                             //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'CANCEL') {
            //                             //                           return Color(0xffffffff);
            //                             //                         } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
            //                             //                             'COMPLETE') {
            //                             //                           // return Color(Constants.colorTheme);
            //                             //                           return Color(0xffffffff);
            //                             //                         } else {
            //                             //                           return Color(0xffffffff);
            //                             //                           // return Color(Constants.colorTheme);
            //                             //                         }
            //                             //                       }
            //                             //                     }()),
            //                             //                     fontFamily: Constants.appFont,
            //                             //                     fontSize: 12)),
            //                             //           ],
            //                             //         ),
            //                             //       ),
            //                             //     )
            //                             //   ],
            //                             // ),
            //
            //                             // SizedBox(
            //                             //   height: ScreenUtil()
            //                             //       .setHeight(10),
            //                             // ),
            //                             //Order Cancel
            //                             Padding(
            //                               padding: const EdgeInsets.all(8.0),
            //                               child: constraints.maxWidth > 600
            //                                   ? Row(
            //                                       mainAxisAlignment:
            //                                           MainAxisAlignment
            //                                               .spaceBetween,
            //                                       children: [
            //                                         ///Complete this order button start
            //                                         order.orderStatus !=
            //                                                     'COMPLETE' &&
            //                                                 order.deliveryType ==
            //                                                     'TAKEAWAY' &&
            //                                                 order.deliveryType !=
            //                                                     'DINING' &&
            //                                                 (order.payment_type ==
            //                                                         'POS CASH' ||
            //                                                     order.payment_type ==
            //                                                         'POS CARD')
            //                                             ? ElevatedButton(
            //                                                 onPressed:
            //                                                     () async {
            //                                                   await getTakeAwayValue(
            //                                                           order.id!)
            //                                                       .then(
            //                                                           (value) {
            //                                                     print(
            //                                                         "value ${value.data}");
            //                                                     Get.to(() => PosMenu(
            //                                                         isDining:
            //                                                             false));
            //                                                   });
            //                                                 },
            //                                                 child: RichText(
            //                                                   textAlign:
            //                                                       TextAlign
            //                                                           .center,
            //                                                   text: TextSpan(
            //                                                     children: [
            //                                                       WidgetSpan(
            //                                                         child:
            //                                                             Padding(
            //                                                           padding: EdgeInsets.only(
            //                                                               right:
            //                                                                   ScreenUtil().setHeight(10)),
            //                                                           child: SvgPicture
            //                                                               .asset(
            //                                                             'images/ic_completed.svg',
            //                                                             width: ScreenUtil()
            //                                                                 .setWidth(20),
            //                                                             //color: Color(Constants.colorRate),
            //                                                             height:
            //                                                                 ScreenUtil().setHeight(20),
            //                                                           ),
            //                                                         ),
            //                                                       ),
            //                                                       TextSpan(
            //                                                         text:
            //                                                             'Complete this order',
            //                                                         style: TextStyle(
            //                                                             color: Colors
            //                                                                 .white,
            //                                                             fontSize:
            //                                                                 18,
            //                                                             fontFamily:
            //                                                                 Constants.appFont),
            //                                                       ),
            //                                                     ],
            //                                                   ),
            //                                                 ),
            //                                               )
            //                                             : Container(),
            //                                         SizedBox(
            //                                           width: 5,
            //                                         ),
            //
            //                                         ///Complete this order button end
            //
            //                                         ///Edit Order Button Start
            //                                         order.payment_type ==
            //                                                 "INCOMPLETE ORDER"
            //                                             ? order.orderStatus ==
            //                                                     'CANCEL'
            //                                                 ? Container()
            //                                                 : ElevatedButton(
            //                                                     onPressed: () {
            //                                                       _cartController
            //                                                               .cartMaster =
            //                                                           CartMaster
            //                                                               .fromMap(
            //                                                                   jsonDecode(order.orderData!));
            //                                                       _cartController
            //                                                               .cartMaster
            //                                                               ?.oldOrderId =
            //                                                           order.id;
            //                                                       _cartController
            //                                                               .tableNumber =
            //                                                           order
            //                                                               .tableNo!;
            //                                                       String
            //                                                           colorCode =
            //                                                           order
            //                                                               .order_id
            //                                                               .toString();
            //                                                       int colorInt =
            //                                                           int.parse(
            //                                                               colorCode
            //                                                                   .substring(1));
            //                                                       print(
            //                                                           "color int ${colorInt}");
            //                                                       SharedPreferences
            //                                                               .getInstance()
            //                                                           .then(
            //                                                               (value) {
            //                                                         value.setInt(
            //                                                             Constants
            //                                                                 .order_main_id
            //                                                                 .toString(),
            //                                                             colorInt);
            //                                                       });
            //                                                       order.deliveryType ==
            //                                                               "TAKEAWAY"
            //                                                           ? _cartController
            //                                                                   .diningValue =
            //                                                               false
            //                                                           : _cartController
            //                                                                   .diningValue =
            //                                                               true;
            //                                                       order.user_name ==
            //                                                               null
            //                                                           ? _cartController
            //                                                                   .userName =
            //                                                               ''
            //                                                           : _cartController
            //                                                                   .userName =
            //                                                               order
            //                                                                   .user_name;
            //                                                       order.mobile ==
            //                                                               null
            //                                                           ? _cartController
            //                                                                   .userMobileNumber =
            //                                                               ''
            //                                                           : _cartController
            //                                                                   .userMobileNumber =
            //                                                               order
            //                                                                   .mobile;
            //                                                       // Constants.order_main_id = order.order_id.toString()
            //                                                       print(
            //                                                           "server order id ${order.order_id.toString()}");
            //                                                       Get.to(() => PosMenu(
            //                                                           isDining:
            //                                                               _cartController
            //                                                                   .diningValue));
            //                                                     },
            //                                                     child: Text(
            //                                                       "Edit this order",
            //                                                       textAlign:
            //                                                           TextAlign
            //                                                               .center,
            //                                                       style:
            //                                                           TextStyle(
            //                                                         fontSize:
            //                                                             18,
            //                                                       ),
            //                                                     ),
            //                                                   )
            //                                             : Container(),
            //                                         SizedBox(
            //                                           width: 5,
            //                                         ),
            //
            //                                         ///End Edit Order Button
            //
            //                                         /// Cancel Order Button Start
            //                                         order.orderStatus ==
            //                                                     'PENDING' ||
            //                                                 order.orderStatus ==
            //                                                     'APPROVE'
            //                                             ? ElevatedButton(
            //                                                 // style: ElevatedButton
            //                                                 //     .styleFrom(
            //                                                 //   primary: Colors.white,
            //                                                 //   shape: RoundedRectangleBorder(
            //                                                 //       borderRadius: BorderRadius.only(
            //                                                 //           bottomLeft: Radius
            //                                                 //               .circular(
            //                                                 //                   20),
            //                                                 //           bottomRight: Radius
            //                                                 //               .circular(
            //                                                 //                   20)),
            //                                                 //       side: BorderSide
            //                                                 //           .none),
            //                                                 // ),
            //                                                 onPressed:
            //                                                     () async {
            //                                                   await showCancelOrderDialog(
            //                                                       order.id);
            //                                                   setState(() {
            //                                                     orderHistoryRef =
            //                                                         _orderHistoryController
            //                                                             .refreshOrderHistory(
            //                                                                 context);
            //                                                   });
            //                                                 },
            //                                                 child: RichText(
            //                                                   textAlign:
            //                                                       TextAlign
            //                                                           .center,
            //                                                   text: TextSpan(
            //                                                     children: [
            //                                                       WidgetSpan(
            //                                                         child:
            //                                                             Padding(
            //                                                           padding: EdgeInsets.only(
            //                                                               right:
            //                                                                   ScreenUtil().setHeight(10)),
            //                                                           child: SvgPicture
            //                                                               .asset(
            //                                                             'images/ic_cancel.svg',
            //                                                             width: ScreenUtil()
            //                                                                 .setWidth(20),
            //                                                             //color: Color(Constants.colorRate),
            //                                                             height:
            //                                                                 ScreenUtil().setHeight(20),
            //                                                           ),
            //                                                         ),
            //                                                       ),
            //                                                       TextSpan(
            //                                                         text:
            //                                                             'Cancel this order',
            //                                                         style: TextStyle(
            //                                                             color: Colors.white,
            //                                                             // color: Color(Constants
            //                                                             //     .colorLike),
            //                                                             fontSize: 18,
            //                                                             fontFamily: Constants.appFont),
            //                                                       ),
            //                                                     ],
            //                                                   ),
            //                                                 ),
            //                                               )
            //                                             // ? Column(
            //                                             //     children: [
            //                                             //       Container(
            //                                             //         // height: ScreenUtil()
            //                                             //         //     .setHeight(50),
            //                                             //         // width: double.minPositive,
            //                                             //         child:
            //                                             //             ElevatedButton(
            //                                             //           // style: ElevatedButton
            //                                             //           //     .styleFrom(
            //                                             //           //   primary: Colors.white,
            //                                             //           //   shape: RoundedRectangleBorder(
            //                                             //           //       borderRadius: BorderRadius.only(
            //                                             //           //           bottomLeft: Radius
            //                                             //           //               .circular(
            //                                             //           //                   20),
            //                                             //           //           bottomRight: Radius
            //                                             //           //               .circular(
            //                                             //           //                   20)),
            //                                             //           //       side: BorderSide
            //                                             //           //           .none),
            //                                             //           // ),
            //                                             //           onPressed:
            //                                             //               () async {
            //                                             //             await showCancelOrderDialog(
            //                                             //                 order.id);
            //                                             //             setState(
            //                                             //                 () {
            //                                             //               orderHistoryRef =
            //                                             //                   _orderHistoryController.refreshOrderHistory(context);
            //                                             //             });
            //                                             //           },
            //                                             //           child:
            //                                             //               RichText(
            //                                             //             text:
            //                                             //                 TextSpan(
            //                                             //               children: [
            //                                             //                 WidgetSpan(
            //                                             //                   child: Padding(
            //                                             //                     padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
            //                                             //                     child: SvgPicture.asset(
            //                                             //                       'images/ic_cancel.svg',
            //                                             //                       width: ScreenUtil().setWidth(20),
            //                                             //                       //color: Color(Constants.colorRate),
            //                                             //                       height: ScreenUtil().setHeight(20),
            //                                             //                     ),
            //                                             //                   ),
            //                                             //                 ),
            //                                             //                 TextSpan(
            //                                             //                   text: 'Cancel this order',
            //                                             //                   style: TextStyle(
            //                                             //                       color: Colors.white,
            //                                             //                       // color: Color(Constants
            //                                             //                       //     .colorLike),
            //                                             //                       fontSize: 18,
            //                                             //                       fontFamily: Constants.appFont),
            //                                             //                 ),
            //                                             //               ],
            //                                             //             ),
            //                                             //           ),
            //                                             //         ),
            //                                             //       ),
            //                                             //     ],
            //                                             //   )
            //                                             : Container(),
            //
            //                                         ///CAncel Order button End
            //                                       ],
            //                                     )
            //                                   : Row(
            //                                       mainAxisAlignment:
            //                                           MainAxisAlignment
            //                                               .spaceBetween,
            //                                       children: [
            //                                         ///Complete this order button start
            //                                         order.orderStatus !=
            //                                                     'COMPLETE' &&
            //                                                 order.deliveryType ==
            //                                                     'TAKEAWAY' &&
            //                                                 order.deliveryType !=
            //                                                     'DINING' &&
            //                                                 (order.payment_type ==
            //                                                         'POS CASH' ||
            //                                                     order.payment_type ==
            //                                                         'POS CARD')
            //                                             ? Expanded(
            //                                                 child:
            //                                                     ElevatedButton(
            //                                                   onPressed:
            //                                                       () async {
            //                                                     await getTakeAwayValue(
            //                                                             order
            //                                                                 .id!)
            //                                                         .then(
            //                                                             (value) {
            //                                                       print(
            //                                                           "value ${value.data}");
            //                                                       Get.to(() => PosMenu(
            //                                                           isDining:
            //                                                               false));
            //                                                     });
            //                                                   },
            //                                                   child: RichText(
            //                                                     textAlign:
            //                                                         TextAlign
            //                                                             .center,
            //                                                     text: TextSpan(
            //                                                       children: [
            //                                                         WidgetSpan(
            //                                                           child:
            //                                                               Padding(
            //                                                             padding:
            //                                                                 EdgeInsets.only(right: ScreenUtil().setHeight(10)),
            //                                                             child: SvgPicture
            //                                                                 .asset(
            //                                                               'images/ic_completed.svg',
            //                                                               width:
            //                                                                   ScreenUtil().setWidth(20),
            //                                                               //color: Color(Constants.colorRate),
            //                                                               height:
            //                                                                   ScreenUtil().setHeight(20),
            //                                                             ),
            //                                                           ),
            //                                                         ),
            //                                                         TextSpan(
            //                                                           text:
            //                                                               'Complete this order',
            //                                                           style: TextStyle(
            //                                                               color: Colors
            //                                                                   .white,
            //                                                               fontSize:
            //                                                                   18,
            //                                                               fontFamily:
            //                                                                   Constants.appFont),
            //                                                         ),
            //                                                       ],
            //                                                     ),
            //                                                   ),
            //                                                 ),
            //                                               )
            //                                             : Container(),
            //                                         SizedBox(
            //                                           width: 5,
            //                                         ),
            //
            //                                         ///Complete this order button end
            //
            //                                         ///Edit Order Button Start
            //                                         order.payment_type ==
            //                                                 "INCOMPLETE ORDER"
            //                                             ? order.orderStatus ==
            //                                                     'CANCEL'
            //                                                 ? Container()
            //                                                 : Expanded(
            //                                                     child:
            //                                                         ElevatedButton(
            //                                                       onPressed:
            //                                                           () {
            //                                                         _cartController
            //                                                                 .cartMaster =
            //                                                             CartMaster.fromMap(
            //                                                                 jsonDecode(order.orderData!));
            //                                                         _cartController
            //                                                                 .cartMaster
            //                                                                 ?.oldOrderId =
            //                                                             order
            //                                                                 .id;
            //                                                         _cartController
            //                                                                 .tableNumber =
            //                                                             order
            //                                                                 .tableNo!;
            //                                                         String
            //                                                             colorCode =
            //                                                             order
            //                                                                 .order_id
            //                                                                 .toString();
            //                                                         int colorInt =
            //                                                             int.parse(
            //                                                                 colorCode.substring(1));
            //                                                         print(
            //                                                             "color int ${colorInt}");
            //                                                         SharedPreferences
            //                                                                 .getInstance()
            //                                                             .then(
            //                                                                 (value) {
            //                                                           value.setInt(
            //                                                               Constants
            //                                                                   .order_main_id
            //                                                                   .toString(),
            //                                                               colorInt);
            //                                                         });
            //                                                         order.deliveryType ==
            //                                                                 "TAKEAWAY"
            //                                                             ? _cartController.diningValue =
            //                                                                 false
            //                                                             : _cartController.diningValue =
            //                                                                 true;
            //                                                         order.user_name ==
            //                                                                 null
            //                                                             ? _cartController.userName =
            //                                                                 ''
            //                                                             : _cartController.userName =
            //                                                                 order.user_name;
            //                                                         order.mobile ==
            //                                                                 null
            //                                                             ? _cartController.userMobileNumber =
            //                                                                 ''
            //                                                             : _cartController.userMobileNumber =
            //                                                                 order.mobile;
            //                                                         // Constants.order_main_id = order.order_id.toString()
            //                                                         print(
            //                                                             "server order id ${order.order_id.toString()}");
            //                                                         Get.to(() =>
            //                                                             PosMenu(
            //                                                                 isDining:
            //                                                                     _cartController.diningValue));
            //                                                       },
            //                                                       child: Text(
            //                                                         "Edit this order",
            //                                                         textAlign:
            //                                                             TextAlign
            //                                                                 .center,
            //                                                         style:
            //                                                             TextStyle(
            //                                                           fontSize:
            //                                                               18,
            //                                                         ),
            //                                                       ),
            //                                                     ),
            //                                                   )
            //                                             : Container(),
            //                                         SizedBox(
            //                                           width: 5,
            //                                         ),
            //
            //                                         ///End Edit Order Button
            //
            //                                         /// Cancel Order Button Start
            //                                         order.orderStatus ==
            //                                                     'PENDING' ||
            //                                                 order.orderStatus ==
            //                                                     'APPROVE'
            //                                             ? Expanded(
            //                                                 child:
            //                                                     ElevatedButton(
            //                                                   // style: ElevatedButton
            //                                                   //     .styleFrom(
            //                                                   //   primary: Colors.white,
            //                                                   //   shape: RoundedRectangleBorder(
            //                                                   //       borderRadius: BorderRadius.only(
            //                                                   //           bottomLeft: Radius
            //                                                   //               .circular(
            //                                                   //                   20),
            //                                                   //           bottomRight: Radius
            //                                                   //               .circular(
            //                                                   //                   20)),
            //                                                   //       side: BorderSide
            //                                                   //           .none),
            //                                                   // ),
            //                                                   onPressed:
            //                                                       () async {
            //                                                     await showCancelOrderDialog(
            //                                                         order.id);
            //                                                     setState(() {
            //                                                       orderHistoryRef =
            //                                                           _orderHistoryController
            //                                                               .refreshOrderHistory(
            //                                                                   context);
            //                                                     });
            //                                                   },
            //                                                   child: RichText(
            //                                                     textAlign:
            //                                                         TextAlign
            //                                                             .center,
            //                                                     text: TextSpan(
            //                                                       children: [
            //                                                         WidgetSpan(
            //                                                           child:
            //                                                               Padding(
            //                                                             padding:
            //                                                                 EdgeInsets.only(right: ScreenUtil().setHeight(10)),
            //                                                             child: SvgPicture
            //                                                                 .asset(
            //                                                               'images/ic_cancel.svg',
            //                                                               width:
            //                                                                   ScreenUtil().setWidth(20),
            //                                                               //color: Color(Constants.colorRate),
            //                                                               height:
            //                                                                   ScreenUtil().setHeight(20),
            //                                                             ),
            //                                                           ),
            //                                                         ),
            //                                                         TextSpan(
            //                                                           text:
            //                                                               'Cancel this order',
            //                                                           style: TextStyle(
            //                                                               color: Colors.white,
            //                                                               // color: Color(Constants
            //                                                               //     .colorLike),
            //                                                               fontSize: 18,
            //                                                               fontFamily: Constants.appFont),
            //                                                         ),
            //                                                       ],
            //                                                     ),
            //                                                   ),
            //                                                 ),
            //                                               )
            //                                             // ? Column(
            //                                             //     children: [
            //                                             //       Container(
            //                                             //         // height: ScreenUtil()
            //                                             //         //     .setHeight(50),
            //                                             //         // width: double.minPositive,
            //                                             //         child:
            //                                             //             ElevatedButton(
            //                                             //           // style: ElevatedButton
            //                                             //           //     .styleFrom(
            //                                             //           //   primary: Colors.white,
            //                                             //           //   shape: RoundedRectangleBorder(
            //                                             //           //       borderRadius: BorderRadius.only(
            //                                             //           //           bottomLeft: Radius
            //                                             //           //               .circular(
            //                                             //           //                   20),
            //                                             //           //           bottomRight: Radius
            //                                             //           //               .circular(
            //                                             //           //                   20)),
            //                                             //           //       side: BorderSide
            //                                             //           //           .none),
            //                                             //           // ),
            //                                             //           onPressed:
            //                                             //               () async {
            //                                             //             await showCancelOrderDialog(
            //                                             //                 order.id);
            //                                             //             setState(
            //                                             //                 () {
            //                                             //               orderHistoryRef =
            //                                             //                   _orderHistoryController.refreshOrderHistory(context);
            //                                             //             });
            //                                             //           },
            //                                             //           child:
            //                                             //               RichText(
            //                                             //             text:
            //                                             //                 TextSpan(
            //                                             //               children: [
            //                                             //                 WidgetSpan(
            //                                             //                   child: Padding(
            //                                             //                     padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
            //                                             //                     child: SvgPicture.asset(
            //                                             //                       'images/ic_cancel.svg',
            //                                             //                       width: ScreenUtil().setWidth(20),
            //                                             //                       //color: Color(Constants.colorRate),
            //                                             //                       height: ScreenUtil().setHeight(20),
            //                                             //                     ),
            //                                             //                   ),
            //                                             //                 ),
            //                                             //                 TextSpan(
            //                                             //                   text: 'Cancel this order',
            //                                             //                   style: TextStyle(
            //                                             //                       color: Colors.white,
            //                                             //                       // color: Color(Constants
            //                                             //                       //     .colorLike),
            //                                             //                       fontSize: 18,
            //                                             //                       fontFamily: Constants.appFont),
            //                                             //                 ),
            //                                             //               ],
            //                                             //             ),
            //                                             //           ),
            //                                             //         ),
            //                                             //       ),
            //                                             //     ],
            //                                             //   )
            //                                             : Container(),
            //
            //                                         ///CAncel Order button End
            //                                       ],
            //                                     ),
            //                             ),
            //
            //                             // order.orderStatus !=
            //                             //             'COMPLETE' &&
            //                             //         order.deliveryType ==
            //                             //             'TAKEAWAY' &&
            //                             //         order.deliveryType !=
            //                             //             'DINING' &&
            //                             //         (order.payment_type ==
            //                             //                 'POS CASH' ||
            //                             //             order.payment_type ==
            //                             //                 'POS CARD')
            //                             //     ? Column(
            //                             //         children: [
            //                             //           ElevatedButton(
            //                             //             onPressed:
            //                             //                 () async {
            //                             //               await getTakeAwayValue(
            //                             //                       order
            //                             //                           .id!)
            //                             //                   .then(
            //                             //                       (value) {
            //                             //                 print(
            //                             //                     "value ${value.data}");
            //                             //                 Get.to(() => PosMenu(
            //                             //                     isDining:
            //                             //                         false));
            //                             //               });
            //                             //             },
            //                             //             child: RichText(
            //                             //               text: TextSpan(
            //                             //                 children: [
            //                             //                   WidgetSpan(
            //                             //                     child:
            //                             //                         Padding(
            //                             //                       padding:
            //                             //                           EdgeInsets.only(right: ScreenUtil().setHeight(10)),
            //                             //                       child: SvgPicture
            //                             //                           .asset(
            //                             //                         'images/ic_completed.svg',
            //                             //                         width:
            //                             //                             ScreenUtil().setWidth(20),
            //                             //                         //color: Color(Constants.colorRate),
            //                             //                         height:
            //                             //                             ScreenUtil().setHeight(20),
            //                             //                       ),
            //                             //                     ),
            //                             //                   ),
            //                             //                   TextSpan(
            //                             //                     text:
            //                             //                         'Complete this order',
            //                             //                     style: TextStyle(
            //                             //                         color: Colors
            //                             //                             .white,
            //                             //                         fontSize:
            //                             //                             18,
            //                             //                         fontFamily:
            //                             //                             Constants.appFont),
            //                             //                   ),
            //                             //                 ],
            //                             //               ),
            //                             //             ),
            //                             //           )
            //                             //           // GestureDetector(
            //                             //           //   onTap: () async {
            //                             //           //
            //                             //           //   },
            //                             //           //   child: Align(
            //                             //           //     alignment:
            //                             //           //         Alignment
            //                             //           //             .center,
            //                             //           //     child:
            //                             //           //   ),
            //                             //           // ),
            //                             //         ],
            //                             //       )
            //                             //     : Container(),
            //                             // if (order.orderStatus ==
            //                             //         'PENDING' ||
            //                             //     order.orderStatus ==
            //                             //         'APPROVE')
            //                             //   Column(
            //                             //     children: [
            //                             //       Container(
            //                             //         // height: ScreenUtil()
            //                             //         //     .setHeight(50),
            //                             //         // width: double.minPositive,
            //                             //         child: ElevatedButton(
            //                             //           // style: ElevatedButton
            //                             //           //     .styleFrom(
            //                             //           //   primary: Colors.white,
            //                             //           //   shape: RoundedRectangleBorder(
            //                             //           //       borderRadius: BorderRadius.only(
            //                             //           //           bottomLeft: Radius
            //                             //           //               .circular(
            //                             //           //                   20),
            //                             //           //           bottomRight: Radius
            //                             //           //               .circular(
            //                             //           //                   20)),
            //                             //           //       side: BorderSide
            //                             //           //           .none),
            //                             //           // ),
            //                             //           onPressed:
            //                             //               () async {
            //                             //             await showCancelOrderDialog(
            //                             //                 order.id);
            //                             //             setState(() {
            //                             //               orderHistoryRef =
            //                             //                   _orderHistoryController
            //                             //                       .refreshOrderHistory(
            //                             //                           context);
            //                             //             });
            //                             //           },
            //                             //           child: RichText(
            //                             //             text: TextSpan(
            //                             //               children: [
            //                             //                 WidgetSpan(
            //                             //                   child:
            //                             //                       Padding(
            //                             //                     padding: EdgeInsets.only(
            //                             //                         right:
            //                             //                             ScreenUtil().setHeight(10)),
            //                             //                     child: SvgPicture
            //                             //                         .asset(
            //                             //                       'images/ic_cancel.svg',
            //                             //                       width: ScreenUtil()
            //                             //                           .setWidth(20),
            //                             //                       //color: Color(Constants.colorRate),
            //                             //                       height:
            //                             //                           ScreenUtil().setHeight(20),
            //                             //                     ),
            //                             //                   ),
            //                             //                 ),
            //                             //                 TextSpan(
            //                             //                   text:
            //                             //                       'Cancel this order',
            //                             //                   style: TextStyle(
            //                             //                       color: Colors.white,
            //                             //                       // color: Color(Constants
            //                             //                       //     .colorLike),
            //                             //                       fontSize: 18,
            //                             //                       fontFamily: Constants.appFont),
            //                             //                 ),
            //                             //               ],
            //                             //             ),
            //                             //           ),
            //                             //         ),
            //                             //       ),
            //                             //     ],
            //                             //   ),
            //                             // (() {
            //                             //   if (order.orderStatus ==
            //                             //           'CANCEL' ||
            //                             //       order.orderStatus ==
            //                             //           'COMPLETE') {
            //                             //     return Container();
            //                             //     // return Container(
            //                             //     //   height: ScreenUtil()
            //                             //     //       .setHeight(
            //                             //     //       40),
            //                             //     //   child:
            //                             //     //   ElevatedButton(
            //                             //     //     style: ElevatedButton.styleFrom(
            //                             //     //       primary: Colors.white,
            //                             //     //       shape: RoundedRectangleBorder(
            //                             //     //           borderRadius:
            //                             //     //           BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            //                             //     //           side: BorderSide.none),
            //                             //     //     ),
            //                             //     //     onPressed:
            //                             //     //         () {
            //                             //     //       Navigator.of(context).push(Transitions(
            //                             //     //           transitionType: TransitionType.fade,
            //                             //     //           curve: Curves.bounceInOut,
            //                             //     //           reverseCurve: Curves.fastLinearToSlowEaseIn,
            //                             //     //           widget: OrderReviewScreen(
            //                             //     //             orderId: _orderHistoryController.listOrderHistory[index].id,
            //                             //     //           )));
            //                             //     //     },
            //                             //     //     child: RichText(
            //                             //     //       text:
            //                             //     //       TextSpan(
            //                             //     //         children: [
            //                             //     //           WidgetSpan(
            //                             //     //             child: Padding(
            //                             //     //               padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
            //                             //     //               child: SvgPicture.asset(
            //                             //     //                 'images/ic_star.svg',
            //                             //     //                 width: ScreenUtil().setWidth(20),
            //                             //     //                 color: Color(Constants.colorRate),
            //                             //     //                 height: ScreenUtil().setHeight(20),
            //                             //     //               ),
            //                             //     //             ),
            //                             //     //           ),
            //                             //     //           TextSpan(
            //                             //     //             text: (() {
            //                             //     //               // your code here
            //                             //     //               // _orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' ? 'Ordered on ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}' : 'Delivered on October 10,2020, 09:23pm',
            //                             //     //               if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL' || _orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
            //                             //     //                 return 'Rate Now';
            //                             //     //               } else {
            //                             //     //                 return '';
            //                             //     //               }
            //                             //     //             }()),
            //                             //     //             style: TextStyle(color: Color(Constants.colorRate), fontSize: 18, fontFamily: Constants.appFont),
            //                             //     //           ),
            //                             //     //         ],
            //                             //     //       ),
            //                             //     //     ),
            //                             //     //
            //                             //     //   ),
            //                             //     // );
            //                             //   } else {
            //                             //     return Container();
            //                             //   }
            //                             // }()),
            //                             if (order.orderStatus != 'COMPLETE' &&
            //                                 order.orderStatus != 'CANCEL' &&
            //                                 order.deliveryType == 'DINING')
            //                               Container(
            //                                 height: ScreenUtil().setHeight(40),
            //                                 child: ElevatedButton(
            //                                   style: ElevatedButton.styleFrom(
            //                                     primary:
            //                                         Color(Constants.colorTheme),
            //                                     shape: RoundedRectangleBorder(
            //                                         borderRadius:
            //                                             BorderRadius.only(
            //                                                 bottomLeft: Radius
            //                                                     .circular(20),
            //                                                 bottomRight:
            //                                                     Radius.circular(
            //                                                         20)),
            //                                         side: BorderSide.none),
            //                                   ),
            //                                   onPressed: () {
            //                                     // showCancelOrderDialog(_orderHistoryController.listOrderHistory[index].id);
            //                                   },
            //                                   child: RichText(
            //                                     text: TextSpan(
            //                                       children: [
            //                                         TextSpan(
            //                                           text: 'Live Order',
            //                                           style: TextStyle(
            //                                             color: Colors.white,
            //                                             fontSize: 18,
            //                                           ),
            //                                         ),
            //                                       ],
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                           ],
            //                         )),
            //                   ],
            //                 )
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     );
            //     // return ListTile(
            //     //   title: Text(order.amount.toString()),
            //     //   subtitle: Text(order.deliveryType.toString()),
            //     // );
            //   },
            // );
            return Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Temp Users",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    "Name",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ))),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    "Phone",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ))),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.data!.tempUser!.length,
                            itemBuilder: (BuildContext context, int index) {
                              // build the list item here
                              final user =
                                  snapshot.data!.data!.tempUser![index];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child:
                                              Center(child: Text(user.name!))),
                                      Expanded(
                                          child:
                                              Center(child: Text(user.phone!))),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Registered Users",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    "Name",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ))),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    "Phone",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ))),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount:
                                snapshot.data!.data!.registeredUser!.length,
                            itemBuilder: (BuildContext context, int index) {
                              // build the list item here
                              final user =
                                  snapshot.data!.data!.registeredUser![index];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child:
                                              Center(child: Text(user.name!))),
                                      Expanded(
                                          child:
                                              Center(child: Text(user.phone!))),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // handle the error here
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: Text('No Orders History'));
          }
        },
      ),
    );
  }
}
