// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pos/config/screen_config.dart';
// import 'package:pos/controller/cart_controller.dart';
// import 'package:pos/model/single_restaurants_details_model.dart'
//     as singleResturantDetailModel;
// import 'package:pos/model/cart_master.dart' as cartMaster;
// import 'package:pos/model/single_restaurants_details_model.dart';
// import 'package:pos/utils/constants.dart';
// import 'package:pos/utils/custom_list_tile.dart';
// import 'package:pos/utils/item_quantity.dart';
//
// class AddonsOnly extends StatefulWidget {
//   final singleResturantDetailModel.Menu data;
//   final String menuPrice;
//   final int menuId;
//   final String category;
//   final Vendor vendor;
//
//   const AddonsOnly(
//       {Key? key,
//       required this.data,
//       required this.menuPrice,
//       required this.menuId,
//       required this.category,
//       required this.vendor})
//       : super(key: key);
//
//   @override
//   _AddonsOnlyState createState() => _AddonsOnlyState();
// }
//
// class _AddonsOnlyState extends State<AddonsOnly> {
//   // List<String> data = ['Page 0', 'Page 1', 'Page 2'];
//   Set set = Set();
//
//   int initPosition = 0;
//   CartController _cartController = Get.find<CartController>();
//
//   @override
//   void initState() {
//     _cartController.quantity.value =
//         _cartController.getQuantity(getCurrentCart(), widget.data.vendorId);
//
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenConfig().init(context);
//     set.clear();
//
//
//     return Scaffold(
//       body: SafeArea(
//           child: SizedBox(
//         width: Get.width,
//         height: Get.height,
//         child: Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   height: 180,
//                   width: 180,
//                   // margin: EdgeInsets.only(left: 5.0),
//                   // decoration: ,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image: CachedNetworkImageProvider(widget.data.image),
//                         fit: BoxFit.cover),
//                     // borderRadius: BorderRadius.circular(12.0),
//                     borderRadius:
//                         BorderRadius.only(topLeft: Radius.circular(8.0)),
//                   ),
//                 ),
//                 SizedBox(
//                   width: ScreenConfig.blockWidth * 2,
//                 ),
//                 Flexible(
//                   flex: 4,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.data.name,
//                         maxLines: 2,
//                         style: TextStyle(
//                           overflow: TextOverflow.ellipsis,
//                           fontSize: 19,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         widget.vendor.name,
//                         maxLines: 4,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Color(Constants.colorTheme),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         'Description',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         widget.data.description,
//                         maxLines: 4,
//                         style: TextStyle(
//                           fontSize: 14,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       ItemQuantity(btnPlusOnPressed: () async {
//                         _cartController.addItem(
//                             getCurrentCart(), widget.data.vendorId, context);
//                         _cartController.quantity.value =
//                             _cartController.getQuantity(
//                                 getCurrentCart(), widget.data.vendorId);
//                       }, btnMinusOnPressed: () async {
//                         _cartController.removeItem(
//                             getCurrentCart(), widget.data.vendorId);
//                         _cartController.quantity.value =
//                             _cartController.getQuantity(
//                                 getCurrentCart(), widget.data.vendorId);
//                       }, btnFloatOnPressed: () {
//                         _cartController.addItem(
//                             getCurrentCart(), widget.data.vendorId, context);
//                         _cartController.quantity.value =
//                             _cartController.getQuantity(
//                                 getCurrentCart(), widget.data.vendorId);
//                       }),
//
//                       // (_orderCustimizationController.response!.data!.menuCategory![index].singleMenu![i].menu!.displayDiscountPrice==null)?
//                       // Text(
//                       //   (_orderCustimizationController.response!.data!.menuCategory![index].singleMenu![i].menu!.price==null) ?
//                       //   '' :
//                       //   "Price "+_orderCustimizationController.response!.data!.menuCategory![index].singleMenu![i].menu!.price.toString()
//                       //   ,style: TextStyle(
//                       //       fontSize: 10
//                       //   ),):
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.start,
//                       //   children: [
//                       //   Text('${_orderCustimizationController.response!.data!.menuCategory![index].singleMenu![i].menu!.displayPrice}',style: TextStyle(decoration:  TextDecoration.lineThrough,color: Colors.grey),),
//                       //     Text(' ${_orderCustimizationController.response!.data!.menuCategory![index].singleMenu![i].menu!.displayDiscountPrice}')
//                       //   ],
//                       // ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: ScreenConfig.blockHeight * 1,
//             ),
//             Expanded(
//               flex: 2,
//               child: ListView.builder(
//                   //physics: const NeverScrollableScrollPhysics(),
//                   // itemCount: length,
//                   itemCount: widget.data.groupMenuAddon!.length,
//                   shrinkWrap: true,
//                   itemBuilder: (context, groupMenuAddonIndex) {
//                     final key = GlobalKey();
//
//                     if (set.contains(widget
//                         .data
//                         .groupMenuAddon![groupMenuAddonIndex]
//                         .addonCategoryId)) {
//                       print("SET ${set.first.toString()}");
//                       return Container();
//                     } else {
//                       set.add(widget.data.groupMenuAddon![groupMenuAddonIndex]
//                           .addonCategoryId);
//                       return Column(
//                         children: [
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Text(
//                                   '${widget.data
//                                       .groupMenuAddon![groupMenuAddonIndex]
//                                       .addonCategory!.name}(${widget.data
//                                       .groupMenuAddon![groupMenuAddonIndex]
//                                       .addonCategory!.min}-${widget.data
//                                       .groupMenuAddon![groupMenuAddonIndex]
//                                       .addonCategory!.max})',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     color: Color(Constants.colorTheme),
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ),
//                               // Tooltip(
//                               // message: 'Minimum Selection ${widget.data.groupMenuAddon![groupMenuAddonIndex].addonCategory!.min}\n'
//                               //     'Maximum Selection ${widget.data.groupMenuAddon![groupMenuAddonIndex].addonCategory!.max}',
//                               // showDuration: Duration(seconds: 0),
//                               // child: Icon(Icons.help,color: Color(Constants.colorTheme),),
//                               // ),
//                               Tooltip(
//                                 message:
//                                 'Minimum Selection ${widget.data
//                                     .groupMenuAddon![groupMenuAddonIndex]
//                                     .addonCategory!.min}\n'
//                                     'Maximum Selection ${widget.data
//                                     .groupMenuAddon![groupMenuAddonIndex]
//                                     .addonCategory!.max}',
//                                 key: key,
//                               ),
//                               IconButton(
//                                 onPressed: () {
//                                   final dynamic tooltip = key.currentState;
//                                   tooltip.ensureTooltipVisible();
//                                 },
//                                 icon: Icon(
//                                   Icons.help,
//                                   color: Color(Constants.colorTheme),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Container(
//                             child: ListView.builder(
//                               padding: EdgeInsets.zero,
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: widget.data.menuAddon!.length,
//                                 itemBuilder: (context, menuAddonIndex) {
//                                   if (widget
//                                       .data
//                                       .groupMenuAddon![groupMenuAddonIndex]
//                                       .addonCategoryId ==
//                                       widget.data.menuAddon![menuAddonIndex]
//                                           .addonCategoryId) {
//                                     if (widget.data.menuAddon![menuAddonIndex]
//                                         .addon!.isChecked ==
//                                         1) {}
//                                     return CustomListTile(
//                                       title: widget.data
//                                           .menuAddon![menuAddonIndex].addon!.name,
//                                       price: widget
//                                           .data.menuAddon![menuAddonIndex].price
//                                           .toString(),
//                                       checkboxValue: widget
//                                           .data
//                                           .menuAddon![menuAddonIndex]
//                                           .addon!
//                                           .isChecked ==
//                                           0
//                                           ? false
//                                           : true,
//                                       onChange: (bool? value) {
//                                         setState(() {
//                                           if (value == true) {
//                                             int checkedCount = 0;
//                                             for (int i = 0;
//                                             i < widget.data.menuAddon!.length;
//                                             i++) {
//                                               if (widget
//                                                   .data
//                                                   .groupMenuAddon![
//                                               groupMenuAddonIndex]
//                                                   .addonCategoryId !=
//                                                   widget.data.menuAddon![i]
//                                                       .addonCategoryId) {
//                                                 continue;
//                                               }
//                                               print(widget.data.menuAddon![i]
//                                                   .addon!.isChecked);
//                                               if (widget.data.menuAddon![i].addon!
//                                                   .isChecked ==
//                                                   1) checkedCount++;
//                                             }
//                                             print(checkedCount);
//                                             if (checkedCount <
//                                                 widget
//                                                     .data
//                                                     .groupMenuAddon![
//                                                 groupMenuAddonIndex]
//                                                     .addonCategory!
//                                                     .max) {
//                                               widget
//                                                   .data
//                                                   .menuAddon![menuAddonIndex]
//                                                   .addon!
//                                                   .isChecked = 1;
//                                             } else
//                                               widget
//                                                   .data
//                                                   .menuAddon![menuAddonIndex]
//                                                   .addon!
//                                                   .isChecked = 0;
//                                           } else {
//                                             widget.data.menuAddon![menuAddonIndex]
//                                                 .addon!.isChecked = 0;
//                                           }
//
//                                           _cartController.quantity.value =
//                                               _cartController.getQuantity(
//                                                   getCurrentCart(),
//                                                   widget.data.vendorId);
//                                         });
//                                       },
//                                       diningPrice: widget
//                                           .data
//                                           .menuAddon![menuAddonIndex]
//                                           .addonDiningPrice
//                                           .toString(),
//                                     );
//
//                                     // CheckboxListTile(
//                                     //   title: Text(widget.data.menuAddon![menuAddonIndex].addon!.name),
//                                     //   subtitle: Text("Price"+widget.data.menuAddon![menuAddonIndex].price.toString()),
//                                     //   value: widget.data.menuAddon![menuAddonIndex].addon!.isChecked==0?false:true,
//                                     //   onChanged: (bool? value){
//                                     //     setState(() {
//                                     //       if(value==true){
//                                     //         int checkedCount=0;
//                                     //         for(int i=0;i<widget.data.menuAddon!.length;i++){
//                                     //           if(widget.data.groupMenuAddon![groupMenuAddonIndex].addonCategoryId!=widget.data.menuAddon![i].addonCategoryId){
//                                     //             continue;
//                                     //           }
//                                     //           print(widget.data.menuAddon![i].addon!.isChecked);
//                                     //           if(widget.data.menuAddon![i].addon!.isChecked==1)
//                                     //             checkedCount++;
//                                     //         }
//                                     //         print(checkedCount);
//                                     //         if(checkedCount<widget.data.groupMenuAddon![groupMenuAddonIndex].addonCategory!.max){
//                                     //           widget.data.menuAddon![menuAddonIndex].addon!.isChecked=1;
//                                     //         }
//                                     //         else
//                                     //           widget.data.menuAddon![menuAddonIndex].addon!.isChecked=0;
//                                     //
//                                     //       }else{
//                                     //         widget.data.menuAddon![menuAddonIndex].addon!.isChecked=0;
//                                     //       }
//                                     //       double totalAmount=double.parse(widget.menuPrice);
//                                     //       List<cartMaster.Addon> addonsList=[];
//                                     //       Set set=Set();
//                                     //       print("selected item name");
//                                     //       for(int i=0;i<widget.data.groupMenuAddon!.length;i++){
//                                     //         if(set.contains(widget.data.groupMenuAddon![i].addonCategoryId)){
//                                     //
//                                     //         }else{
//                                     //           set.add(widget.data.groupMenuAddon![i].addonCategoryId);
//                                     //           for(int menuAddonIndex=0;menuAddonIndex<widget.data.menuAddon!.length;menuAddonIndex++){
//                                     //             if(widget.data.groupMenuAddon![i].addonCategoryId==widget.data.menuAddon![menuAddonIndex].addonCategoryId){
//                                     //               if(widget.data.menuAddon![menuAddonIndex].addon!.isChecked==1){
//                                     //                 print(widget.data.menuAddon![menuAddonIndex].addon!.name);
//                                     //                 addonsList.add(cartMaster.Addon(
//                                     //                   id: widget.data.menuAddon![menuAddonIndex].id,
//                                     //                   name:widget.data.menuAddon![menuAddonIndex].addon!.name,
//                                     //                   price: double.parse(widget.data.menuAddon![menuAddonIndex].price!),
//                                     //                 ));
//                                     //                 totalAmount+=double.parse(widget.data.menuAddon![menuAddonIndex].price!);
//                                     //
//                                     //               }
//                                     //             }
//                                     //           }
//                                     //         }
//                                     //
//                                     //
//                                     //       }
//                                     //       _cartController.quantity.value=_cartController.getQuantity(cartMaster.Cart(
//                                     //           quantity: 1,
//                                     //           totalAmount: totalAmount,
//                                     //           category:widget.category,
//                                     //           menu:[cartMaster.Menu(id: widget.data.id,name:widget.data.name,image:widget.data.image ,totalAmount:totalAmount, addons: addonsList)],
//                                     //           size: null), widget.data.vendorId);
//                                     //     });
//                                     //
//                                     //
//                                     //   });
//                                   } else {
//                                     return Container();
//                                   }
//                                 }),
//                           ),
//                         ],
//                       );
//                     }
//                   })
//             ),
//           ],
//         ),
//       )),
//     );
//   }
//
//   cartMaster.Cart getCurrentCart() {
//     double totalAmount = double.parse(widget.menuPrice);
//     double diningAmount = double.parse(widget.data.diningPrice ?? '0.0');
//
//     List<cartMaster.AddonCartMaster> addonsList = [];
//     Set set = {};
//
//     for (int i = 0; i < widget.data.groupMenuAddon!.length; i++) {
//       if (set.contains(widget.data.groupMenuAddon![i].addonCategoryId)) {
//       } else {
//         set.add(widget.data.groupMenuAddon![i].addonCategoryId);
//         for (int menuAddonIndex = 0;
//             menuAddonIndex < widget.data.menuAddon!.length;
//             menuAddonIndex++) {
//           if (widget.data.groupMenuAddon![i].addonCategoryId ==
//               widget.data.menuAddon![menuAddonIndex].addonCategoryId) {
//             if (widget.data.menuAddon![menuAddonIndex].addon!.isChecked == 1) {
//               addonsList.add(cartMaster.AddonCartMaster(
//                 id: widget.data.menuAddon![menuAddonIndex].id,
//                 name: widget.data.menuAddon![menuAddonIndex].addon!.name,
//                 price:
//                     double.parse(widget.data.menuAddon![menuAddonIndex].price!),
//                 diningPrice: double.parse(
//                     widget.data.menuAddon![menuAddonIndex].addonDiningPrice ??
//                         '0.0'),
//               ));
//               totalAmount +=
//                   double.parse(widget.data.menuAddon![menuAddonIndex].price!);
//               diningAmount += double.parse(
//                   widget.data.menuAddon![menuAddonIndex].addonDiningPrice ??
//                       '0.0');
//             }
//           }
//         }
//       }
//     }
//     return cartMaster.Cart(
//         quantity: 1,
//         totalAmount: totalAmount,
//         diningAmount: diningAmount,
//         category: widget.category,
//         menu: [
//           cartMaster.MenuCartMaster(
//               id: widget.data.id,
//               name: widget.data.name,
//               image: widget.data.image,
//               totalAmount: totalAmount,
//               addons: addonsList)
//         ],
//         size: null);
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/config/screen_config.dart';
import 'package:pos/controller/cart_controller.dart';
import 'package:pos/model/single_restaurants_details_model.dart'
as singleResturantDetailModel;
import 'package:pos/model/cart_master.dart' as cartMaster;
import 'package:pos/model/single_restaurants_details_model.dart';
import 'package:pos/utils/constants.dart';
import 'package:pos/utils/custom_list_tile.dart';
import 'package:pos/utils/item_quantity.dart';

class AddonsOnly extends StatefulWidget {
  final singleResturantDetailModel.Menu data;
  final String menuPrice;
  final int menuId;
  final String category;
  final Vendor vendor;

  const AddonsOnly(
      {Key? key,
        required this.data,
        required this.menuPrice,
        required this.menuId,
        required this.category,
        required this.vendor})
      : super(key: key);

  @override
  _AddonsOnlyState createState() => _AddonsOnlyState();
}

class _AddonsOnlyState extends State<AddonsOnly> {
  Set set = Set();

  int initPosition = 0;
  CartController _cartController = Get.find<CartController>();

  @override
  void initState() {
    _cartController.quantity.value =
        _cartController.getQuantity(getCurrentCart(), widget.data.vendorId);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    set.clear();


    return Scaffold(
      body: SafeArea(
          child: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 125,
                      width: 125,
                      // margin: EdgeInsets.only(left: 5.0),
                      // decoration: ,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(widget.data.image),
                            fit: BoxFit.cover),
                        // borderRadius: BorderRadius.circular(12.0),
                        borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(8.0)),
                      ),
                    ),
                    SizedBox(
                      width: ScreenConfig.blockWidth * 2,
                    ),
                    Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            widget.data.name,
                            maxLines: 2,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 19,
                            ),
                          ),
                          Text(
                            widget.data.price.toString(),
                            maxLines: 2,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),

                          Text(
                            'Description',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            widget.data.description,
                            maxLines: 4,
                            style: TextStyle(
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ItemQuantity(btnPlusOnPressed: () async {
                            _cartController.addItem(
                                getCurrentCart(), widget.data.vendorId, context);
                            _cartController.quantity.value =
                                _cartController.getQuantity(
                                    getCurrentCart(), widget.data.vendorId);
                          }, btnMinusOnPressed: () async {
                            _cartController.removeItem(
                                getCurrentCart(), widget.data.vendorId);
                            _cartController.quantity.value =
                                _cartController.getQuantity(
                                    getCurrentCart(), widget.data.vendorId);
                          }, btnFloatOnPressed: () {
                            print("DATA ${widget.data.toMap()}");
                            _cartController.addItem(
                                getCurrentCart(), widget.data.vendorId, context);
                            _cartController.quantity.value =
                                _cartController.getQuantity(
                                    getCurrentCart(), widget.data.vendorId);
                          }),

                          // (_orderCustimizationController.response!.data!.menuCategory![index].singleMenu![i].menu!.displayDiscountPrice==null)?
                          // Text(
                          //   (_orderCustimizationController.response!.data!.menuCategory![index].singleMenu![i].menu!.price==null) ?
                          //   '' :
                          //   "Price "+_orderCustimizationController.response!.data!.menuCategory![index].singleMenu![i].menu!.price.toString()
                          //   ,style: TextStyle(
                          //       fontSize: 10
                          //   ),):
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //   Text('${_orderCustimizationController.response!.data!.menuCategory![index].singleMenu![i].menu!.displayPrice}',style: TextStyle(decoration:  TextDecoration.lineThrough,color: Colors.grey),),
                          //     Text(' ${_orderCustimizationController.response!.data!.menuCategory![index].singleMenu![i].menu!.displayDiscountPrice}')
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenConfig.blockHeight * 1,
                ),

                Expanded(
                    flex: 2,
                    child: ListView.builder(
                      //physics: const NeverScrollableScrollPhysics(),
                      // itemCount: length,
                        itemCount: widget.data.groupMenuAddon!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, groupMenuAddonIndex) {
                          final key = GlobalKey();

                          if (set.contains(widget
                              .data
                              .groupMenuAddon![groupMenuAddonIndex]
                              .addonCategoryId)) {
                            print("SET ${set.first.toString()}");
                            return Container();
                          } else {
                            set.add(widget.data.groupMenuAddon![groupMenuAddonIndex]
                                .addonCategoryId);
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        '${widget.data
                                            .groupMenuAddon![groupMenuAddonIndex]
                                            .addonCategory!.name}(${widget.data
                                            .groupMenuAddon![groupMenuAddonIndex]
                                            .addonCategory!.min}-${widget.data
                                            .groupMenuAddon![groupMenuAddonIndex]
                                            .addonCategory!.max})',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Color(Constants.colorTheme),
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    // Tooltip(
                                    // message: 'Minimum Selection ${widget.data.groupMenuAddon![groupMenuAddonIndex].addonCategory!.min}\n'
                                    //     'Maximum Selection ${widget.data.groupMenuAddon![groupMenuAddonIndex].addonCategory!.max}',
                                    // showDuration: Duration(seconds: 0),
                                    // child: Icon(Icons.help,color: Color(Constants.colorTheme),),
                                    // ),
                                    Tooltip(
                                      message:
                                      'Minimum Selection ${widget.data
                                          .groupMenuAddon![groupMenuAddonIndex]
                                          .addonCategory!.min}\n'
                                          'Maximum Selection ${widget.data
                                          .groupMenuAddon![groupMenuAddonIndex]
                                          .addonCategory!.max}',
                                      key: key,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        final dynamic tooltip = key.currentState;
                                        tooltip.ensureTooltipVisible();
                                      },
                                      icon: Icon(
                                        Icons.help,
                                        color: Color(Constants.colorTheme),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: widget.data.menuAddon!.length,
                                      itemBuilder: (context, menuAddonIndex) {
                                        if (widget
                                            .data
                                            .groupMenuAddon![groupMenuAddonIndex]
                                            .addonCategoryId ==
                                            widget.data.menuAddon![menuAddonIndex]
                                                .addonCategoryId) {
                                          if (widget.data.menuAddon![menuAddonIndex]
                                              .addon!.isChecked ==
                                              1) {}
                                          return CustomListTile(
                                            title: widget.data
                                                .menuAddon![menuAddonIndex].addon!.name,
                                            price: widget
                                                .data.menuAddon![menuAddonIndex].price
                                                .toString(),
                                            checkboxValue: widget
                                                .data
                                                .menuAddon![menuAddonIndex]
                                                .addon!
                                                .isChecked ==
                                                0
                                                ? false
                                                : true,
                                            onChange: (bool? value) {
                                              setState(() {
                                                if (value == true) {
                                                  int checkedCount = 0;
                                                  for (int i = 0;
                                                  i < widget.data.menuAddon!.length;
                                                  i++) {
                                                    if (widget
                                                        .data
                                                        .groupMenuAddon![
                                                    groupMenuAddonIndex]
                                                        .addonCategoryId !=
                                                        widget.data.menuAddon![i]
                                                            .addonCategoryId) {
                                                      continue;
                                                    }
                                                    print(widget.data.menuAddon![i]
                                                        .addon!.isChecked);
                                                    if (widget.data.menuAddon![i].addon!
                                                        .isChecked ==
                                                        1) checkedCount++;
                                                  }
                                                  print(checkedCount);
                                                  if (checkedCount <
                                                      widget
                                                          .data
                                                          .groupMenuAddon![
                                                      groupMenuAddonIndex]
                                                          .addonCategory!
                                                          .max) {
                                                    widget
                                                        .data
                                                        .menuAddon![menuAddonIndex]
                                                        .addon!
                                                        .isChecked = 1;
                                                  } else
                                                    widget
                                                        .data
                                                        .menuAddon![menuAddonIndex]
                                                        .addon!
                                                        .isChecked = 0;
                                                } else {
                                                  widget.data.menuAddon![menuAddonIndex]
                                                      .addon!.isChecked = 0;
                                                }

                                                _cartController.quantity.value =
                                                    _cartController.getQuantity(
                                                        getCurrentCart(),
                                                        widget.data.vendorId);
                                              });
                                            },
                                            diningPrice: widget
                                                .data
                                                .menuAddon![menuAddonIndex]
                                                .addonDiningPrice
                                                .toString(),
                                          );

                                          // CheckboxListTile(
                                          //   title: Text(widget.data.menuAddon![menuAddonIndex].addon!.name),
                                          //   subtitle: Text("Price"+widget.data.menuAddon![menuAddonIndex].price.toString()),
                                          //   value: widget.data.menuAddon![menuAddonIndex].addon!.isChecked==0?false:true,
                                          //   onChanged: (bool? value){
                                          //     setState(() {
                                          //       if(value==true){
                                          //         int checkedCount=0;
                                          //         for(int i=0;i<widget.data.menuAddon!.length;i++){
                                          //           if(widget.data.groupMenuAddon![groupMenuAddonIndex].addonCategoryId!=widget.data.menuAddon![i].addonCategoryId){
                                          //             continue;
                                          //           }
                                          //           print(widget.data.menuAddon![i].addon!.isChecked);
                                          //           if(widget.data.menuAddon![i].addon!.isChecked==1)
                                          //             checkedCount++;
                                          //         }
                                          //         print(checkedCount);
                                          //         if(checkedCount<widget.data.groupMenuAddon![groupMenuAddonIndex].addonCategory!.max){
                                          //           widget.data.menuAddon![menuAddonIndex].addon!.isChecked=1;
                                          //         }
                                          //         else
                                          //           widget.data.menuAddon![menuAddonIndex].addon!.isChecked=0;
                                          //
                                          //       }else{
                                          //         widget.data.menuAddon![menuAddonIndex].addon!.isChecked=0;
                                          //       }
                                          //       double totalAmount=double.parse(widget.menuPrice);
                                          //       List<cartMaster.Addon> addonsList=[];
                                          //       Set set=Set();
                                          //       print("selected item name");
                                          //       for(int i=0;i<widget.data.groupMenuAddon!.length;i++){
                                          //         if(set.contains(widget.data.groupMenuAddon![i].addonCategoryId)){
                                          //
                                          //         }else{
                                          //           set.add(widget.data.groupMenuAddon![i].addonCategoryId);
                                          //           for(int menuAddonIndex=0;menuAddonIndex<widget.data.menuAddon!.length;menuAddonIndex++){
                                          //             if(widget.data.groupMenuAddon![i].addonCategoryId==widget.data.menuAddon![menuAddonIndex].addonCategoryId){
                                          //               if(widget.data.menuAddon![menuAddonIndex].addon!.isChecked==1){
                                          //                 print(widget.data.menuAddon![menuAddonIndex].addon!.name);
                                          //                 addonsList.add(cartMaster.Addon(
                                          //                   id: widget.data.menuAddon![menuAddonIndex].id,
                                          //                   name:widget.data.menuAddon![menuAddonIndex].addon!.name,
                                          //                   price: double.parse(widget.data.menuAddon![menuAddonIndex].price!),
                                          //                 ));
                                          //                 totalAmount+=double.parse(widget.data.menuAddon![menuAddonIndex].price!);
                                          //
                                          //               }
                                          //             }
                                          //           }
                                          //         }
                                          //
                                          //
                                          //       }
                                          //       _cartController.quantity.value=_cartController.getQuantity(cartMaster.Cart(
                                          //           quantity: 1,
                                          //           totalAmount: totalAmount,
                                          //           category:widget.category,
                                          //           menu:[cartMaster.Menu(id: widget.data.id,name:widget.data.name,image:widget.data.image ,totalAmount:totalAmount, addons: addonsList)],
                                          //           size: null), widget.data.vendorId);
                                          //     });
                                          //
                                          //
                                          //   });
                                        } else {
                                          return Container();
                                        }
                                      }),
                                ),
                              ],
                            );
                          }
                        })
                ),
              ],
            ),
          )),
    );
  }

  cartMaster.Cart getCurrentCart() {
    double totalAmount = double.parse(widget.menuPrice);
    double diningAmount = double.parse(widget.data.diningPrice ?? '0.0');

    List<cartMaster.AddonCartMaster> addonsList = [];
    Set set = {};

    for (int i = 0; i < widget.data.groupMenuAddon!.length; i++) {
      if (set.contains(widget.data.groupMenuAddon![i].addonCategoryId)) {
      } else {
        set.add(widget.data.groupMenuAddon![i].addonCategoryId);
        for (int menuAddonIndex = 0;
        menuAddonIndex < widget.data.menuAddon!.length;
        menuAddonIndex++) {
          if (widget.data.groupMenuAddon![i].addonCategoryId ==
              widget.data.menuAddon![menuAddonIndex].addonCategoryId) {
            if (widget.data.menuAddon![menuAddonIndex].addon!.isChecked == 1) {
              addonsList.add(cartMaster.AddonCartMaster(
                id: widget.data.menuAddon![menuAddonIndex].id,
                name: widget.data.menuAddon![menuAddonIndex].addon!.name,
                price:
                double.parse(widget.data.menuAddon![menuAddonIndex].price!),
                diningPrice: double.parse(
                    widget.data.menuAddon![menuAddonIndex].addonDiningPrice ??
                        '0.0'),
              ));
              totalAmount +=
                  double.parse(widget.data.menuAddon![menuAddonIndex].price!);
              diningAmount += double.parse(
                  widget.data.menuAddon![menuAddonIndex].addonDiningPrice ??
                      '0.0');
            }
          }
        }
      }
    }
    return cartMaster.Cart(
        quantity: 1,
        totalAmount: totalAmount,
        diningAmount: diningAmount,
        category: widget.category,
        menu: [
          cartMaster.MenuCartMaster(
              id: widget.data.id,
              name: widget.data.name,
              image: widget.data.image,
              totalAmount: totalAmount,
              addons: addonsList)
        ],
        size: null);
  }
}
