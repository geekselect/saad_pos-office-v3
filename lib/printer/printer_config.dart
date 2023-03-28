import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/utils/app_toolbar_with_btn_clr.dart';

import '../../config/Palette.dart';
import '../../constant/app_strings.dart';
import '../../widgets/custom_appbar.dart';
import '../utils/constants.dart';
import '../widgets/custom_text_form_field.dart';

class IPAddressValidator {
  static bool isValidIPAddress(String ip) {
    final regex =
        r'^(([01]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.){3}([01]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])$';
    return RegExp(regex).hasMatch(ip);
  }
}

class PortNumberValidator {
  static bool isValidPortNumber(String port) {
    final regex =
        r'^([1-9]|[1-9]\d{1,3}|[1-5]\d{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$';
    return RegExp(regex).hasMatch(port);
  }
}

class PrinterConfig extends StatefulWidget {
  const PrinterConfig({Key? key}) : super(key: key);

  @override
  State<PrinterConfig> createState() => _PrinterConfigState();
}

class _PrinterConfigState extends State<PrinterConfig> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController posIpEditingController = TextEditingController();
  TextEditingController posPortEditingController = TextEditingController();
  TextEditingController kitchenIpEditingController = TextEditingController();
  TextEditingController kitchenPortEditingController = TextEditingController();
  final box = GetStorage();

  void _validateIPAddress(String ip) {
    setState(() {
      if (IPAddressValidator.isValidIPAddress(ip)) {
        print("NO error");
      } else {
        print('Invalid IP address');
      }
    });
  }

  void _validatePortNumber(String port) {
    setState(() {
      if (PortNumberValidator.isValidPortNumber(port)) {
        print("NO port error");
      } else {
        print('Invalid port number');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    posIpEditingController.text = box.read(Constants.posIp) ?? '';
    if (box.read(Constants.posPort) != null) {
      if (box.read(Constants.posPort) != 0) {
        posPortEditingController.text = box.read(Constants.posPort).toString();
      } else {
        posPortEditingController.text = '';
      }
    } else {
      posPortEditingController.text = '';
    }
    print("pos ip ${box.read(Constants.posIp)}");
    print("pos port ${box.read(Constants.posPort)}");
    kitchenIpEditingController.text = box.read(Constants.kitchenIp) ?? '';
    if (box.read(Constants.kitchenPort) != null) {
      if (box.read(Constants.kitchenPort) != 0) {
        kitchenPortEditingController.text = box.read(Constants.kitchenPort).toString();
      } else {
        kitchenPortEditingController.text = '';
      }
    } else {
      kitchenPortEditingController.text = '';
    }
    print("kitchen ip ${box.read(Constants.kitchenIp)}");
    print("kitchen port ${box.read(Constants.kitchenPort)}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: ApplicationToolbarWithClrBtn(
          appbarTitle: 'Printer Configuration',
          // str_button_title: Languages.of(context).labelClearList,
          strButtonTitle: "",
          btnColor: Color(Constants.colorLike),
          onBtnPress: () {},
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image:
          //             Image.asset('assets/images/fluttertutorial.net-logo.png')
          //                 .image,
          //         fit: BoxFit.cover)),
          decoration: BoxDecoration(
              color: Color(Constants.colorScreenBackGround),
              image: DecorationImage(
                image: AssetImage('images/ic_background_image.png'),
                fit: BoxFit.cover,
              )),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: 'Printer Config'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Text(
                    'POS Printer IP',
                    style: TextStyle(
                        color: Palette.loginhead,
                        fontSize: 16,
                        fontFamily: proxima_nova_bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextFromfield(
                    // onChanged: (text) {
                    //   _validateIPAddress(text);
                    // },
                    controller: posIpEditingController,
                    hintText: 'Enter POS IP',
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter pos ip';
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Text(
                    'POS Printer PORT',
                    style: TextStyle(
                        color: Palette.loginhead,
                        fontSize: 16,
                        fontFamily: proxima_nova_bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextFromfield(
                    // onChanged: (text) {
                    //   _validatePortNumber(text);
                    // },
                    controller: posPortEditingController,
                    hintText: 'Enter POS Printer Port',
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter pos  printer port';
                      }
                    }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Text(
                    'Kitchen Printer IP',
                    style: TextStyle(
                        color: Palette.loginhead,
                        fontSize: 16,
                        fontFamily: proxima_nova_bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextFromfield(
                  // onChanged: (text) {
                  //   _validateIPAddress(text);
                  // },
                    controller: kitchenIpEditingController,
                    hintText: 'Enter Kitchen IP',
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter kitchen ip';
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Text(
                    'Kitchen Printer PORT',
                    style: TextStyle(
                        color: Palette.loginhead,
                        fontSize: 16,
                        fontFamily: proxima_nova_bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextFromfield(
                  // onChanged: (text) {
                  //   _validatePortNumber(text);
                  // },
                    controller: kitchenPortEditingController,
                    hintText: 'Enter kitchen Printer Port',
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter Kitchen  printer port';
                      }
                    }),
              ],
            ),
          ),
        ),
        bottomNavigationBar: MaterialButton(
          height: 45,
          minWidth: MediaQuery.of(context).size.width * 0.8,
          color: Color(colorTheme),
          textColor: Colors.white,
          child: Text(
            'Update Config',
            style: TextStyle(fontFamily: proxima_nova_reg, fontSize: 16),
          ),
          onPressed: () async {
            // if (_formKey.currentState!.validate() == true) {
            //   int intValue = int.tryParse(portEditingController.text) ?? 0;
            //   box.write(Constants.ip, ipEditingController.text ??= '');
            //   box.write(Constants.port, intValue);
            //   Get.back();
            //   Get.snackbar('INFORMATION', 'Successfully updated');
            // } else {
            //   Get.snackbar('INFORMATION', 'Please fill the form');
            // }
            int? intValuePosPort = int.tryParse(posPortEditingController.text);
            box.write(Constants.posIp, posIpEditingController.text ??= '');
            box.write(Constants.posPort, intValuePosPort);
            int? intValueKitchenPort = int.tryParse(kitchenPortEditingController.text);
            box.write(Constants.kitchenIp, kitchenIpEditingController.text ??= '');
            box.write(Constants.kitchenPort, intValueKitchenPort);
            Get.back();
            Get.snackbar('INFORMATION', 'Successfully updated');
          },
          splashColor: Colors.white30,
        ),
      ),
    );
  }
}
