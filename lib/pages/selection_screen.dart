
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/common/theme_helper.dart';
import 'package:pos/controller/auth_controller.dart';
import 'package:pos/controller/auto_printer_controller.dart';
import 'package:pos/controller/cart_controller.dart';
import 'package:pos/controller/dining_cart_controller.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/pages/auth/kichen_login.dart';
import 'package:pos/pages/auth/login_page.dart';
import 'package:pos/utils/constants.dart';
import 'package:pos/widgets/custom_grid_tile.dart';

import 'forgot_password_page.dart';
import 'profile_page.dart';
import 'registration_page.dart';
import 'widgets/header_widget.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final OrderCustimizationController _orderCustimizationController=  Get.put(OrderCustimizationController());
  final CartController _cartController=  Get.put(CartController());
  final DiningCartController _diningController=  Get.put(DiningCartController());
  final AutoPrinterController _autoPrinterController=  Get.put(AutoPrinterController());
  final AuthController _authController=   Get.put(AuthController());
  double _headerHeight = 250;
  List<MyCard> orderList=[
    MyCard(isActive: false,),
    MyCard(isActive: false,),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true, Icons.login_rounded), //let's create a common header widget
            ),
            SizedBox(
              height: Get.height*.5,
              child: GridView.count(crossAxisCount: 2,
                physics:const NeverScrollableScrollPhysics(),
                childAspectRatio: ((Get.width/2)/(Get.height*0.25)/2),
                children: [
                CustomGridTile(title: 'POS',
                  icon: Icons.point_of_sale, onTap: () async{
                    setState(() {
                      for(int customGridTileIndex=0;customGridTileIndex<orderList.length;customGridTileIndex++)
                        orderList[customGridTileIndex].isActive=false;
                      orderList[0].isActive=true;
                      Get.to(()=>LoginPage());
                    });
                  },isActive: orderList[0].isActive,),
                CustomGridTile(title: 'RESTAURANT KITCHEN',
                  icon: Icons.kitchen, onTap: () async{
                    setState(() {
                      for(int customGridTileIndex=0;customGridTileIndex<orderList.length;customGridTileIndex++)
                        orderList[customGridTileIndex].isActive=false;
                      orderList[1].isActive=true;
                    });
                    Get.to(()=>KitchenLoginPage());
                  },isActive: orderList[1].isActive,),

              ],),
            ),
          ],
        ),
      ),
    );
  }
}
class MyCard {
  bool isActive;

  MyCard({this.isActive = false});
}