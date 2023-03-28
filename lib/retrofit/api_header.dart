import 'package:dio/dio.dart';
import 'package:pos/controller/auth_controller.dart';
import 'package:pos/utils/constants.dart';
import 'package:pos/utils/preference_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RetroApi {

  Future<Dio> dioData()
  async{

    final dio = Dio();
  //   "Access-Control-Allow-Origin": "*",
  // "Access-Control-Allow-Methods": "GET,HEAD,POST,OPTIONS",
  // "Access-Control-Max-Age": "86400",
    // config your dio headers globally
    dio.options.headers["Accept"] = "application/json"; // config your dio headers globally
    dio.options.headers["Authorization"] = "Bearer ${(await SharedPreferences.getInstance()).getString(Constants.headerToken) ?? ''}"; // config your dio headers globally
    dio.options.headers["Content-Type"] = "application/x-www-form-urlencoded";
    dio.options.followRedirects = false;
    //dio.options.connectTimeout = 75000; //5s
    dio.options.connectTimeout = 20000; //5s
    dio.options.receiveTimeout = 20000;
    return dio;
  }
}