import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/pages/order/OrdersScreen.dart';
import 'package:pos/pages/pos/pos_menu.dart';
import 'package:pos/pages/selection_screen.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/auth_controller.dart';
import 'controller/cart_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'controller/order_controller.dart';
import 'controller/order_history_controller.dart';

class CustomImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    ImageCache imageCache = super.createImageCache();
    // Set your image cache size
    imageCache.maximumSizeBytes = 1024 * 1024 * 100; // 100 MB
    return imageCache;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

//flutter run -d chrome --web-renderer html
void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft,
  //   DeviceOrientation.landscapeRight,
  // ]);
  if (kReleaseMode) {
    CustomImageCache();
  }
  await GetStorage.init();
  Get.put(OrderCustimizationController());
  Get.put(CartController());
  Get.put(OrderHistoryController());
  Get.put(OrderController());
  Get.put(AuthController());
  final prefs = await SharedPreferences.getInstance();
  AuthController.sharedPreferences = prefs;
  runApp(LoginUiApp(
    sharedPreferences: prefs,
  ));
}

class LoginUiApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const LoginUiApp({Key? key, required this.sharedPreferences})
      : super(key: key);
  @override
  State<LoginUiApp> createState() => _LoginUiAppState();
}

class _LoginUiAppState extends State<LoginUiApp> {
  Future<FirebaseApp>? fbApp;
  OrderController orderController = Get.find<OrderController>();
  @override
  void initState() {
    if (kIsWeb) {
      fbApp = Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyCr8iiALRjdxKxk8CGdM10C8L4Q8yS7Ed4',
          databaseURL:
              'https://mealup-af29b-default-rtdb.asia-southeast1.firebasedatabase.app',
          appId: '1:502253922422:web:fea886f0137f9188701757',
          messagingSenderId: '502253922422',
          projectId: 'mealup-af29b',
        ),
      );
    } else {
      fbApp = Firebase.initializeApp();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(Get.width, Get.height),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (BuildContext context, Widget? widget) {
            Widget error = Text(
              '...rendering error...',
              style: TextStyle(color: Colors.red, fontSize: 20),
            );
            if (widget is Scaffold || widget is Navigator)
              // error = Scaffold(body: Center(child: error));
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                print(errorDetails.exception);
                print(errorDetails.stack);
                return error;
              };
            if (widget != null) return widget;
            throw ('widget is null');
          },
          title: 'OZPOS',
          // theme: ThemeData(
          //   visualDensity: VisualDensity.adaptivePlatformDensity,
          // ),
          theme: ThemeData(
            primaryColor: Color(Constants.colorTheme),
            splashColor: Colors.white,
            // secondaryHeaderColor: Color(Constants.colorTheme).withOpacity(0.4),
            // colorScheme: ColorScheme.fromSwatch().copyWith(
            //   secondary: Color(Constants.colorTheme).withOpacity(0.4), // Your accent color
            // ),
            accentColor: Color(Constants.colorTheme).withOpacity(0.4),
            // scaffoldBackgroundColor: Colors.red,
            primarySwatch: Colors.red,
          ),
          home: child,
          // SelectionScreen(),
        );
      },
      child: FutureBuilder(
          future: fbApp,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (widget.sharedPreferences.getBool(Constants.isLoggedIn) ??
                  false) {
                return PosMenu(isDining: false);
              } else if (widget.sharedPreferences
                      .getBool(Constants.isKitchenLoggedIn) ??
                  false) {
                orderController.getOrders('NewOrders');
                return OrderScreen(title: 'Kitchen', apiName: 'NewOrders');
              } else {
                return

                    ///
                    // PosPayment()
                    SelectionScreen();
              }
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text(snapshot.error.toString()),
                ),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: SpinKitFadingCircle(
                    color: Color(Constants.colorTheme),
                  ),
                ),
              );
            }
          }),
    );
  }
}
