import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShortCutButton extends StatelessWidget {
  final String? value;
  final VoidCallback? onTapped;

  const ShortCutButton(
      {Key? key,
        required this.value,
        required this.onTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(left: 5,right: 5, bottom: 5),
        child: Container(
          height: Get.height*0.09,
            width: Get.width*0.2,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.green,
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