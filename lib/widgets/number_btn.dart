import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/utils/constants.dart';

class NumberButton extends StatelessWidget {
  final String? value;
  final VoidCallback? onTapped;
  final Color btnColor;

  const NumberButton(
      {Key? key,
        required this.value,
        required this.onTapped,
      this.btnColor=const Color(0xFFd12828)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(left: 5,right: 5, bottom: 5),
        child: Container(
          height: Get.height*0.09,
          // width: Get.width/7,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            //borderRadius: const BorderRadius.all(Radius.r(60)),
            color: btnColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: Text(
              value!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Dosis',
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
      onTap: onTapped!,
    );
  }
}
