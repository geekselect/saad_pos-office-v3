import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class SideBarGridTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function()? onTap;

  const SideBarGridTile({Key? key, required this.icon, required this.title,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(4.0),
          height: 100,
          width: 120,
          decoration: BoxDecoration(
            color: Color(Constants.colorTheme),
            borderRadius: BorderRadius.all(Radius.circular(16.0))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon,color: Colors.white,),
              Text(title,style: TextStyle(color: Colors.white,),
              textAlign: TextAlign.center,)
            ],
          ),
        ));
  }
}
