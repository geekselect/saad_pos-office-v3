import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pos/model/order_history_list_model.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
class OrderHistoryController extends GetxController{
  RxList<OrderHistoryData> listOrderHistory = <OrderHistoryData>[].obs;


  Future<BaseModel<OrderHistoryListModel>> callGetOrderHistoryList(BuildContext context) async {
    OrderHistoryListModel response;
    try{
      response  = await  RestClient(await RetroApi().dioData()).showOrder();
      if (response.success!) {
        listOrderHistory.value=response.data!;
        // Navigator.of(context).push(Transitions(
        //     transitionType: TransitionType.fade,
        //     curve: Curves.bounceInOut,
        //     reverseCurve:
        //     Curves.fastLinearToSlowEaseIn,
        //     widget: OrderHistory(
        //       isFromProfile: true,
        //     )));
      } else {
        Constants.toastMessage('No Data');
      }

    }catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
  //  refreshOrderHistory(BuildContext context)async{
  //   var response;
  //   try{
  //     response  = await  RestClient(await RetroApi().dioData()).showOrder();
  //     if (response.success!) {
  //       listOrderHistory.value=response.data!;
  //       print("response ${response.data!.first.toJson()}");
  //     } else {
  //       Constants.toastMessage('No Data');
  //     }
  //
  //   }catch (error, stacktrace) {
  //     print("Exception occurred: $error stackTrace: $stacktrace");
  //     return BaseModel()..setException(ServerError.withError(error: error));
  //   }
  //   return BaseModel()..data = response;
  // }
  Future<BaseModel<OrderHistoryListModel>> refreshOrderHistory(BuildContext context)async{
    OrderHistoryListModel response;
    try{
      response  = await  RestClient(await RetroApi().dioData()).showOrder();
      if (response.success!) {
        listOrderHistory.value=response.data!;
      } else {
        Constants.toastMessage('No Data');
      }

    }catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
 }
