import 'package:flutter/material.dart';
import 'package:pos/utils/app_toolbar_with_btn_clr.dart';
import 'package:pos/utils/constants.dart';

class CustomerDataScreen extends StatelessWidget {
  const CustomerDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationToolbarWithClrBtn(
        appbarTitle: 'Customer Data',
        // str_button_title: Languages.of(context).labelClearList,
        strButtonTitle: "",
        btnColor: Color(Constants.colorLike),
        onBtnPress: () {},
      ),
    );
  }
}
