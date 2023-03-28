import 'package:flutter/material.dart';
import 'package:get/get.dart';
//ignore: must_be_immutable
class CustomAppBar extends StatefulWidget {
  final String title;
  IconButton? iconButton;
   CustomAppBar({Key? key,required this.title,this.iconButton}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SizedBox(height: Get.height*0.05,),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              //color: Colors.white.withOpacity(0.4)
    ),
         // color: Colors.transparent,
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

                widget.iconButton??Text(''),
              Text(widget.title,style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black,
                fontSize: 28,
              ),),
            ],
          ),
        ),
      ],
    );
  }
}
