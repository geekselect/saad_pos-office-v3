///Remove folders
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pos/controller/auto_printer_controller.dart';
import 'package:pos/controller/dining_cart_controller.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/pages/order/OrdersScreen.dart';
import 'package:pos/pages/pos/pos_menu.dart';
import 'package:pos/pages/selection_screen.dart';
import 'package:pos/received_notification.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/auth_controller.dart';
import 'controller/cart_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'controller/order_controller.dart';
import 'controller/order_history_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  print(message.data);
}
void selectNotification(NotificationResponse? notificationResponse) async {
  print('payload');
  print(notificationResponse?.payload);
  //Handle notification tapped logic here
}
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    '12345', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

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
  final prefs = await SharedPreferences.getInstance();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');
  final List<DarwinNotificationCategory> darwinNotificationCategories =
  <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];
  final DarwinInitializationSettings initializationSettingsDarwin =
  DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      //   didReceiveLocalNotificationSubject.add(
      //     ReceivedNotification(
      //       id: id,
      //       title: title,
      //       body: body,
      //       payload: payload,
      //     ),
      //   );
    },
    notificationCategories: darwinNotificationCategories,
  );
  final InitializationSettings initializationSettings =
  InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: null);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: selectNotification);
  FirebaseMessaging.onMessage.listen((RemoteMessage message)async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      print(channel.id);
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              '12345', // id
              'High Importance Notifications',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker',
              showWhen: false,
              styleInformation: BigTextStyleInformation(notification.body??''),
              // other properties...
            ),
          ));
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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

  OrderController orderController =   Get.put(OrderController());
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
          smartManagement: SmartManagement.onlyBuilder,
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
            colorScheme: ThemeData().colorScheme.copyWith(
                primary: Color(Constants.colorTheme),
                secondary: Color(Constants.colorTheme).withOpacity(0.4),
            ),
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
