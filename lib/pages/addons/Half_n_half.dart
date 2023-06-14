import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/config/screen_config.dart';
import 'package:pos/controller/cart_controller.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/model/SingleVendorRetrieveSize.dart' as singleVendorretrieveSizes;
import 'package:pos/model/single_restaurants_details_model.dart';
import 'package:pos/pages/addons/half_n_half_addons.dart';
import 'package:pos/model/cart_master.dart' as cartMaster;
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/utils/constants.dart';
import 'package:pos/utils/item_quantity.dart';
import 'package:pos/model/SingleVendorRetrieveSize.dart' as singleVendorRetrieveSize;

import '../../model/SingleVendorRetrieveSize.dart';

class HalfNHalf extends StatefulWidget {
 final String category;
 final int vendorId;
 final HalfNHalfMenu halfNHalfMenu;
  const HalfNHalf({Key? key,required this.category,required this.vendorId,required this.halfNHalfMenu}) : super(key: key);

  @override
  _HalfNHalfState createState() => _HalfNHalfState();
}

class _HalfNHalfState extends State<HalfNHalf>  with TickerProviderStateMixin {
  OrderCustimizationController _orderCustimizationController = Get.find<
      OrderCustimizationController>();
  CartController _cartController = Get.find<CartController>();
  int initPosition = 0;
  int sizeIndex = 0;
  // ScrollController _scrollController = ScrollController();
  List<String> data = ['First Half', 'Second Half',];
  Map<int, cartMaster.MenuCartMaster> menu = Map<int, cartMaster.MenuCartMaster>();
  TabController? _tabController;
  TabController? _halfController;
  List selectItemIndex=[];
  final sizeKey =  GlobalKey();
  final halfKey =  GlobalKey();
  bool runFirstTime=true;
  Future<BaseModel<singleVendorRetrieveSize.SingleVendorRetrieveSizes>>?  ref;

  @override
  void initState() {
    ref=_orderCustimizationController.getSingleVendorRetrieveSizesWithReturnValue(widget.halfNHalfMenu.id);
    _halfController = TabController(
        length: data.length, vsync: this);
    menu.clear();
    selectItemIndex=List.generate( data.length, (index) => -1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Scaffold(
      body: FutureBuilder<BaseModel<singleVendorRetrieveSize.SingleVendorRetrieveSizes>>(
        future:ref,
        builder: (context,snapshot){
          if(snapshot.hasData){
            singleVendorRetrieveSize.SingleVendorRetrieveSizes singleVendorRetrieveSizes=snapshot.data!.data!;
            if(runFirstTime){
              _orderCustimizationController.menuSizeList = singleVendorRetrieveSizes.data![sizeIndex]
                  .menuSize!;
              _tabController = TabController(
                  length: singleVendorRetrieveSizes.data!
                      .length, vsync: this);
              runFirstTime=false;
            }
            return
              // Text( '       '+singleVendorRetrieveSizes.data![sizeIndex]
              //   .menuSize!.length.toString());
              SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              image: CachedNetworkImageProvider(widget.halfNHalfMenu.image),
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
                            Text(widget.halfNHalfMenu.name,
                              maxLines: 2
                              ,style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 19,
                              ),),
                            SizedBox(
                              height: ScreenConfig.blockHeight*1,
                            ),
                            Text(
                              _orderCustimizationController.response.value.data!.vendor!.name,maxLines: 4,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(Constants.colorTheme),
                                overflow: TextOverflow.ellipsis,
                              ),),
                            SizedBox(
                              height: ScreenConfig.blockHeight*1,
                            ),
                            if (menu.length == 2) getAddButton(singleVendorRetrieveSizes) else Container()
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
                      child: Text(widget.halfNHalfMenu.description
                        ,maxLines: 4,
                        style: TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Size"
                          ,style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(Constants.colorTheme),
                          fontSize: 18,
                        ),
                        ),
                        Tooltip(
                          message: 'Select Size  First',
                          key: sizeKey,),
                        IconButton(onPressed: (){
                          final dynamic tooltip = sizeKey.currentState;
                          tooltip.ensureTooltipVisible();

                        }, icon:  Icon(Icons.help,color: Color(Constants.colorTheme),),),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    height: ScreenConfig.blockHeight * 5,
                    child: TabBar(
                      controller: _tabController,
                      unselectedLabelColor: Colors.redAccent,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent),
                      isScrollable: true,
                      tabs: List.generate(
                          singleVendorRetrieveSizes
                              .data!.length, (index) {

                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 1.0,horizontal: 25.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.redAccent, width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(singleVendorRetrieveSizes
                                    .data![index].name,),
                              ],
                            ),
                          ),
                        );
                      }

                      ),
                      onTap: (index) {
                        setState(() {
                          sizeIndex = index;
                          _tabController!.animateTo(index);
                          _orderCustimizationController.menuSizeList =
                          singleVendorRetrieveSizes
                              .data![index].menuSize!;
                          selectItemIndex=List.generate( data.length, (index) => -1);
                          menu.clear();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "HALF"
                          ,style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(Constants.colorTheme),
                          fontSize: 18,
                        ),
                        ),
                        Tooltip(
                          message: 'Select Both Half',
                          key: halfKey,),
                        IconButton(onPressed: (){
                          final dynamic tooltip = halfKey.currentState;
                          tooltip.ensureTooltipVisible();

                        }, icon:  Icon(Icons.help,color: Color(Constants.colorTheme),),),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    height: ScreenConfig.blockHeight * 5,
                    child: TabBar(
                      controller: _halfController,
                      unselectedLabelColor: Colors.redAccent,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent),
                      isScrollable: true,
                      tabs: List.generate(
                          data.length, (index) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 1.0,horizontal: 25.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.redAccent, width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(data[index]),
                              ],
                            ),
                          ),
                        );
                      }

                      ),
                      onTap: (index) {
                        setState(() {
                          initPosition = index;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: ScreenConfig.blockHeight*60,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: singleVendorRetrieveSizes.data![sizeIndex]
                              .menuSize!.length,
                          itemBuilder: (context, MenuSizeIndex) {

                            if (
                            singleVendorRetrieveSizes.data![sizeIndex]
                                .menuSize![MenuSizeIndex].menu!.singleMenu!.isNotEmpty
                                // &&
                                // singleVendorRetrieveSizes.data![sizeIndex]
                                //     .menuSize![MenuSizeIndex].menu!.singleMenu![0]
                                //     .singleMenuItemCategory!.isNotEmpty
                            ) {
                              return Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Column(
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
                                                  image: CachedNetworkImageProvider( singleVendorRetrieveSizes
                                                      .data![sizeIndex]
                                                      .menuSize![MenuSizeIndex].menu!
                                                      .image),
                                                  fit: BoxFit.fill),
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                          ),
                                          SizedBox(
                                            width: ScreenConfig.blockWidth*2,
                                          ),
                                          Flexible(

                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                //Menu Title
                                                Text(singleVendorRetrieveSizes
                                                    .data![sizeIndex]
                                                    .menuSize![MenuSizeIndex].menu!
                                                    .name,
                                                  maxLines: 2
                                                  ,style: TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    fontFamily: "ProximaBold",
                                                    color: Color(Constants.colorTheme),
                                                    fontSize: 17,
                                                  ),),

                                                SizedBox(
                                                  height: ScreenConfig.blockHeight,
                                                ),
                                                getHalfNhalfPrice(
                                                   singleVendorRetrieveSizes
                                                        .data![sizeIndex]
                                                        .menuSize![MenuSizeIndex]),
                                              ],
                                            ),
                                          ),
                                              (){
                                            if (singleVendorRetrieveSizes
                                                .data![sizeIndex]
                                                .menuSize![MenuSizeIndex]
                                                .menuAddon!.isNotEmpty){
                                              return  TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:MaterialStateProperty.all(
                                                        selectItemIndex[initPosition]==MenuSizeIndex?  Color(Constants.colorTheme):Colors.white
                                                    ) ,
                                                    fixedSize:MaterialStateProperty.all(
                                                        const Size(
                                                          75.0,
                                                          75.0,
                                                        )),
                                                    side: MaterialStateProperty.all(
                                                        BorderSide(
                                                          width: 2.0,
                                                          color: Colors.red,
                                                        )),
                                                  ),
                                                  onPressed: () async {
                                                    singleVendorretrieveSizes
                                                        .Menu menu = singleVendorRetrieveSizes
                                                        .data![sizeIndex]
                                                        .menuSize![MenuSizeIndex].menu!;
                                                    List<cartMaster
                                                        .AddonCartMaster>? addonsList = await showDialog(
                                                        context: context,
                                                        builder: (BuildContext context){
                                                          return AlertDialog(
                                                            contentPadding: EdgeInsets.all(0.0),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(20),
                                                              ),
                                                            ),
                                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                                            content: Builder(
                                                              builder: (context){
                                                                var height = MediaQuery.of(context).size.height;
                                                                var width = MediaQuery.of(context).size.width;
                                                                return
                                                                  Container(
                                                                      height: height-100,
                                                                      width: width *0.5,
                                                                      child: HalfNHalfAddons(
                                                                          menuSize: _orderCustimizationController
                                                                              .menuSizeList[MenuSizeIndex])
                                                                  );
                                                              },
                                                            ),

                                                          );
                                                        });
                                                    if(addonsList!=null){
                                                      double totalAmount = double.parse(

                                                             singleVendorRetrieveSizes
                                                              .data![sizeIndex]
                                                              .menuSize![MenuSizeIndex]
                                                              .price) / 2;
                                                      double diningAmount = double.parse(

                                                             singleVendorRetrieveSizes
                                                              .data![sizeIndex]
                                                              .menuSize![MenuSizeIndex]
                                                              .sizeDiningPrice??'0.0') / 2;
                                                      for (int i = 0; i <
                                                          addonsList.length; i++) {
                                                        totalAmount +=
                                                            addonsList[i].price;
                                                        diningAmount+=addonsList[i].diningPrice??0.0;
                                                      }
                                                      this.menu[initPosition] =
                                                          cartMaster.MenuCartMaster(id: menu.id,
                                                              modifiers: [],
                                                              name: menu.name,
                                                              image: menu.image,
                                                              diningAmount: diningAmount,
                                                              totalAmount: totalAmount,
                                                              addons: addonsList);
                                                      selectItemIndex[initPosition]=MenuSizeIndex;

                                                    }

                                                    setState(() {

                                                    });
                                                  },
                                                  child: (){
                                                    if(selectItemIndex[initPosition]==MenuSizeIndex){
                                                      return Text("ADDED",style: TextStyle(color: Colors.white),);
                                                    }else{
                                                      return Text("EDIT",style: TextStyle(color: Colors.redAccent),);
                                                    }
                                                  }());

                                            }else{
                                              return TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:MaterialStateProperty.all(
                                                        selectItemIndex[initPosition]==MenuSizeIndex?  Color(Constants.colorTheme):Colors.white
                                                    ) ,
                                                    fixedSize:MaterialStateProperty.all(
                                                        const Size(
                                                          75.0,
                                                          75.0,
                                                        )),
                                                    side: MaterialStateProperty.all(
                                                        BorderSide(
                                                          width: 2.0,
                                                          color: Colors.red,
                                                        )),
                                                  ),
                                                  onPressed: ()  {
                                                    // print(_orderCustimizationController
                                                    //     .singleVendorRetrieveSizes!
                                                    //     .data![sizeIndex]
                                                    //     .menuSize![MenuSizeIndex]
                                                    //     .sizeDiningPrice??'0.0');
                                                    singleVendorretrieveSizes
                                                        .Menu menu = singleVendorRetrieveSizes
                                                        .data![sizeIndex]
                                                        .menuSize![MenuSizeIndex].menu!;
                                                    this.menu[initPosition] =
                                                        cartMaster.MenuCartMaster(id: menu.id,
                                                            modifiers: [],
                                                            name: menu.name,
                                                            image: menu.image,
                                                            totalAmount: (double
                                                                .parse(
                                                                singleVendorRetrieveSizes
                                                                    .data![sizeIndex]
                                                                    .menuSize![MenuSizeIndex]
                                                                    .price) / 2),
                                                            diningAmount:(double
                                                                .parse(
                                                                singleVendorRetrieveSizes
                                                                    .data![sizeIndex]
                                                                    .menuSize![MenuSizeIndex]
                                                                    .sizeDiningPrice??'0.0') / 2) ,
                                                            addons: []);
                                                    selectItemIndex[initPosition]=MenuSizeIndex;
                                                    setState(() {

                                                    });
                                                  },
                                                  child: (){
                                                    if((selectItemIndex[initPosition]==MenuSizeIndex)){
                                                      return Text("ADDED",style: TextStyle(color: Colors.white),);
                                                    }else{
                                                      return Text("ADD",style: TextStyle(color: Colors.redAccent),);
                                                    }
                                                  }());
                                            }
                                          }(),
                                        ],
                                      ),

                                      Divider(
                                        color: Colors.red,
                                      ),
                                    ],
                                  )
                              );
                            } else {
                              print('ELSE');
                              return Container();
                            }
                          }),
                    ),
                  ),
                  //Spacer(),

                ],
              ),
            );


          }else if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()),);
          }else{
            return  Center(child:  CircularProgressIndicator(color: Color(Constants.colorTheme),));
          }
        },
      )
      //floatingActionButton: (menu.length == 2) ? getAddButton() : Container(),
    );
  }
  getAddButton(singleVendorRetrieveSize.SingleVendorRetrieveSizes singleVendorRetrieveSizes){
  double totalAmount = 0.0;
  List<cartMaster.MenuCartMaster> list = menu.values.toList();
  for (int i = 0; i < menu.values
      .toList()
      .length; i++) {
    totalAmount += list[i].totalAmount;
  }
  _cartController.quantity.value=_cartController.getQuantity(cartMaster.Cart(
    quantity: 1,
    totalAmount: totalAmount,
    category: widget.category,
    menu: menu.values.toList(),
    size: cartMaster.Size(
        id: singleVendorRetrieveSizes
            .data![sizeIndex].id,
        sizeName:
            singleVendorRetrieveSizes.data![sizeIndex].name),
    menuCategory: cartMaster.MenuCategoryCartMaster(
        id: widget.halfNHalfMenu.id,
        image: widget.halfNHalfMenu.image,
        name: widget.halfNHalfMenu.name),
  ), widget.vendorId);
  return ItemQuantity(btnPlusOnPressed: (){
     _cartController.addItem(
         getCurrentCart(singleVendorRetrieveSizes),
         widget.vendorId,context);
    _cartController.quantity.value=_cartController.getQuantity(
        getCurrentCart(singleVendorRetrieveSizes),
        widget.vendorId);

  }, btnMinusOnPressed: ()async{

     _cartController.removeItem(
       getCurrentCart(singleVendorRetrieveSizes),
         widget.vendorId);
    _cartController.quantity.value=_cartController.getQuantity(
       getCurrentCart(singleVendorRetrieveSizes),
        widget.vendorId);

  }, btnFloatOnPressed: ()async{
    if(_cartController.checkMenuExistInCart(widget.category, widget.halfNHalfMenu.id)){
      _cartController.addItem(
          getCurrentCart(singleVendorRetrieveSizes),
          widget.vendorId,context);
      _cartController.quantity.value=_cartController.getQuantity(
          getCurrentCart(singleVendorRetrieveSizes),
          widget.vendorId);
      // if( await _cartController.showMenuExistDialog(context)){
      //    _cartController.addItem(
      //    getCurrentCart(singleVendorRetrieveSizes),
      //        widget.vendorId,context);
      //   _cartController.quantity.value=_cartController.getQuantity(
      //      getCurrentCart(singleVendorRetrieveSizes),
      //       widget.vendorId);
      // }else{
      //   Get.snackbar("Item", "Not Added");
      // }
    }else {
       _cartController.addItem(
        getCurrentCart(singleVendorRetrieveSizes),
           widget.vendorId,context);
      _cartController.quantity.value=_cartController.getQuantity(
          getCurrentCart(singleVendorRetrieveSizes),
          widget.vendorId);
    }


  });
}
  getHalfNhalfPrice(singleVendorretrieveSizes.MenuSize menuSize) {
    if (menuSize.displayDiscountPrice == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Text(menuSize.menu!.name),
          // Text(''),
          Text((double.parse(menuSize.price)/2).toString()),
        ],
      );
    } else {
      return Column(
        children: [
         // Text(menuSize.menu!.name.toString()),
          Row(
            children: [
              Text((double.parse(menuSize.displayPrice??'0.0')/2).toString(), style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),),
              Text((double.parse(menuSize.displayDiscountPrice??'0.0')/2).toString()),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text((double.parse(menuSize.sizeDiningPrice??'0.0')/2).toString()),
          )
        ],
      );
    }
  }
  cartMaster.Cart getCurrentCart(SingleVendorRetrieveSizes singleVendorRetrieveSizes){
    double totalAmount = 0.0;
    double diningAmount=0.0;
    List<cartMaster.MenuCartMaster> list = menu.values.toList();
    for (int i = 0; i < menu.values
        .toList()
        .length; i++) {
      totalAmount += list[i].totalAmount;
      diningAmount += list[i].diningAmount??0.0;
    }
    return cartMaster.Cart(
      quantity: 1,
      totalAmount: totalAmount,
      diningAmount: diningAmount,
      category: widget.category,
      menu: menu.values.toList(),
      size: cartMaster.Size(
          id:singleVendorRetrieveSizes
              .data![sizeIndex].id,
          sizeName: singleVendorRetrieveSizes
              .data![sizeIndex].name),
      menuCategory: cartMaster.MenuCategoryCartMaster(
          id: widget.halfNHalfMenu.id,
          image: widget.halfNHalfMenu.image,
          name: widget.halfNHalfMenu.name),
    );

  }
}
