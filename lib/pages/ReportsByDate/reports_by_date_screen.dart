import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/model/reports_by_date_model.dart';
import 'package:pos/pages/ReportsByDate/reports_by_date_controller.dart';
import 'package:pos/printer/printer_controller.dart';
import 'package:pos/utils/app_toolbar_with_btn_clr.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../retrofit/base_model.dart';


class ReportsByDate extends StatelessWidget {
  final _reportByDateController = Get.put(ReportByDateController());
  PrinterController _printerController = Get.find<PrinterController>();


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (constraints, newContext) {
        return Obx(() => Scaffold(
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
                image: AssetImage('images/ic_background_image.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding:  constraints.width > 600 ? const EdgeInsets.symmetric(horizontal: 20, vertical: 5) : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child:  Column(
                children: [
                  // _reportByDateController.startDateSelect.value == false ||  _reportByDateController.endDateSelect.value == false ? Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     ElevatedButton(
                  //       onPressed: () async {
                  //         if (_reportByDateController.startDateSelect.value ==
                  //             false) {
                  //           final startDate = await showDatePicker(
                  //             context: context,
                  //             initialDate: DateTime.now(),
                  //             firstDate: DateTime(2000),
                  //             lastDate: DateTime.now(),
                  //           );
                  //           if (startDate != null) {
                  //               _reportByDateController.startDateSelect.value = true;
                  //               _reportByDateController.onStartDateSelected(startDate);
                  //           }
                  //         }
                  //       },
                  //       child: Text( _reportByDateController.startDateSelect.value == false ? "Start Date Select" : _reportByDateController.startDate.value),
                  //     ),
                  //         ElevatedButton(
                  //       onPressed: () async {
                  //         if (_reportByDateController.endDateSelect.value == false) {
                  //           final endDate = await showDatePicker(
                  //             context: context,
                  //             initialDate: DateTime.now(),
                  //             firstDate: DateTime(2000),
                  //             lastDate: DateTime.now(),
                  //           );
                  //           if (endDate != null) {
                  //               _reportByDateController.endDateSelect.value = true;
                  //               _reportByDateController.onEndDateSelected(endDate);
                  //           }
                  //         }
                  //       },
                  //       child: Text(_reportByDateController.endDateSelect.value == false ? "End Date Select" : _reportByDateController.endDate.value),
                  //     ),
                  //   ],
                  // ) : SizedBox(),
                  _reportByDateController.range.value.isNotEmpty && _reportByDateController.isValue.value == true ? FutureBuilder<BaseModel<ReportByDateModel>>(
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
                          ReportByDateModel data = snapshot.data!.data!;
                          // return Container();


                          return Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Text(" From : ${DateFormat('yyyy-MM-dd').format(data.from!)}  to  ${DateFormat('yyyy-MM-dd').format(data.to!)}", style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),),
                                      SizedBox(height: 10,),
                                      Expanded(
                                        child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: data.data!.length + 1,
                                            itemBuilder: (BuildContext context, int index) {
                                              if(index == data.data!.length){
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 10),
                                                    Text(
                                                      "Total Item Sold",
                                                      style: TextStyle(
                                                          color: Colors.red.shade400,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w600),
                                                    ),
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        physics: ClampingScrollPhysics(),
                                                        padding: EdgeInsets.zero,
                                                        itemCount: data.totalItemSold!.length,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          TotalItemSold totalItemSold = data.totalItemSold![index];
                                                          return Container(
                                                            color: Colors.white,
                                                            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                                                            child: ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                              title: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "Item Name: ${totalItemSold.itemName.toString()}",
                                                                      style: TextStyle(
                                                                          color: Colors.black, fontSize: 14),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Text(
                                                                      "Quantity : ${totalItemSold.quantity.toString()}",
                                                                      style: TextStyle(
                                                                          color: Colors.black, fontSize: 14),
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),
                                                            ), // title: Text("List item $index")),
                                                          );
                                                        }),
                                                    SizedBox(height: 10),
                                                  ],
                                                );
                                              }else {
                                                Datum datum = data.data![index];
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    SizedBox(height: 30),
                                                    Text(
                                                      "Date ${DateFormat(
                                                          'yyyy-MM-dd').format(datum
                                                          .date!)}",
                                                      style: TextStyle(
                                                          color: Colors.red
                                                              .shade400,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .w600),
                                                    ),
                                                    SizedBox(height: 20),
                                                    constraints.width > 600 ? Row(
                                                      children: const [
                                                        Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              "Name",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .w600),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              "Type",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .w600),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              "Amount",
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
                                                    ) : Row(
                                                      children: const [
                                                        Expanded(
                                                          child: Center(
                                                            child: FittedBox(
                                                              child: Text(
                                                                "Name",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight
                                                                        .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Center(
                                                            child: FittedBox(
                                                              child: Text(
                                                                "Type",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight
                                                                        .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Center(
                                                            child: FittedBox(
                                                              child: Text(
                                                                "Amount",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight
                                                                        .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Center(
                                                            child: FittedBox(
                                                              child: Text(
                                                                "Takeaway",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight
                                                                        .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Center(
                                                            child: FittedBox(
                                                              child: Text(
                                                                "Dining",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight
                                                                        .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Center(
                                                            child: FittedBox(
                                                              child: Text(
                                                                "Discount",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight
                                                                        .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Center(
                                                            child: FittedBox(
                                                              child: Text(
                                                                "Orders",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight
                                                                        .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: Center(
                                                                child: Text(
                                                                    (datum.posCash!
                                                                        .name !=
                                                                        null
                                                                        ? datum
                                                                        .posCash!
                                                                        .name
                                                                        .toString()
                                                                        : 'No Data')))),
                                                        Expanded(
                                                            child: Center(
                                                                child: Text(
                                                                    'Pos Cash'))),
                                                        Expanded(child: Center(
                                                            child: Text(
                                                                datum.posCash!
                                                                    .amount!
                                                                    .toStringAsFixed(
                                                                    2)))),
                                                        Expanded(
                                                          child: Container(),
                                                        ),
                                                        Expanded(
                                                          child: Container(),
                                                        ),
                                                        Expanded(
                                                          child: Container(),
                                                        ),
                                                        Expanded(
                                                          child: Container(),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: Center(
                                                                child: Text(
                                                                    datum.posCard!
                                                                        .name !=
                                                                        null
                                                                        ? datum
                                                                        .posCard!
                                                                        .name
                                                                        .toString()
                                                                        : 'No Data'))),
                                                        Expanded(
                                                            child: Center(
                                                                child: Text(
                                                                    'Pos Card'))),
                                                        Expanded(
                                                            child: Center(
                                                                child: Text(
                                                                    datum.posCard!
                                                                        .amount!
                                                                        .toStringAsFixed(
                                                                        2)))),
                                                        Expanded(child: Center(
                                                            child: Text(
                                                                datum.orderPlaced!
                                                                    .totalTakeaway
                                                                    .toString())),),
                                                        Expanded(
                                                            child: Center(
                                                                child: Text(datum
                                                                    .orderPlaced!
                                                                    .totalTotalDining
                                                                    .toString()))),
                                                        Expanded(
                                                            child: Center(
                                                                child: Text(double.parse(datum
                                                                    .orderPlaced!
                                                                    .totalTotalDiscounts
                                                                    .toString()).toStringAsFixed(2)))),
                                                        Expanded(child: Center(
                                                            child: Text(
                                                                datum.orderPlaced!
                                                                    .totalOrders
                                                                    .toString())),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      // "Orders ${DateFormat(
                                                      //     'yyyy-MM-dd').format(datum
                                                      //     .date!)}",
                                                      "Orders",
                                                      style: TextStyle(
                                                          color: Colors.red
                                                              .shade400,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .w600),
                                                    ),
                                                    SizedBox(height: 20),
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        physics: ClampingScrollPhysics(),
                                                        padding: EdgeInsets.zero,
                                                        itemCount: datum.orders!
                                                            .length,
                                                        itemBuilder: (
                                                            BuildContext context,
                                                            int index) {
                                                          Order orderData = datum
                                                              .orders![index];
                                                          return Container(
                                                            color: Colors.white,
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                vertical: 2,
                                                                horizontal: 20),
                                                            child: ListTile(
                                                              dense: true,
                                                              contentPadding: EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 10),
                                                              title: Row(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "Item Name: ${orderData
                                                                          .itemName
                                                                          .toString()}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize: 14),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Text(
                                                                      "Quantity : ${orderData
                                                                          .quantity
                                                                          .toString()}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize: 14),
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),
                                                            ), // title: Text("List item $index")),
                                                          );
                                                        }),
                                                    SizedBox(height: 10),
                                                    DottedLine(
                                                      dashColor: Color(0xff000000),
                                                    ),

                                                  ],
                                                );
                                              }
                                            }
                                        )
                                      ),


                                    ],
                                  ),
                                ),
                                Container(
                                  // decoration: BoxDecoration(
                                  //   border: Border(
                                  //     top: BorderSide( //                    <--- top side
                                  //     color: Colors.black,
                                  //     width: 1,
                                  //   ),)
                                  // ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      SizedBox(height: 10),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("Total Sum Pos Cash"),
                                                Text(data.sumPosCash!.toStringAsFixed(2)),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("Total Sum Pos Card"),
                                                Text(data.sumPosCard!.toStringAsFixed(2)),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("Total Orders"),
                                                Text(data.sumTotalOrders!.toString()),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("Total TakeAway Orders"),
                                                Text(data.sumTotalTakeaway!.toString()),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("Total Dining Orders"),
                                                Text(data.sumTotalDining!.toString()),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("Total Discounts"),
                                                Text(double.parse(data.sumTotalDiscounts!.toString()).toStringAsFixed(2)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Align(
                                        alignment: Alignment.center,
                                        child: ElevatedButton(
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
                                            child: Text("All Report")),
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }

                      // Displaying LoadingSpinner to indicate waiting state
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
          ),
        ),
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
