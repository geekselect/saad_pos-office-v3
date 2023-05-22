import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pos/model/apply_promocode_model.dart';
import 'package:pos/model/booked_order_model.dart';
import 'package:pos/model/cart_master.dart';
import 'package:pos/model/common_res.dart';
import 'package:pos/model/order_setting_api_model.dart';
import 'package:pos/model/promoCode_model.dart';
import 'package:pos/pages/cart_screen.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
// import 'package:pos/screen_animation_utils/transitions.dart';
// import 'package:pos/screens/bottom_navigation/dashboard_screen.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen_animation_utils/transitions.dart';
class CartController extends GetxController{
  CartMaster? cartMaster;
  RxBool refreshScreen=false.obs;
  List<PromoCodeListData> listPromoCode = [];
  ScrollController scrollController = ScrollController();
  double discountAmount=0.0;
  int taxType= 0;
  double taxAmountNew = 0.0;
  String appliedCouponPercentage='';
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  String? appliedCouponName='';

  String userName='';

  String userMobileNumber='';
  String notes='';

  bool isPromocodeApplied=false;

  double totalPrice=0.0;

  String strAppiedPromocodeId='0';
  RxInt quantity=0.obs;
  String? discountType;
  int discount=0;
  double calculatedTax = 0.0;
  double calculatedAmount=0.0;
  OrderSettingModel? orderSettingModel;
  double deliveryCharge=0.0;
  RxInt cartItemQuantity=0.obs;
  RxInt cartTotalQuantity=0.obs;
  bool diningValue = false;
  int? tableNumber;
  @override

  bool checkMenuExistInCart(String menuCategory,int menuId){
    if (cartMaster!=null) {
      for (Cart cart in cartMaster!.cart){
        if(cart.category=='SINGLE'){
         if(cart.menu[0].id==menuId){
           return true;
         }
        }else if(cart.category=='HALF_N_HALF' || cart.category=='DEALS'){
          if(cart.menuCategory!.id==menuId){
            return true;
          }
        }
      }
    }
    return false;
  }
  Future<bool?> showAlertDialog(BuildContext context)async {

    // set up the AlertDialog


    // show the dialog
   return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return   AlertDialog(
          title: Text("Are You Sure"),
          content: Text("Do you want to delete previous orders from other restaurants"),
          actions: [
        TextButton(
        child: Text("YES"),
        onPressed:  () {
        Navigator.pop(context,true);
        },
        ),
        TextButton(
        child: Text("NO"),
        onPressed:  () {
        Navigator.pop(context,false);
        },
        ),
          ],
        );
      },
    );
  }
  Future<bool> showMenuExistDialog(BuildContext context)async {

    // set up the AlertDialog


    // show the dialog
   return await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return   AlertDialog(
          title: Text("The Menu Already Exist"),
          content: Text("Do You Want To Add Item With Different Size And Addons"),
          actions: [
        TextButton(
        child: Text("YES"),
        onPressed:  () {
        Navigator.pop(context,true);
        },
        ),
        TextButton(
        child: Text("NO"),
        onPressed:  () {
        Navigator.pop(context,false);
        },
        ),
          ],
        );
      },
    ) ?? false;
  }
  Future<BaseModel<PromoCodeModel>> callGetPromocodeListData(
      int? restaurantId,BuildContext context) async {
    PromoCodeModel response;
    try {
      Constants.onLoading(context);
      listPromoCode.clear();
      response = await RestClient(await RetroApi().dioData()).promoCode(restaurantId);
      Constants.hideDialog(context);
      if (response.success!) {
        listPromoCode.addAll(response.data!);
      } else {
        Constants.toastMessage('Error while remove address');
      }
    } catch (error, stacktrace) {
      Constants.hideDialog(context);
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
  Future<BaseModel<BookedOrderModel>> getBookedTableData(Map<String,dynamic> param,BuildContext context)async{
    BookedOrderModel response;
    try {
      Constants.onLoading(context);
      print(param);
      response = await RestClient(await await RetroApi().dioData()).getBookTableData(param);

      Constants.hideDialog(context);
    } catch (error, stacktrace) {
      Constants.hideDialog(context);
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
  Future<BaseModel<OrderSettingModel>> callOrderSetting() async {
    final prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    try {
      orderSettingModel = await RestClient(await RetroApi().dioData()).orderSetting(int.parse(vendorId.toString()));
      if (orderSettingModel!.success!) {

      } else {
        Constants.toastMessage('OrderSetting api error occurs');
      }
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = orderSettingModel;
  }
  Future<BaseModel<String>> callApplyPromoCall(
      BuildContext context,
      String? promocodeName,
      String orderDate,
      double orderAmount,
      int? id) async {
    String response;
    try {
      Constants.onLoading(context);
      Map<String, String> body = {
        'date': orderDate,
        'amount': orderAmount.toString(),
        'delivery_type': 'delivery',
        'promocode_id': id.toString(),
      };

      response = (await RestClient(await RetroApi().dioData()).applyPromoCode(body))!;
      Constants.hideDialog(context);
      final body1 = json.decode(response);
      bool success = body1['success'];
      if (success) {
        Map loginMap = jsonDecode(response.toString());
        var commenRes =
        ApplyPromoCodeModel.fromJson(loginMap as Map<String, dynamic>);
        calculateDiscount(
            promocodeName,
            commenRes.data!.discountType,
            commenRes.data!.discount,
            commenRes.data!.flatDiscount,
            commenRes.data!.isFlat,
            orderAmount);
        Navigator.of(context).pushReplacement(
          Transitions(
            transitionType: TransitionType.fade,
            curve: Curves.bounceInOut,
            reverseCurve: Curves.fastLinearToSlowEaseIn,
            widget: CartScreen(isDining: diningValue,),
          ),
        );
        strAppiedPromocodeId = id.toString();
      } else {
        Map loginMap = jsonDecode(response.toString());
        var commenRes = CommenRes.fromJson(loginMap as Map<String, dynamic>);
        Constants.toastMessage(commenRes.data!);
      }
    } catch (error, stacktrace) {
      Constants.hideDialog(context);
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
  void calculateDiscount(String? promoName, String? discountType, int? discount,
      int? flatDiscount, int? isFlat, double orderAmount) {
    double tempDisc = 0;
    this.discountType=discountType;
    this.discount=discount!;
    if (discountType == 'percentage') {
      tempDisc = orderAmount * discount / 100;
      // if (isFlat == 1) {
      //   tempDisc = tempDisc + flatDiscount!;
      //   print('after flat disc add $tempDisc');
      // }

      discountAmount = tempDisc;
      appliedCouponPercentage = discount.toString() + '%';
      appliedCouponName = promoName;
    } else {
      tempDisc = tempDisc + discount;

      // if (isFlat == 1) {
      //   tempDisc = tempDisc + flatDiscount!;
      // }
      discountAmount = tempDisc;
      appliedCouponPercentage = discount.toString();
    }

    appliedCouponName = promoName;
    isPromocodeApplied = true;
    // discountAmount=double.parse((discountAmount).toStringAsFixed(2));
    // calculatedAmount-=discountAmount;
    //totalPrice = totalPrice - discountAmount;
  }

  void addItem(Cart cart,int vendorId,BuildContext context)async{
   if(cartMaster==null){
     print("cartMaster null");
     cartMaster=CartMaster(vendorId: vendorId, cart: [cart]);
   }else{
     print("cartMaster not null");

     if(vendorId==cartMaster!.vendorId){
       print("vendorId equal");

       for(int i=0;i<cartMaster!.cart.length;i++){

         if(
         (cart.category==cartMaster!.cart[i].category) &&
         ((cart.size==null && cartMaster!.cart[i].size==null) || (cart.size!=null && cartMaster!.cart[i].size!=null && cart.size!.id==cartMaster!.cart[i].size!.id))
         ){
           print("1st ");

           if(cartMaster!.cart[i].menu.length==cart.menu.length){
             print("2nd");

             bool exist=true;
             for(int menuIndex=0;menuIndex<cartMaster!.cart[i].menu.length;menuIndex++){
               print("3rd");

               if(exist==false){
                 break;
               }
               if(cartMaster!.cart[i].menu[menuIndex].id==cart.menu[menuIndex].id){
                 if(cartMaster!.cart[i].menu[menuIndex].addons.length==cart.menu[menuIndex].addons.length){
                   for(int addonIndex=0;addonIndex<cartMaster!.cart[i].menu[menuIndex].addons.length;addonIndex++){
                     if(cartMaster!.cart[i].menu[menuIndex].addons[addonIndex].id==cart.menu[menuIndex].addons[addonIndex].id){

                     }
                     else{
                       exist = false;
                       break;
                     }
                   }
                 }
                 else{
                   exist = false;
                   break;
                 }
               }
               else {
                 exist = false;
                 break;
               }
             }

             if(exist){
               print("Exist");
               // if(diningValue) {
               //   print("diningValue");

                 double diningAmountMain = cartMaster!.cart[i].diningAmount /
                     cartMaster!.cart[i].quantity;
                 if (diningAmountMain == 1 || diningAmountMain == 1.00 ||
                     diningAmountMain == 1.0) {
                   diningAmountMain = diningAmountMain * cartMaster!.cart[i].quantity;
                 }

                 double takeAwayAmountMain = cartMaster!.cart[i].totalAmount /
                     cartMaster!.cart[i].quantity;
                 if (takeAwayAmountMain == 1 || takeAwayAmountMain == 1.00 ||
                     takeAwayAmountMain == 1.0) {
                   takeAwayAmountMain = takeAwayAmountMain * cartMaster!.cart[i].quantity;
                 }
                 print("before ${cartMaster!.cart[i].totalAmount}");
                 print("before ${cartMaster!.cart[i].diningAmount}");
                 print("before ${cartMaster!.cart[i].quantity}");

                 cartMaster!.cart[i].quantity++;
                 cartMaster!.cart[i].diningAmount = diningAmountMain * cartMaster!.cart[i].quantity;
                 cartMaster!.cart[i].totalAmount = takeAwayAmountMain * cartMaster!.cart[i].quantity;
                 // cartMaster!.cart[i].diningAmount = amount;
                 print("total ${cartMaster!.cart[i].totalAmount}");
                 print("total ${cartMaster!.cart[i].diningAmount}");
                 print("total ${cartMaster!.cart[i].quantity}");
               // } else {
               //   print("No diningValue");
               //
               //   double totalAmount = cartMaster!.cart[i].totalAmount /
               //       cartMaster!.cart[i].quantity;
               //   if (totalAmount == 1 || totalAmount == 1.00 ||
               //       totalAmount == 1.0) {
               //     totalAmount = totalAmount * cartMaster!.cart[i].quantity;
               //   }
               //   print("before ${cartMaster!.cart[i].totalAmount}");
               //   print("before ${cartMaster!.cart[i].diningAmount}");
               //   print("before ${cartMaster!.cart[i].quantity}");
               //   cartMaster!.cart[i].quantity++;
               //   double amount = totalAmount + cartMaster!.cart[i].totalAmount;
               //   cartMaster!.cart[i].totalAmount = amount;
               //   print("total ${cartMaster!.cart[i].totalAmount}");
               //   print("total ${cartMaster!.cart[i].diningAmount}");
               //   print("total ${cartMaster!.cart[i].quantity}");
               // }
               return;
             }
           }
         }
       }
     }else{
       print("vendorId not equal");

       if(await  showAlertDialog(context) ?? false){
         cartMaster=CartMaster(vendorId: vendorId, cart: [cart]);
         return;
       }
     }


     cartMaster!.cart.add(cart);
     SchedulerBinding.instance.addPostFrameCallback((_) {
       scrollController.animateTo(
         scrollController.position.maxScrollExtent,
         duration: const Duration(milliseconds: 300),
         curve: Curves.easeOut,
       );
     });
   }
   }
  void removeItem(Cart cart,int vendorId){
    if(cartMaster!=null  && vendorId==cartMaster!.vendorId){
      for(int i=0;i<cartMaster!.cart.length;i++){

        if(
        (cart.category==cartMaster!.cart[i].category) &&
            ((cart.size==null && cartMaster!.cart[i].size==null) || (cart.size!=null && cartMaster!.cart[i].size!=null && cart.size!.id==cartMaster!.cart[i].size!.id))
        ){
          if(cartMaster!.cart[i].menu.length==cart.menu.length){
            bool exist=true;
            for(int menuIndex=0;menuIndex<cartMaster!.cart[i].menu.length;menuIndex++){
              if(exist==false){
                break;
              }
              if(cartMaster!.cart[i].menu[menuIndex].id==cart.menu[menuIndex].id){
                if(cartMaster!.cart[i].menu[menuIndex].addons.length==cart.menu[menuIndex].addons.length){
                  for(int addonIndex=0;addonIndex<cartMaster!.cart[i].menu[menuIndex].addons.length;addonIndex++){
                    if(cartMaster!.cart[i].menu[menuIndex].addons[addonIndex].id==cart.menu[menuIndex].addons[addonIndex].id){

                    }
                    else{
                      exist = false;
                      break;
                    }
                  }
                }
                else{
                  exist = false;
                  break;
                }
              }
              else {
                exist = false;
                break;
              }
            }

            if(exist){
              if(cartMaster!.cart[i].quantity==1){
                cartMaster!.cart.removeAt(i);
                return;
              }
              double amount=cartMaster!.cart[i].totalAmount/cartMaster!.cart[i].quantity;
              cartMaster!.cart[i].quantity--;
              cartMaster!.cart[i].totalAmount-=amount;
              return;
            }
          }
        }
      }
    }
    //Message : does not exist
  }
  int getQuantity(Cart cart,int vendorId){
    if(cartMaster!=null  && vendorId==cartMaster!.vendorId){
      for(int i=0;i<cartMaster!.cart.length;i++){

        if(
        (cart.category==cartMaster!.cart[i].category) &&
            ((cart.size==null && cartMaster!.cart[i].size==null) || (cart.size!=null && cartMaster!.cart[i].size!=null && cart.size!.id==cartMaster!.cart[i].size!.id))
        ){
          if(cartMaster!.cart[i].menu.length==cart.menu.length){
            bool exist=true;
            for(int menuIndex=0;menuIndex<cartMaster!.cart[i].menu.length;menuIndex++){
              if(exist==false){
                break;
              }
              if(cartMaster!.cart[i].menu[menuIndex].id==cart.menu[menuIndex].id){
                if(cartMaster!.cart[i].menu[menuIndex].addons.length==cart.menu[menuIndex].addons.length){
                  for(int addonIndex=0;addonIndex<cartMaster!.cart[i].menu[menuIndex].addons.length;addonIndex++){
                    if(cartMaster!.cart[i].menu[menuIndex].addons[addonIndex].id==cart.menu[menuIndex].addons[addonIndex].id){

                    }
                    else{
                      exist = false;
                      break;
                    }
                  }
                }
                else{
                  exist = false;
                  break;
                }
              }
              else {
                exist = false;
                break;
              }
            }

            if(exist){
              return cartMaster!.cart[i].quantity;
            }
          }
        }
      }
    }
    return 0;
  }
  void addItemToast(){
    // Fluttertoast.showToast(
    //     msg: "$quantity Item added to cart",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.black,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    // );
    Get.snackbar(
      "$quantity Item added to cart",
      "",
        snackPosition:SnackPosition.BOTTOM,
      backgroundColor: Color(Constants.colorTheme).withOpacity(0.8),
      borderRadius: 0.0,
      margin: EdgeInsets.all(0.0),
      colorText: Colors.white,
        snackStyle:SnackStyle.FLOATING,
    );
  }
  void removeItemToast(){
    Fluttertoast.showToast(
        msg: "Item removed from cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  }

  ///
//import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:pos/model/apply_promocode_model.dart';
// import 'package:pos/model/booked_order_model.dart';
// import 'package:pos/model/cart_master.dart';
// import 'package:pos/model/common_res.dart';
// import 'package:pos/model/order_setting_api_model.dart';
// import 'package:pos/model/promoCode_model.dart';
// import 'package:pos/pages/cart_screen.dart';
// import 'package:pos/retrofit/api_client.dart';
// import 'package:pos/retrofit/api_header.dart';
// import 'package:pos/retrofit/base_model.dart';
// import 'package:pos/retrofit/server_error.dart';
// // import 'package:pos/screen_animation_utils/transitions.dart';
// // import 'package:pos/screens/bottom_navigation/dashboard_screen.dart';
// import 'package:pos/utils/constants.dart';
//
// import '../screen_animation_utils/transitions.dart';
// class CartController extends GetxController{
//   CartMaster? cartMaster;
//   RxBool refreshScreen=false.obs;
//   List<PromoCodeListData> listPromoCode = [];
//
//   double discountAmount=0.0;
//
//   String appliedCouponPercentage='';
//
//   String? appliedCouponName='';
//
//   String userName='';
//
//   String userMobileNumber='';
//
//   bool isPromocodeApplied=false;
//
//   double totalPrice=0.0;
//
//   String strAppiedPromocodeId='0';
//   RxInt quantity=0.obs;
//   String? discountType;
//   int discount=0;
//   double calculatedTax=0.0;
//   double calculatedAmount=0.0;
//   OrderSettingModel? orderSettingModel;
//   double deliveryCharge=0.0;
//   RxInt cartItemQuantity=0.obs;
//   RxInt cartTotalQuantity=0.obs;
//   bool diningValue = false;
//   int? tableNumber;
//   bool checkMenuExistInCart(String menuCategory,int menuId){
//     if (cartMaster!=null) {
//       for (Cart cart in cartMaster!.cart){
//         if(cart.category=='SINGLE'){
//           if(cart.menu[0].id==menuId){
//             return true;
//           }
//         }else if(cart.category=='HALF_N_HALF' || cart.category=='DEALS'){
//           if(cart.menuCategory!.id==menuId){
//             return true;
//           }
//         }
//       }
//     }
//     return false;
//   }
//   Future<bool?> showAlertDialog(BuildContext context)async {
//
//     // set up the AlertDialog
//
//
//     // show the dialog
//     return await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return   AlertDialog(
//           title: Text("Are You Sure"),
//           content: Text("Do you want to delete previous orders from other restaurants"),
//           actions: [
//             TextButton(
//               child: Text("YES"),
//               onPressed:  () {
//                 Navigator.pop(context,true);
//               },
//             ),
//             TextButton(
//               child: Text("NO"),
//               onPressed:  () {
//                 Navigator.pop(context,false);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//   Future<bool> showMenuExistDialog(BuildContext context)async {
//
//     // set up the AlertDialog
//
//
//     // show the dialog
//     return await showDialog<bool?>(
//       context: context,
//       builder: (BuildContext context) {
//         return   AlertDialog(
//           title: Text("The Menu Already Exist"),
//           content: Text("Do You Want To Add Item With Different Size And Addons"),
//           actions: [
//             TextButton(
//               child: Text("YES"),
//               onPressed:  () {
//                 Navigator.pop(context,true);
//               },
//             ),
//             TextButton(
//               child: Text("NO"),
//               onPressed:  () {
//                 Navigator.pop(context,false);
//               },
//             ),
//           ],
//         );
//       },
//     ) ?? false;
//   }
//   Future<BaseModel<PromoCodeModel>> callGetPromocodeListData(
//       int? restaurantId,BuildContext context) async {
//     PromoCodeModel response;
//     try {
//       Constants.onLoading(context);
//       listPromoCode.clear();
//       response = await RestClient(await RetroApi().dioData()).promoCode(restaurantId);
//       Constants.hideDialog(context);
//       if (response.success!) {
//         listPromoCode.addAll(response.data!);
//       } else {
//         Constants.toastMessage('Error while remove address');
//       }
//     } catch (error, stacktrace) {
//       Constants.hideDialog(context);
//       print("Exception occurred: $error stackTrace: $stacktrace");
//       return BaseModel()..setException(ServerError.withError(error: error));
//     }
//     return BaseModel()..data = response;
//   }
//   Future<BaseModel<BookedOrderModel>> getBookedTableData(Map<String,dynamic> param,BuildContext context)async{
//     BookedOrderModel response;
//     try {
//       Constants.onLoading(context);
//       print(param);
//       response = await RestClient(await await RetroApi().dioData()).getBookTableData(param);
//
//       Constants.hideDialog(context);
//     } catch (error, stacktrace) {
//       Constants.hideDialog(context);
//       print("Exception occurred: $error stackTrace: $stacktrace");
//       return BaseModel()..setException(ServerError.withError(error: error));
//     }
//     return BaseModel()..data = response;
//   }
//   Future<BaseModel<OrderSettingModel>> callOrderSetting(int id) async {
//     try {
//       orderSettingModel = await RestClient(await RetroApi().dioData()).orderSetting(id);
//       if (orderSettingModel!.success!) {
//
//       } else {
//         Constants.toastMessage('OrderSetting api error occurs');
//       }
//     } catch (error, stacktrace) {
//       print("Exception occurred: $error stackTrace: $stacktrace");
//       return BaseModel()..setException(ServerError.withError(error: error));
//     }
//     return BaseModel()..data = orderSettingModel;
//   }
//   Future<BaseModel<String>> callApplyPromoCall(
//       BuildContext context,
//       String? promocodeName,
//       String orderDate,
//       double orderAmount,
//       int? id) async {
//     String response;
//     try {
//       Constants.onLoading(context);
//       Map<String, String> body = {
//         'date': orderDate,
//         'amount': orderAmount.toString(),
//         'delivery_type': 'delivery',
//         'promocode_id': id.toString(),
//       };
//
//       response = (await RestClient(await RetroApi().dioData()).applyPromoCode(body))!;
//       Constants.hideDialog(context);
//       final body1 = json.decode(response);
//       bool success = body1['success'];
//       if (success) {
//         Map loginMap = jsonDecode(response.toString());
//         var commenRes =
//         ApplyPromoCodeModel.fromJson(loginMap as Map<String, dynamic>);
//         calculateDiscount(
//             promocodeName,
//             commenRes.data!.discountType,
//             commenRes.data!.discount,
//             commenRes.data!.flatDiscount,
//             commenRes.data!.isFlat,
//             orderAmount);
//         Navigator.of(context).pushReplacement(
//           Transitions(
//             transitionType: TransitionType.fade,
//             curve: Curves.bounceInOut,
//             reverseCurve: Curves.fastLinearToSlowEaseIn,
//             widget: CartScreen(isDining: diningValue,),
//           ),
//         );
//         strAppiedPromocodeId = id.toString();
//       } else {
//         Map loginMap = jsonDecode(response.toString());
//         var commenRes = CommenRes.fromJson(loginMap as Map<String, dynamic>);
//         Constants.toastMessage(commenRes.data!);
//       }
//     } catch (error, stacktrace) {
//       Constants.hideDialog(context);
//       print("Exception occurred: $error stackTrace: $stacktrace");
//       return BaseModel()..setException(ServerError.withError(error: error));
//     }
//     return BaseModel()..data = response;
//   }
//   void calculateDiscount(String? promoName, String? discountType, int? discount,
//       int? flatDiscount, int? isFlat, double orderAmount) {
//     double tempDisc = 0;
//     this.discountType=discountType;
//     this.discount=discount!;
//     if (discountType == 'percentage') {
//       tempDisc = orderAmount * discount / 100;
//       // if (isFlat == 1) {
//       //   tempDisc = tempDisc + flatDiscount!;
//       //   print('after flat disc add $tempDisc');
//       // }
//
//       discountAmount = tempDisc;
//       appliedCouponPercentage = discount.toString() + '%';
//       appliedCouponName = promoName;
//     } else {
//       tempDisc = tempDisc + discount;
//
//       // if (isFlat == 1) {
//       //   tempDisc = tempDisc + flatDiscount!;
//       // }
//       discountAmount = tempDisc;
//       appliedCouponPercentage = discount.toString();
//     }
//
//     appliedCouponName = promoName;
//     isPromocodeApplied = true;
//     // discountAmount=double.parse((discountAmount).toStringAsFixed(2));
//     // calculatedAmount-=discountAmount;
//     //totalPrice = totalPrice - discountAmount;
//   }
//   void addItem(Cart cart,int vendorId,BuildContext context)async{
//     if(cartMaster==null){
//       print("cartmaster null");
//       cartMaster=CartMaster(vendorId: vendorId, cart: [cart]);
//     }else{
//       print("cartmaster not null");
//
//       if(vendorId==cartMaster!.vendorId){
//         print("cartmaster not null 1");
//         for(int i=0;i<cartMaster!.cart.length;i++){
//           if(
//           (cart.category==cartMaster!.cart[i].category) &&
//               ((cart.size==null && cartMaster!.cart[i].size==null) || (cart.size!=null && cartMaster!.cart[i].size!=null && cart.size!.id==cartMaster!.cart[i].size!.id))
//           ){
//             print("cartmaster not null 2");
//             if(cartMaster!.cart[i].menu.length==cart.menu.length){
//               print("cartmaster not null 3");
//               print("cartmaster menu ${cartMaster!.cart[i].menu.length}");
//               bool exist=true;
//               for(int menuIndex=0;menuIndex<cartMaster!.cart[i].menu.length;menuIndex++){
//                 print("****");
//
//                 if(exist==false){
//                   break;
//                 }
//                 if(cartMaster!.cart[i].menu[menuIndex].id==cart.menu[menuIndex].id){
//                   if(cartMaster!.cart[i].menu[menuIndex].addons.length==cart.menu[menuIndex].addons.length){
//                     for(int addonIndex=0;addonIndex<cartMaster!.cart[i].menu[menuIndex].addons.length;addonIndex++){
//                       if(cartMaster!.cart[i].menu[menuIndex].addons[addonIndex].id==cart.menu[menuIndex].addons[addonIndex].id){
//                         print(" inner ****");
//                       }
//                       else{
//                         exist = false;
//                         break;
//                       }
//                     }
//                   }
//                   else{
//                     exist = false;
//                     break;
//                   }
//                 }
//                 else {
//                   exist = false;
//                   break;
//                 }
//               }
//               print("----");
//               if(exist){
//                 print("cartmaster not null 4");
//                 double amount = cartMaster!.cart[i].totalAmount /
//                     cartMaster!.cart[i].quantity;
//                 cartMaster!.cart[i].quantity++;
//                 cartMaster!.cart[i].totalAmount += amount;
//                 print(" diningAmount add ${cartMaster!.cart[i].totalAmount}");
//                 print(" quantity add ${cartMaster!.cart[i].quantity}");
//
//                 return;
//               }
//             }
//           }
//         }
//       }else{
//         if(await  showAlertDialog(context) ?? false){
//           cartMaster=CartMaster(vendorId: vendorId, cart: [cart]);
//           return;
//         }
//       }
//
//
//       cartMaster!.cart.add(cart);
//     }
//   }
//   void removeItem(Cart cart,int vendorId){
//     if(cartMaster!=null  && vendorId==cartMaster!.vendorId){
//       for(int i=0;i<cartMaster!.cart.length;i++){
//
//         if(
//         (cart.category==cartMaster!.cart[i].category) &&
//             ((cart.size==null && cartMaster!.cart[i].size==null) || (cart.size!=null && cartMaster!.cart[i].size!=null && cart.size!.id==cartMaster!.cart[i].size!.id))
//         ){
//           if(cartMaster!.cart[i].menu.length==cart.menu.length){
//             bool exist=true;
//             for(int menuIndex=0;menuIndex<cartMaster!.cart[i].menu.length;menuIndex++){
//               if(exist==false){
//                 break;
//               }
//               if(cartMaster!.cart[i].menu[menuIndex].id==cart.menu[menuIndex].id){
//                 if(cartMaster!.cart[i].menu[menuIndex].addons.length==cart.menu[menuIndex].addons.length){
//                   for(int addonIndex=0;addonIndex<cartMaster!.cart[i].menu[menuIndex].addons.length;addonIndex++){
//                     if(cartMaster!.cart[i].menu[menuIndex].addons[addonIndex].id==cart.menu[menuIndex].addons[addonIndex].id){
//
//                     }
//                     else{
//                       exist = false;
//                       break;
//                     }
//                   }
//                 }
//                 else{
//                   exist = false;
//                   break;
//                 }
//               }
//               else {
//                 exist = false;
//                 break;
//               }
//             }
//
//             if(exist){
//               if(cartMaster!.cart[i].quantity==1){
//                 cartMaster!.cart.removeAt(i);
//                 return;
//               }
//               double amount=cartMaster!.cart[i].totalAmount/cartMaster!.cart[i].quantity;
//               cartMaster!.cart[i].quantity--;
//               cartMaster!.cart[i].totalAmount-=amount;
//               return;
//             }
//           }
//         }
//       }
//     }
//     //Message : does not exist
//   }
//   int getQuantity(Cart cart,int vendorId){
//     if(cartMaster!=null  && vendorId==cartMaster!.vendorId){
//       for(int i=0;i<cartMaster!.cart.length;i++){
//
//         if(
//         (cart.category==cartMaster!.cart[i].category) &&
//             ((cart.size==null && cartMaster!.cart[i].size==null) || (cart.size!=null && cartMaster!.cart[i].size!=null && cart.size!.id==cartMaster!.cart[i].size!.id))
//         ){
//           if(cartMaster!.cart[i].menu.length==cart.menu.length){
//             bool exist=true;
//             for(int menuIndex=0;menuIndex<cartMaster!.cart[i].menu.length;menuIndex++){
//               if(exist==false){
//                 break;
//               }
//               if(cartMaster!.cart[i].menu[menuIndex].id==cart.menu[menuIndex].id){
//                 if(cartMaster!.cart[i].menu[menuIndex].addons.length==cart.menu[menuIndex].addons.length){
//                   for(int addonIndex=0;addonIndex<cartMaster!.cart[i].menu[menuIndex].addons.length;addonIndex++){
//                     if(cartMaster!.cart[i].menu[menuIndex].addons[addonIndex].id==cart.menu[menuIndex].addons[addonIndex].id){
//
//                     }
//                     else{
//                       exist = false;
//                       break;
//                     }
//                   }
//                 }
//                 else{
//                   exist = false;
//                   break;
//                 }
//               }
//               else {
//                 exist = false;
//                 break;
//               }
//             }
//
//             if(exist){
//               return cartMaster!.cart[i].quantity;
//             }
//           }
//         }
//       }
//     }
//     return 0;
//   }
//   void addItemToast(){
//     // Fluttertoast.showToast(
//     //     msg: "$quantity Item added to cart",
//     //     toastLength: Toast.LENGTH_SHORT,
//     //     gravity: ToastGravity.CENTER,
//     //     timeInSecForIosWeb: 1,
//     //     backgroundColor: Colors.black,
//     //     textColor: Colors.white,
//     //     fontSize: 16.0
//     // );
//     Get.snackbar(
//       "$quantity Item added to cart",
//       "",
//       snackPosition:SnackPosition.BOTTOM,
//       backgroundColor: Color(Constants.colorTheme).withOpacity(0.8),
//       borderRadius: 0.0,
//       margin: EdgeInsets.all(0.0),
//       colorText: Colors.white,
//       snackStyle:SnackStyle.FLOATING,
//     );
//   }
//   void removeItemToast(){
//     Fluttertoast.showToast(
//         msg: "Item removed from cart",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 16.0
//     );
//   }
//
//
// }