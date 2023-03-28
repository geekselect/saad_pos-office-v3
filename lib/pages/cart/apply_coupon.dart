import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:pos/config/screen_config.dart';
import 'package:pos/controller/cart_controller.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:pos/screen_animation_utils/transitions.dart';
import 'package:pos/utils/constants.dart';

class ApplyCouppon extends StatefulWidget {
  final double totalPrice;
  const ApplyCouppon({Key? key,required this.totalPrice}) : super(key: key);

  @override
  _ApplyCoupponState createState() => _ApplyCoupponState();
}

class _ApplyCoupponState extends State<ApplyCouppon> {
  CartController _cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupons'),
      ),
      body: _cartController.listPromoCode.length !=
          0
          ? GridView
          .count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.50,
        padding: EdgeInsets.all(4.0),
        children: List.generate(
            _cartController.listPromoCode.length, (index) {
          return GestureDetector(
            onTap: () {

              final DateTime now = DateTime.now();
              final DateFormat formatter = DateFormat('y-MM-dd');
              final String orderDate = formatter.format(now);

              _cartController.callApplyPromoCall(context, _cartController.listPromoCode[index].name, orderDate, widget.totalPrice, _cartController.listPromoCode[index].id);
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        height: ScreenConfig.blockHeight*15,
                        width: ScreenUtil().setWidth(140),
                        imageUrl: _cartController.listPromoCode[index]
                            .image!,
                        fit: BoxFit.fill,
                        placeholder: (context, url) =>
                            SpinKitFadingCircle(
                                color: Color(Constants.colorTheme)),
                        errorWidget: (context, url, error) =>
                            Container(
                              child: Center(
                                  child: Image.asset('images/noimage.png')),
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(12)),
                    child: Text(
                      _cartController.listPromoCode[index].name!,
                      style: TextStyle(fontFamily: Constants.appFont,
                          fontSize: ScreenUtil().setSp(14)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(12)),
                    child: Text(
                      _cartController.listPromoCode[index].promoCode!,
                      style: TextStyle(
                        fontFamily: Constants.appFont,
                        fontSize: ScreenUtil().setSp(18),
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  Text(
                    _cartController.listPromoCode[index].displayText!,
                    style: TextStyle(fontFamily: Constants.appFont,
                        fontSize: ScreenUtil().setSp(12),
                        color: Color(Constants.colorTheme)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(12)),
                    child: Text(
                      'Valid Upto ${_cartController
                          .listPromoCode[index].startEndDate!.substring(
                          _cartController.listPromoCode[index].startEndDate!
                              .indexOf(" - ") + 1)}',
                      style: TextStyle(color: Color(Constants.colorGray),
                          fontFamily: Constants.appFont,
                          fontSize: ScreenUtil().setSp(12)),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      )
          : Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: ScreenUtil().setWidth(150),
              height: ScreenUtil().setHeight(180),
              image: AssetImage('images/ic_no_offer.png'),
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              child: Text(
                'No Offer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(18),
                  fontFamily: Constants.appFontBold,
                  color: Color(Constants.colorTheme),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
