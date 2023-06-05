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

///
import 'dart:async';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/model/report_model.dart';
import 'package:pos/pages/OrderHistory/order_history.dart';
import 'package:pos/pages/Reports/report_controller.dart';
import 'package:pos/printer/printer_controller.dart';
import 'package:pos/utils/app_toolbar_with_btn_clr.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            image: DecorationImage(
              image: AssetImage('assets/images/bg_image.png'),
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
                return SingleChildScrollView(
                  physics: ClampingScrollPhysics(), // Disable scrolling physics
                  clipBehavior: Clip.none,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 6), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Todays Shift",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 40,
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _reportController.reportModelData.value.todaysShifts!.length + 1,
                                    itemBuilder: (BuildContext context, int index) {
                                      if (index == 0) {
                                        // This is the first item, which is the button
                                        return GestureDetector(
                                          onTap: () async {
                                            if (!_reportController.buttonDisable
                                                .value) {
                                              final prefs = await SharedPreferences
                                                  .getInstance();
                                              prefs.setString(
                                                  Constants.shiftCode.toString(),
                                                  '');
                                              _reportController.isLoading.value = true;
                                              _reportController.buttonDisable.value = true;
                                              _reportController.reportsApiCall();
                                              Future.delayed(
                                                  Duration(seconds: 3), () {
                                                _reportController.isLoading.value =
                                                false;
                                              });
                                              Timer(Duration(seconds: 5), () {
                                                _reportController.buttonDisable
                                                    .value = false;
                                              });
                                            } else {
                                              print("button disabled");
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                            margin: EdgeInsets.symmetric(horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: Color(Constants.colorTheme),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Current Shift",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return GestureDetector(
                                          onTap: () async {
                                            if (!_reportController.buttonDisable
                                                .value) {
                                              final prefs = await SharedPreferences
                                                  .getInstance();
                                              prefs.setString(
                                                  Constants.shiftCode.toString(),
                                                  _reportController.reportModelData
                                                      .value.todaysShifts![index - 1]
                                                      .shiftCode.toString());
                                              _reportController.isLoading.value =
                                              true;
                                              _reportController.buttonDisable.value =
                                              true;
                                              _reportController.reportsApiCall();
                                              Future.delayed(
                                                  Duration(seconds: 3), () {
                                                _reportController.isLoading.value =
                                                false;
                                              });
                                              Timer(Duration(seconds: 5), () {
                                                _reportController.buttonDisable
                                                    .value = false;
                                              });
                                            } else {
                                              print("button disabled");
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 12),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                                color: Color(Constants.colorTheme),
                                                borderRadius: BorderRadius.circular(
                                                    10)),
                                            child: Center(
                                              child: IntrinsicWidth(
                                                child: Text(
                                                  "${_reportController.reportModelData
                                                      .value.todaysShifts![index - 1]
                                                      .shiftName}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Obx(()=> _reportController.isLoading.value == true ? Center(
                          child: CircularProgressIndicator(
                            color: Color(Constants.colorTheme),
                          ),
                        ) : Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding:
                                EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5)),
                                child: IntrinsicWidth(
                                  child: Row(
                                    children: [
                                      Image.asset("assets/images/file_report.png", width: 15, height: 15,),
                                      SizedBox(width: 5,),
                                      Text(
                                        "Details (${_reportController.reportModelData.value.currentShift.toString()})",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 6), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_reportController.reportModelData.value.payments!.posCash!.name.toString()} (${_reportController.reportModelData.value.currentShift ?? ''})',
                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    children: [
                                      Row(
                                        children: const [
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                "Pos Card",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                "Pos Cash",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                "Total Sale",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                "Total Takeaway",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                "Total Dining",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                "Total Incomplete",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                "Total Cancelled",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                "Total Discounts",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                "Total Orders",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(children: [

                                        Expanded(
                                            child: Center(
                                                child: Text(
                                                    double
                                                        .parse(
                                                        _reportController.reportModelData.value.payments!
                                                            .posCard!
                                                            .amount!
                                                            .toString())
                                                        .toStringAsFixed(
                                                        2)))),
                                        Expanded(
                                            child: Center(
                                              child: Text(
                                                  double
                                                      .parse(
                                                      _reportController.reportModelData.value.payments!
                                                          .posCash!
                                                          .amount!
                                                          .toString())
                                                      .toStringAsFixed(
                                                      2)),)),
                                        Expanded(
                                          child: Center(
                                              child: Text(
                                                  double
                                                      .parse(
                                                      _reportController.reportModelData.value.payments!
                                                          .totalSale!
                                                          .amount!
                                                          .toString())
                                                      .toStringAsFixed(
                                                      2))),),
                                        Expanded(
                                            child: Center(
                                                child: Text(
                                                    _reportController.reportModelData.value
                                                        .totalTakeaway
                                                        .toString()))),
                                        Expanded(
                                            child: Center(
                                                child: Text(
                                                    _reportController.reportModelData.value
                                                        .totalDining
                                                        .toString()))),
                                        Expanded(
                                            child: Center(
                                                child: Text(
                                                    _reportController.reportModelData.value
                                                        .totalIncomplete
                                                        .toString()))),
                                        Expanded(
                                            child: Center(
                                                child: Text(
                                                    _reportController.reportModelData.value
                                                        .totalCanceled
                                                        .toString()))),
                                        Expanded(
                                            child: Center(
                                                child: Text(
                                                    double
                                                        .parse(
                                                        _reportController.reportModelData.value
                                                            .totalDiscounts
                                                            .toString())
                                                        .toStringAsFixed(
                                                        2)))),
                                        Expanded(
                                          child: Center(
                                              child: Text(
                                                  _reportController.reportModelData.value
                                                      .totalOrders
                                                      .toString())),),
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding:
                                EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5)),
                                child: IntrinsicWidth(
                                  child: Row(
                                    children: [
                                      Image.asset("assets/images/fork.png", color: Colors.white, width: 15, height: 15,),
                                      SizedBox(width: 5,),
                                      Text(
                                        "Orders (${_reportController.reportModelData.value.currentShift.toString()})",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: Get.height / 3,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.3),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 6),
                                        ),
                                      ],
                                      borderRadius: BorderRadius
                                          .circular(15),
                                    ),
                                    child: _reportController.reportModelData.value.orders!.isNotEmpty ? SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                "Item Name",
                                                style: TextStyle(
                                                  color: Color(
                                                      Constants
                                                          .colorTheme),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight
                                                      .w600,
                                                ),
                                              ),
                                              Text(
                                                "Quantity",
                                                style: TextStyle(
                                                  color: Color(
                                                      Constants
                                                          .colorTheme),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight
                                                      .w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            // physics: NeverScrollableScrollPhysics(),
                                            itemCount: _reportController.reportModelData.value.orders!.length,
                                            itemBuilder: (context,
                                                i) {
                                              return  Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                          "assets/images/fork.png",
                                                          height: 10,
                                                          width: 10),
                                                      SizedBox(
                                                          width: 5),
                                                      Text(
                                                        _reportController.reportModelData.value.orders![i]
                                                            .itemName
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors
                                                              .black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    _reportController.reportModelData.value.orders![i]
                                                        .quantity
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors
                                                          .black,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight
                                                          .w400,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ) : Column(
                                      children: [
                                        Text(
                                          "Orders",
                                          style: TextStyle(
                                            color: Color(
                                                Constants
                                                    .colorTheme),
                                            fontSize: 14,
                                            fontWeight: FontWeight
                                                .w600,
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text("No Items", style: TextStyle(color: Colors.black),)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    height: Get.height / 3,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.3),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 6),
                                        ),
                                      ],
                                      borderRadius: BorderRadius
                                          .circular(15),
                                    ),
                                    child:  _reportController.reportModelData.value.incompleteOrdersDetail!.isNotEmpty ? SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Incomplete Orders",
                                            style: TextStyle(
                                              color: Color(
                                                  Constants
                                                      .colorTheme),
                                              fontSize: 16,
                                              fontWeight: FontWeight
                                                  .w600,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          ListView.separated(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: _reportController.reportModelData.value.incompleteOrdersDetail!.length,
                                            itemBuilder: (context,
                                                incompleteIndex) {
                                              return Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    vertical: 5,
                                                    horizontal: 5),
                                                child: Column(
                                                  children: [
                                                    CustomNewRow('Order ID', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].orderId.toString()),
                                                    CustomNewRow('User Name',_reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].userName.toString()),
                                                    CustomNewRow('Mobile',_reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].mobile.toString()),
                                                    CustomNewRow('Cancel By', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].cancelBy ?? 'No Cancel'),
                                                    CustomNewRow('Order Status', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].orderStatus.toString()),
                                                    CustomNewRow('Payment Type', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].paymentType.toString()),
                                                    CustomNewRow('Amount', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].amount.toString()),
                                                    CustomNewRow('Delivery Type', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].deliveryType.toString()),
                                                    CustomNewRow('Discounts', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].discounts.toString()),
                                                    CustomNewRow('Notes', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].notes.toString()),
                                                    CustomNewRow('Cancel Reason', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].cancelReason ?? 'No Cancel'),


                                                  ],
                                                ),
                                              );
                                            }, separatorBuilder: (BuildContext context, int incompleteIndex) {
                                            return Container(
                                                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                child: LineWithCircles());
                                          },
                                          ),
                                        ],
                                      ),
                                    ) : Column(
                                      children: [
                                        Text(
                                          "Incomplete Orders",
                                          style: TextStyle(
                                            color: Color(
                                                Constants
                                                    .colorTheme),
                                            fontSize: 14,
                                            fontWeight: FontWeight
                                                .w600,
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text("No Incomplete Orders", style: TextStyle(color: Colors.black),)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    height: Get.height / 3,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.3),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 6),
                                        ),
                                      ],
                                      borderRadius: BorderRadius
                                          .circular(15),
                                    ),
                                    child: _reportController.reportModelData.value.cancelledOrdersDetail!.isNotEmpty ?  SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Cancelled Orders",
                                            style: TextStyle(
                                              color: Color(
                                                  Constants
                                                      .colorTheme),
                                              fontSize: 16,
                                              fontWeight: FontWeight
                                                  .w600,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          ListView.separated(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: _reportController.reportModelData.value.cancelledOrdersDetail!.length,
                                            itemBuilder: (context,
                                                cancelledIndex) {
                                              return Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    vertical: 5,
                                                    horizontal: 5),
                                                child: Column(
                                                  children: [
                                                    CustomNewRow('Order ID', _reportController.reportModelData.value.cancelledOrdersDetail![cancelledIndex].orderId.toString()),
                                                    CustomNewRow('User Name', _reportController.reportModelData.value.cancelledOrdersDetail![cancelledIndex].userName.toString()),
                                                    CustomNewRow('Mobile',_reportController.reportModelData.value.cancelledOrdersDetail![cancelledIndex].mobile.toString()),
                                                    CustomNewRow('Cancel By', _reportController.reportModelData.value.cancelledOrdersDetail![cancelledIndex].cancelBy ?? 'No Cancel'),
                                                    CustomNewRow('Order Status', _reportController.reportModelData.value.cancelledOrdersDetail![cancelledIndex].orderStatus.toString()),
                                                    CustomNewRow('Payment Type',_reportController.reportModelData.value.cancelledOrdersDetail![cancelledIndex].paymentType.toString()),
                                                    CustomNewRow('Amount', _reportController.reportModelData.value.cancelledOrdersDetail![cancelledIndex].amount.toString()),
                                                    CustomNewRow('Delivery Type', _reportController.reportModelData.value.cancelledOrdersDetail![cancelledIndex].deliveryType.toString()),
                                                    CustomNewRow('Discounts', _reportController.reportModelData.value.cancelledOrdersDetail![cancelledIndex].discounts.toString()),
                                                    CustomNewRow('Notes', _reportController.reportModelData.value.cancelledOrdersDetail![cancelledIndex].notes.toString()),
                                                    CustomNewRow('Cancel Reason', _reportController.reportModelData.value.cancelledOrdersDetail![cancelledIndex].cancelReason ?? 'No Cancel'),
                                                  ],
                                                ),
                                              );
                                            }, separatorBuilder: (BuildContext context, int cancelledIndex) {
                                            return Container(
                                                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                child: LineWithCircles());
                                          },
                                          ),
                                        ],
                                      ),
                                    ) : Column(
                                      children: [
                                        Text(
                                          "Cancelled Orders",
                                          style: TextStyle(
                                            color: Color(
                                                Constants
                                                    .colorTheme),
                                            fontSize: 14,
                                            fontWeight: FontWeight
                                                .w600,
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text("No Cancelled Orders", style: TextStyle(color: Colors.black),)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    // backgroundColor: MaterialStateProperty.all<Color>(Color(CO)),
                                    // set the height to 50
                                    fixedSize: MaterialStateProperty.all<Size>(const Size(120, 30)),
                                  ),
                                  onPressed: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: Text('Print Confirmation'),
                                        content: Text('Do you want to print with items?'),
                                        actions: [
                                          TextButton(
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
                                                      true
                                                  );
                                                }
                                              }
                                              Get.back();
                                            },
                                            child: Text('Yes'),
                                          ),
                                          TextButton(
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
                                                      false
                                                  );
                                                }
                                              }
                                              Get.back();
                                            },
                                            child: Text('No'),
                                          ),
                                        ],
                                      ),
                                    );
                                    // if (_printerController.printerModel.value.ipPos !=
                                    //     null) {
                                    //   print("POS ADDED");
                                    //   if (_printerController
                                    //                   .printerModel.value.ipPos ==
                                    //               '' &&
                                    //           _printerController
                                    //                   .printerModel.value.portPos ==
                                    //               '' ||
                                    //       _printerController
                                    //                   .printerModel.value.ipPos ==
                                    //               null &&
                                    //           _printerController
                                    //                   .printerModel.value.portPos ==
                                    //               null) {
                                    //     print("pos ip empty");
                                    //   } else {
                                    //     _reportController.testPrintPOS(
                                    //       _printerController
                                    //           .printerModel.value.ipPos!,
                                    //       int.parse(_printerController
                                    //           .printerModel.value.portPos!),
                                    //       context,
                                    //     );
                                    //   }
                                    // }
                                  },
                                  child: Text("Print", style: TextStyle(fontSize: 16),)),
                            ),
                          ],
                        ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                );

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
        ),
      ),
    );
  }
}

//return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           SizedBox(height: 20),
//                           Container(
//                             padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.3),
//                                     spreadRadius: 5,
//                                     blurRadius: 7,
//                                     offset: Offset(0, 6), // changes position of shadow
//                                   ),
//                                 ],
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Todays Shift",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Container(
//                                   height: 40,
//                                   child: ListView.builder(
//                                       padding: EdgeInsets.zero,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: _reportController.reportModelData.value.todaysShifts!.length + 1,
//                                       itemBuilder: (BuildContext context, int index) {
//                                         if (index == 0) {
//                                           // This is the first item, which is the button
//                                           return GestureDetector(
//                                             onTap: () async {
//                                               if (!_reportController.buttonDisable
//                                                   .value) {
//                                                 final prefs = await SharedPreferences
//                                                     .getInstance();
//                                                 prefs.setString(
//                                                     Constants.shiftCode.toString(),
//                                                     '');
//                                                 _reportController.isLoading.value = true;
//                                                 _reportController.buttonDisable.value = true;
//                                                 _reportController.reportsApiCall();
//                                                 Future.delayed(
//                                                     Duration(seconds: 3), () {
//                                                   _reportController.isLoading.value =
//                                                   false;
//                                                 });
//                                                 Timer(Duration(seconds: 5), () {
//                                                   _reportController.buttonDisable
//                                                       .value = false;
//                                                 });
//                                               } else {
//                                                 print("button disabled");
//                                               }
//                                             },
//                                             child: Container(
//                                               padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//                                               margin: EdgeInsets.symmetric(horizontal: 8),
//                                               decoration: BoxDecoration(
//                                                 color: Color(Constants.colorTheme),
//                                                 borderRadius: BorderRadius.circular(10),
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   "Current Shift",
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 17,
//                                                     fontWeight: FontWeight.w700,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                         } else {
//                                           return GestureDetector(
//                                             onTap: () async {
//                                               if (!_reportController.buttonDisable
//                                                   .value) {
//                                                 final prefs = await SharedPreferences
//                                                     .getInstance();
//                                                 prefs.setString(
//                                                     Constants.shiftCode.toString(),
//                                                     _reportController.reportModelData
//                                                         .value.todaysShifts![index - 1]
//                                                         .shiftCode.toString());
//                                                 _reportController.isLoading.value =
//                                                 true;
//                                                 _reportController.buttonDisable.value =
//                                                 true;
//                                                 _reportController.reportsApiCall();
//                                                 Future.delayed(
//                                                     Duration(seconds: 3), () {
//                                                   _reportController.isLoading.value =
//                                                   false;
//                                                 });
//                                                 Timer(Duration(seconds: 5), () {
//                                                   _reportController.buttonDisable
//                                                       .value = false;
//                                                 });
//                                               } else {
//                                                 print("button disabled");
//                                               }
//                                             },
//                                             child: Container(
//                                               padding: EdgeInsets.symmetric(
//                                                   vertical: 6, horizontal: 12),
//                                               margin: EdgeInsets.symmetric(
//                                                   horizontal: 8),
//                                               decoration: BoxDecoration(
//                                                   color: Color(Constants.colorTheme),
//                                                   borderRadius: BorderRadius.circular(
//                                                       10)),
//                                               child: Center(
//                                                 child: IntrinsicWidth(
//                                                   child: Text(
//                                                     "${_reportController.reportModelData
//                                                         .value.todaysShifts![index - 1]
//                                                         .shiftName}",
//                                                     style: TextStyle(
//                                                         color: Colors.white,
//                                                         fontSize: 17,
//                                                         fontWeight: FontWeight.w700),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                         }
//                                       }),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Obx(()=> _reportController.isLoading.value == true ? Center(
//                             child: CircularProgressIndicator(
//                               color: Color(Constants.colorTheme),
//                             ),
//                           ) : Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     flex: 3,
//                                     child: Container(
//                                       height: Get.height / 4,
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 16,
//                                           horizontal: 16),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.grey
//                                                 .withOpacity(0.3),
//                                             spreadRadius: 5,
//                                             blurRadius: 7,
//                                             offset: Offset(0, 6),
//                                           ),
//                                         ],
//                                         borderRadius: BorderRadius
//                                             .circular(15),
//                                       ),
//                                       child: _reportController.reportModelData.value.orders!.isNotEmpty ? SingleChildScrollView(
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment
//                                                   .spaceBetween,
//                                               children: [
//                                                 Text(
//                                                   "Item Name",
//                                                   style: TextStyle(
//                                                     color: Color(
//                                                         Constants
//                                                             .colorTheme),
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight
//                                                         .w600,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   "Quantity",
//                                                   style: TextStyle(
//                                                     color: Color(
//                                                         Constants
//                                                             .colorTheme),
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight
//                                                         .w600,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(height: 5),
//                                             ListView.builder(
//                                               shrinkWrap: true,
//                                               // physics: NeverScrollableScrollPhysics(),
//                                               itemCount: _reportController.reportModelData.value.orders!.length,
//                                               itemBuilder: (context,
//                                                   i) {
//                                                 return  Row(
//                                                   mainAxisAlignment: MainAxisAlignment
//                                                       .spaceBetween,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         Image.asset(
//                                                             "assets/images/fork.png",
//                                                             height: 10,
//                                                             width: 10),
//                                                         SizedBox(
//                                                             width: 5),
//                                                         Text(
//                                                           _reportController.reportModelData.value.orders![i]
//                                                               .itemName
//                                                               .toString(),
//                                                           style: TextStyle(
//                                                             color: Colors
//                                                                 .black,
//                                                             fontSize: 14,
//                                                             fontWeight: FontWeight
//                                                                 .w400,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Text(
//                                                       _reportController.reportModelData.value.orders![i]
//                                                           .quantity
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                         color: Colors
//                                                             .black,
//                                                         fontSize: 14,
//                                                         fontWeight: FontWeight
//                                                             .w400,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 );
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                       ) : Column(
//                                         children: [
//                                           Text(
//                                             "Orders",
//                                             style: TextStyle(
//                                               color: Color(
//                                                   Constants
//                                                       .colorTheme),
//                                               fontSize: 14,
//                                               fontWeight: FontWeight
//                                                   .w600,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Align(
//                                                 alignment: Alignment.center,
//                                                 child: Text("No Items", style: TextStyle(color: Colors.black),)),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Expanded(
//                                     child: Container(
//                                       height: Get.height / 4,
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 16,
//                                           horizontal: 8),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.grey
//                                                 .withOpacity(0.3),
//                                             spreadRadius: 5,
//                                             blurRadius: 7,
//                                             offset: Offset(0, 6),
//                                           ),
//                                         ],
//                                         borderRadius: BorderRadius
//                                             .circular(15),
//                                       ),
//                                       child:  _reportController.reportModelData.value.incompleteOrdersDetail!.isNotEmpty ? SingleChildScrollView(
//                                         child: Column(
//                                           children: [
//                                             Text(
//                                               "Incomplete Orders",
//                                               style: TextStyle(
//                                                 color: Color(
//                                                     Constants
//                                                         .colorTheme),
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight
//                                                     .w600,
//                                               ),
//                                             ),
//                                             SizedBox(height: 5),
//                                             ListView.separated(
//                                               shrinkWrap: true,
//                                               itemCount: _reportController.reportModelData.value.incompleteOrdersDetail!.length,
//                                               itemBuilder: (context,
//                                                   incompleteIndex) {
//                                                 return Padding(
//                                                   padding: const EdgeInsets
//                                                       .symmetric(
//                                                       vertical: 5,
//                                                       horizontal: 5),
//                                                   child: Column(
//                                                     children: [
//                                                       CustomNewRow('Order ID', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].orderId.toString()),
//                                                       CustomNewRow('User Name',_reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].userName.toString()),
//                                                       CustomNewRow('Mobile',_reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].mobile.toString()),
//                                                       CustomNewRow('Cancel By', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].cancelBy ?? 'No Cancel'),
//                                                       CustomNewRow('Order Status', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].orderStatus.toString()),
//                                                       CustomNewRow('Payment Type', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].paymentType.toString()),
//                                                       CustomNewRow('Amount', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].amount.toString()),
//                                                       CustomNewRow('Delivery Type', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].deliveryType.toString()),
//                                                       CustomNewRow('Discounts', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].discounts.toString()),
//                                                       CustomNewRow('Notes', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].notes.toString()),
//                                                       CustomNewRow('Cancel Reason', _reportController.reportModelData.value.incompleteOrdersDetail![incompleteIndex].cancelReason ?? 'No Cancel'),
//
//
//                                                     ],
//                                                   ),
//                                                 );
//                                               }, separatorBuilder: (BuildContext context, int incompleteIndex) {
//                                               return Container(
//                                                   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                   child: LineWithCircles());
//                                             },
//                                             ),
//                                           ],
//                                         ),
//                                       ) : Column(
//                                         children: [
//                                           Text(
//                                             "Incomplete Orders",
//                                             style: TextStyle(
//                                               color: Color(
//                                                   Constants
//                                                       .colorTheme),
//                                               fontSize: 14,
//                                               fontWeight: FontWeight
//                                                   .w600,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Align(
//                                                 alignment: Alignment.center,
//                                                 child: Text("No Incomplete Orders", style: TextStyle(color: Colors.black),)),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           ),
//                           SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                   );
///cooo

Widget commonRow(String text1, String text2) {
  return Row(
    children: [
      Expanded(
        child: Text(
          text1,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
      Expanded(
        flex: 6,
        child: Text(
          text2,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    ],
  );
}

Widget CustomNewRow(String text1, String text2){
  return   Padding(
    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text1,
          style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400),
        ),
        Text(
          text2,
          style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400),
        ),
      ],
    ),
  );
}

///
// Expanded(
//   child: Container(
//     child: Row(
//       children: [
//         Expanded(
//           flex: 3,
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 5,
//                     blurRadius: 7,
//                     offset: Offset(0, 6), // changes position of shadow
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(15)),
//             child: _reportController.reportModelData.value.orders!.isNotEmpty ? Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Item Name",
//                       style: TextStyle(
//                           color: Color(Constants.colorTheme),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600),
//                     ),
//                     Text(
//                       "Quantity",
//                       style: TextStyle(
//                           color: Color(Constants.colorTheme),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5,),
//                 Expanded(
//                   child: ListView.builder(
//                       padding: EdgeInsets.zero,
//                       itemCount: _reportController.reportModelData.value.orders!.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Image.asset("assets/images/fork.png", height: 10, width: 10,),
//                                 SizedBox(width: 5,),
//                                 Text(
//                                   _reportController.reportModelData.value.orders![index].itemName.toString(),
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 14,
//                                   fontWeight: FontWeight.w400),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               _reportController.reportModelData.value.orders![index].quantity.toString(),
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400),
//                             ),
//                           ],
//                         );
//                       }),
//                 ),
//               ],
//             ) : Center(
//               child: Text("No Orders"),
//             ),
//           ),
//         ),
//         SizedBox(width: 10),
//         Expanded(
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 5,
//                     blurRadius: 7,
//                     offset: Offset(0, 6), // changes position of shadow
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(15)),
//             child: _reportController.reportModelData.value.incompleteOrdersDetail!.isNotEmpty ? Column(
//               children: [
//                 Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                     "Incomplete Orders",
//                     style: TextStyle(
//                         color: Color(Constants.colorTheme),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 SizedBox(height: 5,),
//                 Expanded(
//                   child: ListView.separated(
//                       padding: EdgeInsets.zero,
//                       itemCount: _reportController.reportModelData.value.incompleteOrdersDetail!.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Column(
//                           children: [
//                             CustomNewRow('Order ID', _reportController.reportModelData.value.incompleteOrdersDetail![index].orderId.toString()),
//                             CustomNewRow('User Name', _reportController.reportModelData.value.incompleteOrdersDetail![index].userName.toString()),
//                             CustomNewRow('Mobile',_reportController.reportModelData.value.incompleteOrdersDetail![index].mobile.toString()),
//                             CustomNewRow('Cancel By', _reportController.reportModelData.value.incompleteOrdersDetail![index].cancelBy ?? 'No Cancel'),
//                             CustomNewRow('Order Status', _reportController.reportModelData.value.incompleteOrdersDetail![index].orderStatus.toString()),
//                             CustomNewRow('Payment Type', _reportController.reportModelData.value.incompleteOrdersDetail![index].paymentType.toString()),
//                             CustomNewRow('Amount', _reportController.reportModelData.value.incompleteOrdersDetail![index].amount.toString()),
//                             CustomNewRow('Delivery Type', _reportController.reportModelData.value.incompleteOrdersDetail![index].deliveryType.toString()),
//                             CustomNewRow('Discounts', _reportController.reportModelData.value.incompleteOrdersDetail![index].discounts.toString()),
//                             CustomNewRow('Notes', _reportController.reportModelData.value.incompleteOrdersDetail![index].notes.toString()),
//                             CustomNewRow('Cancel Reason', _reportController.reportModelData.value.incompleteOrdersDetail![index].cancelReason ?? 'No Cancel'),
//                           ],
//                         );
//                       }, separatorBuilder: (BuildContext context, int index) {
//                         return Container(
//                             margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                             child: LineWithCircles());
//                   },),
//                 ),
//               ],
//             ) :  Center(
//               child: Text("No Incomplete Orders"),
//         ),
//           ),
//         ),
//         SizedBox(width: 10),
//         Expanded(
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 5,
//                     blurRadius: 7,
//                     offset: Offset(0, 6), // changes position of shadow
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(15)),
//             child: _reportController.reportModelData.value.cancelledOrdersDetail!.isNotEmpty ? Column(
//               children: [
//                 Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                     "Cancelled Orders",
//                     style: TextStyle(
//                         color: Color(Constants.colorTheme),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.separated(
//                       padding: EdgeInsets.zero,
//                       itemCount: _reportController.reportModelData.value.cancelledOrdersDetail!.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return  Column(
//                           children: [
//                             CustomNewRow('Order ID', _reportController.reportModelData.value.cancelledOrdersDetail![index].orderId.toString()),
//                             CustomNewRow('User Name', _reportController.reportModelData.value.cancelledOrdersDetail![index].userName.toString()),
//                             CustomNewRow('Mobile', _reportController.reportModelData.value.cancelledOrdersDetail![index].mobile.toString()),
//                             CustomNewRow('Cancel By', _reportController.reportModelData.value.cancelledOrdersDetail![index].cancelBy ?? 'No Cancel'),
//                             CustomNewRow('Order Status', _reportController.reportModelData.value.cancelledOrdersDetail![index].orderStatus ?? 'No Status'),
//                             CustomNewRow('Payment Type', _reportController.reportModelData.value.cancelledOrdersDetail![index].paymentType ?? 'No Payment'),
//                             CustomNewRow('Amount', _reportController.reportModelData.value.cancelledOrdersDetail![index].amount.toString()),
//                             CustomNewRow('Delivery Type', _reportController.reportModelData.value.cancelledOrdersDetail![index].deliveryType.toString()),
//                             CustomNewRow('Discounts', _reportController.reportModelData.value.cancelledOrdersDetail![index].discounts.toString()),
//                             CustomNewRow('Notes', _reportController.reportModelData.value.cancelledOrdersDetail![index].notes.toString()),
//                             CustomNewRow('Cancel Reason', _reportController.reportModelData.value.cancelledOrdersDetail![index].cancelReason ?? 'No Cancel'),
//                           ],
//                         );
//                       }, separatorBuilder: (BuildContext context, int index) {
//                     return Container(
//                         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                         child: LineWithCircles());
//                   },),
//                 ),
//               ],
//             ) :   Center(
//               child: Text("No Cancelled Orders"),
//         ),
//           ),
//         ),
//       ],
//     ),
//   ),
// ),