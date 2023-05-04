// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get.dart';
// import 'package:pos/pages/Reports/report_controller.dart';
// import 'package:pos/utils/app_toolbar_with_btn_clr.dart';
// import 'package:pos/utils/constants.dart';
//
//
// class Reports extends StatelessWidget {
//   final _reportcController = Get.put(ReportController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: ApplicationToolbarWithClrBtn(
//         appbarTitle: 'Reports',
//         strButtonTitle: "",
//         btnColor: Color(Constants.colorLike),
//         onBtnPress: () {},
//       ),
//       // body: FutureBuilder<BaseModel<OrderHistoryListModel>>(
//       //     future:orderHistoryRef,
//       //     builder: (context,snapshot){
//       //       if(snapshot.hasData){
//       //         return Container();
//       //         // return Container(
//       //         //   decoration: BoxDecoration(
//       //         //       color: Color(Constants.colorScreenBackGround),
//       //         //       image: DecorationImage(
//       //         //         image: AssetImage('images/ic_background_image.png'),
//       //         //         fit: BoxFit.cover,
//       //         //       )),
//       //         //   child: _orderHistoryController.listOrderHistory.length == 0 ?
//       //         //   Center(
//       //         //     child: Column(
//       //         //       crossAxisAlignment: CrossAxisAlignment.stretch,
//       //         //       mainAxisAlignment: MainAxisAlignment.center,
//       //         //       children: [
//       //         //         Image(
//       //         //           width: 150,
//       //         //           height: 180,
//       //         //           image: AssetImage(
//       //         //               'images/ic_no_order_history.png'),
//       //         //         ),
//       //         //         Text(
//       //         //           'No Order History',
//       //         //           textAlign: TextAlign.center,
//       //         //           style: TextStyle(
//       //         //             fontSize: ScreenUtil().setSp(18),
//       //         //             fontFamily: Constants.appFontBold,
//       //         //             color: Color(Constants.colorTheme),
//       //         //           ),
//       //         //         )
//       //         //       ],
//       //         //     ),
//       //         //   )
//       //         //       :Obx(()=> ListView.builder(
//       //         //       padding: EdgeInsets.only(bottom:100,left: 10,right: 10),
//       //         //       scrollDirection: Axis.vertical,
//       //         //       itemCount: _orderHistoryController.listOrderHistory.length,
//       //         //       itemBuilder: (BuildContext context, int index) {
//       //         //         return Column(
//       //         //           crossAxisAlignment:
//       //         //           CrossAxisAlignment.stretch,
//       //         //           children: [
//       //         //
//       //         //             Padding(
//       //         //               padding: const EdgeInsets.only(
//       //         //                   top: 10, right: 10),
//       //         //               child: Text(
//       //         //                 (() {
//       //         //                   if (_orderHistoryController.listOrderHistory[index]
//       //         //                       .addressId !=
//       //         //                       null) {
//       //         //                     if (_orderHistoryController.listOrderHistory[index]
//       //         //                         .orderStatus ==
//       //         //                         'PENDING') {
//       //         //                       return '${'Ordered On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     } else if (_orderHistoryController.listOrderHistory[
//       //         //                     index]
//       //         //                         .orderStatus ==
//       //         //                         'ACCEPT') {
//       //         //                       return '${'Accepted On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     } else if (_orderHistoryController.listOrderHistory[
//       //         //                     index]
//       //         //                         .orderStatus ==
//       //         //                         'APPROVE') {
//       //         //                       return '${'Approve On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     } else if (_orderHistoryController.listOrderHistory[
//       //         //                     index]
//       //         //                         .orderStatus ==
//       //         //                         'REJECT') {
//       //         //                       return '${'Rejected On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     } else if (_orderHistoryController.listOrderHistory[
//       //         //                     index]
//       //         //                         .orderStatus ==
//       //         //                         'PICKUP') {
//       //         //                       return '${'Pickedup On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     } else if (_orderHistoryController.listOrderHistory[
//       //         //                     index]
//       //         //                         .orderStatus ==
//       //         //                         'DELIVERED') {
//       //         //                       return '${'Delivered On'} ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     } else if (_orderHistoryController.listOrderHistory[
//       //         //                     index]
//       //         //                         .orderStatus ==
//       //         //                         'CANCEL') {
//       //         //                       return 'Canceled On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     } else if (_orderHistoryController.listOrderHistory[
//       //         //                     index]
//       //         //                         .orderStatus ==
//       //         //                         'COMPLETE') {
//       //         //                       return 'Delivered On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     }
//       //         //                   } else {
//       //         //                     if (_orderHistoryController.listOrderHistory[index]
//       //         //                         .orderStatus ==
//       //         //                         'PENDING') {
//       //         //                       return 'Ordered On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     } else if (_orderHistoryController.listOrderHistory[
//       //         //                     index]
//       //         //                         .orderStatus ==
//       //         //                         'ACCEPT') {
//       //         //                       return 'Accepted On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     } else if (_orderHistoryController.listOrderHistory[
//       //         //                     index]
//       //         //                         .orderStatus ==
//       //         //                         'APPROVE') {
//       //         //                       return 'Approve On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     } else if (_orderHistoryController.listOrderHistory[
//       //         //                     index]
//       //         //                         .orderStatus ==
//       //         //                         'REJECT') {
//       //         //                       return 'Rejected On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     } else if (_orderHistoryController.listOrderHistory[
//       //         //                     index]
//       //         //                         .orderStatus ==
//       //         //                         'PREPARE_FOR_ORDER') {
//       //         //                       return 'PREPARE FOR ORDER ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     } else if (_orderHistoryController.listOrderHistory[
//       //         //                     index]
//       //         //                         .orderStatus ==
//       //         //                         'READY_FOR_ORDER') {
//       //         //                       return 'READY FOR ORDER ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     } else if (_orderHistoryController.listOrderHistory[
//       //         //                     index]
//       //         //                         .orderStatus ==
//       //         //                         'CANCEL') {
//       //         //                       return 'Canceled On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     } else if (_orderHistoryController.listOrderHistory[
//       //         //                     index]
//       //         //                         .orderStatus ==
//       //         //                         'COMPLETE') {
//       //         //                       return 'Delivered On ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}';
//       //         //                     }
//       //         //                   }
//       //         //                 }())?? '',
//       //         //                 style: TextStyle(
//       //         //                     color: Color(
//       //         //                         Constants.colorGray),
//       //         //                     fontFamily:
//       //         //                     Constants.appFont,
//       //         //                     fontSize: 12),
//       //         //                 textAlign: TextAlign.end,
//       //         //               ),
//       //         //             ),
//       //         //             GestureDetector(
//       //         //               onTap: () {
//       //         //
//       //         //                 print(
//       //         //                     " orderData is .. ${_orderHistoryController.listOrderHistory[index].deliveryType}");
//       //         //                 // // Constants.toastMessage(_orderHistoryController.listOrderHistory[index].id.toString());
//       //         //                 // Navigator.of(context).push(
//       //         //                 //     Transitions(
//       //         //                 //         transitionType:
//       //         //                 //         TransitionType.fade,
//       //         //                 //         curve:
//       //         //                 //         Curves.bounceInOut,
//       //         //                 //         reverseCurve: Curves
//       //         //                 //             .fastLinearToSlowEaseIn,
//       //         //                 //         widget:
//       //         //                 //         OrderDetailsScreen(
//       //         //                 //           orderId:
//       //         //                 //           _orderHistoryController.listOrderHistory[
//       //         //                 //           index]
//       //         //                 //               .id,
//       //         //                 //           orderDate:
//       //         //                 //           _orderHistoryController.listOrderHistory[
//       //         //                 //           index]
//       //         //                 //               .date,
//       //         //                 //           orderTime:
//       //         //                 //           _orderHistoryController.listOrderHistory[
//       //         //                 //           index]
//       //         //                 //               .time,
//       //         //                 //         )));
//       //         //               },
//       //         //               child: Card(
//       //         //                 shape: RoundedRectangleBorder(
//       //         //                   borderRadius:
//       //         //                   BorderRadius.circular(
//       //         //                       20.0),
//       //         //                 ),
//       //         //                 margin: EdgeInsets.only(
//       //         //                     top: 20,
//       //         //                     left: 16,
//       //         //                     right: 16,
//       //         //                     bottom: 20),
//       //         //                 child: Column(
//       //         //                   children: [
//       //         //
//       //         //
//       //         //                     // (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' || _orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE')?
//       //         //                     //
//       //         //                     // GestureDetector(
//       //         //                     //   onTap: (){
//       //         //                     //     showCancelOrderDialog(_orderHistoryController.listOrderHistory[index].id);
//       //         //                     //   },
//       //         //                     //   child: Padding(
//       //         //                     //     padding: const EdgeInsets
//       //         //                     //         .only(
//       //         //                     //         top: 10,
//       //         //                     //         right:
//       //         //                     //         20),
//       //         //                     //     child:
//       //         //                     //     RichText(
//       //         //                     //       text:
//       //         //                     //       TextSpan(
//       //         //                     //         children: [
//       //         //                     //           WidgetSpan(
//       //         //                     //             child:
//       //         //                     //             Padding(
//       //         //                     //               padding: const EdgeInsets.only(right: 5),
//       //         //                     //               child: SvgPicture.asset('images/ic_cancel.svg',
//       //         //                     //
//       //         //                     //                 //  color: Color(Constants.colorTheme),
//       //         //                     //                 width: 15,
//       //         //                     //                 height: ScreenUtil().setHeight(15),
//       //         //                     //               ),
//       //         //                     //             ),
//       //         //                     //           ),
//       //         //                     //           TextSpan(
//       //         //                     //               text: 'Cancel this order',
//       //         //                     //               style: TextStyle(
//       //         //                     //                   color: Color(Constants.colorLike),
//       //         //                     //                   fontFamily: Constants.appFont,
//       //         //                     //                   fontSize: 12)),
//       //         //                     //         ],
//       //         //                     //       ),
//       //         //                     //     ),
//       //         //                     //   ),
//       //         //                     // ):Container(),
//       //         //
//       //         //                     Row(
//       //         //                       crossAxisAlignment:
//       //         //                       CrossAxisAlignment.start,
//       //         //                       children: [
//       //         //                         Padding(
//       //         //                           padding:
//       //         //                           const EdgeInsets
//       //         //                               .all(5.0),
//       //         //                           child: ClipRRect(
//       //         //                             borderRadius:
//       //         //                             BorderRadius
//       //         //                                 .circular(
//       //         //                                 15.0),
//       //         //                             child: CachedNetworkImage(
//       //         //                               height:
//       //         //                               100,
//       //         //                               width:
//       //         //                               100,
//       //         //                               imageUrl:
//       //         //                               _orderHistoryController.listOrderHistory[
//       //         //                               index]
//       //         //                                   .vendor!
//       //         //                                   .image!,
//       //         //                               fit: BoxFit.cover,
//       //         //                               placeholder: (context,
//       //         //                                   url) =>
//       //         //                                   SpinKitFadingCircle(
//       //         //                                       color: Color(
//       //         //                                           Constants
//       //         //                                               .colorTheme)),
//       //         //                               errorWidget:
//       //         //                                   (context, url,
//       //         //                                   error) =>
//       //         //                                   Container(
//       //         //                                     child: Center(
//       //         //                                         child: Image.asset('images/noimage.png')),
//       //         //                                   ),
//       //         //                             ),
//       //         //                           ),
//       //         //                         ),
//       //         //                         Expanded(
//       //         //                           child: Column(
//       //         //                             crossAxisAlignment:
//       //         //                             CrossAxisAlignment
//       //         //                                 .start,
//       //         //                             children: [
//       //         //                               Row(
//       //         //                                 children: [
//       //         //                                   Expanded(
//       //         //                                     flex: 4,
//       //         //                                     child:
//       //         //                                     Padding(
//       //         //                                       padding: const EdgeInsets
//       //         //                                           .only(
//       //         //                                           left:
//       //         //                                           10,
//       //         //                                           top:
//       //         //                                           10),
//       //         //                                       child:
//       //         //                                       Text(
//       //         //                                         _orderHistoryController.listOrderHistory[index]
//       //         //                                             .vendor!
//       //         //                                             .name!,
//       //         //                                         style: TextStyle(
//       //         //                                             fontFamily:
//       //         //                                             Constants.appFontBold,
//       //         //                                             fontSize: 16),
//       //         //                                       ),
//       //         //                                     ),
//       //         //                                   ),
//       //         //                                 ],
//       //         //                               ),
//       //         //                               Padding(
//       //         //                                 padding:
//       //         //                                 const EdgeInsets
//       //         //                                     .only(
//       //         //                                     top: 3,
//       //         //                                     left:
//       //         //                                     10,
//       //         //                                     right:
//       //         //                                     5),
//       //         //                                 child: Text(
//       //         //                                   _orderHistoryController.listOrderHistory[
//       //         //                                   index]
//       //         //                                       .vendor!
//       //         //                                       .mapAddress ?? '',
//       //         //                                   overflow:
//       //         //                                   TextOverflow
//       //         //                                       .ellipsis,
//       //         //                                   style: TextStyle(
//       //         //                                       fontFamily:
//       //         //                                       Constants
//       //         //                                           .appFont,
//       //         //                                       color: Color(
//       //         //                                           Constants
//       //         //                                               .colorGray),
//       //         //                                       fontSize:
//       //         //                                       13),
//       //         //                                 ),
//       //         //                               ),
//       //         //                               _orderHistoryController.listOrderHistory[index].tableNo == 0 || _orderHistoryController.listOrderHistory[index].tableNo == null ? SizedBox():  Padding(
//       //         //                                 padding:
//       //         //                                 const EdgeInsets
//       //         //                                     .only(
//       //         //                                     top: 3,
//       //         //                                     left:
//       //         //                                     10,
//       //         //                                     right:
//       //         //                                     5),
//       //         //                                 child: Text(
//       //         //                                   "Table No ${_orderHistoryController.listOrderHistory[index].tableNo.toString() }"?? '',
//       //         //                                   overflow:
//       //         //                                   TextOverflow
//       //         //                                       .ellipsis,
//       //         //                                   style: TextStyle(
//       //         //                                       fontFamily:
//       //         //                                       Constants.appFontBold,
//       //         //                                       fontSize: 16),
//       //         //                                 ),
//       //         //                               ),
//       //         //                               SizedBox(
//       //         //                                 height:
//       //         //                                 ScreenUtil()
//       //         //                                     .setHeight(
//       //         //                                     10),
//       //         //                               ),
//       //         //
//       //         //                               Row(
//       //         //                                 children: [
//       //         //
//       //         //                                   Expanded(
//       //         //                                     child:
//       //         //                                     Padding(
//       //         //                                       padding: const EdgeInsets
//       //         //                                           .only(
//       //         //                                           left:
//       //         //                                           10,
//       //         //                                           top:
//       //         //                                           10),
//       //         //                                       child:
//       //         //                                       Text(
//       //         //                                         AuthController.sharedPreferences?.getString(Constants.appSettingCurrencySymbol)??''
//       //         //                                             +
//       //         //                                             '${_orderHistoryController.listOrderHistory[index].amount}',
//       //         //                                         style: TextStyle(
//       //         //                                             fontFamily:
//       //         //                                             Constants.appFont,
//       //         //                                             fontSize: 14),
//       //         //                                       ),
//       //         //                                     ),
//       //         //                                   ),
//       //         //
//       //         //                                   Padding(
//       //         //                                     padding: const EdgeInsets
//       //         //                                         .only(
//       //         //                                         top: 10,
//       //         //                                         right:
//       //         //                                         20),
//       //         //                                     child:
//       //         //                                     RichText(
//       //         //                                       text:
//       //         //                                       TextSpan(
//       //         //                                         children: [
//       //         //                                           WidgetSpan(
//       //         //                                             child:
//       //         //                                             Padding(
//       //         //                                               padding: const EdgeInsets.only(right: 5),
//       //         //                                               child: SvgPicture.asset(
//       //         //                                                 (() {
//       //         //                                                   if (_orderHistoryController.listOrderHistory[index].addressId != null) {
//       //         //                                                     if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//       //         //                                                       return 'images/ic_pending.svg';
//       //         //                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
//       //         //                                                       return 'images/ic_accept.svg';
//       //         //                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//       //         //                                                       return 'images/ic_accept.svg';
//       //         //                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
//       //         //                                                       return 'images/ic_cancel.svg';
//       //         //                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
//       //         //                                                       return 'images/ic_pickup.svg';
//       //         //                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
//       //         //                                                       return 'images/ic_completed.svg';
//       //         //                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
//       //         //                                                       return 'images/ic_cancel.svg';
//       //         //                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//       //         //                                                       return 'images/ic_completed.svg';
//       //         //                                                     }else{
//       //         //                                                       return 'images/ic_accept.svg';
//       //         //                                                     }
//       //         //                                                   } else {
//       //         //                                                     if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//       //         //                                                       return 'images/ic_pending.svg';
//       //         //                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
//       //         //                                                       return 'images/ic_accept.svg';
//       //         //                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
//       //         //                                                       return 'images/ic_pickup.svg';
//       //         //                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
//       //         //                                                       return 'images/ic_completed.svg';
//       //         //                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
//       //         //                                                       return 'images/ic_cancel.svg';
//       //         //                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
//       //         //                                                       return 'images/ic_cancel.svg';
//       //         //                                                     } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//       //         //                                                       return 'images/ic_completed.svg';
//       //         //                                                     }
//       //         //                                                   }
//       //         //                                                 }())?? '',
//       //         //                                                 color: (() {
//       //         //                                                   // your code here
//       //         //                                                   // _orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' ? 'Ordered on ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}' : 'Delivered on October 10,2020, 09:23pm',
//       //         //                                                   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//       //         //                                                     return Color(Constants.colorOrderPending);
//       //         //                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//       //         //                                                     return Color(Constants.colorBlack);
//       //         //                                                   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
//       //         //                                                     return Color(Constants.colorOrderPickup);
//       //         //                                                   }
//       //         //                                                 }()),
//       //         //                                                 width: 15,
//       //         //                                                 height: ScreenUtil().setHeight(15),
//       //         //                                               ),
//       //         //                                             ),
//       //         //                                           ),
//       //         //
//       //         //                                           TextSpan(
//       //         //                                               text: (() {
//       //         //                                                 if(_orderHistoryController.listOrderHistory[index].deliveryType=='TAKEAWAY'){
//       //         //                                                   if(_orderHistoryController.listOrderHistory[index].orderStatus=='READY TO PICKUP'){
//       //         //                                                     return 'Waiting For User To Pickup';
//       //         //                                                   }
//       //         //
//       //         //                                                 }else{
//       //         //                                                   if(_orderHistoryController.listOrderHistory[index].orderStatus=='READY TO PICKUP'||
//       //         //                                                       _orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT'){
//       //         //                                                     return 'Waiting For Driver To Pickup';
//       //         //                                                   }
//       //         //
//       //         //
//       //         //                                                 }
//       //         //                                                 return _orderHistoryController.listOrderHistory[index].orderStatus;
//       //         //                                                 // if (_orderHistoryController.listOrderHistory[index].addressId != null) {
//       //         //                                                 //
//       //         //                                                 //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//       //         //                                                 //     return Languages.of(context)!.labelOrderPending;
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
//       //         //                                                 //     return Languages.of(context)!.labelOrderAccepted;
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//       //         //                                                 //     return Languages.of(context)!.labelOrderAccepted;
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
//       //         //                                                 //     return Languages.of(context)!.labelOrderRejected;
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
//       //         //                                                 //     return 'PREPARING FOOD';
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
//       //         //                                                 //     return 'READY TO PICKUP';
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
//       //         //                                                 //     return Languages.of(context)!.labelOrderPickedUp;
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
//       //         //                                                 //     return Languages.of(context)!.labelDeliveredSuccess;
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
//       //         //                                                 //     return Languages.of(context)!.labelOrderCanceled;
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//       //         //                                                 //     return Languages.of(context)!.labelOrderCompleted;
//       //         //                                                 //   }
//       //         //                                                 // } else {
//       //         //                                                 //   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//       //         //                                                 //     return Languages.of(context)!.labelOrderPending;
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
//       //         //                                                 //     return Languages.of(context)!.labelOrderAccepted;
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//       //         //                                                 //     return Languages.of(context)!.labelOrderAccepted;
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
//       //         //                                                 //     return 'PREPARING FOOD';
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
//       //         //                                                 //     return 'READY TO PICKUP';
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
//       //         //                                                 //     return Languages.of(context)!.labelOrderRejected;
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//       //         //                                                 //     return Languages.of(context)!.labelOrderCompleted;
//       //         //                                                 //   } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
//       //         //                                                 //     return Languages.of(context)!.labelOrderCanceled;
//       //         //                                                 //   }
//       //         //                                                 // }
//       //         //                                               }()),
//       //         //                                               style: TextStyle(
//       //         //                                                   color: (() {
//       //         //                                                     if (_orderHistoryController.listOrderHistory[index].addressId != null) {
//       //         //                                                       if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//       //         //                                                         return Color(Constants.colorOrderPending);
//       //         //                                                       } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
//       //         //                                                         return Color(Constants.colorBlack);
//       //         //                                                       } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//       //         //                                                         return Color(Constants.colorBlack);
//       //         //                                                       } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
//       //         //                                                         return Color(Constants.colorLike);
//       //         //                                                       } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PICKUP') {
//       //         //                                                         return Color(Constants.colorOrderPickup);
//       //         //                                                       } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'DELIVERED') {
//       //         //                                                         return Color(Constants.colorTheme);
//       //         //                                                       } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
//       //         //                                                         return Color(Constants.colorLike);
//       //         //                                                       } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//       //         //                                                         return Color(Constants.colorTheme);
//       //         //                                                       }else{
//       //         //                                                         return Color(Constants.colorTheme);
//       //         //                                                       }
//       //         //                                                     } else {
//       //         //                                                       if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING') {
//       //         //                                                         return Color(Constants.colorOrderPending);
//       //         //                                                       } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE') {
//       //         //                                                         return Color(Constants.colorBlack);
//       //         //                                                       } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'ACCEPT') {
//       //         //                                                         return Color(Constants.colorBlack);
//       //         //                                                       } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'REJECT') {
//       //         //                                                         return Color(Constants.colorLike);
//       //         //                                                       } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PREPARING FOOD') {
//       //         //                                                         return Color(Constants.colorOrderPickup);
//       //         //                                                       } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'READY TO PICKUP') {
//       //         //                                                         return Color(Constants.colorTheme);
//       //         //                                                       } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL') {
//       //         //                                                         return Color(Constants.colorLike);
//       //         //                                                       } else if (_orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//       //         //                                                         return Color(Constants.colorTheme);
//       //         //                                                       }else{
//       //         //                                                         return Color(Constants.colorTheme);
//       //         //                                                       }
//       //         //                                                     }
//       //         //                                                   }()),
//       //         //                                                   fontFamily: Constants.appFont,
//       //         //                                                   fontSize: 12)),
//       //         //                                         ],
//       //         //                                       ),
//       //         //                                     ),
//       //         //                                   )
//       //         //                                 ],
//       //         //                               ),
//       //         //                             ],
//       //         //                           ),
//       //         //                         ),
//       //         //                       ],
//       //         //                     ),
//       //         //                     Padding(
//       //         //                       padding:
//       //         //                       const EdgeInsets.only(
//       //         //                           left: 5,
//       //         //                           right: 5,
//       //         //                           top: 20),
//       //         //                       child: DottedLine(
//       //         //                         dashColor:
//       //         //                         Color(0xffcccccc),
//       //         //                       ),
//       //         //                     ),
//       //         //                     Row(
//       //         //                       children: [
//       //         //                         Expanded(
//       //         //                             flex: 5,
//       //         //                             child: Column(
//       //         //                               crossAxisAlignment:
//       //         //                               CrossAxisAlignment
//       //         //                                   .stretch,
//       //         //                               children: [
//       //         //                                 ListView
//       //         //                                     .builder(
//       //         //                                   physics:
//       //         //                                   ClampingScrollPhysics(),
//       //         //                                   shrinkWrap:
//       //         //                                   true,
//       //         //                                   scrollDirection:
//       //         //                                   Axis.vertical,
//       //         //                                   itemCount: _orderHistoryController.listOrderHistory[
//       //         //                                   index]
//       //         //                                       .orderItems!
//       //         //                                       .length,
//       //         //                                   itemBuilder:
//       //         //                                       (BuildContext context,
//       //         //                                       int innerindex) =>
//       //         //                                       Padding(
//       //         //                                         padding: const EdgeInsets
//       //         //                                             .only(
//       //         //                                             left:
//       //         //                                             20,
//       //         //                                             top:
//       //         //                                             20),
//       //         //                                         child:
//       //         //                                         Column(
//       //         //                                           children: [
//       //         //                                             Row(
//       //         //                                               children: [
//       //         //                                                 Text(
//       //         //                                                   _orderHistoryController.listOrderHistory[index].orderItems![innerindex].itemName.toString(),
//       //         //                                                   style: TextStyle(fontFamily: Constants.appFont, fontSize: 12),
//       //         //                                                 ),
//       //         //                                                 Padding(
//       //         //                                                   padding: const EdgeInsets.only(left: 5),
//       //         //                                                   child: Text(
//       //         //                                                       (() {
//       //         //                                                         String qty = '';
//       //         //                                                         if (_orderHistoryController.listOrderHistory[index].orderItems!.length > 0 && _orderHistoryController.listOrderHistory[index].orderItems != null) {
//       //         //                                                           // for (int i = 0; i < _orderHistoryController.listOrderHistory[index].orderItems.length; i++) {
//       //         //                                                           qty = ' X ${_orderHistoryController.listOrderHistory[index].orderItems![innerindex].qty.toString()}';
//       //         //                                                           // }
//       //         //                                                           return qty;
//       //         //                                                         } else {
//       //         //                                                           return '';
//       //         //                                                         }
//       //         //                                                       }()),
//       //         //                                                       style: TextStyle(color: Color(Constants.colorTheme), fontFamily: Constants.appFont, fontSize: 12)),
//       //         //                                                 ),
//       //         //                                               ],
//       //         //                                             ),
//       //         //                                           ],
//       //         //                                         ),
//       //         //                                       ),
//       //         //                                 ),
//       //         //                                 SizedBox(
//       //         //                                   height: ScreenUtil()
//       //         //                                       .setHeight(
//       //         //                                       10),
//       //         //                                 ),
//       //         //                                 //Order Cancel
//       //         //                                 if (_orderHistoryController.listOrderHistory[index].deliveryType=='DINING'
//       //         //                                     && _orderHistoryController.listOrderHistory[index].orderStatus!='COMPLETE')
//       //         //                                   Column(
//       //         //                                     children: [
//       //         //                                       Container(
//       //         //                                           height: ScreenUtil()
//       //         //                                               .setHeight(
//       //         //                                               40),
//       //         //                                           child:GestureDetector(
//       //         //                                             onTap: (){
//       //         //                                               _cartController.cartMaster=CartMaster.fromMap(jsonDecode(_orderHistoryController.listOrderHistory[index].orderData!));
//       //         //                                               _cartController.cartMaster?.oldOrderId=_orderHistoryController.listOrderHistory[index].id;
//       //         //                                               _cartController.tableNumber=_orderHistoryController.listOrderHistory[index].tableNo;
//       //         //                                               Get.to(()=>PosMenu(isDining:true));
//       //         //
//       //         //                                             },
//       //         //                                             child: Align(
//       //         //                                                 alignment: Alignment.center,
//       //         //                                                 child: Text('Edit This Order')),
//       //         //                                           )
//       //         //
//       //         //                                       ),
//       //         //                                     ],
//       //         //                                   ),
//       //         //                                 if (_orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' || _orderHistoryController.listOrderHistory[index].orderStatus == 'APPROVE')
//       //         //                                   Container(
//       //         //                                     height: ScreenUtil()
//       //         //                                         .setHeight(
//       //         //                                         50),
//       //         //                                     child:
//       //         //                                     ElevatedButton(
//       //         //                                       style: ElevatedButton.styleFrom(
//       //         //                                         primary: Colors.white,
//       //         //                                         shape: RoundedRectangleBorder(
//       //         //                                             borderRadius:
//       //         //                                             BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
//       //         //                                             side: BorderSide.none),
//       //         //                                       ),
//       //         //                                       onPressed:
//       //         //                                           ()async {
//       //         //                                         await showCancelOrderDialog(_orderHistoryController.listOrderHistory[index].id);
//       //         //                                         setState(() {
//       //         //                                           orderHistoryRef=_orderHistoryController.refreshOrderHistory(context);
//       //         //                                         });
//       //         //                                       },
//       //         //                                       child: RichText(
//       //         //                                         text:
//       //         //                                         TextSpan(
//       //         //                                           children: [
//       //         //                                             WidgetSpan(
//       //         //                                               child: Padding(
//       //         //                                                 padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
//       //         //                                                 child: SvgPicture.asset(
//       //         //                                                   'images/ic_cancel.svg',
//       //         //                                                   width: ScreenUtil().setWidth(20),
//       //         //                                                   //color: Color(Constants.colorRate),
//       //         //                                                   height: ScreenUtil().setHeight(20),
//       //         //                                                 ),
//       //         //                                               ),
//       //         //                                             ),
//       //         //                                             TextSpan(
//       //         //                                               text:'Cancel this order',
//       //         //                                               style: TextStyle(color: Color(Constants.colorLike), fontSize: 18, fontFamily: Constants.appFont),
//       //         //                                             ),
//       //         //                                           ],
//       //         //                                         ),
//       //         //                                       ),
//       //         //
//       //         //                                     ),
//       //         //                                   ),
//       //         //                                 (() {
//       //         //                                   if (_orderHistoryController.listOrderHistory[index]
//       //         //                                       .orderStatus ==
//       //         //                                       'CANCEL' ||
//       //         //                                       _orderHistoryController.listOrderHistory[index]
//       //         //                                           .orderStatus ==
//       //         //                                           'COMPLETE') {
//       //         //                                     return Container(
//       //         //                                       height: ScreenUtil()
//       //         //                                           .setHeight(
//       //         //                                           40),
//       //         //                                       child:
//       //         //                                       ElevatedButton(
//       //         //                                         style: ElevatedButton.styleFrom(
//       //         //                                           primary: Colors.white,
//       //         //                                           shape: RoundedRectangleBorder(
//       //         //                                               borderRadius:
//       //         //                                               BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
//       //         //                                               side: BorderSide.none),
//       //         //                                         ),
//       //         //                                         onPressed:
//       //         //                                             () {
//       //         //                                           Navigator.of(context).push(Transitions(
//       //         //                                               transitionType: TransitionType.fade,
//       //         //                                               curve: Curves.bounceInOut,
//       //         //                                               reverseCurve: Curves.fastLinearToSlowEaseIn,
//       //         //                                               widget: OrderReviewScreen(
//       //         //                                                 orderId: _orderHistoryController.listOrderHistory[index].id,
//       //         //                                               )));
//       //         //                                         },
//       //         //                                         child: RichText(
//       //         //                                           text:
//       //         //                                           TextSpan(
//       //         //                                             children: [
//       //         //                                               WidgetSpan(
//       //         //                                                 child: Padding(
//       //         //                                                   padding: EdgeInsets.only(right: ScreenUtil().setHeight(10)),
//       //         //                                                   child: SvgPicture.asset(
//       //         //                                                     'images/ic_star.svg',
//       //         //                                                     width: ScreenUtil().setWidth(20),
//       //         //                                                     color: Color(Constants.colorRate),
//       //         //                                                     height: ScreenUtil().setHeight(20),
//       //         //                                                   ),
//       //         //                                                 ),
//       //         //                                               ),
//       //         //                                               TextSpan(
//       //         //                                                 text: (() {
//       //         //                                                   // your code here
//       //         //                                                   // _orderHistoryController.listOrderHistory[index].orderStatus == 'PENDING' ? 'Ordered on ${_orderHistoryController.listOrderHistory[index].date}, ${_orderHistoryController.listOrderHistory[index].time}' : 'Delivered on October 10,2020, 09:23pm',
//       //         //                                                   if (_orderHistoryController.listOrderHistory[index].orderStatus == 'CANCEL' || _orderHistoryController.listOrderHistory[index].orderStatus == 'COMPLETE') {
//       //         //                                                     return 'Rate Now';
//       //         //                                                   } else {
//       //         //                                                     return '';
//       //         //                                                   }
//       //         //                                                 }()),
//       //         //                                                 style: TextStyle(color: Color(Constants.colorRate), fontSize: 18, fontFamily: Constants.appFont),
//       //         //                                               ),
//       //         //                                             ],
//       //         //                                           ),
//       //         //                                         ),
//       //         //
//       //         //                                       ),
//       //         //                                     );
//       //         //                                   } else {
//       //         //                                     return Container();
//       //         //                                   }
//       //         //                                 }()),
//       //         //                                 if(_orderHistoryController.listOrderHistory[index].orderStatus !=
//       //         //                                     'COMPLETE' &&_orderHistoryController.listOrderHistory[index].orderStatus !=
//       //         //                                     'CANCEL' &&  _orderHistoryController.listOrderHistory[index].deliveryType == 'DINING')
//       //         //                                   Container(
//       //         //                                     height: ScreenUtil()
//       //         //                                         .setHeight(
//       //         //                                         40),
//       //         //                                     child:
//       //         //                                     ElevatedButton(
//       //         //                                       style: ElevatedButton.styleFrom(
//       //         //                                         primary: Color(Constants.colorTheme),
//       //         //                                         shape: RoundedRectangleBorder(
//       //         //                                             borderRadius:
//       //         //                                             BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
//       //         //                                             side: BorderSide.none),
//       //         //                                       ),
//       //         //                                       onPressed:
//       //         //                                           () {
//       //         //                                         // showCancelOrderDialog(_orderHistoryController.listOrderHistory[index].id);
//       //         //                                       },
//       //         //                                       child: RichText(
//       //         //                                         text:
//       //         //                                         TextSpan(
//       //         //                                           children: [
//       //         //                                             TextSpan(
//       //         //                                               text: 'Live Order',style: TextStyle(
//       //         //                                               color: Colors.white,
//       //         //                                               fontSize: 18,
//       //         //                                             ),),
//       //         //                                           ],
//       //         //                                         ),
//       //         //                                       ),
//       //         //                                     ),
//       //         //                                   ),
//       //         //                               ],
//       //         //                             )),
//       //         //                       ],
//       //         //                     )
//       //         //                   ],
//       //         //                 ),
//       //         //               ),
//       //         //             ),
//       //         //           ],
//       //         //         );
//       //         //       })),
//       //         // );
//       //       }
//       //       return Center(
//       //         child: SpinKitFadingCircle(color: Color(Constants.colorTheme),),
//       //       );
//       //     }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/model/report_model.dart';
import 'package:pos/pages/Reports/report_controller.dart';
import 'package:pos/printer/printer_controller.dart';
import 'package:pos/utils/app_toolbar_with_btn_clr.dart';
import 'package:pos/utils/constants.dart';

import '../../retrofit/base_model.dart';

class Reports extends StatelessWidget {
  final _reportController = Get.put(ReportController());
  PrinterController _printerController = Get.find<PrinterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolbarWithClrBtn(
        appbarTitle: 'Reports',
        strButtonTitle: "",
        btnColor: Color(Constants.colorLike),
        onBtnPress: () {},
      ),
      body: Container(
          decoration: BoxDecoration(
              color: Colors.red.shade50,
              image: DecorationImage(
                image: AssetImage('images/ic_background_image.png'),
                fit: BoxFit.cover,
              )),
          child: FutureBuilder<BaseModel<ReportModel>>(
            builder: (ctx, snapshot) {
              // Checking if future is resolved or not
              if (snapshot.connectionState == ConnectionState.done) {
                // If we got an error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error} occurred',
                      style: TextStyle(fontSize: 18),
                    ),
                  );

                  // if we got our data
                } else if (snapshot.hasData) {
                  // Extracting data from snapshot object
                  // final data = snapshot.data as String;
                  // return Container();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Payments",
                          style: TextStyle(
                              color: Colors.red.shade400,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 70,
                        width: double.infinity,
                        // padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Type",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Amount",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Center(
                                        child: Text(_reportController
                                                .reportModelData
                                                .value
                                                .payments!
                                                .posCash!
                                                .name!
                                                .isNotEmpty
                                            ? _reportController
                                                .reportModelData
                                                .value
                                                .payments!
                                                .posCash!
                                                .name!
                                                .first
                                                .toString()
                                            : "No data"))),
                                const Expanded(
                                    child: Center(child: Text("POS Cash"))),
                                Expanded(
                                    child: Center(
                                        child: Text(_reportController
                                            .reportModelData
                                            .value
                                            .payments!
                                            .posCash!
                                            .amount
                                            .toString()))),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Center(
                                        child: Text(
                                  _reportController.reportModelData.value
                                          .payments!.posCard!.name!.isNotEmpty
                                      ? _reportController.reportModelData.value
                                          .payments!.posCard!.name!.first
                                          .toString()
                                      : "No data",
                                ))),
                                const Expanded(
                                    child: Center(child: Text("POS Card"))),
                                Expanded(
                                    child: Center(
                                        child: Text(_reportController
                                            .reportModelData
                                            .value
                                            .payments!
                                            .posCard!
                                            .amount
                                            .toString()))),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Orders",
                          style: TextStyle(
                              color: Colors.red.shade400,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        child: snapshot.data!.data!.orders!.length == 0
                            ? Center(
                                child: Text("No data"),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: snapshot.data!.data!.orders!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  _reportController.reportModelOrderData.value =
                                      snapshot.data!.data!.orders![index];
                                  return Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: ListTile(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      title: Text(
                                        "Item Name: ${_reportController.reportModelOrderData.value.itemName.toString()}",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                      subtitle: Text(
                                        "Quantity ${_reportController.reportModelOrderData.value.quantity.toString()}",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ), // title: Text("List item $index")),
                                  );
                                }),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Total Orders",
                          style: TextStyle(
                              color: Colors.red.shade400,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Todays total orders"),
                                Text(_reportController
                                    .reportModelData.value.todaysTotalOrders
                                    .toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Todays total TakeAway"),
                                Text(_reportController
                                    .reportModelData.value.todaysTotalTakeaway
                                    .toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Todays total Dine in"),
                                Text(_reportController
                                    .reportModelData.value.todaysTotalDining
                                    .toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),

                      ///For both but 2 future builders
                      // Expanded(
                      //   child: FutureBuilder<BaseModel<ReportCashModel>>(
                      //     builder: (ctx, snapshot) {
                      //       // Checking if future is resolved or not
                      //       if (snapshot.connectionState == ConnectionState.done) {
                      //         // If we got an error
                      //         if (snapshot.hasError) {
                      //           return Center(
                      //             child: Text(
                      //               '${snapshot.error} occurred',
                      //               style: TextStyle(fontSize: 18),
                      //             ),
                      //           );
                      //
                      //           // if we got our data
                      //         } else if (snapshot.hasData) {
                      //           // Extracting data from snapshot object
                      //           // final data = snapshot.data as String;
                      //           return Center(
                      //             child: ListView.builder(
                      //               padding: EdgeInsets.zero,
                      //                 itemCount: snapshot.data!.data!.data!.names!.length,
                      //                 itemBuilder: (BuildContext context, int index) {
                      //                   _reportController.posCashLength.value = snapshot.data!.data!.data!.amount!;
                      //                   return Container(
                      //                     color: Colors.white,
                      //                     margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      //                     child: ListTile(
                      //                       contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      //                         title:  Text(
                      //                           "${snapshot.data!.data!.data!.names![index].toString()}",
                      //                           style: TextStyle(color: Colors.black, fontSize: 18),
                      //                         ),
                      //                         subtitle:  Text(
                      //                           "Payment pos cash ${snapshot.data!.data!.data!.amount![index].toString()}",
                      //                           style: TextStyle(color: Colors.black, fontSize: 15),
                      //                         ),
                      //                     ),  // title: Text("List item $index")),
                      //                   );
                      //                 }),
                      //
                      //
                      //
                      //             // Container(
                      //             //   child: Column(
                      //             //     children: [
                      //             //      Row(
                      //             //        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             //        children: [
                      //             //          Text("Name"),
                      //             //          Text("${snapshot.data!.data!.data!.names!.first.toString()}")
                      //             //        ],
                      //             //      ),
                      //             //       SizedBox(height: 10,),
                      //             //       Row(
                      //             //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             //         children: [
                      //             //           Text("Amount"),
                      //             //           Text("${snapshot.data!.data!.data!.amount!.first.toString()}")
                      //             //         ],
                      //             //       ),
                      //             //     ],
                      //             //   ),
                      //             // ),
                      //           );
                      //         }
                      //       }
                      //
                      //       // Displaying LoadingSpinner to indicate waiting state
                      //       return Center(
                      //         child: CircularProgressIndicator(),
                      //       );
                      //     },
                      //
                      //     // Future that needs to be resolved
                      //     // inorder to display something on the Canvas
                      //     future: _reportController.posCashCall(Constants.vendorId),
                      //   ),
                      // ),
                      // Expanded(
                      //   child: FutureBuilder<BaseModel<ReportCardModel>>(
                      //     builder: (ctx, snapshot) {
                      //       // Checking if future is resolved or not
                      //       if (snapshot.connectionState == ConnectionState.done) {
                      //         // If we got an error
                      //         if (snapshot.hasError) {
                      //           return Center(
                      //             child: Text(
                      //               '${snapshot.error} occurred',
                      //               style: TextStyle(fontSize: 18),
                      //             ),
                      //           );
                      //
                      //           // if we got our data
                      //         } else if (snapshot.hasData) {
                      //           // Extracting data from snapshot object
                      //           // final data = snapshot.data as String;
                      //           return Center(
                      //             child: ListView.builder(
                      //                 padding: EdgeInsets.zero,
                      //                 itemCount: snapshot.data!.data!.data!.names!.length,
                      //                 itemBuilder: (BuildContext context, int index) {
                      //                   _reportController.poscardlength.value = snapshot.data!.data!.data!.amount!;
                      //                   return Container(
                      //                     color: Colors.white,
                      //                     margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      //                     child: ListTile(
                      //                       contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      //                       title:  Text(
                      //                         "${snapshot.data!.data!.data!.names![index].toString()}",
                      //                         style: TextStyle(color: Colors.black, fontSize: 18),
                      //                       ),
                      //                       subtitle:  Text(
                      //                         "Payment pos card ${snapshot.data!.data!.data!.amount![index].toString()}",
                      //                         style: TextStyle(color: Colors.black, fontSize: 15),
                      //                       ),
                      //                     ),  // title: Text("List item $index")),
                      //                   );
                      //                 }),
                      //
                      //
                      //
                      //             // Container(
                      //             //   child: Column(
                      //             //     children: [
                      //             //      Row(
                      //             //        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             //        children: [
                      //             //          Text("Name"),
                      //             //          Text("${snapshot.data!.data!.data!.names!.first.toString()}")
                      //             //        ],
                      //             //      ),
                      //             //       SizedBox(height: 10,),
                      //             //       Row(
                      //             //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             //         children: [
                      //             //           Text("Amount"),
                      //             //           Text("${snapshot.data!.data!.data!.amount!.first.toString()}")
                      //             //         ],
                      //             //       ),
                      //             //     ],
                      //             //   ),
                      //             // ),
                      //           );
                      //         }
                      //       }
                      //
                      //       // Displaying LoadingSpinner to indicate waiting state
                      //       return Center(
                      //         child: CircularProgressIndicator(),
                      //       );
                      //     },
                      //
                      //     // Future that needs to be resolved
                      //     // inorder to display something on the Canvas
                      //     future: _reportController.posCardCall(Constants.vendorId),
                      //   ),
                      // ),
                      ///For both Pos card and also pos cash call in same futurebuilder
                      // Expanded(
                      //   child: FutureBuilder<List<dynamic>>(
                      //     builder: (ctx, snapshot) {
                      //       // Checking if future is resolved or not
                      //       if (snapshot.connectionState == ConnectionState.done) {
                      //         // If we got an error
                      //         if (snapshot.hasError) {
                      //           return Center(
                      //             child: Text(
                      //               '${snapshot.error} occurred',
                      //               style: TextStyle(fontSize: 18),
                      //             ),
                      //           );
                      //         } else if (snapshot.hasData) {
                      //           // Combine the two lists
                      //           List<dynamic> list1 = snapshot.data![0];
                      //           List<dynamic> list2 = snapshot.data![1];
                      //           List<dynamic> combinedList = [...list1, ...list2];
                      //           // Build the ListView using the combined list
                      //           return Center(
                      //             child: ListView.builder(
                      //               padding: EdgeInsets.zero,
                      //               itemCount: combinedList.length,
                      //               itemBuilder: (BuildContext context, int index) {
                      //                 print("value..${combinedList[index].toJson()}");
                      //
                      //                 String subtitle = "Payment";
                      //                 // Get the payment method from the current item
                      //                var type = combinedList[index].runtimeType;
                      //                print("type ${type}");
                      //                 ReportCashModel? reportCashModel;
                      //                 ReportCardModel? reportCardModel;
                      //
                      //                 // Check the payment method and call the appropriate model
                      //                 if (type == ReportCashModel) {
                      //                   // Call the Pos cash model
                      //                   print("ABC");
                      //                    reportCashModel = combinedList[index];
                      //                    _reportController.posCashdata.value = reportCashModel!;
                      //                   // posCashModel(combinedList[index]);
                      //                 } else if (type == ReportCardModel) {
                      //                   // Call the Pos card model
                      //                   // posCardModel(combinedList[index]);
                      //                    reportCardModel = combinedList[index];
                      //                    _reportController.posCarddata.value = reportCardModel!;
                      //                   print("DEF");
                      //
                      //                 }
                      //
                      //                 return type == ReportCashModel ?
                      //                 reportCashModel!.data!.names!.length == 0 ? Container() :
                      //                 Container(
                      //                   color: Colors.white,
                      //                   margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      //                   child: ListTile(
                      //                     contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      //                     title: Text(
                      //                         reportCashModel.data!.names!.first.toString(),
                      //                       style: TextStyle(color: Colors.black, fontSize: 18),
                      //                     ),
                      //                     subtitle: Text(
                      //                        "Payement pos cash ${reportCashModel.data!.amount!.first.toString()}",
                      //                       style: TextStyle(color: Colors.black, fontSize: 15),
                      //                     )
                      //                   ),
                      //                 ) :
                      //                 reportCardModel!.data!.names!.length == 0 ? Container() :
                      //                 Container(
                      //                   color: Colors.white,
                      //                   margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      //                   child: ListTile(
                      //                     contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      //                     title: Text(
                      //                       reportCardModel.data!.names!.first.toString(),
                      //                       style: TextStyle(color: Colors.black, fontSize: 18),
                      //                     ),
                      //                     subtitle:  Text(
                      //                       "Payement pos card ${reportCardModel.data!.amount!.first.toString()}",
                      //                       style: TextStyle(color: Colors.black, fontSize: 15),
                      //                     ),
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //             // child: ListView.builder(
                      //             //   padding: EdgeInsets.zero,
                      //             //   itemCount: combinedList.length,
                      //             //   itemBuilder: (BuildContext context, int index) {
                      //             //   print("value..${combinedList[index].toJson()}");
                      //             //
                      //             //     String subtitle = "Payment";
                      //             //     return Container(
                      //             //       color: Colors.white,
                      //             //       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      //             //       child: ListTile(
                      //             //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      //             //         title: Text(
                      //             //           "${combinedList[index].toString()}",
                      //             //           style: TextStyle(color: Colors.black, fontSize: 18),
                      //             //         ),
                      //             //         subtitle: Text(
                      //             //           subtitle,
                      //             //           style: TextStyle(color: Colors.black, fontSize: 15),
                      //             //         ),
                      //             //       ),
                      //             //     );
                      //             //   },
                      //             // ),
                      //           );
                      //         }
                      //       }
                      //
                      //       // Displaying LoadingSpinner to indicate waiting state
                      //       return Center(
                      //         child: CircularProgressIndicator(),
                      //       );
                      //     },
                      //
                      //     // Future that needs to be resolved
                      //     // inorder to display something on the Canvas
                      //     future: Future.wait([
                      //       _reportController.posCashCall(Constants.vendorId),
                      //       _reportController.posCardCall(Constants.vendorId)
                      //     ]),
                      //   ),
                      // ),
                      ///End futurebuilder for both

                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_printerController.printerModel.value.ipPos !=
                                  null) {
                                print("POS ADDED");
                                if (_printerController
                                                .printerModel.value.ipPos ==
                                            '' &&
                                        _printerController
                                                .printerModel.value.portPos ==
                                            '' ||
                                    _printerController
                                                .printerModel.value.ipPos ==
                                            null &&
                                        _printerController
                                                .printerModel.value.portPos ==
                                            null) {
                                  print("pos ip empty");
                                } else {
                                  _reportController.testPrintPOS(
                                    _printerController
                                        .printerModel.value.ipPos!,
                                    int.parse(_printerController
                                        .printerModel.value.portPos!),
                                    context,
                                  );
                                }
                              }
                            },
                            child: Text("Reports")),
                      )
                    ],
                  );
                  // : Center(
                  //     child: Text("No data"),
                  //   );
                }
              }

              // Displaying LoadingSpinner to indicate waiting state
              return Center(
                child: CircularProgressIndicator(),
              );
            },

            // Future that needs to be resolved
            // inorder to display something on the Canvas
            future: _reportController.reportsApiCall(),
          )),
    );
  }
}
