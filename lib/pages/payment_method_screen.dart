import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos/controller/auth_controller.dart';
import 'package:pos/controller/cart_controller.dart';
import 'package:pos/controller/order_history_controller.dart';
import 'package:pos/model/cartmodel.dart';
import 'package:pos/model/common_res.dart';
import 'package:pos/model/payment_setting_model.dart';
import 'package:pos/pages/pos/payment_stripe.dart';
import 'package:pos/pages/pos/pos_payement.dart';
import 'package:pos/pages/vendor_menu.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/pages/PaypalPayment.dart';
import 'package:pos/screen_animation_utils/transitions.dart';
import 'package:pos/utils/app_toolbar.dart';
import 'package:pos/utils/constants.dart';
import 'package:pos/utils/rounded_corner_app_button.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/cart_master.dart';
import 'OrderHistory/order_history.dart';

class PaymentMethodScreen extends StatefulWidget {
  final int? venderId,
      addressId,
      vendorDiscountId,tableNumber;
  final String? orderDate,
      orderTime,
      orderStatus,
      ordrePromoCode,
      customerName,
      customerPhone,
      orderDeliveryType,
      strTaxAmount,
      orderDeliveryCharge;
  final String? deliveryTime;
  final String? deliveryDate;
  // final double orderItem;
  final double? orderAmount,vendorDiscountAmount,subTotal;

  final List<Map<String, dynamic>>? allTax;

  // final List<String> orderItem;

  const PaymentMethodScreen(
      {Key? key,
      this.venderId,
        required this.customerName,
        required this.customerPhone,
      this.orderDeliveryType,
      this.orderDate,
      this.orderTime,
      this.orderAmount,
      this.addressId,
      this.orderDeliveryCharge,
      this.orderStatus,
      this.ordrePromoCode,
      this.vendorDiscountAmount,
      this.vendorDiscountId,
      this.strTaxAmount,
      this.allTax, this.subTotal,
        this.deliveryTime,
        this.deliveryDate,
      this.tableNumber})
      : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

// enum PaymentMethod { paypal, rozarpay, stripe, cashOnDelivery }

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int radioIndex = -1;
  String? orderPaymentType;
  CartController _cartController=Get.find<CartController>();

  // Razorpay _razorpay;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String strPaymentToken = '';

  String? stripePublicKey;
  String? stripeSecretKey;
  String? stripeToken;
  int? paymentTokenKnow;
  int? paymentStatus;
  String? paymentType;
  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool showSpinner = false;
  int? selectedIndex;

  List<int> listPayment = [];
  List<String> listPaymentName = [];
  List<String> listPaymentImage = [];
  OrderHistoryController _orderHistoryController=Get.find<OrderHistoryController>();

  @override
  void initState() {
    super.initState();
    callGetPaymentSettingAPI();
  }

  Future<BaseModel<PaymentSettingModel>> callGetPaymentSettingAPI() async {
    PaymentSettingModel response;
    try{
      final dio = Dio();
      dio.options.headers["Accept"] = "application/json"; // config your dio headers globally// config your dio headers globally
      dio.options.followRedirects = false;
      dio.options.connectTimeout = 5000; //5s
      dio.options.receiveTimeout = 3000;
      response  = await  RestClient(dio).paymentSetting();
      print(response.success);

      if (response.success!) {
        if (mounted)
          setState(() {
            AuthController.sharedPreferences?.setString(Constants.appPaymentCOD, response.data!.cod.toString());
            if(response.data!.wallet != null){
              AuthController.sharedPreferences?.setString(Constants.appPaymentWallet, response.data!.wallet.toString());
            }else{
              AuthController.sharedPreferences?.setString(Constants.appPaymentWallet, '0');
            }
            if(response.data!.stripe != null){
              AuthController.sharedPreferences?.setString(Constants.appPaymentStripe, response.data!.stripe.toString());
            }else{
              AuthController.sharedPreferences?.setString(Constants.appPaymentStripe, '0');
            }
            if(response.data!.razorpay != null){
              AuthController.sharedPreferences?.setString(Constants.appPaymentRozerPay, response.data!.razorpay.toString());
            }else{
              AuthController.sharedPreferences?.setString(Constants.appPaymentRozerPay, '0');
            }

            if(response.data!.paypal != null){
              AuthController.sharedPreferences?.setString(Constants.appPaymentPaypal, response.data!.paypal.toString());
            }else{
              AuthController.sharedPreferences?.setString(Constants.appPaymentPaypal, '0');
            }

            if(response.data!.stripePublishKey != null){
              AuthController.sharedPreferences?.setString(Constants.appStripePublishKey, response.data!.stripePublishKey.toString());
            }else{
              AuthController.sharedPreferences?.setString(Constants.appStripePublishKey, '0');
            }

            if(response.data!.stripeSecretKey != null){
              AuthController.sharedPreferences?.setString(Constants.appStripeSecretKey, response.data!.stripeSecretKey.toString());
            }else{
              AuthController.sharedPreferences?.setString(Constants.appStripeSecretKey, '0');
            }

            if(response.data!.paypalProduction != null){
              AuthController.sharedPreferences?.setString(Constants.appPaypalProduction, response.data!.paypalProduction.toString());
            }else{
              AuthController.sharedPreferences?.setString(Constants.appPaypalProduction, '0');
            }

            if(response.data!.stripeSecretKey != null){
              AuthController.sharedPreferences?.setString(Constants.appPaypalSendBox, response.data!.stripeSecretKey.toString());
            }else{
              AuthController.sharedPreferences?.setString(Constants.appPaypalSendBox, '0');
            }

            if(response.data!.paypalClientId != null){
              AuthController.sharedPreferences?.setString(Constants.appPaypalClientId, response.data!.paypalClientId.toString());
            }else{
              AuthController.sharedPreferences?.setString(Constants.appPaypalClientId, '0');
            }
            if(response.data!.paypalSecretKey != null){
              AuthController.sharedPreferences?.setString(Constants.appPaypalSecretKey, response.data!.paypalSecretKey.toString());
            }else{
              AuthController.sharedPreferences?.setString(Constants.appPaypalSecretKey, '0');
            }

            if(response.data!.razorpayPublishKey != null){
              AuthController.sharedPreferences?.setString(Constants.appRozerpayPublishKey, response.data!.razorpayPublishKey.toString());
            }else{
              AuthController.sharedPreferences?.setString(Constants.appRozerpayPublishKey, '0');
            }
          });
        if (AuthController.sharedPreferences?.getString(Constants.appPaymentCOD) == '1') {
          listPayment.add(0);
          listPaymentName.add('Cash on Delivery');
          listPaymentImage.add('images/cod.svg');
        } else {
          listPayment.remove(0);
          listPaymentName.remove('Cash on Delivery');
          listPaymentImage.remove('images/code.svg');
        }

        if (AuthController.sharedPreferences?.getString(Constants.appPaymentWallet) == '1') {
          listPayment.add(1);
          listPaymentName.add('MealUp Wallet');
          listPaymentImage.add('images/wallet.svg');
        } else {
          listPayment.remove(1);
          listPaymentName.remove('MealUp Wallet');
          listPaymentImage.remove('images/wallet.svg');
        }

        if (AuthController.sharedPreferences?.getString(Constants.appPaymentStripe) == '1') {
          listPayment.add(2);
          listPaymentName.add('Stripe');
          listPaymentImage.add('images/ic_stripe.svg');
        } else {
          listPayment.remove(2);
          listPaymentName.remove('Stripe');
          listPaymentImage.remove('images/ic_stripe.svg');
        }

        if (AuthController.sharedPreferences?.getString(Constants.appPaymentRozerPay) == '1') {
          listPayment.add(3);
          listPaymentName.add('Rozerpay');
          listPaymentImage.add('images/ic_rozar_pay.svg');
        } else {
          listPayment.remove(3);
          listPaymentName.remove('Rozerpay');
          listPaymentImage.add('images/ic_rozar_pay.svg');
        }

        if (AuthController.sharedPreferences?.getString(Constants.appPaymentPaypal) == '1') {
          listPayment.add(4);
          listPaymentName.add('PayPal');
          listPaymentImage.add('images/ic_paypal.svg');
        } else {
          listPayment.remove(4);
          listPaymentName.remove('PayPal');
          listPaymentImage.remove('images/ic_paypal.svg');
        }

        print('listPayment' + listPayment.length.toString());
      } else {
        Constants.toastMessage('No Data');
      }

    }catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }


  @override
  void dispose() {
    super.dispose();
  }

  void openCheckout() async {
   /* var options = {
      'key': SharedPreferenceUtil.getString(Constants.appRozerpayPublishKey),
      'amount': widget.orderAmount * 100,
      'name': SharedPreferenceUtil.getString(Constants.loginUserName),
      'description': 'Payment',
      'prefill': {
        'contact': SharedPreferenceUtil.getString(Constants.loginPhone),
        'email': SharedPreferenceUtil.getString(Constants.loginEmail)
      },
      'external': {
        'wallets': ['paytm']
      }
    };*/
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: ApplicationToolbar(
            appbarTitle: 'Payment Method',
          ),
          backgroundColor: Color(0xFFFAFAFA),
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/ic_background_image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              GestureDetector(
                                onTap: ()async{
                                  Get.to(PosPayment(
                                    userName: widget.customerPhone,
                                      mobileNumber: widget.customerName,
                                      totalAmount: widget.orderAmount??0.0,
                                      venderId: widget.venderId,
                                      addressId:widget.addressId,
                                      vendorDiscountId: widget.vendorDiscountId,
                                      tableNumber: widget.tableNumber,
                                      orderDate: widget.orderDate, orderTime: widget.orderTime,
                                      orderStatus: widget.orderStatus, ordrePromoCode: widget.ordrePromoCode, orderDeliveryType: widget.orderDeliveryType,
                                      strTaxAmount: widget.strTaxAmount, orderDeliveryCharge: widget.orderDeliveryCharge,
                                      deliveryTime: widget.deliveryTime, deliveryDate:widget.deliveryDate,
                                      vendorDiscountAmount: widget.vendorDiscountAmount, subTotal: widget.subTotal, allTax: widget.allTax));
                                  // await showDialog(context: context, builder: (context){
                                  //   return Center(
                                  //     child: Container(
                                  //       // margin: EdgeInsets.all(9.0),
                                  //       height: Get.height*0.8,
                                  //       width: Get.width*0.9,
                                  //       decoration:  BoxDecoration(
                                  //           color: Colors.white,
                                  //           border: Border.all(
                                  //             color: Colors.white,
                                  //           ),
                                  //           borderRadius: BorderRadius.all(Radius.circular(5))
                                  //       ),
                                  //       child: PosPayment(totalAmount: widget.orderAmount??0.0,),
                                  //     ),
                                  //   );
                                  // });
                                  // orderPaymentType = 'POS CASH';
                                  // changeIndex(0);

                                },
                                child: customRadioList(
                                    'POS CASH',
                                    0,
                                    Icon(Icons.payment),
                                0),
                              ),

                              GestureDetector(
                                onTap: (){
                                  orderPaymentType = 'POS CARD';
                                  changeIndex(1);
                                },
                                child: customRadioList(
                                  'POS CARD',
                                  0,
                                  Icon(Icons.payment),
                                1),
                              ),
                              GestureDetector(
                                onTap: (){
                                  orderPaymentType = 'CASH ON DELIVERY';
                                  changeIndex(2);
                                },
                                child: customRadioList(
                                    'COD',
                                    0,
                                    Icon(Icons.payment),
                                    2),
                              ),
                              GestureDetector(
                                onTap: (){
                                  orderPaymentType = 'STRIPE';
                                  changeIndex(3);
                                },
                                child: customRadioList(
                                    'STRIPE',
                                    2,
                                    Icon(Icons.payment),
                                    3),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: RoundedCornerAppButton(
                            onPressed: () {
                              if (orderPaymentType != null) {

                                if (orderPaymentType == 'STRIPE') {
                                  stripeSecretKey =
                                      AuthController.sharedPreferences?.getString(
                                          Constants.appStripeSecretKey);
                                  stripePublicKey =
                                      AuthController.sharedPreferences?.getString(
                                          Constants.appStripePublishKey);

                                  Get.to(()=>PaymentStripe(
                                    orderDeliveryType:
                                    widget.orderDeliveryType,
                                    orderAmount: widget.orderAmount,
                                    venderId: widget.venderId,
                                    ordrePromoCode: widget.ordrePromoCode,
                                    orderTime: widget.orderTime,
                                    orderDate: widget.orderDate,
                                    orderStatus: widget.orderStatus,
                                    orderDeliveryCharge:
                                    widget.orderDeliveryCharge,
                                    orderCustomization:
                                    '',
                                    addressId: widget.addressId,
                                    orderItem: [],
                                    vendorDiscountAmount: widget
                                        .vendorDiscountAmount!
                                        .toInt(),
                                    vendorDiscountId:
                                    widget.vendorDiscountId,
                                    allTax: widget.allTax,
                                    calculateTax: double.parse(widget.strTaxAmount!),
                                    subTotal: widget.subTotal,
                                    deliveryDate: widget.deliveryDate,
                                    deliveryTime: widget.deliveryTime,
                                    // strTaxAmount: widget.strTaxAmount,
                                  ));
                                } else {
                                  placeOrder();
                                }
                              } else {
                                Constants.toastMessage('Please Select Payment Method');
                              }
                            },
                            btnLabel:
                                'Place Your Order',
                          ),
                        ),
                      ],
                    )),
              );
            },
          )),
    );
  }

  void changeIndex(int index)async {
    setState(() {
      radioIndex = index;
    });
  }

  Widget customRadioList(String title, int index, Icon icon,int listIndex) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: ScreenUtil().setHeight(90),
        alignment: Alignment.center,
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: icon,
          ),
          title: Text(
            title,
            style: TextStyle(fontFamily: Constants.appFont, fontSize: 16),
          ),
          trailing: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: SizedBox(
                width: 25.0,
                height: ScreenUtil().setHeight(25),
                child: SvgPicture.asset(
                  radioIndex == listIndex
                      ? 'images/ic_completed.svg'
                      : 'images/ic_gray.svg',
                  width: 15,
                  height: ScreenUtil().setHeight(15),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // void testPrint(String printerIp, String? port,BuildContext ctx,or.Data data,CartMaster cartMaster) async {
  //   // TODO Don't forget to choose printer's paper size
  //   const PaperSize paper = PaperSize.mm80;
  //   final profile = await CapabilityProfile.load();
  //   final printer = NetworkPrinter(paper, profile);
  //   final PosPrintResult res = await printer.connect(printerIp, port: int.parse(port??'9100'));
  //
  //   if (res == PosPrintResult.success) {
  //     // DEMO RECEIPT
  //     await printDemoReceipt(printer,data,cartMaster);
  //     // TEST PRINT
  //     // await testReceipt(printer);
  //     printer.disconnect();
  //   }
  //
  //   final snackBar =
  //   SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
  //   ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
  // }
  // Future<void> printDemoReceipt(NetworkPrinter printer,CartMaster cartMaster) async {
  //   // // Print image
  //   // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
  //   // final Uint8List bytes = data.buffer.asUint8List();
  //   // final img.Image? image = img.decodeImage(bytes);
  //   // printer.image(image!);
  //   List<Cart> cart=cartMaster.cart;
  //   // printer.text(SharedPreferenceHelper.getString(Preferences.name).toString(),
  //   //     styles: PosStyles(
  //   //       align: PosAlign.center,
  //   //       height: PosTextSize.size2,
  //   //       width: PosTextSize.size2,
  //   //     ),
  //   //     linesAfter: 1);
  //
  //   // printer.text(widget.vendorAddress.toString(), styles: PosStyles(align: PosAlign.center));
  //   // printer.text('New Braunfels, TX',
  //   //     styles: PosStyles(align: PosAlign.center));
  //
  //   printer.text('Tel: 830-221-1234',
  //       styles: PosStyles(align: PosAlign.center));
  //   printer.text('Customer Name : ${data.userName}',
  //       styles: PosStyles(align: PosAlign.center));
  //   printer.text('Customer Phone : ${data.userPhone}',
  //       styles: PosStyles(align: PosAlign.center));
  //   printer.text('Payment Status : ${data.paymentType}',
  //       styles: PosStyles(align: PosAlign.center));
  //   printer.text('${data.deliveryType}',
  //       styles: PosStyles(align: PosAlign.center));
  //
  //   // printer.text('Web: www.example.com',
  //   //     styles: PosStyles(align: PosAlign.center), linesAfter: 1);
  //
  //   printer.hr();
  //   printer.row([
  //     PosColumn(text: 'Qty', width: 1),
  //     PosColumn(text: 'Item', width: 9),
  //     PosColumn(
  //         text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   for(int itemIndex=0;itemIndex<cart.length;itemIndex++){
  //     String category=cart[itemIndex].category;
  //     MenuCategory? menuCategory=cart[itemIndex].menuCategory;
  //     List<Menu> menu=cart[itemIndex].menu;
  //     if(category=='SINGLE'){
  //       Cart cartItem=cart[itemIndex];
  //       printer.row([
  //         PosColumn(
  //             text: "-SINGLE-",
  //             width: 12,
  //             styles: PosStyles(width:PosTextSize.size1,height:PosTextSize.size1,align: PosAlign.center )
  //         )
  //       ]);
  //
  //       for(int menuIndex=0;menuIndex<menu.length;menuIndex++){
  //         Menu menuItem= menu[menuIndex];
  //         printer.row([
  //           PosColumn(text: cartItem.quantity.toString(), width: 1),
  //
  //           PosColumn(
  //             text: menu[menuIndex].name+
  //                 (cart[itemIndex].size!=null?'(${cart[itemIndex].size?.sizeName})':''), width: 9,),
  //           PosColumn(
  //               text: data!.orderItems![itemIndex].price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //         ]);
  //         for(int addonIndex=0;addonIndex<menuItem.addons.length;addonIndex++){
  //           Addon addonItem=menuItem.addons[addonIndex];
  //           if(addonIndex==0){
  //             printer.row([
  //               PosColumn(
  //                   text: "-ADDONS-",
  //                   width: 12,
  //                   styles: PosStyles(width:PosTextSize.size1,height:PosTextSize.size1,align: PosAlign.center )
  //               )
  //             ]);
  //           }
  //           printer.row([
  //             PosColumn(text: '', width: 1),
  //             PosColumn(text: addonItem.name, width: 9),
  //             // PosColumn(
  //             // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //             PosColumn(
  //                 text: addonItem.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //           ]);
  //         }
  //       }
  //     }
  //     else if(category=='HALF_N_HALF'){
  //       Cart cartItem=cart[itemIndex];
  //       printer.row([
  //         PosColumn(
  //             text: "-HALF & HALF-",
  //             width: 12,
  //             styles: PosStyles(width:PosTextSize.size1,height:PosTextSize.size1,align: PosAlign.center )
  //         )
  //       ]);
  //       printer.row([
  //         PosColumn(text: cartItem.quantity.toString(), width: 1),
  //         PosColumn(text: menuCategory!.name
  //             +(cartItem.size!=null?'(${cartItem.size?.sizeName})':''), width: 9,styles: PosStyles(width:PosTextSize.size1,height:PosTextSize.size1 )),
  //         // PosColumn(
  //         // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //         PosColumn(
  //             text: data!.orderItems![itemIndex].price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //       ]);
  //
  //       for(int menuIndex=0;menuIndex<menu.length;menuIndex++){
  //         Menu menuItem= menu[menuIndex];
  //         printer.row([
  //           PosColumn(text:' ${ menuIndex==0?'-1st Half-':"-2nd Half-"}',width: 12,
  //               styles: PosStyles(width:PosTextSize.size1,height:PosTextSize.size1,align: PosAlign.center ))
  //         ]);
  //         printer.row([
  //           PosColumn(text: '', width: 1),
  //           PosColumn(text: menuItem.name+'', width: 9),
  //           // PosColumn(
  //           // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //           PosColumn(
  //               text:'', width: 2, styles: PosStyles(align: PosAlign.right)),
  //         ]);
  //
  //         for(int addonIndex=0;addonIndex<menuItem.addons.length;addonIndex++){
  //           Addon addonItem=menuItem.addons[addonIndex];
  //           if(addonIndex==0){
  //             printer.row([
  //               PosColumn(
  //                   text: "-ADDONS-",
  //                   width: 12,
  //                   styles: PosStyles(width:PosTextSize.size1,height:PosTextSize.size1,align: PosAlign.center )
  //               )
  //             ]);
  //           }
  //           printer.row([
  //             PosColumn(text: '', width: 1),
  //             PosColumn(text: addonItem.name, width: 9),
  //             // PosColumn(
  //             // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //             PosColumn(
  //                 text: addonItem.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //           ]);
  //         }
  //       }
  //     }
  //     else if(category=='DEALS'){
  //       Cart cartItem=cart[itemIndex];
  //
  //       printer.row([
  //         PosColumn(
  //             text: "-DEALS-",
  //             width: 12,
  //             styles: PosStyles(width:PosTextSize.size1,height:PosTextSize.size1,align: PosAlign.center )
  //         )
  //       ]);
  //       printer.row([
  //         PosColumn(text: cartItem.quantity.toString(), width: 1),
  //         PosColumn(text: menuCategory!.name
  //             +(cartItem.size!=null?'(${cartItem.size?.sizeName})':''), width: 9,styles: PosStyles(width:PosTextSize.size1,height:PosTextSize.size1 )),
  //         // PosColumn(
  //         // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //         PosColumn(
  //             text: data!.orderItems![itemIndex].price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //       ]);
  //       for(int menuIndex=0;menuIndex<menu.length;menuIndex++){
  //         Menu menuItem= menu[menuIndex];
  //         DealsItems dealsItems=menu[menuIndex].dealsItems!;
  //         printer.row([
  //           PosColumn(
  //               text: "-${menuItem.name}(${dealsItems.name})-",
  //               width: 12,
  //               styles: PosStyles(width:PosTextSize.size1,height:PosTextSize.size1,align: PosAlign.center )
  //           )
  //         ]);
  //         for(int addonIndex=0;addonIndex<menuItem.addons.length;addonIndex++){
  //           Addon addonItem=menuItem.addons[addonIndex];
  //           if(addonIndex==0){
  //
  //             printer.row([
  //               PosColumn(width: 1),
  //
  //               PosColumn(
  //                   text: "        -ADDONS-",
  //                   width: 9,
  //                   styles: PosStyles(width:PosTextSize.size1,height:PosTextSize.size1,align: PosAlign.center )
  //               ),
  //               PosColumn(width: 2),
  //
  //             ]);
  //           }
  //           printer.row([
  //             PosColumn(text: '', width: 1),
  //             PosColumn(text: addonItem.name, width: 9),
  //             // PosColumn(
  //             // text: orderItems.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //             PosColumn(
  //                 text: addonItem.price.toString(), width: 2, styles: PosStyles(align: PosAlign.right)),
  //           ]);
  //         }
  //
  //       }
  //
  //     }
  //
  //   }
  //   printer.hr();
  //
  //   printer.row([
  //     PosColumn(
  //         text: 'TOTAL',
  //         width: 6,
  //         styles: PosStyles(
  //           height: PosTextSize.size2,
  //           width: PosTextSize.size2,
  //         )),
  //     PosColumn(
  //         text: "$currencySymbol${data!.amount}",
  //         width: 6,
  //         styles: PosStyles(
  //           align: PosAlign.right,
  //           height: PosTextSize.size2,
  //           width: PosTextSize.size2,
  //         )),
  //   ]);
  //
  //   printer.hr(ch: '=', linesAfter: 1);
  //
  //
  //   printer.feed(2);
  //   printer.text('Thank you!',
  //       styles: PosStyles(align: PosAlign.center, bold: true));
  //
  //   // Print QR Code from image
  //   // try {
  //   //   const String qrData = 'example.com';
  //   //   const double qrSize = 200;
  //   //   final uiImg = await QrPainter(
  //   //     data: qrData,
  //   //     version: QrVersions.auto,
  //   //     gapless: false,
  //   //   ).toImageData(qrSize);
  //   //   final dir = await getTemporaryDirectory();
  //   //   final pathName = '${dir.path}/qr_tmp.png';
  //   //   final qrFile = File(pathName);
  //   //   final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
  //   //   final img = decodeImage(imgFile.readAsBytesSync());
  //
  //   //   printer.image(img);
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  //
  //   // Print QR Code using native function
  //   // printer.qrcode('example.com');
  //
  //   printer.feed(1);
  //   printer.cut();
  // }
  // void testPrint(String printerIp, String? port,BuildContext ctx) async {
  //   // TODO Don't forget to choose printer's paper size
  //   const PaperSize paper = PaperSize.mm80;
  //   final profile = await CapabilityProfile.load();
  //   final printer = NetworkPrinter(paper, profile);
  //   final PosPrintResult res = await printer.connect(printerIp, port: int.parse(port??'9100'));
  //
  //   if (res == PosPrintResult.success) {
  //     // DEMO RECEIPT
  //     await printDemoReceipt(printer);
  //     // TEST PRINT
  //     // await testReceipt(printer);
  //     printer.disconnect();
  //   }
  //
  //   final snackBar =
  //   SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
  //   ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
  // }
  Future<BaseModel<CommenRes>> placeOrder() async {
    CommenRes response;
    try{
      Constants.onLoading(context);

     // print('with ${item1.toString()}');
      // var json = jsonEncode(widget.orderItem, toEncodable: (e) => e.toString());
      // Map<String, dynamic> item = {"id": 11, "price": 200, "qty": 1};
      //
      // item = {"id": 10, "price": 195, "qty": 3};
      //
      // List<Map<String, dynamic>> temp = [];
      // temp.add({'id': 10, 'price': 195, 'qty': 3});
      // temp.add({'id': 11, 'price': 200, 'qty': 1});
      //
      // print('with $item');
      // print('temp without ${json.encode(temp.toString())}');
      // print('temp with' + json.encode(temp).toString());
      //
      // print('item with' + jsonEncode(item));
      // item.addEntries({"id": 2, "price": 200, "qty": 2});
      print('the amount ${widget.orderAmount.toString()}');
      Map<String, String?> body = {
        'vendor_id': widget.venderId.toString(),
        'date': widget.orderDate,
        'time': widget.orderTime,
        'delivery_time':widget.deliveryTime,
        'delivery_date':widget.deliveryDate,
        'item': json.encode(_cartController.cartMaster!.toMap()),
        // 'item': json.encode(widget.orderItem).toString(),
        // 'item': '[{\'id\':\'11\',\'price\':\'200\',\'qty\':\'1\'},{\'id\':\'10\',\'price\':\'195\',\'qty\':\'3\'}]',
        'amount': widget.orderAmount.toString(),
        'delivery_type': widget.orderDeliveryType,
        // 'address_id': widget.orderDeliveryType == 'SHOP' ? '' : widget.addressId.toString(),
        'delivery_charge':widget.orderDeliveryCharge,
        'payment_type': orderPaymentType,
        'payment_status': orderPaymentType == 'COD' ? '0' : '1',
        'order_status': widget.orderStatus,
        'custimization': '',
        'promocode_id': _cartController.strAppiedPromocodeId,
        'payment_token': strPaymentToken,
        'promocode_price':widget.vendorDiscountAmount != 0
            ? widget.vendorDiscountAmount.toString()
            : '',
         'tax': widget.strTaxAmount,
        'sub_total':widget.subTotal!.toString(),
        'table_no':widget.tableNumber?.toString(),
        'old_order_id':_cartController.cartMaster!.oldOrderId?.toString(),
        // 'tax': json.encode(widget.allTax).toString(),
      };
      response  = await RestClient(await RetroApi().dioData()).bookOrder(body);
      print(response.toJson());
      //Constants.hideDialog(context);
      print(response);
      print(response.success);
      if (response.success!) {
        Constants.toastMessage(response.data!);
        _cartController.cartMaster=null;
        _cartController.cartTotalQuantity.value=0;
        // ScopedModel.of<CartModel>(context, rebuildOnChange: true).clearCart();
        strPaymentToken = '';
        _orderHistoryController.callGetOrderHistoryList(context);
        Get.offAll(VendorMenu(vendorId: 5,isDininig: false,));
        Navigator.of(context).pushAndRemoveUntil(
            Transitions(
              transitionType: TransitionType.fade,
              curve: Curves.bounceInOut,
              reverseCurve: Curves.fastLinearToSlowEaseIn,
              widget: OrderHistory(
                isFromProfile: false,
              ),
            ),
                (Route<dynamic> route) => true);
      } else {
        Constants.toastMessage('Errow while place order.');
      }

    }catch (error, stacktrace) {
      print("catch");
      Constants.hideDialog(context);
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }



  Future<BaseModel<CommenRes>> getWalletBalance() async {
    CommenRes response;
    try{
      Constants.onLoading(context);
      response  = await RestClient(await RetroApi().dioData()).getWalletBalance();
      Constants.hideDialog(context);
      if(widget.orderAmount! > int.parse(response.data!)){
        Constants.toastMessage('Not Enough money in wallet please add first');
      }else{
        placeOrder();
      }
    }catch (error, stacktrace) {
     Constants.hideDialog(context);
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

}
