import 'dart:collection';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/config/Palette.dart';
import 'package:pos/constant/app_strings.dart';
import 'package:pos/controller/auth_controller.dart';
import 'package:pos/model/vendor/orders_response.dart';
import 'package:pos/widgets/custom_appbar.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/cart_master.dart';

// ignore: must_be_immutable
class OrderDetailScreen extends StatefulWidget {
  Data? data;
  CartMaster? cartMaster;
  OrderDetailScreen(Data data,CartMaster cartMaster) {
    this.data = data;
    this.cartMaster=cartMaster;
  }

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState(data);
}

String currencySymbol = '';

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Data? data;
  double subTotal = 0.0;
  late List<Cart> cart;
  Color primaryColor=Color(0xffd12828);
  //List<dynamic>? listTextData;

  _OrderDetailScreenState(Data? data) {
    this.data = data;
  }

  @override
  void initState() {
    cart=widget.cartMaster!.cart;
    // currencySymbol = AuthController.sharedPreferences!.getString(Preferences.currency_symbol);
    currencySymbol = '\$';
    for (int i = 0; i < data!.orderItems!.length; i++) {
      subTotal = subTotal + double.parse(data!.orderItems![i].price!.toString());
    }
    print("currency symbol ${currencySymbol}");
    //listTextData = jsonDecode(data!.tax!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //color set to transperent or set your own color
      statusBarIconBrightness: Brightness.dark,
      //set brightness for icons, like dark background light icons
    ));
    return Scaffold(
      appBar: AppBar(title: Text('Order Details'),),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/background.png')
            ,fit: BoxFit.cover),),
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          //padding: EdgeInsets.only(top: 10, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: CustomAppBar(title: '${data!.orderId}\n${data?.date}',iconButton: IconButton(onPressed: ()async{
                  Map<String, String?> param = HashMap();
                  param['id'] = data!.id.toString();
                  param['status'] = 'PRINT';
                  // await changeOrderStatus(param);
                }, icon: Icon(CupertinoIcons.printer_fill,
                  color: Colors.green,)),),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    )
                  ], borderRadius: BorderRadius.circular(25), color: Palette.white),
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            data!.userName!,
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontFamily: proxima_nova_reg,
                                fontSize: 16),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          child: Container(
                            child: Icon(Icons.call),
                          ),
                          onTap: () {
                            print(data!.userPhone);
                            launch("tel:+${data!.userPhone}");
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            child:CircleAvatar(child:Image.network("https://png.pngtree.com/element_our/sm/20180626/sm_5b321c99945a2.jpg") ,),
                          ),
                          onTap: () {
                            print(data!.userPhone);
                            // TODO: static +92 is given
                            launch("https://wa.me/${data!.userPhone}");
                            // launch("https://wa.me/9203360010088");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              // Flexible(
              //   fit: FlexFit.loose,
              //   child: Container(
              //     margin: EdgeInsets.only(left: 20, right: 20,),
              //     decoration: BoxDecoration(boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.5),
              //         spreadRadius: 2,
              //         blurRadius: 3,
              //         offset: Offset(0, 3),
              //       )
              //     ], borderRadius: BorderRadius.circular(25), color: Palette.white),
              //     child: ListView.builder(
              //       // padding: EdgeInsets.all(7.0),
              //         itemCount: cart.length,
              //         shrinkWrap: true,
              //         padding: EdgeInsets.only(bottom: 20.0,top: 20.0),
              //         physics: NeverScrollableScrollPhysics(),
              //         itemBuilder: (context,itemIndex){
              //           String category=cart[itemIndex].category;
              //           MenuCategory? menuCategory=cart[itemIndex].menuCategory;
              //           List<Menu> menu=cart[itemIndex].menu;
              //           if(category=='SINGLE'){
              //             return ListView.builder(
              //                 shrinkWrap: true,
              //                 itemCount: menu.length,
              //                 physics: NeverScrollableScrollPhysics(),
              //                 itemBuilder: (context,menuIndex){
              //                   Menu menuItem= menu[menuIndex];
              //                   return Column(
              //                     mainAxisSize: MainAxisSize.min,
              //                     children: [
              //                       Flexible(
              //                         fit: FlexFit.loose,
              //                         child:  Padding(
              //                           padding: const EdgeInsets.only(left: 15.0),
              //                           child: Row(
              //                             children: [
              //                               Text(menu[menuIndex].name+
              //                                   (cart[itemIndex].size!=null?' ( ${cart[itemIndex].size?.sizeName}) ':'')+' x ${cart[itemIndex].quantity}  ',
              //                                   style: TextStyle(color: primaryColor,fontWeight: FontWeight.w900, fontSize: 16)),
              //                               Container(
              //                                 height: 20,
              //                                 width: 60,
              //                                 decoration: BoxDecoration(
              //                                     color: primaryColor,
              //                                     borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                                 ),
              //                                 child: Center(
              //                                   child: Text('SINGLE',
              //                                       style: TextStyle(color: Colors.white,fontWeight:FontWeight.w300 , fontSize: 16)),
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                         ),
              //                       ),
              //                       Flexible(
              //                         fit: FlexFit.loose,
              //                         child: ListView.builder(
              //                             shrinkWrap: true,
              //                             physics: NeverScrollableScrollPhysics(),
              //                             itemCount: menuItem.addons.length,
              //                             padding: EdgeInsets.only(left: 25),
              //                             itemBuilder: (context,addonIndex){
              //                               Addon addonItem=menuItem.addons[addonIndex];
              //                               return Padding(
              //                                 padding: const EdgeInsets.only(top: 5.0),
              //                                 child: Row(
              //                                   children: [
              //                                     Text(addonItem.name+' '),
              //                                     Container(
              //                                       height: 20,
              //                                       padding: EdgeInsets.all(3.0),
              //                                       decoration: BoxDecoration(
              //                                           color: Colors.black,
              //                                           borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                                       ),
              //                                       child: Center(
              //                                         child: Text('ADDONS',
              //                                           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),),
              //                                       ),
              //                                     )
              //                                   ],
              //                                 ),
              //                               );
              //
              //                             }),
              //                       )
              //                     ],
              //                   );
              //                 });
              //           }
              //           else if(category=='HALF_N_HALF'){
              //             return Column(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Flexible(
              //                   fit: FlexFit.loose,
              //                   child:Padding(
              //                     padding: const EdgeInsets.only(top: 20.0,left: 15.0),
              //                     child: Row(
              //                       children: [
              //                         Text(menuCategory!.name
              //                             +(cart[itemIndex].size!=null?' ( ${cart[itemIndex].size?.sizeName}) ':'')
              //                             +' x ${cart[itemIndex].quantity}  '
              //                             ,style: TextStyle(color: primaryColor,fontWeight: FontWeight.w900, fontSize: 16)
              //                         ),
              //                         Container(
              //                           height: 20,
              //                           decoration: BoxDecoration(
              //                               color: primaryColor,
              //                               borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                           ),
              //                           child: Center(
              //                             child: Text(' HALF & HALF ',
              //                                 style: TextStyle(color: Colors.white,fontWeight:FontWeight.w300 , fontSize: 16)
              //                             ),
              //                           ),
              //                         )
              //                       ],
              //                     ),
              //                   ),),
              //                 Flexible(
              //                   fit: FlexFit.loose,
              //                   child: ListView.builder(
              //                       shrinkWrap: true,
              //                       padding: EdgeInsets.only(left: 25),
              //                       physics: NeverScrollableScrollPhysics(),
              //                       itemCount: menu.length,
              //                       itemBuilder: (context,menuIndex){
              //                         Menu menuItem= menu[menuIndex];
              //                         return Column(
              //                           mainAxisSize: MainAxisSize.min,
              //                           crossAxisAlignment: CrossAxisAlignment.start,
              //                           children: [
              //                             Flexible(
              //                                 fit: FlexFit.loose,
              //                                 child:Padding(
              //                                   padding: const EdgeInsets.only(top: 5.0),
              //                                   child: Row(
              //                                     children: [
              //                                       Text(menuItem.name+' ',style: TextStyle(fontWeight: FontWeight.w900),),
              //                                       if(menuIndex==0)
              //                                         Container(
              //                                           height: 20,
              //                                           padding: EdgeInsets.all(3.0),
              //                                           decoration: BoxDecoration(
              //                                               color: primaryColor,
              //                                               borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                                           ),
              //                                           child: Center(
              //                                             child: Text('First Half'.toUpperCase(),
              //                                               style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),),
              //                                           ),
              //                                         )
              //                                       else
              //                                         Container(
              //                                           height: 20,
              //                                           padding: EdgeInsets.all(3.0),
              //                                           decoration: BoxDecoration(
              //                                               color: primaryColor,
              //                                               borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                                           ),
              //
              //                                           child: Center(
              //                                             child: Text('Second Half'.toUpperCase(),
              //                                               style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),),
              //                                           ),
              //                                         )
              //                                     ],
              //                                   ),
              //                                 )
              //                             ),
              //                             Flexible(
              //                               fit: FlexFit.loose,
              //                               child: ListView.builder(
              //                                   shrinkWrap: true,
              //                                   physics: NeverScrollableScrollPhysics(),
              //                                   padding: EdgeInsets.only(left: 16,top: 5.0,),
              //                                   itemCount:menuItem.addons.length,
              //                                   itemBuilder: (context,addonIndex) {
              //                                     Addon addonItem=menuItem.addons[addonIndex];
              //                                     return Padding(
              //                                       padding: const EdgeInsets.only(bottom: 5.0),
              //                                       child: Row(children: [
              //                                         Text(addonItem.name+' '),
              //                                         Container(
              //                                           height: 20,
              //                                           padding: EdgeInsets.all(3.0),
              //                                           decoration: BoxDecoration(
              //                                               color: Colors.black,
              //                                               borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                                           ),
              //                                           child: Center(
              //                                             child: Text('ADDONS',
              //                                               style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),),
              //                                           ),
              //                                         ),
              //                                       ],),
              //                                     );
              //                                   }
              //                               ),
              //                             )
              //                           ],
              //                         );
              //
              //                       }),
              //                 ),
              //               ],
              //             );
              //           }else if(category=='DEALS'){
              //             return Column(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Flexible(
              //                   fit: FlexFit.loose,
              //                   child: Padding(
              //                     padding: const EdgeInsets.only(top: 20.0,left: 15.0),
              //                     child: Row(
              //                       children: [
              //                         Text(menuCategory!.name
              //                             +'  x ${cart[itemIndex].quantity} '
              //                             ,style: TextStyle(color: primaryColor,fontWeight: FontWeight.w900, fontSize: 16)
              //                         ),
              //                         Container(
              //                             height: 20,
              //                             padding: EdgeInsets.all(3.0),
              //                             decoration: BoxDecoration(
              //                                 color: primaryColor,
              //                                 borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                             ),
              //                             child: Center(child: Text('DEALS',style: TextStyle(color: Colors.white,fontWeight:FontWeight.w500 , fontSize: 14))))
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //                 Flexible(
              //                   fit: FlexFit.loose,
              //                   child: ListView.builder(
              //                       shrinkWrap: true,
              //                       padding: EdgeInsets.only(left: 25,top: 5.0),
              //                       physics: NeverScrollableScrollPhysics(),
              //                       itemCount: menu.length,
              //                       itemBuilder: (context,menuIndex){
              //                         Menu menuItem= menu[menuIndex];
              //                         DealsItems dealsItems=menu[menuIndex].dealsItems!;
              //                         return Column(
              //                           mainAxisSize: MainAxisSize.min,
              //                           crossAxisAlignment: CrossAxisAlignment.start,
              //                           children: [
              //                             Flexible(
              //                                 fit: FlexFit.loose,
              //                                 child:Row(
              //                                   children: [
              //                                     Text(menuItem.name+' ',style: TextStyle(fontWeight: FontWeight.w900),),
              //                                     Container(
              //                                         height: 20,
              //                                         padding: EdgeInsets.all(3.0),
              //                                         decoration: BoxDecoration(
              //                                             color: primaryColor,
              //                                             borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                                         ),
              //                                         child: Center(child: Text('${dealsItems.name} ',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),)))
              //                                   ],
              //                                 )
              //                             ),
              //                             Flexible(
              //                               fit: FlexFit.loose,
              //                               child: ListView.builder(
              //                                   shrinkWrap: true,
              //                                   physics: NeverScrollableScrollPhysics(),
              //                                   padding: EdgeInsets.only(left: 24,top: 5.0,),
              //                                   itemCount:menuItem.addons.length,
              //                                   itemBuilder: (context,addonIndex) {
              //                                     Addon addonItem=menuItem.addons[addonIndex];
              //                                     return Padding(
              //                                       padding: const EdgeInsets.only(bottom: 5.0),
              //                                       child: Row(children: [
              //                                         Text(addonItem.name+' '),
              //                                         Container(
              //                                           height: 20,
              //                                           padding: EdgeInsets.all(3.0),
              //                                           decoration: BoxDecoration(
              //                                               color: Colors.black,
              //                                               borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                                           ),
              //                                           child: Center(
              //                                             child: Text('ADDONS',
              //                                               style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),),
              //                                           ),
              //                                         )
              //                                       ],),
              //                                     );
              //                                   }
              //                               ),
              //                             )
              //                           ],
              //                         );
              //
              //                       }),
              //                 ),
              //               ],
              //             );
              //           }
              //           return Container();
              //         }),
              //   ),),
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    )
                  ], borderRadius: BorderRadius.circular(25), color: Palette.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                        child: ListView.builder(
                          itemCount: data!.orderItems!.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index1) {
                            Cart cartItem=cart[index1];
                            String category=cartItem.category;
                            List<MenuCartMaster> menu=cartItem.menu;
                            return Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            data!.orderItems![index1].itemName!,
                                            style: TextStyle(
                                                color: Palette.loginhead,
                                                fontFamily: "ProximaNova",
                                                fontSize: 14),
                                          ),
                                          Text(
                                            ' x ${data!.orderItems![index1].qty}',
                                            style: TextStyle(
                                                color: Color(colorTheme),
                                                fontFamily: "ProximaBold",
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                          (){
                                        if(category=='SINGLE' ){
                                          return SizedBox(
                                            height: (30*menu.length).toDouble(),
                                            width: Get.width*0.7,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                itemCount: menu.length,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemBuilder: (context,menuIndex){
                                                  MenuCartMaster menuItem= menu[menuIndex];
                                                  return Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Flexible(
                                                        fit: FlexFit.loose,
                                                        child: ListView.builder(
                                                            shrinkWrap: true,

                                                            physics: NeverScrollableScrollPhysics(),
                                                            itemCount: menuItem.addons.length,
                                                            padding: EdgeInsets.only(left: 5),
                                                            itemBuilder: (context,addonIndex){
                                                              AddonCartMaster addonItem=menuItem.addons[addonIndex];
                                                              return Padding(
                                                                padding: const EdgeInsets.only(top: 5.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(addonItem.name+' '),
                                                                    Container(
                                                                      height: 20,
                                                                      padding: EdgeInsets.all(3.0),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.black,
                                                                          borderRadius: BorderRadius.all(Radius.circular(4.0))
                                                                      ),
                                                                      child: Center(
                                                                        child: Text('ADDONS',
                                                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              );

                                                            }),
                                                      )
                                                    ],
                                                  );
                                                }),
                                          );
                                        }else{
                                          return Container();
                                        }
                                      }(),
                                    ],
                                  ),
                                  Text(
                                    '$currencySymbol ${data!.orderItems![index1].price.toString()}',
                                    style: TextStyle(
                                        color: Palette.loginhead,
                                        fontFamily: proxima_nova_reg,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 10.0,
                        dashColor: Palette.divider,
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                        dashGapRadius: 0.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal ",
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 15,
                                  fontFamily: "ProximaNova"),
                            ),
                            Text(
                              "$currencySymbol$subTotal",
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 15,
                                  fontFamily: "ProximaBold"),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 10.0,
                        dashColor: Palette.divider,
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                        dashGapRadius: 0.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Applied Coupon",
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 15,
                                  fontFamily: "ProximaNova"),
                            ),
                            Text(
                              "-$currencySymbol${data!.promoCodePrice}",
                              style: TextStyle(
                                  color: Palette.removeacct,
                                  fontSize: 15,
                                  fontFamily: "ProximaBold"),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                          child: Text(
                            "FPAR1223F(30%)",
                            style: TextStyle(
                                color: Color(colorTheme), fontSize: 15, fontFamily: "ProximaBold"),
                          ),
                        ),
                        visible: false,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 10.0,
                        dashColor: Palette.divider,
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                        dashGapRadius: 0.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   padding: EdgeInsets.only(
                      //     left: 20,
                      //     right: 20,
                      //   ),
                      //   child: ListView.builder(
                      //     shrinkWrap: true,
                      //     physics: NeverScrollableScrollPhysics(),
                      //     itemCount: listTextData!.length,
                      //     itemBuilder: (context, index) {
                      //       return listTextData!.length > 0
                      //           ? Container(
                      //               margin: EdgeInsets.only(bottom: 10, top: 10),
                      //               child: Row(
                      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                 children: [
                      //                   Text(
                      //                     "${listTextData![index]['name']}",
                      //                     style: TextStyle(
                      //                         fontSize: 14,
                      //                         color: Palette.loginhead,
                      //                         fontFamily: proxima_nova_reg),
                      //                   ),
                      //                   Text(
                      //                     "$currencySymbol${listTextData![index]['tax'].toString()}",
                      //                     style: TextStyle(
                      //                         fontSize: 13,
                      //                         color: Palette.loginhead,
                      //                         fontFamily: "ProximaNova"),
                      //                   ),
                      //                 ],
                      //               ),
                      //             )
                      //           : Container();
                      //     },
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 10.0,
                        dashColor: Palette.divider,
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                        dashGapRadius: 0.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Grand Total",
                              style: TextStyle(
                                  color: Color(colorTheme), fontSize: 15, fontFamily: "ProximaBold"),
                            ),
                            Text(
                              "$currencySymbol${data!.amount}",
                              style: TextStyle(
                                  color: Color(colorTheme), fontSize: 15, fontFamily: "ProximaBold"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              data!.deliveryType == 'HOME' && data!.deliveryPersonId != null
                  ? Flexible(
                fit: FlexFit.loose,
                    child: Container(
                        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          )
                        ], borderRadius: BorderRadius.circular(25), color: Palette.white),
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15), color: Colors.white),
                              child: Row(
                                children: [
                                  /*Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black),
                                    height: MediaQuery.of(context).size.height * 0.07,
                                    width: MediaQuery.of(context).size.width * 0.15,
                                  ),*/
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data!.deliveryPerson!.firstName! + ' ' + data!.deliveryPerson!.lastName!,
                                          style: TextStyle(
                                              color: Palette.loginhead,
                                              fontSize: 15,
                                              fontFamily: "ProximaBold"),
                                        ),
                                        Text(
                                          data!.deliveryPerson!.contact ?? '',
                                          style: TextStyle(
                                              color: Palette.switchs,
                                              fontSize: 15,
                                              fontFamily: "ProximaNova"),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: GestureDetector(
                                onTap: () {
                                  launch("tel://${data!.deliveryPerson!.contact}");
                                },
                                child: Container(
                                  child: Image.asset("assets/images/call.png"),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                  )
                  : Container(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              if(data!.userAddress!=null)
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      )
                    ], borderRadius: BorderRadius.circular(25), color: Palette.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //SHOP

                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          width: Get.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                width: Get.width*0.7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data!.userName??'',
                                      style: TextStyle(
                                          color: Palette.loginhead,
                                          fontFamily: proxima_nova_bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      data!.userAddress ?? 'sdas',
                                      style: TextStyle(
                                          color: Palette.switchs,
                                          fontFamily: proxima_nova_reg,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        data!.deliveryType == 'HOME' && data!.userAddress != null
                            ? Container(
                          width: 100.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(left: 10, top: 2),
                                  child: Image.asset("assets/images/two.png")),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                width: 70.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Home",
                                      style: TextStyle(
                                          color: Palette.loginhead,
                                          fontFamily: "ProximaBold",
                                          fontSize: 16),
                                    ),
                                    Text(
                                      data!.vendorAddress!,
                                      style: TextStyle(
                                          color: Palette.switchs,
                                          fontFamily: proxima_nova_reg,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                            : Container(),

                      ],
                    ),
                  ),
                ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.03,
              // ),
              // Flexible(
              //   fit: FlexFit.loose,
              //   child: Container(
              //     margin: EdgeInsets.only(left: 20, right: 20,),
              //     decoration: BoxDecoration(boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.5),
              //         spreadRadius: 2,
              //         blurRadius: 3,
              //         offset: Offset(0, 3),
              //       )
              //     ], borderRadius: BorderRadius.circular(25), color: Palette.white),
              //     child: ListView.builder(
              //       // padding: EdgeInsets.all(7.0),
              //         itemCount: cart.length,
              //         shrinkWrap: true,
              //         padding: EdgeInsets.only(bottom: 20.0,top: 20.0),
              //         physics: NeverScrollableScrollPhysics(),
              //         itemBuilder: (context,itemIndex){
              //           String category=cart[itemIndex].category;
              //           MenuCategory? menuCategory=cart[itemIndex].menuCategory;
              //           List<Menu> menu=cart[itemIndex].menu;
              //           if(category=='SINGLE'){
              //             return ListView.builder(
              //                 shrinkWrap: true,
              //                 itemCount: menu.length,
              //                 physics: NeverScrollableScrollPhysics(),
              //                 itemBuilder: (context,menuIndex){
              //                   Menu menuItem= menu[menuIndex];
              //                   return Column(
              //                     mainAxisSize: MainAxisSize.min,
              //                     children: [
              //                       Flexible(
              //                         fit: FlexFit.loose,
              //                         child:  Padding(
              //                           padding: const EdgeInsets.only(left: 15.0),
              //                           child: Row(
              //                             children: [
              //                               Text(menu[menuIndex].name+
              //                                   (cart[itemIndex].size!=null?' ( ${cart[itemIndex].size?.sizeName}) ':'')+' x ${cart[itemIndex].quantity}  ',
              //                                   style: TextStyle(color: primaryColor,fontWeight: FontWeight.w900, fontSize: 16)),
              //                               Container(
              //                                 height: 20,
              //                                 width: 60,
              //                                 decoration: BoxDecoration(
              //                                     color: primaryColor,
              //                                     borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                                 ),
              //                                 child: Center(
              //                                   child: Text('SINGLE',
              //                                       style: TextStyle(color: Colors.white,fontWeight:FontWeight.w300 , fontSize: 16)),
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                         ),
              //                       ),
              //                       Flexible(
              //                         fit: FlexFit.loose,
              //                         child: ListView.builder(
              //                             shrinkWrap: true,
              //                             physics: NeverScrollableScrollPhysics(),
              //                             itemCount: menuItem.addons.length,
              //                             padding: EdgeInsets.only(left: 25),
              //                             itemBuilder: (context,addonIndex){
              //                               Addon addonItem=menuItem.addons[addonIndex];
              //                               return Padding(
              //                                 padding: const EdgeInsets.only(top: 5.0),
              //                                 child: Row(
              //                                   children: [
              //                                     Text(addonItem.name+' '),
              //                                     Container(
              //                                       height: 20,
              //                                       padding: EdgeInsets.all(3.0),
              //                                       decoration: BoxDecoration(
              //                                           color: Colors.black,
              //                                           borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                                       ),
              //                                       child: Center(
              //                                         child: Text('ADDONS',
              //                                           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),),
              //                                       ),
              //                                     )
              //                                   ],
              //                                 ),
              //                               );
              //
              //                             }),
              //                       )
              //                     ],
              //                   );
              //                 });
              //           }
              //           else if(category=='HALF_N_HALF'){
              //             return Column(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Flexible(
              //                   fit: FlexFit.loose,
              //                   child:Padding(
              //                     padding: const EdgeInsets.only(top: 20.0,left: 15.0),
              //                     child: Row(
              //                       children: [
              //                         Text(menuCategory!.name
              //                             +(cart[itemIndex].size!=null?' ( ${cart[itemIndex].size?.sizeName}) ':'')
              //                             +' x ${cart[itemIndex].quantity}  '
              //                             ,style: TextStyle(color: primaryColor,fontWeight: FontWeight.w900, fontSize: 16)
              //                         ),
              //                         Container(
              //                           height: 20,
              //                           decoration: BoxDecoration(
              //                               color: primaryColor,
              //                               borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                           ),
              //                           child: Center(
              //                             child: Text(' HALF & HALF ',
              //                                 style: TextStyle(color: Colors.white,fontWeight:FontWeight.w300 , fontSize: 16)
              //                             ),
              //                           ),
              //                         )
              //                       ],
              //                     ),
              //                   ),),
              //                 Flexible(
              //                   fit: FlexFit.loose,
              //                   child: ListView.builder(
              //                       shrinkWrap: true,
              //                       padding: EdgeInsets.only(left: 25),
              //                       physics: NeverScrollableScrollPhysics(),
              //                       itemCount: menu.length,
              //                       itemBuilder: (context,menuIndex){
              //                         Menu menuItem= menu[menuIndex];
              //                         return Column(
              //                           mainAxisSize: MainAxisSize.min,
              //                           crossAxisAlignment: CrossAxisAlignment.start,
              //                           children: [
              //                             Flexible(
              //                                 fit: FlexFit.loose,
              //                                 child:Padding(
              //                                   padding: const EdgeInsets.only(top: 5.0),
              //                                   child: Row(
              //                                     children: [
              //                                       Text(menuItem.name+' ',style: TextStyle(fontWeight: FontWeight.w900),),
              //                                       if(menuIndex==0)
              //                                         Container(
              //                                           height: 20,
              //                                           padding: EdgeInsets.all(3.0),
              //                                           decoration: BoxDecoration(
              //                                               color: primaryColor,
              //                                               borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                                           ),
              //                                           child: Center(
              //                                             child: Text('First Half'.toUpperCase(),
              //                                               style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),),
              //                                           ),
              //                                         )
              //                                       else
              //                                         Container(
              //                                           height: 20,
              //                                           padding: EdgeInsets.all(3.0),
              //                                           decoration: BoxDecoration(
              //                                               color: primaryColor,
              //                                               borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                                           ),
              //
              //                                           child: Center(
              //                                             child: Text('Second Half'.toUpperCase(),
              //                                               style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),),
              //                                           ),
              //                                         )
              //                                     ],
              //                                   ),
              //                                 )
              //                             ),
              //                             Flexible(
              //                               fit: FlexFit.loose,
              //                               child: ListView.builder(
              //                                   shrinkWrap: true,
              //                                   physics: NeverScrollableScrollPhysics(),
              //                                   padding: EdgeInsets.only(left: 16,top: 5.0,),
              //                                   itemCount:menuItem.addons.length,
              //                                   itemBuilder: (context,addonIndex) {
              //                                     Addon addonItem=menuItem.addons[addonIndex];
              //                                     return Padding(
              //                                       padding: const EdgeInsets.only(bottom: 5.0),
              //                                       child: Row(children: [
              //                                         Text(addonItem.name+' '),
              //                                         Container(
              //                                           height: 20,
              //                                           padding: EdgeInsets.all(3.0),
              //                                           decoration: BoxDecoration(
              //                                               color: Colors.black,
              //                                               borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                                           ),
              //                                           child: Center(
              //                                             child: Text('ADDONS',
              //                                               style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),),
              //                                           ),
              //                                         ),
              //                                       ],),
              //                                     );
              //                                   }
              //                               ),
              //                             )
              //                           ],
              //                         );
              //
              //                       }),
              //                 ),
              //               ],
              //             );
              //           }else if(category=='DEALS'){
              //             return Column(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Flexible(
              //                   fit: FlexFit.loose,
              //                   child: Padding(
              //                     padding: const EdgeInsets.only(top: 20.0,left: 15.0),
              //                     child: Row(
              //                       children: [
              //                         Text(menuCategory!.name
              //                             +'  x ${cart[itemIndex].quantity} '
              //                             ,style: TextStyle(color: primaryColor,fontWeight: FontWeight.w900, fontSize: 16)
              //                         ),
              //                         Container(
              //                             height: 20,
              //                             padding: EdgeInsets.all(3.0),
              //                             decoration: BoxDecoration(
              //                                 color: primaryColor,
              //                                 borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                             ),
              //                             child: Center(child: Text('DEALS',style: TextStyle(color: Colors.white,fontWeight:FontWeight.w500 , fontSize: 14))))
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //                 Flexible(
              //                   fit: FlexFit.loose,
              //                   child: ListView.builder(
              //                       shrinkWrap: true,
              //                       padding: EdgeInsets.only(left: 25,top: 5.0),
              //                       physics: NeverScrollableScrollPhysics(),
              //                       itemCount: menu.length,
              //                       itemBuilder: (context,menuIndex){
              //                         Menu menuItem= menu[menuIndex];
              //                         DealsItems dealsItems=menu[menuIndex].dealsItems!;
              //                         return Column(
              //                           mainAxisSize: MainAxisSize.min,
              //                           crossAxisAlignment: CrossAxisAlignment.start,
              //                           children: [
              //                             Flexible(
              //                                 fit: FlexFit.loose,
              //                                 child:Row(
              //                                   children: [
              //                                     Text(menuItem.name+' ',style: TextStyle(fontWeight: FontWeight.w900),),
              //                                     Container(
              //                                         height: 20,
              //                                         padding: EdgeInsets.all(3.0),
              //                                         decoration: BoxDecoration(
              //                                             color: primaryColor,
              //                                             borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                                         ),
              //                                         child: Center(child: Text('${dealsItems.name} ',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),)))
              //                                   ],
              //                                 )
              //                             ),
              //                             Flexible(
              //                               fit: FlexFit.loose,
              //                               child: ListView.builder(
              //                                   shrinkWrap: true,
              //                                   physics: NeverScrollableScrollPhysics(),
              //                                   padding: EdgeInsets.only(left: 24,top: 5.0,),
              //                                   itemCount:menuItem.addons.length,
              //                                   itemBuilder: (context,addonIndex) {
              //                                     Addon addonItem=menuItem.addons[addonIndex];
              //                                     return Padding(
              //                                       padding: const EdgeInsets.only(bottom: 5.0),
              //                                       child: Row(children: [
              //                                         Text(addonItem.name+' '),
              //                                         Container(
              //                                           height: 20,
              //                                           padding: EdgeInsets.all(3.0),
              //                                           decoration: BoxDecoration(
              //                                               color: Colors.black,
              //                                               borderRadius: BorderRadius.all(Radius.circular(4.0))
              //                                           ),
              //                                           child: Center(
              //                                             child: Text('ADDONS',
              //                                               style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),),
              //                                           ),
              //                                         )
              //                                       ],),
              //                                     );
              //                                   }
              //                               ),
              //                             )
              //                           ],
              //                         );
              //
              //                       }),
              //                 ),
              //               ],
              //             );
              //           }
              //           return Container();
              //         }),
              //   ),),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
