import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pos/model/reports_by_date_model.dart';
import 'package:pos/pages/ReportsByDate/reports_by_date_controller.dart';
import 'package:pos/printer/printer_controller.dart';
import 'package:pos/utils/app_toolbar_with_btn_clr.dart';
import 'package:pos/utils/base_model.dart';
import 'package:pos/utils/constants.dart';

class ReportsByDate extends StatelessWidget {
  final _reportByDateController = Get.put(ReportByDateController());
  PrinterController _printerController = Get.find<PrinterController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: ApplicationToolbarWithClrBtn(
        appbarTitle: 'Reports',
        strButtonTitle: "",
        btnColor: Color(Constants.colorLike),
        onBtnPress: () {},
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: [
              _reportByDateController.startDateSelect.value == false ||  _reportByDateController.endDateSelect.value == false ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_reportByDateController.startDateSelect.value ==
                          false) {
                        final startDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (startDate != null) {
                            _reportByDateController.startDateSelect.value = true;
                            _reportByDateController.onStartDateSelected(startDate);
                        }
                      }
                    },
                    child: Text( _reportByDateController.startDateSelect.value == false ? "Start Date Select" : _reportByDateController.startDate.value),
                  ),
                      ElevatedButton(
                    onPressed: () async {
                      if (_reportByDateController.endDateSelect.value == false) {
                        final endDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (endDate != null) {
                            _reportByDateController.endDateSelect.value = true;
                            _reportByDateController.onEndDateSelected(endDate);
                        }
                      }
                    },
                    child: Text(_reportByDateController.endDateSelect.value == false ? "End Date Select" : _reportByDateController.endDate.value),
                  ),
                ],
              ) : SizedBox(),
              _reportByDateController.startDateSelect.value == true && _reportByDateController.endDateSelect.value == true ? FutureBuilder<BaseModel<ReportByDateModel>>(
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
                                  Text(" From : ${DateFormat('yyyy-MM-dd').format(data.from!)}  to  ${DateFormat('yyyy-MM-dd').format(data.to!)}"),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Payments Date",
                                    style: TextStyle(
                                        color: Colors.red.shade400,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 10,),
                                  Expanded(
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: data.data!.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          Datum datum = data.data![index];
                                          return Column(
                                            children: [
                                              Text(
                                                DateFormat('yyyy-MM-dd').format(datum.date!),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Row(
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
                                                        "Amount",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Center(
                                                          child: Text(datum.posCash!.name.toString()))),
                                                  Expanded(
                                                      child: Center(
                                                          child: Text(datum.posCash!.amount!.toStringAsFixed(2)))),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Center(
                                                          child: Text(datum.posCard!.name.toString()))),
                                                  Expanded(
                                                      child: Center(
                                                          child: Text(datum.posCard!.amount!.toStringAsFixed(2)))),
                                                ],
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
                                              Container(
                                                height: 300,
                                                child: ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    itemCount: datum.orders!.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      Order orderData = datum.orders![index];
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
                                                                  "Item Name: ${orderData.itemName.toString()}",
                                                                  style: TextStyle(
                                                                      color: Colors.black, fontSize: 14),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  "Quantity : ${orderData.quantity.toString()}",
                                                                  style: TextStyle(
                                                                      color: Colors.black, fontSize: 14),
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                        ), // title: Text("List item $index")),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          );
                                        }
                                    )
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Total Item Sold',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
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
                                  )
                                ],
                              ),
                            ),

                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    "Total Item Sold",
                                    style: TextStyle(
                                        color: Colors.red.shade400,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(height: 5),
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
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),

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

                            // Align(
                            //   alignment: Alignment.center,
                            //   child: ElevatedButton(
                            //       onPressed: () {
                            //         if (_printerController.printerModel.value.ipPos !=
                            //             null) {
                            //           print("POS ADDED");
                            //           if (_printerController
                            //               .printerModel.value.ipPos ==
                            //               '' &&
                            //               _printerController
                            //                   .printerModel.value.portPos ==
                            //                   '' ||
                            //               _printerController
                            //                   .printerModel.value.ipPos ==
                            //                   null &&
                            //                   _printerController
                            //                       .printerModel.value.portPos ==
                            //                       null) {
                            //             print("pos ip empty");
                            //           } else {
                            //             _reportController.testPrintPOS(
                            //               _printerController
                            //                   .printerModel.value.ipPos!,
                            //               int.parse(_printerController
                            //                   .printerModel.value.portPos!),
                            //               context,
                            //             );
                            //           }
                            //         }
                            //       },
                            //       child: Text("Reports")),
                            // )
                          ],
                        ),
                      );
                    }
                  }

                  // Displaying LoadingSpinner to indicate waiting state
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                future: _reportByDateController.reportsApiByDateCall(),
              ) : Center(
                child: Text("No Data"),
              )
            ],
          ),
        ),
      ),
    ),
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
