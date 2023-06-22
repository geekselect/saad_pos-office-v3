import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants extends GetxController{
  //static const String serverLink='http://192.168.18.25/ozpos/ozpos/public/api/';
  static const String serverLink =
      'http://www.menucart.com.au/ozpos/public/api/';
  //static const String serverLink='http://192.168.18.142/api/';
  //static const String serverLink='http://192.168.18.15/api/';
  /*map key*/
  static final String androidKey = 'AIzaSyCDcZlGMIvPlbwuDgQzlEkdhjVQVPnne4c';
  static final String iosKey = 'AIzaSyCDcZlGMIvPlbwuDgQzlEkdhjVQVPnne4c';
  static bool isMobile() => Get.width < 850;

  static bool isTablet() => Get.width < 1100 && Get.width >= 850;

  static bool isDesktop() => Get.width >= 1100;

  static int colorBlack = 0xFF090E21;
  static int colorGray = 0xFF999999;
  static int colorLightGray = 0xFFe8e8e8;
  static int colorLike = 0xFFff6060;
  static int colorLikeLight = 0xFFe2bcbc;
  static int
      //colorTheme = 0xFF06C168;
      colorTheme = 0xFFff6565;
  static int colorOrderPending = 0xFFF4AE36;
  static int colorOrderPickup = 0xFFd1286b;
  static int colorThemeOp = 0xFF9BE6C2;
  static int colorBackground = 0xFFFAFAFA;
  static int colorRate = 0xFFffc107;
  static int colorBlue = 0xFF1492e6;
  static int colorScreenBackGround = 0xFFf2f2f2;
  static int colorHint = 0xFFb9b9b9;
  static String appFont = 'Proxima';
  static String appFontBold = 'ProximaBold';

  static String registrationOTP = 'regOTP';
  static String registrationEmail = 'regEmail';
  static String registrationPhone = 'regPhone';
  static String registrationUserId = 'userId';

  static String bankIFSC = 'bank_IFSC';
  static String bankMICR = 'bank_MICR';
  static String bankACCName = 'bank_ACC_Name';
  static String bankACCNumber = 'bank_ACC_Number';

  static String loginOTP = 'loginOTP';
  static String loginEmail = 'loginEmail';
  static String loginPhone = 'loginPhone';
  static String loginUserId = 'loggeduserId';
  static String loginUserImage = 'loggedImage';
  static String loginUserName = 'loggedName';

/*  static String loginLanguage = 'loginLanguage';
  static String loginIFSC_CODE = 'loginIFSC_CODE';
  static String loginMICR_CODE = 'loginMICR_CODE';
  static String loginBankAccountName = 'loginBankAccountName';
  static String loginBankAccountNumber = 'loginBankAccountNumber';*/

  static String headerToken = 'headerToken';
  static String isLoggedIn = 'isLoggedIn';
  static String isKitchenLoggedIn = 'isKitchenLoggedIn';
  static String stripePaymentToken = 'stripePaymentToken';

  static String selectedAddress = 'selectedAddress';
  static String selectedAddressId = 'selectedAddressId';
  static String selectedLat = 'selectedLat';
  static String selectedLng = 'selectedLng';

  static String recentSearch = 'recentSearch';

  static String appSettingCurrency = 'appSettingCurrency';
  static String appSettingCurrencySymbol = 'appSettingCurrencySymbol';
  static String appSettingPrivacyPolicy = 'appSettingPrivacyPolicy';
  static String appSettingTerm = 'appSettingTerm';
  static String appAboutCompany = 'appAboutCompany';
  static String appSettingHelp = 'appSettingHelp';
  static String appSettingAboutUs = 'appSettingAboutUs';
  static String appSettingDriverAutoRefresh = 'appSettingDriverAutoRefresh';
  static String appSettingBusinessAvailability =
      'appSettingBusiness_availability';
  static String appSettingBusinessMessage = 'appSettingBusiness_message';
  static String appSettingCustomerAppId = 'appSettingCustomerAppId';
  static String appSettingAndroidCustomerVersion =
      'appSetting_android_customer_version';
  static String appSettingIsPickup = 'appSetting_isPickup';
  static String appPushOneSingleToken = 'push_oneSingleToken';

  static String previousLat = 'previousLat';
  static String previousLng = 'previousLng';

  // payment Setting
  static String appPaymentWallet = 'appPaymentWallet';
  static String appPaymentCOD = 'appPaymentCOD';
  static String appPaymentStripe = 'appPaymentStripe';
  static String appPaymentRozerPay = 'appPaymentRozerPay';
  static String appPaymentPaypal = 'appPaymentPaypal';
  static String appStripePublishKey = 'appStripePublishKey';
  static String appStripeSecretKey = 'appStripeSecretKey';
  static String appPaypalProduction = 'appPaypalProducation';
  static String appPaypalClientId = 'appPaypal_client_id';
  static String appPaypalSecretKey = 'appPaypal_secret_key';
  static String appPaypalSendBox = 'appPaypalSendbox';
  static String appRozerpayPublishKey = 'appRozerpayPublishKey';
  static String cartMasterkey = 'cartMasterkey';
  static String vendorBearerToken = 'vendorBearerToken';
  static String posIp = 'posIp';
  static String posPort = 'posPort';
  static String kitchenIp = 'kitchenIp';
  static String kitchenPort = 'kitchenPort';
  static String vendorName = 'vendorName';
  static String baseLink = 'https://v4.ozfoodz.com.au/api';
  static String vendorBaseLink = '$baseLink/kitchen/';
  static String vendorId = 'vendorId';
  static String shiftName = 'auto_generated_shift_code';
  static String shiftCode = 'shiftCode';
  static Color secondaryColor = Color(0xfff2f7fb);
  static Color yellowColor = Color(0xffffbb2e);
  static int order_main_id = 0;

  static var kAppLabelWidget = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
      fontFamily: Constants.appFontBold);

  static var kTextFieldInputDecoration = InputDecoration(
    hintStyle: TextStyle(color: Color(Constants.colorHint)),
    errorStyle: TextStyle(fontFamily: Constants.appFontBold, color: Colors.red),
    filled: true,
    fillColor: Colors.white,
    contentPadding:
        const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0, right: 14),
    errorMaxLines: 2,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: BorderSide(width: 0.5, color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: BorderSide(width: 0.5, color: Colors.grey),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: BorderSide(width: 0.5, color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: BorderSide(width: 0.5, color: Colors.grey),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: BorderSide(width: 0.5, color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: BorderSide(width: 1, color: Colors.red),
    ),
  );

  static toastMessage(String msg) {

    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(Constants.colorTheme),
        textColor: Colors.white,
        fontSize: 16.0);
    // Toast.show(msg, duration: 8, gravity: 0);
  }

  static onLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(Constants.colorTheme)),
                SizedBox(width: 20),
                Text('Please Wait'),
              ],
            ),
          ),
        );
      },
    );
  }

  static hideDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
