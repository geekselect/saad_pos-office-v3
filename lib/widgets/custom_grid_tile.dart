import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/utils/constants.dart';
//ignore: must_be_immutable
class CustomGridTile extends StatefulWidget {
  final IconData icon;
  final title;
  bool isActive;
  final Function()? onTap;
   CustomGridTile({Key? key,required this.icon,required this.title, this.isActive=false,required this.onTap}) : super(key: key);

  @override
  _CustomGridTileState createState() => _CustomGridTileState();
}

class _CustomGridTileState extends State<CustomGridTile> {
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: Get.height*0.3,
      child: InkWell(
        onTap:widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: widget.isActive ? Color(Constants.colorTheme) : Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  widget.icon,
                  size: 120,
                  color: widget.isActive
                      ? Colors.white
                      : Color(Constants.colorTheme),
                ),
                SizedBox(height: 10),
                Text(
                  widget.title,
                  style: TextStyle(
                      color: widget.isActive
                          ? Colors.white
                          : Color(0xffd12828)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
