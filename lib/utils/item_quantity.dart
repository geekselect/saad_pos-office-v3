import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/config/screen_config.dart';
import 'package:pos/controller/cart_controller.dart';
import 'package:pos/model/cart_master.dart' as cartMaster;
// import 'package:pos/screens/bottom_navigation/dashboard_screen.dart';
import 'package:pos/utils/rounded_corner_app_button.dart';

import 'constants.dart';
class ItemQuantity extends StatefulWidget {
  final Function btnPlusOnPressed;
  final Function btnMinusOnPressed;
  final Function btnFloatOnPressed;

  ItemQuantity({Key? key,required this.btnPlusOnPressed,required this.btnMinusOnPressed,required this.btnFloatOnPressed}) : super(key: key);

  @override
  _ItemQuantityState createState() => _ItemQuantityState();
}

class _ItemQuantityState extends State<ItemQuantity> {
  final CartController _cartController=Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    if(_cartController.quantity.value==0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              RoundedCornerAppButton(btnLabel: 'ADD TO CART', onPressed: ()async{
                await widget.btnFloatOnPressed();
                _cartController.cartItemQuantity.value=_cartController.cartMaster!.cart.length;
                checkCartTotalItemQuantity();
                Constants.toastMessage('"${_cartController.quantity} Item added to cart"');
                _cartController.refreshScreen.value=toggleBoolValue(_cartController.refreshScreen.value);
                // Get.back();
                setState(() {

                });

              }),
              SizedBox(width: 5,),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(Constants.colorTheme)),
                      // set the height to 50
                      fixedSize: MaterialStateProperty.all<Size>(Size(140, 40)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),

                    child: Text(
                      'Close',
                      style: TextStyle(
                          fontFamily: Constants.appFont,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: 16.0),
                    ),
                  ),
                  onPressed: (){
                    Get.back();
                  }),
            ],
          ),
        ],
      );
    }else{
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4.0,horizontal: 4.0),
                width: ScreenConfig.screenWidth,
                height: ScreenConfig.blockHeight*5,
                decoration: BoxDecoration(
                  color: Color(Constants.colorTheme),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      // color: Colors.white,\
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child:GestureDetector(
                            onTap: ()async{
                              await widget.btnPlusOnPressed();
                              _cartController.cartItemQuantity.value=_cartController.cartMaster!.cart.length;
                              checkCartTotalItemQuantity();
                              _cartController.refreshScreen.value=toggleBoolValue(_cartController.refreshScreen.value);
                              // Get.back();
                              setState(() {

                              });

                            },
                            child: Icon(CupertinoIcons.add)),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text('${_cartController.quantity}',style: TextStyle(
                      color: Colors.white
                    ),),
                    SizedBox(width: 5,),
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child:GestureDetector(
                            onTap: ()async{
                              await widget.btnMinusOnPressed();
                              _cartController.cartItemQuantity.value=_cartController.cartMaster!.cart.length;
                             checkCartTotalItemQuantity();
                              Constants.toastMessage('Item removed from cart');
                              _cartController.refreshScreen.value=toggleBoolValue(_cartController.refreshScreen.value);
                              setState(() {

                              });
                            } ,
                            child: Icon(CupertinoIcons.minus)),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(width: 5,),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(Constants.colorTheme)),
                  // set the height to 50
                  fixedSize: MaterialStateProperty.all<Size>(Size(140, 40)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                        )
                    )
                ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),

                child: Text(
                  'Close',
                  style: TextStyle(
                      fontFamily: Constants.appFont,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontSize: 16.0),
                ),
              ),
              onPressed: (){
    Get.back();
    }),


            // RoundedCornerAppButton(btnLabel: 'Checkout', onPressed: (){
            //   Get.to(()=>DashboardScreen(2));
            // })
          ],
        ),
      );
    }

  }
  checkCartTotalItemQuantity(){
    _cartController.cartTotalQuantity.value=0;
    for(cartMaster.Cart cart in _cartController.cartMaster!.cart){
      _cartController.cartTotalQuantity.value+=cart.quantity;
    }
  }
  bool toggleBoolValue(bool value){
    if(value){
      return false;
    }else{
      return true;
    }
  }
}

