import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/model/shift_model.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftController extends GetxController {
  Rx<DateTime> startTime = DateTime.now().obs;
  Rx<int> shiftDuration = 0.obs;
  RxBool createButtonEnable = false.obs;
  final TextEditingController shiftTextController = TextEditingController();
  final GlobalKey<FormState> formShiftKey = GlobalKey<FormState>();
  Timer? timer;

  RxList<ShiftModel> shiftsList = <ShiftModel>[].obs;


  Future<BaseModel<ShiftModel>> getShiftDetails(BuildContext context, dynamic shiftName) async {
    ShiftModel response;
    final prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    String userId = prefs.getString(Constants.loginUserId.toString()) ?? '';
    try {
      Constants.onLoading(context);
      response = await RestClient(await RetroApi().dioData()).createShift(
          int.parse(vendorId.toString()),
          int.parse(userId.toString()),
          shiftName);
      prefs.setString(
          Constants.shiftCode.toString(), response.shiftCode.toString());
      prefs.setString(
          Constants.shiftName.toString(), response.shiftName.toString());
      Constants.hideDialog(context);
      // timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //   shiftDuration.value = DateTime.now().difference(startTime.value).inSeconds;
      // });
    } catch (error, stacktrace) {
      print("Exception occurred printer: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<ListShiftModel>> getShiftAllDetails(BuildContext context) async {
    ListShiftModel response;
    final prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    String userId = prefs.getString(Constants.loginUserId.toString()) ?? '';
    try {
      createButtonEnable.value == false;
      Constants.onLoading(context);
      response = await RestClient(await RetroApi().dioData()).getAllShifts(
          int.parse(vendorId.toString()),
          int.parse(userId.toString()));
      if (response.success!) {
        shiftsList.value = response.data!;
      } else {
        Constants.toastMessage('No Data');
      }
     print("response ${response.toJson()}");
      Constants.hideDialog(context);
    } catch (error, stacktrace) {
      print("Exception occurred printer: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  void cancelShift() {
    timer?.cancel();
    shiftDuration.value = 0;
    startTime.value = DateTime.now();
  }


  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
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






