import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/config/screen_config.dart';
import 'package:pos/controller/cart_controller.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/model/single_restaurants_details_model.dart';
import 'package:pos/model/cart_master.dart' as cartMaster;
import 'package:pos/model/deals_sizes.dart' as dealSizes;
import 'package:pos/utils/constants.dart';
import 'package:pos/utils/item_quantity.dart';

import 'deals_addons.dart';

class DealsItems extends StatefulWidget {
  final List<DealsItem> dealsItemList;
  final DealsMenu dealsMenu;
  final String category;
  const DealsItems({Key? key,required this.dealsItemList,required this.dealsMenu,required this.category}) : super(key: key);

  @override
  _DealsItemsState createState() => _DealsItemsState();
}

class _DealsItemsState extends State<DealsItems> with SingleTickerProviderStateMixin {
  OrderCustimizationController _orderCustimizationController=Get.find<OrderCustimizationController>();
  TabController? _tabController;
  Future? singleVendorRetrieveSize;
  int initPosition = 0;
  List selectItemIndex=[];
  CartController _cartController=Get.find<CartController>();

  Map<int,cartMaster.MenuCartMaster> menu=Map<int,cartMaster.MenuCartMaster>();
  @override
  void initState() {
    _tabController=TabController(length:  widget.dealsItemList.length, vsync: this);
    selectItemIndex=List.generate( widget.dealsItemList.length, (index) => -1);
   if(widget.dealsItemList.isNotEmpty){
     singleVendorRetrieveSize=_orderCustimizationController.getSingleVendorRetrieveSize(
         widget.dealsItemList[0].vendorId,
         widget.dealsItemList[0].itemCategoryId,
         widget.dealsItemList[0].itemSizeId);
   }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Scaffold(
      body: Column(
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
                      image: CachedNetworkImageProvider(widget.dealsMenu.image),
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
                    Text(widget.dealsMenu.name,
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
                    (menu.length==widget.dealsItemList.length)?
                    getAddButton() :Container(),
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
              child: Text(widget.dealsMenu.description
                ,maxLines: 4,
                style: TextStyle(
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),),
            ),
          ),
          SizedBox(
            height: ScreenConfig.blockHeight,
          ),
        Container(
          margin: EdgeInsets.all(8.0),
          child: Align(
      alignment: Alignment.topLeft,
            child: SizedBox(
              height: ScreenConfig.blockHeight * 8,
              child: TabBar(
              controller:_tabController,
                unselectedLabelColor: Colors.redAccent,
                indicatorSize: TabBarIndicatorSize.label,
                // padding: EdgeInsets.only(bottom: 0.0),
                labelPadding: EdgeInsets.only(left: 8.0,right: 8.0),
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.redAccent),
                isScrollable: true,
              onTap: (int index){
                setState(() {
                  _tabController!.animateTo(index);
                  initPosition=index;
                  singleVendorRetrieveSize=_orderCustimizationController.getSingleVendorRetrieveSize(
                      widget.dealsItemList[index].vendorId,
                      widget.dealsItemList[index].itemCategoryId,
                      widget.dealsItemList[index].itemSizeId);
                });
              },
                tabs: List.generate(widget.dealsItemList.length, (index) {
                  return  Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.redAccent, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.dealsItemList[index].name),
                        ],
                      ),
                    ),
                  );
                }

                ),),
            ),
          ),
        ),
          (widget.dealsItemList.isNotEmpty)?
          Expanded(
            child: FutureBuilder(
                future: singleVendorRetrieveSize!,
                builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.done){
                      return ListView.builder(
                          itemCount: _orderCustimizationController.dealsSizes!.data!.menuSize!.length,
                          itemBuilder: (context,index){
                            //if(_orderCustimizationController.menuSizeList[MenuSizeIndex].menu!.singleMenu![0].singleMenuItemCategory!.isNotEmpty){
                            //print(_orderCustimizationController.dealsSizes!.data!.menuSize![index].menu!.singleMenu![0].toMap());

                            if(_orderCustimizationController.dealsSizes!.data!.menuSize![index].menu!.singleMenu.isNotEmpty && _orderCustimizationController.dealsSizes!.data!.menuSize![index].menu!.singleMenu[0].singleMenuItemCategory!.isNotEmpty){

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
                                                  image: CachedNetworkImageProvider(_orderCustimizationController.dealsSizes!.data!.menuSize![index].menu!.image),
                                                  fit: BoxFit.fill),
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                          ),
                                          SizedBox(
                                            width: ScreenConfig.blockWidth*2,
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                //Menu Title
                                                Text(_orderCustimizationController.dealsSizes!.data!.menuSize![index].menu!.name,
                                                  maxLines: 2
                                                  ,style: TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    fontFamily: "ProximaBold",
                                                    color: Color(Constants.colorTheme),
                                                    fontSize: 17,
                                                  ),),
                                                SizedBox(
                                                  height: ScreenConfig.blockHeight*1,
                                                ),
                                                //Menu description
                                                Text(_orderCustimizationController.dealsSizes!.data!.menuSize![index].menu!.description
                                                  ,maxLines: 4,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),),
                                                SizedBox(
                                                  height: ScreenConfig.blockHeight,
                                                ),
                                              ],
                                            ),
                                          ),
                                          (_orderCustimizationController.dealsSizes!.data!.menuSize![index].menuAddon!.isEmpty)?
                                          TextButton(
                                              style: ButtonStyle(
                                                side: MaterialStateProperty.all(BorderSide(
                                                  width: 2.0,
                                                  color: Colors.red,
                                                )),
                                              ),
                                              onPressed: ()async{
                                                dealSizes.Menu menu=_orderCustimizationController.dealsSizes!.data!.menuSize![index].menu!;
                                                this.menu[initPosition]=cartMaster.MenuCartMaster(id: menu.id,name:menu.name,image:menu.image,
                                                    totalAmount:0.0,
                                                    addons: [],
                                                    modifiers: [],
                                                    dealsItems:cartMaster.DealsItems(id: widget.dealsItemList[initPosition].id,name: widget.dealsItemList[initPosition].name));

                                                selectItemIndex[initPosition]=index;
                                                setState(() {

                                                });
                                              },
                                              child: (){
                                                  if(selectItemIndex[initPosition]==index){
                                                    return Text("ADDED",style: TextStyle(color: Colors.redAccent),);
                                                  }else{
                                                  return Text("ADD");
                                                  }

                                              }()):
                                          TextButton(
                                              style: ButtonStyle(
                                                side: MaterialStateProperty.all(BorderSide(
                                                  width: 2.0,
                                                  color: Colors.red,
                                                )),
                                              ),
                                              onPressed: ()async{
                                                dealSizes.Menu menu=_orderCustimizationController.dealsSizes!.data!.menuSize![index].menu!;

                                                List<cartMaster.AddonCartMaster>? addonsList=await showDialog(
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
                                                              SizedBox(
                                                                height: height-100,
                                                                width: width *0.5,
                                                                child: DealsAddons(
                                                                  menuSize: _orderCustimizationController.dealsSizes!.data!.menuSize![index],),
                                                              );
                                                          },
                                                        ),

                                                      );
                                                    });
                                                if (addonsList!=null) {
                                                  this.menu[initPosition]=cartMaster.MenuCartMaster(id: menu.id,name:menu.name,image:menu.image,
                                                      totalAmount:0.0,
                                                      addons: addonsList,
                                                      modifiers: [],
                                                      dealsItems:cartMaster.DealsItems(id: widget.dealsItemList[initPosition].id,name: widget.dealsItemList[initPosition].name)
                                                  );
                                                  selectItemIndex[initPosition]=index;
                                                }
                                                setState(() {

                                                });
                                              },
                                              child: (){
                                                if(selectItemIndex[initPosition]==index){
                                                  return Text("ADDED",style: TextStyle(color: Colors.redAccent),);
                                                }else{
                                                  return Text("EDIT");
                                                }
                                              }())
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.red,
                                      ),
                                    ],
                                  )
                              );
                            }else{
                              return Container();
                            }
                          });
                    }
                    if(snapshot.hasError){
                      print(snapshot.error);
                    }
                    return Center(
                      child: CircularProgressIndicator(color: Color(Constants.colorTheme) ),
                    );

            }),
          ):Container(),

        ],
      ),
    );
  }
  getAddButton(){
    _cartController.quantity.value=_cartController.getQuantity(cartMaster.Cart(
      quantity: 1,
      totalAmount: double.parse(widget.dealsMenu.price!),
      diningAmount: double.parse(widget.dealsMenu.dealsDiningPrice??'0.0'),
      category:widget.category,
      menu:menu.values.toList(),
      size: null,
      menuCategory:cartMaster.MenuCategoryCartMaster(id:widget.dealsMenu.id,image:widget.dealsMenu.image,name:widget.dealsMenu.name ),
    ), widget.dealsMenu.vendorId,);
    return ItemQuantity(btnFloatOnPressed:()async{
       _cartController.addItem(getCurrentCart(), widget.dealsMenu.vendorId,context);
      _cartController.quantity.value=_cartController.getQuantity(
        getCurrentCart(), widget.dealsMenu.vendorId,);

    }, btnPlusOnPressed: ()async{
       _cartController.addItem(
           getCurrentCart(), widget.dealsMenu.vendorId,context);
      _cartController.quantity.value=_cartController.getQuantity(getCurrentCart(), widget.dealsMenu.vendorId,);


    }, btnMinusOnPressed: (){
      _cartController.removeItem(getCurrentCart(), widget.dealsMenu.vendorId);
      _cartController.quantity.value=_cartController.getQuantity(
        getCurrentCart(),
        widget.dealsMenu.vendorId,);

    },);
  }
  cartMaster.Cart getCurrentCart(){
   return cartMaster.Cart(
        quantity: 1,
        totalAmount: double.parse(widget.dealsMenu.price!),
    diningAmount: double.parse(widget.dealsMenu.dealsDiningPrice??'0.0'),
    category:widget.category,
    menu:menu.values.toList(),
    size: null,
    menuCategory:cartMaster.MenuCategoryCartMaster(id:widget.dealsMenu.id,image:widget.dealsMenu.image,name:widget.dealsMenu.name )
    );
  }
}
