// import 'dart:async';
// import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dotted_line/dotted_line.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:pos/controller/auth_controller.dart';
// import 'package:pos/controller/cart_controller.dart';
// import 'package:pos/controller/order_custimization_controller.dart';
// import 'package:pos/controller/order_history_controller.dart';
// import 'package:pos/controller/order_history_controller.dart';
// import 'package:pos/model/cart_master.dart';
// import 'package:pos/model/common_res.dart';
// import 'package:pos/model/order_history_list_model.dart';
// import 'package:pos/pages/cart_screen.dart';
// import 'package:pos/pages/pos/pos_menu.dart';
// import 'package:pos/retrofit/api_client.dart';
// import 'package:pos/retrofit/api_header.dart';
// import 'package:pos/retrofit/base_model.dart';
// import 'package:pos/retrofit/server_error.dart';
// import 'package:pos/screen_animation_utils/transitions.dart';
//
// // import 'package:pos/screens/order_tracking/trackingScreen.dart';
// // import 'package:pos/utils/SharedPreferenceUtil.dart';
// import 'package:pos/utils/app_toolbar_with_btn_clr.dart';
// import 'package:pos/utils/constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../constant/app_strings.dart';
//
// enum FilterType { TakeAway, DineIn, None }
//
// class OrderHistory extends StatefulWidget {
//   final bool isFromProfile;
//
//   const OrderHistory({Key? key, required this.isFromProfile}) : super(key: key);
//
//   @override
//   _OrderHistoryState createState() => _OrderHistoryState();
// }
//
// class _OrderHistoryState extends State<OrderHistory> {
//   OrderHistoryController _orderHistoryController =
//       Get.find<OrderHistoryController>();
//   OrderCustimizationController _orderCustimizationController =
//       Get.find<OrderCustimizationController>();
//
//   DatabaseReference _firebaseRef = FirebaseDatabase.instance.reference();
//   Future<BaseModel<OrderHistoryListModel>>? orderHistoryRef;
//   TextEditingController _textOrderCancelReason = new TextEditingController();
//   StreamSubscription<DatabaseEvent>? firebaseListener;
//   CartController _cartController = Get.find<CartController>();
//   RxList<dynamic> dynamicList = RxList<dynamic>();
//
//   // RxList<OrderHistoryData> _totalOrders = RxList<OrderHistoryData>();
//   // RxList<OrderHistoryData> _takeAwayOrders = RxList<OrderHistoryData>();
//   // RxList<OrderHistoryData> _DineInOrders = RxList<OrderHistoryData>();
//   // FilterType _filterType = FilterType.None;
//
//   @override
//   void initState() {
//     // orderHistoryRef = _orderHistoryController.refreshOrderHistory(context);
//     // orderHistoryRef!.then((value) {
//     //   _totalOrders.value = value.data!.data!;
//     //   value.data!.data!.forEach((element) {
//     //   if(element.deliveryType == "TAKEAWAY"){
//     //     _takeAwayOrders.add(element);
//     //   } else if(element.deliveryType == "DINING"){
//     //     _DineInOrders.add(element);
//     //   }
//     //   });
//     //
//     // });
//     _getOrders();
//     initAsync();
//     super.initState();
//   }
//
//   // void _applyFilter(FilterType filterType) {
//   //   setState(() {
//   //     _filterType = filterType;
//   //   });
//   // }
//
//   // List<OrderHistoryData> _getFilteredOrders() {
//   //   if (_filterType == FilterType.TakeAway) {
//   //     return _takeAwayOrders;
//   //   } else if (_filterType == FilterType.DineIn) {
//   //     return _DineInOrders;
//   //   } else {
//   //     return _totalOrders;
//   //   }
//   // }
//
//   initAsync() async {
//     firebaseListener = _firebaseRef
//         .child('orders')
//         .child((await SharedPreferences.getInstance())
//                 .getString(Constants.loginUserId) ??
//             '144')
//         .onChildChanged
//         .listen((event) {
//       _orderHistoryController.refreshOrderHistory(context);
//     });
//   }
//
//   final _totalOrders = <OrderHistoryData>[].obs;
//   final _takeAwayOrders = <OrderHistoryData>[].obs;
//   final _DineInOrders = <OrderHistoryData>[].obs;
//   FilterType _filterType = FilterType.None;
//
//   Future<void> _getOrders() async {
//     orderHistoryRef = _orderHistoryController.refreshOrderHistory(context);
//     final value = await orderHistoryRef;
//     if (value!.data!.data!.isNotEmpty) {
//       setState(() {
//         _totalOrders.addAll(value.data!.data!);
//         for (final element in value.data!.data!) {
//           if (element.deliveryType == "TAKEAWAY") {
//             _takeAwayOrders.add(element);
//           } else if (element.deliveryType == "DINING") {
//             _DineInOrders.add(element);
//           }
//         }
//       });
//     } else {
//       // handle error case
//     }
//   }
//
//   void _applyFilter(FilterType filterType) {
//     setState(() {
//       _filterType = filterType;
//     });
//   }
//
//   List<OrderHistoryData> _getFilteredOrders() {
//     if (_filterType == FilterType.TakeAway) {
//       return _takeAwayOrders;
//     } else if (_filterType == FilterType.DineIn) {
//       return _DineInOrders;
//     } else {
//       return _totalOrders;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         await _orderCustimizationController.callGetRestaurantsDetails(5);
//         Get.off(() => PosMenu(
//
//             isDining: false));
//         return Future.value(true);
//       },
//       child: Scaffold(
//         appBar: ApplicationToolbarWithClrBtn(
//           appbarTitle: 'Order History',
//           // str_button_title: Languages.of(context).labelClearList,
//           strButtonTitle: "",
//           btnColor: Color(Constants.colorLike),
//           onBtnPress: () {},
//         ),
//         body: Container(
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(
//               color: Color(Constants.colorScreenBackGround),
//               image: DecorationImage(
//                 image: AssetImage('images/ic_background_image.png'),
//                 fit: BoxFit.cover,
//               )),
//           child: Column(
//             children: [
//               SizedBox(height: 5),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   delieveryTypeButton(
//                       onTap: () => _applyFilter(FilterType.DineIn),
//                       icon: Icons.card_travel,
//                       title: "Dine In",
//                       style: TextStyle(
//                           color: _filterType == FilterType.DineIn
//                               ? Colors.white
//                               : Colors.black),
//                       color: _filterType == FilterType.DineIn
//                           ? Colors.white
//                           : Colors.black,
//                       buttonColor: _filterType == FilterType.DineIn
//                           ? Colors.red.shade500
//                           : Colors.white),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   delieveryTypeButton(
//                       onTap: () => _applyFilter(FilterType.TakeAway),
//                       icon: Icons.table_bar,
//                       title: "TakeAway",
//                       style: TextStyle(
//                           color: _filterType == FilterType.TakeAway
//                               ? Colors.white
//                               : Colors.black),
//                       color: _filterType == FilterType.TakeAway
//                           ? Colors.white
//                           : Colors.black,
//                       buttonColor: _filterType == FilterType.TakeAway
//                           ? Colors.red.shade500
//                           : Colors.white),
//                   // ElevatedButton(
//                   //   onPressed: () => _applyFilter(FilterType.TakeAway),
//                   //   child: Text('Takeaway'),
//                   // ),
//                   // ElevatedButton(
//                   //   onPressed: () => _applyFilter(FilterType.DineIn),
//                   //   child: Text('Dining'),
//                   // ),
//                 ],
//               ),
//               Expanded(
//                 child: FutureBuilder<BaseModel<OrderHistoryListModel>>(
//                   future: orderHistoryRef,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       // show a CircularProgressIndicator while data is being fetched
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     } else if (snapshot.hasData) {
//                       return ListView.builder(
//                         padding:
//                             EdgeInsets.only(bottom: 100, left: 10, right: 10),
//                         scrollDirection: Axis.vertical,
//                         itemCount: _getFilteredOrders().length,
//                         itemBuilder: (BuildContext context, int index) {
//                           // build the list item here
//                           final order = _getFilteredOrders()[index];
//                           // print("order data ${order.toJson()}");
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.only(top: 10, right: 10),
//                                 child: Text(
//                                   (() {
//                                         if (order.addressId != null) {
//                                           if (order.orderStatus == 'PENDING') {
//                                             return '${'Ordered On'} ${order.date}, ${order.time}';
//                                           } else if (order.orderStatus ==
//                                               'ACCEPT') {
//                                             return '${'Accepted On'} ${order.date}, ${order.time}';
//                                           } else if (order.orderStatus ==
//                                               'APPROVE') {
//                                             return '${'Approve On'} ${order.date}, ${order.time}';
//                                           } else if (order.orderStatus ==
//                                               'REJECT') {
//                                             return '${'Rejected On'} ${order.date}, ${order.time}';
//                                           } else if (order.orderStatus ==
//                                               'PICKUP') {
//                                             return '${'Pickedup On'} ${order.date}, ${order.time}';
//                                           } else if (order.orderStatus ==
//                                               'DELIVERED') {
//                                             return '${'Delivered On'} ${order.date}, ${order.time}';
//                                           } else if (order.orderStatus ==
//                                               'CANCEL') {
//                                             return 'Canceled On ${order.date}, ${order.time}';
//                                           } else if (order.orderStatus ==
//                                               'COMPLETE') {
//                                             return 'Delivered On ${order.date}, ${order.time}';
//                                           }
//                                         } else {
//                                           if (order.orderStatus == 'PENDING') {
//                                             return 'Ordered On ${order.date}, ${order.time}';
//                                           } else if (order.orderStatus ==
//                                               'ACCEPT') {
//                                             return 'Accepted On ${order.date}, ${order.time}';
//                                           } else if (order.orderStatus ==
//                                               'APPROVE') {
//                                             return 'Approve On ${order.date}, ${order.time}';
//                                           } else if (order.orderStatus ==
//                                               'REJECT') {
//                                             return 'Rejected On ${order.date}, ${order.time}';
//                                           } else if (order.orderStatus ==
//                                               'PREPARE_FOR_ORDER') {
//                                             return 'PREPARE FOR ORDER ${order.date}, ${order.time}';
//                                           } else if (order.orderStatus ==
//                                               'READY_FOR_ORDER') {
//                                             return 'READY FOR ORDER ${order.date}, ${order.time}';
//                                           } else if (order.orderStatus ==
//                                               'CANCEL') {
//                                             return 'Canceled On ${order.date}, ${order.time}';
//                                           } else if (order.orderStatus ==
//                                               'COMPLETE') {
//                                             return 'Delivered On ${order.date}, ${order.time}';
//                                           }
//                                         }
//                                       }()) ??
//                                       '',
//                                   style: TextStyle(
//                                       color: Color(Constants.colorGray),
//                                       fontFamily: Constants.appFont,
//                                       fontSize: 12),
//                                   textAlign: TextAlign.end,
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   print(
//                                       " orderData is .. ${order.deliveryType}");
//                                   // // Constants.toastMessage(_orderHistoryController.listOrderHistory[index].id.toString());
//                                   // Navigator.of(context).push(
//                                   //     Transitions(
//                                   //         transitionType:
//                                   //         TransitionType.fade,
//                                   //         curve:
//                                   //         Curves.bounceInOut,
//                                   //         reverseCurve: Curves
//                                   //             .fastLinearToSlowEaseIn,
//                                   //         widget:
//                                   //         OrderDetailsScreen(
//                                   //           orderId:
//                                   //           _orderHistoryController.listOrderHistory[
//                                   //           index]
//                                   //               .id,
//                                   //           orderDate:
//                                   //           _orderHistoryController.listOrderHistory[
//                                   //           index]
//                                   //               .date,
//                                   //           orderTime:
//                                   //           _orderHistoryController.listOrderHistory[
//                                   //           index]
//                                   //               .time,
//                                   //         )));
//                                 },
//                                 child: Card(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20.0),
//                                   ),
//                                   margin: EdgeInsets.only(
//                                       top: 20, left: 16, right: 16, bottom: 20),
//                                   child: Column(
//                                     children: [
//                                       // (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' || _orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE')?
//                                       //
//                                       // GestureDetector(
//                                       //   onTap: (){
//                                       //     showCancelOrderDialog(_orderHistoryController.listOrderHistory[index].id);
//                                       //   },
//                                       //   child: Padding(
//                                       //     padding: const EdgeInsets
//                                       //         .only(
//                                       //         top: 10,
//                                       //         right:
//                                       //         20),
//                                       //     child:
//                                       //     RichText(
//                                       //       text:
//                                       //       TextSpan(
//                                       //         children: [
//                                       //           WidgetSpan(
//                                       //             child:
//                                       //             Padding(
//                                       //               padding: const EdgeInsets.only(right: 5),
//                                       //               child: SvgPicture.asset('images/ic_cancel.svg',
//                                       //
//                                       //                 //  color: Color(Constants.colorTheme),
//                                       //                 width: 15,
//                                       //                 height: ScreenUtil().setHeight(15),
//                                       //               ),
//                                       //             ),
//                                       //           ),
//                                       //           TextSpan(
//                                       //               text: 'Cancel this order',
//                                       //               style: TextStyle(
//                                       //                   color: Color(Constants.colorLike),
//                                       //                   fontFamily: Constants.appFont,
//                                       //                   fontSize: 12)),
//                                       //         ],
//                                       //       ),
//                                       //     ),
//                                       //   ),
//                                       // ):Container(),
//                                       Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           // Padding(
//                                           //   padding:
//                                           //   const EdgeInsets
//                                           //       .all(5.0),
//                                           //   child: ClipRRect(
//                                           //     borderRadius:
//                                           //     BorderRadius
//                                           //         .circular(
//                                           //         15.0),
//                                           //     child: CachedNetworkImage(
//                                           //       height:
//                                           //       100,
//                                           //       width:
//                                           //       100,
//                                           //       imageUrl:
//                                           //       _orderHistoryController.listOrderHistory[
//                                           //       index]
//                                           //           .vendor!
//                                           //           .image!,
//                                           //       fit: BoxFit.cover,
//                                           //       placeholder: (context,
//                                           //           url) =>
//                                           //           SpinKitFadingCircle(
//                                           //               color: Color(
//                                           //                   Constants
//                                           //                       .colorTheme)),
//                                           //       errorWidget:
//                                           //           (context, url,
//                                           //           error) =>
//                                           //           Container(
//                                           //             child: Center(
//                                           //                 child: Image.asset('images/noimage.png')),
//                                           //           ),
//                                           //     ),
//                                           //   ),
//                                           // ),
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           left: 10, top: 10),
//                                                   child: Text(
//                                                     "Order ${order.order_id.toString()} | ${order.user!.name} | ${order.vendor!.name!} | ${order.payment_type.toString()} | ${order.deliveryType}}",
//                                                     style: TextStyle(
//                                                       fontFamily:
//                                                           Constants.appFontBold,
//                                                       fontSize: 12,
//                                                       color: Color(
//                                                           Constants.colorGray),
//                                                     ),
//                                                   ),
//
//                                                   // child: Row(
//                                                   //   children: [
//                                                   //     // Expanded(
//                                                   //     //   flex: 4,
//                                                   //     //   child:
//                                                   //     //   Padding(
//                                                   //     //     padding: const EdgeInsets
//                                                   //     //         .only(
//                                                   //     //         left:
//                                                   //     //         10,
//                                                   //     //         top:
//                                                   //     //         10),
//                                                   //     //     child: Text(
//                                                   //     //       "Order # ${_orderHistoryController.listOrderHistory[index].id.toString()}",
//                                                   //     //       style: TextStyle(
//                                                   //     //           fontFamily:
//                                                   //     //           Constants.appFontBold,
//                                                   //     //           fontSize: 16),
//                                                   //     //     ),
//                                                   //     //     // Text(
//                                                   //     //     //   _orderHistoryController.listOrderHistory[index]
//                                                   //     //     //       .vendor!
//                                                   //     //     //       .name!,
//                                                   //     //     //   style: TextStyle(
//                                                   //     //     //       fontFamily:
//                                                   //     //     //       Constants.appFontBold,
//                                                   //     //     //       fontSize: 16),
//                                                   //     //     // ),
//                                                   //     //   ),
//                                                   //     // ),
//                                                   //     Text(
//                                                   //       "Order # ${_orderHistoryController.listOrderHistory[index].id.toString()} | ${_orderHistoryController.listOrderHistory[index].user!.name}",
//                                                   //       style: TextStyle(
//                                                   //           fontFamily:
//                                                   //           Constants.appFontBold,
//                                                   //           fontSize: 12,
//                                                   //       color: Color(Constants.colorGray),
//                                                   //       ),
//                                                   //     ),
//                                                   //     Text(
//                                                   //       ,
//                                                   //       style: TextStyle(
//                                                   //           fontFamily:
//                                                   //           Constants.appFontBold,
//                                                   //           fontSize: 12,
//                                                   //         color: Color(Constants.colorGray),
//                                                   //       ),
//                                                   //     ),
//                                                   //   ],
//                                                   // ),
//                                                 ),
//                                                 // Padding(
//                                                 //   padding:
//                                                 //   const EdgeInsets
//                                                 //       .only(
//                                                 //       top: 3,
//                                                 //       left:
//                                                 //       10,
//                                                 //       right:
//                                                 //       5),
//                                                 //   child: Text(
//                                                 //    _orderHistoryController.listOrderHistory[index].user!.name,
//                                                 //     style: TextStyle(
//                                                 //         fontFamily:
//                                                 //         Constants.appFontBold,
//                                                 //         fontSize: 12),
//                                                 //   ),
//                                                 // ),
//                                                 ///Start vendor name
//                                                 // Padding(
//                                                 //   padding:
//                                                 //       const EdgeInsets
//                                                 //               .only(
//                                                 //           top: 3,
//                                                 //           left: 10,
//                                                 //           right: 5),
//                                                 //   child: Text(
//                                                 //     _orderHistoryController
//                                                 //         .listOrderHistory[
//                                                 //             index]
//                                                 //         .vendor!
//                                                 //         .name!,
//                                                 //     style: TextStyle(
//                                                 //         fontFamily:
//                                                 //             Constants
//                                                 //                 .appFontBold,
//                                                 //         fontSize: 10),
//                                                 //   ),
//                                                 // ),
//                                                 ///End vendor Name
//                                                 // Padding(
//                                                 //   padding:
//                                                 //   const EdgeInsets
//                                                 //       .only(
//                                                 //       top: 3,
//                                                 //       left:
//                                                 //       10,
//                                                 //       right:
//                                                 //       5),
//                                                 //   child: Text(
//                                                 //     _orderHistoryController.listOrderHistory[
//                                                 //     index]
//                                                 //         .vendor!
//                                                 //         .mapAddress ?? '',
//                                                 //     overflow:
//                                                 //     TextOverflow
//                                                 //         .ellipsis,
//                                                 //     style: TextStyle(
//                                                 //         fontFamily:
//                                                 //         Constants
//                                                 //             .appFont,
//                                                 //         color: Color(
//                                                 //             Constants
//                                                 //                 .colorGray),
//                                                 //         fontSize:
//                                                 //         13),
//                                                 //   ),
//                                                 // ),
//                                                 order.tableNo == 0
//                                                     ? SizedBox()
//                                                     : Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                     .only(
//                                                                 top: 3,
//                                                                 left: 10,
//                                                                 right: 5),
//                                                         child: Text(
//                                                           "Table No ${order.tableNo.toString()}" ??
//                                                               '',
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           style: TextStyle(
//                                                               fontFamily: Constants
//                                                                   .appFontBold,
//                                                               fontSize: 16),
//                                                         ),
//                                                       ),
//                                                 SizedBox(
//                                                   height: ScreenUtil()
//                                                       .setHeight(10),
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     Expanded(
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                     .only(
//                                                                 left: 10,
//                                                                 top: 10),
//                                                         child: RichText(
//                                                           text: TextSpan(
//                                                               text: AuthController
//                                                                       .sharedPreferences
//                                                                       ?.getString(
//                                                                           Constants
//                                                                               .appSettingCurrencySymbol) ??
//                                                                   '' +
//                                                                       '${order.amount} ',
//                                                               style: TextStyle(
//                                                                   fontFamily:
//                                                                   Constants
//                                                                       .appFont,
//                                                                   fontSize:
//                                                                   14),
//                                                               children: <
//                                                                   TextSpan>[
//                                                                 TextSpan(
//                                                                   text:
//                                                                      order.payment_type == "POS CASH" || order.payment_type == "POS CARD" ?  '( Payment Completed )' : '( Payment Incomplete )',
//                                                                   style: TextStyle(
//                                                                       color: Colors.red.shade500,
//                                                                     // fontWeight: FontWeight.bold,
//                                                                       fontFamily:
//                                                                       Constants
//                                                                           .appFont,
//                                                                       fontSize:
//                                                                       14),
//                                                                 )
//                                                               ]),
//                                                         ),
//                                                         // child: Text(
//                                                         //   AuthController
//                                                         //       .sharedPreferences
//                                                         //       ?.getString(Constants
//                                                         //       .appSettingCurrencySymbol) ??
//                                                         //       '' +
//                                                         //           '${order.amount}',
//                                                         //   style: TextStyle(
//                                                         //       fontFamily:
//                                                         //       Constants
//                                                         //           .appFont,
//                                                         //       fontSize:
//                                                         //       14),
//                                                         // ),
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               top: 10,
//                                                               right: 20),
//                                                       child: RichText(
//                                                         text: TextSpan(
//                                                           children: [
//                                                             WidgetSpan(
//                                                               child: Padding(
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                             .only(
//                                                                         right:
//                                                                             5),
//                                                                 child:
//                                                                     SvgPicture
//                                                                         .asset(
//                                                                   (() {
//                                                                         if (_orderHistoryController.listOrderHistory[index].addressId !=
//                                                                             null) {
//                                                                           if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'PENDING') {
//                                                                             return 'images/ic_pending.svg';
//                                                                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'APPROVE') {
//                                                                             return 'images/ic_accept.svg';
//                                                                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'ACCEPT') {
//                                                                             return 'images/ic_accept.svg';
//                                                                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'REJECT') {
//                                                                             return 'images/ic_cancel.svg';
//                                                                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'PICKUP') {
//                                                                             return 'images/ic_pickup.svg';
//                                                                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'DELIVERED') {
//                                                                             return 'images/ic_completed.svg';
//                                                                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'CANCEL') {
//                                                                             return 'images/ic_cancel.svg';
//                                                                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'COMPLETE') {
//                                                                             return 'images/ic_completed.svg';
//                                                                           } else {
//                                                                             return 'images/ic_accept.svg';
//                                                                           }
//                                                                         } else {
//                                                                           if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'PENDING') {
//                                                                             return 'images/ic_pending.svg';
//                                                                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'APPROVE') {
//                                                                             return 'images/ic_accept.svg';
//                                                                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'PREPARING FOOD') {
//                                                                             return 'images/ic_pickup.svg';
//                                                                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'READY TO PICKUP') {
//                                                                             return 'images/ic_completed.svg';
//                                                                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'REJECT') {
//                                                                             return 'images/ic_cancel.svg';
//                                                                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'CANCEL') {
//                                                                             return 'images/ic_cancel.svg';
//                                                                           } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                               'COMPLETE') {
//                                                                             return 'images/ic_completed.svg';
//                                                                           }
//                                                                         }
//                                                                       }()) ??
//                                                                       '',
//                                                                   color: (() {
//                                                                     // your code here
//                                                                     // _orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' ? 'Ordered on ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}' : 'Delivered on October 10,2020, 09:23pm',
//                                                                     if (_orderHistoryController
//                                                                             .listOrderHistory[
//                                                                                 index]
//                                                                             .orderStatus ==
//                                                                         'PENDING') {
//                                                                       return Color(
//                                                                           Constants
//                                                                               .colorOrderPending);
//                                                                     } else if (_orderHistoryController
//                                                                             .listOrderHistory[
//                                                                                 index]
//                                                                             .orderStatus ==
//                                                                         'ACCEPT') {
//                                                                       return Color(
//                                                                           Constants
//                                                                               .colorBlack);
//                                                                     } else if (_orderHistoryController
//                                                                             .listOrderHistory[index]
//                                                                             .orderStatus ==
//                                                                         'PICKUP') {
//                                                                       return Color(
//                                                                           Constants
//                                                                               .colorOrderPickup);
//                                                                     }
//                                                                   }()),
//                                                                   width: 15,
//                                                                   height: ScreenUtil()
//                                                                       .setHeight(
//                                                                           15),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             TextSpan(
//                                                                 text: (() {
//                                                                   if (_orderHistoryController
//                                                                           .listOrderHistory[
//                                                                               index]
//                                                                           .deliveryType ==
//                                                                       'TAKEAWAY') {
//                                                                     if (_orderHistoryController
//                                                                             .listOrderHistory[index]
//                                                                             .orderStatus ==
//                                                                         'READY TO PICKUP') {
//                                                                       return 'Waiting For User To Pickup';
//                                                                     }
//                                                                   } else {
//                                                                     if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                             'READY TO PICKUP' ||
//                                                                         _orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                             'ACCEPT') {
//                                                                       return 'Waiting For Driver To Pickup';
//                                                                     }
//                                                                   }
//                                                                   return _orderHistoryController
//                                                                       .listOrderHistory[
//                                                                           index]
//                                                                       .orderStatus;
//                                                                   // if (_orderHistoryController.listOrderHistory[index].addressId != null) {
//                                                                   //
//                                                                   //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//                                                                   //     return Languages.of(context)!.labelOrderPending;
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
//                                                                   //     return Languages.of(context)!.labelOrderAccepted;
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//                                                                   //     return Languages.of(context)!.labelOrderAccepted;
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
//                                                                   //     return Languages.of(context)!.labelOrderRejected;
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
//                                                                   //     return 'PREPARING FOOD';
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
//                                                                   //     return 'READY TO PICKUP';
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
//                                                                   //     return Languages.of(context)!.labelOrderPickedUp;
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
//                                                                   //     return Languages.of(context)!.labelDeliveredSuccess;
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
//                                                                   //     return Languages.of(context)!.labelOrderCanceled;
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//                                                                   //     return Languages.of(context)!.labelOrderCompleted;
//                                                                   //   }
//                                                                   // } else {
//                                                                   //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//                                                                   //     return Languages.of(context)!.labelOrderPending;
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
//                                                                   //     return Languages.of(context)!.labelOrderAccepted;
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//                                                                   //     return Languages.of(context)!.labelOrderAccepted;
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
//                                                                   //     return 'PREPARING FOOD';
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
//                                                                   //     return 'READY TO PICKUP';
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
//                                                                   //     return Languages.of(context)!.labelOrderRejected;
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//                                                                   //     return Languages.of(context)!.labelOrderCompleted;
//                                                                   //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
//                                                                   //     return Languages.of(context)!.labelOrderCanceled;
//                                                                   //   }
//                                                                   // }
//                                                                 }()),
//                                                                 style:
//                                                                     TextStyle(
//                                                                         color:
//                                                                             (() {
//                                                                           if (_orderHistoryController.listOrderHistory[index].addressId !=
//                                                                               null) {
//                                                                             if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'PENDING') {
//                                                                               return Color(Constants.colorOrderPending);
//                                                                             } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'APPROVE') {
//                                                                               return Color(Constants.colorBlack);
//                                                                             } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'ACCEPT') {
//                                                                               return Color(Constants.colorBlack);
//                                                                             } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'REJECT') {
//                                                                               return Color(Constants.colorLike);
//                                                                             } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'PICKUP') {
//                                                                               return Color(Constants.colorOrderPickup);
//                                                                             } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'DELIVERED') {
//                                                                               return Color(Constants.colorTheme);
//                                                                             } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'CANCEL') {
//                                                                               return Color(Constants.colorLike);
//                                                                             } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'COMPLETE') {
//                                                                               return Color(Constants.colorTheme);
//                                                                             } else {
//                                                                               return Color(Constants.colorTheme);
//                                                                             }
//                                                                           } else {
//                                                                             if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'PENDING') {
//                                                                               return Color(Constants.colorOrderPending);
//                                                                             } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'APPROVE') {
//                                                                               return Color(Constants.colorBlack);
//                                                                             } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'ACCEPT') {
//                                                                               return Color(Constants.colorBlack);
//                                                                             } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'REJECT') {
//                                                                               return Color(Constants.colorLike);
//                                                                             } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'PREPARING FOOD') {
//                                                                               return Color(Constants.colorOrderPickup);
//                                                                             } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'READY TO PICKUP') {
//                                                                               return Color(Constants.colorTheme);
//                                                                             } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'CANCEL') {
//                                                                               return Color(Constants.colorLike);
//                                                                             } else if (_orderHistoryController.listOrderHistory[index].orderStatus ==
//                                                                                 'COMPLETE') {
//                                                                               return Color(Constants.colorTheme);
//                                                                             } else {
//                                                                               return Color(Constants.colorTheme);
//                                                                             }
//                                                                           }
//                                                                         }()),
//                                                                         fontFamily:
//                                                                             Constants
//                                                                                 .appFont,
//                                                                         fontSize:
//                                                                             12)),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 5, right: 5, top: 20),
//                                         child: DottedLine(
//                                           dashColor: Color(0xffcccccc),
//                                         ),
//                                       ),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                               flex: 5,
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.stretch,
//                                                 children: [
//                                                   ListView.builder(
//                                                     physics:
//                                                         ClampingScrollPhysics(),
//                                                     shrinkWrap: true,
//                                                     scrollDirection:
//                                                         Axis.vertical,
//                                                     itemCount: order
//                                                         .orderItems!.length,
//                                                     itemBuilder: (BuildContext
//                                                                 context,
//                                                             int innerindex) =>
//                                                         Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               left: 20,
//                                                               top: 20),
//                                                       child: Column(
//                                                         children: [
//                                                           Row(
//                                                             children: [
//                                                               Text(
//                                                                 order
//                                                                     .orderItems![
//                                                                         innerindex]
//                                                                     .itemName
//                                                                     .toString(),
//                                                                 style: TextStyle(
//                                                                     fontFamily:
//                                                                         Constants
//                                                                             .appFont,
//                                                                     fontSize:
//                                                                         12),
//                                                               ),
//                                                               Padding(
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                             .only(
//                                                                         left:
//                                                                             5),
//                                                                 child: Text(
//                                                                     (() {
//                                                                       String
//                                                                           qty =
//                                                                           '';
//                                                                       if (order.orderItems!.length >
//                                                                               0 &&
//                                                                           order.orderItems !=
//                                                                               null) {
//                                                                         // for (int i = 0; i < _orderHistoryController.listOrderHistory[index].orderItems.length; i++) {
//                                                                         qty =
//                                                                             ' X ${order.orderItems![innerindex].qty.toString()}';
//                                                                         // }
//                                                                         return qty;
//                                                                       } else {
//                                                                         return '';
//                                                                       }
//                                                                     }()),
//                                                                     style: TextStyle(
//                                                                         color: Color(Constants
//                                                                             .colorTheme),
//                                                                         fontFamily:
//                                                                             Constants
//                                                                                 .appFont,
//                                                                         fontSize:
//                                                                             12)),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     height: ScreenUtil()
//                                                         .setHeight(10),
//                                                   ),
//                                                   //Order Cancel
//                                                   if (order.payment_type == "INCOMPLETE ORDER")
//                                                     Column(
//                                                       children: [
//                                                         Container(
//                                                             height: ScreenUtil()
//                                                                 .setHeight(40),
//                                                             child:
//                                                                 GestureDetector(
//                                                               onTap: () {
//                                                                 _cartController
//                                                                         .cartMaster =
//                                                                     CartMaster.fromMap(
//                                                                         jsonDecode(
//                                                                             order.orderData!));
//                                                                 _cartController
//                                                                         .cartMaster
//                                                                         ?.oldOrderId =
//                                                                     order.id;
//                                                                 _cartController
//                                                                         .tableNumber =
//                                                                     order
//                                                                         .tableNo;
//                                                                 Get.to(() =>
//                                                                     PosMenu(
//                                                                         isDining:
//                                                                             true));
//                                                               },
//                                                               child: Align(
//                                                                   alignment:
//                                                                       Alignment
//                                                                           .center,
//                                                                   child: Text(
//                                                                       'Edit This Order')),
//                                                             )),
//                                                       ],
//                                                     ),
//                                                   if (order.orderStatus ==
//                                                           'PENDING' ||
//                                                       order.orderStatus ==
//                                                           'APPROVE')
//                                                     Container(
//                                                       height: ScreenUtil()
//                                                           .setHeight(50),
//                                                       child: ElevatedButton(
//                                                         style: ElevatedButton
//                                                             .styleFrom(
//                                                           primary: Colors.white,
//                                                           shape: RoundedRectangleBorder(
//                                                               borderRadius: BorderRadius.only(
//                                                                   bottomLeft: Radius
//                                                                       .circular(
//                                                                           20),
//                                                                   bottomRight: Radius
//                                                                       .circular(
//                                                                           20)),
//                                                               side: BorderSide
//                                                                   .none),
//                                                         ),
//                                                         onPressed: () async {
//                                                           await showCancelOrderDialog(
//                                                               order.id);
//                                                           setState(() {
//                                                             orderHistoryRef =
//                                                                 _orderHistoryController
//                                                                     .refreshOrderHistory(
//                                                                         context);
//                                                           });
//                                                         },
//                                                         child: RichText(
//                                                           text: TextSpan(
//                                                             children: [
//                                                               WidgetSpan(
//                                                                 child: Padding(
//                                                                   padding: EdgeInsets.only(
//                                                                       right: ScreenUtil()
//                                                                           .setHeight(
//                                                                               10)),
//                                                                   child:
//                                                                       SvgPicture
//                                                                           .asset(
//                                                                     'images/ic_cancel.svg',
//                                                                     width: ScreenUtil()
//                                                                         .setWidth(
//                                                                             20),
//                                                                     //color: Color(Constants.colorRate),
//                                                                     height: ScreenUtil()
//                                                                         .setHeight(
//                                                                             20),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               TextSpan(
//                                                                 text:
//                                                                     'Cancel this order',
//                                                                 style: TextStyle(
//                                                                     color: Color(
//                                                                         Constants
//                                                                             .colorLike),
//                                                                     fontSize:
//                                                                         18,
//                                                                     fontFamily:
//                                                                         Constants
//                                                                             .appFont),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   (() {
//                                                     if (order.orderStatus ==
//                                                             'CANCEL' ||
//                                                         order.orderStatus ==
//                                                             'COMPLETE') {
//                                                       return Container();
//                                                       // return Container(
//                                                       //   height: ScreenUtil()
//                                                       //       .setHeight(
//                                                       //       40),
//                                                       //   child:
//                                                       //   ElevatedButton(
//                                                       //     style: ElevatedButton.styleFrom(
//                                                       //       primary: Colors.white,
//                                                       //       shape: RoundedRectangleBorder(
//                                                       //           borderRadius:
//                                                       //           BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
//                                                       //           side: BorderSide.none),
//                                                       //     ),
//                                                       //     onPressed:
//                                                       //         () {
//                                                       //       Navigator.of(context).push(Transitions(
//                                                       //           transitionType: TransitionType.fade,
//                                                       //           curve: Curves.bounceInOut,
//                                                       //           reverseCurve: Curves.fastLinearToSlowEaseIn,
//                                                       //           widget: OrderReviewScreen(
//                                                       //             orderId: _orderHistoryController.listOrderHistory[index].id,
//                                                       //           )));
//                                                       //     },
//                                                       //     child: RichText(
//                                                       //       text:
//                                                       //       TextSpan(
//                                                       //         children: [
//                                                       //           WidgetSpan(
//                                                       //             child: Padding(
//                                                       //               padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
//                                                       //               child: SvgPicture.asset(
//                                                       //                 'images/ic_star.svg',
//                                                       //                 width: ScreenUtil().setWidth(20),
//                                                       //                 color: Color(Constants.colorRate),
//                                                       //                 height: ScreenUtil().setHeight(20),
//                                                       //               ),
//                                                       //             ),
//                                                       //           ),
//                                                       //           TextSpan(
//                                                       //             text: (() {
//                                                       //               // your code here
//                                                       //               // _orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' ? 'Ordered on ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}' : 'Delivered on October 10,2020, 09:23pm',
//                                                       //               if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL' || _orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//                                                       //                 return 'Rate Now';
//                                                       //               } else {
//                                                       //                 return '';
//                                                       //               }
//                                                       //             }()),
//                                                       //             style: TextStyle(color: Color(Constants.colorRate), fontSize: 18, fontFamily: Constants.appFont),
//                                                       //           ),
//                                                       //         ],
//                                                       //       ),
//                                                       //     ),
//                                                       //
//                                                       //   ),
//                                                       // );
//                                                     } else {
//                                                       return Container();
//                                                     }
//                                                   }()),
//                                                   if (order.orderStatus !=
//                                                           'COMPLETE' &&
//                                                       order.orderStatus !=
//                                                           'CANCEL' &&
//                                                       order.deliveryType ==
//                                                           'DINING')
//                                                     Container(
//                                                       height: ScreenUtil()
//                                                           .setHeight(40),
//                                                       child: ElevatedButton(
//                                                         style: ElevatedButton
//                                                             .styleFrom(
//                                                           primary: Color(
//                                                               Constants
//                                                                   .colorTheme),
//                                                           shape: RoundedRectangleBorder(
//                                                               borderRadius: BorderRadius.only(
//                                                                   bottomLeft: Radius
//                                                                       .circular(
//                                                                           20),
//                                                                   bottomRight: Radius
//                                                                       .circular(
//                                                                           20)),
//                                                               side: BorderSide
//                                                                   .none),
//                                                         ),
//                                                         onPressed: () {
//                                                           // showCancelOrderDialog(_orderHistoryController.listOrderHistory[index].id);
//                                                         },
//                                                         child: RichText(
//                                                           text: TextSpan(
//                                                             children: [
//                                                               TextSpan(
//                                                                 text:
//                                                                     'Live Order',
//                                                                 style:
//                                                                     TextStyle(
//                                                                   color: Colors
//                                                                       .white,
//                                                                   fontSize: 18,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                 ],
//                                               )),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                           // return ListTile(
//                           //   title: Text(order.amount.toString()),
//                           //   subtitle: Text(order.deliveryType.toString()),
//                           // );
//                         },
//                       );
//                     } else if (snapshot.hasError) {
//                       // handle the error here
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else {
//                       return Center(child: Text('No Orders History'));
//                     }
//                   },
//                 ),
//               ),
//               // Expanded(
//               //   child: Obx(
//               //         () => ListView.builder(
//               //           padding: EdgeInsets.only(
//               //               bottom: 100, left: 10, right: 10),
//               //           scrollDirection: Axis.vertical,
//               //       itemCount: _getFilteredOrders().length,
//               //       itemBuilder: (BuildContext context, int index) {
//               //         final order = _getFilteredOrders()[index];
//               //
//               //         return  ListTile(
//               //           title: Text("${order.amount}"),
//               //           subtitle: Text(order.deliveryType!),
//               //         );
//               //       },
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//         // body: FutureBuilder<BaseModel<OrderHistoryListModel>>(
//         //     future: orderHistoryRef,
//         //     builder: (context, snapshot) {
//         //       if (snapshot.hasData) {
//         //         return ListView.builder(
//         //             padding: EdgeInsets.only(
//         //                 bottom: 100, left: 10, right: 10),
//         //             scrollDirection: Axis.vertical,
//         //             itemCount: _getFilteredOrders().length,
//         //             itemBuilder:
//         //                 (BuildContext context, int index) {
//         //               OrderHistoryData order = _getFilteredOrders()[index];
//         //               return ListTile(
//         //                 title: Text(order.deliveryType!),
//         //               );
//         //             }
//         //         );
//         //       }
//         //
//         //       else {
//         //         return Container();
//         //       }
//         //     }),
//       ),
//     );
//   }
//
//   ///Container Main Code]
//   //                 return Container(
//   //                 height: MediaQuery.of(context).size.height,
//   //                 decoration: BoxDecoration(
//   //                     color: Color(Constants.colorScreenBackGround),
//   //                     image: DecorationImage(
//   //                       image: AssetImage('images/ic_background_image.png'),
//   //                       fit: BoxFit.cover,
//   //                     )),
//   //                 child: _orderHistoryController.listOrderHistory.length == 0
// //                       ? Center(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.stretch,
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               Image(
// //                                 width: 150,
// //                                 height: 180,
// //                                 image: AssetImage(
// //                                     'images/ic_no_order_history.png'),
// //                               ),
// //                               Text(
// //                                 'No Order History',
// //                                 textAlign: TextAlign.center,
// //                                 style: TextStyle(
// //                                   fontSize: ScreenUtil().setSp(18),
// //                                   fontFamily: Constants.appFontBold,
// //                                   color: Color(Constants.colorTheme),
// //                                 ),
// //                               )
// //                             ],
// //                           ),
// //                         )
// //                       : Column(
// //                           children: [
// //                             SizedBox(height: 5),
// //                             Row(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 delieveryTypeButton(
// //                                     onTap: () =>
// //                                         _applyFilter(FilterType.DineIn),
// //                                     icon: Icons.card_travel,
// //                                     title: "Dine In",
// //                                     style: TextStyle(
// //                                         color: _filterType == FilterType.DineIn
// //                                             ? Colors.white
// //                                             : Colors.black),
// //                                     color: _filterType == FilterType.DineIn
// //                                         ? Colors.white
// //                                         : Colors.black,
// //                                     buttonColor:
// //                                         _filterType == FilterType.DineIn
// //                                             ? Colors.red.shade500
// //                                             : Colors.white),
// //                                 // ElevatedButton(
// //                                 //     style: ElevatedButton.styleFrom(
// //                                 //       backgroundColor:_filterType == FilterType.DineIn ?  Colors.red.shade500  :  Colors.white, // Background color
// //                                 //     ),
// //                                 //     onPressed:  () => _applyFilter(FilterType.DineIn), child: Text("Dine In", style: TextStyle(
// //                                 //   color:  _filterType == FilterType.DineIn ? Colors.white  :  Colors.black
// //                                 // ),)),
// //                                 SizedBox(
// //                                   width: 5,
// //                                 ),
// //                                 delieveryTypeButton(
// //                                     onTap: () =>
// //                                         _applyFilter(FilterType.TakeAway),
// //                                     icon: Icons.table_bar,
// //                                     title: "TakeAway",
// //                                     style: TextStyle(
// //                                         color:
// //                                             _filterType == FilterType.TakeAway
// //                                                 ? Colors.white
// //                                                 : Colors.black),
// //                                     color: _filterType == FilterType.TakeAway
// //                                         ? Colors.white
// //                                         : Colors.black,
// //                                     buttonColor:
// //                                         _filterType == FilterType.TakeAway
// //                                             ? Colors.red.shade500
// //                                             : Colors.white),
// //                                 // ElevatedButton(
// //                                 //     style: ElevatedButton.styleFrom(
// //                                 //       backgroundColor: _filterType == FilterType.TakeAway ? Colors.red.shade500  :  Colors.white, // Background color
// //                                 //     ),
// //                                 //     onPressed:  () => _applyFilter(FilterType.TakeAway), child: Text("TakeAway", style: TextStyle(
// //                                 //     color:  _filterType == FilterType.TakeAway ? Colors.white  :  Colors.black
// //                                 // ),)),
// //                               ],
// //                             ),
// //
// //                             Expanded(
// //                               child: Obx(() => ListView.builder(
// //                                   padding: EdgeInsets.only(
// //                                       bottom: 100, left: 10, right: 10),
// //                                   scrollDirection: Axis.vertical,
// //                                   itemCount: _getFilteredOrders().length,
// //                                   itemBuilder:
// //                                       (BuildContext context, int index) {
// //                                     return Column(
// //                                       crossAxisAlignment:
// //                                           CrossAxisAlignment.stretch,
// //                                       children: [
// //                                         Padding(
// //                                           padding: const EdgeInsets.only(
// //                                               top: 10, right: 10),
// //                                           child: Text(
// //                                             (() {
// //                                                   if (_orderHistoryController
// //                                                           .listOrderHistory[
// //                                                               index]
// //                                                           .addressId !=
// //                                                       null) {
// //                                                     if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'PENDING') {
// //                                                       return '${'Ordered On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     } else if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'ACCEPT') {
// //                                                       return '${'Accepted On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     } else if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'APPROVE') {
// //                                                       return '${'Approve On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     } else if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'REJECT') {
// //                                                       return '${'Rejected On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     } else if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'PICKUP') {
// //                                                       return '${'Pickedup On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     } else if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'DELIVERED') {
// //                                                       return '${'Delivered On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     } else if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'CANCEL') {
// //                                                       return 'Canceled On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     } else if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'COMPLETE') {
// //                                                       return 'Delivered On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     }
// //                                                   } else {
// //                                                     if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'PENDING') {
// //                                                       return 'Ordered On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     } else if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'ACCEPT') {
// //                                                       return 'Accepted On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     } else if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'APPROVE') {
// //                                                       return 'Approve On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     } else if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'REJECT') {
// //                                                       return 'Rejected On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     } else if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'PREPARE_FOR_ORDER') {
// //                                                       return 'PREPARE FOR ORDER ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     } else if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'READY_FOR_ORDER') {
// //                                                       return 'READY FOR ORDER ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     } else if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'CANCEL') {
// //                                                       return 'Canceled On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     } else if (_orderHistoryController
// //                                                             .listOrderHistory[
// //                                                                 index]
// //                                                             .orderStatus ==
// //                                                         'COMPLETE') {
// //                                                       return 'Delivered On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
// //                                                     }
// //                                                   }
// //                                                 }()) ??
// //                                                 '',
// //                                             style: TextStyle(
// //                                                 color:
// //                                                     Color(Constants.colorGray),
// //                                                 fontFamily: Constants.appFont,
// //                                                 fontSize: 12),
// //                                             textAlign: TextAlign.end,
// //                                           ),
// //                                         ),
// //                                         GestureDetector(
// //                                           onTap: () {
// //                                             print(
// //                                                 " orderData is .. ${_orderHistoryController.listOrderHistory[index].deliveryType}");
// //                                             // // Constants.toastMessage(_orderHistoryController.listOrderHistory[index].id.toString());
// //                                             // Navigator.of(context).push(
// //                                             //     Transitions(
// //                                             //         transitionType:
// //                                             //         TransitionType.fade,
// //                                             //         curve:
// //                                             //         Curves.bounceInOut,
// //                                             //         reverseCurve: Curves
// //                                             //             .fastLinearToSlowEaseIn,
// //                                             //         widget:
// //                                             //         OrderDetailsScreen(
// //                                             //           orderId:
// //                                             //           _orderHistoryController.listOrderHistory[
// //                                             //           index]
// //                                             //               .id,
// //                                             //           orderDate:
// //                                             //           _orderHistoryController.listOrderHistory[
// //                                             //           index]
// //                                             //               .date,
// //                                             //           orderTime:
// //                                             //           _orderHistoryController.listOrderHistory[
// //                                             //           index]
// //                                             //               .time,
// //                                             //         )));
// //                                           },
// //                                           child: Card(
// //                                             shape: RoundedRectangleBorder(
// //                                               borderRadius:
// //                                                   BorderRadius.circular(20.0),
// //                                             ),
// //                                             margin: EdgeInsets.only(
// //                                                 top: 20,
// //                                                 left: 16,
// //                                                 right: 16,
// //                                                 bottom: 20),
// //                                             child: Column(
// //                                               children: [
// //                                                 // (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' || _orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE')?
// //                                                 //
// //                                                 // GestureDetector(
// //                                                 //   onTap: (){
// //                                                 //     showCancelOrderDialog(_orderHistoryController.listOrderHistory[index].id);
// //                                                 //   },
// //                                                 //   child: Padding(
// //                                                 //     padding: const EdgeInsets
// //                                                 //         .only(
// //                                                 //         top: 10,
// //                                                 //         right:
// //                                                 //         20),
// //                                                 //     child:
// //                                                 //     RichText(
// //                                                 //       text:
// //                                                 //       TextSpan(
// //                                                 //         children: [
// //                                                 //           WidgetSpan(
// //                                                 //             child:
// //                                                 //             Padding(
// //                                                 //               padding: const EdgeInsets.only(right: 5),
// //                                                 //               child: SvgPicture.asset('images/ic_cancel.svg',
// //                                                 //
// //                                                 //                 //  color: Color(Constants.colorTheme),
// //                                                 //                 width: 15,
// //                                                 //                 height: ScreenUtil().setHeight(15),
// //                                                 //               ),
// //                                                 //             ),
// //                                                 //           ),
// //                                                 //           TextSpan(
// //                                                 //               text: 'Cancel this order',
// //                                                 //               style: TextStyle(
// //                                                 //                   color: Color(Constants.colorLike),
// //                                                 //                   fontFamily: Constants.appFont,
// //                                                 //                   fontSize: 12)),
// //                                                 //         ],
// //                                                 //       ),
// //                                                 //     ),
// //                                                 //   ),
// //                                                 // ):Container(),
// //
// //                                                 Row(
// //                                                   crossAxisAlignment:
// //                                                       CrossAxisAlignment.start,
// //                                                   children: [
// //                                                     // Padding(
// //                                                     //   padding:
// //                                                     //   const EdgeInsets
// //                                                     //       .all(5.0),
// //                                                     //   child: ClipRRect(
// //                                                     //     borderRadius:
// //                                                     //     BorderRadius
// //                                                     //         .circular(
// //                                                     //         15.0),
// //                                                     //     child: CachedNetworkImage(
// //                                                     //       height:
// //                                                     //       100,
// //                                                     //       width:
// //                                                     //       100,
// //                                                     //       imageUrl:
// //                                                     //       _orderHistoryController.listOrderHistory[
// //                                                     //       index]
// //                                                     //           .vendor!
// //                                                     //           .image!,
// //                                                     //       fit: BoxFit.cover,
// //                                                     //       placeholder: (context,
// //                                                     //           url) =>
// //                                                     //           SpinKitFadingCircle(
// //                                                     //               color: Color(
// //                                                     //                   Constants
// //                                                     //                       .colorTheme)),
// //                                                     //       errorWidget:
// //                                                     //           (context, url,
// //                                                     //           error) =>
// //                                                     //           Container(
// //                                                     //             child: Center(
// //                                                     //                 child: Image.asset('images/noimage.png')),
// //                                                     //           ),
// //                                                     //     ),
// //                                                     //   ),
// //                                                     // ),
// //                                                     Expanded(
// //                                                       child: Column(
// //                                                         crossAxisAlignment:
// //                                                             CrossAxisAlignment
// //                                                                 .start,
// //                                                         children: [
// //                                                           Padding(
// //                                                             padding:
// //                                                                 const EdgeInsets
// //                                                                         .only(
// //                                                                     left: 10,
// //                                                                     top: 10),
// //                                                             child: Text(
// //                                                               "Order # ${_orderHistoryController.listOrderHistory[index].id.toString()} | ${_orderHistoryController.listOrderHistory[index].user!.name} | ${_orderHistoryController.listOrderHistory[index].vendor!.name!}",
// //                                                               style: TextStyle(
// //                                                                 fontFamily:
// //                                                                     Constants
// //                                                                         .appFontBold,
// //                                                                 fontSize: 12,
// //                                                                 color: Color(
// //                                                                     Constants
// //                                                                         .colorGray),
// //                                                               ),
// //                                                             ),
// //
// //                                                             // child: Row(
// //                                                             //   children: [
// //                                                             //     // Expanded(
// //                                                             //     //   flex: 4,
// //                                                             //     //   child:
// //                                                             //     //   Padding(
// //                                                             //     //     padding: const EdgeInsets
// //                                                             //     //         .only(
// //                                                             //     //         left:
// //                                                             //     //         10,
// //                                                             //     //         top:
// //                                                             //     //         10),
// //                                                             //     //     child: Text(
// //                                                             //     //       "Order # ${_orderHistoryController.listOrderHistory[index].id.toString()}",
// //                                                             //     //       style: TextStyle(
// //                                                             //     //           fontFamily:
// //                                                             //     //           Constants.appFontBold,
// //                                                             //     //           fontSize: 16),
// //                                                             //     //     ),
// //                                                             //     //     // Text(
// //                                                             //     //     //   _orderHistoryController.listOrderHistory[index]
// //                                                             //     //     //       .vendor!
// //                                                             //     //     //       .name!,
// //                                                             //     //     //   style: TextStyle(
// //                                                             //     //     //       fontFamily:
// //                                                             //     //     //       Constants.appFontBold,
// //                                                             //     //     //       fontSize: 16),
// //                                                             //     //     // ),
// //                                                             //     //   ),
// //                                                             //     // ),
// //                                                             //     Text(
// //                                                             //       "Order # ${_orderHistoryController.listOrderHistory[index].id.toString()} | ${_orderHistoryController.listOrderHistory[index].user!.name}",
// //                                                             //       style: TextStyle(
// //                                                             //           fontFamily:
// //                                                             //           Constants.appFontBold,
// //                                                             //           fontSize: 12,
// //                                                             //       color: Color(Constants.colorGray),
// //                                                             //       ),
// //                                                             //     ),
// //                                                             //     Text(
// //                                                             //       ,
// //                                                             //       style: TextStyle(
// //                                                             //           fontFamily:
// //                                                             //           Constants.appFontBold,
// //                                                             //           fontSize: 12,
// //                                                             //         color: Color(Constants.colorGray),
// //                                                             //       ),
// //                                                             //     ),
// //                                                             //   ],
// //                                                             // ),
// //                                                           ),
// //                                                           // Padding(
// //                                                           //   padding:
// //                                                           //   const EdgeInsets
// //                                                           //       .only(
// //                                                           //       top: 3,
// //                                                           //       left:
// //                                                           //       10,
// //                                                           //       right:
// //                                                           //       5),
// //                                                           //   child: Text(
// //                                                           //    _orderHistoryController.listOrderHistory[index].user!.name,
// //                                                           //     style: TextStyle(
// //                                                           //         fontFamily:
// //                                                           //         Constants.appFontBold,
// //                                                           //         fontSize: 12),
// //                                                           //   ),
// //                                                           // ),
// // ///Start vendor name
// //                                                           // Padding(
// //                                                           //   padding:
// //                                                           //       const EdgeInsets
// //                                                           //               .only(
// //                                                           //           top: 3,
// //                                                           //           left: 10,
// //                                                           //           right: 5),
// //                                                           //   child: Text(
// //                                                           //     _orderHistoryController
// //                                                           //         .listOrderHistory[
// //                                                           //             index]
// //                                                           //         .vendor!
// //                                                           //         .name!,
// //                                                           //     style: TextStyle(
// //                                                           //         fontFamily:
// //                                                           //             Constants
// //                                                           //                 .appFontBold,
// //                                                           //         fontSize: 10),
// //                                                           //   ),
// //                                                           // ),
// //                                                           ///End vendor Name
// //                                                           // Padding(
// //                                                           //   padding:
// //                                                           //   const EdgeInsets
// //                                                           //       .only(
// //                                                           //       top: 3,
// //                                                           //       left:
// //                                                           //       10,
// //                                                           //       right:
// //                                                           //       5),
// //                                                           //   child: Text(
// //                                                           //     _orderHistoryController.listOrderHistory[
// //                                                           //     index]
// //                                                           //         .vendor!
// //                                                           //         .mapAddress ?? '',
// //                                                           //     overflow:
// //                                                           //     TextOverflow
// //                                                           //         .ellipsis,
// //                                                           //     style: TextStyle(
// //                                                           //         fontFamily:
// //                                                           //         Constants
// //                                                           //             .appFont,
// //                                                           //         color: Color(
// //                                                           //             Constants
// //                                                           //                 .colorGray),
// //                                                           //         fontSize:
// //                                                           //         13),
// //                                                           //   ),
// //                                                           // ),
// //                                                           _orderHistoryController
// //                                                                           .listOrderHistory[
// //                                                                               index]
// //                                                                           .tableNo ==
// //                                                                       0 ||
// //                                                                   _orderHistoryController
// //                                                                           .listOrderHistory[
// //                                                                               index]
// //                                                                           .tableNo ==
// //                                                                       null
// //                                                               ? SizedBox()
// //                                                               : Padding(
// //                                                                   padding: const EdgeInsets
// //                                                                           .only(
// //                                                                       top: 3,
// //                                                                       left: 10,
// //                                                                       right: 5),
// //                                                                   child: Text(
// //                                                                     "Table No ${_orderHistoryController.listOrderHistory[index].tableNo.toString()}" ??
// //                                                                         '',
// //                                                                     overflow:
// //                                                                         TextOverflow
// //                                                                             .ellipsis,
// //                                                                     style: TextStyle(
// //                                                                         fontFamily:
// //                                                                             Constants
// //                                                                                 .appFontBold,
// //                                                                         fontSize:
// //                                                                             16),
// //                                                                   ),
// //                                                                 ),
// //                                                           SizedBox(
// //                                                             height: ScreenUtil()
// //                                                                 .setHeight(10),
// //                                                           ),
// //
// //                                                           Row(
// //                                                             children: [
// //                                                               Expanded(
// //                                                                 child: Padding(
// //                                                                   padding: const EdgeInsets
// //                                                                           .only(
// //                                                                       left: 10,
// //                                                                       top: 10),
// //                                                                   child: Text(
// //                                                                     AuthController
// //                                                                             .sharedPreferences
// //                                                                             ?.getString(Constants
// //                                                                                 .appSettingCurrencySymbol) ??
// //                                                                         '' +
// //                                                                             '${_orderHistoryController.listOrderHistory[index].amount}',
// //                                                                     style: TextStyle(
// //                                                                         fontFamily:
// //                                                                             Constants
// //                                                                                 .appFont,
// //                                                                         fontSize:
// //                                                                             14),
// //                                                                   ),
// //                                                                 ),
// //                                                               ),
// //                                                               Padding(
// //                                                                 padding:
// //                                                                     const EdgeInsets
// //                                                                             .only(
// //                                                                         top: 10,
// //                                                                         right:
// //                                                                             20),
// //                                                                 child: RichText(
// //                                                                   text:
// //                                                                       TextSpan(
// //                                                                     children: [
// //                                                                       WidgetSpan(
// //                                                                         child:
// //                                                                             Padding(
// //                                                                           padding:
// //                                                                               const EdgeInsets.only(right: 5),
// //                                                                           child:
// //                                                                               SvgPicture.asset(
// //                                                                             (() {
// //                                                                                   if (_orderHistoryController.listOrderHistory[index].addressId != null) {
// //                                                                                     if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
// //                                                                                       return 'images/ic_pending.svg';
// //                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
// //                                                                                       return 'images/ic_accept.svg';
// //                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
// //                                                                                       return 'images/ic_accept.svg';
// //                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
// //                                                                                       return 'images/ic_cancel.svg';
// //                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
// //                                                                                       return 'images/ic_pickup.svg';
// //                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
// //                                                                                       return 'images/ic_completed.svg';
// //                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
// //                                                                                       return 'images/ic_cancel.svg';
// //                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
// //                                                                                       return 'images/ic_completed.svg';
// //                                                                                     } else {
// //                                                                                       return 'images/ic_accept.svg';
// //                                                                                     }
// //                                                                                   } else {
// //                                                                                     if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
// //                                                                                       return 'images/ic_pending.svg';
// //                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
// //                                                                                       return 'images/ic_accept.svg';
// //                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
// //                                                                                       return 'images/ic_pickup.svg';
// //                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
// //                                                                                       return 'images/ic_completed.svg';
// //                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
// //                                                                                       return 'images/ic_cancel.svg';
// //                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
// //                                                                                       return 'images/ic_cancel.svg';
// //                                                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
// //                                                                                       return 'images/ic_completed.svg';
// //                                                                                     }
// //                                                                                   }
// //                                                                                 }()) ??
// //                                                                                 '',
// //                                                                             color:
// //                                                                                 (() {
// //                                                                               // your code here
// //                                                                               // _orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' ? 'Ordered on ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}' : 'Delivered on October 10,2020, 09:23pm',
// //                                                                               if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
// //                                                                                 return Color(Constants.colorOrderPending);
// //                                                                               } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
// //                                                                                 return Color(Constants.colorBlack);
// //                                                                               } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
// //                                                                                 return Color(Constants.colorOrderPickup);
// //                                                                               }
// //                                                                             }()),
// //                                                                             width:
// //                                                                                 15,
// //                                                                             height:
// //                                                                                 ScreenUtil().setHeight(15),
// //                                                                           ),
// //                                                                         ),
// //                                                                       ),
// //                                                                       TextSpan(
// //                                                                           text:
// //                                                                               (() {
// //                                                                             if (_orderHistoryController.listOrderHistory[index].deliveryType ==
// //                                                                                 'TAKEAWAY') {
// //                                                                               if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
// //                                                                                 return 'Waiting For User To Pickup';
// //                                                                               }
// //                                                                             } else {
// //                                                                               if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP' || _orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
// //                                                                                 return 'Waiting For Driver To Pickup';
// //                                                                               }
// //                                                                             }
// //                                                                             return _orderHistoryController.listOrderHistory[index].orderStatus;
// //                                                                             // if (_orderHistoryController.listOrderHistory[index].addressId != null) {
// //                                                                             //
// //                                                                             //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
// //                                                                             //     return Languages.of(context)!.labelOrderPending;
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
// //                                                                             //     return Languages.of(context)!.labelOrderAccepted;
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
// //                                                                             //     return Languages.of(context)!.labelOrderAccepted;
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
// //                                                                             //     return Languages.of(context)!.labelOrderRejected;
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
// //                                                                             //     return 'PREPARING FOOD';
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
// //                                                                             //     return 'READY TO PICKUP';
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
// //                                                                             //     return Languages.of(context)!.labelOrderPickedUp;
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
// //                                                                             //     return Languages.of(context)!.labelDeliveredSuccess;
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
// //                                                                             //     return Languages.of(context)!.labelOrderCanceled;
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
// //                                                                             //     return Languages.of(context)!.labelOrderCompleted;
// //                                                                             //   }
// //                                                                             // } else {
// //                                                                             //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
// //                                                                             //     return Languages.of(context)!.labelOrderPending;
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
// //                                                                             //     return Languages.of(context)!.labelOrderAccepted;
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
// //                                                                             //     return Languages.of(context)!.labelOrderAccepted;
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
// //                                                                             //     return 'PREPARING FOOD';
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
// //                                                                             //     return 'READY TO PICKUP';
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
// //                                                                             //     return Languages.of(context)!.labelOrderRejected;
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
// //                                                                             //     return Languages.of(context)!.labelOrderCompleted;
// //                                                                             //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
// //                                                                             //     return Languages.of(context)!.labelOrderCanceled;
// //                                                                             //   }
// //                                                                             // }
// //                                                                           }()),
// //                                                                           style: TextStyle(
// //                                                                               color: (() {
// //                                                                                 if (_orderHistoryController.listOrderHistory[index].addressId != null) {
// //                                                                                   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
// //                                                                                     return Color(Constants.colorOrderPending);
// //                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
// //                                                                                     return Color(Constants.colorBlack);
// //                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
// //                                                                                     return Color(Constants.colorBlack);
// //                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
// //                                                                                     return Color(Constants.colorLike);
// //                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
// //                                                                                     return Color(Constants.colorOrderPickup);
// //                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
// //                                                                                     return Color(Constants.colorTheme);
// //                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
// //                                                                                     return Color(Constants.colorLike);
// //                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
// //                                                                                     return Color(Constants.colorTheme);
// //                                                                                   } else {
// //                                                                                     return Color(Constants.colorTheme);
// //                                                                                   }
// //                                                                                 } else {
// //                                                                                   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
// //                                                                                     return Color(Constants.colorOrderPending);
// //                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
// //                                                                                     return Color(Constants.colorBlack);
// //                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
// //                                                                                     return Color(Constants.colorBlack);
// //                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
// //                                                                                     return Color(Constants.colorLike);
// //                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
// //                                                                                     return Color(Constants.colorOrderPickup);
// //                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
// //                                                                                     return Color(Constants.colorTheme);
// //                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
// //                                                                                     return Color(Constants.colorLike);
// //                                                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
// //                                                                                     return Color(Constants.colorTheme);
// //                                                                                   } else {
// //                                                                                     return Color(Constants.colorTheme);
// //                                                                                   }
// //                                                                                 }
// //                                                                               }()),
// //                                                                               fontFamily: Constants.appFont,
// //                                                                               fontSize: 12)),
// //                                                                     ],
// //                                                                   ),
// //                                                                 ),
// //                                                               )
// //                                                             ],
// //                                                           ),
// //                                                         ],
// //                                                       ),
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                                 Padding(
// //                                                   padding:
// //                                                       const EdgeInsets.only(
// //                                                           left: 5,
// //                                                           right: 5,
// //                                                           top: 20),
// //                                                   child: DottedLine(
// //                                                     dashColor:
// //                                                         Color(0xffcccccc),
// //                                                   ),
// //                                                 ),
// //                                                 Row(
// //                                                   children: [
// //                                                     Expanded(
// //                                                         flex: 5,
// //                                                         child: Column(
// //                                                           crossAxisAlignment:
// //                                                               CrossAxisAlignment
// //                                                                   .stretch,
// //                                                           children: [
// //                                                             ListView.builder(
// //                                                               physics:
// //                                                                   ClampingScrollPhysics(),
// //                                                               shrinkWrap: true,
// //                                                               scrollDirection:
// //                                                                   Axis.vertical,
// //                                                               itemCount:
// //                                                                   _orderHistoryController
// //                                                                       .listOrderHistory[
// //                                                                           index]
// //                                                                       .orderItems!
// //                                                                       .length,
// //                                                               itemBuilder: (BuildContext
// //                                                                           context,
// //                                                                       int innerindex) =>
// //                                                                   Padding(
// //                                                                 padding:
// //                                                                     const EdgeInsets
// //                                                                             .only(
// //                                                                         left:
// //                                                                             20,
// //                                                                         top:
// //                                                                             20),
// //                                                                 child: Column(
// //                                                                   children: [
// //                                                                     Row(
// //                                                                       children: [
// //                                                                         Text(
// //                                                                           _orderHistoryController
// //                                                                               .listOrderHistory[index]
// //                                                                               .orderItems![innerindex]
// //                                                                               .itemName
// //                                                                               .toString(),
// //                                                                           style: TextStyle(
// //                                                                               fontFamily: Constants.appFont,
// //                                                                               fontSize: 12),
// //                                                                         ),
// //                                                                         Padding(
// //                                                                           padding:
// //                                                                               const EdgeInsets.only(left: 5),
// //                                                                           child: Text(
// //                                                                               (() {
// //                                                                                 String qty = '';
// //                                                                                 if (_orderHistoryController.listOrderHistory[index].orderItems!.length > 0 && _orderHistoryController.listOrderHistory[index].orderItems != null) {
// //                                                                                   // for (int i = 0; i < _orderHistoryController.listOrderHistory[index].orderItems.length; i++) {
// //                                                                                   qty = ' X ${_orderHistoryController.listOrderHistory[index].orderItems![innerindex].qty.toString()}';
// //                                                                                   // }
// //                                                                                   return qty;
// //                                                                                 } else {
// //                                                                                   return '';
// //                                                                                 }
// //                                                                               }()),
// //                                                                               style: TextStyle(color: Color(Constants.colorTheme), fontFamily: Constants.appFont, fontSize: 12)),
// //                                                                         ),
// //                                                                       ],
// //                                                                     ),
// //                                                                   ],
// //                                                                 ),
// //                                                               ),
// //                                                             ),
// //                                                             SizedBox(
// //                                                               height:
// //                                                                   ScreenUtil()
// //                                                                       .setHeight(
// //                                                                           10),
// //                                                             ),
// //                                                             //Order Cancel
// //                                                             if (_orderHistoryController
// //                                                                         .listOrderHistory[
// //                                                                             index]
// //                                                                         .deliveryType ==
// //                                                                     'DINING' &&
// //                                                                 _orderHistoryController
// //                                                                         .listOrderHistory[
// //                                                                             index]
// //                                                                         .orderStatus !=
// //                                                                     'COMPLETE')
// //                                                               Column(
// //                                                                 children: [
// //                                                                   Container(
// //                                                                       height: ScreenUtil()
// //                                                                           .setHeight(
// //                                                                               40),
// //                                                                       child:
// //                                                                           GestureDetector(
// //                                                                         onTap:
// //                                                                             () {
// //                                                                           _cartController.cartMaster = CartMaster.fromMap(jsonDecode(_orderHistoryController
// //                                                                               .listOrderHistory[index]
// //                                                                               .orderData!));
// //                                                                           _cartController
// //                                                                               .cartMaster
// //                                                                               ?.oldOrderId = _orderHistoryController.listOrderHistory[index].id;
// //                                                                           _cartController.tableNumber = _orderHistoryController
// //                                                                               .listOrderHistory[index]
// //                                                                               .tableNo;
// //                                                                           Get.to(() =>
// //                                                                               PosMenu(isDining: true));
// //                                                                         },
// //                                                                         child: Align(
// //                                                                             alignment:
// //                                                                                 Alignment.center,
// //                                                                             child: Text('Edit This Order')),
// //                                                                       )),
// //                                                                 ],
// //                                                               ),
// //                                                             if (_orderHistoryController
// //                                                                         .listOrderHistory[
// //                                                                             index]
// //                                                                         .orderStatus ==
// //                                                                     'PENDING' ||
// //                                                                 _orderHistoryController
// //                                                                         .listOrderHistory[
// //                                                                             index]
// //                                                                         .orderStatus ==
// //                                                                     'APPROVE')
// //                                                               Container(
// //                                                                 height:
// //                                                                     ScreenUtil()
// //                                                                         .setHeight(
// //                                                                             50),
// //                                                                 child:
// //                                                                     ElevatedButton(
// //                                                                   style: ElevatedButton
// //                                                                       .styleFrom(
// //                                                                     primary: Colors
// //                                                                         .white,
// //                                                                     shape: RoundedRectangleBorder(
// //                                                                         borderRadius: BorderRadius.only(
// //                                                                             bottomLeft: Radius.circular(
// //                                                                                 20),
// //                                                                             bottomRight: Radius.circular(
// //                                                                                 20)),
// //                                                                         side: BorderSide
// //                                                                             .none),
// //                                                                   ),
// //                                                                   onPressed:
// //                                                                       () async {
// //                                                                     await showCancelOrderDialog(_orderHistoryController
// //                                                                         .listOrderHistory[
// //                                                                             index]
// //                                                                         .id);
// //                                                                     setState(
// //                                                                         () {
// //                                                                       orderHistoryRef =
// //                                                                           _orderHistoryController
// //                                                                               .refreshOrderHistory(context);
// //                                                                     });
// //                                                                   },
// //                                                                   child:
// //                                                                       RichText(
// //                                                                     text:
// //                                                                         TextSpan(
// //                                                                       children: [
// //                                                                         WidgetSpan(
// //                                                                           child:
// //                                                                               Padding(
// //                                                                             padding:
// //                                                                                 EdgeInsets.only(right: ScreenUtil().setHeight(10)),
// //                                                                             child:
// //                                                                                 SvgPicture.asset(
// //                                                                               'images/ic_cancel.svg',
// //                                                                               width: ScreenUtil().setWidth(20),
// //                                                                               //color: Color(Constants.colorRate),
// //                                                                               height: ScreenUtil().setHeight(20),
// //                                                                             ),
// //                                                                           ),
// //                                                                         ),
// //                                                                         TextSpan(
// //                                                                           text:
// //                                                                               'Cancel this order',
// //                                                                           style: TextStyle(
// //                                                                               color: Color(Constants.colorLike),
// //                                                                               fontSize: 18,
// //                                                                               fontFamily: Constants.appFont),
// //                                                                         ),
// //                                                                       ],
// //                                                                     ),
// //                                                                   ),
// //                                                                 ),
// //                                                               ),
// //                                                             (() {
// //                                                               if (_orderHistoryController
// //                                                                           .listOrderHistory[
// //                                                                               index]
// //                                                                           .orderStatus ==
// //                                                                       'CANCEL' ||
// //                                                                   _orderHistoryController
// //                                                                           .listOrderHistory[
// //                                                                               index]
// //                                                                           .orderStatus ==
// //                                                                       'COMPLETE') {
// //                                                                 return Container();
// //                                                                 // return Container(
// //                                                                 //   height: ScreenUtil()
// //                                                                 //       .setHeight(
// //                                                                 //       40),
// //                                                                 //   child:
// //                                                                 //   ElevatedButton(
// //                                                                 //     style: ElevatedButton.styleFrom(
// //                                                                 //       primary: Colors.white,
// //                                                                 //       shape: RoundedRectangleBorder(
// //                                                                 //           borderRadius:
// //                                                                 //           BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
// //                                                                 //           side: BorderSide.none),
// //                                                                 //     ),
// //                                                                 //     onPressed:
// //                                                                 //         () {
// //                                                                 //       Navigator.of(context).push(Transitions(
// //                                                                 //           transitionType: TransitionType.fade,
// //                                                                 //           curve: Curves.bounceInOut,
// //                                                                 //           reverseCurve: Curves.fastLinearToSlowEaseIn,
// //                                                                 //           widget: OrderReviewScreen(
// //                                                                 //             orderId: _orderHistoryController.listOrderHistory[index].id,
// //                                                                 //           )));
// //                                                                 //     },
// //                                                                 //     child: RichText(
// //                                                                 //       text:
// //                                                                 //       TextSpan(
// //                                                                 //         children: [
// //                                                                 //           WidgetSpan(
// //                                                                 //             child: Padding(
// //                                                                 //               padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
// //                                                                 //               child: SvgPicture.asset(
// //                                                                 //                 'images/ic_star.svg',
// //                                                                 //                 width: ScreenUtil().setWidth(20),
// //                                                                 //                 color: Color(Constants.colorRate),
// //                                                                 //                 height: ScreenUtil().setHeight(20),
// //                                                                 //               ),
// //                                                                 //             ),
// //                                                                 //           ),
// //                                                                 //           TextSpan(
// //                                                                 //             text: (() {
// //                                                                 //               // your code here
// //                                                                 //               // _orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' ? 'Ordered on ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}' : 'Delivered on October 10,2020, 09:23pm',
// //                                                                 //               if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL' || _orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
// //                                                                 //                 return 'Rate Now';
// //                                                                 //               } else {
// //                                                                 //                 return '';
// //                                                                 //               }
// //                                                                 //             }()),
// //                                                                 //             style: TextStyle(color: Color(Constants.colorRate), fontSize: 18, fontFamily: Constants.appFont),
// //                                                                 //           ),
// //                                                                 //         ],
// //                                                                 //       ),
// //                                                                 //     ),
// //                                                                 //
// //                                                                 //   ),
// //                                                                 // );
// //                                                               } else {
// //                                                                 return Container();
// //                                                               }
// //                                                             }()),
// //                                                             if (_orderHistoryController
// //                                                                         .listOrderHistory[
// //                                                                             index]
// //                                                                         .orderStatus !=
// //                                                                     'COMPLETE' &&
// //                                                                 _orderHistoryController
// //                                                                         .listOrderHistory[
// //                                                                             index]
// //                                                                         .orderStatus !=
// //                                                                     'CANCEL' &&
// //                                                                 _orderHistoryController
// //                                                                         .listOrderHistory[
// //                                                                             index]
// //                                                                         .deliveryType ==
// //                                                                     'DINING')
// //                                                               Container(
// //                                                                 height:
// //                                                                     ScreenUtil()
// //                                                                         .setHeight(
// //                                                                             40),
// //                                                                 child:
// //                                                                     ElevatedButton(
// //                                                                   style: ElevatedButton
// //                                                                       .styleFrom(
// //                                                                     primary: Color(
// //                                                                         Constants
// //                                                                             .colorTheme),
// //                                                                     shape: RoundedRectangleBorder(
// //                                                                         borderRadius: BorderRadius.only(
// //                                                                             bottomLeft: Radius.circular(
// //                                                                                 20),
// //                                                                             bottomRight: Radius.circular(
// //                                                                                 20)),
// //                                                                         side: BorderSide
// //                                                                             .none),
// //                                                                   ),
// //                                                                   onPressed:
// //                                                                       () {
// //                                                                     // showCancelOrderDialog(_orderHistoryController.listOrderHistory[index].id);
// //                                                                   },
// //                                                                   child:
// //                                                                       RichText(
// //                                                                     text:
// //                                                                         TextSpan(
// //                                                                       children: [
// //                                                                         TextSpan(
// //                                                                           text:
// //                                                                               'Live Order',
// //                                                                           style:
// //                                                                               TextStyle(
// //                                                                             color:
// //                                                                                 Colors.white,
// //                                                                             fontSize:
// //                                                                                 18,
// //                                                                           ),
// //                                                                         ),
// //                                                                       ],
// //                                                                     ),
// //                                                                   ),
// //                                                                 ),
// //                                                               ),
// //                                                           ],
// //                                                         )),
// //                                                   ],
// //                                                 )
// //                                               ],
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     );
// //                                   })),
// //                             ),
// //                           ],
// //                         ),
// //                 );
//
//   ///Center Circle code
//   // return Center(
//   //   child: SpinKitFadingCircle(
//   //     color: Color(Constants.colorTheme),
//   //   ),
//   // );
//
//   showCancelOrderDialog(int? orderId) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               insetPadding: EdgeInsets.all(15),
//               child: Padding(
//                 padding: EdgeInsets.only(
//                     left: ScreenUtil().setWidth(20),
//                     right: ScreenUtil().setWidth(20),
//                     bottom: 0,
//                     top: ScreenUtil().setHeight(20)),
//                 child: Container(
//                   height: MediaQuery.of(context).size.height * 0.42,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Cancel Order',
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                               style: TextStyle(
//                                 fontSize: ScreenUtil().setSp(18),
//                                 fontWeight: FontWeight.w900,
//                                 fontFamily: Constants.appFontBold,
//                               ),
//                             ),
//                             GestureDetector(
//                               child: Icon(Icons.close),
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                             )
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: ScreenUtil().setHeight(10),
//                       ),
//                       Divider(
//                         thickness: 1,
//                         color: Color(0xffcccccc),
//                       ),
//                       SizedBox(
//                         height: ScreenUtil().setHeight(10),
//                       ),
//                       Text(
//                         'Order Cancel Reason',
//                         style: TextStyle(
//                             fontFamily: Constants.appFontBold, fontSize: 16),
//                       ),
//                       SizedBox(
//                         height: ScreenUtil().setHeight(10),
//                       ),
//                       Card(
//                         elevation: 3,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextField(
//                             controller: _textOrderCancelReason,
//                             keyboardType: TextInputType.text,
//                             decoration: InputDecoration(
//                                 contentPadding: EdgeInsets.only(left: 10),
//                                 hintText: 'Type Order Cancel Reason',
//                                 border: InputBorder.none),
//                             maxLines: 5,
//                             style: TextStyle(
//                                 fontFamily: Constants.appFont,
//                                 fontSize: 16,
//                                 color: Color(
//                                   Constants.colorGray,
//                                 )),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: ScreenUtil().setHeight(10),
//                       ),
//                       Divider(
//                         thickness: 1,
//                         color: Color(0xffcccccc),
//                       ),
//                       Padding(
//                         padding:
//                             EdgeInsets.only(top: ScreenUtil().setHeight(15)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text(
//                                 'No Go Back',
//                                 style: TextStyle(
//                                     fontSize: ScreenUtil().setSp(14),
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: Constants.appFontBold,
//                                     color: Color(Constants.colorGray)),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(
//                                   left: ScreenUtil().setWidth(12)),
//                               child: GestureDetector(
//                                 onTap: () async {
//                                   if (_textOrderCancelReason.text.isNotEmpty) {
//                                     await callCancelOrder(
//                                         orderId, _textOrderCancelReason.text);
//                                   } else {
//                                     Constants.toastMessage(
//                                         'Please Enter Cancel Reason');
//                                   }
//                                 },
//                                 child: Text(
//                                   'Yes Cancel It',
//                                   style: TextStyle(
//                                       fontSize: ScreenUtil().setSp(14),
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: Constants.appFontBold,
//                                       color: Color(Constants.colorBlue)),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<BaseModel<CommenRes>> callCancelOrder(
//       int? orderId, String cancelReason) async {
//     CommenRes response;
//     try {
//       Constants.onLoading(context);
//       Map<String, String> body = {
//         'id': orderId.toString(),
//         'cancel_reason': cancelReason,
//       };
//       response = await RestClient(await RetroApi().dioData()).cancelOrder(body);
//       Constants.hideDialog(context);
//       if (response.success!) {
//         Navigator.pop(context);
//         _orderHistoryController.refreshOrderHistory(context);
//         Constants.toastMessage(response.data!);
//       } else {
//         Constants.toastMessage(response.data!);
//       }
//     } catch (error, stacktrace) {
//       Constants.hideDialog(context);
//       print("Exception occurred: $error stackTrace: $stacktrace");
//       return BaseModel()..setException(ServerError.withError(error: error));
//     }
//     return BaseModel()..data = response;
//   }
//
//   Widget delieveryTypeButton(
//       {required void Function()? onTap,
//       required IconData icon,
//       required String title,
//       required TextStyle style,
//       required Color buttonColor,
//       required Color color}) {
//     return GestureDetector(
//         onTap: onTap,
//         child: Container(
//           margin: EdgeInsets.all(4.0),
//           height: 70,
//           width: 70,
//           decoration: BoxDecoration(
//               color: buttonColor,
//               borderRadius: BorderRadius.all(Radius.circular(16.0))),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 color: color,
//               ),
//               Text(
//                 title,
//                 style: style,
//               )
//             ],
//           ),
//         ));
//   }
//
//   @override
//   void dispose() {
//     firebaseListener?.cancel();
//     super.dispose();
//   }
// }
// ///Last modified without search