import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pos/pages/selection_screen.dart';
import 'package:pos/utils/constants.dart';

import 'auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  _SplashScreenState(){

    //  Timer(
    //   Duration(milliseconds: 10),(){
    //     setState(() {
    //       _isVisible = true; // Now it is showing fade effect and navigating to Login page
    //     });
    //   }
    // );

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration:  BoxDecoration(
        gradient:  LinearGradient(
          colors: [Color(Constants.colorTheme), Color(Constants.colorTheme).withOpacity(0.9),],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: Duration(milliseconds: 1200),
        child: Center(
          child: Image.asset('images/ozpos_logo.png'),
        ),
      ),
    );
  }
}