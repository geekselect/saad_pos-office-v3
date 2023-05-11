import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoPrinterController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadAutoPrint();
  }
  RxBool autoPrintKitchen = true.obs;

  Future<void> saveAutoPrintKitchen(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    autoPrintKitchen.value = value;
    prefs.setBool('autoPrintKitchen', value);
  }

  RxBool autoPrint = true.obs;

  Future<void> saveAutoPrint(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    autoPrint.value = value;
    prefs.setBool('autoPrintPOS', value);
  }

  Future<void> loadAutoPrint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    autoPrint.value = prefs.getBool('autoPrintPOS') ?? true;
    autoPrintKitchen.value = prefs.getBool('autoPrintKitchen') ?? true;
  }

}