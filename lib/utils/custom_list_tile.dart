// // import 'package:flutter/material.dart';
// // import 'package:pos/config/screen_config.dart';
// //
// // import 'constants.dart';
// //
// // class CustomListTile extends StatefulWidget {
// //   final String title;
// //   final String price;
// //   final String diningPrice;
// //   final bool checkboxValue;
// //   final Function(bool?) onChange;
// //   const CustomListTile({Key? key,required this.title,required this.price,required this.checkboxValue,required this.onChange,required this.diningPrice}) : super(key: key);
// //
// //   @override
// //   _CustomListTileState createState() => _CustomListTileState();
// // }
// //
// // class _CustomListTileState extends State<CustomListTile> {
// //   @override
// //   Widget build(BuildContext context) {
// //     ScreenConfig().init(context);
// //     return  CheckboxListTile(
// //       contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
// //       title:Text(widget.title) ,
// //       subtitle: Row(
// //         children: [
// //           Text(widget.price),
// //           SizedBox(width: 5,),
// //           Text(widget.diningPrice),
// //         ],
// //       ),
// //       // isThreeLine:true,
// //       value: widget.checkboxValue,
// //       onChanged: widget.onChange,
// //       checkColor: Colors.white,
// //       activeColor: Color(Constants.colorTheme),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:pos/config/screen_config.dart';
//
// import 'constants.dart';
//
// class CustomListTile extends StatefulWidget {
//   final String title;
//   final String price;
//   final String diningPrice;
//   final bool checkboxValue;
//   final Function(bool?) onChange;
//
//   const CustomListTile({
//     Key? key,
//     required this.title,
//     required this.price,
//     required this.diningPrice,
//     required this.checkboxValue,
//     required this.onChange,
//   }) : super(key: key);
//
//   @override
//   _CustomListTileState createState() => _CustomListTileState();
// }
//
// class _CustomListTileState extends State<CustomListTile> {
//   @override
//   Widget build(BuildContext context) {
//     ScreenConfig().init(context);
//     return Padding(
//       padding: const EdgeInsets.only(left: 12),
//       child: Row(
//         children: [
//           CustomCheckbox(
//             value: widget.checkboxValue,
//             onChanged: widget.onChange,
//           ),
//           SizedBox(width: 60),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(widget.title, style: TextStyle(fontSize: 15)),
//               SizedBox(height: 4),
//               Row(
//                 children: [
//                   SizedBox(
//                     height: 4,
//                     width: 10,
//                   ),
//                   Text(widget.price, style: TextStyle(fontSize: 12)),
//                   SizedBox(
//                     height: 4,
//                     width: 10,
//                   ),
//                   Text(" Dining ${widget.diningPrice} ",
//                       style: TextStyle(fontSize: 12)),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class CustomCheckbox extends StatelessWidget {
//   final bool value;
//   final Function(bool?) onChanged;
//
//   const CustomCheckbox({
//     Key? key,
//     required this.value,
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 38,
//       height: 38,
//       child: Checkbox(
//         value: value,
//         onChanged: onChanged,
//         checkColor: Colors.white,
//         activeColor: Color(Constants.colorTheme),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:pos/config/screen_config.dart';
//
// import 'constants.dart';
//
// class CustomListTile extends StatefulWidget {
//   final String title;
//   final String price;
//   final String diningPrice;
//   final bool checkboxValue;
//   final Function(bool?) onChange;
//   const CustomListTile({Key? key,required this.title,required this.price,required this.checkboxValue,required this.onChange,required this.diningPrice}) : super(key: key);
//
//   @override
//   _CustomListTileState createState() => _CustomListTileState();
// }
//
// class _CustomListTileState extends State<CustomListTile> {
//   @override
//   Widget build(BuildContext context) {
//     ScreenConfig().init(context);
//     return  CheckboxListTile(
//       contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
//       title:Text(widget.title) ,
//       subtitle: Row(
//         children: [
//           Text(widget.price),
//           SizedBox(width: 5,),
//           Text(widget.diningPrice),
//         ],
//       ),
//       // isThreeLine:true,
//       value: widget.checkboxValue,
//       onChanged: widget.onChange,
//       checkColor: Colors.white,
//       activeColor: Color(Constants.colorTheme),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pos/config/screen_config.dart';

import 'constants.dart';

class CustomListTile extends StatefulWidget {
  final String title;
  final String price;
  final String diningPrice;
  final bool checkboxValue;
  final Function(bool?) onChange;

  const CustomListTile({
    Key? key,
    required this.title,
    required this.price,
    required this.diningPrice,
    required this.checkboxValue,
    required this.onChange,
  }) : super(key: key);

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Row(
        children: [
          CustomCheckbox(
            value: widget.checkboxValue,
            onChanged: widget.onChange,
          ),
          SizedBox(width: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.title, style: TextStyle(fontSize: 15)),
              SizedBox(height: 4),
              Row(
                children: [
                  SizedBox(
                    height: 4,
                    width: 10,
                  ),
                  Text(widget.price, style: TextStyle(fontSize: 12)),
                  SizedBox(
                    height: 4,
                    width: 10,
                  ),
                  Text(" Dining ${widget.diningPrice} ",
                      style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 27,
      height: 27,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        checkColor: Colors.white,
        activeColor: Color(Constants.colorTheme),
      ),
    );
  }
}
