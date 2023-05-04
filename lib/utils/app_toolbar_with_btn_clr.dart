import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/pages/pos/pos_menu.dart';

import 'constants.dart';

class ApplicationToolbarWithClrBtn extends StatelessWidget with PreferredSizeWidget {
  ApplicationToolbarWithClrBtn({required this.appbarTitle,required this.strButtonTitle,required this.btnColor,required this.onBtnPress});

  final String appbarTitle,strButtonTitle;
  final Color btnColor;
  final Function onBtnPress;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
        Get.offAll(()=> PosMenu(isDining: false));
      },),
      elevation: 0.0,
      title: Text(
        appbarTitle,
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20.0,
            fontFamily: Constants.appFontBold),
      ),
      actions: [
        GestureDetector(
          onTap: onBtnPress as void Function()?,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(strButtonTitle,
              style: TextStyle(
                fontSize: 14,
                color: btnColor
              ),),
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
