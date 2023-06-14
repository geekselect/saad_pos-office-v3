import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/model/reports_by_date_model.dart';
import 'package:pos/pages/OrderHistory/order_history.dart';
import 'package:pos/pages/Reports/report_screen.dart';
import 'package:pos/pages/ReportsByDate/reports_by_date_controller.dart';
import 'package:pos/printer/printer_controller.dart';
import 'package:pos/utils/app_toolbar_with_btn_clr.dart';
import 'package:pos/utils/constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../retrofit/base_model.dart';


class ReportsByDate extends StatelessWidget {
  final _reportByDateController = Get.put(ReportByDateController());
  PrinterController _printerController = Get.find<PrinterController>();


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (constraints, newContext) {
        _reportByDateController.startDate.value = '';
        _reportByDateController.endDate.value = '';
        return Obx((){
          return Scaffold(
            appBar: ApplicationToolbarWithClrBtn(
              appbarTitle: 'Reports By Date',
              strButtonTitle: "Select Date",
              btnColor: Color(0XFFFFFFFF),
              onBtnPress: () {
                Get.defaultDialog(
                    title: "Data Picker",
                    content: Container(
                        color: Colors.white,
                        height: 300,
                        width: 300,
                        child: Center(
                          child: SfDateRangePicker(
                            onSelectionChanged: _reportByDateController.onSelectionChanged,
                            selectionMode: DateRangePickerSelectionMode.range,
                            initialSelectedRange: PickerDateRange(
                                DateTime.now().subtract(const Duration(days: 4)),
                                DateTime.now().add(const Duration(days: 3))),
                          ),
                        )
                    ),
                    confirm: ElevatedButton(onPressed: (){
                      _reportByDateController.isValue.value = true;
                      Get.back();
                    }, child: Text("OK"))
                );
              },
            ),
            body: Container(
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                image: const DecorationImage(
                  image: AssetImage('assets/images/bg_image.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  _reportByDateController.startDate.value.isNotEmpty && _reportByDateController.endDate.value.isNotEmpty ? FutureBuilder<BaseModel<ReportByDateModel>>(
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
                          // return Expanded(
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(horizontal: 30),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //       children: [
                          //         SizedBox(height: 20),
                          //         Obx(()=> Expanded(
                          //           child: _reportByDateController.isLoading.value == true ? Center(
                          //             child: CircularProgressIndicator(
                          //               color: Color(Constants.colorTheme),
                          //             ),
                          //           ) : Column(
                          //             children: [
                          //               SizedBox(
                          //                 height: 10,
                          //               ),
                          //               Align(
                          //                 alignment: Alignment.center,
                          //                 child: Container(
                          //                   padding:
                          //                   EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          //                   decoration: BoxDecoration(
                          //                       color: Colors.black,
                          //                       borderRadius: BorderRadius.circular(5)),
                          //                   child: IntrinsicWidth(
                          //                     child: Row(
                          //                       children: [
                          //                         Icon(Icons.calendar_today_outlined, color: Colors.white,),
                          //                         SizedBox(width: 5,),
                          //                         Text(
                          //                           " From : ${DateFormat('yyyy-MM-dd').format(_reportByDateController.reportByDateModelData.value.from!)}  to  ${DateFormat('yyyy-MM-dd').format(_reportByDateController.reportByDateModelData.value.to!)}",
                          //                           style: TextStyle(
                          //                               color: Colors.white,
                          //                               fontSize: 18,
                          //                               fontWeight: FontWeight.w600),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //               SizedBox(
                          //                 height: 10,
                          //               ),
                          //               Container(
                          //                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          //                 margin: EdgeInsets.symmetric(vertical: 5),
                          //                 decoration: BoxDecoration(
                          //                     color: Colors.white,
                          //                     boxShadow: [
                          //                       BoxShadow(
                          //                         color: Colors.grey.withOpacity(0.3),
                          //                         spreadRadius: 5,
                          //                         blurRadius: 7,
                          //                         offset: Offset(0, 6), // changes position of shadow
                          //                       ),
                          //                     ],
                          //                     borderRadius: BorderRadius.circular(10)),
                          //                 child: Column(
                          //                   crossAxisAlignment: CrossAxisAlignment.start,
                          //                   children: [
                          //                     Text(
                          //                       '${_reportByDateController.reportByDateModelData.value.data!.posCash!.name.toString()} (${_reportController.reportModelData.value.currentShift ?? ''})',
                          //                       style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                          //                     ),
                          //                     SizedBox(height: 10),
                          //                     Column(
                          //                       children: [
                          //                         Row(
                          //                           children: const [
                          //                             Expanded(
                          //                               child: Center(
                          //                                 child: Text(
                          //                                   "Type",
                          //                                   style: TextStyle(
                          //                                       fontWeight: FontWeight.w600),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                 child: Text(
                          //                                   "Amount",
                          //                                   style: TextStyle(
                          //                                       fontWeight: FontWeight.w600),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                 child: Text(
                          //                                   "Total Sum",
                          //                                   style: TextStyle(
                          //                                       fontWeight: FontWeight.w600),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                 child: Text(
                          //                                   "Total Takeaway",
                          //                                   style: TextStyle(
                          //                                       fontWeight: FontWeight.w600),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                 child: Text(
                          //                                   "Total Dining",
                          //                                   style: TextStyle(
                          //                                       fontWeight: FontWeight.w600),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                 child: Text(
                          //                                   "Total Incomplete",
                          //                                   style: TextStyle(
                          //                                       fontWeight: FontWeight.w600),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                 child: Text(
                          //                                   "Total Cancelled",
                          //                                   style: TextStyle(
                          //                                       fontWeight: FontWeight.w600),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                 child: Text(
                          //                                   "Total Discounts",
                          //                                   style: TextStyle(
                          //                                       fontWeight: FontWeight.w600),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                 child: Text(
                          //                                   "Total Orders",
                          //                                   style: TextStyle(
                          //                                       fontWeight: FontWeight.w600),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                         SizedBox(height: 10),
                          //                         Row(
                          //                           children: [
                          //                             Expanded(
                          //                                 child: Center(child: Text('Pos Cash'))),
                          //                             Expanded(
                          //                               child: Center(
                          //                                 child: Text(
                          //
                          //                                     double
                          //                                         .parse(
                          //                                         _reportController.reportModelData.value.payments!
                          //                                             .posCash!
                          //                                             .amount!
                          //                                             .toString())
                          //                                         .toStringAsFixed(
                          //                                         2)),
                          //                               ),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                   child: Text(' - - - - - - - - - ', style: TextStyle(
                          //                                       fontWeight: FontWeight.bold
                          //                                   ),)),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                   child: Text(' - - - - - - - - - ', style: TextStyle(
                          //                                       fontWeight: FontWeight.bold
                          //                                   ),)),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                   child: Text(' - - - - - - - - - ', style: TextStyle(
                          //                                       fontWeight: FontWeight.bold
                          //                                   ),)),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                   child: Text(' - - - - - - - - - ', style: TextStyle(
                          //                                       fontWeight: FontWeight.bold
                          //                                   ),)),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                   child: Text(' - - - - - - - - - ', style: TextStyle(
                          //                                       fontWeight: FontWeight.bold
                          //                                   ),)),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                   child: Text(' - - - - - - - - - ', style: TextStyle(
                          //                                       fontWeight: FontWeight.bold
                          //                                   ),)),
                          //                             ),
                          //                             Expanded(
                          //                               child: Center(
                          //                                   child: Text(' - - - - - - - - - ', style: TextStyle(
                          //                                       fontWeight: FontWeight.bold
                          //                                   ),)),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                         SizedBox(height: 10),
                          //                         Row(children: [
                          //                           Expanded(
                          //                               child: Center(
                          //                                   child: Text(
                          //                                       'Pos Card'))),
                          //                           Expanded(
                          //                               child: Center(
                          //                                   child: Text(
                          //                                       double
                          //                                           .parse(
                          //                                           _reportController.reportModelData.value.payments!
                          //                                               .posCard!
                          //                                               .amount!
                          //                                               .toString())
                          //                                           .toStringAsFixed(
                          //                                           2)))),
                          //                           Expanded(
                          //                             child: Center(
                          //                                 child: Text(
                          //                                     double
                          //                                         .parse(
                          //                                         _reportController.reportModelData.value.payments!
                          //                                             .totalSale!
                          //                                             .amount!
                          //                                             .toString())
                          //                                         .toStringAsFixed(
                          //                                         2))),),
                          //                           Expanded(
                          //                               child: Center(
                          //                                   child: Text(
                          //                                       _reportController.reportModelData.value
                          //                                           .totalTakeaway
                          //                                           .toString()))),
                          //                           Expanded(
                          //                               child: Center(
                          //                                   child: Text(
                          //                                       _reportController.reportModelData.value
                          //                                           .totalDining
                          //                                           .toString()))),
                          //                           Expanded(
                          //                               child: Center(
                          //                                   child: Text(
                          //                                       _reportController.reportModelData.value
                          //                                           .totalIncomplete
                          //                                           .toString()))),
                          //                           Expanded(
                          //                               child: Center(
                          //                                   child: Text(
                          //                                       _reportController.reportModelData.value
                          //                                           .totalCanceled
                          //                                           .toString()))),
                          //                           Expanded(
                          //                               child: Center(
                          //                                   child: Text(
                          //                                       double
                          //                                           .parse(
                          //                                           _reportController.reportModelData.value
                          //                                               .totalDiscounts
                          //                                               .toString())
                          //                                           .toStringAsFixed(
                          //                                           2)))),
                          //                           Expanded(
                          //                             child: Center(
                          //                                 child: Text(
                          //                                     _reportController.reportModelData.value
                          //                                         .totalOrders
                          //                                         .toString())),),
                          //                         ]),
                          //                       ],
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //               SizedBox(
                          //                 height: 10,
                          //               ),
                          //               Align(
                          //                 alignment: Alignment.center,
                          //                 child: Container(
                          //                   padding:
                          //                   EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          //                   decoration: BoxDecoration(
                          //                       color: Colors.black,
                          //                       borderRadius: BorderRadius.circular(5)),
                          //                   child: IntrinsicWidth(
                          //                     child: Text(
                          //                       "Orders",
                          //                       style: TextStyle(
                          //                           color: Colors.white,
                          //                           fontSize: 18,
                          //                           fontWeight: FontWeight.w600),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //               SizedBox(height: 10),
                          //               Expanded(
                          //                 child: Container(
                          //                   child: Row(
                          //                     children: [
                          //                       Expanded(
                          //                         flex: 3,
                          //                         child: Container(
                          //                           padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          //                           decoration: BoxDecoration(
                          //                               color: Colors.white,
                          //                               boxShadow: [
                          //                                 BoxShadow(
                          //                                   color: Colors.grey.withOpacity(0.3),
                          //                                   spreadRadius: 5,
                          //                                   blurRadius: 7,
                          //                                   offset: Offset(0, 6), // changes position of shadow
                          //                                 ),
                          //                               ],
                          //                               borderRadius: BorderRadius.circular(15)),
                          //                           child: _reportController.reportModelData.value.orders!.isNotEmpty ? Column(
                          //                             children: [
                          //                               Padding(
                          //                                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          //                                 child: Row(
                          //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                   children: [
                          //                                     Text(
                          //                                       "Item Name",
                          //                                       style: TextStyle(
                          //                                           color: Color(Constants.colorTheme),
                          //                                           fontSize: 14,
                          //                                           fontWeight: FontWeight.w600),
                          //                                     ),
                          //                                     Text(
                          //                                       "Quantity",
                          //                                       style: TextStyle(
                          //                                           color: Color(Constants.colorTheme),
                          //                                           fontSize: 14,
                          //                                           fontWeight: FontWeight.w600),
                          //                                     ),
                          //                                   ],
                          //                                 ),
                          //                               ),
                          //                               SizedBox(height: 5,),
                          //                               Expanded(
                          //                                 child: ListView.builder(
                          //                                     padding: EdgeInsets.zero,
                          //                                     itemCount: _reportController.reportModelData.value.orders!.length,
                          //                                     itemBuilder: (BuildContext context, int index) {
                          //                                       return Padding(
                          //                                         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          //                                         child: Row(
                          //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                           children: [
                          //                                             Row(
                          //                                               children: [
                          //                                                 Image.asset("assets/images/fork.png", height: 10, width: 10,),
                          //                                                 SizedBox(width: 5,),
                          //                                                 Text(
                          //                                                   _reportController.reportModelData.value.orders![index].itemName.toString(),
                          //                                                   style: TextStyle(
                          //                                                       color: Colors.black,
                          //                                                       fontSize: 14,
                          //                                                       fontWeight: FontWeight.w400),
                          //                                                 ),
                          //                                               ],
                          //                                             ),
                          //                                             Padding(
                          //                                               padding: const EdgeInsets.only(right: 16),
                          //                                               child: Text(
                          //                                                 _reportController.reportModelData.value.orders![index].quantity.toString(),
                          //                                                 style: TextStyle(
                          //                                                     color: Colors.black,
                          //                                                     fontSize: 14,
                          //                                                     fontWeight: FontWeight.w400),
                          //                                               ),
                          //                                             ),
                          //                                           ],
                          //                                         ),
                          //                                       );
                          //                                     }),
                          //                               ),
                          //                             ],
                          //                           ) : Center(
                          //                             child: Text("No Orders"),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                       SizedBox(width: 10),
                          //                       Expanded(
                          //                         child: Container(
                          //                           padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          //                           decoration: BoxDecoration(
                          //                               color: Colors.white,
                          //                               boxShadow: [
                          //                                 BoxShadow(
                          //                                   color: Colors.grey.withOpacity(0.3),
                          //                                   spreadRadius: 5,
                          //                                   blurRadius: 7,
                          //                                   offset: Offset(0, 6), // changes position of shadow
                          //                                 ),
                          //                               ],
                          //                               borderRadius: BorderRadius.circular(15)),
                          //                           child: _reportController.reportModelData.value.incompleteOrdersDetail!.isNotEmpty ? Column(
                          //                             children: [
                          //                               Align(
                          //                                 alignment: Alignment.center,
                          //                                 child: Text(
                          //                                   "Incomplete Orders",
                          //                                   style: TextStyle(
                          //                                       color: Color(Constants.colorTheme),
                          //                                       fontSize: 14,
                          //                                       fontWeight: FontWeight.w600),
                          //                                 ),
                          //                               ),
                          //                               SizedBox(height: 5,),
                          //                               Expanded(
                          //                                 child: ListView.separated(
                          //                                   padding: EdgeInsets.zero,
                          //                                   itemCount: _reportController.reportModelData.value.incompleteOrdersDetail!.length,
                          //                                   itemBuilder: (BuildContext context, int index) {
                          //                                     return Column(
                          //                                       children: [
                          //                                         CustomNewRow('Order ID', _reportController.reportModelData.value.incompleteOrdersDetail![index].orderId.toString()),
                          //                                         CustomNewRow('User Name', _reportController.reportModelData.value.incompleteOrdersDetail![index].userName.toString()),
                          //                                         CustomNewRow('Mobile',_reportController.reportModelData.value.incompleteOrdersDetail![index].mobile.toString()),
                          //                                         CustomNewRow('Cancel By', _reportController.reportModelData.value.incompleteOrdersDetail![index].cancelBy ?? 'No Cancel'),
                          //                                         CustomNewRow('Order Status', _reportController.reportModelData.value.incompleteOrdersDetail![index].orderStatus.toString()),
                          //                                         CustomNewRow('Payment Type', _reportController.reportModelData.value.incompleteOrdersDetail![index].paymentType.toString()),
                          //                                         CustomNewRow('Amount', _reportController.reportModelData.value.incompleteOrdersDetail![index].amount.toString()),
                          //                                         CustomNewRow('Delivery Type', _reportController.reportModelData.value.incompleteOrdersDetail![index].deliveryType.toString()),
                          //                                         CustomNewRow('Discounts', _reportController.reportModelData.value.incompleteOrdersDetail![index].discounts.toString()),
                          //                                         CustomNewRow('Notes', _reportController.reportModelData.value.incompleteOrdersDetail![index].notes.toString()),
                          //                                         CustomNewRow('Cancel Reason', _reportController.reportModelData.value.incompleteOrdersDetail![index].cancelReason ?? 'No Cancel'),
                          //                                       ],
                          //                                     );
                          //                                   }, separatorBuilder: (BuildContext context, int index) {
                          //                                   return Container(
                          //                                       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          //                                       child: LineWithCircles());
                          //                                 },),
                          //                               ),
                          //                             ],
                          //                           ) :  Center(
                          //                             child: Text("No Incomplete Orders"),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                       SizedBox(width: 10),
                          //                       Expanded(
                          //                         child: Container(
                          //                           padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          //                           decoration: BoxDecoration(
                          //                               color: Colors.white,
                          //                               boxShadow: [
                          //                                 BoxShadow(
                          //                                   color: Colors.grey.withOpacity(0.3),
                          //                                   spreadRadius: 5,
                          //                                   blurRadius: 7,
                          //                                   offset: Offset(0, 6), // changes position of shadow
                          //                                 ),
                          //                               ],
                          //                               borderRadius: BorderRadius.circular(15)),
                          //                           child: _reportController.reportModelData.value.cancelledOrdersDetail!.isNotEmpty ? Column(
                          //                             children: [
                          //                               Align(
                          //                                 alignment: Alignment.center,
                          //                                 child: Text(
                          //                                   "Cancelled Orders",
                          //                                   style: TextStyle(
                          //                                       color: Color(Constants.colorTheme),
                          //                                       fontSize: 14,
                          //                                       fontWeight: FontWeight.w600),
                          //                                 ),
                          //                               ),
                          //                               Expanded(
                          //                                 child: ListView.separated(
                          //                                   padding: EdgeInsets.zero,
                          //                                   itemCount: _reportController.reportModelData.value.cancelledOrdersDetail!.length,
                          //                                   itemBuilder: (BuildContext context, int index) {
                          //                                     return  Column(
                          //                                       children: [
                          //                                         CustomNewRow('Order ID', _reportController.reportModelData.value.cancelledOrdersDetail![index].orderId.toString()),
                          //                                         CustomNewRow('User Name', _reportController.reportModelData.value.cancelledOrdersDetail![index].userName.toString()),
                          //                                         CustomNewRow('Mobile', _reportController.reportModelData.value.cancelledOrdersDetail![index].mobile.toString()),
                          //                                         CustomNewRow('Cancel By', _reportController.reportModelData.value.cancelledOrdersDetail![index].cancelBy ?? 'No Cancel'),
                          //                                         CustomNewRow('Order Status', _reportController.reportModelData.value.cancelledOrdersDetail![index].orderStatus ?? 'No Status'),
                          //                                         CustomNewRow('Payment Type', _reportController.reportModelData.value.cancelledOrdersDetail![index].paymentType ?? 'No Payment'),
                          //                                         CustomNewRow('Amount', _reportController.reportModelData.value.cancelledOrdersDetail![index].amount.toString()),
                          //                                         CustomNewRow('Delivery Type', _reportController.reportModelData.value.cancelledOrdersDetail![index].deliveryType.toString()),
                          //                                         CustomNewRow('Discounts', _reportController.reportModelData.value.cancelledOrdersDetail![index].discounts.toString()),
                          //                                         CustomNewRow('Notes', _reportController.reportModelData.value.cancelledOrdersDetail![index].notes.toString()),
                          //                                         CustomNewRow('Cancel Reason', _reportController.reportModelData.value.cancelledOrdersDetail![index].cancelReason ?? 'No Cancel'),
                          //                                       ],
                          //                                     );
                          //                                   }, separatorBuilder: (BuildContext context, int index) {
                          //                                   return Container(
                          //                                       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          //                                       child: LineWithCircles());
                          //                                 },),
                          //                               ),
                          //                             ],
                          //                           ) :   Center(
                          //                             child: Text("No Cancelled Orders"),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ),
                          //               SizedBox(
                          //                 height: 10,
                          //               ),
                          //               Align(
                          //                 alignment: Alignment.center,
                          //                 child: ElevatedButton(
                          //                     onPressed: () {
                          //                       Get.dialog(
                          //                         AlertDialog(
                          //                           title: Text('Print Confirmation'),
                          //                           content: Text('Do you want to print with items?'),
                          //                           actions: [
                          //                             TextButton(
                          //                               onPressed: () {
                          //                                 if (_printerController.printerModel.value.ipPos !=
                          //                                     null) {
                          //                                   print("POS ADDED");
                          //                                   if (_printerController
                          //                                       .printerModel.value.ipPos ==
                          //                                       '' &&
                          //                                       _printerController
                          //                                           .printerModel.value.portPos ==
                          //                                           '' ||
                          //                                       _printerController
                          //                                           .printerModel.value.ipPos ==
                          //                                           null &&
                          //                                           _printerController
                          //                                               .printerModel.value.portPos ==
                          //                                               null) {
                          //                                     print("pos ip empty");
                          //                                   } else {
                          //                                     _reportController.testPrintPOS(
                          //                                         _printerController
                          //                                             .printerModel.value.ipPos!,
                          //                                         int.parse(_printerController
                          //                                             .printerModel.value.portPos!),
                          //                                         context,
                          //                                         true
                          //                                     );
                          //                                   }
                          //                                 }
                          //                                 Get.back();
                          //                               },
                          //                               child: Text('Yes'),
                          //                             ),
                          //                             TextButton(
                          //                               onPressed: () {
                          //                                 if (_printerController.printerModel.value.ipPos !=
                          //                                     null) {
                          //                                   print("POS ADDED");
                          //                                   if (_printerController
                          //                                       .printerModel.value.ipPos ==
                          //                                       '' &&
                          //                                       _printerController
                          //                                           .printerModel.value.portPos ==
                          //                                           '' ||
                          //                                       _printerController
                          //                                           .printerModel.value.ipPos ==
                          //                                           null &&
                          //                                           _printerController
                          //                                               .printerModel.value.portPos ==
                          //                                               null) {
                          //                                     print("pos ip empty");
                          //                                   } else {
                          //                                     _reportController.testPrintPOS(
                          //                                         _printerController
                          //                                             .printerModel.value.ipPos!,
                          //                                         int.parse(_printerController
                          //                                             .printerModel.value.portPos!),
                          //                                         context,
                          //                                         false
                          //                                     );
                          //                                   }
                          //                                 }
                          //                                 Get.back();
                          //                               },
                          //                               child: Text('No'),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       );
                          //                       // if (_printerController.printerModel.value.ipPos !=
                          //                       //     null) {
                          //                       //   print("POS ADDED");
                          //                       //   if (_printerController
                          //                       //                   .printerModel.value.ipPos ==
                          //                       //               '' &&
                          //                       //           _printerController
                          //                       //                   .printerModel.value.portPos ==
                          //                       //               '' ||
                          //                       //       _printerController
                          //                       //                   .printerModel.value.ipPos ==
                          //                       //               null &&
                          //                       //           _printerController
                          //                       //                   .printerModel.value.portPos ==
                          //                       //               null) {
                          //                       //     print("pos ip empty");
                          //                       //   } else {
                          //                       //     _reportController.testPrintPOS(
                          //                       //       _printerController
                          //                       //           .printerModel.value.ipPos!,
                          //                       //       int.parse(_printerController
                          //                       //           .printerModel.value.portPos!),
                          //                       //       context,
                          //                       //     );
                          //                       //   }
                          //                       // }
                          //                     },
                          //                     child: Text("Print")),
                          //               ),
                          //
                          //             ],
                          //           ),
                          //         ),
                          //         ),
                          //         SizedBox(height: 20),
                          //       ],
                          //     ),
                          //   ),
                          // );
                          //   Extracting data from snapshot object
                          return Expanded(
                            child: Padding(
                              padding: constraints.width > 650 ? const EdgeInsets.symmetric(horizontal: 30) :  const EdgeInsets.symmetric(horizontal: 15),
                              child:  _reportByDateController.reportByDateModelData.value.data!.isNotEmpty ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10,),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: IntrinsicWidth(
                                          child: Row(
                                            children: [
                                              Icon(Icons.calendar_today_outlined, color: Colors.white, size: 16,),
                                              _reportByDateController.reportByDateModelData.value.data!.isNotEmpty ? Text(" From : ${DateFormat('yyyy-MM-dd').format(_reportByDateController.reportByDateModelData.value.data!.first.date!)} to ${DateFormat('yyyy-MM-dd').format(_reportByDateController.reportByDateModelData.value.data!.last.date!)}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),) : Text("No Data",  style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold), ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: _reportByDateController.reportByDateModelData.value.data!.length + 1,
                                        itemBuilder: (context, index) {
                                          if(index == _reportByDateController.reportByDateModelData.value.data!.length){
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 10,),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    padding: EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    child: IntrinsicWidth(
                                                      child: Center(
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.money, color: Colors.white, size: 16,),
                                                            _reportByDateController.reportByDateModelData.value.data!.isNotEmpty ? Text(" Total Item Sold (From : ${DateFormat('yyyy-MM-dd').format(_reportByDateController.reportByDateModelData.value.data!.first.date!)}  to ${DateFormat('yyyy-MM-dd').format(_reportByDateController.reportByDateModelData.value.data!.last.date!)})",
                                                              style: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold),
                                                              textAlign: TextAlign.center,

                                                            )  : Text("No Data",  style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold), ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
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
                                                      borderRadius: BorderRadius
                                                          .circular(10)
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children:  [
                                                          Text("Total Sum", style: TextStyle(
                                                              color: Color(Constants.colorTheme)
                                                          ),),
                                                          Text("Total Amount", style: TextStyle(
                                                              color: Color(Constants.colorTheme)
                                                          ),),
                                                        ],
                                                      ),
                                                      CustomNewRow("Total Sum Pos Cash", _reportByDateController.reportByDateModelData.value.sumPosCash!.toStringAsFixed(2)),
                                                      CustomNewRow("Total Sum Pos Card", _reportByDateController.reportByDateModelData.value.sumPosCard!.toStringAsFixed(2)),
                                                      CustomNewRow("Total Sum Pos", double.parse(_reportByDateController.reportByDateModelData.value.sumPosTotal!.toString()).toStringAsFixed(2)),
                                                      CustomNewRow("Total Orders", _reportByDateController.reportByDateModelData.value.sumTotalOrders!.toString()),
                                                      CustomNewRow("Total TakeAway Orders", _reportByDateController.reportByDateModelData.value.sumTotalTakeaway!.toString()),
                                                      CustomNewRow("Total Dining Orders", _reportByDateController.reportByDateModelData.value.sumTotalDining!.toString()),
                                                      CustomNewRow("Total Discounts", double.parse(_reportByDateController.reportByDateModelData.value.sumTotalDiscounts!.toString()).toStringAsFixed(2)),
                                                      CustomNewRow("Total InComplete", _reportByDateController.reportByDateModelData.value.sunTotalIncomplete!.toString()),
                                                      CustomNewRow("Total Cancelled", _reportByDateController.reportByDateModelData.value.sumTotalCanceled!.toString()),
                                                    ],
                                                  ),
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
                                                                      _reportByDateController.testPrintPOS(
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
                                                                      _reportByDateController.testPrintPOS(
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
                                                      },
                                                      child: Text("All Report", style: TextStyle(fontSize: 16))),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Container(
                                              margin: EdgeInsets.all(4),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 10,),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      padding: EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius: BorderRadius
                                                              .circular(5)
                                                      ),
                                                      child: IntrinsicWidth(
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons
                                                                .calendar_today_outlined,
                                                              color: Colors.white,
                                                              size: 16,),
                                                            Text(
                                                                " Date ${DateFormat('yyyy-MM-dd').format(_reportByDateController.reportByDateModelData.value.data![0].date!)} (${_reportByDateController.reportByDateModelData.value.data![0].shiftName.toString()})",
                                                              // " Date ${DateFormat(
                                                              //     'yyyy-MM-dd')
                                                              //     .format(
                                                              //     _reportByDateController
                                                              //         .reportByDateModelData
                                                              //         .value
                                                              //         .data![index]
                                                              //         .date!)} (${_reportByDateController.reportByDateModelData.value.data![index].shiftName.toString()})",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight
                                                                      .bold),),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(0.3),
                                                            spreadRadius: 5,
                                                            blurRadius: 7,
                                                            offset: Offset(0,
                                                                6), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius: BorderRadius
                                                            .circular(10)),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          '${_reportByDateController
                                                              .reportByDateModelData
                                                              .value.data![index]
                                                              .posCash!.name
                                                              .toString()}',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .w700,
                                                              fontSize: 16),
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
                                                                          fontWeight: FontWeight
                                                                              .w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Pos Cash",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Total Sale",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Total Takeaway",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Total Dining",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Total Incomplete",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Total Cancelled",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Total Discounts",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Total Orders",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600),
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
                                                                              _reportByDateController
                                                                                  .reportByDateModelData
                                                                                  .value
                                                                                  .data![index]
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
                                                                          _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value
                                                                              .data![index]
                                                                              .posCash!
                                                                              .amount!
                                                                              .toString())
                                                                          .toStringAsFixed(
                                                                          2)),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Center(
                                                                    child: Text(
                                                                        double
                                                                            .parse(
                                                                            _reportByDateController
                                                                                .reportByDateModelData
                                                                                .value
                                                                                .data![index]
                                                                                .posTotalSale!
                                                                                .amount!
                                                                                .toString())
                                                                            .toStringAsFixed(
                                                                            2))),),
                                                              Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value
                                                                              .data![index]
                                                                              .orderPlaced!
                                                                              .totalTakeaway
                                                                              .toString()))),
                                                              Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value
                                                                              .data![index]
                                                                              .orderPlaced!
                                                                              .totalDining
                                                                              .toString()))),
                                                              Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value
                                                                              .data![index]
                                                                              .orderPlaced!
                                                                              .totalIncomplete
                                                                              .toString()))),
                                                              Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value
                                                                              .data![index]
                                                                              .orderPlaced!
                                                                              .totalCanceled
                                                                              .toString()))),
                                                              Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          double
                                                                              .parse(
                                                                              _reportByDateController
                                                                                  .reportByDateModelData
                                                                                  .value
                                                                                  .data![index]
                                                                                  .orderPlaced!
                                                                                  .totalDiscounts
                                                                                  .toString())
                                                                              .toStringAsFixed(
                                                                              2)))),
                                                              Expanded(
                                                                child: Center(
                                                                    child: Text(
                                                                        _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value
                                                                            .data![index]
                                                                            .orderPlaced!
                                                                            .totalOrders
                                                                            .toString())),),
                                                            ]),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      padding: EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius: BorderRadius
                                                              .circular(5)
                                                      ),
                                                      child: IntrinsicWidth(
                                                        child: Row(
                                                          children: [
                                                            Image.asset("assets/images/fork.png", color: Colors.white, width: 15, height: 15,),
                                                            SizedBox(width: 5,),
                                                            Text("Orders ${DateFormat(
                                                                'yyyy-MM-dd')
                                                                .format(
                                                                _reportByDateController
                                                                    .reportByDateModelData
                                                                    .value
                                                                    .data![index]
                                                                    .date!)} (${_reportByDateController.reportByDateModelData.value.data![index].shiftName.toString()})",
                                                              style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight
                                                                      .bold),),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  constraints.width > 650 ? Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                          height: Get.height / 4,
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
                                                          child: _reportByDateController
                                                              .reportByDateModelData
                                                              .value.data![index]
                                                              .orders!.isNotEmpty ? SingleChildScrollView(
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
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemCount: _reportByDateController
                                                                      .reportByDateModelData
                                                                      .value.data![index]
                                                                      .orders!.length,
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
                                                                              _reportByDateController
                                                                                  .reportByDateModelData
                                                                                  .value
                                                                                  .data![index]
                                                                                  .orders![i]
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
                                                                          _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value
                                                                              .data![index]
                                                                              .orders![i]
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
                                                          height: Get.height / 4,
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
                                                          child:  _reportByDateController
                                                              .reportByDateModelData
                                                              .value.data![index]
                                                              .orderPlaced!.incompleteOrdersDetail!.isNotEmpty ? SingleChildScrollView(
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
                                                                  itemCount: _reportByDateController
                                                                      .reportByDateModelData
                                                                      .value.data![index]
                                                                      .orderPlaced!.incompleteOrdersDetail!.length,
                                                                  itemBuilder: (context,
                                                                      incompleteIndex) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical: 5,
                                                                          horizontal: 5),
                                                                      child: Column(
                                                                        children: [
                                                                          CustomNewRow('Order ID', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.incompleteOrdersDetail![incompleteIndex].orderId.toString()),
                                                                          CustomNewRow('User Name', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.incompleteOrdersDetail![incompleteIndex].userName.toString()),
                                                                          CustomNewRow('Mobile',_reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.incompleteOrdersDetail![incompleteIndex].mobile.toString()),
                                                                          CustomNewRow('Cancel By', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.incompleteOrdersDetail![incompleteIndex].cancelBy ?? 'No Cancel'),
                                                                          CustomNewRow('Order Status', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.incompleteOrdersDetail![incompleteIndex].orderStatus.toString()),
                                                                          CustomNewRow('Payment Type', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.incompleteOrdersDetail![incompleteIndex].paymentType.toString()),
                                                                          CustomNewRow('Amount', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.incompleteOrdersDetail![incompleteIndex].amount.toString()),
                                                                          CustomNewRow('Delivery Type', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.incompleteOrdersDetail![incompleteIndex].deliveryType.toString()),
                                                                          CustomNewRow('Discounts', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.incompleteOrdersDetail![incompleteIndex].discounts.toString()),
                                                                          CustomNewRow('Notes', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.incompleteOrdersDetail![incompleteIndex].notes.toString()),
                                                                          CustomNewRow('Cancel Reason', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.incompleteOrdersDetail![incompleteIndex].cancelReason ?? 'No Cancel'),


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
                                                          height: Get.height / 4,
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
                                                          child: _reportByDateController
                                                              .reportByDateModelData
                                                              .value.data![index]
                                                              .orderPlaced!.cancelledOrdersDetail!.isNotEmpty ?  SingleChildScrollView(
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
                                                                  itemCount: _reportByDateController
                                                                      .reportByDateModelData
                                                                      .value.data![index]
                                                                      .orderPlaced!.cancelledOrdersDetail!.length,
                                                                  itemBuilder: (context,
                                                                      cancelledIndex) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical: 5,
                                                                          horizontal: 5),
                                                                      child: Column(
                                                                        children: [
                                                                          CustomNewRow('Order ID', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.cancelledOrdersDetail![cancelledIndex].orderId.toString()),
                                                                          CustomNewRow('User Name', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.cancelledOrdersDetail![cancelledIndex].userName.toString()),
                                                                          CustomNewRow('Mobile',_reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.cancelledOrdersDetail![cancelledIndex].mobile.toString()),
                                                                          CustomNewRow('Cancel By', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.cancelledOrdersDetail![cancelledIndex].cancelBy ?? 'No Cancel'),
                                                                          CustomNewRow('Order Status', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.cancelledOrdersDetail![cancelledIndex].orderStatus.toString()),
                                                                          CustomNewRow('Payment Type', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.cancelledOrdersDetail![cancelledIndex].paymentType.toString()),
                                                                          CustomNewRow('Amount', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.cancelledOrdersDetail![cancelledIndex].amount.toString()),
                                                                          CustomNewRow('Delivery Type', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.cancelledOrdersDetail![cancelledIndex].deliveryType.toString()),
                                                                          CustomNewRow('Discounts', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.cancelledOrdersDetail![cancelledIndex].discounts.toString()),
                                                                          CustomNewRow('Notes', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.cancelledOrdersDetail![cancelledIndex].notes.toString()),
                                                                          CustomNewRow('Cancel Reason', _reportByDateController
                                                                              .reportByDateModelData
                                                                              .value.data![index]
                                                                              .orderPlaced!.cancelledOrdersDetail![cancelledIndex].cancelReason ?? 'No Cancel'),


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
                                                  ) :  Column(
                                                    children: [
                                                      Container(
                                                        height: Get.height / 4,
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
                                                        child: _reportByDateController
                                                            .reportByDateModelData
                                                            .value.data![index]
                                                            .orders!.isNotEmpty ? SingleChildScrollView(
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
                                                                physics: NeverScrollableScrollPhysics(),
                                                                itemCount: _reportByDateController
                                                                    .reportByDateModelData
                                                                    .value.data![index]
                                                                    .orders!.length,
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
                                                                            _reportByDateController
                                                                                .reportByDateModelData
                                                                                .value
                                                                                .data![index]
                                                                                .orders![i]
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
                                                                        _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value
                                                                            .data![index]
                                                                            .orders![i]
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
                                                      SizedBox(height: 10),
                                                      Container(
                                                        height: Get.height / 4,
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
                                                        child:  _reportByDateController
                                                            .reportByDateModelData
                                                            .value.data![index]
                                                            .orderPlaced!.incompleteOrdersDetail!.isNotEmpty ? SingleChildScrollView(
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
                                                                itemCount: _reportByDateController
                                                                    .reportByDateModelData
                                                                    .value.data![index]
                                                                    .orderPlaced!.incompleteOrdersDetail!.length,
                                                                itemBuilder: (context,
                                                                    incompleteIndex) {
                                                                  return Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical: 5,
                                                                        horizontal: 5),
                                                                    child: Column(
                                                                      children: [
                                                                        CustomNewRow('Order ID', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.incompleteOrdersDetail![incompleteIndex].orderId.toString()),
                                                                        CustomNewRow('User Name', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.incompleteOrdersDetail![incompleteIndex].userName.toString()),
                                                                        CustomNewRow('Mobile',_reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.incompleteOrdersDetail![incompleteIndex].mobile.toString()),
                                                                        CustomNewRow('Cancel By', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.incompleteOrdersDetail![incompleteIndex].cancelBy ?? 'No Cancel'),
                                                                        CustomNewRow('Order Status', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.incompleteOrdersDetail![incompleteIndex].orderStatus.toString()),
                                                                        CustomNewRow('Payment Type', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.incompleteOrdersDetail![incompleteIndex].paymentType.toString()),
                                                                        CustomNewRow('Amount', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.incompleteOrdersDetail![incompleteIndex].amount.toString()),
                                                                        CustomNewRow('Delivery Type', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.incompleteOrdersDetail![incompleteIndex].deliveryType.toString()),
                                                                        CustomNewRow('Discounts', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.incompleteOrdersDetail![incompleteIndex].discounts.toString()),
                                                                        CustomNewRow('Notes', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.incompleteOrdersDetail![incompleteIndex].notes.toString()),
                                                                        CustomNewRow('Cancel Reason', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.incompleteOrdersDetail![incompleteIndex].cancelReason ?? 'No Cancel'),


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
                                                      SizedBox(height: 10),
                                                      Container(
                                                        height: Get.height / 4,
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
                                                        child: _reportByDateController
                                                            .reportByDateModelData
                                                            .value.data![index]
                                                            .orderPlaced!.cancelledOrdersDetail!.isNotEmpty ?  SingleChildScrollView(
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
                                                                itemCount: _reportByDateController
                                                                    .reportByDateModelData
                                                                    .value.data![index]
                                                                    .orderPlaced!.cancelledOrdersDetail!.length,
                                                                itemBuilder: (context,
                                                                    cancelledIndex) {
                                                                  return Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical: 5,
                                                                        horizontal: 5),
                                                                    child: Column(
                                                                      children: [
                                                                        CustomNewRow('Order ID', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.cancelledOrdersDetail![cancelledIndex].orderId.toString()),
                                                                        CustomNewRow('User Name', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.cancelledOrdersDetail![cancelledIndex].userName.toString()),
                                                                        CustomNewRow('Mobile',_reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.cancelledOrdersDetail![cancelledIndex].mobile.toString()),
                                                                        CustomNewRow('Cancel By', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.cancelledOrdersDetail![cancelledIndex].cancelBy ?? 'No Cancel'),
                                                                        CustomNewRow('Order Status', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.cancelledOrdersDetail![cancelledIndex].orderStatus.toString()),
                                                                        CustomNewRow('Payment Type', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.cancelledOrdersDetail![cancelledIndex].paymentType.toString()),
                                                                        CustomNewRow('Amount', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.cancelledOrdersDetail![cancelledIndex].amount.toString()),
                                                                        CustomNewRow('Delivery Type', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.cancelledOrdersDetail![cancelledIndex].deliveryType.toString()),
                                                                        CustomNewRow('Discounts', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.cancelledOrdersDetail![cancelledIndex].discounts.toString()),
                                                                        CustomNewRow('Notes', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.cancelledOrdersDetail![cancelledIndex].notes.toString()),
                                                                        CustomNewRow('Cancel Reason', _reportByDateController
                                                                            .reportByDateModelData
                                                                            .value.data![index]
                                                                            .orderPlaced!.cancelledOrdersDetail![cancelledIndex].cancelReason ?? 'No Cancel'),


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
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                  ]
                              ) : Center(
                                child: Text("No Data"),
                              ),
                            ),
                          );
                        }
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    future: _reportByDateController.reportsApiByDateCall(),
                  ) : Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Get.defaultDialog(
                            title: "Data Picker",
                            content: Container(
                                color: Colors.white,
                                height: 300,
                                width: 300,
                                child: Center(
                                  child: SfDateRangePicker(
                                    onSelectionChanged: _reportByDateController.onSelectionChanged,
                                    selectionMode: DateRangePickerSelectionMode.range,
                                    initialSelectedRange: PickerDateRange(
                                        DateTime.now().subtract(const Duration(days: 4)),
                                        DateTime.now().add(const Duration(days: 3))),
                                  ),
                                )
                            ),
                            confirm: ElevatedButton(onPressed: (){
                              _reportByDateController.isValue.value = true;
                              Get.back();
                            }, child: Text("OK"))
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Center(child: Text("Select Date", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                        ),)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        );
      }
    );
    // return Obx(
    //   () => Scaffold(
    //       appBar: ApplicationToolbarWithClrBtn(
    //         appbarTitle: 'Reports',
    //         strButtonTitle: "",
    //         btnColor: Color(Constants.colorLike),
    //         onBtnPress: () {},
    //       ),
    //       body: Container(
    //         decoration: BoxDecoration(
    //             color: Colors.red.shade50,
    //             image: const DecorationImage(
    //               image: AssetImage('images/ic_background_image.png'),
    //               fit: BoxFit.cover,
    //             )),
    //         child: Column(
    //           children: [
    //             TextButton(
    //                 onPressed: () async {
    //                   if (_reportByDateController.startDateSelect.value ==
    //                       false) {
    //                     final startDate = await showDatePicker(
    //                       context: context,
    //                       initialDate: DateTime.now(),
    //                       firstDate: DateTime(2000),
    //                       lastDate: DateTime.now(),
    //                     );
    //                     if (startDate != null) {
    //                       _reportByDateController.startDateSelect.value = true;
    //                       _reportByDateController
    //                           .onStartDateSelected(startDate);
    //                     }
    //                   }
    //                 },
    //                 child: Text(
    //                     _reportByDateController.startDateSelect.value == true
    //                         ? _reportByDateController.startDate.value
    //                         : "Start")),
    //             TextButton(
    //                 onPressed: () async {
    //                   if (_reportByDateController.endDateSelect.value ==
    //                       false) {
    //                     final endDate = await showDatePicker(
    //                       context: context,
    //                       initialDate: DateTime.now(),
    //                       firstDate: DateTime(2000),
    //                       lastDate: DateTime.now(),
    //                     );
    //                     if (endDate != null) {
    //                       _reportByDateController.endDateSelect.value = true;
    //                       _reportByDateController.onEndDateSelected(endDate);
    //                     }
    //                   }
    //                 },
    //                 child: Text(
    //                     _reportByDateController.endDateSelect.value == true
    //                         ? _reportByDateController.endDate.value
    //                         : "End")),
    //           ],
    //         ),
    //       )),
    // );
  }
}

/// Old
// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:pos/model/reports_by_date_model.dart';
// import 'package:pos/pages/ReportsByDate/reports_by_date_controller.dart';
// import 'package:pos/printer/printer_controller.dart';
// import 'package:pos/utils/app_toolbar_with_btn_clr.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//
// import '../../retrofit/base_model.dart';
//
//
// class ReportsByDate extends StatelessWidget {
//   final _reportByDateController = Get.put(ReportByDateController());
//   PrinterController _printerController = Get.find<PrinterController>();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (constraints, newContext) {
//         return  Scaffold(
//           appBar: ApplicationToolbarWithClrBtn(
//             appbarTitle: 'Reports By Date',
//             strButtonTitle: "Select Date",
//             btnColor: Color(0XFFFFFFFF),
//             onBtnPress: () {
//               Get.defaultDialog(
//                   title: "Data Picker",
//                   content: Container(
//                       color: Colors.white,
//                       height: 300,
//                       width: 300,
//                       child: Center(
//                         child: SfDateRangePicker(
//                           onSelectionChanged: _reportByDateController.onSelectionChanged,
//                           selectionMode: DateRangePickerSelectionMode.range,
//                           initialSelectedRange: PickerDateRange(
//                               DateTime.now().subtract(const Duration(days: 4)),
//                               DateTime.now().add(const Duration(days: 3))),
//                         ),
//                       )
//                   ),
//                   confirm: ElevatedButton(onPressed: (){
//                     _reportByDateController.isValue.value = true;
//                     Get.back();
//                   }, child: Text("OK"))
//               );
//             },
//           ),
//           body: Container(
//             decoration: BoxDecoration(
//               color: Colors.red.shade50,
//               image: const DecorationImage(
//                 image: AssetImage('images/ic_background_image.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Padding(
//               padding:  constraints.width > 600 ? const EdgeInsets.symmetric(horizontal: 20, vertical: 5) : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               child:  Column(
//                 children: [
//                   // _reportByDateController.startDateSelect.value == false ||  _reportByDateController.endDateSelect.value == false ? Row(
//                   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //   children: [
//                   //     ElevatedButton(
//                   //       onPressed: () async {
//                   //         if (_reportByDateController.startDateSelect.value ==
//                   //             false) {
//                   //           final startDate = await showDatePicker(
//                   //             context: context,
//                   //             initialDate: DateTime.now(),
//                   //             firstDate: DateTime(2000),
//                   //             lastDate: DateTime.now(),
//                   //           );
//                   //           if (startDate != null) {
//                   //               _reportByDateController.startDateSelect.value = true;
//                   //               _reportByDateController.onStartDateSelected(startDate);
//                   //           }
//                   //         }
//                   //       },
//                   //       child: Text( _reportByDateController.startDateSelect.value == false ? "Start Date Select" : _reportByDateController.startDate.value),
//                   //     ),
//                   //         ElevatedButton(
//                   //       onPressed: () async {
//                   //         if (_reportByDateController.endDateSelect.value == false) {
//                   //           final endDate = await showDatePicker(
//                   //             context: context,
//                   //             initialDate: DateTime.now(),
//                   //             firstDate: DateTime(2000),
//                   //             lastDate: DateTime.now(),
//                   //           );
//                   //           if (endDate != null) {
//                   //               _reportByDateController.endDateSelect.value = true;
//                   //               _reportByDateController.onEndDateSelected(endDate);
//                   //           }
//                   //         }
//                   //       },
//                   //       child: Text(_reportByDateController.endDateSelect.value == false ? "End Date Select" : _reportByDateController.endDate.value),
//                   //     ),
//                   //   ],
//                   // ) : SizedBox(),
//                   _reportByDateController.startDate == '' && _reportByDateController.startDate == '' ? FutureBuilder<BaseModel<ReportByDateModel>>(
//                     builder: (ctx, snapshot) {
//                       // Checking if future is resolved or not
//                       if (snapshot.connectionState == ConnectionState.done) {
//                         // If we got an error
//                         if (snapshot.hasError) {
//                           return Center(
//                             child: Text(
//                               '${snapshot.error} occurred',
//                               style: TextStyle(fontSize: 18),
//                             ),
//                           );
//
//                           // if we got our data
//                         } else if (snapshot.hasData) {
//                           // Extracting data from snapshot object
//                           ReportByDateModel data = snapshot.data!.data!;
//                           // return Container();
//
//
//                           return Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       SizedBox(height: 10,),
//                                       data.data!.isNotEmpty ? Align(
//                                         alignment: Alignment.center,
//                                         child: Container(
//                                           padding: EdgeInsets.all(2),
//                                           decoration: BoxDecoration(
//                                               color: Colors.black,
//                                               borderRadius: BorderRadius.circular(5)
//                                           ),
//                                           child: IntrinsicWidth(
//                                             child: Row(
//                                               children: [
//                                                 Icon(Icons.calendar_today_outlined, color: Colors.white, size: 16,),
//                                                 Text(" From : ${DateFormat('yyyy-MM-dd').format(data.data!.first.date!)}  to  ${DateFormat('yyyy-MM-dd').format(data.data!.last.date!)}", style: const TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight.bold),),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ) : Container(),
//                                       SizedBox(height: 10,),
//                                       Expanded(
//                                         child: ListView.builder(
//                                             padding: EdgeInsets.zero,
//                                             itemCount: data.data!.length + 1,
//                                             itemBuilder: (BuildContext context, int index) {
//                                               if(index == data.data!.length){
//                                                 return Column(
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     SizedBox(height: 10),
//                                                     Text(
//                                                       "Total Item Sold",
//                                                       style: TextStyle(
//                                                           color: Colors.red.shade400,
//                                                           fontSize: 18,
//                                                           fontWeight: FontWeight.w600),
//                                                     ),
//                                                     ListView.builder(
//                                                         shrinkWrap: true,
//                                                         physics: ClampingScrollPhysics(),
//                                                         padding: EdgeInsets.zero,
//                                                         itemCount: data.totalItemSold!.length,
//                                                         itemBuilder: (BuildContext context, int index) {
//                                                           TotalItemSold totalItemSold = data.totalItemSold![index];
//                                                           return Container(
//                                                             color: Colors.white,
//                                                             margin: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
//                                                             child: ListTile(
//                                                               dense: true,
//                                                               contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                                                               title: Row(
//                                                                 mainAxisAlignment: MainAxisAlignment.start,
//                                                                 children: [
//                                                                   Expanded(
//                                                                     child: Text(
//                                                                       "Item Name: ${totalItemSold.itemName.toString()}",
//                                                                       style: TextStyle(
//                                                                           color: Colors.black, fontSize: 14),
//                                                                     ),
//                                                                   ),
//                                                                   Expanded(
//                                                                     flex: 2,
//                                                                     child: Text(
//                                                                       "Quantity : ${totalItemSold.quantity.toString()}",
//                                                                       style: TextStyle(
//                                                                           color: Colors.black, fontSize: 14),
//                                                                     ),
//                                                                   ),
//
//                                                                 ],
//                                                               ),
//                                                             ), // title: Text("List item $index")),
//                                                           );
//                                                         }),
//                                                     SizedBox(height: 10),
//                                                   ],
//                                                 );
//                                               }else {
//                                                 Datum datum = data.data![index];
//                                                 return Column(
//                                                   crossAxisAlignment: CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     SizedBox(height: 30),
//                                                     Text(
//                                                       "Date ${DateFormat(
//                                                           'yyyy-MM-dd').format(datum
//                                                           .date!)}",
//                                                       style: TextStyle(
//                                                           color: Colors.red
//                                                               .shade400,
//                                                           fontSize: 15,
//                                                           fontWeight: FontWeight
//                                                               .w600),
//                                                     ),
//                                                     SizedBox(height: 20),
//                                                     constraints.width > 600 ? Row(
//                                                       children: const [
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: Text(
//                                                               "Name",
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .w600),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: Text(
//                                                               "Type",
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .w600),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: Text(
//                                                               "Amount",
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .w600),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: Text(
//                                                               "Total Takeaway",
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .w600),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: Text(
//                                                               "Total Dining",
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .w600),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: Text(
//                                                               "Total Discounts",
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .w600),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: Text(
//                                                               "Total Orders",
//                                                               style: TextStyle(
//                                                                   fontWeight: FontWeight
//                                                                       .w600),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ) : Row(
//                                                       children: const [
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: FittedBox(
//                                                               child: Text(
//                                                                 "Name",
//                                                                 style: TextStyle(
//                                                                     fontSize: 12,
//                                                                     fontWeight: FontWeight
//                                                                         .w600),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: FittedBox(
//                                                               child: Text(
//                                                                 "Type",
//                                                                 style: TextStyle(
//                                                                     fontSize: 12,
//                                                                     fontWeight: FontWeight
//                                                                         .w600),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: FittedBox(
//                                                               child: Text(
//                                                                 "Amount",
//                                                                 style: TextStyle(
//                                                                     fontSize: 12,
//                                                                     fontWeight: FontWeight
//                                                                         .w600),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: FittedBox(
//                                                               child: Text(
//                                                                 "Takeaway",
//                                                                 style: TextStyle(
//                                                                     fontSize: 12,
//                                                                     fontWeight: FontWeight
//                                                                         .w600),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: FittedBox(
//                                                               child: Text(
//                                                                 "Dining",
//                                                                 style: TextStyle(
//                                                                     fontSize: 12,
//                                                                     fontWeight: FontWeight
//                                                                         .w600),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: FittedBox(
//                                                               child: Text(
//                                                                 "Discount",
//                                                                 style: TextStyle(
//                                                                     fontSize: 12,
//                                                                     fontWeight: FontWeight
//                                                                         .w600),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: Center(
//                                                             child: FittedBox(
//                                                               child: Text(
//                                                                 "Orders",
//                                                                 style: TextStyle(
//                                                                     fontSize: 12,
//                                                                     fontWeight: FontWeight
//                                                                         .w600),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     SizedBox(height: 5),
//                                                     Row(
//                                                       children: [
//                                                         Expanded(
//                                                             child: Center(
//                                                                 child: Text(
//                                                                     (datum.posCash!
//                                                                         .name !=
//                                                                         null
//                                                                         ? datum
//                                                                         .posCash!
//                                                                         .name
//                                                                         .toString()
//                                                                         : 'No Data')))),
//                                                         Expanded(
//                                                             child: Center(
//                                                                 child: Text(
//                                                                     'Pos Cash'))),
//                                                         Expanded(child: Center(
//                                                             child: Text(
//                                                                 double.parse(datum.posCash!
//                                                                     .amount!.toString())
//                                                                     .toStringAsFixed(
//                                                                     2)))),
//                                                         Expanded(
//                                                           child: Container(),
//                                                         ),
//                                                         Expanded(
//                                                           child: Container(),
//                                                         ),
//                                                         Expanded(
//                                                           child: Container(),
//                                                         ),
//                                                         Expanded(
//                                                           child: Container(),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     SizedBox(height: 5),
//                                                     Row(
//                                                       children: [
//                                                         Expanded(
//                                                             child: Center(
//                                                                 child: Text(
//                                                                     datum.posCard!
//                                                                         .name !=
//                                                                         null
//                                                                         ? datum
//                                                                         .posCard!
//                                                                         .name
//                                                                         .toString()
//                                                                         : 'No Data'))),
//                                                         Expanded(
//                                                             child: Center(
//                                                                 child: Text(
//                                                                     'Pos Card'))),
//                                                         Expanded(
//                                                             child: Center(
//                                                                 child: Text(
//                                               double.parse(datum.posCard!
//                                                   .amount!.toString())
//                                                                         .toStringAsFixed(
//                                                                         2)))),
//                                                         Expanded(child: Center(
//                                                             child: Text(
//                                                                 datum.orderPlaced!
//                                                                     .totalTakeaway
//                                                                     .toString())),),
//                                                         Expanded(
//                                                             child: Center(
//                                                                 child: Text(datum
//                                                                     .orderPlaced!
//                                                                     .totalDining
//                                                                     .toString()))),
//                                                         Expanded(
//                                                             child: Center(
//                                                                 child: Text(double.parse(datum
//                                                                     .orderPlaced!
//                                                                     .totalDiscounts
//                                                                     .toString()).toStringAsFixed(2)))),
//                                                         Expanded(child: Center(
//                                                             child: Text(
//                                                                 datum.orderPlaced!
//                                                                     .totalOrders
//                                                                     .toString())),),
//                                                       ],
//                                                     ),
//                                                     SizedBox(height: 20),
//                                                     Text(
//                                                       // "Orders ${DateFormat(
//                                                       //     'yyyy-MM-dd').format(datum
//                                                       //     .date!)}",
//                                                       "Orders",
//                                                       style: TextStyle(
//                                                           color: Colors.red
//                                                               .shade400,
//                                                           fontSize: 15,
//                                                           fontWeight: FontWeight
//                                                               .w600),
//                                                     ),
//                                                     SizedBox(height: 20),
//                                                     ListView.builder(
//                                                         shrinkWrap: true,
//                                                         physics: ClampingScrollPhysics(),
//                                                         padding: EdgeInsets.zero,
//                                                         itemCount: datum.orders!
//                                                             .length,
//                                                         itemBuilder: (
//                                                             BuildContext context,
//                                                             int index) {
//                                                           Order orderData = datum
//                                                               .orders![index];
//                                                           return Container(
//                                                             color: Colors.white,
//                                                             margin: EdgeInsets
//                                                                 .symmetric(
//                                                                 vertical: 2,
//                                                                 horizontal: 20),
//                                                             child: ListTile(
//                                                               dense: true,
//                                                               contentPadding: EdgeInsets
//                                                                   .symmetric(
//                                                                   horizontal: 10),
//                                                               title: Row(
//                                                                 mainAxisAlignment: MainAxisAlignment
//                                                                     .start,
//                                                                 children: [
//                                                                   Expanded(
//                                                                     child: Text(
//                                                                       "Item Name: ${orderData
//                                                                           .itemName
//                                                                           .toString()}",
//                                                                       style: TextStyle(
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontSize: 14),
//                                                                     ),
//                                                                   ),
//                                                                   Expanded(
//                                                                     flex: 2,
//                                                                     child: Text(
//                                                                       "Quantity : ${orderData
//                                                                           .quantity
//                                                                           .toString()}",
//                                                                       style: TextStyle(
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontSize: 14),
//                                                                     ),
//                                                                   ),
//
//                                                                 ],
//                                                               ),
//                                                             ), // title: Text("List item $index")),
//                                                           );
//                                                         }),
//                                                     SizedBox(height: 10),
//                                                     DottedLine(
//                                                       dashColor: Color(0xff000000),
//                                                     ),
//
//                                                   ],
//                                                 );
//                                               }
//                                             }
//                                         )
//                                       ),
//
//
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   // decoration: BoxDecoration(
//                                   //   border: Border(
//                                   //     top: BorderSide( //                    <--- top side
//                                   //     color: Colors.black,
//                                   //     width: 1,
//                                   //   ),)
//                                   // ),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//
//                                       SizedBox(height: 10),
//                                       Container(
//                                         width: double.infinity,
//                                         padding: EdgeInsets.symmetric(horizontal: 20),
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 const Text("Total Sum Pos Cash"),
//                                                 Text(data.sumPosCash!.toStringAsFixed(2)),
//                                               ],
//                                             ),
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 const Text("Total Sum Pos Card"),
//                                                 Text(data.sumPosCard!.toStringAsFixed(2)),
//                                               ],
//                                             ),
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 const Text("Total Orders"),
//                                                 Text(data.sumTotalOrders!.toString()),
//                                               ],
//                                             ),
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 const Text("Total TakeAway Orders"),
//                                                 Text(data.sumTotalTakeaway!.toString()),
//                                               ],
//                                             ),
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 const Text("Total Dining Orders"),
//                                                 Text(data.sumTotalDining!.toString()),
//                                               ],
//                                             ),
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 const Text("Total Discounts"),
//                                                 Text(double.parse(data.sumTotalDiscounts!.toString()).toStringAsFixed(2)),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(height: 5),
//                                       Align(
//                                         alignment: Alignment.center,
//                                         child: ElevatedButton(
//                                             onPressed: () {
//                                               Get.dialog(
//                                                 AlertDialog(
//                                                   title: Text('Print Confirmation'),
//                                                   content: Text('Do you want to print with items?'),
//                                                   actions: [
//                                                     TextButton(
//                                                       onPressed: () {
//                                                         if (_printerController.printerModel.value.ipPos !=
//                                                             null) {
//                                                           print("POS ADDED");
//                                                           if (_printerController
//                                                               .printerModel.value.ipPos ==
//                                                               '' &&
//                                                               _printerController
//                                                                   .printerModel.value.portPos ==
//                                                                   '' ||
//                                                               _printerController
//                                                                   .printerModel.value.ipPos ==
//                                                                   null &&
//                                                                   _printerController
//                                                                       .printerModel.value.portPos ==
//                                                                       null) {
//                                                             print("pos ip empty");
//                                                           } else {
//                                                             _reportByDateController.testPrintPOS(
//                                                               _printerController
//                                                                   .printerModel.value.ipPos!,
//                                                               int.parse(_printerController
//                                                                   .printerModel.value.portPos!),
//                                                               context,
//                                                               true
//                                                             );
//                                                           }
//                                                         }
//                                                         Get.back();
//                                                       },
//                                                       child: Text('Yes'),
//                                                     ),
//                                                     TextButton(
//                                                       onPressed: () {
//                                                         if (_printerController.printerModel.value.ipPos !=
//                                                             null) {
//                                                           print("POS ADDED");
//                                                           if (_printerController
//                                                               .printerModel.value.ipPos ==
//                                                               '' &&
//                                                               _printerController
//                                                                   .printerModel.value.portPos ==
//                                                                   '' ||
//                                                               _printerController
//                                                                   .printerModel.value.ipPos ==
//                                                                   null &&
//                                                                   _printerController
//                                                                       .printerModel.value.portPos ==
//                                                                       null) {
//                                                             print("pos ip empty");
//                                                           } else {
//                                                             _reportByDateController.testPrintPOS(
//                                                               _printerController
//                                                                   .printerModel.value.ipPos!,
//                                                               int.parse(_printerController
//                                                                   .printerModel.value.portPos!),
//                                                               context,
//                                                               false
//                                                             );
//                                                           }
//                                                         }
//                                                         Get.back();
//                                                       },
//                                                       child: Text('No'),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               );
//                                             },
//                                             child: Text("All Report")),
//                                       ),
//                                       SizedBox(height: 5),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }
//                       }
//
//                       // Displaying LoadingSpinner to indicate waiting state
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     },
//                     future: _reportByDateController.reportsApiByDateCall(),
//                   ) : Container(
//                     height: 39,
//                     width: 35,
//                     color: Colors.amber,
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       }
//     );
//     // return Obx(
//     //   () => Scaffold(
//     //       appBar: ApplicationToolbarWithClrBtn(
//     //         appbarTitle: 'Reports',
//     //         strButtonTitle: "",
//     //         btnColor: Color(Constants.colorLike),
//     //         onBtnPress: () {},
//     //       ),
//     //       body: Container(
//     //         decoration: BoxDecoration(
//     //             color: Colors.red.shade50,
//     //             image: const DecorationImage(
//     //               image: AssetImage('images/ic_background_image.png'),
//     //               fit: BoxFit.cover,
//     //             )),
//     //         child: Column(
//     //           children: [
//     //             TextButton(
//     //                 onPressed: () async {
//     //                   if (_reportByDateController.startDateSelect.value ==
//     //                       false) {
//     //                     final startDate = await showDatePicker(
//     //                       context: context,
//     //                       initialDate: DateTime.now(),
//     //                       firstDate: DateTime(2000),
//     //                       lastDate: DateTime.now(),
//     //                     );
//     //                     if (startDate != null) {
//     //                       _reportByDateController.startDateSelect.value = true;
//     //                       _reportByDateController
//     //                           .onStartDateSelected(startDate);
//     //                     }
//     //                   }
//     //                 },
//     //                 child: Text(
//     //                     _reportByDateController.startDateSelect.value == true
//     //                         ? _reportByDateController.startDate.value
//     //                         : "Start")),
//     //             TextButton(
//     //                 onPressed: () async {
//     //                   if (_reportByDateController.endDateSelect.value ==
//     //                       false) {
//     //                     final endDate = await showDatePicker(
//     //                       context: context,
//     //                       initialDate: DateTime.now(),
//     //                       firstDate: DateTime(2000),
//     //                       lastDate: DateTime.now(),
//     //                     );
//     //                     if (endDate != null) {
//     //                       _reportByDateController.endDateSelect.value = true;
//     //                       _reportByDateController.onEndDateSelected(endDate);
//     //                     }
//     //                   }
//     //                 },
//     //                 child: Text(
//     //                     _reportByDateController.endDateSelect.value == true
//     //                         ? _reportByDateController.endDate.value
//     //                         : "End")),
//     //           ],
//     //         ),
//     //       )),
//     // );
//   }
// }