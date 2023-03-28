import 'dart:collection';
import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/config/Palette.dart';
import 'package:pos/config/screen_config.dart';
import 'package:pos/constant/app_strings.dart';
import 'package:pos/controller/order_controller.dart';
import 'package:pos/pages/pos/pos_menu.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:pos/widgets/custom_appbar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../model/cart_master.dart';
import '../selection_screen.dart';
import 'OrderDetailScreen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pos/model/vendor/orders_response.dart' as orderResponse;

class OrderScreen extends StatefulWidget {
  final String title;
  final String apiName;

  OrderScreen({Key? key, required this.title, required this.apiName})
      : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderController _orderController = Get.find<OrderController>();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Color primaryColor = Color(0xffd12828);

  List<Color> colorList = [
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.orange,
  ];

  @override
  void initState() {
    // TODO: implement initState
    checkNewOrders();
    super.initState();
  }

  Future<void> checkNewOrders() async {
    int vendorId = Constants.vendorId;
    DatabaseReference ref = FirebaseDatabase.instance.ref("vendor/$vendorId");
    ref.onChildChanged.listen((event) async {
      print("data is updated");

      DataSnapshot dataSnapshot =
          await FirebaseDatabase.instance.ref("vendor/$vendorId/status").get();
      print('new order arrived');
      print(dataSnapshot.value);
      if (dataSnapshot.value == 'APPROVE') {
        _orderController.getOrders('NewOrders');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        _orderController.orderList.clear();
        return true;
      },
      child: Scaffold(
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: Image.asset('images/background.png').image,
                  fit: BoxFit.cover)),
          child: SmartRefresher(
            onRefresh: () async {
              await _orderController.getOrders(widget.apiName);
              _refreshController.refreshCompleted();
            },
            controller: _refreshController,
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: Column(
                children: [
                  Container(
                    height: Get.height * 0.1,
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration:
                        BoxDecoration(color: Color(Constants.colorTheme)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        TextButton(
                          onPressed: () async {
                            SharedPreferences sharedPrefs =
                                await SharedPreferences.getInstance();
                            sharedPrefs.remove(Constants.isKitchenLoggedIn);
                            Get.offAll(() => SelectionScreen());
                          },
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(onPressed: () async {
                        await _orderController.getOrders(widget.apiName);
                      }, child: Text("Reload"),),
                    ),
                  ),
                  Flexible(
                    child: Obx(
                      () => MasonryGridView.count(

                          // padding: EdgeInsets.symmetric(horizontal: 22),
                          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //   crossAxisCount: 3,
                          //   mainAxisExtent: 300,
                          //
                          // ),
                          crossAxisCount: () {
                            if (Constants.isMobile()) {
                              return 1;
                            } else if (Constants.isDesktop()) {
                              return 3;
                            } else if (Constants.isTablet()) {
                              return 2;
                            }
                            return 1;
                          }(),
                          itemCount: _orderController.orderList.length,
                          // shrinkWrap: true,
                          // // padding: EdgeInsets.only(top: 10, bottom: 200),
                          // scrollDirection: Axis.vertical,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, orderIndex) {
                            orderResponse.Data order =
                                _orderController.orderList[orderIndex];
                            CartMaster cartMaster = CartMaster.fromMap(
                                jsonDecode(order.orderData!));
                            int addonsHeight = 0;
                            List<Cart> cart = cartMaster.cart;
                            if (order.deliveryTime != null) {
                              if (checkGivenDateIsEqual(order.deliveryTime!)) {
                                order.isDisable = false;
                              }
                            }
                            for (Cart cart in cartMaster.cart) {
                              if (cart.category == 'SINGLE') {
                                for (MenuCartMaster menu in cart.menu) {
                                  addonsHeight += menu.addons.length * 20;
                                }
                              }
                            }
                            return SizedBox(
                              // height:150,
                              height: (order.orderItems!.length * 30) +
                                  addonsHeight +
                                  220,
                              child: Card(
                                color: (order.isDisable &&
                                        widget.title != 'PastOrders')
                                    ? Colors.grey[300]
                                    : null,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white24, width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                            bottom: 0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "OID:",
                                                      style: TextStyle(
                                                          color:
                                                              Palette.switchs,
                                                          fontFamily:
                                                              proxima_nova_reg,
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      order.orderId!,
                                                      style: TextStyle(
                                                          color:
                                                              Palette.switchs,
                                                          fontFamily:
                                                              proxima_nova_reg,
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      " | ",
                                                      style: TextStyle(
                                                          color:
                                                              Palette.switchs,
                                                          fontFamily:
                                                              proxima_nova_reg,
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      '${order.date}, ${order.time}',
                                                      style: TextStyle(
                                                          color:
                                                              Palette.switchs,
                                                          fontFamily:
                                                              proxima_nova_reg,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                _orderController
                                                                .orderList[
                                                                    orderIndex]
                                                                .table_no ==
                                                            0 ||
                                                        _orderController
                                                                .orderList[
                                                                    orderIndex]
                                                                .table_no ==
                                                            null
                                                    ? Text("")
                                                    : Text(
                                                        "Table No: ${_orderController.orderList[orderIndex].table_no.toString()}",
                                                        style: TextStyle(
                                                            color: Palette
                                                                .loginhead,
                                                            fontFamily:
                                                                proxima_nova_bold,
                                                            fontSize: 16),
                                                      ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  order.userName!,
                                                  style: TextStyle(
                                                      color: Palette.loginhead,
                                                      fontFamily:
                                                          proxima_nova_bold,
                                                      fontSize: 16),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      () {
                                                        if (order
                                                                .deliveryTime !=
                                                            null) {
                                                          return 'Schedule Order';
                                                        } else {
                                                          return order
                                                                  .deliveryType ??
                                                              '';
                                                        }
                                                      }(),
                                                      style: TextStyle(
                                                          color:
                                                              Palette.loginhead,
                                                          fontFamily:
                                                              proxima_nova_bold,
                                                          fontSize: 16),
                                                    ),
                                                    () {
                                                      if (order.deliveryTime !=
                                                          null) {
                                                        return Text(
                                                          '${DateFormat('yyyy-MM-dd').format(order.deliveryTime!)},${DateFormat("h:mma").format(order.deliveryTime!)}',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  colorTheme),
                                                              fontFamily:
                                                                  proxima_nova_reg,
                                                              fontSize: 12),
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    }(),
                                                  ],
                                                ),
                                                IconButton(
                                                    onPressed: order.isDisable
                                                        ? null
                                                        : () {
                                                            CartMaster
                                                                cartMaster =
                                                                CartMaster.fromMap(
                                                                    jsonDecode(order
                                                                        .orderData!));
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      OrderDetailScreen(
                                                                          order,
                                                                          cartMaster),
                                                                ));
                                                          },
                                                    icon: Icon(
                                                      Icons
                                                          .keyboard_arrow_right_outlined,
                                                      color: Palette.loginhead,
                                                      size: 35,
                                                    ))
                                              ],
                                            ),
                                          ],
                                        )),
                                    DottedLine(
                                      direction: Axis.horizontal,
                                      lineThickness: 1.0,
                                      dashColor: Palette.switchs,
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          // image
                                          //constraints: BoxConstraints.expand(),
                                          decoration: BoxDecoration(
                                              // image: DecorationImage(
                                              //   image: Image.asset("images/${order.deliveryType=='DELIVERY'?'delivery.png':'take_away.jpg'}",fit: BoxFit.fill,).image,
                                              //
                                              // )
                                              ),
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 10,
                                              top: 10),

                                          child: ListView.builder(
                                            itemCount: order.orderItems!.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (context, index1) {
                                              Cart cartItem = cart[index1];
                                              String category =
                                                  cartItem.category;
                                              MenuCategoryCartMaster?
                                                  menuCategory =
                                                  cartItem.menuCategory;
                                              List<MenuCartMaster> menu =
                                                  cartItem.menu;
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          order
                                                              .orderItems![
                                                                  index1]
                                                              .itemName!,
                                                          style: TextStyle(
                                                              color: Palette
                                                                  .loginhead,
                                                              fontFamily:
                                                                  "ProximaNova",
                                                              fontSize: 14),
                                                        ),
                                                        Text(
                                                          ' x ${order.orderItems![index1].qty}',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  colorTheme),
                                                              fontFamily:
                                                                  "ProximaBold",
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                    () {
                                                      if (category ==
                                                          'SINGLE') {
                                                        return ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                menu.length,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                    menuIndex) {
                                                              MenuCartMaster
                                                                  menuItem =
                                                                  menu[
                                                                      menuIndex];
                                                              return Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Flexible(
                                                                    fit: FlexFit
                                                                        .loose,
                                                                    child: ListView.builder(
                                                                        shrinkWrap: true,
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        itemCount: menuItem.addons.length,
                                                                        padding: EdgeInsets.only(left: 5),
                                                                        itemBuilder: (context, addonIndex) {
                                                                          AddonCartMaster
                                                                              addonItem =
                                                                              menuItem.addons[addonIndex];
                                                                          return Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 5.0),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Text(addonItem.name + ' '),
                                                                                Container(
                                                                                  height: 20,
                                                                                  padding: EdgeInsets.all(3.0),
                                                                                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      'ADDONS',
                                                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }),
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      } else {
                                                        return Container();
                                                      }
                                                    }(),
                                                    Visibility(
                                                      child: Text(
                                                        '(${order.orderItems![index1].itemName})',
                                                        style: TextStyle(
                                                            color:
                                                                Palette.switchs,
                                                            fontFamily:
                                                                "ProximaNova",
                                                            fontSize: 12),
                                                      ),
                                                      visible: false,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    DottedLine(
                                      direction: Axis.horizontal,
                                      lineThickness: 1.0,
                                      dashColor: Palette.switchs,
                                    ),
                                    Container(
                                      width: Get.width,
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          bottom: 10,
                                          top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            // width: 90,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Payment From : ${order.paymentType!}",
                                                  style: TextStyle(
                                                      color: Palette.switchs,
                                                      fontFamily:
                                                          proxima_nova_reg,
                                                      fontSize: 12),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "From : ${order.placedFrom!}",
                                                  style: TextStyle(
                                                      color: Palette.switchs,
                                                      fontFamily:
                                                          proxima_nova_reg,
                                                      fontSize: 12),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    order.paymentType == "POS CASH" || order.paymentType == "POS CARD" ?  'Payment : Completed' : 'Payment : Incomplete',
                                                  style: TextStyle(
                                                      color: Colors.red.shade500,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          proxima_nova_reg,
                                                      fontSize: 12),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '\$${order.amount}',
                                                  style: TextStyle(
                                                      color: Palette.loginhead,
                                                      fontFamily:
                                                          proxima_nova_bold,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                          //   (_orderController.orderList[index].orderStatus=='COMPLETE' || _orderController.orderList[index].orderStatus=='REJECT')?Container():
                                          Flexible(
                                            child: () {
                                              switch (order.orderStatus) {
                                                case 'APPROVE':
                                                  return ElevatedButton(
                                                      onPressed: () async {
                                                        String status =
                                                            'PREPARING FOOD';
                                                        Map<String, String?>
                                                            param =
                                                            new HashMap();
                                                        param['id'] =
                                                            order.id.toString();
                                                        param['status'] =
                                                            status;
                                                        var res =
                                                            await _orderController
                                                                .changeOrderStatus(
                                                                    param);
                                                        if (res.data!.success ==
                                                            true) {
                                                          await _orderController
                                                              .getOrders(widget
                                                                  .apiName);
                                                          Constants
                                                              .toastMessage(res
                                                                  .data!.data
                                                                  .toString());
                                                        } else {
                                                          Constants
                                                              .toastMessage(res
                                                                  .data!.data
                                                                  .toString());
                                                        }
                                                      },
                                                      child: Text(
                                                          'PREPARING FOOD'));
                                                case 'PREPARING FOOD':
                                                  return ElevatedButton(
                                                      onPressed: () async {
                                                        String status =
                                                            'READY TO PICKUP';
                                                        Map<String, String?>
                                                            param =
                                                            new HashMap();
                                                        param['id'] =
                                                            order.id.toString();
                                                        param['status'] =
                                                            status;
                                                        var res =
                                                            await _orderController
                                                                .changeOrderStatus(
                                                                    param);
                                                        if (res.data!.success ==
                                                            true) {
                                                          await _orderController
                                                              .getOrders(widget
                                                                  .apiName);
                                                          Constants
                                                              .toastMessage(res
                                                                  .data!.data
                                                                  .toString());
                                                        } else {
                                                          Constants
                                                              .toastMessage(res
                                                                  .data!.data
                                                                  .toString());
                                                        }
                                                      },
                                                      child: Text(
                                                          'READY TO PICKUP'));
                                                default:
                                                  return Container();
                                              }
                                            }(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool checkGivenDateIsEqual(DateTime dateTime) {
    DateTime currentDate = DateTime.now();
    if (dateTime.year == currentDate.year &&
        dateTime.month == currentDate.month &&
        dateTime.day == currentDate.day) {
      return true;
    } else {
      return false;
    }
  }
}
