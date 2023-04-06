import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos/config/screen_config.dart';
import 'package:pos/controller/auth_controller.dart';
import 'package:pos/controller/cart_controller.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/dummy.dart';
import 'package:pos/model/booked_order_model.dart';
import 'package:pos/model/cart_master.dart';
import 'package:pos/model/order_setting_api_model.dart';
import 'package:pos/model/status_model.dart';
import 'package:pos/pages/dining/dining_cart_screen.dart';
import 'package:pos/pages/pos/pos_payement.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/screen_animation_utils/transitions.dart';
import 'package:pos/pages/payment_method_screen.dart';
import 'package:pos/utils/constants.dart';
import 'package:pos/utils/rounded_corner_app_button.dart';
import 'package:pos/widgets/custom_text_form_field.dart';
import '../config/Palette.dart';
import '../constant/app_strings.dart';
import 'cart/apply_coupon.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

enum DeliveryMethod { TAKEAWAY, DELIVERY }

enum ScheduleMethod { DELIVERNOW, SCHEDULETIME }

class CartScreen extends StatefulWidget {
  final bool isDining;
  CartScreen({Key? key, required this.isDining}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartController _cartController = Get.find<CartController>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? picked;
  OrderCustimizationController _orderCustimizationController =
      Get.find<OrderCustimizationController>();
  Color primaryColor = Color(Constants.colorTheme);
  double totalAmount = 0.0;
  double subTotal = 0.0;
  //double originalSubAmount=0.0;
  DeliveryMethod selectMethod = DeliveryMethod.TAKEAWAY;
  ScheduleMethod scheduleMethod = ScheduleMethod.DELIVERNOW;
  Future<BaseModel<OrderSettingModel>>? callOrderSettingRef;
  Future<BaseModel<StatusModel>>? statusRef;
  @override
  void initState() {
    _cartController.diningValue = widget.isDining;
    if (_cartController.cartMaster?.oldOrderId != null) {
      nameController.text = _cartController.userName;
      phoneNoController.text = _cartController.userMobileNumber;
    }
    if (_cartController.cartMaster != null) {
      callOrderSettingRef = _cartController
          .callOrderSetting(_cartController.cartMaster!.vendorId);

      // callOrderSettingRef!.then((value) {
      //   print("---------------");
      //   print("Order Data Cart Screen ${value.data!.toJson()}");
      //   if(value.data!.data!. != null){
      //     nameController.text = value.data!.data!.user_name.toString();
      //   } else {
      //     print("NUll Name");
      //     nameController.text = _cartController.userName;
      //   }
      //   if(value.data!.data!.mobile != null){
      //     phoneNoController.text = value.data!.data!.mobile.toString();
      //   } else {
      //     print("NUll Phone");
      //     phoneNoController.text = _cartController.userMobileNumber;
      //   }
      //   print("---------------");
      // });

      statusRef = _orderCustimizationController
          .status(_cartController.cartMaster!.vendorId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("name ${_cartController.userName}");
    ScreenConfig().init(context);
    if (_cartController.cartMaster == null ||
        _cartController.cartMaster!.cart.isEmpty) {
      return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                color: Color(Constants.colorScreenBackGround),
                image: DecorationImage(
                  image: AssetImage('images/ic_background_image.png'),
                  fit: BoxFit.cover,
                )),
            child: Center(
              child: Text("No data in the cart"),
            )),
      );
    } else {
      return FutureBuilder<BaseModel<OrderSettingModel>>(
          future: _cartController
              .callOrderSetting(_cartController.cartMaster!.vendorId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GetBuilder<CartController>(
                init: CartController(),
                id: 'dining',
                builder: (controller) {
                  if (_cartController.diningValue) {
                    return DiningCartScreen();
                  } else {
                    _cartController.calculatedAmount = 0.0;
                    totalAmount = 0.0;

                    _cartController.calculatedTax = 0.0;
                    if (_cartController.cartMaster != null) {
                      for (int i = 0;
                          i < _cartController.cartMaster!.cart.length;
                          i++)
                        totalAmount +=
                            _cartController.cartMaster!.cart[i].totalAmount;
                      totalAmount =
                          double.parse((totalAmount).toStringAsFixed(2));
                      _cartController.calculatedAmount = totalAmount;
                    }
                    if (_cartController.isPromocodeApplied) {
                      if (_cartController.discountType == 'percentage') {
                        _cartController.discountAmount =
                            totalAmount * _cartController.discount / 100;
                      } else {
                        _cartController.discountAmount =
                            double.parse(_cartController.discount.toString());
                      }
                      _cartController.calculatedAmount -=
                          _cartController.discountAmount;
                      print("sadas" +
                          _cartController.calculatedAmount.toString());
                      print(_cartController.discountAmount);
                    } else {
                      _cartController.discountAmount = 0.0;
                      _cartController.appliedCouponName = null;
                      _cartController.strAppiedPromocodeId = '0';
                    }
                    // print(jsonEncode(snapshot.data!.data!.toJson()));
                    BaseModel<OrderSettingModel> orderSettingModel =
                        snapshot.data!;
                    print("Order DAta ${snapshot.data!.data!.toJson()}");

                    ///Inclusive tax
                    if (orderSettingModel.data?.data!.taxType == 1) {
                      _cartController.calculatedTax =
                          _cartController.calculatedAmount *
                              double.parse(orderSettingModel.data!.data!.tax!) /
                              100;
                      totalAmount -= _cartController.calculatedTax;

                      ///Exclusive tax
                    } else if (orderSettingModel.data!.data!.taxType == 2) {
                      _cartController.calculatedTax =
                          _cartController.calculatedAmount *
                              double.parse(orderSettingModel.data!.data!.tax!) /
                              100;
                      _cartController.calculatedAmount +=
                          _cartController.calculatedTax;
                    }

                    subTotal = totalAmount;
                    return Scaffold(
                      body: Container(
                        decoration: BoxDecoration(
                            color: Color(Constants.colorScreenBackGround),
                            image: DecorationImage(
                              image:
                                  AssetImage('images/ic_background_image.png'),
                              fit: BoxFit.cover,
                            )),
                        child: SafeArea(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (picked != null &&
                                    selectedDate != null &&
                                    scheduleMethod != ScheduleMethod.DELIVERNOW)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(DateFormat('yyyy-MM-dd hh:mm')
                                          .format(selectedDate!)),
                                      Text(picked!.format(context)),
                                      GestureDetector(
                                          onTap: () async {
                                            await _selectDate(context);
                                            if (selectedDate != null) {
                                              await _selectTime(context);
                                              if (picked != null) {
                                                setState(() {});
                                              } else {
                                                Get.snackbar('ALERT',
                                                    'Please Select Time');
                                              }
                                            } else {
                                              Get.snackbar('ALERT',
                                                  'Please Select Date');
                                            }
                                          },
                                          child: Text("  Edit here",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.blue))),
                                    ],
                                  ),
                                SizedBox(
                                  height: ScreenConfig.blockHeight * 50,
                                  child: getCartData(),
                                ),
                                // getCouponWidget(),
                                SizedBox(
                                  height: !_cartController.isPromocodeApplied
                                      ? ScreenConfig.blockHeight * 22
                                      : ScreenConfig.blockHeight * 23,
                                  child:
                                      getTotalAmountWidget(orderSettingModel),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6.0,
                                      right: 6.0,
                                      bottom: 2.0,
                                      top: 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: RoundedCornerAppButton(
                                            btnLabel: "Checkout",
                                            onPressed: () {
                                              // if( _cartController.calculatedAmount>=double.parse(orderSettingModel.data!.data!.minOrderValue!)){
                                              //
                                              //
                                              // }else{
                                              //   Get.snackbar("ALERT", 'Minimum Order Amount Is ${orderSettingModel.data!.data!.minOrderValue}');
                                              // }
                                              if (scheduleMethod.index == 0) {
                                                selectedDate = null;
                                                picked = null;
                                              }
                                              print(selectedDate?.toString());
                                              print(picked?.toString());
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PosPayment(
                                                          notes: notesController
                                                              .text,
                                                          mobileNumber:
                                                              phoneNoController
                                                                  .text,
                                                          userName:
                                                              nameController
                                                                  .text,
                                                          venderId:
                                                              _cartController
                                                                  .cartMaster!
                                                                  .vendorId,
                                                          orderDeliveryType:
                                                              () {
                                                            if (_cartController
                                                                .diningValue) {
                                                              return 'DINING';
                                                            } else {
                                                              if (selectMethod
                                                                      .index ==
                                                                  0) {
                                                                return "TAKEAWAY";
                                                              } else {
                                                                return "DELIVERY";
                                                              }
                                                            }
                                                          }(),
                                                          orderDate: DateFormat(
                                                                  'y-MM-dd')
                                                              .format(DateTime
                                                                  .now())
                                                              .toString(),
                                                          orderTime: DateFormat(
                                                                  'hh:mm a')
                                                              .format(DateTime
                                                                  .now())
                                                              .toString(),
                                                          totalAmount:
                                                              _cartController
                                                                  .calculatedAmount,
                                                          addressId: 0,
                                                          orderDeliveryCharge:
                                                              "${_cartController.deliveryCharge}",
                                                          orderStatus:
                                                              "PENDING",
                                                          ordrePromoCode:
                                                              _cartController
                                                                  .appliedCouponName,
                                                          vendorDiscountAmount:
                                                              _cartController
                                                                  .discountAmount,
                                                          vendorDiscountId: int
                                                              .parse(_cartController
                                                                  .strAppiedPromocodeId),
                                                          strTaxAmount:
                                                              _cartController
                                                                  .calculatedTax
                                                                  .toString(),
                                                          allTax: [],
                                                          subTotal: subTotal,
                                                          deliveryDate:
                                                              selectedDate
                                                                  ?.toString(),
                                                          deliveryTime: picked
                                                              ?.format(context),
                                                          tableNumber:
                                                              _cartController
                                                                  .tableNumber,
                                                          customerName:
                                                              nameController
                                                                  .text,
                                                          customerPhone:
                                                              phoneNoController
                                                                  .text,
                                                        )),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            }
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                    color: Color(Constants.colorScreenBackGround),
                    image: DecorationImage(
                      image: AssetImage('images/ic_background_image.png'),
                      fit: BoxFit.cover,
                    )),
                child: Center(
                  child: CircularProgressIndicator(
                      color: Color(Constants.colorTheme)),
                ),
              ),
            );
          });
    }
  }

  getCartData() {
    if (_cartController.cartMaster == null ||
        _cartController.cartMaster!.cart.length == 0) {
      return Center(
        child: Text("No data in the cart"),
      );
    } else {
      // CustomTextFromfield(
      //   // onChanged: (text) {
      //   //   _validateIPAddress(text);
      //   // },
      //     controller: nameController,
      //     hintText: 'Enter Name',
      //     validator: (String? value) {
      //       if (value!.isEmpty) {
      //         return 'Please Enter Name';
      //       }
      //     }),
      return Column(
        children: [
          // selectMethod == DeliveryMethod.TAKEAWAY?
          Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    nameController.clear();
                    phoneNoController.clear();
                    // _cartController.tableNumber = null;
                    setState(() {});
                  },
                  child: Text('Clear'))),
          SizedBox(height: 2),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                SizedBox(width: 5),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.4)),
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: (40 - 15) / 2,
                        ),
                        border: InputBorder.none,
                        hintText: "Enter a Name ${nameController.text}",
                        hintStyle: TextStyle(
                            color: Colors.black26,
                            fontSize: 15,
                            fontFamily: "ProximaNova"),
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.4)),
                    child: TextFormField(
                      controller: phoneNoController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: (40 - 15) / 2,
                          ),
                          border: InputBorder.none,
                          hintText:
                              "Enter phone Number ${phoneNoController.text}",
                          hintStyle: TextStyle(
                              color: Colors.black26,
                              fontSize: 15,
                              fontFamily: "ProximaNova")),
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(width: 5),
              ],
            ),
          ),
          // : SizedBox(),
          Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    _cartController.cartMaster?.cart.clear();
                    _cartController.userName = '';
                    _cartController.userMobileNumber = '';
                    nameController.clear();
                    phoneNoController.clear();
                    // _cartController.tableNumber = null;
                    setState(() {});
                  },
                  child: Text('Clear Cart'))),
          Flexible(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _cartController.cartMaster!.cart.length,
                itemBuilder: (context, index) {
                  //totalAmount+=_cartController.cartMaster!.cart[index].totalAmount;
                  Cart cart = _cartController.cartMaster!.cart[index];
                  MenuCategoryCartMaster? menuCategory = cart.menuCategory;
                  List<MenuCartMaster> menu = cart.menu;
                  if (_cartController.cartMaster!.cart[index].category ==
                      "SINGLE") {
                    MenuCartMaster menuItem = cart.menu[0];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Constants.secondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      width: Get.width,
                      child: Padding(
                        padding: EdgeInsets.zero,
                        // padding: EdgeInsets.only(
                        //     top: ScreenUtil()
                        //         .setHeight(15),
                        //     left: ScreenUtil()
                        //         .setHeight(15),
                        //     bottom: ScreenUtil()
                        //         .setHeight(5)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              flex: 4,
                              fit: FlexFit.loose,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Text(
                                              menuItem.name +
                                                  (cart.size != null
                                                      ? ' ( ${cart.size?.sizeName}) '
                                                      : '') +
                                                  ' x ${cart.quantity}  ',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 16)),
                                        ),
                                        // SizedBox(
                                        //   height: 5,
                                        // ),
                                        // Align(
                                        //   alignment: Alignment.centerLeft,
                                        //   child: Container(
                                        //     decoration: BoxDecoration(
                                        //         color: primaryColor,
                                        //         borderRadius: BorderRadius.all(Radius.circular(4.0))
                                        //     ),
                                        //     child: Text('SINGLE',
                                        //         overflow: TextOverflow.ellipsis,
                                        //         style: TextStyle(color: Colors.white,fontWeight:FontWeight.w300 , fontSize: 16)),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      '${cart.menu[0].totalAmount}',
                                      style: TextStyle(
                                          color: Constants.yellowColor),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: menuItem.addons.length,
                                        itemBuilder: (context, addonIndex) {
                                          AddonCartMaster addonItem =
                                              menuItem.addons[addonIndex];
                                          return Row(
                                            children: [
                                              Text(addonItem.name + ' '),
                                              Text(
                                                '(ADDON)',
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                              )
                                            ],
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                                fit: FlexFit.loose,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      //decrement section
                                      GestureDetector(
                                        onTap: () {
                                          removeButton(index);
                                        },
                                        child: Container(
                                          height: 19.5,
                                          width: 19.5,
                                          decoration: BoxDecoration(
                                            color: Constants.yellowColor,
                                            shape: BoxShape.circle,
                                            // borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '-',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 18,
                                        child: Text(
                                          _cartController
                                              .cartMaster!.cart[index].quantity
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: Constants.appFont),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      //increment section
                                      GestureDetector(
                                        onTap: () {
                                          addButton(index);
                                        },
                                        child: Container(
                                          height: 19.5,
                                          width: 19.5,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Constants.yellowColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '+',
                                              style: TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  } else if (_cartController.cartMaster!.cart[index].category ==
                      "HALF_N_HALF") {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Constants.secondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      width: Get.width,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(5),
                            top: ScreenUtil().setHeight(15),
                            bottom: ScreenUtil().setHeight(5)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 4,
                              fit: FlexFit.loose,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text('${cart.totalAmount}'),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, left: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Text(
                                                menuCategory!.name +
                                                    (cart.size != null
                                                        ? ' ( ${cart.size?.sizeName}) '
                                                        : '') +
                                                    ' x ${cart.quantity}  ',
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 16)),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              4.0))),
                                              child: Text(' HALF & HALF ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 16)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(left: 25),
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: menu.length,
                                        itemBuilder: (context, menuIndex) {
                                          MenuCartMaster menuItem =
                                              menu[menuIndex];
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                  fit: FlexFit.loose,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          menuItem.name + ' ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        ),
                                                        if (menuIndex == 0)
                                                          Container(
                                                            height: 20,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    3.0),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    primaryColor,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4.0))),
                                                            child: Center(
                                                              child: Text(
                                                                'First Half'
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          )
                                                        else
                                                          Container(
                                                            height: 20,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    3.0),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    primaryColor,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4.0))),
                                                            child: Center(
                                                              child: Text(
                                                                'Second Half'
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          )
                                                      ],
                                                    ),
                                                  )),
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    padding: EdgeInsets.only(
                                                      left: 16,
                                                      top: 5.0,
                                                    ),
                                                    itemCount:
                                                        menuItem.addons.length,
                                                    itemBuilder:
                                                        (context, addonIndex) {
                                                      AddonCartMaster
                                                          addonItem =
                                                          menuItem.addons[
                                                              addonIndex];
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 5.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                addonItem.name +
                                                                    ' '),
                                                            Text(
                                                              '(ADDONS)',
                                                              style: TextStyle(
                                                                  color:
                                                                      primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              )
                                            ],
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                                fit: FlexFit.loose,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(15)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        //decrement section
                                        GestureDetector(
                                          onTap: () {
                                            removeButton(index);
                                          },
                                          child: Container(
                                            height: ScreenUtil().setHeight(21),
                                            width: ScreenUtil().setWidth(36),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              color: Color(0xfff1f1f1),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '-',
                                                style: TextStyle(
                                                    color: Color(
                                                        Constants.colorTheme)),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: ScreenUtil().setHeight(5),
                                              bottom:
                                                  ScreenUtil().setHeight(5)),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: ScreenUtil().setHeight(21),
                                            width: ScreenUtil().setWidth(36),
                                            child: Text(
                                              _cartController.cartMaster!
                                                  .cart[index].quantity
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily:
                                                      Constants.appFont),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        //increment section
                                        GestureDetector(
                                          onTap: () {
                                            addButton(index);
                                          },
                                          child: Container(
                                            height: ScreenUtil().setHeight(21),
                                            width: ScreenUtil().setWidth(36),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
                                              color: Color(0xfff1f1f1),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '+',
                                                style: TextStyle(
                                                    color: Color(
                                                        Constants.colorTheme)),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  } else if (_cartController.cartMaster!.cart[index].category ==
                      "DEALS") {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Constants.secondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      width: Get.width,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(5),
                            top: ScreenUtil().setHeight(15),
                            bottom: ScreenUtil().setHeight(5)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 4,
                              fit: FlexFit.loose,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text('${cart.totalAmount}'),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, left: 15.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Text(
                                                menuCategory!.name +
                                                    '  x ${cart.quantity} ',
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 16)),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                                padding: EdgeInsets.all(3.0),
                                                decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                3.0))),
                                                child: Text('DEALS',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14))),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        padding:
                                            EdgeInsets.only(left: 25, top: 5.0),
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: menu.length,
                                        itemBuilder: (context, menuIndex) {
                                          MenuCartMaster menuItem =
                                              menu[menuIndex];
                                          DealsItems dealsItems =
                                              menu[menuIndex].dealsItems!;
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                  fit: FlexFit.loose,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        menuItem.name + ' ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                      Container(
                                                          height: 20,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  3.0),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  primaryColor,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          4.0))),
                                                          child: Center(
                                                              child: Text(
                                                            '${dealsItems.name} ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12),
                                                          )))
                                                    ],
                                                  )),
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    padding: EdgeInsets.only(
                                                      left: 24,
                                                      top: 5.0,
                                                    ),
                                                    itemCount:
                                                        menuItem.addons.length,
                                                    itemBuilder:
                                                        (context, addonIndex) {
                                                      AddonCartMaster
                                                          addonItem =
                                                          menuItem.addons[
                                                              addonIndex];
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 5.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                addonItem.name +
                                                                    ' '),
                                                            Text(
                                                              '(ADDONS)',
                                                              style: TextStyle(
                                                                  color:
                                                                      primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              )
                                            ],
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Flexible(
                                flex: 1,
                                fit: FlexFit.loose,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(15)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      //decrement section
                                      GestureDetector(
                                        onTap: () {
                                          removeButton(index);
                                        },
                                        child: Container(
                                          height: ScreenUtil().setHeight(21),
                                          width: ScreenUtil().setWidth(36),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                            color: Color(0xfff1f1f1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '-',
                                              style: TextStyle(
                                                  color: Color(
                                                      Constants.colorTheme)),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(5),
                                            bottom: ScreenUtil().setHeight(5)),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: ScreenUtil().setHeight(21),
                                          width: ScreenUtil().setWidth(36),
                                          child: Text(
                                            _cartController.cartMaster!
                                                .cart[index].quantity
                                                .toString(),
                                            style: TextStyle(
                                                fontFamily: Constants.appFont),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      //increment section
                                      GestureDetector(
                                        onTap: () {
                                          addButton(index);
                                        },
                                        child: Container(
                                          height: ScreenUtil().setHeight(21),
                                          width: ScreenUtil().setWidth(36),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                            color: Color(0xfff1f1f1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '+',
                                              style: TextStyle(
                                                  color: Color(
                                                      Constants.colorTheme)),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      );
    }
  }

  getCouponWidget() {
    if (_cartController.cartMaster != null ||
        _cartController.cartMaster!.cart.length > 0) {
      if (!_cartController.isPromocodeApplied) {
        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 2.0),
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(16),
              strokeWidth: 2,
              dashPattern: [8, 4],
              color: Color(Constants.colorTheme),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: Container(
                  height: ScreenUtil().setHeight(25),
                  color: Color(0xffd4e1db),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(15),
                        right: ScreenUtil().setWidth(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'You Have Coupon',
                          style: TextStyle(
                              fontFamily: Constants.appFont, fontSize: 16),
                        ),
                        Text(
                          'Apply It',
                          style: TextStyle(
                              fontFamily: Constants.appFont,
                              color: Color(Constants.colorTheme),
                              fontSize: ScreenUtil().setSp(16)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          onTap: () async {
            await _cartController.callGetPromocodeListData(
                _cartController.cartMaster!.vendorId, context);
            await Navigator.of(context).push(
              Transitions(
                transitionType: TransitionType.fade,
                curve: Curves.bounceInOut,
                reverseCurve: Curves.fastLinearToSlowEaseIn,
                widget: ApplyCouppon(
                  totalPrice: totalAmount,
                ),
              ),
            );
            if (_cartController.isPromocodeApplied) {
              setState(() {});
            }
          },
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  getTotalAmountWidget(BaseModel<OrderSettingModel> orderSettingModel) {
    if (_cartController.cartMaster != null ||
        _cartController.cartMaster!.cart.length > 0) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Sub Total ",
                    style: TextStyle(
                        fontFamily: Constants.appFont,
                        fontSize: ScreenUtil().setSp(16)),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                    child: Text(
                      totalAmount.toStringAsFixed(2),
                      style: TextStyle(
                          fontFamily: Constants.appFont,
                          fontSize: ScreenUtil().setSp(14)),
                    ),
                  ),
                ],
              ),
              (_cartController.isPromocodeApplied)
                  ? Row(
                      children: [
                        Text(
                          'Coupon',
                          style: TextStyle(
                              fontFamily: Constants.appFont,
                              fontSize: ScreenUtil().setSp(16)),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            _cartController.isPromocodeApplied = false;
                            setState(() {});
                          },
                          child: Text('Remove',
                              maxLines: 1,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontFamily: Constants.appFont,
                                color: Color(Constants.colorTheme),
                                fontWeight: FontWeight.w800,
                              )),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '-${_cartController.discountAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontFamily: Constants.appFont,
                                fontSize: ScreenUtil().setSp(14)),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tax ",
                    style: TextStyle(
                        fontFamily: Constants.appFont,
                        fontSize: ScreenUtil().setSp(17)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                    child: Text(
                      _cartController.calculatedTax.toStringAsFixed(2),
                      style: TextStyle(
                          fontFamily: Constants.appFont,
                          fontSize: ScreenUtil().setSp(14)),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: ScreenConfig.blockHeight*1.5,),
              () {
                if (selectMethod.index == 1) {
                  if (orderSettingModel.data!.data!.freeDelivery == 1) {
                    return Text('Delivery Free');
                  } else {
                    if (orderSettingModel.data!.data!.freeDeliveryDistance !=
                            0 &&
                        orderSettingModel.data!.data!.freeDeliveryAmount != 0) {
                      if (_cartController.calculatedAmount >=
                              orderSettingModel
                                  .data!.data!.freeDeliveryAmount! &&
                          orderSettingModel.data!.data!.distance! <=
                              orderSettingModel
                                  .data!.data!.freeDeliveryDistance!) {
                        return Text('Delivery Free');
                      } else {
                        print(_cartController.calculatedAmount);
                        _cartController.deliveryCharge =
                            _cartController.calculatedAmount * 0.1;
                        _cartController.calculatedAmount +=
                            _cartController.deliveryCharge;
                        // print()
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery Charges",
                              style: TextStyle(
                                  fontFamily: Constants.appFont,
                                  fontSize: ScreenUtil().setSp(16)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(10)),
                              child: Text(
                                _cartController.deliveryCharge
                                    .toStringAsFixed(2),
                                style: TextStyle(
                                    fontFamily: Constants.appFont,
                                    fontSize: ScreenUtil().setSp(14)),
                              ),
                            ),
                          ],
                        );
                      }
                    } else if (orderSettingModel
                            .data!.data!.freeDeliveryDistance ==
                        0) {
                      if (_cartController.calculatedAmount >=
                          orderSettingModel.data!.data!.freeDeliveryAmount!) {
                        return Text('Delivery Free');
                      } else {
                        _cartController.deliveryCharge =
                            _cartController.calculatedAmount * 0.1;
                        _cartController.calculatedAmount +=
                            _cartController.deliveryCharge;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery Charges",
                              style: TextStyle(
                                  fontFamily: Constants.appFont,
                                  fontSize: ScreenUtil().setSp(16)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(10)),
                              child: Text(
                                _cartController.deliveryCharge
                                    .toStringAsFixed(2),
                                style: TextStyle(
                                    fontFamily: Constants.appFont,
                                    fontSize: ScreenUtil().setSp(14)),
                              ),
                            ),
                          ],
                        );
                      }
                    } else if (orderSettingModel
                            .data!.data!.freeDeliveryAmount ==
                        0) {
                      if (orderSettingModel.data!.data!.distance! <=
                          orderSettingModel.data!.data!.freeDeliveryDistance!) {
                        return Text('Delivery Free');
                      } else {
                        print(_cartController.calculatedAmount);
                        _cartController.deliveryCharge =
                            _cartController.calculatedAmount * 0.1;
                        _cartController.calculatedAmount +=
                            _cartController.deliveryCharge;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery Charges",
                              style: TextStyle(
                                  fontFamily: Constants.appFont,
                                  fontSize: ScreenUtil().setSp(16)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(10)),
                              child: Text(
                                _cartController.deliveryCharge
                                    .toStringAsFixed(2),
                                style: TextStyle(
                                    fontFamily: Constants.appFont,
                                    fontSize: ScreenUtil().setSp(14)),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                    return Container();
                  }
                } else {
                  return Container();
                }
              }(),
              SizedBox(
                height: ScreenConfig.blockHeight,
              ),
              DottedLine(
                dashColor: Colors.black,
              ),
              SizedBox(
                height: ScreenConfig.blockHeight,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TOTAL",
                    style: TextStyle(
                        fontFamily: Constants.appFont,
                        color: Color(Constants.colorTheme),
                        fontSize: ScreenUtil().setSp(16)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                    child: Text(
                      _cartController.calculatedAmount.toStringAsFixed(2),
                      style: TextStyle(
                          fontFamily: Constants.appFont,
                          color: Color(Constants.colorTheme),
                          fontSize: ScreenUtil().setSp(14)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenConfig.blockHeight,
              ),
              Container(
                // height: 30,
                // color: Colors.red,
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white.withOpacity(0.4)),
                child: TextFormField(
                  // minLines: 1,
                  // maxLines: 3,
                  controller: notesController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        // vertical: (38 - 15) / 2,
                      ),
                      border: InputBorder.none,
                      hintText: "Enter Notes",
                      hintStyle: TextStyle(
                          color: Colors.black26,
                          fontSize: 15,
                          fontFamily: "ProximaNova")),
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            //primaryColor: const Color(0xFF8CE7F1),
            backgroundColor: Color(Constants.colorTheme),
            unselectedWidgetColor: Colors.white,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.light(primary: Color(Constants.colorTheme))
                .copyWith(secondary: const Color(0xFF8CE7F1)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            //primaryColor: const Color(0xFF8CE7F1),
            dialogBackgroundColor: Color(Constants.colorTheme),
            //unselectedWidgetColor: Colors.white,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.light(primary: Color(Constants.colorTheme))
                .copyWith(secondary: const Color(0xFF8CE7F1)),
          ),
          child: child!,
        );
      },
    );
  }

  addButton(int index) {
    double diningAmount =
        _cartController.cartMaster!.cart[index].diningAmount! /
            _cartController.cartMaster!.cart[index].quantity;
    _cartController.cartMaster!.cart[index].diningAmount =
        _cartController.cartMaster!.cart[index].diningAmount! + diningAmount;
    double amount = _cartController.cartMaster!.cart[index].totalAmount /
        _cartController.cartMaster!.cart[index].quantity;
    _cartController.cartMaster!.cart[index].quantity++;
    _cartController.cartMaster!.cart[index].totalAmount += amount;
    setState(() {});
  }

  removeButton(int index) {
    if (_cartController.cartMaster!.cart[index].quantity == 1) {
      _cartController.cartMaster!.cart.removeAt(index);
    } else {
      double diningAmount =
          _cartController.cartMaster!.cart[index].diningAmount! /
              _cartController.cartMaster!.cart[index].quantity;
      _cartController.cartMaster!.cart[index].diningAmount =
          _cartController.cartMaster!.cart[index].diningAmount! - diningAmount;
      double amount = _cartController.cartMaster!.cart[index].totalAmount /
          _cartController.cartMaster!.cart[index].quantity;
      _cartController.cartMaster!.cart[index].quantity--;
      _cartController.cartMaster!.cart[index].totalAmount -= amount;
    }
    setState(() {});
  }
}
