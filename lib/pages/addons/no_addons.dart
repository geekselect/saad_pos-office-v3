import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pos/config/screen_config.dart';
import 'package:pos/controller/cart_controller.dart';
import 'package:pos/model/cart_master.dart';
import 'package:pos/model/single_restaurants_details_model.dart' as singleResturantDetailModel;
import 'package:pos/utils/constants.dart';
import 'package:pos/utils/item_quantity.dart';
class NoAddons extends StatefulWidget {
  final singleResturantDetailModel.Menu menu;
  final String category;
  final singleResturantDetailModel.Vendor vendor;
  const NoAddons({Key? key,required this.menu,required this.category,required this.vendor}) : super(key: key);

  @override
  _NoAddonsState createState() => _NoAddonsState();
}

class _NoAddonsState extends State<NoAddons> {
  CartController _cartController=Get.find<CartController>();
  @override
  void initState() {
    _cartController.quantity.value=_cartController.getQuantity(
        Cart(
            category: widget.category,
            menu:[ MenuCartMaster(
             name: widget.menu.name, 
              totalAmount: double.parse(widget.menu.price!), 
              id: widget.menu.id, addons: [],
              modifiers: [],
              image: widget.menu.image,
            )], size: null,
            totalAmount: double.parse(widget.menu.price!),
            diningAmount: double.parse(widget.menu.diningPrice??'0.0'),
            quantity: 1),
        widget.menu.vendorId);
    print("Quantity ${_cartController.quantity.value}");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              // margin: EdgeInsets.only(left: 5.0),
              // decoration: ,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.menu.image),
                    fit: BoxFit.cover),
                // borderRadius: BorderRadius.circular(12.0),
                borderRadius: BorderRadius.only(topLeft:Radius.circular(8.0) ),
              ),
            ),
            SizedBox(
              width: ScreenConfig.blockWidth*2,
            ),
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.menu.name,
                    maxLines: 2
                    ,style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 19,
                    ),),
                  SizedBox(
                    height: ScreenConfig.blockHeight*1,
                  ),
                  Text(
                    widget.vendor.name,maxLines: 4,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(Constants.colorTheme),
                      overflow: TextOverflow.ellipsis,
                    ),),
                  SizedBox(
                    height: ScreenConfig.blockHeight*1,
                  ),
                  ItemQuantity(btnPlusOnPressed: ()async{
                    print("cart data quantity plus ${_cartController.quantity.value}");
                    Cart cart=Cart(
                        category: widget.category,
                        menu:[ MenuCartMaster(
                          name: widget.menu.name,
                          totalAmount: double.parse(widget.menu.price!),
                          id: widget.menu.id, addons: [],
                          modifiers: [],
                          image: widget.menu.image,
                        )],
                        size: null,
                        totalAmount: double.parse(widget.menu.price!),
                        diningAmount: double.parse(widget.menu.diningPrice??'0'),
                        quantity: 1);
                     _cartController.addItem(
                        cart,widget.menu.vendorId,context);
                    _cartController.quantity.value=_cartController.getQuantity(
                       cart, widget.menu.vendorId);


                  }, btnMinusOnPressed: (){
                    print("cart data quantity minus ${_cartController.quantity.value}");
                    Cart cart=Cart(
                        category: widget.category,
                        menu:[ MenuCartMaster(
                          name: widget.menu.name,
                          totalAmount: double.parse(widget.menu.price!),
                          id: widget.menu.id, addons: [],
                          modifiers: [],
                          image: widget.menu.image,
                        )],
                        size: null,
                        totalAmount: double.parse(widget.menu.price!),
                        diningAmount: double.parse(widget.menu.diningPrice??'0'),
                        quantity: 1);
                    _cartController.removeItem(
                        cart, widget.menu.vendorId);
                    _cartController.quantity.value=_cartController.getQuantity(
                        cart, widget.menu.vendorId);

                  }, btnFloatOnPressed: ()async{
                    //
                    // _cartController
                    //     .addItem(
                    //    Cart(
                    //         diningAmount: double.parse(
                    //             widget
                    //                 .menu
                    //                 .diningPrice!),
                    //         category:
                    //         "SINGLE",
                    //         menu: [
                    //           MenuCartMaster(
                    //             name:
                    //             widget.menu.name,
                    //             totalAmount:
                    //             double.parse(widget.menu.price!),
                    //             id: widget.menu.id,
                    //             addons: [],
                    //             image:
                    //             widget.menu.image,
                    //           )
                    //         ],
                    //         size:
                    //         null,
                    //         totalAmount: double.parse(widget
                    //             .menu
                    //             .price!),
                    //         quantity:
                    //         1),
                    //     int.parse(widget.menu.vendorId.toString()),
                    //     context);

                    print("cart data quantity flat ${_cartController.quantity.value}");
                    ///Previous
                    print("No Addon Flat Button");
                    Cart cart=Cart(
                        category: widget.category,
                        menu:[ MenuCartMaster(
                          name: widget.menu.name,
                          totalAmount: double.parse(widget.menu.price!),
                          id: widget.menu.id, addons: [],
                          modifiers: [],
                          image: widget.menu.image,
                        )],
                        size: null,
                        totalAmount: double.parse(widget.menu.price!),
                        diningAmount: double.parse(widget.menu.diningPrice??'0'),
                        quantity: 1);
                     _cartController.addItem(
                        cart,widget.menu.vendorId,context);
                    _cartController.quantity.value =_cartController.getQuantity(
                       cart, widget.menu.vendorId);


                  })

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
          height: ScreenConfig.blockHeight*1,
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Text('Description',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),))),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Text(widget.menu.description
              ,maxLines: 4,
              style: TextStyle(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),),
          ),
        ),

      ],
    );
  }
}
