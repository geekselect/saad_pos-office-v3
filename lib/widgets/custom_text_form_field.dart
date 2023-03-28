import 'package:flutter/material.dart';
//ignore: must_be_immutable
class CustomTextFromfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  TextInputType textInputType;
  void Function(String)? onChanged;
  CustomTextFromfield({Key? key,this.onChanged, required this.controller,required this.hintText,required this.validator,this.textInputType=TextInputType.text}) : super(key: key);

  @override
  _CustomTextFromfieldState createState() => _CustomTextFromfieldState();
}

class _CustomTextFromfieldState extends State<CustomTextFromfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      // padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.4)),
        height: MediaQuery.of(context).size.height * 0.07,
        //width: MediaQuery.of(context).size.width * 0.55,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: Center(
            child: TextFormField(
              onChanged: widget.onChanged,
              controller: widget.controller,
              validator: widget.validator,
              keyboardType: widget.textInputType,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                      color: Colors.white54,
                      fontSize: 15,
                      fontFamily: "ProximaNova")),
              style:
              TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
