import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/controller/timer_controller.dart';
import 'package:pos/model/msg_response_model.dart';
import 'package:pos/model/shift_model.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftController extends GetxController {
  final TimerController timerController = Get.put(TimerController());
  RxBool createButtonEnable = false.obs;
  final TextEditingController shiftTextController = TextEditingController();
  final GlobalKey<FormState> formShiftKey = GlobalKey<FormState>();
  RxList<ShiftModel> shiftsList = <ShiftModel>[].obs;
  RxString shiftCodeMain = ''.obs;
  RxString shiftNameMain = ''.obs;
  Future<BaseModel<MsgResModel>> createShiftDetails(
      BuildContext context, dynamic shiftName) async {
    MsgResModel response;
    final prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    String userId = prefs.getString(Constants.loginUserId.toString()) ?? '';
    Map<String, dynamic> body = {
      "vendor_id": vendorId,
      "user_id": userId,
      "shift_name": shiftName,
    };
    try {
      Constants.onLoading(context);
      response = await RestClient(await RetroApi().dioData()).createShift(body);
      print('response ${response.toJson()}');
      if (response.success) {
        Map<String, dynamic> res = response.msg as Map<String, dynamic>;
        ShiftModel shiftModel = ShiftModel.fromJson(res);
        prefs.setString(
            Constants.shiftCode.toString(), shiftModel.shiftCode.toString());
        prefs.setString(
            Constants.shiftName.toString(), shiftModel.shiftName.toString());
        shiftCodeMain.value = shiftModel.shiftCode.toString();
        shiftNameMain.value = shiftModel.shiftName.toString();
        timerController.startTimer();
      } else {
        createButtonEnable.value = false;
        Constants.toastMessage(response.msg!.toString());
      }
      Constants.hideDialog(context);
      shiftTextController.clear();
      Get.back();
    } catch (error, stacktrace) {
      print("Exception occurred printer: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<MsgResModel>> closeShiftDetails(BuildContext context) async {
    MsgResModel response;

    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(Constants.loginUserId.toString()) ?? '';
    String shiftCode = prefs.getString(Constants.shiftCode.toString()) ?? '';
    timerController.stopTimer();
    print("${timerController.elapsedTime}");
    dynamic shiftTime = timerController.elapsedTime.toString();
    try {
      Map<String, dynamic> body = {
        "user_id": userId,
        "shift_code": shiftCode,
        "shift_timer": shiftTime,
      };
      Constants.onLoading(context);
      response = await RestClient(await RetroApi().dioData()).closeShift(body);
      if (response.success) {
        prefs.setString(Constants.shiftCode.toString(), '');
        prefs.setString(Constants.shiftName.toString(), '');
        shiftCodeMain.value = '';
        shiftNameMain.value = '';
        timerController.timerDuration.value = Duration.zero;

        Constants.hideDialog(context);
        Constants.toastMessage(response.msg!.toString());
      } else {
        Constants.toastMessage(response.msg!);
      }
    } catch (error, stacktrace) {
      print("Exception occurred printer: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<ListShiftModel>> getShiftAllDetails(
      BuildContext context) async {
    ListShiftModel response;
    final prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    String userId = prefs.getString(Constants.loginUserId.toString()) ?? '';
    try {
      createButtonEnable.value == false;
      Constants.onLoading(context);
      response = await RestClient(await RetroApi().dioData()).getAllShifts(
          int.parse(vendorId.toString()), int.parse(userId.toString()));
        shiftsList.value = response.data!;
      // print("response ${response.toJson()}");
      Constants.hideDialog(context);
    } catch (error, stacktrace) {
      print("Exception occurred printer: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<MsgResModel>> getCurrentShiftDetails() async {
    MsgResModel response;
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(Constants.loginUserId.toString()) ?? '';
    try {
      response = await RestClient(await RetroApi().dioData())
          .getCurrentShift(int.parse(userId.toString()));
      if (response.success) {
        Map<String, dynamic> res = response.msg as Map<String, dynamic>;
        ShiftModel shiftModel = ShiftModel.fromJson(res);
        prefs.setString(
            Constants.shiftCode.toString(), shiftModel.shiftCode.toString());
        prefs.setString(
            Constants.shiftName.toString(), shiftModel.shiftName.toString());
        shiftCodeMain.value = shiftModel.shiftCode.toString();
        shiftNameMain.value = shiftModel.shiftName.toString();
        if(timerController.timerDuration.value == Duration.zero) {
          if (shiftModel.shiftTimer != null) {
            String durationString = shiftModel.shiftTimer;
            DateFormat durationFormat = DateFormat('H:m:s');
            DateTime durationDateTime = durationFormat.parse(durationString);
            Duration duration = Duration(
              hours: durationDateTime.hour,
              minutes: durationDateTime.minute,
              seconds: durationDateTime.second,
            );
            timerController.timerDuration.value = duration;
          }
          else {
            String durationString = '00:00:01.11111';
            DateFormat durationFormat = DateFormat('H:m:s');
            DateTime durationDateTime = durationFormat.parse(durationString);
            Duration duration = Duration(
              hours: durationDateTime.hour,
              minutes: durationDateTime.minute,
              seconds: durationDateTime.second,
            );
            timerController.timerDuration.value = duration;
          }
          timerController.startTimer();
        }
      } else {
        prefs.setString(Constants.shiftCode.toString(), '');
        prefs.setString(Constants.shiftName.toString(), '');
        shiftCodeMain.value = '';
        shiftNameMain.value = '';
        Constants.toastMessage(response.msg!.toString());
      }
    } catch (error, stacktrace) {
      print("Exception occurred printer: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<MsgResModel>> selectShiftDetails(BuildContext context,
      dynamic shiftCodeFunc, dynamic shiftNameFunc, dynamic timer) async {
    MsgResModel response;
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(Constants.loginUserId.toString()) ?? '';
    Map<String, dynamic> body = {
      "shift_code": shiftCodeFunc,
      "user_id": userId,
      "shift_timer_old": timer,
    };
    print("body select Shift ${body}");
    try {
      response = await RestClient(await RetroApi().dioData()).selectShift(body);
      // print('response select Shift function out ${response.toJson()}');
      if (response.success) {
        Map<String, dynamic> res = response.msg as Map<String, dynamic>;
        ShiftModel shiftModel = ShiftModel.fromJson(res);
        prefs.setString(
            Constants.shiftCode.toString(), shiftModel.shiftCode.toString());
        prefs.setString(
            Constants.shiftName.toString(), shiftModel.shiftName.toString());
        shiftCodeMain.value = shiftModel.shiftCode.toString();
        shiftNameMain.value = shiftModel.shiftName.toString();
        if (shiftModel.shiftTimer != null) {
          String durationString = shiftModel.shiftTimer;
          DateFormat durationFormat = DateFormat('H:m:s');
          DateTime durationDateTime = durationFormat.parse(durationString);
          Duration duration = Duration(
            hours: durationDateTime.hour,
            minutes: durationDateTime.minute,
            seconds: durationDateTime.second,
          );
          timerController.timerDuration.value = duration;
        }
        // else {
        //   String durationString = '00:00:01.11111';
        //   DateFormat durationFormat = DateFormat('H:m:s');
        //   DateTime durationDateTime = durationFormat.parse(durationString);
        //   Duration duration = Duration(
        //     hours: durationDateTime.hour,
        //     minutes: durationDateTime.minute,
        //     seconds: durationDateTime.second,
        //   );
        //   timerController.timerDuration.value = duration;
        // }
        timerController.startTimer();
      } else {
        Constants.toastMessage(response.msg!.toString());
      }
      Get.back();
    } catch (error, stacktrace) {
      print("Exception occurred printer: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}

// class ShiftDialog extends StatelessWidget {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Create Shift'),
//       content: Form(
//         key: _formKey,
//         child: Obx(
//               () => TextFormField(
//             controller: textEditingController,
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Please enter a shift name';
//               }
//               return null;
//             },
//             decoration: InputDecoration(
//               labelText: 'Shift Name',
//             ),
//             enabled: !shiftController.isButtonDisabled.value,
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             if (_formKey.currentState.validate()) {
//               String shiftName = textEditingController.text;
//               shiftController.createShift(shiftName);
//               Get.back();
//             }
//           },
//           child: Text('Create'),
//         ),
//       ],
//     );
//   }
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Shift Example',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Shift Example'),
//         ),
//         body: Center(
//           child: Obx(
//                 () => ElevatedButton(
//               onPressed: shiftController.isButtonDisabled.value
//                   ? null
//                   : () {
//                 Get.dialog(ShiftDialog());
//               },
//               child: Text('Create Shift'),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
