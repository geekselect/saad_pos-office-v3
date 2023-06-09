import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/controller/cart_controller.dart';
import 'package:pos/controller/dining_cart_controller.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/controller/order_history_controller.dart';
import 'package:pos/controller/shift_controller.dart';
import 'package:pos/controller/timer_controller.dart';
import 'package:pos/model/book_table_model.dart';
import 'package:pos/model/booked_order_model.dart';
import 'package:pos/controller/auto_printer_controller.dart';
import 'package:pos/model/cart_master.dart' as cart;
import 'package:pos/model/shift_model.dart';
import 'package:pos/model/single_restaurants_details_model.dart';
import 'package:pos/pages/OrderHistory/new_button_check_file.dart';
import 'package:pos/pages/OrderHistory/order_history.dart';
import 'package:pos/pages/Reports/report_screen.dart';
import 'package:pos/pages/ReportsByDate/reports_by_date_screen.dart';
import 'package:pos/pages/addons/Half_n_half.dart';
import 'package:pos/pages/addons/addons_only.dart';
import 'package:pos/pages/addons/addons_with_sizes.dart';
import 'package:pos/pages/customer_data_screen.dart';
import 'package:pos/pages/modifiers/modifier_controller.dart';
import 'package:pos/pages/pos/Paymmmm/home_pay.dart';
import 'package:pos/pages/pos/Paymmmm/linkly_controller.dart';
import 'package:pos/pages/pos/Paymmmm/my_app_pay.dart';
import 'package:pos/pages/pos/Paymmmm/pay_screen.dart';
import 'package:pos/pages/pos/Paymmmm/transaction_screen.dart';
import 'package:pos/pages/pos/visibility_controller.dart';
import 'package:pos/pages/selection_screen.dart';
import 'package:pos/pages/vendor_menu.dart';
import 'package:pos/printer/printer_config.dart';
import 'package:pos/printer/printer_controller.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:pos/pages/addons/deals_items.dart' as dealsItems;
import 'package:shared_preferences/shared_preferences.dart';
import '../../customClipper/appbar_clipper.dart';
import '../../customClipper/option_clippper.dart';
import '../../model/cart_master.dart' as cm;
import '../../retrofit/api_client.dart';
import '../../retrofit/api_header.dart';
import '../../widgets/side_bar_grid_tile.dart';
import '../cart_screen.dart';

class PosMenu extends StatefulWidget {
  final bool isDining;

  // final String orderId;

  PosMenu({
    Key? key,
    required this.isDining,
  }) : super(key: key);

  @override
  _PosMenuState createState() => _PosMenuState();
}

class _PosMenuState extends State<PosMenu> {
  final ShiftController shiftController = Get.put(ShiftController());

  bool isLoading = false;

  Future<void> clearCaches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void _reloadScreen() {
    setState(() {
      _orderCustimizationController.callGetRestaurantsDetails().then((value) {
        if(value.data!.success == true) {
          _orderCustimizationController.response.value = value.data!;
        }
        _orderCustimizationController.strRestaurantModifier.value = value.data!.data!.vendor!.modifiers;
        if(value.data!.data!.vendor!.modifiers == 1) {
          print("call modifier");
          ModifierDataController _modifierDataController = Get.put(ModifierDataController());
          _modifierDataController.modifierDataApiCall();
        } else {
          print("no call modifier");
        }

        _orderCustimizationController.strRestaurantLinkly.value = value.data!.data!.vendor!.linkly;
        if(value.data!.data!.vendor!.linkly == 1) {
          print("call linkly");
          LinklyDataController _linklyDataController = Get.put(LinklyDataController());
          _linklyDataController.linklyDataApiCall();
        } else {
          print("no call linkly");
        }
      });
      shiftController.callOrderSetting().then((value) {
        shiftController.cartController.taxType = value.data!.data!.taxType!;
        shiftController.cartController.taxAmountNew =
            double.parse(value.data!.data!.tax!.toString());
        print("calculated Tax ${shiftController.cartController.calculatedTax}");
        print("tax ${shiftController.cartController.taxAmountNew}");
      });
      isLoading = true;
    });

    // Simulate a 3-second delay
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  final DiningCartController _diningCartController=  Get.put(DiningCartController());


  AutoPrinterController _autoPrinterController =
  Get.put(AutoPrinterController());

  final OrderCustimizationController _orderCustimizationController =
  Get.put(OrderCustimizationController());

  // int selectedMenuCategoryIndex = 0;
  int _selectedCategoryIndex = 0;
  bool runFirstTime = true;

  // Future<BaseModel<SingleRestaurantsDetailsModel>>? callGetResturantDetailsRef;

  var _printerController = Get.put(PrinterController());
  List<SideBarGridTile> sidebarGridTileList = [];
  // final OrderHistoryController _orderHistoryMainController =
  //     Get.put(OrderHistoryController());



  Future<BookTableModel> getBookTable() async {
    final prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    return await RestClient(await RetroApi().dioData())
        .getTables(int.parse(vendorId.toString()));
  }

  // int _getMenuItemCount( List<MenuCategory> _menuCategories) {
  //   if (_selectedCategoryIndex == 0) {
  //     int total = 0;
  //     for (int i = 0; i < _menuCategories.length; i++) {
  //       total += _menuCategories[i].singleMenu!.length;
  //     }
  //     return total;
  //   } else {
  //     return _menuCategories[_selectedCategoryIndex - 1]
  //         .singleMenu!
  //         .length;
  //   }
  // }

  String vendorIdMain = '';




  int _getMenuItemCount(List<MenuCategory> _menuCategories) {
    if (_selectedCategoryIndex == 0) {
      int total = 0;
      for (int i = 0; i < _menuCategories.length; i++) {
        for (int j = 0; j < _menuCategories[i].singleMenu!.length; j++) {
          if (_menuCategories[i]
              .singleMenu![j]
              .menu!
              .name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase())) {
            total++;
          }
        }
      }
      return total;
    } else {
      int total = 0;
      for (int i = 0;
          i < _menuCategories[_selectedCategoryIndex - 1].singleMenu!.length;
          i++) {
        if (_menuCategories[_selectedCategoryIndex - 1]
            .singleMenu![i]
            .menu!
            .name
            .toLowerCase()
            .contains(_searchQuery.toLowerCase())) {
          total++;
        }
      }
      return total;
    }
  }
  List<Widget> sideBarGridTiles = [];

  bool isVisibleImage = true;
  VisibilityController controller = VisibilityController();

  Future<void> _loadVisibility() async {
    final visibility = await controller.getVisibility();
    setState(() {
      isVisibleImage = visibility;
    });
  }

  Future<void> _toggleVisibility() async {
    final newVisibility = !isVisibleImage;
    await controller.setVisibility(newVisibility);
    setState(() {
      isVisibleImage = newVisibility;
    });
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  void initState() {
    sidebarGridTileList = [

      SideBarGridTile(
        icon: Icons.print,
        title: 'Printer',
        onTap: () {
          Get.to(() => PrinterConfig());
        },
      ),
      // SideBarGridTile(
      //   icon: Icons.table_bar,
      //   title: 'Table',
      //   onTap: () async {
      //     final prefs = await SharedPreferences.getInstance();
      //     String vendorId =
      //         prefs.getString(Constants.vendorId.toString()) ?? '';
      //     bool value = true;
      //     if (value) {
      //       await Get.dialog(AlertDialog(
      //         title: Center(child: Text('Available table no')),
      //         content: SizedBox(
      //           height: Get.height * 0.4,
      //           width: Get.width * 0.5,
      //           child: Column(
      //             children: [
      //               Expanded(
      //                 child: FutureBuilder<BookTableModel>(
      //                     future: getBookTable(),
      //                     builder: (context, snapshot) {
      //                       if (snapshot.hasError) {
      //                         return Center(
      //                           child: Text(snapshot.error.toString()),
      //                         );
      //                       } else if (snapshot.hasData) {
      //                         return GridView.builder(
      //                           itemCount:
      //                               snapshot.data?.data.bookedTable.length ?? 0,
      //                           itemBuilder: (builder, index) {
      //                             return GestureDetector(
      //                               // onTap: (){
      //                               //   // print("B ${snapshot.data?.data.bookedTable[index].}");
      //                               // },
      //                               onTap: () async {
      //                                 shiftController.cartController.tableNumber = snapshot
      //                                     .data!
      //                                     .data
      //                                     .bookedTable[index]
      //                                     .bookedTableNumber;
      //                                 // if (bookOrderModel.data!.mobile !=
      //                                 //     null &&
      //                                 //     bookOrderModel.data!.userName!
      //                                 //         .isNotEmpty) {
      //                                 //   _diningCartController
      //                                 //       .diningUserMobileNumber =
      //                                 //   bookOrderModel.data!.mobile!;
      //                                 // }
      //                                 // print(bookOrderModel.data!.mobile);
      //                                 //
      //                                 // if (bookOrderModel.data!.notes !=
      //                                 //     null &&
      //                                 //     bookOrderModel.data!.userName!
      //                                 //         .isNotEmpty) {
      //                                 //   _diningCartController
      //                                 //       .diningNotes =
      //                                 //   bookOrderModel.data!.notes!;
      //                                 // }
      //                                 // print(bookOrderModel.data!.notes);
      //                                 if (snapshot.data!.data.bookedTable[index]
      //                                         .status ==
      //                                     1) {
      //                                   Map<String, dynamic> param = {
      //                                     'vendor_id':
      //                                         int.parse(vendorId.toString()),
      //                                     'booked_table_number': snapshot
      //                                         .data!
      //                                         .data
      //                                         .bookedTable[index]
      //                                         .bookedTableNumber,
      //                                   };
      //                                   BaseModel<BookedOrderModel> baseModel =
      //                                       await shiftController.cartController
      //                                           .getBookedTableData(
      //                                               param, context);
      //                                   BookedOrderModel bookOrderModel =
      //                                       baseModel.data!;
      //                                   print("------------------");
      //                                   print(
      //                                       "CHECK DATA ${snapshot.data?.data.bookedTable[index].toJson()}");
      //                                   print("------------------");
      //
      //                                   if (bookOrderModel.success!) {
      //                                     print(
      //                                         "ANNN  ${bookOrderModel.toJson()}");
      //                                     shiftController.cartController.cartMaster =
      //                                         cm.CartMaster.fromMap(jsonDecode(
      //                                             bookOrderModel
      //                                                 .data!.orderData!));
      //                                     shiftController.cartController
      //                                             .cartMaster?.oldOrderId =
      //                                         bookOrderModel.data!.orderId;
      //                                     _diningCartController.diningUserName =
      //                                         bookOrderModel.data!.userName!;
      //                                     _diningCartController
      //                                             .diningUserMobileNumber =
      //                                         bookOrderModel.data!.mobile!;
      //                                     _diningCartController.diningNotes =
      //                                         bookOrderModel.data!.notes!;
      //                                     _diningCartController
      //                                             .nameController.text =
      //                                         _diningCartController
      //                                             .diningUserName;
      //                                     _diningCartController
      //                                             .phoneNoController.text =
      //                                         _diningCartController
      //                                             .diningUserMobileNumber;
      //                                     _diningCartController
      //                                             .notesController.text =
      //                                         _diningCartController.diningNotes;
      //                                     Navigator.pop(context);
      //                                   } else {
      //                                     print("base eror ");
      //                                     print(baseModel.error);
      //                                   }
      //                                 } else {
      //                                   print("new table select");
      //                                setState(() {
      //                                  shiftController.cartController.cartMaster?.oldOrderId = null;
      //                                });
      //                                   print("${shiftController.cartController.cartMaster?.oldOrderId}");
      //                                   _diningCartController.diningUserName =
      //                                       '';
      //                                   _diningCartController
      //                                       .diningUserMobileNumber = '';
      //                                   _diningCartController.diningNotes = '';
      //                                   _diningCartController
      //                                           .nameController.text =
      //                                       _diningCartController
      //                                           .diningUserName;
      //                                   _diningCartController
      //                                           .phoneNoController.text =
      //                                       _diningCartController
      //                                           .diningUserMobileNumber;
      //                                   _diningCartController
      //                                           .notesController.text =
      //                                       _diningCartController.diningNotes;
      //                                   Navigator.pop(context);
      //                                 }
      //                               },
      //                               child: Container(
      //                                 margin: EdgeInsets.only(bottom: 18),
      //                                 child: Stack(
      //                                   children: [
      //                                     Positioned(
      //                                       child: Container(
      //                                         padding: EdgeInsets.all(40.0),
      //                                         decoration: BoxDecoration(
      //                                             color: snapshot
      //                                                         .data!
      //                                                         .data
      //                                                         .bookedTable[
      //                                                             index]
      //                                                         .status ==
      //                                                     1
      //                                                 ? Color(
      //                                                     Constants.colorTheme)
      //                                                 : Colors.green,
      //                                             shape: BoxShape.circle),
      //                                       ),
      //                                     ),
      //                                     Center(
      //                                       child: Text(
      //                                         snapshot
      //                                             .data!
      //                                             .data
      //                                             .bookedTable[index]
      //                                             .bookedTableNumber
      //                                             .toString(),
      //                                         style: TextStyle(
      //                                             color: Colors.white,
      //                                             fontSize: 18,
      //                                             fontWeight: FontWeight.w800),
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                             );
      //                           },
      //                           gridDelegate:
      //                               SliverGridDelegateWithFixedCrossAxisCount(
      //                             crossAxisCount: kIsWeb ? 8 : 3,
      //                             mainAxisExtent: 80,
      //                           ),
      //                         );
      //                       }
      //                       return Center(
      //                           child: CircularProgressIndicator(
      //                         color: Color(Constants.colorTheme),
      //                       ));
      //                     }),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ));
      //       setState(() {
      //         // _cartController.tableNumber!=null?selectMethod=DeliveryMethod.TAKEAWAY:null;
      //         shiftController.cartController.diningValue =
      //         shiftController.cartController.tableNumber != null ? true : false;
      //         shiftController.cartController.isPromocodeApplied = false;
      //       });
      //     }
      //   },
      // ),
      SideBarGridTile(
        icon: Icons.report,
        title: 'Reports',
        onTap: () {
          Get.to(() => Reports());
        },
      ),
      SideBarGridTile(
        icon: Icons.report_gmailerrorred,
        title: 'Full Reports',
        onTap: () {
          Get.to(() => ReportsByDate());
        },
      ),
      SideBarGridTile(
        icon: Icons.person,
        title: 'Users',
        onTap: () {
          Get.to(() => CustomerDataScreen());
        },
      ),
      SideBarGridTile(
        icon: Icons.create_new_folder,
        title: 'Create Shift',
        onTap: () {
          shiftController.getShiftAllDetails(context).then((value) {});
          Get.dialog(
            Obx(
              () {
                return Form(
                  key: shiftController.formShiftKey,
                  onWillPop: () async {
                    shiftController.createButtonEnable.value = false;
                    return true;
                  },
                  child: AlertDialog(
                    title: Text('Create Shift'),
                    content: Container(
                      width: Get.width / 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Column(
                              children: [
                                shiftController.createButtonEnable.value ==
                                        false
                                    ? ElevatedButton(
                                        onPressed: () {
                                          shiftController
                                              .createButtonEnable.value = true;
                                        },
                                        child: Text('Create New Shift'),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 10,
                                ),
                                shiftController.createButtonEnable.value == true
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: Get.width / 4,
                                            child: TextFormField(
                                              controller: shiftController
                                                  .shiftTextController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter a shift name';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Shift Name',
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (shiftController
                                                    .formShiftKey.currentState!
                                                    .validate() && shiftController
                                                    .timerController.timerDuration
                                                    .value == Duration.zero) {
                                                  shiftController
                                                      .createShiftDetails(
                                                          context,
                                                          shiftController
                                                              .shiftTextController
                                                              .text);
                                                } else{
                                                  shiftController
                                                      .shiftTextController
                                                      .clear();
                                                      Get.back();
                                                  Constants.toastMessage('please first close ongoing shift');
                                                }
                                              },
                                              child: Text('Create'),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Continue With Previous Shift",
                              style: TextStyle(
                                fontSize: 18,
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: Get.height / 3,
                            child: shiftController.shiftsList.isNotEmpty
                                ? ListView.separated(
                                    itemCount:
                                        shiftController.shiftsList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        trailing: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: shiftController
                                                .shiftsList[index]
                                                .shiftCode == shiftController.shiftCodeMain.value ? Colors.grey : Color(Constants.colorTheme), // Background color
                                          ),
                                          onPressed: shiftController
                                              .shiftsList[index]
                                              .shiftCode == shiftController.shiftCodeMain.value ? (){} :  () async {

                                              if (shiftController
                                                  .timerController.timerDuration
                                                  .value == Duration.zero) {
                                                print("Timer not Send");
                                                shiftController
                                                    .selectShiftDetails(context,
                                                    shiftController
                                                        .shiftsList[index]
                                                        .shiftCode,
                                                    shiftController
                                                        .shiftsList[index]
                                                        .shiftName,
                                                   '');
                                              }
                                              if (shiftController
                                                  .timerController.timerDuration
                                                  .value != Duration.zero) {
                                                print("Timer Send");
                                                var startTime = DateTime.now().subtract(shiftController.timerController.timerDuration.value);
                                                var stopTime = DateTime.now();
                                                var elapsedTime = stopTime.difference(startTime);
                                                shiftController
                                                    .selectShiftDetails(context,
                                                    shiftController
                                                        .shiftsList[index]
                                                        .shiftCode,
                                                    shiftController
                                                        .shiftsList[index]
                                                        .shiftName,
                                                  elapsedTime
                                                  );
                                              }

                                          },
                                          child:  Text(
                                            shiftController
                                                .shiftsList[index]
                                                .shiftCode == shiftController.shiftCodeMain.value ? "Ongoing" :"Continue",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Shift Date : ${shiftController.shiftsList[index].shiftDate.toString()}"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                "Shift Name : ${shiftController.shiftsList[index].shiftName.toString()}"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                "Shift Code : ${shiftController.shiftsList[index].shiftCode.toString()}"),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return Divider();
                                    },
                                  )
                                : Center(
                                    child: Text("No Previous Shifts Found"),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      SideBarGridTile(
        icon: Icons.sync,
        title: 'Reload',
        onTap: _reloadScreen,
      ),

      SideBarGridTile(
        icon: Icons.payments,
        title: 'Linkly Payment',
        onTap:  (){
          if( _orderCustimizationController.strRestaurantLinkly.value == 1 ) {
              print("Linkly");
              final LinklyDataController _linklyDataController=  Get.put(LinklyDataController());
              print("linkly data ${_linklyDataController.linklyDataModel.value.data!.toJson()}");
              if( _linklyDataController.linklyDataModel.value.data!.secretKey == null) {
                print("My Home Pay Screen");
                Get.to(() => HomePayPage());
              } else {
                print("All Data present");
              }
          } else {
            print("value ${_orderCustimizationController.strRestaurantLinkly
                .value}");
          }
        } ,

      ),
      SideBarGridTile(
        icon: Icons.view_day_outlined,
        title: 'View Changed',
        onTap: _toggleVisibility,
      ),
      // SideBarGridTile(
      //   icon: Icons.track_changes,
      //   title: 'Payments Checks',
      //   onTap: () {
      //     Get.to(() => TransactionScreen());
      //   },
      // ),
      SideBarGridTile(
        icon: Icons.logout,
        title: 'Logout',
        onTap: () async {
          if (shiftController.cartController.cartMaster != null) {
            shiftController.cartController.cartMaster!.cart.clear();
          }
          SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
          sharedPrefs.remove(Constants.isLoggedIn);

          _autoPrinterController.autoPrint.value = true;
          _autoPrinterController.autoPrintKitchen.value = true;
          sharedPrefs.setBool(
              'autoPrintPOS', _autoPrinterController.autoPrint.value);
          sharedPrefs.setBool(
              'autoPrintKitchen', _autoPrinterController.autoPrint.value);
          Get.deleteAll();
          DefaultCacheManager manager =  DefaultCacheManager();
          manager.emptyCache();
          clearCaches();
          Get.offAll(() => SelectionScreen());
        },
      ),
    ];

    _loadVisibility();




    print("dining value before ${shiftController.cartController.diningValue}");
    shiftController.cartController.diningValue = widget.isDining;

    print("dining value after ${shiftController.cartController.diningValue}");
    print("table value before ${shiftController.cartController.tableNumber}");
    if (shiftController.cartController.diningValue == false) {
      print("Dining false");
      shiftController.cartController.tableNumber = null;
    } else {
      print("Dining true");
      print("---------");
    }
    print("table value after ${shiftController.cartController.tableNumber}");
    getApiCAll();
    super.initState();
  }

  getApiCAll() async {
    final prefs = await SharedPreferences.getInstance();
    vendorIdMain = prefs.getString(Constants.vendorId.toString()) ?? '';
    shiftController.getCurrentShiftDetails().then((value) => print("value...${value.data!.toJson()}"));
    shiftController.shiftNameMain.value = prefs.getString(Constants.shiftName.toString()) ?? '';
    shiftController.shiftCodeMain.value = prefs.getString(Constants.shiftCode.toString()) ?? '';
  }

  String searchText = '';

  //
  String _searchQuery = '';

  //
  // void _updateSearchQuery(String query) {
  //   setState(() {
  //     _searchQuery = query;
  //   });
  // }

  // List<dynamic> getFilteredMenuItems(String searchQuery,   List<SingleMenu>? singleMenu, List<HalfNHalfMenu>? halfNHalfMenu, List<DealsMenu>? dealsMenu) {
  //   List<dynamic> filteredItems = [];
  //
  //   // Filter single menu items
  //   if (singleMenu != null) {
  //     for (SingleMenu item in singleMenu) {
  //       if (item.menu != null && item.menu!.name.toLowerCase().contains(searchQuery.toLowerCase())) {
  //         filteredItems.add(item);
  //       }
  //     }
  //   }
  //
  //   // Filter half and half menu items
  //   if (halfNHalfMenu != null) {
  //     for (HalfNHalfMenu item in halfNHalfMenu) {
  //       if (item.name.toLowerCase().contains(searchQuery.toLowerCase())) {
  //         filteredItems.add(item);
  //       }
  //     }
  //   }
  //
  //   // Filter deals menu items
  //   if (dealsMenu != null) {
  //     for (DealsMenu item in dealsMenu) {
  //       if (item.name.toLowerCase().contains(searchQuery.toLowerCase())) {
  //         filteredItems.add(item);
  //       }
  //     }
  //   }
  //
  //   return filteredItems;
  // }FTAKEAW
  void _addToCart(SingleMenu singleMenu, int index) {
    print("Item $index is pressed  ${singleMenu.menu!.name}");
  }

  // List<dynamic> getFilteredMenuItems(
  //     String searchQuery, String? type, DataSingleVendor data) {
  //   List<dynamic> filteredMenuItems = [];
  //
  //   if (data.menuCategory == null) {
  //     // If data.menuCategory is null, return all menu items from all categories
  //     for (MenuCategory category in data.menuCategory!) {
  //       filteredMenuItems.addAll(category.singleMenu ?? []);
  //       filteredMenuItems.addAll(category.halfNHalfMenu ?? []);
  //       filteredMenuItems.addAll(category.dealsMenu ?? []);
  //     }
  //   } else {
  //     // If data.menuCategory is not null, filter menu items based on search query and type
  //     for (MenuCategory category in data.menuCategory!) {
  //       // filteredMenuItems.addAll(category.getFilteredMenuItems(searchQuery, type, data));
  //     }
  //   }
  //
  //   return filteredMenuItems;
  // }

  void updateDiningValue(bool newValue) {
    setState(() {
      shiftController.cartController.diningValue = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("dining value before dining ${shiftController.cartController.diningValue}");
    print("elappsed time ${shiftController.timerController.elapsedTime}");
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg-full.jpg'),
            fit: BoxFit.cover,
          )),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: Column(
            children: [
                Container(
                  width: Get.width,
                  child: DrawerHeader(
                    // padding: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      color: Color(Constants.colorTheme),
                    ),
                    child: Obx(()=> Column(
                      children: [
                        CircleAvatar(
                              radius: 36,
                              backgroundImage:
                              Image.network(_orderCustimizationController.strRestaurantImage.value).image),
                        Text(
                            _orderCustimizationController.strRestaurantsName.value,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                      ],
                    ),
                    ),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: sidebarGridTileList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      hoverColor: Color(Constants.colorTheme),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(sidebarGridTileList[index].icon, size: 30),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(sidebarGridTileList[index].title, style: TextStyle(
                          fontSize: 20,

                        ),),
                      ),
                      onTap: sidebarGridTileList[index].onTap as void Function()?,
                    );
                  },
                //   separatorBuilder: (BuildContext context, int index) {
                //     return Divider();
                // },
                ),
              ),
            ],
          ),
        ),
        // drawer: Drawer(
        //   child: ListView(
        //     padding: EdgeInsets.zero,
        //     children: [
        //       DrawerHeader(
        //         decoration: BoxDecoration(
        //           color: Colors.blue,
        //         ),
        //         child: Text(
        //           'Drawer Header',
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 24,
        //           ),
        //         ),
        //       ),
        //       ListTile(
        //         title: Text('Item 1'),
        //         onTap: () {
        //           // Handle item 1 tap
        //         },
        //       ),
        //       ListTile(
        //         title: Text('Item 2'),
        //         onTap: () {
        //           // Handle item 2 tap
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    print("Desktop");
                    return SafeArea(
                      child:
                          FutureBuilder<BaseModel<SingleRestaurantsDetailsModel>>(
                        future: _orderCustimizationController
                            .callGetRestaurantsDetails(),
                        builder: (BuildContext context,
                            AsyncSnapshot<
                                    BaseModel<SingleRestaurantsDetailsModel>>
                                snapshot) {
                          if (snapshot.hasData) {
                            SingleRestaurantsDetailsModel
                                singleRestaurantsDetailsModel =
                                snapshot.data!.data!;
                            if (singleRestaurantsDetailsModel.success) {
                              Vendor vendor =
                                  singleRestaurantsDetailsModel.data!.vendor!;
                              List vendorNameList = vendor.name.split(' ');
                              List<MenuCategory> _menuCategories =
                                  singleRestaurantsDetailsModel
                                      .data!.menuCategory!;
                              return Stack(
                                children: [
                                  Column(
                                    children: [
                                       ClipPath(
                                          clipper: AppbarClipper(),
                                          child: Container(
                                            height: Get.height * 0.1,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                                color:
                                                    Color(Constants.colorTheme)),
                                            child: Row(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 50,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 25.0),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          // Note: Styles for TextSpans must be explicitly defined.
                                                          // Child text spans will inherit styles from parent
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    vendorNameList[
                                                                        0],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontSize: 25,
                                                                    color: Colors
                                                                        .black)),
                                                            TextSpan(text: ' '),
                                                            TextSpan(
                                                                text:
                                                                    vendorNameList[
                                                                        1],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontSize: 25,
                                                                    color: Colors
                                                                        .white)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Obx(() {
                                                  final duration = shiftController
                                                      .timerController
                                                      .timerDuration
                                                      .value;
                                                  return  shiftController
                                                      .timerController
                                                      .timerDuration
                                                      .value == Duration.zero ? SizedBox() :  Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                          '${shiftController.shiftNameMain.value}: ${shiftController.formatDuration(duration)}',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              SizedBox(width: 5),
                                                        ElevatedButton(
                                                                  onPressed: () {
                                                                    shiftController
                                                                        .closeShiftDetails(
                                                                            context);

                                                                  },
                                                                  child: Text(
                                                                      "Close"))
                                                            ],
                                                          ),
                                                        ) ;
                                                }),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all<Color>(Color(Constants.colorBlack)),
                                                        // set the height to 50
                                                        fixedSize: MaterialStateProperty.all<Size>(const Size(120, 50)),
                                                      ),
                                                      onPressed: (){
                                                        Get.to(() => OrderHistory());
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/orders.png',
                                                            color: Colors.white,
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'Orders',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color:  Colors.white),
                                                          )
                                                        ],
                                                      ),
                                                    ),


                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all<Color>(Color(Constants.colorBlack)),
                                                        // set the height to 50
                                                        fixedSize: MaterialStateProperty.all<Size>(const Size(120, 50)),
                                                      ),
                                                      onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          String vendorId =
                          prefs.getString(Constants.vendorId.toString()) ?? '';
                          bool value = true;
                          if (value) {
                          await Get.dialog(AlertDialog(
                          title: Center(child: Text('Available table no')),
                          content: SizedBox(
                          height: Get.height * 0.4,
                          width: Get.width * 0.5,
                          child: Column(
                          children: [
                          Expanded(
                          child: FutureBuilder<BookTableModel>(
                          future: getBookTable(),
                          builder: (context, snapshot) {
                          if (snapshot.hasError) {
                          return Center(
                          child: Text(snapshot.error.toString()),
                          );
                          } else if (snapshot.hasData) {
                          return GridView.builder(
                          itemCount:
                          snapshot.data?.data.bookedTable.length ?? 0,
                          itemBuilder: (builder, index) {
                          return GestureDetector(
                          // onTap: (){
                          //   // print("B ${snapshot.data?.data.bookedTable[index].}");
                          // },
                          onTap: () async {
                          shiftController.cartController.tableNumber = snapshot
                              .data!
                              .data
                              .bookedTable[index]
                              .bookedTableNumber;
                          // if (bookOrderModel.data!.mobile !=
                          //     null &&
                          //     bookOrderModel.data!.userName!
                          //         .isNotEmpty) {
                          //   _diningCartController
                          //       .diningUserMobileNumber =
                          //   bookOrderModel.data!.mobile!;
                          // }
                          // print(bookOrderModel.data!.mobile);
                          //
                          // if (bookOrderModel.data!.notes !=
                          //     null &&
                          //     bookOrderModel.data!.userName!
                          //         .isNotEmpty) {
                          //   _diningCartController
                          //       .diningNotes =
                          //   bookOrderModel.data!.notes!;
                          // }
                          // print(bookOrderModel.data!.notes);
                          if (snapshot.data!.data.bookedTable[index]
                              .status ==
                          1) {
                          Map<String, dynamic> param = {
                          'vendor_id':
                          int.parse(vendorId.toString()),
                          'booked_table_number': snapshot
                              .data!
                              .data
                              .bookedTable[index]
                              .bookedTableNumber,
                          };
                          BaseModel<BookedOrderModel> baseModel =
                          await shiftController.cartController
                              .getBookedTableData(
                          param, context);
                          BookedOrderModel bookOrderModel =
                          baseModel.data!;
                          print("------------------");
                          print(
                          "CHECK DATA ${snapshot.data?.data.bookedTable[index].toJson()}");
                          print("------------------");

                          if (bookOrderModel.success!) {
                          print(
                          "ANNN  ${bookOrderModel.toJson()}");
                          shiftController.cartController.cartMaster =
                          cm.CartMaster.fromMap(jsonDecode(
                          bookOrderModel
                              .data!.orderData!));
                          shiftController.cartController
                              .cartMaster?.oldOrderId =
                          bookOrderModel.data!.orderId;
                          _diningCartController.diningUserName =
                          bookOrderModel.data!.userName!;
                          _diningCartController
                              .diningUserMobileNumber =
                          bookOrderModel.data!.mobile!;
                          _diningCartController.diningNotes =
                          bookOrderModel.data!.notes!;
                          _diningCartController
                              .nameController.text =
                          _diningCartController
                              .diningUserName;
                          _diningCartController
                              .phoneNoController.text =
                          _diningCartController
                              .diningUserMobileNumber;
                          _diningCartController
                              .notesController.text =
                          _diningCartController.diningNotes;
                          Navigator.pop(context);
                          } else {
                          print("base eror ");
                          print(baseModel.error);
                          }
                          } else {
                          print("new table select");
                          setState(() {
                          shiftController.cartController.cartMaster?.oldOrderId = null;
                          });
                          print("${shiftController.cartController.cartMaster?.oldOrderId}");
                          _diningCartController.diningUserName =
                          '';
                          _diningCartController
                              .diningUserMobileNumber = '';
                          _diningCartController.diningNotes = '';
                          _diningCartController
                              .nameController.text =
                          _diningCartController
                              .diningUserName;
                          _diningCartController
                              .phoneNoController.text =
                          _diningCartController
                              .diningUserMobileNumber;
                          _diningCartController
                              .notesController.text =
                          _diningCartController.diningNotes;
                          Navigator.pop(context);
                          }
                          },
                          child: Container(
                          margin: EdgeInsets.only(bottom: 18),
                          child: Stack(
                          children: [
                          Positioned(
                          child: Container(
                          padding: EdgeInsets.all(40.0),
                          decoration: BoxDecoration(
                          color: snapshot
                              .data!
                              .data
                              .bookedTable[
                          index]
                              .status ==
                          1
                          ? Color(
                          Constants.colorTheme)
                              : Colors.green,
                          shape: BoxShape.circle),
                          ),
                          ),
                          Center(
                          child: Text(
                          snapshot
                              .data!
                              .data
                              .bookedTable[index]
                              .bookedTableNumber
                              .toString(),
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                          ),
                          ),
                          ],
                          ),
                          ),
                          );
                          },
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: kIsWeb ? 8 : 3,
                          mainAxisExtent: 80,
                          ),
                          );
                          }
                          return Center(
                          child: CircularProgressIndicator(
                          color: Color(Constants.colorTheme),
                          ));
                          }),
                          ),
                          ],
                          ),
                          ),
                          ));
                          setState(() {
                          // _cartController.tableNumber!=null?selectMethod=DeliveryMethod.TAKEAWAY:null;
                          shiftController.cartController.diningValue =
                          shiftController.cartController.tableNumber != null ? true : false;
                          shiftController.cartController.isPromocodeApplied = false;
                          });
                          }
                          },
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/tables.png',
                                                            color: Colors.white,
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            'Tables',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color:  Colors.white),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                // Container(
                                                //   child: GestureDetector(
                                                //       onTap: () {
                                                //         Get.to(() => NewFile());
                                                //       },
                                                //       child: Text("New Page")),
                                                // ),
                                                // SizedBox(
                                                //   width: 5,
                                                // ),

                                                Container(
                                                  width: 200,
                                                  // child: TextField(
                                                  //   // controller: _controller,
                                                  //   decoration: const InputDecoration(
                                                  //     hintText: 'Search',
                                                  //     suffixIcon: Icon(Icons.search),
                                                  //   ),
                                                  //   onChanged: (value) {
                                                  //     setState(() {
                                                  //       searchQuery = value;
                                                  //     });
                                                  //     // setState(() {
                                                  //     //   searchText = value;
                                                  //     // });
                                                  //     // _search(value,singleRestaurantsDetailsModel.data!.menuCategory![0].singleMenu!,singleRestaurantsDetailsModel.data!.menuCategory![0].halfNHalfMenu!,singleRestaurantsDetailsModel.data!.menuCategory![0].dealsMenu!);
                                                  //   },
                                                  // ),
                                                  child: TextField(
                                                    onTap: () {
                                                      if (_selectedCategoryIndex !=
                                                          0) {
                                                        setState(() {
                                                          _selectedCategoryIndex =
                                                              0;
                                                        });
                                                      }
                                                    },
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _searchQuery = value;
                                                      });
                                                    },
                                                    decoration: const InputDecoration(
                                                        labelText: 'Search',
                                                        labelStyle: TextStyle(
                                                            color: Colors.white)
                                                        // border: OutlineInputBorder(),
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Get.width * 0.3,
                                                  child:  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        if (shiftController.cartController
                                                            .diningValue)
                                                          Center(
                                                            child: Text(
                                                              'DINE IN',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 50,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                              ),
                                                            ),
                                                          )
                                                        else
                                                          Center(
                                                            child: Text(
                                                              'TAKEAWAY',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 50,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        Switch(
                                                          onChanged:
                                                              (bool? value) async {
                                                            if (value!) {
                                                              print("if Block");
                                                              print(
                                                                  "${shiftController.cartController.tableNumber}");
                                                              print("if Block End");
                                                              await showDialog<int>(
                                                                  context: context,
                                                                  builder: (_) =>
                                                                      AlertDialog(
                                                                        title: Center(
                                                                            child: Text(
                                                                                'Available table no')),
                                                                        content:
                                                                            SizedBox(
                                                                          height:
                                                                              Get.height *
                                                                                  0.4,
                                                                          width: Get
                                                                                  .width *
                                                                              0.5,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Expanded(
                                                                                child: FutureBuilder<BookTableModel>(
                                                                                    future: getBookTable(),
                                                                                    builder: (context, snapshot) {
                                                                                      if (snapshot.hasError) {
                                                                                        return Center(
                                                                                          child: Text(snapshot.error.toString()),
                                                                                        );
                                                                                      } else if (snapshot.hasData) {
                                                                                        return GridView.builder(
                                                                                          itemCount: snapshot.data?.data.bookedTable.length ?? 0,
                                                                                          itemBuilder: (builder, index) {
                                                                                            return GestureDetector(
                                                                                              onTap: () async {
                                                                                                final prefs = await SharedPreferences.getInstance();

                                                                                                // int vendorId = prefs.getInt(Constants.vendorId.toString()) ?? 0;
                                                                                                String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';

                                                                                                shiftController.cartController.tableNumber = snapshot.data!.data.bookedTable[index].bookedTableNumber;
                                                                                                if (snapshot.data!.data.bookedTable[index].status == 1) {
                                                                                                  print("vjjjfvdj");
                                                                                                  Map<String, dynamic> param = {
                                                                                                    'vendor_id': '${int.parse(vendorId.toString())}',
                                                                                                    'booked_table_number': snapshot.data!.data.bookedTable[index].bookedTableNumber,
                                                                                                  };
                                                                                                  BaseModel<BookedOrderModel> baseModel = await shiftController.cartController.getBookedTableData(param, context);
                                                                                                  BookedOrderModel bookOrderModel = baseModel.data!;
                                                                                                  if (bookOrderModel.success!) {
                                                                                                    print("ABC");
                                                                                                    shiftController.cartController.cartMaster = cm.CartMaster.fromMap(jsonDecode(bookOrderModel.data!.orderData!));
                                                                                                    shiftController.cartController.cartMaster?.oldOrderId = bookOrderModel.data!.orderId;
                                                                                                    _diningCartController.diningUserName = bookOrderModel.data!.userName!;
                                                                                                    _diningCartController.diningUserMobileNumber = bookOrderModel.data!.mobile!;
                                                                                                    _diningCartController.diningNotes = bookOrderModel.data!.notes!;
                                                                                                    _diningCartController.nameController.text = _diningCartController.diningUserName;
                                                                                                    _diningCartController.phoneNoController.text = _diningCartController.diningUserMobileNumber;
                                                                                                    _diningCartController.notesController.text = _diningCartController.diningNotes;
                                                                                                    Navigator.pop(context);
                                                                                                  } else {
                                                                                                    print("Error bbb");
                                                                                                    print(bookOrderModel.toJson());
                                                                                                    // print(baseModel.error);
                                                                                                  }
                                                                                                } else {
                                                                                                  print("nnnnn");
                                                                                                  shiftController.cartController.cartMaster?.oldOrderId = null;
                                                                                                  Navigator.pop(context);
                                                                                                }
                                                                                              },
                                                                                              child: Container(
                                                                                                margin: EdgeInsets.only(bottom: 18),
                                                                                                child: Stack(
                                                                                                  children: [
                                                                                                    Positioned(
                                                                                                      child: Container(
                                                                                                        padding: EdgeInsets.all(40.0),
                                                                                                        decoration: BoxDecoration(color: snapshot.data!.data.bookedTable[index].status == 1 ? Color(Constants.colorTheme) : Colors.green, shape: BoxShape.circle),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Center(
                                                                                                      child: Text(
                                                                                                        snapshot.data!.data.bookedTable[index].bookedTableNumber.toString(),
                                                                                                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                                            crossAxisCount: kIsWeb ? 8 : 3,
                                                                                            mainAxisExtent: 80,
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                      return Center(
                                                                                        child: CircularProgressIndicator(color: Color(Constants.colorTheme)),
                                                                                      );
                                                                                    }),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ));
                                                              setState(() {
                                                                // shiftController.cartController.tableNumber!=null?selectMethod=DeliveryMethod.TAKEAWAY:null;
                                                                shiftController.cartController
                                                                        .diningValue =
                                                                shiftController.cartController
                                                                                .tableNumber !=
                                                                            null && shiftController.cartController
                                                                        .tableNumber != 0
                                                                        ? true
                                                                        : false;
                                                                shiftController.cartController
                                                                        .isPromocodeApplied =
                                                                    false;
                                                                shiftController.cartController
                                                                    .userMobileNumber = '';
                                                                shiftController.cartController
                                                                    .userName = '';
                                                                shiftController.cartController
                                                                    .notes = '';
                                                                _diningCartController
                                                                    .nameController
                                                                    .text = shiftController.cartController
                                                                    .nameController
                                                                    .text;
                                                                _diningCartController
                                                                    .phoneNoController
                                                                    .text = shiftController.cartController
                                                                    .phoneNoController
                                                                    .text;
                                                                _diningCartController
                                                                    .notesController
                                                                    .text = shiftController.cartController
                                                                    .notesController
                                                                    .text;
                                                                shiftController.cartController
                                                                        .nameController
                                                                        .text =
                                                                    shiftController.cartController
                                                                        .userName;
                                                                shiftController.cartController
                                                                        .phoneNoController
                                                                        .text =
                                                                    shiftController.cartController
                                                                        .userMobileNumber;
                                                                shiftController.cartController
                                                                        .notesController
                                                                        .text =
                                                                    shiftController.cartController
                                                                        .notes;
                                                                if(shiftController.cartController.diningValue == false){
                                                                  shiftController.cartController
                                                                      .nameController
                                                                      .text =
                                                                      _diningCartController
                                                                          .nameController
                                                                          .text;
                                                                  shiftController.cartController
                                                                      .phoneNoController
                                                                      .text =
                                                                      _diningCartController
                                                                          .phoneNoController
                                                                          .text;
                                                                  shiftController.cartController
                                                                      .notesController
                                                                      .text =
                                                                      _diningCartController
                                                                          .notesController
                                                                          .text;
                                                                }
                                                              });

                                                            } else {
                                                              print(
                                                                  "new table select");
                                                              setState(() {
                                                                // if (shiftController.cartController
                                                                //         .cartMaster
                                                                //         ?.oldOrderId !=
                                                                //     null) {
                                                                //   shiftController.cartController
                                                                //           .cartMaster =
                                                                //       null;
                                                                // }
                                                                shiftController.cartController.cartMaster?.oldOrderId = null;
                                                                shiftController.cartController
                                                                        .tableNumber =
                                                                    null;
                                                                shiftController.cartController
                                                                        .diningValue =
                                                                    false;
                                                                _diningCartController
                                                                    .diningUserName = '';
                                                                _diningCartController
                                                                    .diningUserMobileNumber = '';
                                                                _diningCartController
                                                                    .diningNotes = '';
                                                                shiftController.cartController
                                                                    .nameController
                                                                    .text =  _diningCartController
                                                                    .nameController
                                                                    .text;
                                                                shiftController.cartController
                                                                    .phoneNoController
                                                                    .text =  _diningCartController
                                                                    .phoneNoController
                                                                    .text;
                                                                shiftController.cartController
                                                                    .notesController
                                                                    .text = _diningCartController
                                                                    .notesController
                                                                    .text;
                                                                _diningCartController
                                                                        .nameController
                                                                        .text =
                                                                    _diningCartController
                                                                        .diningUserName;
                                                                _diningCartController
                                                                        .phoneNoController
                                                                        .text =
                                                                    _diningCartController
                                                                        .diningUserMobileNumber;
                                                                _diningCartController
                                                                        .notesController
                                                                        .text =
                                                                    _diningCartController
                                                                        .diningNotes;
                                                              });
                                                            }
                                                            print("mmm");

                                                          },
                                                          value: shiftController.cartController
                                                              .diningValue,
                                                          activeColor:
                                                              Constants.yellowColor,
                                                          activeTrackColor:
                                                              Constants.yellowColor,
                                                          inactiveThumbColor:
                                                              Colors.white,
                                                          inactiveTrackColor:
                                                              Colors.white,
                                                        ),
                                                      ],
                                                    ),

                                                )
                                              ],
                                            ),
                                          ),
                                        ),

                                      // getMenu(
                                      //     singleRestaurantsDetailsModel,
                                      //     selectedMenuCategoryIndex,
                                      //     _searchsingleMenuListList1,
                                      //     _searchhalfMenuListList2,
                                      //     _searchdealsMenuListList2)

                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                      //   child: SizedBox(
                                      //     height: 32.0,
                                      //     child: ListView.builder(
                                      //       scrollDirection: Axis.horizontal,
                                      //       itemCount: singleRestaurantsDetailsModel.data!.menuCategory!.length + 1,
                                      //       itemBuilder: (context, index) {
                                      //         return GestureDetector(
                                      //           onTap: () {
                                      //             setState(() {
                                      //               selectedMenuCategoryIndex = index;
                                      //             });
                                      //           },
                                      //           child: Container(
                                      //             margin: EdgeInsets.only(right: 16.0),
                                      //             padding: EdgeInsets.symmetric(horizontal: 16.0),
                                      //             decoration: BoxDecoration(
                                      //               color: selectedMenuCategoryIndex == index
                                      //                   ? Colors.orange
                                      //                   : Colors.grey.withOpacity(0.2),
                                      //               borderRadius: BorderRadius.circular(16.0),
                                      //             ),
                                      //             alignment: Alignment.center,
                                      //             child: Text(
                                      //               index == 0 ? "All" : singleRestaurantsDetailsModel.data!.menuCategory![index - 1].name,
                                      //               style: TextStyle(
                                      //                 color: selectedMenuCategoryIndex == index
                                      //                     ? Colors.white
                                      //                     : Colors.black,
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         );
                                      //       },
                                      //     ),
                                      //   ),
                                      // ),
                                      ///NO////
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       horizontal: 16.0, vertical: 8.0),
                                      //   child: SizedBox(
                                      //     height: 32.0,
                                      //     child: ListView.builder(
                                      //       scrollDirection: Axis.horizontal,
                                      //       itemCount: singleRestaurantsDetailsModel
                                      //               .data!.menuCategory!.length +
                                      //           1,
                                      //       itemBuilder: (context, index) {
                                      //         return GestureDetector(
                                      //           onTap: () {
                                      //             setState(() {
                                      //               _selectedCategoryIndex = index;
                                      //             });
                                      //           },
                                      //           child: Container(
                                      //             margin: EdgeInsets.only(right: 16.0),
                                      //             padding: EdgeInsets.symmetric(
                                      //                 horizontal: 16.0),
                                      //             decoration: BoxDecoration(
                                      //               color: _selectedCategoryIndex == index
                                      //                   ? Colors.blue
                                      //                   : Colors.grey.withOpacity(0.2),
                                      //               borderRadius:
                                      //                   BorderRadius.circular(16.0),
                                      //             ),
                                      //             alignment: Alignment.center,
                                      //             child: Text(
                                      //               index == 0
                                      //                   ? "All"
                                      //                   : singleRestaurantsDetailsModel
                                      //                       .data!
                                      //                       .menuCategory![index - 1]
                                      //                       .name,
                                      //               style: TextStyle(
                                      //                 color:
                                      //                     _selectedCategoryIndex == index
                                      //                         ? Colors.white
                                      //                         : Colors.black,
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         );
                                      //       },
                                      //     ),
                                      //   ),
                                      // ),

                                      //             Expanded(
                                      //               child: ListView.builder(
                                      // itemCount: selectedMenuCategoryIndex == 0
                                      // ? singleRestaurantsDetailsModel.data!.menuCategory!.length
                                      //     : singleRestaurantsDetailsModel.data!.menuCategory!
                                      //     .where((singleMenu) =>
                                      // singleMenu.menu?.category == _categoryNames[_selectedCategoryIndex - 1])
                                      //     .length,
                                      // itemBuilder: (context, index) {
                                      // SingleMenu singleMenu;
                                      // if (selectedMenuCategoryIndex == 0) {
                                      // singleMenu = _singleMenus![index];
                                      // } else {
                                      // singleMenu = _singleMenus!.where((singleMenu) =>
                                      // singleMenu.menu?.category == _categoryNames[selectedMenuCategoryIndex - 1])[index];
                                      // }
                                      //
                                      //               ),
                                      //
                                      //
                                      //             )

                                      ///**************
                                      Expanded(child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ///New
                                            // Container(
                                            //   height: Get.height,
                                            //   width: Get.width * 0.1,
                                            //   margin: EdgeInsets.only(top: 5),
                                            //   decoration: BoxDecoration(
                                            //     color: Colors.red,
                                            //     borderRadius:
                                            //         BorderRadius.circular(16.0),
                                            //   ),
                                            //   child: Column(
                                            //     children: [
                                            //       SizedBox(
                                            //         height: 70,
                                            //       ),
                                            //       GridView.builder(
                                            //         shrinkWrap: true,
                                            //         scrollDirection:
                                            //             Axis.vertical,
                                            //         // physics: const NeverScrollableScrollPhysics(),
                                            //         gridDelegate:
                                            //             SliverGridDelegateWithFixedCrossAxisCount(
                                            //           crossAxisCount: 2,
                                            //           mainAxisExtent:
                                            //               Get.height * 0.1,
                                            //         ),
                                            //         itemCount: sidebarGridTileList
                                            //             .length,
                                            //         itemBuilder: (BuildContext
                                            //                 context,
                                            //             int sidebarGridTileListIndex) {
                                            //           return sidebarGridTileList[
                                            //               sidebarGridTileListIndex];
                                            //         },
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                            // SizedBox(width: 5),
                                            ///Old
                                            //                             child: ListView.builder(
                                            //                                 itemCount:
                                            //                                     singleRestaurantsDetailsModel
                                            //                                         .data!
                                            //                                         .menuCategory!
                                            //                                         .length,
                                            //                                 shrinkWrap: true,
                                            //                                 scrollDirection:
                                            //                                     Axis.horizontal,
                                            //                                 itemBuilder: (context,
                                            //                                     menuCategoryIndex) {
                                            //
                                            //                                     List<MenuCategory> menu =
                                            //                                     singleRestaurantsDetailsModel
                                            //                                         .data!
                                            //                                         .menuCategory!;
                                            //                                     MenuCategory menuCategory =
                                            //                                     menu[menuCategoryIndex];
                                            //                                     menu[selectedMenuCategoryIndex]
                                            //                                         .selected = true;
                                            //                                     return Padding(
                                            //                                       padding:
                                            //                                       const EdgeInsets.all(
                                            //                                           8.0),
                                            //                                       child: GestureDetector(
                                            //                                         onTap: () {
                                            //                                           setState(() {
                                            //                                             for (MenuCategory _menuCategory
                                            //                                             in menu) {
                                            //                                               _menuCategory
                                            //                                                   .selected =
                                            //                                               false;
                                            //                                             }
                                            //                                             selectedMenuCategoryIndex =
                                            //                                                 menuCategoryIndex;
                                            //                                           });
                                            //                                         },
                                            //                                         child: Container(
                                            //                                           padding: EdgeInsets
                                            //                                               .symmetric(
                                            //                                               vertical:
                                            //                                               10.0,
                                            //                                               horizontal:
                                            //                                               25.0),
                                            //                                           decoration: BoxDecoration(
                                            //                                               color: menuCategory
                                            //                                                   .selected
                                            //                                                   ? Color(
                                            //                                                   Constants
                                            //                                                       .colorTheme)
                                            //                                                   : null,
                                            //                                               borderRadius:
                                            //                                               BorderRadius
                                            //                                                   .circular(
                                            //                                                   24),
                                            //                                               border: Border
                                            //                                                   .all(
                                            //                                                   color: Colors
                                            //                                                       .redAccent,
                                            //                                                   width: 1)),
                                            //                                           child: Align(
                                            //                                             alignment: Alignment
                                            //                                                 .center,
                                            //                                             child: Column(
                                            //                                               mainAxisAlignment:
                                            //                                               MainAxisAlignment
                                            //                                                   .center,
                                            //                                               children: [
                                            //                                                 Text(
                                            //                                                   menuCategory
                                            //                                                       .name,
                                            //                                                   style: TextStyle(
                                            //                                                       fontSize:
                                            //                                                       11,
                                            //                                                       fontWeight:
                                            //                                                       FontWeight
                                            //                                                           .w700,
                                            //                                                       color: menuCategory
                                            //                                                           .selected
                                            //                                                           ? Colors
                                            //                                                           .white
                                            //                                                           : null),
                                            //                                                 ),
                                            //                                               ],
                                            //                                             ),
                                            //                                           ),
                                            //                                         ),
                                            //                                       ),
                                            //                                     );
                                            //
                                            // }),
                                            Container(
                                              height: Get.height,
                                              width: Get.width * 0.72,
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage('images/bg-full.jpg'),
                                                    fit: BoxFit.cover,
                                                  )),

                                              ///old
                                              // child: Column(
                                              //   children: [
                                              //     TextField(
                                              //       onChanged: _updateSearchQuery,
                                              //       decoration: InputDecoration(
                                              //         hintText: 'Search menu items',
                                              //         border: OutlineInputBorder(),
                                              //       ),
                                              //     ),
                                              //     Expanded(
                                              //       child: ListView(
                                              //         children: singleRestaurantsDetailsModel.data!.menuCategory![selectedMenuCategoryIndex].getFilteredMenuItems(_searchQuery).map((item) =>
                                              //             ListTile(
                                              //               title: Text(item.menu?.name ?? item.name),
                                              //             )
                                              //         ).toList(),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              child: Column(
                                                children: [
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 60,
                                                            width: Get.width * 0.10,
                                                              // color: Colors.red,
                                                              child: Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                  child:  InkWell(
                                                                    onTap: _openDrawer,
                                                                    // onTap: (){
                                                                    //   var random = Random();
                                                                    //   var uniqueId = '';
                                                                    //     uniqueId = random.nextInt(999999999).toString().padRight(10, '0');
                                                                    //     print("unique id $uniqueId");
                                                                    //
                                                                    //   print(uniqueId);
                                                                    // },
                                                                    child: Container(
                                                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                                                      decoration: BoxDecoration(
                                                                        color: Color(Constants.colorTheme),
                                                                        borderRadius: BorderRadius.circular(5)
                                                                      ),
                                                                      child: Icon(Icons.menu, color: Colors.white,),
                                                                    ),
                                                                  )
                                                                ),
                                                              )
                                                          ),
                                                          Container(
                                                            height: 60,
                                                            width: Get.width * 0.6,

                                                            // child: ListView.builder(
                                                            //   itemCount:
                                                            //       singleRestaurantsDetailsModel
                                                            //               .data!
                                                            //               .menuCategory!
                                                            //               .length +
                                                            //           1,
                                                            //   shrinkWrap: true,
                                                            //   scrollDirection:
                                                            //       Axis.horizontal,
                                                            //   itemBuilder:
                                                            //       (context, index) {
                                                            //     if (index == 0) {
                                                            //       // Render a custom container for index 0
                                                            //       return Padding(
                                                            //         padding:
                                                            //             const EdgeInsets
                                                            //                 .all(8.0),
                                                            //         child: GestureDetector(
                                                            //           onTap: () {
                                                            //             // setState(() {
                                                            //             //   showAllMenuItems =
                                                            //             //       true; // Update the state when custom container is pressed
                                                            //             // });
                                                            //           },
                                                            //           child: Container(
                                                            //             padding:
                                                            //                 const EdgeInsets
                                                            //                         .symmetric(
                                                            //                     vertical:
                                                            //                         10.0,
                                                            //                     horizontal:
                                                            //                         25.0),
                                                            //             decoration:
                                                            //                 BoxDecoration(
                                                            //               borderRadius:
                                                            //                   BorderRadius
                                                            //                       .circular(
                                                            //                           24),
                                                            //               border: Border.all(
                                                            //                   color: Colors
                                                            //                       .redAccent,
                                                            //                   width: 1),
                                                            //             ),
                                                            //             child: const Center(
                                                            //               child: Text(
                                                            //                 'All',
                                                            //                 style:
                                                            //                     TextStyle(
                                                            //                   fontSize: 11,
                                                            //                   fontWeight:
                                                            //                       FontWeight
                                                            //                           .w700,
                                                            //                 ),
                                                            //               ),
                                                            //             ),
                                                            //           ),
                                                            //         ),
                                                            //       );
                                                            //     } else {
                                                            //       // Render the remaining menu categories
                                                            //       List<MenuCategory> menu =
                                                            //           singleRestaurantsDetailsModel
                                                            //               .data!
                                                            //               .menuCategory!;
                                                            //       MenuCategory
                                                            //           menuCategory =
                                                            //           menu[index - 1];
                                                            //       menu[selectedMenuCategoryIndex]
                                                            //           .selected = true;
                                                            //       return Padding(
                                                            //         padding:
                                                            //             const EdgeInsets
                                                            //                 .all(8.0),
                                                            //         child: GestureDetector(
                                                            //           onTap: () {
                                                            //             setState(() {
                                                            //               for (MenuCategory _menuCategory
                                                            //                   in menu) {
                                                            //                 _menuCategory
                                                            //                         .selected =
                                                            //                     false;
                                                            //               }
                                                            //               selectedMenuCategoryIndex =
                                                            //                   index - 1;
                                                            //             });
                                                            //           },
                                                            //           child: Container(
                                                            //             padding: EdgeInsets
                                                            //                 .symmetric(
                                                            //                     vertical:
                                                            //                         10.0,
                                                            //                     horizontal:
                                                            //                         25.0),
                                                            //             decoration:
                                                            //                 BoxDecoration(
                                                            //               color: menuCategory
                                                            //                       .selected
                                                            //                   ? Color(Constants
                                                            //                       .colorTheme)
                                                            //                   : null,
                                                            //               borderRadius:
                                                            //                   BorderRadius
                                                            //                       .circular(
                                                            //                           24),
                                                            //               border: Border.all(
                                                            //                   color: Colors
                                                            //                       .redAccent,
                                                            //                   width: 1),
                                                            //             ),
                                                            //             child: Align(
                                                            //               alignment:
                                                            //                   Alignment
                                                            //                       .center,
                                                            //               child: Column(
                                                            //                 mainAxisAlignment:
                                                            //                     MainAxisAlignment
                                                            //                         .center,
                                                            //                 children: [
                                                            //                   Text(
                                                            //                     menuCategory
                                                            //                         .name,
                                                            //                     style:
                                                            //                         TextStyle(
                                                            //                       fontSize:
                                                            //                           11,
                                                            //                       fontWeight:
                                                            //                           FontWeight
                                                            //                               .w700,
                                                            //                       color: menuCategory
                                                            //                               .selected
                                                            //                           ? Colors
                                                            //                               .white
                                                            //                           : null,
                                                            //                     ),
                                                            //                   ),
                                                            //                 ],
                                                            //               ),
                                                            //             ),
                                                            //           ),
                                                            //         ),
                                                            //       );
                                                            //     }
                                                            //   },
                                                            // )
                                                            child: ListView.builder(
                                                              padding: EdgeInsets.zero,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount:
                                                                  singleRestaurantsDetailsModel
                                                                          .data!
                                                                          .menuCategory!
                                                                          .length +
                                                                      1,
                                                              itemBuilder:
                                                                  (context, index) {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(vertical: 8, horizontal: 4.0),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        _selectedCategoryIndex =
                                                                            index;
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      padding: EdgeInsets
                                                                          .symmetric(
                                                                              vertical:
                                                                                  10.0,
                                                                              horizontal:
                                                                                  25.0),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: _selectedCategoryIndex ==
                                                                                index
                                                                            ? Color(Constants
                                                                                .colorTheme)
                                                                            : null,
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                    10),
                                                                        border: Border.all(
                                                                            color: Colors
                                                                                .redAccent,
                                                                            width: 1),
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Text(
                                                                        index == 0
                                                                            ? "All"
                                                                            : singleRestaurantsDetailsModel
                                                                                .data!
                                                                                .menuCategory![index -
                                                                                    1]
                                                                                .name,
                                                                        style:
                                                                            TextStyle(
                                                                          color: _selectedCategoryIndex ==
                                                                                  index
                                                                              ? Colors
                                                                                  .white
                                                                              : Colors
                                                                                  .black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  ),
                                                  ///Second Last Grid View///
                                                  // Expanded(
                                                  //
                                                  //   child: GridView.builder(
                                                  //     shrinkWrap: true,
                                                  //     gridDelegate:
                                                  //         SliverGridDelegateWithFixedCrossAxisCount(
                                                  //       crossAxisCount: 5,
                                                  //       mainAxisExtent: Get.height * 0.25,
                                                  //     ),
                                                  //     itemCount: _getMenuItemCount(
                                                  //         singleRestaurantsDetailsModel
                                                  //             .data!.menuCategory!),
                                                  //     itemBuilder: (BuildContext context,
                                                  //         int index) {
                                                  //       SingleMenu? singleMenu;
                                                  //       if (_selectedCategoryIndex == 0) {
                                                  //         int total = 0;
                                                  //         for (int i = 0;
                                                  //             i < _menuCategories.length;
                                                  //             i++) {
                                                  //           if (_menuCategories[i]
                                                  //                   .singleMenu !=
                                                  //               null) {
                                                  //             for (int j = 0;
                                                  //                 j <
                                                  //                     _menuCategories[i]
                                                  //                         .singleMenu!
                                                  //                         .length;
                                                  //                 j++) {
                                                  //               if (_searchQuery
                                                  //                       .isEmpty ||
                                                  //                   _menuCategories[i]
                                                  //                       .singleMenu![j]
                                                  //                       .menu!
                                                  //                       .name
                                                  //                       .toLowerCase()
                                                  //                       .contains(_searchQuery
                                                  //                           .toLowerCase())) {
                                                  //                 if (index == total) {
                                                  //                   singleMenu =
                                                  //                       _menuCategories[i]
                                                  //                           .singleMenu![j];
                                                  //                   break;
                                                  //                 }
                                                  //                 total++;
                                                  //               }
                                                  //             }
                                                  //           }
                                                  //           if (singleMenu != null) {
                                                  //             break;
                                                  //           }
                                                  //         }
                                                  //       } else {
                                                  //         if (_menuCategories[
                                                  //                         _selectedCategoryIndex -
                                                  //                             1]
                                                  //                     .singleMenu !=
                                                  //                 null &&
                                                  //             (_searchQuery.isEmpty ||
                                                  //                 _menuCategories[
                                                  //                         _selectedCategoryIndex -
                                                  //                             1]
                                                  //                     .singleMenu![index]
                                                  //                     .menu!
                                                  //                     .name
                                                  //                     .toLowerCase()
                                                  //                     .contains(_searchQuery
                                                  //                         .toLowerCase()))) {
                                                  //           singleMenu = _menuCategories[
                                                  //                   _selectedCategoryIndex -
                                                  //                       1]
                                                  //               .singleMenu![index];
                                                  //         }
                                                  //       }
                                                  //       if (singleMenu != null) {
                                                  //         return GestureDetector(
                                                  //           onTap: () async {
                                                  //             // TODO: && operator added
                                                  //             if (singleMenu!
                                                  //                         .menu!.price ==
                                                  //                     null ||
                                                  //                 singleMenu
                                                  //                     .menu!
                                                  //                     .menuAddon!
                                                  //                     .isNotEmpty) {
                                                  //               List<MenuSize> tempList =
                                                  //                   [];
                                                  //               tempList.addAll(singleMenu
                                                  //                   .menu!.menuSize!);
                                                  //               if (singleMenu
                                                  //                       .menu!.price ==
                                                  //                   null) {
                                                  //                 List<MenuSize>
                                                  //                     menuSizeList =
                                                  //                     singleMenu.menu!
                                                  //                         .menuSize!;
                                                  //                 for (int menuSizeIndex =
                                                  //                         0;
                                                  //                     menuSizeIndex <
                                                  //                         menuSizeList
                                                  //                             .length;
                                                  //                     menuSizeIndex++) {
                                                  //                   List<MenuAddon>
                                                  //                       groupMenuAddon =
                                                  //                       menuSizeList[
                                                  //                               menuSizeIndex]
                                                  //                           .groupMenuAddon!;
                                                  //                   Set set = {};
                                                  //                   for (int groupMenuAddonIndex =
                                                  //                           0;
                                                  //                       groupMenuAddonIndex <
                                                  //                           groupMenuAddon
                                                  //                               .length;
                                                  //                       groupMenuAddonIndex++) {
                                                  //                     if (set.contains(
                                                  //                         groupMenuAddon[
                                                  //                                 groupMenuAddonIndex]
                                                  //                             .addonCategoryId)) {
                                                  //                       //duplicate
                                                  //                       groupMenuAddon[
                                                  //                               groupMenuAddonIndex]
                                                  //                           .isDuplicate = true;
                                                  //                     } else {
                                                  //                       //unique
                                                  //                       set.add(groupMenuAddon[
                                                  //                               groupMenuAddonIndex]
                                                  //                           .addonCategoryId);
                                                  //                     }
                                                  //                   }
                                                  //                 }
                                                  //                 showDialog(
                                                  //                     context: context,
                                                  //                     builder:
                                                  //                         (BuildContext
                                                  //                             context) {
                                                  //                       return AlertDialog(
                                                  //                         contentPadding:
                                                  //                             EdgeInsets
                                                  //                                 .all(
                                                  //                                     0.0),
                                                  //                         shape:
                                                  //                             RoundedRectangleBorder(
                                                  //                           borderRadius:
                                                  //                               BorderRadius
                                                  //                                   .all(
                                                  //                             Radius
                                                  //                                 .circular(
                                                  //                                     20),
                                                  //                           ),
                                                  //                         ),
                                                  //                         clipBehavior: Clip
                                                  //                             .antiAliasWithSaveLayer,
                                                  //                         content:
                                                  //                             Builder(
                                                  //                           builder:
                                                  //                               (context) {
                                                  //                             var height =
                                                  //                                 MediaQuery.of(context)
                                                  //                                     .size
                                                  //                                     .height;
                                                  //                             var width =
                                                  //                                 MediaQuery.of(context)
                                                  //                                     .size
                                                  //                                     .width;
                                                  //                             return Container(
                                                  //                                 height: height -
                                                  //                                     100,
                                                  //                                 width: width *
                                                  //                                     0.5,
                                                  //                                 child:
                                                  //                                     AddonsWithSized(
                                                  //                                   menu:
                                                  //                                       singleMenu!.menu!,
                                                  //                                   category:
                                                  //                                       "SINGLE",
                                                  //                                   data: singleMenu
                                                  //                                       .menu!
                                                  //                                       .menuSize!,
                                                  //                                 ));
                                                  //                           },
                                                  //                         ),
                                                  //                       );
                                                  //                     });
                                                  //               } else if (singleMenu
                                                  //                   .menu!
                                                  //                   .menuAddon!
                                                  //                   .isNotEmpty) {
                                                  //                 print("ADDONS ONly ");
                                                  //                 showDialog(
                                                  //                     context: context,
                                                  //                     builder:
                                                  //                         (BuildContext
                                                  //                             context) {
                                                  //                       return AlertDialog(
                                                  //                         contentPadding:
                                                  //                             const EdgeInsets
                                                  //                                     .all(
                                                  //                                 0.0),
                                                  //                         shape:
                                                  //                             const RoundedRectangleBorder(
                                                  //                           borderRadius:
                                                  //                               BorderRadius
                                                  //                                   .all(
                                                  //                             Radius
                                                  //                                 .circular(
                                                  //                                     20),
                                                  //                           ),
                                                  //                         ),
                                                  //                         clipBehavior: Clip
                                                  //                             .antiAliasWithSaveLayer,
                                                  //                         content:
                                                  //                             Builder(
                                                  //                           builder:
                                                  //                               (context) {
                                                  //                             var height =
                                                  //                                 MediaQuery.of(context)
                                                  //                                     .size
                                                  //                                     .height;
                                                  //                             var width =
                                                  //                                 MediaQuery.of(context)
                                                  //                                     .size
                                                  //                                     .width;
                                                  //                             return Container(
                                                  //                               height:
                                                  //                                   height -
                                                  //                                       100,
                                                  //                               width:
                                                  //                                   width *
                                                  //                                       0.5,
                                                  //                               child:
                                                  //                                   AddonsOnly(
                                                  //                                 data: singleMenu!
                                                  //                                     .menu!,
                                                  //                                 menuPrice: singleMenu
                                                  //                                     .menu!
                                                  //                                     .price!,
                                                  //                                 menuId:
                                                  //                                     singleMenu.id,
                                                  //                                 category:
                                                  //                                     "SINGLE",
                                                  //                                 vendor: singleRestaurantsDetailsModel
                                                  //                                     .data!
                                                  //                                     .vendor!,
                                                  //                               ),
                                                  //                             );
                                                  //                           },
                                                  //                         ),
                                                  //                       );
                                                  //                     });
                                                  //               }
                                                  //             } else {
                                                  //               shiftController.cartController.addItem(
                                                  //                   cart.Cart(
                                                  //                       diningAmount: double
                                                  //                           .parse(singleMenu
                                                  //                                   .menu!
                                                  //                                   .diningPrice ??
                                                  //                               '0.0'),
                                                  //                       category:
                                                  //                           "SINGLE",
                                                  //                       menu: [
                                                  //                         cart.MenuCartMaster(
                                                  //                           name:
                                                  //                               singleMenu
                                                  //                                   .menu!
                                                  //                                   .name,
                                                  //                           totalAmount: double.parse(
                                                  //                               singleMenu
                                                  //                                   .menu!
                                                  //                                   .price!),
                                                  //                           id: singleMenu
                                                  //                               .id,
                                                  //                           addons: [],
                                                  //                           image:
                                                  //                               singleMenu
                                                  //                                   .menu!
                                                  //                                   .image,
                                                  //                         )
                                                  //                       ],
                                                  //                       size: null,
                                                  //                       totalAmount:
                                                  //                           double.parse(
                                                  //                               singleMenu
                                                  //                                   .menu!
                                                  //                                   .price!),
                                                  //                       quantity: 1),
                                                  //                   Constants.vendorId,
                                                  //                   context);
                                                  //               shiftController.cartController
                                                  //                       .refreshScreen
                                                  //                       .value =
                                                  //                   toggleBoolValue(
                                                  //                       shiftController.cartController
                                                  //                           .refreshScreen
                                                  //                           .value);
                                                  //             }
                                                  //             // _addToCart(singleMenu!, index);
                                                  //           },
                                                  //           child: Container(
                                                  //             // alignment: Alignment.center,
                                                  //             margin:
                                                  //                 const EdgeInsets.only(
                                                  //                     left: 8.0,
                                                  //                     right: 8.0,
                                                  //                     bottom: 8.0),
                                                  //             decoration:
                                                  //                 const BoxDecoration(
                                                  //                     color: Colors.white,
                                                  //                     borderRadius:
                                                  //                         BorderRadius
                                                  //                             .all(Radius
                                                  //                                 .circular(
                                                  //                                     8))),
                                                  //             child: Column(
                                                  //               crossAxisAlignment:
                                                  //                   CrossAxisAlignment
                                                  //                       .center,
                                                  //               mainAxisAlignment:
                                                  //                   MainAxisAlignment
                                                  //                       .center,
                                                  //               children: [
                                                  //                 Container(
                                                  //                   height: 100,
                                                  //                   width: 100,
                                                  //                   // margin: EdgeInsets.only(left: 5.0),
                                                  //                   // decoration: ,
                                                  //                   decoration:
                                                  //                       BoxDecoration(
                                                  //                     image: DecorationImage(
                                                  //                         image: CachedNetworkImageProvider(
                                                  //                             singleMenu!
                                                  //                                 .menu!
                                                  //                                 .image),
                                                  //                         fit: BoxFit
                                                  //                             .fill),
                                                  //                     borderRadius:
                                                  //                         BorderRadius
                                                  //                             .circular(
                                                  //                                 12.0),
                                                  //                   ),
                                                  //                 ),
                                                  //                 Text(
                                                  //                   singleMenu.menu!.name,
                                                  //                   textAlign:
                                                  //                       TextAlign.center,
                                                  //                   maxLines: 2,
                                                  //                   style: TextStyle(
                                                  //                     overflow:
                                                  //                         TextOverflow
                                                  //                             .ellipsis,
                                                  //                     fontFamily:
                                                  //                         "ProximaBold",
                                                  //                     color: Color(
                                                  //                         Constants
                                                  //                             .colorTheme),
                                                  //                     fontSize: 17,
                                                  //                   ),
                                                  //                 ),
                                                  //                 Text(
                                                  //                   "Normal ${singleMenu.menu!.price}" ??
                                                  //                       "Price In Addons",
                                                  //                   overflow: TextOverflow
                                                  //                       .ellipsis,
                                                  //                   maxLines: 1,
                                                  //                   style:
                                                  //                       const TextStyle(
                                                  //                     fontWeight:
                                                  //                         FontWeight.w500,
                                                  //                     color: Colors.red,
                                                  //                     fontSize: 14,
                                                  //                     overflow:
                                                  //                         TextOverflow
                                                  //                             .ellipsis,
                                                  //                   ),
                                                  //                 ),
                                                  //                 Text(
                                                  //                   "Dining ${singleMenu.menu!.diningPrice}" ??
                                                  //                       "0.0",
                                                  //                   overflow: TextOverflow
                                                  //                       .ellipsis,
                                                  //                   maxLines: 1,
                                                  //                   style:
                                                  //                       const TextStyle(
                                                  //                     fontWeight:
                                                  //                         FontWeight.w500,
                                                  //                     color: Colors.red,
                                                  //                     fontSize: 14,
                                                  //                     overflow:
                                                  //                         TextOverflow
                                                  //                             .ellipsis,
                                                  //                   ),
                                                  //                 ),
                                                  //                 const SizedBox(
                                                  //                   height: 5,
                                                  //                 )
                                                  //               ],
                                                  //             ),
                                                  //           ),
                                                  //         );
                                                  //       } else {
                                                  //         return Container(); // Return an empty container if the item doesn't match the search query
                                                  //       }
                                                  //     },
                                                  //   ),
                                                  // ),
                                                  ///on d
                                                  // onTap: () async {
                                                  //                                                   // TODO: && operator added
                                                  //                                                   if (singleMenu!
                                                  //                                                       .menu!.price ==
                                                  //                                                       null ||
                                                  //                                                       singleMenu
                                                  //                                                           .menu!
                                                  //                                                           .menuAddon!
                                                  //                                                           .isNotEmpty) {
                                                  //                                                     List<MenuSize> tempList =
                                                  //                                                     [];
                                                  //                                                     tempList.addAll(singleMenu
                                                  //                                                         .menu!.menuSize!);
                                                  //                                                     if (singleMenu
                                                  //                                                         .menu!.price ==
                                                  //                                                         null) {
                                                  //                                                       List<MenuSize>
                                                  //                                                       menuSizeList =
                                                  //                                                       singleMenu.menu!
                                                  //                                                           .menuSize!;
                                                  //                                                       for (int menuSizeIndex =
                                                  //                                                       0;
                                                  //                                                       menuSizeIndex <
                                                  //                                                           menuSizeList
                                                  //                                                               .length;
                                                  //                                                       menuSizeIndex++) {
                                                  //                                                         List<MenuAddon>
                                                  //                                                         groupMenuAddon =
                                                  //                                                         menuSizeList[
                                                  //                                                         menuSizeIndex]
                                                  //                                                             .groupMenuAddon!;
                                                  //                                                         Set set = {};
                                                  //                                                         for (int groupMenuAddonIndex =
                                                  //                                                         0;
                                                  //                                                         groupMenuAddonIndex <
                                                  //                                                             groupMenuAddon
                                                  //                                                                 .length;
                                                  //                                                         groupMenuAddonIndex++) {
                                                  //                                                           if (set.contains(
                                                  //                                                               groupMenuAddon[
                                                  //                                                               groupMenuAddonIndex]
                                                  //                                                                   .addonCategoryId)) {
                                                  //                                                             //duplicate
                                                  //                                                             groupMenuAddon[
                                                  //                                                             groupMenuAddonIndex]
                                                  //                                                                 .isDuplicate = true;
                                                  //                                                           } else {
                                                  //                                                             //unique
                                                  //                                                             set.add(groupMenuAddon[
                                                  //                                                             groupMenuAddonIndex]
                                                  //                                                                 .addonCategoryId);
                                                  //                                                           }
                                                  //                                                         }
                                                  //                                                       }
                                                  //                                                       showDialog(
                                                  //                                                           context: context,
                                                  //                                                           builder:
                                                  //                                                               (BuildContext
                                                  //                                                           context) {
                                                  //                                                             return AlertDialog(
                                                  //                                                               contentPadding:
                                                  //                                                               EdgeInsets
                                                  //                                                                   .all(
                                                  //                                                                   0.0),
                                                  //                                                               shape:
                                                  //                                                               RoundedRectangleBorder(
                                                  //                                                                 borderRadius:
                                                  //                                                                 BorderRadius
                                                  //                                                                     .all(
                                                  //                                                                   Radius
                                                  //                                                                       .circular(
                                                  //                                                                       20),
                                                  //                                                                 ),
                                                  //                                                               ),
                                                  //                                                               clipBehavior: Clip
                                                  //                                                                   .antiAliasWithSaveLayer,
                                                  //                                                               content:
                                                  //                                                               Builder(
                                                  //                                                                 builder:
                                                  //                                                                     (context) {
                                                  //                                                                   var height =
                                                  //                                                                       MediaQuery.of(context)
                                                  //                                                                           .size
                                                  //                                                                           .height;
                                                  //                                                                   var width =
                                                  //                                                                       MediaQuery.of(context)
                                                  //                                                                           .size
                                                  //                                                                           .width;
                                                  //                                                                   return Container(
                                                  //                                                                       height: height -
                                                  //                                                                           100,
                                                  //                                                                       width: width *
                                                  //                                                                           0.5,
                                                  //                                                                       child:
                                                  //                                                                       AddonsWithSized(
                                                  //                                                                         menu:
                                                  //                                                                         singleMenu!.menu!,
                                                  //                                                                         category:
                                                  //                                                                         "SINGLE",
                                                  //                                                                         data: singleMenu
                                                  //                                                                             .menu!
                                                  //                                                                             .menuSize!,
                                                  //                                                                       ));
                                                  //                                                                 },
                                                  //                                                               ),
                                                  //                                                             );
                                                  //                                                           });
                                                  //                                                     } else if (singleMenu
                                                  //                                                         .menu!
                                                  //                                                         .menuAddon!
                                                  //                                                         .isNotEmpty) {
                                                  //                                                       print("ADDONS ONly ");
                                                  //                                                       showDialog(
                                                  //                                                           context: context,
                                                  //                                                           builder:
                                                  //                                                               (BuildContext
                                                  //                                                           context) {
                                                  //                                                             return AlertDialog(
                                                  //                                                               contentPadding:
                                                  //                                                               const EdgeInsets
                                                  //                                                                   .all(
                                                  //                                                                   0.0),
                                                  //                                                               shape:
                                                  //                                                               const RoundedRectangleBorder(
                                                  //                                                                 borderRadius:
                                                  //                                                                 BorderRadius
                                                  //                                                                     .all(
                                                  //                                                                   Radius
                                                  //                                                                       .circular(
                                                  //                                                                       20),
                                                  //                                                                 ),
                                                  //                                                               ),
                                                  //                                                               clipBehavior: Clip
                                                  //                                                                   .antiAliasWithSaveLayer,
                                                  //                                                               content:
                                                  //                                                               Builder(
                                                  //                                                                 builder:
                                                  //                                                                     (context) {
                                                  //                                                                   var height =
                                                  //                                                                       MediaQuery.of(context)
                                                  //                                                                           .size
                                                  //                                                                           .height;
                                                  //                                                                   var width =
                                                  //                                                                       MediaQuery.of(context)
                                                  //                                                                           .size
                                                  //                                                                           .width;
                                                  //                                                                   return Container(
                                                  //                                                                     height:
                                                  //                                                                     height -
                                                  //                                                                         100,
                                                  //                                                                     width:
                                                  //                                                                     width *
                                                  //                                                                         0.5,
                                                  //                                                                     child:
                                                  //                                                                     AddonsOnly(
                                                  //                                                                       data: singleMenu!
                                                  //                                                                           .menu!,
                                                  //                                                                       menuPrice: singleMenu
                                                  //                                                                           .menu!
                                                  //                                                                           .price!,
                                                  //                                                                       menuId:
                                                  //                                                                       singleMenu.id,
                                                  //                                                                       category:
                                                  //                                                                       "SINGLE",
                                                  //                                                                       vendor: singleRestaurantsDetailsModel
                                                  //                                                                           .data!
                                                  //                                                                           .vendor!,
                                                  //                                                                     ),
                                                  //                                                                   );
                                                  //                                                                 },
                                                  //                                                               ),
                                                  //                                                             );
                                                  //                                                           });
                                                  //                                                     }
                                                  //                                                   } else {
                                                  //                                                     shiftController.cartController.addItem(
                                                  //                                                         cart.Cart(
                                                  //                                                             diningAmount: double
                                                  //                                                                 .parse(singleMenu
                                                  //                                                                 .menu!
                                                  //                                                                 .diningPrice ??
                                                  //                                                                 '0.0'),
                                                  //                                                             category:
                                                  //                                                             "SINGLE",
                                                  //                                                             menu: [
                                                  //                                                               cart.MenuCartMaster(
                                                  //                                                                 name:
                                                  //                                                                 singleMenu
                                                  //                                                                     .menu!
                                                  //                                                                     .name,
                                                  //                                                                 totalAmount: double.parse(
                                                  //                                                                     singleMenu
                                                  //                                                                         .menu!
                                                  //                                                                         .price!),
                                                  //                                                                 id: singleMenu
                                                  //                                                                     .id,
                                                  //                                                                 addons: [],
                                                  //                                                                 image:
                                                  //                                                                 singleMenu
                                                  //                                                                     .menu!
                                                  //                                                                     .image,
                                                  //                                                               )
                                                  //                                                             ],
                                                  //                                                             size: null,
                                                  //                                                             totalAmount:
                                                  //                                                             double.parse(
                                                  //                                                                 singleMenu
                                                  //                                                                     .menu!
                                                  //                                                                     .price!),
                                                  //                                                             quantity: 1),
                                                  //                                                         Constants.vendorId,
                                                  //                                                         context);
                                                  //                                                     shiftController.cartController
                                                  //                                                         .refreshScreen
                                                  //                                                         .value =
                                                  //                                                         toggleBoolValue(
                                                  //                                                             shiftController.cartController
                                                  //                                                                 .refreshScreen
                                                  //                                                                 .value);
                                                  //                                                   }
                                                  //                                                   // _addToCart(singleMenu!, index);
                                                  //                                                 },
                                                  Expanded(
                                                    child: GridView.builder(
                                                      shrinkWrap: true,
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisSpacing: 10,
                                                        mainAxisSpacing: 10,
                                                        crossAxisCount: 6,
                                                        mainAxisExtent: isVisibleImage == true ? Get.height * 0.24 : Get.height * 0.095,
                                                      ),
                                                      itemCount: _getMenuItemCount(
                                                          singleRestaurantsDetailsModel
                                                              .data!
                                                              .menuCategory!),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        SingleMenu? singleMenu;
                                                        List<SingleMenu>
                                                            filteredMenus = [];
                                                        if (_selectedCategoryIndex ==
                                                            0) {
                                                          for (MenuCategory category
                                                              in singleRestaurantsDetailsModel
                                                                  .data!
                                                                  .menuCategory!) {
                                                            filteredMenus.addAll(category
                                                                .singleMenu!
                                                                .where((menu) => menu
                                                                    .menu!.name
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        _searchQuery
                                                                            .toLowerCase()))
                                                                .toList());
                                                          }
                                                        } else {
                                                          filteredMenus.addAll(singleRestaurantsDetailsModel
                                                              .data!
                                                              .menuCategory![
                                                                  _selectedCategoryIndex -
                                                                      1]
                                                              .singleMenu!
                                                              .where((menu) => menu
                                                                  .menu!.name
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      _searchQuery
                                                                          .toLowerCase()))
                                                              .toList());
                                                        }
                                                        if (index <
                                                            filteredMenus
                                                                .length) {
                                                          singleMenu =
                                                              filteredMenus[
                                                                  index];
                                                        }
                                                        return singleMenu == null
                                                            ? SizedBox.shrink()
                                                            : GestureDetector(
                                                                onTap: () async {
                                                                  final prefs =
                                                                      await SharedPreferences
                                                                          .getInstance();
                                                                  String
                                                                      vendorId =
                                                                      prefs.getString(Constants
                                                                              .vendorId
                                                                              .toString()) ??
                                                                          '';
                                                                  // TODO: && operator added
                                                                  if (singleMenu!
                                                                              .menu!
                                                                              .price ==
                                                                          null ||
                                                                      singleMenu
                                                                          .menu!
                                                                          .menuAddon!
                                                                          .isNotEmpty) {
                                                                    print(
                                                                        "not empty addon");
                                                                    List<MenuSize>
                                                                        tempList =
                                                                        [];
                                                                    tempList.addAll(
                                                                        singleMenu
                                                                            .menu!
                                                                            .menuSize!);
                                                                    if (singleMenu
                                                                            .menu!
                                                                            .price ==
                                                                        null) {
                                                                      print(
                                                                          "ADDONS Only");
                                                                      List<MenuSize>
                                                                          menuSizeList =
                                                                          singleMenu
                                                                              .menu!
                                                                              .menuSize!;
                                                                      for (int menuSizeIndex =
                                                                              0;
                                                                          menuSizeIndex <
                                                                              menuSizeList.length;
                                                                          menuSizeIndex++) {
                                                                        List<MenuAddon>
                                                                            groupMenuAddon =
                                                                            menuSizeList[menuSizeIndex]
                                                                                .groupMenuAddon!;
                                                                        Set set =
                                                                            {};
                                                                        for (int groupMenuAddonIndex =
                                                                                0;
                                                                            groupMenuAddonIndex <
                                                                                groupMenuAddon.length;
                                                                            groupMenuAddonIndex++) {
                                                                          if (set.contains(
                                                                              groupMenuAddon[groupMenuAddonIndex].addonCategoryId)) {
                                                                            //duplicate
                                                                            groupMenuAddon[groupMenuAddonIndex].isDuplicate =
                                                                                true;
                                                                          } else {
                                                                            //unique
                                                                            set.add(
                                                                                groupMenuAddon[groupMenuAddonIndex].addonCategoryId);
                                                                          }
                                                                        }
                                                                      }
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext
                                                                                  context) {
                                                                            return AlertDialog(
                                                                              contentPadding:
                                                                                  EdgeInsets.all(0.0),
                                                                              shape:
                                                                                  RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(20),
                                                                                ),
                                                                              ),
                                                                              clipBehavior:
                                                                                  Clip.antiAliasWithSaveLayer,
                                                                              content:
                                                                                  Builder(
                                                                                builder: (context) {
                                                                                  var height = MediaQuery.of(context).size.height;
                                                                                  var width = MediaQuery.of(context).size.width;
                                                                                  return Container(
                                                                                      height: height - 100,
                                                                                      width: width * 0.5,
                                                                                      child: AddonsWithSized(
                                                                                        menu: singleMenu!.menu!,
                                                                                        category: "SINGLE",
                                                                                        data: singleMenu.menu!.menuSize!,
                                                                                      ));
                                                                                },
                                                                              ),
                                                                            );
                                                                          });
                                                                    } else if (singleMenu
                                                                        .menu!
                                                                        .menuAddon!
                                                                        .isNotEmpty) {
                                                                      print(
                                                                          "ADDONS Only Dialog");

                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext
                                                                                  context) {
                                                                            return AlertDialog(
                                                                              contentPadding:
                                                                                  const EdgeInsets.all(0.0),
                                                                              shape:
                                                                                  const RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(20),
                                                                                ),
                                                                              ),
                                                                              clipBehavior:
                                                                                  Clip.antiAliasWithSaveLayer,
                                                                              content:
                                                                                  Builder(
                                                                                builder: (context) {
                                                                                  var height = MediaQuery.of(context).size.height;
                                                                                  var width = MediaQuery.of(context).size.width;
                                                                                  return Container(
                                                                                    height: height - 300,
                                                                                    // height: height - 100,
                                                                                    width: width * 0.5,
                                                                                    child: AddonsOnly(
                                                                                      data: singleMenu!.menu!,
                                                                                      menuPrice: singleMenu.menu!.price!,
                                                                                      menuId: singleMenu.id,
                                                                                      category: "SINGLE",
                                                                                      vendor: singleRestaurantsDetailsModel.data!.vendor!,
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            );
                                                                          });
                                                                    }
                                                                  } else {
                                                                    print(
                                                                        "Empty addon");
                                                                    shiftController.cartController.addItem(
                                                                        cart.Cart(
                                                                            diningAmount: double.parse(singleMenu.menu!.diningPrice!),
                                                                            category: "SINGLE",
                                                                            menu: [
                                                                              cart.MenuCartMaster(
                                                                                name: singleMenu.menu!.name,
                                                                                totalAmount: double.parse(singleMenu.menu!.price!),
                                                                                id: singleMenu.id,
                                                                                addons: [],
                                                                                modifiers: [],
                                                                                image: singleMenu.menu!.image,
                                                                              )
                                                                            ],
                                                                            size: null,
                                                                            totalAmount: double.parse(singleMenu.menu!.price!),
                                                                            quantity: 1),
                                                                        int.parse(vendorId.toString()),
                                                                        context);
                                                                    shiftController.cartController
                                                                            .refreshScreen
                                                                            .value =
                                                                        toggleBoolValue(shiftController.cartController
                                                                            .refreshScreen
                                                                            .value);
                                                                  }
                                                                },
                                                                child: Container(
                                                                  // alignment: Alignment.center,
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              8.0,
                                                                          right:
                                                                              8.0,
                                                                          top:
                                                                              8.0,
                                                                      bottom: 8.0,
                                                                      ),
                                                                  decoration:  BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          // color: Colors.grey.withOpacity(0.5),
                                                                          color: Colors.grey.withOpacity(0.2),
                                                                          spreadRadius: 5,
                                                                          blurRadius: 7,
                                                                          offset: Offset(0, 3), // changes position of shadow
                                                                        ),
                                                                      ],
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(8))),
                                                                  child: Column(
                                                                    // crossAxisAlignment:
                                                                    //     CrossAxisAlignment
                                                                    //         .center,
                                                                    // mainAxisAlignment:
                                                                    //     MainAxisAlignment
                                                                    //         .center,
                                                                    children: [
                                                                      Visibility(
                                                                        visible: isVisibleImage,
                                                                        child: Container(
                                                                          height:
                                                                              100,
                                                                          width:
                                                                              100,
                                                                          // margin: EdgeInsets.only(left: 5.0),
                                                                          // decoration: ,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            image: DecorationImage(
                                                                                image: CachedNetworkImageProvider(
                                                                                    singleMenu
                                                                                        .menu!
                                                                                        .image),
                                                                                // image: NetworkImage(singleMenu.menu!.image),
                                                                                fit: BoxFit.fill),
                                                                            borderRadius:
                                                                                BorderRadius.circular(12.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        singleMenu
                                                                            .menu!
                                                                            .name,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        maxLines:
                                                                            2,
                                                                        style:
                                                                            TextStyle(
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          fontFamily:
                                                                              "ProximaBold",
                                                                          color: Color(
                                                                              Constants.colorTheme),
                                                                          fontSize:
                                                                              17,
                                                                        ),
                                                                      ),
                                                                      singleMenu.menu!.price.toString() ==
                                                                                  'null' &&
                                                                              singleMenu.menu!.diningPrice ==
                                                                                  null
                                                                          ? Text(
                                                                              "Customizable",
                                                                              style:
                                                                                  TextStyle(color: Theme.of(context).primaryColor),
                                                                            )
                                                                          : isVisibleImage == false ?  Text(
                                                                        "\$ ${singleMenu.menu!.price}",
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 1,
                                                                        style: const TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Colors.red,
                                                                          fontSize: 13,
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                      ) : Column(
                                                                              children: [

                                                                                Text(
                                                                                  "Normal ${singleMenu.menu!.price}" ?? "Price In Addons",
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 1,
                                                                                  style: const TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.red,
                                                                                    fontSize: 13,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  "Dining ${singleMenu.menu!.diningPrice}" ?? "0.0",
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 1,
                                                                                  style: const TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.red,
                                                                                    fontSize: 13,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),

                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(8))),
                                              width: Get.width * 0.27,
                                              child: Obx(() {
                                                if (shiftController.cartController
                                                        .refreshScreen.value ||
                                                    !shiftController.cartController
                                                        .refreshScreen.value) {
                                                  return CartScreen(
                                                      isDining: shiftController.cartController
                                                          .diningValue,
                                                  updateDiningValue: updateDiningValue,
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              }),
                                            )
                                          ],
                                        )),
                                    ],
                                  ),
                                  Positioned(
                                    left: 65,
                                    top: Get.height * 0.07,
                                    child: CircleAvatar(
                                        radius: 36,
                                        backgroundImage:
                                            Image.network(vendor.image).image),
                                  ),
                                ],
                              );
                            } else {
                              return Text('Success is not true');
                            }
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else {
                            print("Circle");
                            return Center(
                              child: CircularProgressIndicator(
                                  color: Color(Constants.colorTheme)),
                            );
                          }
                        },
                      ),
                    );
                  }
                  // else if (constraints.maxWidth > 650 &&
                  //     constraints.maxWidth < 900) {
                  //   print("Tablet");
                  //   return SafeArea(
                  //     child:
                  //         FutureBuilder<BaseModel<SingleRestaurantsDetailsModel>>(
                  //       future: _orderCustimizationController
                  //           .callGetRestaurantsDetails(),
                  //       builder: (BuildContext context,
                  //           AsyncSnapshot<
                  //                   BaseModel<SingleRestaurantsDetailsModel>>
                  //               snapshot) {
                  //         if (snapshot.hasData) {
                  //           SingleRestaurantsDetailsModel
                  //               singleRestaurantsDetailsModel =
                  //               snapshot.data!.data!;
                  //           // singleRestaurantsDetailsModel.data.menuCategory.
                  //           if (singleRestaurantsDetailsModel.success) {
                  //             Vendor vendor =
                  //                 singleRestaurantsDetailsModel.data!.vendor!;
                  //             List vendorNameList = vendor.name.split(' ');
                  //             List<MenuCategory> _menuCategories =
                  //                 singleRestaurantsDetailsModel
                  //                     .data!.menuCategory!;
                  //             return Stack(
                  //               children: [
                  //                 Column(
                  //                   children: [
                  //                     ClipPath(
                  //                       clipper: AppbarClipper(),
                  //                       child: Container(
                  //                         height: Get.height * 0.1,
                  //                         width: Get.width,
                  //                         decoration: BoxDecoration(
                  //                             color: Color(Constants.colorTheme)),
                  //                         child: Row(
                  //                           children: [
                  //                             Row(
                  //                               mainAxisAlignment:
                  //                                   MainAxisAlignment.start,
                  //                               children: [
                  //                                 SizedBox(
                  //                                   width: 10,
                  //                                 ),
                  //                                 Padding(
                  //                                   padding:
                  //                                       const EdgeInsets.only(
                  //                                           bottom: 25.0),
                  //                                   child: RichText(
                  //                                     text: TextSpan(
                  //                                       // Note: Styles for TextSpans must be explicitly defined.
                  //                                       // Child text spans will inherit styles from parent
                  //                                       style: TextStyle(
                  //                                         fontSize: 14.0,
                  //                                         color: Colors.black,
                  //                                       ),
                  //                                       children: <TextSpan>[
                  //                                         TextSpan(
                  //                                             text:
                  //                                                 vendorNameList[
                  //                                                     0],
                  //                                             style: TextStyle(
                  //                                                 fontWeight:
                  //                                                     FontWeight
                  //                                                         .w800,
                  //                                                 fontSize: 25,
                  //                                                 color: Colors
                  //                                                     .black)),
                  //                                         TextSpan(text: ' '),
                  //                                         TextSpan(
                  //                                             text:
                  //                                                 vendorNameList[
                  //                                                     1],
                  //                                             style: TextStyle(
                  //                                                 fontWeight:
                  //                                                     FontWeight
                  //                                                         .w800,
                  //                                                 fontSize: 25,
                  //                                                 color: Colors
                  //                                                     .white)),
                  //                                       ],
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                             Spacer(),
                  //                             Container(
                  //                               width: 200,
                  //                               // child: TextField(
                  //                               //   // controller: _controller,
                  //                               //   decoration: const InputDecoration(
                  //                               //     hintText: 'Search',
                  //                               //     suffixIcon: Icon(Icons.search),
                  //                               //   ),
                  //                               //   onChanged: (value) {
                  //                               //     setState(() {
                  //                               //       searchQuery = value;
                  //                               //     });
                  //                               //     // setState(() {
                  //                               //     //   searchText = value;
                  //                               //     // });
                  //                               //     // _search(value,singleRestaurantsDetailsModel.data!.menuCategory![0].singleMenu!,singleRestaurantsDetailsModel.data!.menuCategory![0].halfNHalfMenu!,singleRestaurantsDetailsModel.data!.menuCategory![0].dealsMenu!);
                  //                               //   },
                  //                               // ),
                  //                               child: TextField(
                  //                                 style: TextStyle(
                  //                                     color: Colors.white),
                  //                                 onChanged: (value) {
                  //                                   setState(() {
                  //                                     _searchQuery = value;
                  //                                   });
                  //                                 },
                  //                                 decoration: const InputDecoration(
                  //                                     labelText: 'Search',
                  //                                     labelStyle: TextStyle(
                  //                                         color: Colors.white)
                  //                                     // border: OutlineInputBorder(),
                  //                                     ),
                  //                               ),
                  //                             ),
                  //                             SizedBox(
                  //                               width: Get.width * 0.3,
                  //                               child: Row(
                  //                                 mainAxisAlignment:
                  //                                     MainAxisAlignment
                  //                                         .spaceAround,
                  //                                 children: [
                  //                                   if (shiftController.cartController
                  //                                       .diningValue)
                  //                                     Center(
                  //                                       child: Text(
                  //                                         'DINING',
                  //                                         style: TextStyle(
                  //                                           color: Colors.white,
                  //                                           fontSize: 50,
                  //                                           fontWeight:
                  //                                               FontWeight.bold,
                  //                                         ),
                  //                                       ),
                  //                                     )
                  //                                   else
                  //                                     Center(
                  //                                       child: Text(
                  //                                         'TAKEAWAY',
                  //                                         style: TextStyle(
                  //                                           color: Colors.white,
                  //                                           fontSize: 50,
                  //                                           fontWeight:
                  //                                               FontWeight.bold,
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                   Switch(
                  //                                     onChanged:
                  //                                         (bool? value) async {
                  //                                       if (value!) {
                  //                                         await showDialog<int>(
                  //                                             context: context,
                  //                                             builder:
                  //                                                 (_) =>
                  //                                                     AlertDialog(
                  //                                                       title: Center(
                  //                                                           child:
                  //                                                               Text('Available table no')),
                  //                                                       content:
                  //                                                           SizedBox(
                  //                                                         height: Get.height *
                  //                                                             0.4,
                  //                                                         width: Get.width *
                  //                                                             0.5,
                  //                                                         child:
                  //                                                             Column(
                  //                                                           children: [
                  //                                                             Expanded(
                  //                                                               child: FutureBuilder<BookTableModel>(
                  //                                                                   future: getBookTable(),
                  //                                                                   builder: (context, snapshot) {
                  //                                                                     if (snapshot.hasError) {
                  //                                                                       return Center(
                  //                                                                         child: Text(snapshot.error.toString()),
                  //                                                                       );
                  //                                                                     } else if (snapshot.hasData) {
                  //                                                                       return GridView.builder(
                  //                                                                         itemCount: snapshot.data?.data.bookedTable.length ?? 0,
                  //                                                                         itemBuilder: (builder, index) {
                  //                                                                           return GestureDetector(
                  //                                                                             onTap: () async {
                  //                                                                               final prefs = await SharedPreferences.getInstance();
                  //                                                                               String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
                  //                                                                               shiftController.cartController.tableNumber = snapshot.data!.data.bookedTable[index].bookedTableNumber;
                  //                                                                               if (snapshot.data!.data.bookedTable[index].status == 1) {
                  //                                                                                 Map<String, dynamic> param = {
                  //                                                                                   'vendor_id': int.parse(vendorId.toString()),
                  //                                                                                   'booked_table_number': snapshot.data!.data.bookedTable[index].bookedTableNumber,
                  //                                                                                 };
                  //                                                                                 BaseModel<BookedOrderModel> baseModel = await shiftController.cartController.getBookedTableData(param, context);
                  //                                                                                 BookedOrderModel bookOrderModel = baseModel.data!;
                  //                                                                                 if (bookOrderModel.success!) {
                  //                                                                                   print('order');
                  //                                                                                   print("****************");
                  //                                                                                   if (bookOrderModel.data!.userName != null) {
                  //                                                                                     _diningCartController.diningUserName = bookOrderModel.data!.userName!;
                  //                                                                                   }
                  //                                                                                   print(bookOrderModel.data!.userName);
                  //                                                                                   print("****************");
                  //
                  //                                                                                   print("----------------");
                  //                                                                                   if (bookOrderModel.data!.mobile != null) {
                  //                                                                                     _diningCartController.diningUserMobileNumber = bookOrderModel.data!.mobile!;
                  //                                                                                   }
                  //                                                                                   print(bookOrderModel.data!.mobile);
                  //                                                                                   if (bookOrderModel.data!.notes != null) {
                  //                                                                                     _diningCartController.diningNotes = bookOrderModel.data!.notes!;
                  //                                                                                   }
                  //                                                                                   print(bookOrderModel.data!.notes);
                  //                                                                                   print("----------------");
                  //                                                                                   print(bookOrderModel.data!.orderId);
                  //                                                                                   shiftController.cartController.cartMaster = cm.CartMaster.fromMap(jsonDecode(bookOrderModel.data!.orderData!));
                  //                                                                                   shiftController.cartController.cartMaster?.oldOrderId = bookOrderModel.data!.orderId;
                  //                                                                                   Navigator.pop(context);
                  //                                                                                 } else {
                  //                                                                                   print(bookOrderModel.toJson());
                  //                                                                                   // print(baseModel.error);
                  //                                                                                 }
                  //                                                                               } else {
                  //                                                                                 Navigator.pop(context);
                  //                                                                               }
                  //                                                                             },
                  //                                                                             child: Container(
                  //                                                                               margin: EdgeInsets.only(bottom: 18),
                  //                                                                               child: Stack(
                  //                                                                                 children: [
                  //                                                                                   Positioned(
                  //                                                                                     child: Container(
                  //                                                                                       padding: EdgeInsets.all(40.0),
                  //                                                                                       decoration: BoxDecoration(color: snapshot.data!.data.bookedTable[index].status == 1 ? Color(Constants.colorTheme) : Colors.green, shape: BoxShape.circle),
                  //                                                                                     ),
                  //                                                                                   ),
                  //                                                                                   Center(
                  //                                                                                     child: Text(
                  //                                                                                       snapshot.data!.data.bookedTable[index].bookedTableNumber.toString(),
                  //                                                                                       style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                  //                                                                                     ),
                  //                                                                                   ),
                  //                                                                                 ],
                  //                                                                               ),
                  //                                                                             ),
                  //                                                                           );
                  //                                                                         },
                  //                                                                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //                                                                           crossAxisCount: kIsWeb ? 8 : 3,
                  //                                                                           mainAxisExtent: 80,
                  //                                                                         ),
                  //                                                                       );
                  //                                                                     }
                  //                                                                     return Center(
                  //                                                                       child: CircularProgressIndicator(color: Color(Constants.colorTheme)),
                  //                                                                     );
                  //                                                                   }),
                  //                                                             ),
                  //                                                           ],
                  //                                                         ),
                  //                                                       ),
                  //                                                     ));
                  //                                         setState(() {
                  //                                           // shiftController.cartController.tableNumber!=null?selectMethod=DeliveryMethod.TAKEAWAY:null;
                  //                                           shiftController.cartController
                  //                                                   .diningValue =
                  //                                               shiftController.cartController
                  //                                                           .tableNumber !=
                  //                                                       null
                  //                                                   ? true
                  //                                                   : false;
                  //                                           shiftController.cartController
                  //                                                   .isPromocodeApplied =
                  //                                               false;
                  //                                         });
                  //                                       } else {
                  //                                         setState(() {
                  //                                           if (shiftController.cartController
                  //                                                   .cartMaster
                  //                                                   ?.oldOrderId !=
                  //                                               null) {
                  //                                             shiftController.cartController
                  //                                                     .cartMaster =
                  //                                                 null;
                  //                                           }
                  //                                           shiftController.cartController
                  //                                                   .tableNumber =
                  //                                               null;
                  //                                           shiftController.cartController
                  //                                                   .diningValue =
                  //                                               false;
                  //                                         });
                  //                                       }
                  //                                     },
                  //                                     value: shiftController.cartController
                  //                                         .diningValue,
                  //                                     activeColor:
                  //                                         Constants.yellowColor,
                  //                                     activeTrackColor:
                  //                                         Constants.yellowColor,
                  //                                     inactiveThumbColor:
                  //                                         Colors.white,
                  //                                     inactiveTrackColor:
                  //                                         Colors.white,
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             )
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     // getMenu(
                  //                     //     singleRestaurantsDetailsModel,
                  //                     //     selectedMenuCategoryIndex,
                  //                     //     _searchsingleMenuListList1,
                  //                     //     _searchhalfMenuListList2,
                  //                     //     _searchdealsMenuListList2)
                  //
                  //                     // Padding(
                  //                     //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  //                     //   child: SizedBox(
                  //                     //     height: 32.0,
                  //                     //     child: ListView.builder(
                  //                     //       scrollDirection: Axis.horizontal,
                  //                     //       itemCount: singleRestaurantsDetailsModel.data!.menuCategory!.length + 1,
                  //                     //       itemBuilder: (context, index) {
                  //                     //         return GestureDetector(
                  //                     //           onTap: () {
                  //                     //             setState(() {
                  //                     //               selectedMenuCategoryIndex = index;
                  //                     //             });
                  //                     //           },
                  //                     //           child: Container(
                  //                     //             margin: EdgeInsets.only(right: 16.0),
                  //                     //             padding: EdgeInsets.symmetric(horizontal: 16.0),
                  //                     //             decoration: BoxDecoration(
                  //                     //               color: selectedMenuCategoryIndex == index
                  //                     //                   ? Colors.orange
                  //                     //                   : Colors.grey.withOpacity(0.2),
                  //                     //               borderRadius: BorderRadius.circular(16.0),
                  //                     //             ),
                  //                     //             alignment: Alignment.center,
                  //                     //             child: Text(
                  //                     //               index == 0 ? "All" : singleRestaurantsDetailsModel.data!.menuCategory![index - 1].name,
                  //                     //               style: TextStyle(
                  //                     //                 color: selectedMenuCategoryIndex == index
                  //                     //                     ? Colors.white
                  //                     //                     : Colors.black,
                  //                     //               ),
                  //                     //             ),
                  //                     //           ),
                  //                     //         );
                  //                     //       },
                  //                     //     ),
                  //                     //   ),
                  //                     // ),
                  //                     ///NO////
                  //                     // Padding(
                  //                     //   padding: const EdgeInsets.symmetric(
                  //                     //       horizontal: 16.0, vertical: 8.0),
                  //                     //   child: SizedBox(
                  //                     //     height: 32.0,
                  //                     //     child: ListView.builder(
                  //                     //       scrollDirection: Axis.horizontal,
                  //                     //       itemCount: singleRestaurantsDetailsModel
                  //                     //               .data!.menuCategory!.length +
                  //                     //           1,
                  //                     //       itemBuilder: (context, index) {
                  //                     //         return GestureDetector(
                  //                     //           onTap: () {
                  //                     //             setState(() {
                  //                     //               _selectedCategoryIndex = index;
                  //                     //             });
                  //                     //           },
                  //                     //           child: Container(
                  //                     //             margin: EdgeInsets.only(right: 16.0),
                  //                     //             padding: EdgeInsets.symmetric(
                  //                     //                 horizontal: 16.0),
                  //                     //             decoration: BoxDecoration(
                  //                     //               color: _selectedCategoryIndex == index
                  //                     //                   ? Colors.blue
                  //                     //                   : Colors.grey.withOpacity(0.2),
                  //                     //               borderRadius:
                  //                     //                   BorderRadius.circular(16.0),
                  //                     //             ),
                  //                     //             alignment: Alignment.center,
                  //                     //             child: Text(
                  //                     //               index == 0
                  //                     //                   ? "All"
                  //                     //                   : singleRestaurantsDetailsModel
                  //                     //                       .data!
                  //                     //                       .menuCategory![index - 1]
                  //                     //                       .name,
                  //                     //               style: TextStyle(
                  //                     //                 color:
                  //                     //                     _selectedCategoryIndex == index
                  //                     //                         ? Colors.white
                  //                     //                         : Colors.black,
                  //                     //               ),
                  //                     //             ),
                  //                     //           ),
                  //                     //         );
                  //                     //       },
                  //                     //     ),
                  //                     //   ),
                  //                     // ),
                  //
                  //                     //             Expanded(
                  //                     //               child: ListView.builder(
                  //                     // itemCount: selectedMenuCategoryIndex == 0
                  //                     // ? singleRestaurantsDetailsModel.data!.menuCategory!.length
                  //                     //     : singleRestaurantsDetailsModel.data!.menuCategory!
                  //                     //     .where((singleMenu) =>
                  //                     // singleMenu.menu?.category == _categoryNames[_selectedCategoryIndex - 1])
                  //                     //     .length,
                  //                     // itemBuilder: (context, index) {
                  //                     // SingleMenu singleMenu;
                  //                     // if (selectedMenuCategoryIndex == 0) {
                  //                     // singleMenu = _singleMenus![index];
                  //                     // } else {
                  //                     // singleMenu = _singleMenus!.where((singleMenu) =>
                  //                     // singleMenu.menu?.category == _categoryNames[selectedMenuCategoryIndex - 1])[index];
                  //                     // }
                  //                     //
                  //                     //               ),
                  //                     //
                  //                     //
                  //                     //             )
                  //
                  //                     ///**************
                  //                     Expanded(
                  //                       child: Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.start,
                  //                         children: [
                  //                           Container(
                  //                             height: Get.height,
                  //                             width: Get.width * 0.1,
                  //                             margin: EdgeInsets.only(top: 5),
                  //                             decoration: BoxDecoration(
                  //                               color: Colors.white,
                  //                               borderRadius:
                  //                                   BorderRadius.circular(16.0),
                  //                             ),
                  //                             child: Column(
                  //                               children: [
                  //                                 SizedBox(
                  //                                   height: 70,
                  //                                 ),
                  //                                 GridView.builder(
                  //                                   shrinkWrap: true,
                  //                                   scrollDirection:
                  //                                       Axis.vertical,
                  //                                   // physics: const NeverScrollableScrollPhysics(),
                  //                                   gridDelegate:
                  //                                       SliverGridDelegateWithFixedCrossAxisCount(
                  //                                     crossAxisCount: 2,
                  //                                     mainAxisExtent:
                  //                                         Get.height * 0.1,
                  //                                   ),
                  //                                   itemCount: sidebarGridTileList
                  //                                       .length,
                  //                                   itemBuilder: (BuildContext
                  //                                           context,
                  //                                       int sidebarGridTileListIndex) {
                  //                                     return sidebarGridTileList[
                  //                                         sidebarGridTileListIndex];
                  //                                   },
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           SizedBox(width: 5),
                  //                           //                             child: ListView.builder(
                  //                           //                                 itemCount:
                  //                           //                                     singleRestaurantsDetailsModel
                  //                           //                                         .data!
                  //                           //                                         .menuCategory!
                  //                           //                                         .length,
                  //                           //                                 shrinkWrap: true,
                  //                           //                                 scrollDirection:
                  //                           //                                     Axis.horizontal,
                  //                           //                                 itemBuilder: (context,
                  //                           //                                     menuCategoryIndex) {
                  //                           //
                  //                           //                                     List<MenuCategory> menu =
                  //                           //                                     singleRestaurantsDetailsModel
                  //                           //                                         .data!
                  //                           //                                         .menuCategory!;
                  //                           //                                     MenuCategory menuCategory =
                  //                           //                                     menu[menuCategoryIndex];
                  //                           //                                     menu[selectedMenuCategoryIndex]
                  //                           //                                         .selected = true;
                  //                           //                                     return Padding(
                  //                           //                                       padding:
                  //                           //                                       const EdgeInsets.all(
                  //                           //                                           8.0),
                  //                           //                                       child: GestureDetector(
                  //                           //                                         onTap: () {
                  //                           //                                           setState(() {
                  //                           //                                             for (MenuCategory _menuCategory
                  //                           //                                             in menu) {
                  //                           //                                               _menuCategory
                  //                           //                                                   .selected =
                  //                           //                                               false;
                  //                           //                                             }
                  //                           //                                             selectedMenuCategoryIndex =
                  //                           //                                                 menuCategoryIndex;
                  //                           //                                           });
                  //                           //                                         },
                  //                           //                                         child: Container(
                  //                           //                                           padding: EdgeInsets
                  //                           //                                               .symmetric(
                  //                           //                                               vertical:
                  //                           //                                               10.0,
                  //                           //                                               horizontal:
                  //                           //                                               25.0),
                  //                           //                                           decoration: BoxDecoration(
                  //                           //                                               color: menuCategory
                  //                           //                                                   .selected
                  //                           //                                                   ? Color(
                  //                           //                                                   Constants
                  //                           //                                                       .colorTheme)
                  //                           //                                                   : null,
                  //                           //                                               borderRadius:
                  //                           //                                               BorderRadius
                  //                           //                                                   .circular(
                  //                           //                                                   24),
                  //                           //                                               border: Border
                  //                           //                                                   .all(
                  //                           //                                                   color: Colors
                  //                           //                                                       .redAccent,
                  //                           //                                                   width: 1)),
                  //                           //                                           child: Align(
                  //                           //                                             alignment: Alignment
                  //                           //                                                 .center,
                  //                           //                                             child: Column(
                  //                           //                                               mainAxisAlignment:
                  //                           //                                               MainAxisAlignment
                  //                           //                                                   .center,
                  //                           //                                               children: [
                  //                           //                                                 Text(
                  //                           //                                                   menuCategory
                  //                           //                                                       .name,
                  //                           //                                                   style: TextStyle(
                  //                           //                                                       fontSize:
                  //                           //                                                       11,
                  //                           //                                                       fontWeight:
                  //                           //                                                       FontWeight
                  //                           //                                                           .w700,
                  //                           //                                                       color: menuCategory
                  //                           //                                                           .selected
                  //                           //                                                           ? Colors
                  //                           //                                                           .white
                  //                           //                                                           : null),
                  //                           //                                                 ),
                  //                           //                                               ],
                  //                           //                                             ),
                  //                           //                                           ),
                  //                           //                                         ),
                  //                           //                                       ),
                  //                           //                                     );
                  //                           //
                  //                           // }),
                  //                           Container(
                  //                             height: Get.height,
                  //                             width: Get.width * 0.45,
                  //                             // child: Column(
                  //                             //   children: [
                  //                             //     TextField(
                  //                             //       onChanged: _updateSearchQuery,
                  //                             //       decoration: InputDecoration(
                  //                             //         hintText: 'Search menu items',
                  //                             //         border: OutlineInputBorder(),
                  //                             //       ),
                  //                             //     ),
                  //                             //     Expanded(
                  //                             //       child: ListView(
                  //                             //         children: singleRestaurantsDetailsModel.data!.menuCategory![selectedMenuCategoryIndex].getFilteredMenuItems(_searchQuery).map((item) =>
                  //                             //             ListTile(
                  //                             //               title: Text(item.menu?.name ?? item.name),
                  //                             //             )
                  //                             //         ).toList(),
                  //                             //       ),
                  //                             //     ),
                  //                             //   ],
                  //                             // ),
                  //                             child: Column(
                  //                               children: [
                  //                                 Column(
                  //                                   children: [
                  //                                     SizedBox(
                  //                                       height: 5,
                  //                                     ),
                  //                                     Container(
                  //                                       decoration: BoxDecoration(
                  //                                           color: Colors.white,
                  //                                           borderRadius:
                  //                                               BorderRadius.all(
                  //                                                   Radius
                  //                                                       .circular(
                  //                                                           8))),
                  //                                       height: 60,
                  //                                       width: Get.width * 0.9,
                  //
                  //                                       // child: ListView.builder(
                  //                                       //   itemCount:
                  //                                       //       singleRestaurantsDetailsModel
                  //                                       //               .data!
                  //                                       //               .menuCategory!
                  //                                       //               .length +
                  //                                       //           1,
                  //                                       //   shrinkWrap: true,
                  //                                       //   scrollDirection:
                  //                                       //       Axis.horizontal,
                  //                                       //   itemBuilder:
                  //                                       //       (context, index) {
                  //                                       //     if (index == 0) {
                  //                                       //       // Render a custom container for index 0
                  //                                       //       return Padding(
                  //                                       //         padding:
                  //                                       //             const EdgeInsets
                  //                                       //                 .all(8.0),
                  //                                       //         child: GestureDetector(
                  //                                       //           onTap: () {
                  //                                       //             // setState(() {
                  //                                       //             //   showAllMenuItems =
                  //                                       //             //       true; // Update the state when custom container is pressed
                  //                                       //             // });
                  //                                       //           },
                  //                                       //           child: Container(
                  //                                       //             padding:
                  //                                       //                 const EdgeInsets
                  //                                       //                         .symmetric(
                  //                                       //                     vertical:
                  //                                       //                         10.0,
                  //                                       //                     horizontal:
                  //                                       //                         25.0),
                  //                                       //             decoration:
                  //                                       //                 BoxDecoration(
                  //                                       //               borderRadius:
                  //                                       //                   BorderRadius
                  //                                       //                       .circular(
                  //                                       //                           24),
                  //                                       //               border: Border.all(
                  //                                       //                   color: Colors
                  //                                       //                       .redAccent,
                  //                                       //                   width: 1),
                  //                                       //             ),
                  //                                       //             child: const Center(
                  //                                       //               child: Text(
                  //                                       //                 'All',
                  //                                       //                 style:
                  //                                       //                     TextStyle(
                  //                                       //                   fontSize: 11,
                  //                                       //                   fontWeight:
                  //                                       //                       FontWeight
                  //                                       //                           .w700,
                  //                                       //                 ),
                  //                                       //               ),
                  //                                       //             ),
                  //                                       //           ),
                  //                                       //         ),
                  //                                       //       );
                  //                                       //     } else {
                  //                                       //       // Render the remaining menu categories
                  //                                       //       List<MenuCategory> menu =
                  //                                       //           singleRestaurantsDetailsModel
                  //                                       //               .data!
                  //                                       //               .menuCategory!;
                  //                                       //       MenuCategory
                  //                                       //           menuCategory =
                  //                                       //           menu[index - 1];
                  //                                       //       menu[selectedMenuCategoryIndex]
                  //                                       //           .selected = true;
                  //                                       //       return Padding(
                  //                                       //         padding:
                  //                                       //             const EdgeInsets
                  //                                       //                 .all(8.0),
                  //                                       //         child: GestureDetector(
                  //                                       //           onTap: () {
                  //                                       //             setState(() {
                  //                                       //               for (MenuCategory _menuCategory
                  //                                       //                   in menu) {
                  //                                       //                 _menuCategory
                  //                                       //                         .selected =
                  //                                       //                     false;
                  //                                       //               }
                  //                                       //               selectedMenuCategoryIndex =
                  //                                       //                   index - 1;
                  //                                       //             });
                  //                                       //           },
                  //                                       //           child: Container(
                  //                                       //             padding: EdgeInsets
                  //                                       //                 .symmetric(
                  //                                       //                     vertical:
                  //                                       //                         10.0,
                  //                                       //                     horizontal:
                  //                                       //                         25.0),
                  //                                       //             decoration:
                  //                                       //                 BoxDecoration(
                  //                                       //               color: menuCategory
                  //                                       //                       .selected
                  //                                       //                   ? Color(Constants
                  //                                       //                       .colorTheme)
                  //                                       //                   : null,
                  //                                       //               borderRadius:
                  //                                       //                   BorderRadius
                  //                                       //                       .circular(
                  //                                       //                           24),
                  //                                       //               border: Border.all(
                  //                                       //                   color: Colors
                  //                                       //                       .redAccent,
                  //                                       //                   width: 1),
                  //                                       //             ),
                  //                                       //             child: Align(
                  //                                       //               alignment:
                  //                                       //                   Alignment
                  //                                       //                       .center,
                  //                                       //               child: Column(
                  //                                       //                 mainAxisAlignment:
                  //                                       //                     MainAxisAlignment
                  //                                       //                         .center,
                  //                                       //                 children: [
                  //                                       //                   Text(
                  //                                       //                     menuCategory
                  //                                       //                         .name,
                  //                                       //                     style:
                  //                                       //                         TextStyle(
                  //                                       //                       fontSize:
                  //                                       //                           11,
                  //                                       //                       fontWeight:
                  //                                       //                           FontWeight
                  //                                       //                               .w700,
                  //                                       //                       color: menuCategory
                  //                                       //                               .selected
                  //                                       //                           ? Colors
                  //                                       //                               .white
                  //                                       //                           : null,
                  //                                       //                     ),
                  //                                       //                   ),
                  //                                       //                 ],
                  //                                       //               ),
                  //                                       //             ),
                  //                                       //           ),
                  //                                       //         ),
                  //                                       //       );
                  //                                       //     }
                  //                                       //   },
                  //                                       // )
                  //                                       child: ListView.builder(
                  //                                         scrollDirection:
                  //                                             Axis.horizontal,
                  //                                         itemCount:
                  //                                             singleRestaurantsDetailsModel
                  //                                                     .data!
                  //                                                     .menuCategory!
                  //                                                     .length +
                  //                                                 1,
                  //                                         itemBuilder:
                  //                                             (context, index) {
                  //                                           return Padding(
                  //                                             padding:
                  //                                                 const EdgeInsets
                  //                                                     .all(8.0),
                  //                                             child:
                  //                                                 GestureDetector(
                  //                                               onTap: () {
                  //                                                 setState(() {
                  //                                                   _selectedCategoryIndex =
                  //                                                       index;
                  //                                                 });
                  //                                               },
                  //                                               child: Container(
                  //                                                 padding: EdgeInsets
                  //                                                     .symmetric(
                  //                                                         vertical:
                  //                                                             10.0,
                  //                                                         horizontal:
                  //                                                             25.0),
                  //                                                 decoration:
                  //                                                     BoxDecoration(
                  //                                                   color: _selectedCategoryIndex ==
                  //                                                           index
                  //                                                       ? Color(Constants
                  //                                                           .colorTheme)
                  //                                                       : null,
                  //                                                   borderRadius:
                  //                                                       BorderRadius
                  //                                                           .circular(
                  //                                                               24),
                  //                                                   border: Border.all(
                  //                                                       color: Colors
                  //                                                           .redAccent,
                  //                                                       width: 1),
                  //                                                 ),
                  //                                                 alignment:
                  //                                                     Alignment
                  //                                                         .center,
                  //                                                 child: Text(
                  //                                                   index == 0
                  //                                                       ? "All"
                  //                                                       : singleRestaurantsDetailsModel
                  //                                                           .data!
                  //                                                           .menuCategory![index -
                  //                                                               1]
                  //                                                           .name,
                  //                                                   style:
                  //                                                       TextStyle(
                  //                                                     color: _selectedCategoryIndex ==
                  //                                                             index
                  //                                                         ? Colors
                  //                                                             .white
                  //                                                         : Colors
                  //                                                             .black,
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                             ),
                  //                                           );
                  //                                         },
                  //                                       ),
                  //                                     ),
                  //                                     const SizedBox(
                  //                                       height: 20,
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //
                  //                                 ///Second Last Grid View///
                  //                                 // Expanded(
                  //                                 //
                  //                                 //   child: GridView.builder(
                  //                                 //     shrinkWrap: true,
                  //                                 //     gridDelegate:
                  //                                 //         SliverGridDelegateWithFixedCrossAxisCount(
                  //                                 //       crossAxisCount: 5,
                  //                                 //       mainAxisExtent: Get.height * 0.25,
                  //                                 //     ),
                  //                                 //     itemCount: _getMenuItemCount(
                  //                                 //         singleRestaurantsDetailsModel
                  //                                 //             .data!.menuCategory!),
                  //                                 //     itemBuilder: (BuildContext context,
                  //                                 //         int index) {
                  //                                 //       SingleMenu? singleMenu;
                  //                                 //       if (_selectedCategoryIndex == 0) {
                  //                                 //         int total = 0;
                  //                                 //         for (int i = 0;
                  //                                 //             i < _menuCategories.length;
                  //                                 //             i++) {
                  //                                 //           if (_menuCategories[i]
                  //                                 //                   .singleMenu !=
                  //                                 //               null) {
                  //                                 //             for (int j = 0;
                  //                                 //                 j <
                  //                                 //                     _menuCategories[i]
                  //                                 //                         .singleMenu!
                  //                                 //                         .length;
                  //                                 //                 j++) {
                  //                                 //               if (_searchQuery
                  //                                 //                       .isEmpty ||
                  //                                 //                   _menuCategories[i]
                  //                                 //                       .singleMenu![j]
                  //                                 //                       .menu!
                  //                                 //                       .name
                  //                                 //                       .toLowerCase()
                  //                                 //                       .contains(_searchQuery
                  //                                 //                           .toLowerCase())) {
                  //                                 //                 if (index == total) {
                  //                                 //                   singleMenu =
                  //                                 //                       _menuCategories[i]
                  //                                 //                           .singleMenu![j];
                  //                                 //                   break;
                  //                                 //                 }
                  //                                 //                 total++;
                  //                                 //               }
                  //                                 //             }
                  //                                 //           }
                  //                                 //           if (singleMenu != null) {
                  //                                 //             break;
                  //                                 //           }
                  //                                 //         }
                  //                                 //       } else {
                  //                                 //         if (_menuCategories[
                  //                                 //                         _selectedCategoryIndex -
                  //                                 //                             1]
                  //                                 //                     .singleMenu !=
                  //                                 //                 null &&
                  //                                 //             (_searchQuery.isEmpty ||
                  //                                 //                 _menuCategories[
                  //                                 //                         _selectedCategoryIndex -
                  //                                 //                             1]
                  //                                 //                     .singleMenu![index]
                  //                                 //                     .menu!
                  //                                 //                     .name
                  //                                 //                     .toLowerCase()
                  //                                 //                     .contains(_searchQuery
                  //                                 //                         .toLowerCase()))) {
                  //                                 //           singleMenu = _menuCategories[
                  //                                 //                   _selectedCategoryIndex -
                  //                                 //                       1]
                  //                                 //               .singleMenu![index];
                  //                                 //         }
                  //                                 //       }
                  //                                 //       if (singleMenu != null) {
                  //                                 //         return GestureDetector(
                  //                                 //           onTap: () async {
                  //                                 //             // TODO: && operator added
                  //                                 //             if (singleMenu!
                  //                                 //                         .menu!.price ==
                  //                                 //                     null ||
                  //                                 //                 singleMenu
                  //                                 //                     .menu!
                  //                                 //                     .menuAddon!
                  //                                 //                     .isNotEmpty) {
                  //                                 //               List<MenuSize> tempList =
                  //                                 //                   [];
                  //                                 //               tempList.addAll(singleMenu
                  //                                 //                   .menu!.menuSize!);
                  //                                 //               if (singleMenu
                  //                                 //                       .menu!.price ==
                  //                                 //                   null) {
                  //                                 //                 List<MenuSize>
                  //                                 //                     menuSizeList =
                  //                                 //                     singleMenu.menu!
                  //                                 //                         .menuSize!;
                  //                                 //                 for (int menuSizeIndex =
                  //                                 //                         0;
                  //                                 //                     menuSizeIndex <
                  //                                 //                         menuSizeList
                  //                                 //                             .length;
                  //                                 //                     menuSizeIndex++) {
                  //                                 //                   List<MenuAddon>
                  //                                 //                       groupMenuAddon =
                  //                                 //                       menuSizeList[
                  //                                 //                               menuSizeIndex]
                  //                                 //                           .groupMenuAddon!;
                  //                                 //                   Set set = {};
                  //                                 //                   for (int groupMenuAddonIndex =
                  //                                 //                           0;
                  //                                 //                       groupMenuAddonIndex <
                  //                                 //                           groupMenuAddon
                  //                                 //                               .length;
                  //                                 //                       groupMenuAddonIndex++) {
                  //                                 //                     if (set.contains(
                  //                                 //                         groupMenuAddon[
                  //                                 //                                 groupMenuAddonIndex]
                  //                                 //                             .addonCategoryId)) {
                  //                                 //                       //duplicate
                  //                                 //                       groupMenuAddon[
                  //                                 //                               groupMenuAddonIndex]
                  //                                 //                           .isDuplicate = true;
                  //                                 //                     } else {
                  //                                 //                       //unique
                  //                                 //                       set.add(groupMenuAddon[
                  //                                 //                               groupMenuAddonIndex]
                  //                                 //                           .addonCategoryId);
                  //                                 //                     }
                  //                                 //                   }
                  //                                 //                 }
                  //                                 //                 showDialog(
                  //                                 //                     context: context,
                  //                                 //                     builder:
                  //                                 //                         (BuildContext
                  //                                 //                             context) {
                  //                                 //                       return AlertDialog(
                  //                                 //                         contentPadding:
                  //                                 //                             EdgeInsets
                  //                                 //                                 .all(
                  //                                 //                                     0.0),
                  //                                 //                         shape:
                  //                                 //                             RoundedRectangleBorder(
                  //                                 //                           borderRadius:
                  //                                 //                               BorderRadius
                  //                                 //                                   .all(
                  //                                 //                             Radius
                  //                                 //                                 .circular(
                  //                                 //                                     20),
                  //                                 //                           ),
                  //                                 //                         ),
                  //                                 //                         clipBehavior: Clip
                  //                                 //                             .antiAliasWithSaveLayer,
                  //                                 //                         content:
                  //                                 //                             Builder(
                  //                                 //                           builder:
                  //                                 //                               (context) {
                  //                                 //                             var height =
                  //                                 //                                 MediaQuery.of(context)
                  //                                 //                                     .size
                  //                                 //                                     .height;
                  //                                 //                             var width =
                  //                                 //                                 MediaQuery.of(context)
                  //                                 //                                     .size
                  //                                 //                                     .width;
                  //                                 //                             return Container(
                  //                                 //                                 height: height -
                  //                                 //                                     100,
                  //                                 //                                 width: width *
                  //                                 //                                     0.5,
                  //                                 //                                 child:
                  //                                 //                                     AddonsWithSized(
                  //                                 //                                   menu:
                  //                                 //                                       singleMenu!.menu!,
                  //                                 //                                   category:
                  //                                 //                                       "SINGLE",
                  //                                 //                                   data: singleMenu
                  //                                 //                                       .menu!
                  //                                 //                                       .menuSize!,
                  //                                 //                                 ));
                  //                                 //                           },
                  //                                 //                         ),
                  //                                 //                       );
                  //                                 //                     });
                  //                                 //               } else if (singleMenu
                  //                                 //                   .menu!
                  //                                 //                   .menuAddon!
                  //                                 //                   .isNotEmpty) {
                  //                                 //                 print("ADDONS ONly ");
                  //                                 //                 showDialog(
                  //                                 //                     context: context,
                  //                                 //                     builder:
                  //                                 //                         (BuildContext
                  //                                 //                             context) {
                  //                                 //                       return AlertDialog(
                  //                                 //                         contentPadding:
                  //                                 //                             const EdgeInsets
                  //                                 //                                     .all(
                  //                                 //                                 0.0),
                  //                                 //                         shape:
                  //                                 //                             const RoundedRectangleBorder(
                  //                                 //                           borderRadius:
                  //                                 //                               BorderRadius
                  //                                 //                                   .all(
                  //                                 //                             Radius
                  //                                 //                                 .circular(
                  //                                 //                                     20),
                  //                                 //                           ),
                  //                                 //                         ),
                  //                                 //                         clipBehavior: Clip
                  //                                 //                             .antiAliasWithSaveLayer,
                  //                                 //                         content:
                  //                                 //                             Builder(
                  //                                 //                           builder:
                  //                                 //                               (context) {
                  //                                 //                             var height =
                  //                                 //                                 MediaQuery.of(context)
                  //                                 //                                     .size
                  //                                 //                                     .height;
                  //                                 //                             var width =
                  //                                 //                                 MediaQuery.of(context)
                  //                                 //                                     .size
                  //                                 //                                     .width;
                  //                                 //                             return Container(
                  //                                 //                               height:
                  //                                 //                                   height -
                  //                                 //                                       100,
                  //                                 //                               width:
                  //                                 //                                   width *
                  //                                 //                                       0.5,
                  //                                 //                               child:
                  //                                 //                                   AddonsOnly(
                  //                                 //                                 data: singleMenu!
                  //                                 //                                     .menu!,
                  //                                 //                                 menuPrice: singleMenu
                  //                                 //                                     .menu!
                  //                                 //                                     .price!,
                  //                                 //                                 menuId:
                  //                                 //                                     singleMenu.id,
                  //                                 //                                 category:
                  //                                 //                                     "SINGLE",
                  //                                 //                                 vendor: singleRestaurantsDetailsModel
                  //                                 //                                     .data!
                  //                                 //                                     .vendor!,
                  //                                 //                               ),
                  //                                 //                             );
                  //                                 //                           },
                  //                                 //                         ),
                  //                                 //                       );
                  //                                 //                     });
                  //                                 //               }
                  //                                 //             } else {
                  //                                 //               shiftController.cartController.addItem(
                  //                                 //                   cart.Cart(
                  //                                 //                       diningAmount: double
                  //                                 //                           .parse(singleMenu
                  //                                 //                                   .menu!
                  //                                 //                                   .diningPrice ??
                  //                                 //                               '0.0'),
                  //                                 //                       category:
                  //                                 //                           "SINGLE",
                  //                                 //                       menu: [
                  //                                 //                         cart.MenuCartMaster(
                  //                                 //                           name:
                  //                                 //                               singleMenu
                  //                                 //                                   .menu!
                  //                                 //                                   .name,
                  //                                 //                           totalAmount: double.parse(
                  //                                 //                               singleMenu
                  //                                 //                                   .menu!
                  //                                 //                                   .price!),
                  //                                 //                           id: singleMenu
                  //                                 //                               .id,
                  //                                 //                           addons: [],
                  //                                 //                           image:
                  //                                 //                               singleMenu
                  //                                 //                                   .menu!
                  //                                 //                                   .image,
                  //                                 //                         )
                  //                                 //                       ],
                  //                                 //                       size: null,
                  //                                 //                       totalAmount:
                  //                                 //                           double.parse(
                  //                                 //                               singleMenu
                  //                                 //                                   .menu!
                  //                                 //                                   .price!),
                  //                                 //                       quantity: 1),
                  //                                 //                   Constants.vendorId,
                  //                                 //                   context);
                  //                                 //               shiftController.cartController
                  //                                 //                       .refreshScreen
                  //                                 //                       .value =
                  //                                 //                   toggleBoolValue(
                  //                                 //                       shiftController.cartController
                  //                                 //                           .refreshScreen
                  //                                 //                           .value);
                  //                                 //             }
                  //                                 //             // _addToCart(singleMenu!, index);
                  //                                 //           },
                  //                                 //           child: Container(
                  //                                 //             // alignment: Alignment.center,
                  //                                 //             margin:
                  //                                 //                 const EdgeInsets.only(
                  //                                 //                     left: 8.0,
                  //                                 //                     right: 8.0,
                  //                                 //                     bottom: 8.0),
                  //                                 //             decoration:
                  //                                 //                 const BoxDecoration(
                  //                                 //                     color: Colors.white,
                  //                                 //                     borderRadius:
                  //                                 //                         BorderRadius
                  //                                 //                             .all(Radius
                  //                                 //                                 .circular(
                  //                                 //                                     8))),
                  //                                 //             child: Column(
                  //                                 //               crossAxisAlignment:
                  //                                 //                   CrossAxisAlignment
                  //                                 //                       .center,
                  //                                 //               mainAxisAlignment:
                  //                                 //                   MainAxisAlignment
                  //                                 //                       .center,
                  //                                 //               children: [
                  //                                 //                 Container(
                  //                                 //                   height: 100,
                  //                                 //                   width: 100,
                  //                                 //                   // margin: EdgeInsets.only(left: 5.0),
                  //                                 //                   // decoration: ,
                  //                                 //                   decoration:
                  //                                 //                       BoxDecoration(
                  //                                 //                     image: DecorationImage(
                  //                                 //                         image: CachedNetworkImageProvider(
                  //                                 //                             singleMenu!
                  //                                 //                                 .menu!
                  //                                 //                                 .image),
                  //                                 //                         fit: BoxFit
                  //                                 //                             .fill),
                  //                                 //                     borderRadius:
                  //                                 //                         BorderRadius
                  //                                 //                             .circular(
                  //                                 //                                 12.0),
                  //                                 //                   ),
                  //                                 //                 ),
                  //                                 //                 Text(
                  //                                 //                   singleMenu.menu!.name,
                  //                                 //                   textAlign:
                  //                                 //                       TextAlign.center,
                  //                                 //                   maxLines: 2,
                  //                                 //                   style: TextStyle(
                  //                                 //                     overflow:
                  //                                 //                         TextOverflow
                  //                                 //                             .ellipsis,
                  //                                 //                     fontFamily:
                  //                                 //                         "ProximaBold",
                  //                                 //                     color: Color(
                  //                                 //                         Constants
                  //                                 //                             .colorTheme),
                  //                                 //                     fontSize: 17,
                  //                                 //                   ),
                  //                                 //                 ),
                  //                                 //                 Text(
                  //                                 //                   "Normal ${singleMenu.menu!.price}" ??
                  //                                 //                       "Price In Addons",
                  //                                 //                   overflow: TextOverflow
                  //                                 //                       .ellipsis,
                  //                                 //                   maxLines: 1,
                  //                                 //                   style:
                  //                                 //                       const TextStyle(
                  //                                 //                     fontWeight:
                  //                                 //                         FontWeight.w500,
                  //                                 //                     color: Colors.red,
                  //                                 //                     fontSize: 14,
                  //                                 //                     overflow:
                  //                                 //                         TextOverflow
                  //                                 //                             .ellipsis,
                  //                                 //                   ),
                  //                                 //                 ),
                  //                                 //                 Text(
                  //                                 //                   "Dining ${singleMenu.menu!.diningPrice}" ??
                  //                                 //                       "0.0",
                  //                                 //                   overflow: TextOverflow
                  //                                 //                       .ellipsis,
                  //                                 //                   maxLines: 1,
                  //                                 //                   style:
                  //                                 //                       const TextStyle(
                  //                                 //                     fontWeight:
                  //                                 //                         FontWeight.w500,
                  //                                 //                     color: Colors.red,
                  //                                 //                     fontSize: 14,
                  //                                 //                     overflow:
                  //                                 //                         TextOverflow
                  //                                 //                             .ellipsis,
                  //                                 //                   ),
                  //                                 //                 ),
                  //                                 //                 const SizedBox(
                  //                                 //                   height: 5,
                  //                                 //                 )
                  //                                 //               ],
                  //                                 //             ),
                  //                                 //           ),
                  //                                 //         );
                  //                                 //       } else {
                  //                                 //         return Container(); // Return an empty container if the item doesn't match the search query
                  //                                 //       }
                  //                                 //     },
                  //                                 //   ),
                  //                                 // ),
                  //
                  //                                 Expanded(
                  //                                   child: GridView.builder(
                  //                                     shrinkWrap: true,
                  //                                     gridDelegate:
                  //                                         SliverGridDelegateWithFixedCrossAxisCount(
                  //                                       crossAxisCount: 3,
                  //                                       mainAxisExtent:
                  //                                           Get.height * 0.25,
                  //                                     ),
                  //                                     itemCount: _getMenuItemCount(
                  //                                         singleRestaurantsDetailsModel
                  //                                             .data!
                  //                                             .menuCategory!),
                  //                                     itemBuilder:
                  //                                         (BuildContext context,
                  //                                             int index) {
                  //                                       SingleMenu? singleMenu;
                  //                                       List<SingleMenu>
                  //                                           filteredMenus = [];
                  //                                       if (_selectedCategoryIndex ==
                  //                                           0) {
                  //                                         for (MenuCategory category
                  //                                             in singleRestaurantsDetailsModel
                  //                                                 .data!
                  //                                                 .menuCategory!) {
                  //                                           filteredMenus.addAll(category
                  //                                               .singleMenu!
                  //                                               .where((menu) => menu
                  //                                                   .menu!.name
                  //                                                   .toLowerCase()
                  //                                                   .contains(
                  //                                                       _searchQuery
                  //                                                           .toLowerCase()))
                  //                                               .toList());
                  //                                         }
                  //                                       } else {
                  //                                         filteredMenus.addAll(singleRestaurantsDetailsModel
                  //                                             .data!
                  //                                             .menuCategory![
                  //                                                 _selectedCategoryIndex -
                  //                                                     1]
                  //                                             .singleMenu!
                  //                                             .where((menu) => menu
                  //                                                 .menu!.name
                  //                                                 .toLowerCase()
                  //                                                 .contains(
                  //                                                     _searchQuery
                  //                                                         .toLowerCase()))
                  //                                             .toList());
                  //                                       }
                  //                                       if (index <
                  //                                           filteredMenus
                  //                                               .length) {
                  //                                         singleMenu =
                  //                                             filteredMenus[
                  //                                                 index];
                  //                                       }
                  //                                       return singleMenu == null
                  //                                           ? SizedBox.shrink()
                  //                                           : GestureDetector(
                  //                                               onTap: () async {
                  //                                                 // TODO: && operator added
                  //                                                 final prefs =
                  //                                                     await SharedPreferences
                  //                                                         .getInstance();
                  //                                                 String
                  //                                                     vendorId =
                  //                                                     prefs.getString(Constants
                  //                                                             .vendorId
                  //                                                             .toString()) ??
                  //                                                         '';
                  //                                                 if (singleMenu!
                  //                                                             .menu!
                  //                                                             .price ==
                  //                                                         null ||
                  //                                                     singleMenu
                  //                                                         .menu!
                  //                                                         .menuAddon!
                  //                                                         .isNotEmpty) {
                  //                                                   List<MenuSize>
                  //                                                       tempList =
                  //                                                       [];
                  //                                                   tempList.addAll(
                  //                                                       singleMenu
                  //                                                           .menu!
                  //                                                           .menuSize!);
                  //                                                   if (singleMenu
                  //                                                           .menu!
                  //                                                           .price ==
                  //                                                       null) {
                  //                                                     List<MenuSize>
                  //                                                         menuSizeList =
                  //                                                         singleMenu
                  //                                                             .menu!
                  //                                                             .menuSize!;
                  //                                                     for (int menuSizeIndex =
                  //                                                             0;
                  //                                                         menuSizeIndex <
                  //                                                             menuSizeList.length;
                  //                                                         menuSizeIndex++) {
                  //                                                       List<MenuAddon>
                  //                                                           groupMenuAddon =
                  //                                                           menuSizeList[menuSizeIndex]
                  //                                                               .groupMenuAddon!;
                  //                                                       Set set =
                  //                                                           {};
                  //                                                       for (int groupMenuAddonIndex =
                  //                                                               0;
                  //                                                           groupMenuAddonIndex <
                  //                                                               groupMenuAddon.length;
                  //                                                           groupMenuAddonIndex++) {
                  //                                                         if (set.contains(
                  //                                                             groupMenuAddon[groupMenuAddonIndex].addonCategoryId)) {
                  //                                                           //duplicate
                  //                                                           groupMenuAddon[groupMenuAddonIndex].isDuplicate =
                  //                                                               true;
                  //                                                         } else {
                  //                                                           //unique
                  //                                                           set.add(
                  //                                                               groupMenuAddon[groupMenuAddonIndex].addonCategoryId);
                  //                                                         }
                  //                                                       }
                  //                                                     }
                  //                                                     showDialog(
                  //                                                         context:
                  //                                                             context,
                  //                                                         builder:
                  //                                                             (BuildContext
                  //                                                                 context) {
                  //                                                           return AlertDialog(
                  //                                                             contentPadding:
                  //                                                                 EdgeInsets.all(0.0),
                  //                                                             shape:
                  //                                                                 RoundedRectangleBorder(
                  //                                                               borderRadius: BorderRadius.all(
                  //                                                                 Radius.circular(20),
                  //                                                               ),
                  //                                                             ),
                  //                                                             clipBehavior:
                  //                                                                 Clip.antiAliasWithSaveLayer,
                  //                                                             content:
                  //                                                                 Builder(
                  //                                                               builder: (context) {
                  //                                                                 var height = MediaQuery.of(context).size.height;
                  //                                                                 var width = MediaQuery.of(context).size.width;
                  //                                                                 return Container(
                  //                                                                     height: height - 100,
                  //                                                                     width: width * 0.5,
                  //                                                                     child: AddonsWithSized(
                  //                                                                       menu: singleMenu!.menu!,
                  //                                                                       category: "SINGLE",
                  //                                                                       data: singleMenu.menu!.menuSize!,
                  //                                                                     ));
                  //                                                               },
                  //                                                             ),
                  //                                                           );
                  //                                                         });
                  //                                                   } else if (singleMenu
                  //                                                       .menu!
                  //                                                       .menuAddon!
                  //                                                       .isNotEmpty) {
                  //                                                     print(
                  //                                                         "ADDONS ONly ");
                  //                                                     showDialog(
                  //                                                         context:
                  //                                                             context,
                  //                                                         builder:
                  //                                                             (BuildContext
                  //                                                                 context) {
                  //                                                           return AlertDialog(
                  //                                                             contentPadding:
                  //                                                                 const EdgeInsets.all(0.0),
                  //                                                             shape:
                  //                                                                 const RoundedRectangleBorder(
                  //                                                               borderRadius: BorderRadius.all(
                  //                                                                 Radius.circular(20),
                  //                                                               ),
                  //                                                             ),
                  //                                                             clipBehavior:
                  //                                                                 Clip.antiAliasWithSaveLayer,
                  //                                                             content:
                  //                                                                 Builder(
                  //                                                               builder: (context) {
                  //                                                                 var height = MediaQuery.of(context).size.height;
                  //                                                                 var width = MediaQuery.of(context).size.width;
                  //                                                                 return Container(
                  //                                                                   height: height - 100,
                  //                                                                   width: width * 0.5,
                  //                                                                   child: AddonsOnly(
                  //                                                                     data: singleMenu!.menu!,
                  //                                                                     menuPrice: singleMenu.menu!.price!,
                  //                                                                     menuId: singleMenu.id,
                  //                                                                     category: "SINGLE",
                  //                                                                     vendor: singleRestaurantsDetailsModel.data!.vendor!,
                  //                                                                   ),
                  //                                                                 );
                  //                                                               },
                  //                                                             ),
                  //                                                           );
                  //                                                         });
                  //                                                   }
                  //                                                 } else {
                  //                                                   shiftController.cartController.addItem(
                  //                                                       cart.Cart(
                  //                                                           diningAmount: double.parse(singleMenu.menu!.diningPrice ?? '0.0'),
                  //                                                           category: "SINGLE",
                  //                                                           menu: [
                  //                                                             cart.MenuCartMaster(
                  //                                                               name: singleMenu.menu!.name,
                  //                                                               totalAmount: double.parse(singleMenu.menu!.price!),
                  //                                                               id: singleMenu.id,
                  //                                                               addons: [],
                  //                                                               image: singleMenu.menu!.image,
                  //                                                             )
                  //                                                           ],
                  //                                                           size: null,
                  //                                                           totalAmount: double.parse(singleMenu.menu!.price!),
                  //                                                           quantity: 1),
                  //                                                       int.parse(vendorId.toString()),
                  //                                                       context);
                  //                                                   shiftController.cartController
                  //                                                           .refreshScreen
                  //                                                           .value =
                  //                                                       toggleBoolValue(shiftController.cartController
                  //                                                           .refreshScreen
                  //                                                           .value);
                  //                                                 }
                  //                                                 // _addToCart(singleMenu!, index);
                  //                                               },
                  //                                               child: Container(
                  //                                                 // alignment: Alignment.center,
                  //                                                 margin:
                  //                                                     const EdgeInsets
                  //                                                             .only(
                  //                                                         left:
                  //                                                             8.0,
                  //                                                         right:
                  //                                                             8.0,
                  //                                                         bottom:
                  //                                                             8.0),
                  //                                                 decoration: const BoxDecoration(
                  //                                                     color: Colors
                  //                                                         .white,
                  //                                                     borderRadius:
                  //                                                         BorderRadius.all(
                  //                                                             Radius.circular(8))),
                  //                                                 child: Column(
                  //                                                   crossAxisAlignment:
                  //                                                       CrossAxisAlignment
                  //                                                           .center,
                  //                                                   mainAxisAlignment:
                  //                                                       MainAxisAlignment
                  //                                                           .center,
                  //                                                   children: [
                  //                                                     Container(
                  //                                                       height:
                  //                                                           100,
                  //                                                       width:
                  //                                                           100,
                  //                                                       // margin: EdgeInsets.only(left: 5.0),
                  //                                                       // decoration: ,
                  //                                                       decoration:
                  //                                                           BoxDecoration(
                  //                                                         image: DecorationImage(
                  //                                                             image:
                  //                                                                 CachedNetworkImageProvider(singleMenu!.menu!.image),
                  //                                                             fit: BoxFit.fill),
                  //                                                         borderRadius:
                  //                                                             BorderRadius.circular(12.0),
                  //                                                       ),
                  //                                                     ),
                  //                                                     Text(
                  //                                                       singleMenu
                  //                                                           .menu!
                  //                                                           .name,
                  //                                                       textAlign:
                  //                                                           TextAlign
                  //                                                               .center,
                  //                                                       maxLines:
                  //                                                           2,
                  //                                                       style:
                  //                                                           TextStyle(
                  //                                                         overflow:
                  //                                                             TextOverflow.ellipsis,
                  //                                                         fontFamily:
                  //                                                             "ProximaBold",
                  //                                                         color: Color(
                  //                                                             Constants.colorTheme),
                  //                                                         fontSize:
                  //                                                             17,
                  //                                                       ),
                  //                                                     ),
                  //                                                     Text(
                  //                                                       "Normal ${singleMenu.menu!.price}" ??
                  //                                                           "Price In Addons",
                  //                                                       overflow:
                  //                                                           TextOverflow
                  //                                                               .ellipsis,
                  //                                                       maxLines:
                  //                                                           1,
                  //                                                       style:
                  //                                                           const TextStyle(
                  //                                                         fontWeight:
                  //                                                             FontWeight.w500,
                  //                                                         color: Colors
                  //                                                             .red,
                  //                                                         fontSize:
                  //                                                             14,
                  //                                                         overflow:
                  //                                                             TextOverflow.ellipsis,
                  //                                                       ),
                  //                                                     ),
                  //                                                     Text(
                  //                                                       "Dining ${singleMenu.menu!.diningPrice}" ??
                  //                                                           "0.0",
                  //                                                       overflow:
                  //                                                           TextOverflow
                  //                                                               .ellipsis,
                  //                                                       maxLines:
                  //                                                           1,
                  //                                                       style:
                  //                                                           const TextStyle(
                  //                                                         fontWeight:
                  //                                                             FontWeight.w500,
                  //                                                         color: Colors
                  //                                                             .red,
                  //                                                         fontSize:
                  //                                                             14,
                  //                                                         overflow:
                  //                                                             TextOverflow.ellipsis,
                  //                                                       ),
                  //                                                     ),
                  //                                                     const SizedBox(
                  //                                                       height: 5,
                  //                                                     )
                  //                                                   ],
                  //                                                 ),
                  //                                               ),
                  //                                             );
                  //                                     },
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           SizedBox(width: 5),
                  //                           Container(
                  //                             margin: EdgeInsets.only(top: 5),
                  //                             decoration: BoxDecoration(
                  //                                 color: Colors.white,
                  //                                 borderRadius: BorderRadius.all(
                  //                                     Radius.circular(8))),
                  //                             width: Get.width * 0.25,
                  //                             child: Obx(() {
                  //                               if (shiftController.cartController
                  //                                       .refreshScreen.value ||
                  //                                   !shiftController.cartController
                  //                                       .refreshScreen.value) {
                  //                                 return CartScreen(
                  //                                     isDining: shiftController.cartController.diningValue);
                  //                               } else {
                  //                                 return Container();
                  //                               }
                  //                             }),
                  //                           )
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 Positioned(
                  //                   left: 35,
                  //                   top: Get.height * 0.07,
                  //                   child: CircleAvatar(
                  //                       radius: 36,
                  //                       backgroundImage:
                  //                           Image.network(vendor.image).image),
                  //                 ),
                  //               ],
                  //             );
                  //           } else {
                  //             return Text('Success is not true');
                  //           }
                  //         } else if (snapshot.hasError) {
                  //           return Text(snapshot.error.toString());
                  //         } else {
                  //           return Center(
                  //             child: CircularProgressIndicator(
                  //                 color: Color(Constants.colorTheme)),
                  //           );
                  //         }
                  //       },
                  //     ),
                  //   );
                  // }
                  else {
                    return FutureBuilder<
                            BaseModel<SingleRestaurantsDetailsModel>>(
                        future: _orderCustimizationController
                            .callGetRestaurantsDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            SingleRestaurantsDetailsModel
                                singleRestaurantsDetailsModel =
                                snapshot.data!.data!;
                            // singleRestaurantsDetailsModel.data.menuCategory.
                            if (singleRestaurantsDetailsModel.success) {
                              Vendor vendor =
                                  singleRestaurantsDetailsModel.data!.vendor!;
                              List vendorNameList = vendor.name.split(' ');
                              List<MenuCategory> _menuCategories =
                                  singleRestaurantsDetailsModel
                                      .data!.menuCategory!;
                              return VendorMenu(
                                updateDiningValue: updateDiningValue,
                                vendorId: int.parse(vendorIdMain.toString()),
                                isDininig: shiftController.cartController.diningValue,
                              );
                            }
                          }
                          return SpinKitFadingCircle(
                            color: Color(Constants.colorTheme),
                          );
                        });
                  }
                },
              ),
      ),
    );
  }

  getMenu(
      SingleRestaurantsDetailsModel singleRestaurantsDetailsModel,
      int selectedMenuCategoryIndex,
      List<SingleMenu> singleList,
      List<HalfNHalfMenu> halfList,
      List<DealsMenu> dealsList) {
    MenuCategory menuCategory = singleRestaurantsDetailsModel
        .data!.menuCategory![selectedMenuCategoryIndex];
    String menuCategoryType = menuCategory.type;

    if (menuCategoryType == 'SINGLE') {
      print("Single");
      return Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          // scrollDirection: Axis.vertical,
          // physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisExtent: Get.height * 0.25,
          ),
          itemCount: menuCategory.singleMenu!.length,
          // itemCount: singleList.length,
          itemBuilder: (BuildContext context, int singleMenuIndex) {
            Menu singleMenu = menuCategory.singleMenu![singleMenuIndex].menu!;

            // Menu singleMenu = singleList[singleMenuIndex].menu!;
            return GestureDetector(
              onTap: () async {
                // TODO: && operator added
                final prefs = await SharedPreferences.getInstance();
                String vendorId =
                    prefs.getString(Constants.vendorId.toString()) ?? '';

                if (singleMenu.price == null ||
                    singleMenu.menuAddon!.isNotEmpty) {
                  List<MenuSize> tempList = [];
                  tempList.addAll(singleMenu.menuSize!);
                  if (singleMenu.price == null) {
                    List<MenuSize> menuSizeList = singleMenu.menuSize!;
                    for (int menuSizeIndex = 0;
                        menuSizeIndex < menuSizeList.length;
                        menuSizeIndex++) {
                      List<MenuAddon> groupMenuAddon =
                          menuSizeList[menuSizeIndex].groupMenuAddon!;
                      Set set = {};
                      for (int groupMenuAddonIndex = 0;
                          groupMenuAddonIndex < groupMenuAddon.length;
                          groupMenuAddonIndex++) {
                        if (set.contains(groupMenuAddon[groupMenuAddonIndex]
                            .addonCategoryId)) {
                          //duplicate
                          groupMenuAddon[groupMenuAddonIndex].isDuplicate =
                              true;
                        } else {
                          //unique
                          set.add(groupMenuAddon[groupMenuAddonIndex]
                              .addonCategoryId);
                        }
                      }
                    }
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.all(0.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            content: Builder(
                              builder: (context) {
                                var height = MediaQuery.of(context).size.height;
                                var width = MediaQuery.of(context).size.width;
                                return Container(
                                    height: height - 100,
                                    width: width * 0.5,
                                    child: AddonsWithSized(
                                      menu: singleMenu,
                                      category: menuCategoryType,
                                      data: singleMenu.menuSize!,
                                    ));
                              },
                            ),
                          );
                        });
                  } else if (singleMenu.menuAddon!.isNotEmpty) {
                    print("ADDONS ONly ");
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.all(0.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            content: Builder(
                              builder: (context) {
                                var height = MediaQuery.of(context).size.height;
                                var width = MediaQuery.of(context).size.width;
                                return Container(
                                  height: height - 100,
                                  width: width * 0.5,
                                  child: AddonsOnly(
                                    data: singleMenu,
                                    menuPrice: singleMenu.price!,
                                    menuId: singleMenu.id,
                                    category: menuCategoryType,
                                    vendor: singleRestaurantsDetailsModel
                                        .data!.vendor!,
                                  ),
                                );
                              },
                            ),
                          );
                        });
                  }
                } else {
                  shiftController.cartController.addItem(
                      cart.Cart(
                          diningAmount:
                              double.parse(singleMenu.diningPrice ?? '0.0'),
                          category: menuCategoryType,
                          menu: [
                            cart.MenuCartMaster(
                              name: singleMenu.name,
                              totalAmount: double.parse(singleMenu.price!),
                              id: singleMenu.id,
                              addons: [],
                              modifiers: [],
                              image: singleMenu.image,
                            )
                          ],
                          size: null,
                          totalAmount: double.parse(singleMenu.price!),
                          quantity: 1),
                      int.parse(vendorId.toString()),
                      context);
                  shiftController.cartController.refreshScreen.value =
                      toggleBoolValue(shiftController.cartController.refreshScreen.value);
                }
              },
              child: Container(
                // alignment: Alignment.center,
                margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      // margin: EdgeInsets.only(left: 5.0),
                      // decoration: ,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(singleMenu.image),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    Text(
                      singleMenu.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontFamily: "ProximaBold",
                        color: Color(Constants.colorTheme),
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      "Normal ${singleMenu.price}" ?? "Price In Addons",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "Dining ${singleMenu.diningPrice}" ?? "0.0",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else if (menuCategoryType == 'HALF_N_HALF') {
      print("HALF_N_HALF");
      return Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          // physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, mainAxisExtent: Get.height * 0.22),
          itemCount: menuCategory.halfNHalfMenu!.length,
          // itemCount: halfList.length,
          itemBuilder: (BuildContext context, int halfMenuIndex) {
            HalfNHalfMenu halfNHalfMenu =
                menuCategory.halfNHalfMenu![halfMenuIndex];
            // HalfNHalfMenu halfNHalfMenu=halfList[halfMenuIndex];
            return GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        content: Builder(
                          builder: (context) {
                            var height = MediaQuery.of(context).size.height;
                            var width = MediaQuery.of(context).size.width;
                            return Container(
                              height: height - 100,
                              width: width * 0.5,
                              child: HalfNHalf(
                                category: menuCategoryType,
                                vendorId: int.parse(vendorIdMain.toString()),
                                halfNHalfMenu: halfNHalfMenu,
                              ),
                            );
                          },
                        ),
                      );
                    });
              },
              child: Padding(
                  padding: EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        // margin: EdgeInsets.only(left: 5.0),
                        // decoration: ,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  halfNHalfMenu.image),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      Text(
                        halfNHalfMenu.name,
                        maxLines: 2,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontFamily: "ProximaBold",
                          color: Color(Constants.colorTheme),
                          fontSize: 17,
                        ),
                      ),
                      // Text(halfNHalfMenu.description,
                      //   maxLines: 2,
                      //   style: TextStyle(
                      //     color: Colors.grey[600],
                      //     fontSize: 14,
                      //     overflow: TextOverflow.fade,
                      //   ),),
                    ],
                  )),
            );
          },
        ),
      );
    } else if (menuCategoryType == 'DEALS') {
      print("DEALS");
      return Expanded(
        child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            // physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisExtent: Get.height * 0.22,
            ),
            // itemCount: dealsList.length,
            itemCount: menuCategory.dealsMenu!.length,
            itemBuilder: (BuildContext context, int dealMenuIndex) {
              DealsMenu dealsMenu = menuCategory.dealsMenu![dealMenuIndex];
              // DealsMenu dealsMenu=dealsList[dealMenuIndex];
              return GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          content: Builder(
                            builder: (context) {
                              var height = MediaQuery.of(context).size.height;
                              var width = MediaQuery.of(context).size.width;
                              return SizedBox(
                                height: height - 100,
                                width: width * 0.5,
                                child: dealsItems.DealsItems(
                                  dealsItemList: dealsMenu.dealsItems!,
                                  dealsMenu: dealsMenu,
                                  category: menuCategoryType,
                                ),
                              );
                            },
                          ),
                        );
                      });
                },
                child: Padding(
                    padding: EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    CachedNetworkImageProvider(dealsMenu.image),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        Text(
                          dealsMenu.name,
                          maxLines: 2,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontFamily: "ProximaBold",
                            color: Color(Constants.colorTheme),
                            fontSize: 17,
                          ),
                        ),
                        // Text(dealsMenu.description,
                        //   maxLines: 2,
                        //   style: TextStyle(
                        //     color: Colors.grey[600],
                        //     fontSize: 14,
                        //     overflow: TextOverflow.fade,
                        //   ),),
                        Text(
                          dealsMenu.price ?? "Price In Addons",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          dealsMenu.dealsDiningPrice ?? "0.0",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )),
              );
            }),
      );
    }
  }

  bool toggleBoolValue(bool value) {
    if (value) {
      return false;
    } else {
      return true;
    }
  }
}
