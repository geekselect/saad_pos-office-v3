import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';
import 'package:get/get.dart';
import 'package:pos/model/cartmodel.dart';
import 'package:pos/model/common_res.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';

import 'package:pos/utils/rounded_corner_app_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../controller/cart_controller.dart';
import '../../controller/order_history_controller.dart';
import '../../screen_animation_utils/transitions.dart';
import '../OrderHistory/order_history.dart';

class PaymentStripe extends StatefulWidget {
  final int? venderId,
      addressId,
      vendorDiscountAmount,
      vendorDiscountId;
  final String? orderDate,
      orderTime,
      orderStatus,
      orderCustomization,
      ordrePromoCode,
      orderDeliveryType,

  // strTaxAmount,
      orderDeliveryCharge,deliveryTime,deliveryDate;
  // final double orderItem;
  final double? orderAmount,calculateTax,subTotal;
  final List<Map<String, dynamic>>? orderItem;
  final List<Map<String, dynamic>>? allTax;

  const PaymentStripe(
      {Key? key,
        this.venderId,
        this.orderDeliveryCharge,
        this.orderAmount,
        this.addressId,
        this.orderDate,
        this.orderTime,
        this.orderStatus,
        this.orderCustomization,
        this.ordrePromoCode,
        this.orderDeliveryType,
        this.orderItem,
        this.vendorDiscountAmount,
        this.vendorDiscountId,
        this.allTax, this.calculateTax, this.subTotal, this.deliveryTime, this.deliveryDate})
      : super(key: key);
  @override
  _PaymentStripeState createState() => _PaymentStripeState();
}



class _PaymentStripeState extends State<PaymentStripe> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CartController _cartController=Get.find<CartController>();
  OrderHistoryController _orderHistoryController=Get.find<OrderHistoryController>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                isHolderNameVisible: true,
                cardBgColor: Colors.red,
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {
                  print(creditCardBrand.brandName);
                },
                customCardTypeIcons: <CustomCardTypeIcon>[
                  CustomCardTypeIcon(
                    cardType: CardType.mastercard,
                    cardImage: Image.asset(
                      'assets/images/call.png',
                      height: 48,
                      width: 48,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,

                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        themeColor: Color(Constants.colorTheme),
                        textColor: Colors.black,
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                          hintStyle: const TextStyle(color: Colors.black),
                          labelStyle: const TextStyle(color: Colors.black),
                          focusedBorder: border,
                          enabledBorder: border,
                        ),
                        expiryDateDecoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.black),
                          labelStyle: const TextStyle(color: Colors.black),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.black),
                          labelStyle: const TextStyle(color: Colors.black),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.black),
                          labelStyle: const TextStyle(color: Colors.black),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'Card Holder',
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          primary: const Color(0xff1b447b),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          child: const Text(
                            'Proceed',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'halter',
                              fontSize: 14,
                              package: 'flutter_credit_card',
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            print('valid!');
                            placeOrder();
                          } else {
                            print('invalid!');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
  Future<BaseModel<CommenRes>> placeOrder() async {
    CommenRes response;
    try{
    // [02,22]
      List list=expiryDate.split('/');
      Constants.onLoading(context);
      Map<String, String?> body = {
        'payment_type': 'STRIPE',
        'card_number':cardNumber,
        'cvv':cvvCode,
        'expiry_month':list[0],
        'expiry_year':list[1],
        'card_holder_name':cardHolderName,
        'vendor_id': widget.venderId.toString(),
        'date': widget.orderDate,
        'time': widget.orderTime,
        'delivery_time':widget.deliveryTime,
        'delivery_date':widget.deliveryDate,
        'item': json.encode(_cartController.cartMaster!.toMap()),
        'amount': widget.orderAmount.toString(),
        'delivery_type': widget.orderDeliveryType,
        'address_id':
        widget.orderDeliveryType == 'SHOP' ? '' : widget.addressId.toString(),
        'delivery_charge': widget.orderDeliveryCharge,
        'payment_status': '1',
        'order_status': widget.orderStatus,
        'custimization': json.encode(widget.orderCustomization).toString(),
        'promocode_id': _cartController.strAppiedPromocodeId,
        'promocode_price':widget.vendorDiscountAmount != 0
            ? widget.vendorDiscountAmount.toString()
            : '',
        'tax': json.encode(widget.allTax).toString(),
        'sub_total':widget.subTotal!.toString(),
      };

      response  = await RestClient(await RetroApi().dioData()).bookOrder(body);
      print(response.toJson());
      if (response.success!) {
        Constants.toastMessage(response.data!);

        _cartController.cartMaster=null;
        _cartController.cartTotalQuantity.value=0;
        //Navigator.pop(context);
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
      Constants.hideDialog(context);
      print(error);
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}



  // setError(dynamic error,dynamic stackTrace) {
  //   showSpinner = false;
  //   print(error);
  //   print(stackTrace);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(error.toString())));
  // }








