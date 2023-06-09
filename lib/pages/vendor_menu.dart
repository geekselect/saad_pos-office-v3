import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pos/config/screen_config.dart';
import 'package:pos/controller/cart_controller.dart';
import 'package:pos/controller/dining_cart_controller.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/controller/shift_controller.dart';
import 'package:pos/model/cart_master.dart' as cm;
import 'package:pos/model/single_restaurants_details_model.dart';
import 'package:pos/pages/OrderHistory/order_history.dart';
import 'package:pos/pages/Reports/report_screen.dart';
import 'package:pos/pages/ReportsByDate/reports_by_date_screen.dart';
import 'package:pos/pages/cart_screen.dart';
import 'package:pos/pages/selection_screen.dart';
import 'package:pos/pages/vendor_item_categories.dart';
import 'package:pos/printer/printer_config.dart';
import 'package:pos/utils/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/book_table_model.dart';
import '../model/booked_order_model.dart';
import '../retrofit/api_client.dart';
import '../retrofit/api_header.dart';
import '../retrofit/base_model.dart';
import 'addons/Half_n_half.dart';
import 'addons/addons_only.dart';
import 'addons/addons_with_sizes.dart';
import 'addons/deals_items.dart' as dealsItems;

import 'addons/no_addons.dart';

class VendorMenu extends StatefulWidget {
  final int vendorId;
  final bool isDininig;
  final Function(bool) updateDiningValue;
  const VendorMenu({Key? key, required this.vendorId, required this.isDininig, required this.updateDiningValue})
      : super(key: key);

  @override
  _VendorMenuState createState() => _VendorMenuState();
}

class _VendorMenuState extends State<VendorMenu>
    with SingleTickerProviderStateMixin {
  final ShiftController shiftController = Get.put(ShiftController());
  final DiningCartController _diningCartController= Get.find<DiningCartController>();
  OrderCustimizationController _orderCustimizationController =
      Get.find<OrderCustimizationController>();
  TabController? _tabController;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  CartController _cartController = Get.find<CartController>();

  String _searchQuery = '';

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget circleWidget(IconData icon, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Material(
          color: Color(Constants.colorTheme),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  bool enable = true;

  int _selectedCategoryIndex = 0;

  int getmenuItem(List<MenuCategory> _menuCategories) {
    print(_menuCategories.length);
    int total = 0;
    for (int i = 0; i < _menuCategories.length; i++) {
      for (int j = 0; j < _menuCategories[i].singleMenu!.length; j++) {
        print(_menuCategories[i].singleMenu![j].menu!.name);
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
  }

  @override
  void initState() {

    _tabController = TabController(
        length:
            _orderCustimizationController.response!.data!.menuCategory!.length,
        vsync: this);

    ///Set State Error
    // if (_cartController.cartMaster != null) {
    //   _cartController.cartTotalQuantity.value = 0;
    //   for (cm.Cart cart in _cartController.cartMaster!.cart) {
    //     _cartController.cartTotalQuantity.value += cart.quantity;
    //   }
    // }
    super.initState();
  }

  Future<BookTableModel> getBookTable() async {
    final prefs = await SharedPreferences.getInstance();

    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    return await RestClient(await RetroApi().dioData())
        .getTables(int.parse(vendorId.toString()));
  }

  // List<Widget> getCategoriesItemList(int index) {
  //   List<SingleMenu> menuItems = _orderCustimizationController
  //       .response!.data!.menuCategory![index].singleMenu!;
  //
  //   if (_searchQuery.isNotEmpty) {
  //     menuItems = menuItems.where((item) => item.menu!.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  //   }
  //
  //   return menuItems.map((menu) => YourWidget(menu)).toList();
  // }

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

  @override
  Widget build(BuildContext context) {

    itemPositionsListener.itemPositions.addListener(() {
      _tabController!.animateTo(
          itemPositionsListener.itemPositions.value.first.index,
          duration: Duration(seconds: 0));
    });
    ScreenConfig().init(context);
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 650) {
          return Row(
            children: [
              SizedBox(
                width: Get.width * 0.7,
                child: Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                      color: Color(Constants.colorScreenBackGround),
                      image: DecorationImage(
                        image: AssetImage('images/ic_background_image.png'),
                        fit: BoxFit.cover,
                      )),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: ScreenConfig.screenWidth,
                            height: 100,
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5.0),
                                  width: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            _orderCustimizationController
                                                .response!.data!.vendor!.image,
                                            headers: {
                                              "Access-Control-Allow-Origin":
                                                  "*",
                                            }),
                                        fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _orderCustimizationController
                                              .response!.data!.vendor!.name,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "CinzelBold"),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height:
                                              ScreenConfig.blockHeight * 0.5,
                                        ),
                                        Text(
                                          _orderCustimizationController
                                              .response!
                                              .data!
                                              .vendor!
                                              .mapAddress,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        ),
                                        Row(
                                          children: [
                                            RatingBar.builder(
                                              initialRating:
                                                  _orderCustimizationController
                                                      .response!
                                                      .data!
                                                      .vendor!
                                                      .rate
                                                      .toDouble(),
                                              ignoreGestures: true,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              itemSize: 20,
                                              allowHalfRating: true,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (double rating) {
                                                print(rating);
                                              },
                                            ),
                                            Text(
                                              '(${_orderCustimizationController.response!.data!.vendor!.review})',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: Constants.appFont,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TabBar(
                            padding: EdgeInsets.all(8.0),
                            labelColor: Colors.red,
                            labelStyle: TextStyle(
                              fontFamily: "ProximaBold",
                              fontSize: 30,
                              color: Colors.red,
                            ),
                            indicatorColor: Colors.transparent,
                            controller: _tabController,
                            unselectedLabelColor: Colors.black,
                            isScrollable: true,
                            tabs: List.generate(
                              _orderCustimizationController
                                  .response!.data!.menuCategory!.length,
                              (index) => Text(
                                _orderCustimizationController
                                    .response!.data!.menuCategory![index].name,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            onTap: (i) {
                              itemScrollController.scrollTo(
                                  index: i,
                                  duration: Duration(milliseconds: 500));
                            },
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: ScrollablePositionedList.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: _orderCustimizationController
                                  .response!.data!.menuCategory!.length,
                              itemBuilder: (context, index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: ScreenConfig.blockHeight,
                                  ),
                                  Text(
                                    _orderCustimizationController.response!
                                        .data!.menuCategory![index].name,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "ProximaBold",
                                        fontSize:
                                            ScreenConfig.blockHeight * 2.5),
                                  ),
                                  SizedBox(
                                    height: ScreenConfig.blockHeight,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Column(
                                      children: getCategoriesItemList(index),
                                    ),
                                  ),
                                ],
                              ),
                              itemScrollController: itemScrollController,
                              itemPositionsListener: itemPositionsListener,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                          top: 50.0,
                          right: 40,
                          child: Container(
                            margin: EdgeInsets.only(left: 16.0),
                            child: ClipOval(
                              child: Material(
                                color: Color(Constants.colorTheme),
                                // Button color
                                child: GestureDetector(
                                  //splashColor: Color(Constants.colorTheme), // Splash color
                                  onTap: () {
                                    Get.to(() => CartScreen(
                                      updateDiningValue: widget.updateDiningValue,
                                          isDining: widget.isDininig,
                                        ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      CupertinoIcons.shopping_cart,
                                      color: Colors.white,
                                      size: Get.width * 0.02,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Positioned(
                        top: 40.0,
                        right: 42,
                        child: ClipOval(
                          child: Material(
                            color: Color(Constants.colorTheme),
                            // Button color
                            child: GestureDetector(
                              onTap: () {},
                              child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Obx(() => Text(
                                        _cartController.cartTotalQuantity
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Get.width * 0.01,
                                        ),
                                      ))),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40.0,
                        right: 0,
                        child: PopupMenuButton<int>(
                            icon: Icon(
                              Icons.adaptive.more,
                              color: Colors.white,
                            ),
                            onSelected: (item) => onSelected(context, item),
                            itemBuilder: (context) => [
                                  PopupMenuItem<int>(
                                      value: 0, child: Text('Categories')),
                                ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: Get.width * 0.3,
                child: Obx(() {
                  if (_cartController.refreshScreen.value ||
                      !_cartController.refreshScreen.value) {
                    return CartScreen(
                        updateDiningValue: widget.updateDiningValue,
                        isDining: widget.isDininig);
                  } else {
                    return Container();
                  }
                }),
              )
            ],
          );
        } else {
          // return Container(
          //   constraints: const BoxConstraints.expand(),
          //   decoration: BoxDecoration(
          //       color: Color(Constants.colorScreenBackGround),
          //       image: DecorationImage(
          //         image: AssetImage('images/ic_background_image.png'),
          //         fit: BoxFit.cover,
          //       )),
          //   child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //
          //           SizedBox(
          //             // height: ScreenConfig.blockHeight * 0.5,
          //             height: 30,
          //           ),
          //           TextField(
          //             style: TextStyle(color: Colors.red),
          //             onChanged: (value) {
          //               setState(() {
          //                 _searchQuery = value;
          //               });
          //             },
          //             decoration: const InputDecoration(
          //                 labelText: 'Search',
          //                 labelStyle:
          //                 TextStyle(color: Colors.red)
          //               // border: OutlineInputBorder(),
          //             ),
          //           ),
          //           // TabBar(
          //           //   padding: EdgeInsets.all(8.0),
          //           //   labelColor: Colors.red,
          //           //   labelStyle: TextStyle(
          //           //     fontFamily: "ProximaBold",
          //           //     fontSize: 30,
          //           //     color: Colors.red,
          //           //   ),
          //           //   indicatorColor: Colors.transparent,
          //           //   controller: _tabController,
          //           //   unselectedLabelColor: Colors.black,
          //           //   isScrollable: true,
          //           //   tabs: List.generate(
          //           //     _orderCustimizationController
          //           //         .response!.data!.menuCategory!.length,
          //           //     (index) => Text(
          //           //       _orderCustimizationController
          //           //           .response!.data!.menuCategory![index].name,
          //           //       style: TextStyle(fontSize: 16),
          //           //     ),
          //           //   ),
          //           //   onTap: (i) {
          //           //     itemScrollController.scrollTo(
          //           //         index: i, duration: Duration(milliseconds: 500));
          //           //   },
          //           // ),
          //
          //         ],
          //       ),
          //
          //
          // );
          print("dining value before dining vendor ${_cartController.diningValue}");
          return Column(
            children: [
              Container(
                margin: EdgeInsets.all(5.0),
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          _orderCustimizationController
                              .response!.data!.vendor!.image),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
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
                                        .black),
                              ),
                              SizedBox(width: 5),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(Constants.colorTheme), // Background color
                                  ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                _cartController.diningValue
                                    ? 'Dine in'
                                    : 'Take Away',
                              ),
                              Switch(
                                onChanged: (bool? value) async {
                                  if (value!) {
                                    await showDialog<int>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: Center(
                                                  child: Text(
                                                      'Available table no')),
                                              content: SizedBox(
                                                height: Get.height * 0.4,
                                                width: Get.width * 0.5,
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: FutureBuilder<
                                                              BookTableModel>(
                                                          future:
                                                              getBookTable(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasError) {
                                                              return Center(
                                                                child: Text(snapshot
                                                                    .error
                                                                    .toString()),
                                                              );
                                                            } else if (snapshot
                                                                .hasData) {
                                                              return GridView
                                                                  .builder(
                                                                itemCount: snapshot
                                                                        .data
                                                                        ?.data
                                                                        .bookedTable
                                                                        .length ??
                                                                    0,
                                                                itemBuilder:
                                                                    (builder,
                                                                        index) {
                                                                  return GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                          final prefs = await SharedPreferences.getInstance();
                                                                          String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
                                                                      _cartController.tableNumber = snapshot
                                                                          .data!
                                                                          .data
                                                                          .bookedTable[
                                                                              index]
                                                                          .bookedTableNumber;
                                                                      if (snapshot
                                                                              .data!
                                                                              .data
                                                                              .bookedTable[index]
                                                                              .status ==
                                                                          1) {
                                                                        Map<String,
                                                                                dynamic>
                                                                            param =
                                                                            {
                                                                          'vendor_id':int.parse(vendorId.toString()),
                                                                          'booked_table_number': snapshot
                                                                              .data!
                                                                              .data
                                                                              .bookedTable[index]
                                                                              .bookedTableNumber,
                                                                        };
                                                                        BaseModel<BookedOrderModel>
                                                                            baseModel =
                                                                            await _cartController.getBookedTableData(param,
                                                                                context);
                                                                        BookedOrderModel
                                                                            bookOrderModel =
                                                                            baseModel.data!;
                                                                        if (bookOrderModel
                                                                            .success!) {
                                                                          print(
                                                                              'order');
                                                                          print(bookOrderModel
                                                                              .data!
                                                                              .orderId);
                                                                          _cartController.cartMaster = cm.CartMaster.fromMap(jsonDecode(bookOrderModel
                                                                              .data!
                                                                              .orderData!));
                                                                          _cartController
                                                                              .cartMaster
                                                                              ?.oldOrderId = bookOrderModel.data!.orderId;
                                                                          Navigator.pop(
                                                                              context);
                                                                        } else {
                                                                          print(
                                                                              baseModel.error);
                                                                        }
                                                                      } else {
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              18),
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Positioned(
                                                                            child:
                                                                                Container(
                                                                              padding: EdgeInsets.all(40.0),
                                                                              decoration: BoxDecoration(color: snapshot.data!.data.bookedTable[index].status == 1 ? Color(Constants.colorTheme) : Colors.green, shape: BoxShape.circle),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child:
                                                                                Text(
                                                                              snapshot.data!.data.bookedTable[index].bookedTableNumber.toString(),
                                                                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                gridDelegate:
                                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount:
                                                                      Get.width >
                                                                              1200
                                                                          ? 8
                                                                          : 3,
                                                                  mainAxisExtent:
                                                                      80,
                                                                ),
                                                              );
                                                            }
                                                            return Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                              color: Color(
                                                                  Constants
                                                                      .colorTheme),
                                                            ));
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                    setState(() {
                                      // _cartController.tableNumber!=null?selectMethod=DeliveryMethod.TAKEAWAY:null;
                                      _cartController.diningValue =
                                          _cartController.tableNumber != null
                                              ? true
                                              : false;
                                      _cartController.isPromocodeApplied =
                                          false;
                                    });
                                  } else {
                                    setState(() {
                                      _cartController.tableNumber = null;
                                      _cartController.diningValue = false;
                                    });
                                  }
                                },
                                value: _cartController.diningValue,
                                activeColor: Colors.red,
                                activeTrackColor: Colors.red,
                                inactiveThumbColor: Colors.red,
                                inactiveTrackColor: Colors.white,
                              ),
                            ],
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(Constants.colorTheme), // Background color
                              ),
                              onPressed: () {
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
                                      content: SingleChildScrollView(
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
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Color(Constants.colorTheme), // Background color
                                                    ),
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
                                                      Expanded(
                                                        child: IntrinsicWidth(
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
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Align(
                                                        alignment: Alignment.bottomCenter,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                          backgroundColor: Color(Constants.colorTheme), // Background color
                                                          ),
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
                                                          shiftController.timerController.stopTimer();
                                                          print("Timer Send");
                                                          shiftController
                                                              .selectShiftDetails(context,
                                                              shiftController
                                                                  .shiftsList[index]
                                                                  .shiftCode,
                                                              shiftController
                                                                  .shiftsList[index]
                                                                  .shiftName,
                                                              shiftController
                                                                  .timerController
                                                                  .elapsedTime);
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
                          }, child: Text("Create Shift")),
                          Text(
                            _orderCustimizationController
                                .response!.data!.vendor!.name,
                            style: TextStyle(
                                fontSize: 20, fontFamily: "CinzelBold"),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenConfig.blockHeight * 0.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          circleWidget(Icons.card_travel, () {
                            Get.to(() => OrderHistory());
                          }),
                          circleWidget(Icons.print, () {
                            Get.to(() => PrinterConfig());
                          }),
                          circleWidget(
                            Icons.table_bar,
                            () async {
                              bool value = true;
                              if (value) {
                                await Get.dialog(AlertDialog(
                                  title:
                                      Center(child: Text('Available table no')),
                                  content: SizedBox(
                                    height: Get.height * 0.4,
                                    width: Get.width * 0.5,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: FutureBuilder<BookTableModel>(
                                              future: getBookTable(),
                                              builder: (context, snapshot) {
                                                // print("response get book table ${snapshot.data.data}")
                                                if (snapshot.hasError) {
                                                  return Center(
                                                    child: Text(snapshot.error
                                                        .toString()),
                                                  );
                                                } else if (snapshot.hasData) {
                                                  return GridView.builder(
                                                    itemCount: snapshot
                                                            .data
                                                            ?.data
                                                            .bookedTable
                                                            .length ??
                                                        0,
                                                    itemBuilder:
                                                        (builder, index) {
                                                      return GestureDetector(
                                                        onTap: () async {
                                                          final prefs = await SharedPreferences.getInstance();
                                                          String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
                                                          _cartController
                                                                  .tableNumber =
                                                              snapshot
                                                                  .data!
                                                                  .data
                                                                  .bookedTable[
                                                                      index]
                                                                  .bookedTableNumber;
                                                          if (snapshot
                                                                  .data!
                                                                  .data
                                                                  .bookedTable[
                                                                      index]
                                                                  .status ==
                                                              1) {
                                                            Map<String, dynamic>
                                                                param = {
                                                              'vendor_id':int.parse(vendorId.toString()),
                                                              'booked_table_number':
                                                                  snapshot
                                                                      .data!
                                                                      .data
                                                                      .bookedTable[
                                                                          index]
                                                                      .bookedTableNumber,
                                                            };
                                                            BaseModel<
                                                                    BookedOrderModel>
                                                                baseModel =
                                                                await _cartController
                                                                    .getBookedTableData(
                                                                        param,
                                                                        context);
                                                            BookedOrderModel
                                                                bookOrderModel =
                                                                baseModel.data!;
                                                            if (bookOrderModel
                                                                .success!) {
                                                              print('order');
                                                              print(
                                                                  bookOrderModel
                                                                      .data!
                                                                      .orderId);
                                                              print(
                                                                  "****************");
                                                              if (bookOrderModel
                                                                      .data!
                                                                      .userName !=
                                                                  null) {
                                                                _diningCartController
                                                                        .diningUserName =
                                                                    bookOrderModel
                                                                        .data!
                                                                        .userName!;
                                                              }
                                                              print(
                                                                  bookOrderModel
                                                                      .data!
                                                                      .userName);
                                                              print(
                                                                  "****************");

                                                              print(
                                                                  "----------------");
                                                              if (bookOrderModel
                                                                      .data!
                                                                      .mobile !=
                                                                  null) {
                                                                _diningCartController.diningUserMobileNumber =
                                                                    bookOrderModel
                                                                        .data!
                                                                        .mobile!;
                                                              }

                                                              print(
                                                                  bookOrderModel
                                                                      .data!
                                                                      .mobile);
                                                              print(
                                                                  "----------------");

                                                              _cartController
                                                                  .cartMaster = cm
                                                                      .CartMaster
                                                                  .fromMap(jsonDecode(
                                                                      bookOrderModel
                                                                          .data!
                                                                          .orderData!));
                                                              _cartController
                                                                      .cartMaster
                                                                      ?.oldOrderId =
                                                                  bookOrderModel
                                                                      .data!
                                                                      .orderId;
                                                              Navigator.pop(
                                                                  context);
                                                            } else {
                                                              print(baseModel
                                                                  .error);
                                                            }
                                                          } else {
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 18),
                                                          child: Stack(
                                                            children: [
                                                              Positioned(
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              40.0),
                                                                  decoration: BoxDecoration(
                                                                      color: snapshot.data!.data.bookedTable[index].status ==
                                                                              1
                                                                          ? Color(Constants
                                                                              .colorTheme)
                                                                          : Colors
                                                                              .green,
                                                                      shape: BoxShape
                                                                          .circle),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  snapshot
                                                                      .data!
                                                                      .data
                                                                      .bookedTable[
                                                                          index]
                                                                      .bookedTableNumber
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount:
                                                          kIsWeb ? 8 : 3,
                                                      mainAxisExtent: 80,
                                                    ),
                                                  );
                                                }
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: Color(
                                                      Constants.colorTheme),
                                                ));
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                                setState(() {
                                  // _cartController.tableNumber!=null?selectMethod=DeliveryMethod.TAKEAWAY:null;
                                  _cartController.diningValue =
                                      _cartController.tableNumber != null
                                          ? true
                                          : false;
                                  _cartController.isPromocodeApplied = false;
                                });
                              } else {
                                setState(() {
                                  _cartController.tableNumber = null;
                                  _cartController.diningValue = false;
                                });
                              }
                            },
                          ),
                          circleWidget(Icons.report, () {
                            Get.to(() => Reports());
                          }),
                          circleWidget(Icons.report_gmailerrorred, () {
                            Get.to(() => ReportsByDate());
                          }),
                          circleWidget(Icons.logout, () async {
                            SharedPreferences sharedPrefs =
                                await SharedPreferences.getInstance();
                            sharedPrefs.remove(Constants.isLoggedIn);
                            Get.offAll(() => SelectionScreen());
                          }),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => CartScreen(
                                updateDiningValue: widget.updateDiningValue,
                                    isDining: _cartController.diningValue,
                                  ));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  child: ClipOval(
                                    child: Material(
                                      color: Color(Constants.colorTheme),
                                      // Button color
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Icon(
                                          CupertinoIcons.shopping_cart,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                   Positioned(
                                    right: 5,
                                    child: ClipOval(
                                      child: Material(
                                        color: Color(Constants.colorTheme),
                                        // Button color
                                        child: GestureDetector(
                                            onTap: () {},
                                            child: Padding(
                                                padding: const EdgeInsets.all(
                                                    2.0),
                                                child:  Obx(() => Text(
                                                      _cartController.cartTotalQuantity.value != 0 ? _cartController.cartMaster!
                                                        .cart.length.toString() : '0',
                                                    // _cartController
                                                    //     .cartTotalQuantity
                                                    //     .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    )
                                                ),
                                                )),
                                      ),
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenConfig.blockHeight * 0.9,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            enable = true;
                          });
                          print("lmn");
                        },
                        child: TextFormField(
                          // // Disable the text field by default
                          enabled: enable,
                          // // When the user taps on the text field, enable it and show the keyboard
                          style: TextStyle(color: Colors.red),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          textInputAction: TextInputAction.none,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              // border: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //         color: Colors.red
                              //     )
                              // ),
                              labelText: 'Search',
                              labelStyle: TextStyle(color: Colors.red)
                              // border: OutlineInputBorder(),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TabBar(
                padding: EdgeInsets.all(8.0),
                labelColor: Colors.red,
                labelStyle: TextStyle(
                  fontFamily: "ProximaBold",
                  fontSize: 30,
                  color: Colors.red,
                ),
                indicatorColor: Colors.transparent,
                controller: _tabController,
                unselectedLabelColor: Colors.black,
                isScrollable: true,
                tabs: List.generate(
                  _orderCustimizationController
                      .response!.data!.menuCategory!.length,
                  (index) => Text(
                    _orderCustimizationController
                        .response!.data!.menuCategory![index].name,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                onTap: (i) {
                  itemScrollController.scrollTo(
                      index: i, duration: Duration(milliseconds: 500));
                },
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ScrollablePositionedList.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _orderCustimizationController
                      .response!.data!.menuCategory!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _searchQuery.isEmpty
                            ? SizedBox(
                                height: ScreenConfig.blockHeight,
                              )
                            : SizedBox(),
                        _searchQuery.isEmpty
                            ? Text(
                                _orderCustimizationController
                                    .response!.data!.menuCategory![index].name,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "ProximaBold",
                                    fontSize: ScreenConfig.blockHeight * 2.5),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: ScreenConfig.blockHeight,
                        ),
                        WillPopScope(
                          onWillPop: () async {
                            // Navigate to the previous screen instead of removing this screen
                            // Navigator.of(context).pop();
                            return false;
                          },
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Column(
                              children: getCategoriesItemList(index),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                ),
              ),
            ],
          );
          // child: Stack(
          // children: [
          // Column(
          // mainAxisSize: MainAxisSize.min,
          // children: [
          // Container(
          // color: Colors.red,
          // child: Row(
          // children: [
          // Container(
          // margin: EdgeInsets.all(5.0),
          // width: 100,
          // decoration: BoxDecoration(
          // image: DecorationImage(
          // image: CachedNetworkImageProvider(
          // _orderCustimizationController
          //     .response!.data!.vendor!.image),
          // fit: BoxFit.fill),
          // borderRadius: BorderRadius.circular(12.0),
          // ),
          // ),
          // SizedBox(
          // child: Padding(
          // padding: const EdgeInsets.all(5.0),
          // child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // children: [
          // SizedBox(height: 30,),
          // Text(
          // _orderCustimizationController
          //     .response!.data!.vendor!.name,
          // style: TextStyle(
          // fontSize: 20, fontFamily: "CinzelBold"),
          // overflow: TextOverflow.ellipsis,
          // ),
          // SizedBox(
          // height: ScreenConfig.blockHeight * 0.5,
          // ),
          // Container(
          // color: Colors.green,
          // child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          // children: [
          // Text(_cartController.diningValue
          // ? 'Dine in'
          //     : 'Take Away'),
          // Switch(
          // onChanged: (bool? value) async {
          // if (value!) {
          // await showDialog<int>(
          // context: context,
          // builder: (_) => AlertDialog(
          // title: Center(
          // child: Text(
          // 'Available table no')),
          // content: SizedBox(
          // height: Get.height * 0.4,
          // width: Get.width * 0.5,
          // child: Column(
          // children: [
          // Expanded(
          // child: FutureBuilder<
          // BookTableModel>(
          // future:
          // getBookTable(),
          // builder: (context,
          // snapshot) {
          // if (snapshot
          //     .hasError) {
          // return Center(
          // child: Text(snapshot
          //     .error
          //     .toString()),
          // );
          // } else if (snapshot
          //     .hasData) {
          // return GridView
          //     .builder(
          // itemCount: snapshot
          //     .data
          //     ?.data
          //     .bookedTable
          //     .length ??
          // 0,
          // itemBuilder:
          // (builder,
          // index) {
          // return GestureDetector(
          // onTap:
          // () async {
          // _cartController.tableNumber =
          // snapshot.data!.data.bookedTable[index].bookedTableNumber;
          // if (snapshot.data!.data.bookedTable[index].status ==
          // 1) {
          // Map<String, dynamic> param = {
          // 'vendor_id': Constants.vendorId,
          // 'booked_table_number': snapshot.data!.data.bookedTable[index].bookedTableNumber,
          // };
          // BaseModel<BookedOrderModel> baseModel = await _cartController.getBookedTableData(param, context);
          // BookedOrderModel bookOrderModel = baseModel.data!;
          // if (bookOrderModel.success!) {
          // print('order');
          // print(bookOrderModel.data!.orderId);
          // _cartController.cartMaster = cm.CartMaster.fromMap(jsonDecode(bookOrderModel.data!.orderData!));
          // _cartController.cartMaster?.oldOrderId = bookOrderModel.data!.orderId;
          // Navigator.pop(context);
          // } else {
          // print(baseModel.error);
          // }
          // } else {
          // Navigator.pop(context);
          // }
          // },
          // child:
          // Container(
          // margin:
          // EdgeInsets.only(bottom: 18),
          // child:
          // Stack(
          // children: [
          // Positioned(
          // child: Container(
          // padding: EdgeInsets.all(40.0),
          // decoration: BoxDecoration(color: snapshot.data!.data.bookedTable[index].status == 1 ? Color(Constants.colorTheme) : Colors.green, shape: BoxShape.circle),
          // ),
          // ),
          // Center(
          // child: Text(
          // snapshot.data!.data.bookedTable[index].bookedTableNumber.toString(),
          // style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
          // ),
          // ),
          // ],
          // ),
          // ),
          // );
          // },
          // gridDelegate:
          // SliverGridDelegateWithFixedCrossAxisCount(
          // crossAxisCount: Get.width >
          // 1200
          // ? 8
          //     : 3,
          // mainAxisExtent:
          // 80,
          // ),
          // );
          // }
          // return Center(
          // child:
          // CircularProgressIndicator(
          // color: Color(
          // Constants
          //     .colorTheme),
          // ));
          // }),
          // ),
          // ],
          // ),
          // ),
          // ));
          // setState(() {
          // // _cartController.tableNumber!=null?selectMethod=DeliveryMethod.TAKEAWAY:null;
          // _cartController.diningValue =
          // _cartController.tableNumber !=
          // null
          // ? true
          //     : false;
          // _cartController.isPromocodeApplied =
          // false;
          // });
          // } else {
          // setState(() {
          // _cartController.tableNumber = null;
          // _cartController.diningValue = false;
          // });
          // }
          // },
          // value: _cartController.diningValue,
          // activeColor: Colors.red,
          // activeTrackColor: Colors.red,
          // inactiveThumbColor: Colors.red,
          // inactiveTrackColor: Colors.white,
          // ),
          // ],
          // ),
          // ),
          // ],
          // ),
          // ),
          // ),
          // ],
          // ),
          // ),
          // TabBar(
          // padding: EdgeInsets.all(8.0),
          // labelColor: Colors.red,
          // labelStyle: TextStyle(
          // fontFamily: "ProximaBold",
          // fontSize: 30,
          // color: Colors.red,
          // ),
          // indicatorColor: Colors.transparent,
          // controller: _tabController,
          // unselectedLabelColor: Colors.black,
          // isScrollable: true,
          // tabs: List.generate(
          // _orderCustimizationController
          //     .response!.data!.menuCategory!.length,
          // (index) => Text(
          // _orderCustimizationController
          //     .response!.data!.menuCategory![index].name,
          // style: TextStyle(fontSize: 16),
          // ),
          // ),
          // onTap: (i) {
          // itemScrollController.scrollTo(
          // index: i, duration: Duration(milliseconds: 500));
          // },
          // ),
          // Flexible(
          // fit: FlexFit.loose,
          // child: ScrollablePositionedList.builder(
          // shrinkWrap: true,
          // scrollDirection: Axis.vertical,
          // itemCount: _orderCustimizationController
          //     .response!.data!.menuCategory!.length,
          // itemBuilder: (context, index) => Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // children: [
          // SizedBox(
          // height: ScreenConfig.blockHeight,
          // ),
          // Text(
          // _orderCustimizationController
          //     .response!.data!.menuCategory![index].name,
          // style: TextStyle(
          // color: Colors.grey,
          // fontFamily: "ProximaBold",
          // fontSize: ScreenConfig.blockHeight * 2.5),
          // ),
          // SizedBox(
          // height: ScreenConfig.blockHeight,
          // ),
          // Padding(
          // padding: EdgeInsets.all(2.0),
          // child: Column(
          // children: getCategoriesItemList(index),
          // ),
          // ),
          // ],
          // ),
          // itemScrollController: itemScrollController,
          // itemPositionsListener: itemPositionsListener,
          // ),
          // ),
          // ],
          // ),
          // Positioned(
          // top: 50.0,
          // right: 40,
          // child: GestureDetector(
          // onTap: () {
          // Get.to(() => CartScreen(
          // isDining: _cartController.diningValue,
          // ));
          // },
          // child: Container(
          // margin: EdgeInsets.only(left: 16.0),
          // child: ClipOval(
          // child: Material(
          // color: Color(Constants.colorTheme),
          // // Button color
          // child: Padding(
          // padding: const EdgeInsets.all(8.0),
          // child: Icon(
          // CupertinoIcons.shopping_cart,
          // color: Colors.white,
          // ),
          // ),
          // ),
          // ),
          // ),
          // )),
          // Positioned(
          // top: 40.0,
          // right: 42,
          // child: ClipOval(
          // child: Material(
          // color: Color(Constants.colorTheme), // Button color
          // child: GestureDetector(
          // onTap: () {},
          // child: Padding(
          // padding: const EdgeInsets.all(2.0),
          // child: Obx(() => Text(
          // _cartController.cartTotalQuantity.toString(),
          // style: TextStyle(
          // color: Colors.white,
          // ),
          // ))),
          // ),
          // ),
          // ),
          // ),
          // Positioned(
          // top: 40.0,
          // right: 0,
          // child: PopupMenuButton<int>(
          // icon: Icon(
          // Icons.adaptive.more,
          // color: Colors.white,
          // ),
          // onSelected: (item) => onSelected(context, item),
          // itemBuilder: (context) => [
          // PopupMenuItem<int>(
          // value: 0, child: Text('Categories')),
          // ]),
          // ),
          // ],
          // ),
        }
      },
    ));
  }

  ///New Chenge??

  List<Widget> getCategoriesItemList(int index) {
    if (_orderCustimizationController
            .response!.data!.menuCategory![index].type ==
        'SINGLE') {
      List<SingleMenu> searchResults = _searchQuery.isEmpty
          ? _orderCustimizationController
              .response!.data!.menuCategory![index].singleMenu!
          : _orderCustimizationController
              .response!.data!.menuCategory![index].singleMenu!
              .where((menu) => menu.menu!.name
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();
      return List.generate(searchResults.length, (i) {
        return Padding(
            padding: EdgeInsets.only(right: 8.0, left: 8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                searchResults[i].menu!.image),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    SizedBox(
                      width: ScreenConfig.blockWidth * 2,
                    ),
                    Flexible(
                      child: SizedBox(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              searchResults[i].menu!.name,
                              maxLines: 2,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontFamily: "ProximaBold",
                                color: Color(Constants.colorTheme),
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(
                              height: ScreenConfig.blockHeight * 1,
                            ),
                            Text(
                              searchResults[i].menu!.description,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: ScreenConfig.blockHeight,
                            ),
                            getPrice(searchResults[i]),
                          ],
                        ),
                      ),
                    ),
                    (searchResults[i].menu!.price == null ||
                            searchResults[i].menu!.menuAddon!.isNotEmpty)
                        ? GestureDetector(
                            onTap: () {
                              print("ABC");
                              List<MenuSize> tempList = [];
                              tempList.addAll(searchResults[i].menu!.menuSize!);
                              if (searchResults[i].menu!.price == null) {
                                print("123");
                                List<MenuSize> menuSizeList =
                                    searchResults[i].menu!.menuSize!;
                                for (int menuSizeIndex = 0;
                                    menuSizeIndex < menuSizeList.length;
                                    menuSizeIndex++) {
                                  List<MenuAddon> groupMenuAddon =
                                      menuSizeList[menuSizeIndex]
                                          .groupMenuAddon!;
                                  Set set = Set();
                                  for (int groupMenuAddonIndex = 0;
                                      groupMenuAddonIndex <
                                          groupMenuAddon.length;
                                      groupMenuAddonIndex++) {
                                    if (set.contains(
                                        groupMenuAddon[groupMenuAddonIndex]
                                            .addonCategoryId)) {
                                      //duplicate
                                      groupMenuAddon[groupMenuAddonIndex]
                                          .isDuplicate = true;
                                    } else {
                                      //unique
                                      set.add(
                                          groupMenuAddon[groupMenuAddonIndex]
                                              .addonCategoryId);
                                    }
                                  }
                                }
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: ScreenConfig.blockHeight * 80,
                                        child: AddonsWithSized(
                                          menu: searchResults[i].menu!,
                                          category:
                                              _orderCustimizationController
                                                  .response!
                                                  .data!
                                                  .menuCategory![index]
                                                  .type,
                                          data:
                                              searchResults[i].menu!.menuSize!,
                                        ),
                                      );
                                    });
                              } else if (searchResults[i]
                                  .menu!
                                  .menuAddon!
                                  .isNotEmpty) {
                                print("456");
                                enable = false;
                                showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    builder: (BuildContext context) {
                                      return AddonsOnly(
                                        data: searchResults[i].menu!,
                                        menuPrice:
                                            searchResults[i].menu!.price!,
                                        menuId: searchResults[i].menu!.id,
                                        category: _orderCustimizationController
                                            .response!
                                            .data!
                                            .menuCategory![index]
                                            .type,
                                        vendor: _orderCustimizationController
                                            .response!.data!.vendor!,
                                      );
                                    });
                              }
                            },
                            child: Container(
                              width: ScreenConfig.blockWidth * 10,
                              height: ScreenConfig.blockHeight * 16,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Color(Constants.colorTheme),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              print("DEF");
                              await showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 200,
                                      child: NoAddons(
                                        menu: searchResults[i].menu!,
                                        category: _orderCustimizationController
                                            .response!
                                            .data!
                                            .menuCategory![index]
                                            .type,
                                        vendor: _orderCustimizationController
                                            .response!.data!.vendor!,
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              width: 30,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Color(Constants.colorTheme),
                              ),
                            ),
                          ),
                  ],
                ),
                Divider(
                  color: Colors.red,
                ),
              ],
            ));
      });
    } else if (_orderCustimizationController
            .response!.data!.menuCategory![index].type ==
        'HALF_N_HALF') {
      return List.generate(
        _orderCustimizationController
            .response!.data!.menuCategory![index].halfNHalfMenu!.length,
        (i) => Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            _orderCustimizationController.response!.data!
                                .menuCategory![index].halfNHalfMenu![i].image),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                SizedBox(
                  width: ScreenConfig.blockWidth * 2,
                ),
                Flexible(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _orderCustimizationController.response!.data!
                            .menuCategory![index].halfNHalfMenu![i].name,
                        maxLines: 2,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontFamily: "ProximaBold",
                          color: Color(Constants.colorTheme),
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(
                        height: ScreenConfig.blockHeight * 1,
                      ),
                      Text(
                        _orderCustimizationController.response!.data!
                            .menuCategory![index].halfNHalfMenu![i].description,
                        maxLines: 4,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                TextButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                        width: 2.0,
                        color: Colors.red,
                      )),
                    ),
                    onPressed: () async {
                      // await _orderCustimizationController.getSingleVendorRetrieveSizes(_orderCustimizationController.response!.data!.vendor!.id,
                      //     _orderCustimizationController.response!.data!.menuCategory![index].halfNHalfMenu![i].itemCategoryId);
                      // if(_orderCustimizationController.singleVendorRetrieveSizes!.success){
                      //
                      // }else{
                      //   print("Success is not true");
                      // }
                      final prefs = await SharedPreferences.getInstance();

                      String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
                       showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          builder: (BuildContext context) {
                            return Container(
                              height: ScreenConfig.blockHeight * 80,
                              child: HalfNHalf(
                                category: _orderCustimizationController
                                    .response!.data!.menuCategory![index].type,
                                vendorId: int.parse(vendorId.toString()),
                                halfNHalfMenu: _orderCustimizationController
                                    .response!
                                    .data!
                                    .menuCategory![index]
                                    .halfNHalfMenu![i],
                              ),
                            );
                          });
                    },
                    child: Text("EDIT"))
              ],
            ),
            Divider(
              color: Colors.red,
            ),
          ],
        ),
      );
    } else if (_orderCustimizationController
            .response!.data!.menuCategory![index].type ==
        'DEALS') {
      return List.generate(
          _orderCustimizationController
              .response!.data!.menuCategory![index].dealsMenu!.length, (i) {
        DealsMenu dealsMenu = _orderCustimizationController
            .response!.data!.menuCategory![index].dealsMenu![i];
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(dealsMenu.image),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                SizedBox(
                  width: ScreenConfig.blockWidth * 2,
                ),
                SizedBox(
                  width: ScreenConfig.blockWidth * 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      SizedBox(
                        height: ScreenConfig.blockHeight * 1,
                      ),
                      Text(
                        dealsMenu.description,
                        maxLines: 4,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      getDealsPrice(dealsMenu),
                    ],
                  ),
                ),
                Spacer(),
                TextButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                        width: 2.0,
                        color: Colors.red,
                      )),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          builder: (BuildContext context) {
                            return Container(
                              height: ScreenConfig.blockHeight * 80,
                              child: dealsItems.DealsItems(
                                dealsItemList: _orderCustimizationController
                                    .response!
                                    .data!
                                    .menuCategory![index]
                                    .dealsMenu![i]
                                    .dealsItems!,
                                dealsMenu: dealsMenu,
                                category: _orderCustimizationController
                                    .response!.data!.menuCategory![index].type,
                              ),
                            );
                          });
                    },
                    child: Text("EDIT"))
              ],
            ),
            Divider(
              color: Colors.red,
            ),
          ],
        );
      });
    } else {
      return [];
    }
  }

  getPrice(SingleMenu singleMenu) {
    if (singleMenu.menu!.price == null) {
      return Row(
        children: [
          Text(
            "Customizable",
            style: TextStyle(
              color: Color(Constants.colorTheme),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      );
    } else {
      if (singleMenu.menu!.displayDiscountPrice == null) {
        return Row(
          children: [
            Text(
              singleMenu.menu!.price!,
              style: TextStyle(
                fontFamily: "digital",
                color: Color(Constants.colorTheme),
                fontSize: 20,
              ),
            ),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${singleMenu.menu!.displayPrice}',
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontFamily: "digital",
                    color: Color(Constants.colorTheme),
                    fontSize: 20,
                  ),
                ),
                Text(
                  ' ${singleMenu.menu!.price}',
                  style: TextStyle(
                    fontFamily: "digital",
                    color: Color(Constants.colorTheme),
                    fontSize: 20,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${singleMenu.menu!.diningPrice}',
              style: TextStyle(
                fontFamily: "digital",
                color: Color(Constants.colorTheme),
                fontSize: 20,
              ),
            ),
          ],
        );
      }
    }
  }

  getDealsPrice(DealsMenu dealsMenu) {
    if (dealsMenu.displayDiscountPrice == null) {
      return Text(
        'Price: ${dealsMenu.price}',
        style: TextStyle(
          fontFamily: "digital",
          color: Color(Constants.colorTheme),
          fontSize: 20,
        ),
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${dealsMenu.displayPrice}',
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  fontFamily: "digital",
                  color: Color(Constants.colorTheme),
                  fontSize: 20,
                ),
              ),
              Text(
                ' ${dealsMenu.displayDiscountPrice}',
                style: TextStyle(
                  fontFamily: "digital",
                  color: Color(Constants.colorTheme),
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${dealsMenu.dealsDiningPrice ?? 0.0}',
              style: TextStyle(
                fontFamily: "digital",
                color: Color(Constants.colorTheme),
                fontSize: 20,
              ),
            ),
          ),
        ],
      );
    }
  }

  calculateGroupMenuAddon(List<MenuAddon> groupMenuAddonList, Set set) {
    for (int groupMenuAddonIndex = 0;
        groupMenuAddonIndex < groupMenuAddonList.length;
        groupMenuAddonIndex++) {
      if (set
          .contains(groupMenuAddonList[groupMenuAddonIndex].addonCategoryId)) {
        groupMenuAddonList.remove((groupMenuAddonList[groupMenuAddonIndex]));
        print('remove');
        break;
      } else {
        set.add(groupMenuAddonList[groupMenuAddonIndex].addonCategoryId);
      }
    }
  }

  onSelected(BuildContext context, int item) {
    if (item == 0) {
      Get.to(() => VendorItemCategories(vendorId: widget.vendorId));
    }
  }
}

///Item Search but error for tab///
//itemCount: _getMenuItemCount(_orderCustimizationController.response!.data!.menuCategory!),
//                   itemBuilder: (BuildContext context, int index) {
//                     List<SingleMenu> filteredMenus = [];
//                     if (_selectedCategoryIndex == 0) {
//                       for (MenuCategory category in _orderCustimizationController.response!.data!.menuCategory!) {
//                         filteredMenus.addAll(category.singleMenu!
//                             .where((menu) =>
//                             menu.menu!.name.toLowerCase().contains(_searchQuery.toLowerCase()))
//                             .toList());
//                       }
//                     } else {
//                       filteredMenus.addAll(_orderCustimizationController.response!.data!.menuCategory![_selectedCategoryIndex - 1]
//                           .singleMenu!
//                           .where((menu) =>
//                           menu.menu!.name.toLowerCase().contains(_searchQuery.toLowerCase()))
//                           .toList());
//                     }
//                     if (filteredMenus.isEmpty) {
//                       return Center(
//                         child: Text('No matching items found.'),
//                       );
//                     } else {
//                       SingleMenu singleMenu = filteredMenus[index];
//                       return Padding(
//                           padding: EdgeInsets.only(right: 8.0, left: 8.0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     height: 100,
//                                     width: 100,
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                           image: CachedNetworkImageProvider(
//                                               singleMenu.menu!.image),
//                                           fit: BoxFit.fill),
//                                       borderRadius: BorderRadius.circular(12.0),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: ScreenConfig.blockWidth * 2,
//                                   ),
//                                   Flexible(
//                                     child: SizedBox(
//                                       height: 100,
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             singleMenu.menu!.name,
//                                             maxLines: 2,
//                                             style: TextStyle(
//                                               overflow: TextOverflow.ellipsis,
//                                               fontFamily: "ProximaBold",
//                                               color: Color(Constants.colorTheme),
//                                               fontSize: 17,
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: ScreenConfig.blockHeight * 1,
//                                           ),
//                                           Text(
//                                             singleMenu.menu!.description,
//                                             maxLines: 2,
//                                             style: TextStyle(
//                                               color: Colors.grey[600],
//                                               fontSize: 14,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: ScreenConfig.blockHeight,
//                                           ),
//                                           getPrice(singleMenu),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   (singleMenu.menu!.price == null ||
//                                       singleMenu.menu!.menuAddon!.isNotEmpty)
//                                       ? GestureDetector(
//                                     onTap: () {
//                                       print("ABC");
//                                       List<MenuSize> tempList = [];
//                                       tempList.addAll(singleMenu.menu!.menuSize!);
//                                       if (singleMenu.menu!.price == null) {
//                                         print("123");
//                                         List<MenuSize> menuSizeList =
//                                         singleMenu.menu!.menuSize!;
//                                         for (int menuSizeIndex = 0;
//                                         menuSizeIndex < menuSizeList.length;
//                                         menuSizeIndex++) {
//                                           List<MenuAddon> groupMenuAddon =
//                                           menuSizeList[menuSizeIndex]
//                                               .groupMenuAddon!;
//                                           Set set = Set();
//                                           for (int groupMenuAddonIndex = 0;
//                                           groupMenuAddonIndex <
//                                               groupMenuAddon.length;
//                                           groupMenuAddonIndex++) {
//                                             if (set.contains(
//                                                 groupMenuAddon[groupMenuAddonIndex]
//                                                     .addonCategoryId)) {
//                                               //duplicate
//                                               groupMenuAddon[groupMenuAddonIndex]
//                                                   .isDuplicate = true;
//                                             } else {
//                                               //unique
//                                               set.add(
//                                                   groupMenuAddon[groupMenuAddonIndex]
//                                                       .addonCategoryId);
//                                             }
//                                           }
//                                         }
//                                         showModalBottomSheet(
//                                             isScrollControlled: true,
//                                             context: context,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.vertical(
//                                                 top: Radius.circular(20),
//                                               ),
//                                             ),
//                                             clipBehavior: Clip.antiAliasWithSaveLayer,
//                                             builder: (BuildContext context) {
//                                               return Container(
//                                                 height: ScreenConfig.blockHeight * 80,
//                                                 child: AddonsWithSized(
//                                                   menu: singleMenu.menu!,
//                                                   category:
//                                                   _orderCustimizationController
//                                                       .response!
//                                                       .data!
//                                                       .menuCategory![index]
//                                                       .type,
//                                                   data:
//                                                   singleMenu.menu!.menuSize!,
//                                                 ),
//                                               );
//                                             });
//                                       } else if (singleMenu
//                                           .menu!
//                                           .menuAddon!
//                                           .isNotEmpty) {
//                                         print("456");
//                                         enable = false;
//                                         showModalBottomSheet(
//                                             context: context,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.vertical(
//                                                 top: Radius.circular(20),
//                                               ),
//                                             ),
//                                             clipBehavior: Clip.antiAliasWithSaveLayer,
//                                             builder: (BuildContext context) {
//                                               return AddonsOnly(
//                                                 data: singleMenu.menu!,
//                                                 menuPrice:
//                                                 singleMenu.menu!.price!,
//                                                 menuId: singleMenu.menu!.id,
//                                                 category: _orderCustimizationController
//                                                     .response!
//                                                     .data!
//                                                     .menuCategory![index]
//                                                     .type,
//                                                 vendor: _orderCustimizationController
//                                                     .response!.data!.vendor!,
//                                               );
//                                             });
//                                       }
//                                     },
//                                     child: Container(
//                                       width: ScreenConfig.blockWidth * 10,
//                                       height: ScreenConfig.blockHeight * 16,
//                                       decoration: BoxDecoration(
//                                         border: Border.all(color: Colors.red),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ),
//                                       child: Icon(
//                                         Icons.add,
//                                         color: Color(Constants.colorTheme),
//                                       ),
//                                     ),
//                                   )
//                                       : GestureDetector(
//                                     onTap: () async {
//                                       print("DEF");
//                                       await showModalBottomSheet(
//                                           context: context,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.vertical(
//                                               top: Radius.circular(20),
//                                             ),
//                                           ),
//                                           clipBehavior: Clip.antiAliasWithSaveLayer,
//                                           builder: (BuildContext context) {
//                                             return Container(
//                                               height: 200,
//                                               child: NoAddons(
//                                                 menu: singleMenu.menu!,
//                                                 category: _orderCustimizationController
//                                                     .response!
//                                                     .data!
//                                                     .menuCategory![index]
//                                                     .type,
//                                                 vendor: _orderCustimizationController
//                                                     .response!.data!.vendor!,
//                                               ),
//                                             );
//                                           });
//                                     },
//                                     child: Container(
//                                       width: 30,
//                                       height: 100,
//                                       decoration: BoxDecoration(
//                                         border: Border.all(color: Colors.red),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ),
//                                       child: Icon(
//                                         Icons.add,
//                                         color: Color(Constants.colorTheme),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Divider(
//                                 color: Colors.red,
//                               ),
//                             ],
//                           ));
//                     }
//                   },
