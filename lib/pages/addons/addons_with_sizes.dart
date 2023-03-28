import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/config/screen_config.dart';
import 'package:pos/controller/cart_controller.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/model/cart_master.dart';
import 'package:pos/model/single_restaurants_details_model.dart' as singleVendorDetailModel;
import 'package:pos/model/cart_master.dart' as cartMaster;
import 'package:pos/model/single_restaurants_details_model.dart';
import 'package:pos/utils/constants.dart';
import 'package:pos/utils/custom_list_tile.dart';
import 'package:pos/utils/item_quantity.dart';

class AddonsWithSized extends StatefulWidget {
  final List<singleVendorDetailModel.MenuSize> data;
  final String category;
  final singleVendorDetailModel.Menu menu;
  const AddonsWithSized({Key? key,required this.data,required this.category,required this.menu}) : super(key: key);

  @override
  _AddonsWithSizedState createState() => _AddonsWithSizedState();
}

class _AddonsWithSizedState extends State<AddonsWithSized> with SingleTickerProviderStateMixin {
  CartController _cartController=Get.find<CartController>();
  List<String> data = ['Page 0', 'Page 1', 'Page 2'];
  int initPosition = 0;
  TabController? _tabController;
  OrderCustimizationController _orderCustimizationController=Get.find<OrderCustimizationController>();
  final key =  GlobalKey();
  @override
  void initState() {
    _tabController = TabController(
        length: widget.data
            .length, vsync: this);
    Set set=Set();
    double totalAmount=double.parse(widget.data[initPosition].price.toString());
    double diningAmount=double.parse(widget.data[initPosition].sizeDiningPrice??'0.0');
    List<cartMaster.AddonCartMaster> addonsList=[];
    for(int i=0;i<widget.data[initPosition].groupMenuAddon!.length;i++){
      if(set.contains(widget.data[initPosition].groupMenuAddon![i].addonCategoryId)){

      }else{
        set.add(widget.data[initPosition].groupMenuAddon![i].addonCategoryId);
        for(int menuAddonIndex=0;menuAddonIndex<widget.data[initPosition].menuAddon!.length;menuAddonIndex++){
          if(widget.data[initPosition].groupMenuAddon![i].addonCategoryId==widget.data[initPosition].menuAddon![menuAddonIndex].addonCategoryId){
            if(widget.data[initPosition].menuAddon![menuAddonIndex].addon!.isChecked==1){
              addonsList.add(cartMaster.AddonCartMaster(
                id: widget.data[initPosition].menuAddon![menuAddonIndex].id,
                name:widget.data[initPosition].menuAddon![menuAddonIndex].addon!.name ,
                price: double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].price!),
                diningPrice: double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice??'0.0'),
                ),
              );
              totalAmount+=double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].price.toString());
              diningAmount+=double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice??'0.0');
            }
          }
        }

      }

    }
    _cartController.quantity.value=_cartController.getQuantity(cartMaster.Cart(
        quantity: 1,
        totalAmount: totalAmount,
        diningAmount: diningAmount,
        category:widget.category,menu:[cartMaster.MenuCartMaster(id: widget.menu.id,name:widget.menu.name,image:widget.menu.image ,totalAmount:totalAmount, addons: addonsList)],size: Size(sizeName: widget.data[initPosition].itemSize!.name.toString(), id: widget.data[initPosition].itemSize!.id!)), widget.menu.vendorId);
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
                      _orderCustimizationController.response!.data!.vendor!.name,maxLines: 4,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(Constants.colorTheme),
                        overflow: TextOverflow.ellipsis,
                      ),),
                    SizedBox(
                      height: ScreenConfig.blockHeight*1,
                    ),
                    ItemQuantity(
                        btnFloatOnPressed: () async{
                          if (_cartController.checkMenuExistInCart(widget.category, widget.menu.id)) {
                           if( await _cartController.showMenuExistDialog(context)){
                               Set set={};
                               double totalAmount=double.parse(widget.data[initPosition].price.toString());
                               double diningAmount=double.parse(widget.data[initPosition].sizeDiningPrice??'0.0');
                               List<cartMaster.AddonCartMaster> addonsList=[];
                               for(int i=0;i<widget.data[initPosition].groupMenuAddon!.length;i++){
                                 if(set.contains(widget.data[initPosition].groupMenuAddon![i].addonCategoryId)){

                                 }else{
                                   set.add(widget.data[initPosition].groupMenuAddon![i].addonCategoryId);
                                   for(int menuAddonIndex=0;menuAddonIndex<widget.data[initPosition].menuAddon!.length;menuAddonIndex++){
                                     if(widget.data[initPosition].groupMenuAddon![i].addonCategoryId==widget.data[initPosition].menuAddon![menuAddonIndex].addonCategoryId){
                                       if(widget.data[initPosition].menuAddon![menuAddonIndex].addon!.isChecked==1){

                                         addonsList.add(cartMaster.AddonCartMaster(
                                           id: widget.data[initPosition].menuAddon![menuAddonIndex].id,
                                           name:widget.data[initPosition].menuAddon![menuAddonIndex].addon!.name ,
                                           price: double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].price!),
                                           diningPrice: double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice??'0.0'),
                                         ));
                                         totalAmount+=double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].price.toString());
                                         diningAmount+=double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice??'0.0');
                                       }
                                     }
                                   }

                                 }

                               }
                                _cartController.addItem(cartMaster.Cart(
                                   quantity: 1,
                                   totalAmount: totalAmount,
                                   diningAmount: diningAmount,
                                   category:widget.category,menu:[cartMaster.MenuCartMaster(id: widget.menu.id,name:widget.menu.name,image:widget.menu.image ,totalAmount:totalAmount, addons: addonsList)],size: Size(sizeName: widget.data[initPosition].itemSize!.name.toString(), id: widget.data[initPosition].itemSize!.id!)), widget.menu.vendorId,context);
                               _cartController.quantity.value=_cartController.getQuantity(cartMaster.Cart(
                                   quantity: 1,
                                   totalAmount: totalAmount,
                                   diningAmount: diningAmount,
                                   category:widget.category,menu:[cartMaster.MenuCartMaster(id: widget.menu.id,name:widget.menu.name,image:widget.menu.image ,totalAmount:totalAmount, addons: addonsList)],size: Size(sizeName: widget.data[initPosition].itemSize!.name.toString(), id: widget.data[initPosition].itemSize!.id!)), widget.menu.vendorId);
                               setState(() {

                               });

                           } else{
                             Get.snackbar("Item", "Not Added");
                           }
                          }else{
                            Set set=Set();
                            double totalAmount=double.parse(widget.data[initPosition].price.toString());
                            double diningAmount=double.parse(widget.data[initPosition].sizeDiningPrice??'0.0');
                            List<cartMaster.AddonCartMaster> addonsList=[];
                            for(int i=0;i<widget.data[initPosition].groupMenuAddon!.length;i++){
                              if(set.contains(widget.data[initPosition].groupMenuAddon![i].addonCategoryId)){

                              }else{
                                set.add(widget.data[initPosition].groupMenuAddon![i].addonCategoryId);
                                for(int menuAddonIndex=0;menuAddonIndex<widget.data[initPosition].menuAddon!.length;menuAddonIndex++){
                                  if(widget.data[initPosition].groupMenuAddon![i].addonCategoryId==widget.data[initPosition].menuAddon![menuAddonIndex].addonCategoryId){
                                    if(widget.data[initPosition].menuAddon![menuAddonIndex].addon!.isChecked==1){
                                      addonsList.add(cartMaster.AddonCartMaster(
                                        id: widget.data[initPosition].menuAddon![menuAddonIndex].id,
                                        name:widget.data[initPosition].menuAddon![menuAddonIndex].addon!.name ,
                                        price: double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].price!,),
                                        diningPrice: double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice??'0.0',),
                                      ));
                                      totalAmount+=double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].price.toString());
                                      diningAmount+=double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice??'0.0');
                                    }
                                  }
                                }

                              }

                            }
                             _cartController.addItem(cartMaster.Cart(
                                quantity: 1,
                                totalAmount: totalAmount,
                                diningAmount: diningAmount,
                                category:widget.category,menu:[cartMaster.MenuCartMaster(id: widget.menu.id,name:widget.menu.name,image:widget.menu.image ,totalAmount:totalAmount, addons: addonsList)],size: Size(sizeName: widget.data[initPosition].itemSize!.name.toString(), id: widget.data[initPosition].itemSize!.id!)), widget.menu.vendorId,context);
                            _cartController.quantity.value=_cartController.getQuantity(cartMaster.Cart(
                                diningAmount: diningAmount,
                                quantity: 1,
                                totalAmount: totalAmount,
                                category:widget.category,menu:[cartMaster.MenuCartMaster(id: widget.menu.id,name:widget.menu.name,image:widget.menu.image ,totalAmount:totalAmount, addons: addonsList)],size: Size(sizeName: widget.data[initPosition].itemSize!.name.toString(), id: widget.data[initPosition].itemSize!.id!)), widget.menu.vendorId);
                            setState(() {

                            });
                          }
                        },
                        btnPlusOnPressed: ()async{
                          Set set={};
                          double totalAmount=double.parse(widget.data[initPosition].price.toString());
                          double diningAmount=double.parse(widget.data[initPosition].sizeDiningPrice??'0.0');
                          List<cartMaster.AddonCartMaster> addonsList=[];
                          for(int i=0;i<widget.data[initPosition].groupMenuAddon!.length;i++){
                            if(set.contains(widget.data[initPosition].groupMenuAddon![i].addonCategoryId)){

                            }else{
                              set.add(widget.data[initPosition].groupMenuAddon![i].addonCategoryId);
                              for(int menuAddonIndex=0;menuAddonIndex<widget.data[initPosition].menuAddon!.length;menuAddonIndex++){
                                if(widget.data[initPosition].groupMenuAddon![i].addonCategoryId==widget.data[initPosition].menuAddon![menuAddonIndex].addonCategoryId){
                                  if(widget.data[initPosition].menuAddon![menuAddonIndex].addon!.isChecked==1){
                                    addonsList.add(cartMaster.AddonCartMaster(
                                      id: widget.data[initPosition].menuAddon![menuAddonIndex].id,
                                      name:widget.data[initPosition].menuAddon![menuAddonIndex].addon!.name ,
                                      price: double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].price!),
                                      diningPrice: double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice??'0.0'),
                                    ));
                                    totalAmount+=double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].price.toString());
                                    diningAmount+=double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice??'0.');
                                  }
                                }
                              }

                            }

                          }
                           _cartController.addItem(cartMaster.Cart(
                              quantity: 1,
                              totalAmount: totalAmount,
                              diningAmount: diningAmount,
                              category:widget.category,menu:[cartMaster.MenuCartMaster(id: widget.menu.id,name:widget.menu.name,image:widget.menu.image ,totalAmount:totalAmount, addons: addonsList)],size: Size(sizeName: widget.data[initPosition].itemSize!.name.toString(), id: widget.data[initPosition].itemSize!.id!)), widget.menu.vendorId,context);
                          _cartController.quantity.value=_cartController.getQuantity(cartMaster.Cart(
                              quantity: 1,
                              totalAmount: totalAmount,
                              diningAmount: diningAmount,
                              category:widget.category,menu:[cartMaster.MenuCartMaster(id: widget.menu.id,name:widget.menu.name,image:widget.menu.image ,totalAmount:totalAmount, addons: addonsList)],size: Size(sizeName: widget.data[initPosition].itemSize!.name.toString(), id: widget.data[initPosition].itemSize!.id!)), widget.menu.vendorId);
                          setState(() {

                          });
                        }, btnMinusOnPressed: (){
                      Set set=Set();
                      double totalAmount=double.parse(widget.data[initPosition].price.toString());
                      double diningAmount=double.parse(widget.data[initPosition].sizeDiningPrice??'0.0');
                      List<cartMaster.AddonCartMaster> addonsList=[];
                      for(int i=0;i<widget.data[initPosition].groupMenuAddon!.length;i++){
                        if(set.contains(widget.data[initPosition].groupMenuAddon![i].addonCategoryId)){

                        }else{
                          set.add(widget.data[initPosition].groupMenuAddon![i].addonCategoryId);
                          for(int menuAddonIndex=0;menuAddonIndex<widget.data[initPosition].menuAddon!.length;menuAddonIndex++){
                            if(widget.data[initPosition].groupMenuAddon![i].addonCategoryId==widget.data[initPosition].menuAddon![menuAddonIndex].addonCategoryId){
                              if(widget.data[initPosition].menuAddon![menuAddonIndex].addon!.isChecked==1){
                                addonsList.add(cartMaster.AddonCartMaster(
                                  id: widget.data[initPosition].menuAddon![menuAddonIndex].id,
                                  name:widget.data[initPosition].menuAddon![menuAddonIndex].addon!.name ,
                                  price: double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].price!),
                                  diningPrice: double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice??'0.0'),
                                ));
                                totalAmount+=double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].price.toString());
                                diningAmount+=double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice??'0.0');
                              }
                            }
                          }

                        }

                      }
                      _cartController.removeItem(cartMaster.Cart(
                          quantity: 1,
                          totalAmount: totalAmount,
                          diningAmount: diningAmount,
                          category:widget.category,menu:[cartMaster.MenuCartMaster(id: widget.menu.id,name:widget.menu.name,image:widget.menu.image ,
                          totalAmount:totalAmount, addons: addonsList)],size: Size(sizeName: widget.data[initPosition].itemSize!.name.toString(),
                          id: widget.data[initPosition].itemSize!.id!)), widget.menu.vendorId);
                      _cartController.quantity.value=_cartController.getQuantity(cartMaster.Cart(
                          quantity: 1,
                          totalAmount: totalAmount,
                          diningAmount: diningAmount,
                          category:widget.category,menu:[cartMaster.MenuCartMaster(id: widget.menu.id,name:widget.menu.name,image:widget.menu.image ,
                          totalAmount:totalAmount, addons: addonsList)],size: Size(sizeName: widget.data[initPosition].itemSize!.name.toString(),
                          id: widget.data[initPosition].itemSize!.id!)), widget.menu.vendorId);
                      // setState(() {
                      //
                      // });

                    })

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
          SizedBox(
            height: ScreenConfig.blockHeight,
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
                  key: key,),
                IconButton(onPressed: (){
                  final dynamic tooltip = key.currentState;
                  tooltip.ensureTooltipVisible();

                }, icon:  Icon(Icons.help,color: Color(Constants.colorTheme),),),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: ScreenConfig.blockHeight * 8,
              child: TabBar(
                controller: _tabController,
                unselectedLabelColor: Colors.redAccent,
                indicatorSize: TabBarIndicatorSize.label,
               // padding: EdgeInsets.only(bottom: 0.0),
                labelPadding: EdgeInsets.only(left: 8.0,right: 8.0),
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.redAccent),
                isScrollable: true,
                tabs: List.generate(
                    widget.data
                        .length, (index) {
                  return  getPrice(widget.data[index]);
                }

                ),
                onTap: (index) {
                  initPosition = index;
                  Set set={};
                  double totalAmount=double.parse(widget.data[initPosition].price.toString());
                  double diningAmount=double.parse(widget.data[initPosition].sizeDiningPrice??'0.0');
                  List<cartMaster.AddonCartMaster> addonsList=[];
                  for(int i=0;i<widget.data[initPosition].groupMenuAddon!.length;i++){
                    if(set.contains(widget.data[initPosition].groupMenuAddon![i].addonCategoryId)){

                    }else{
                      set.add(widget.data[initPosition].groupMenuAddon![i].addonCategoryId);
                      for(int menuAddonIndex=0;menuAddonIndex<widget.data[initPosition].menuAddon!.length;menuAddonIndex++){
                        if(widget.data[initPosition].groupMenuAddon![i].addonCategoryId==widget.data[initPosition].menuAddon![menuAddonIndex].addonCategoryId){
                          if(widget.data[initPosition].menuAddon![menuAddonIndex].addon!.isChecked==1){
                            addonsList.add(cartMaster.AddonCartMaster(
                              id: widget.data[initPosition].menuAddon![menuAddonIndex].id,
                              name:widget.data[initPosition].menuAddon![menuAddonIndex].addon!.name ,
                              price: double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].price!),
                              diningPrice: double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice??'0.0'),

                            ));
                            totalAmount+=double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].price.toString());
                            diningAmount+=double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice??'0.0');
                          }
                        }
                      }

                    }

                  }
                  _cartController.quantity.value=_cartController.getQuantity(cartMaster.Cart(
                      quantity: 1,
                      totalAmount: totalAmount,
                      diningAmount: diningAmount,
                      category:widget.category,menu:[cartMaster.MenuCartMaster(id: widget.menu.id,name:widget.menu.name,image:widget.menu.image ,totalAmount:totalAmount, addons: addonsList)],size: Size(sizeName: widget.data[initPosition].itemSize!.name.toString(), id: widget.data[initPosition].itemSize!.id!)), widget.menu.vendorId);
                  setState(() {
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
            height: ScreenConfig.blockHeight*100,
            child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.data[initPosition].groupMenuAddon!.length,
            itemBuilder: (context,groupMenuAddonIndex){
              final key =  GlobalKey();
              return (widget.data[initPosition].groupMenuAddon![groupMenuAddonIndex].isDuplicate)?Container():
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('${widget.data[initPosition].groupMenuAddon![groupMenuAddonIndex].addonCategory!.name}(${widget.data[initPosition].groupMenuAddon![groupMenuAddonIndex].addonCategory!.min}-${widget.data[initPosition].groupMenuAddon![groupMenuAddonIndex].addonCategory!.max})',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(Constants.colorTheme),
                            fontSize: 18,
                          ),),
                        ),
                        Tooltip(
                          message: 'Minimum Selection ${widget.data[initPosition].groupMenuAddon![groupMenuAddonIndex].addonCategory!.min}\n'
                              'Maximum Selection ${widget.data[initPosition].groupMenuAddon![groupMenuAddonIndex].addonCategory!.max}',
                          key: key,),
                        IconButton(onPressed: (){
                          final dynamic tooltip = key.currentState;
                          tooltip.ensureTooltipVisible();

                        }, icon:  Icon(Icons.help,color: Color(Constants.colorTheme),),),
                      ],
                    ),
                    // Text('Minimum Selection ${widget.data[initPosition].groupMenuAddon![groupMenuAddonIndex].addonCategory!.min}'),
                    // Text('Maximum Selection ${widget.data[initPosition].groupMenuAddon![groupMenuAddonIndex].addonCategory!.max}'),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.data[initPosition].menuAddon!.length,
                        itemBuilder: (context,menuAddonIndex){
                          return (widget.data[initPosition].groupMenuAddon![groupMenuAddonIndex].addonCategoryId==widget.data[initPosition].menuAddon![menuAddonIndex].addonCategoryId)?
                          CustomListTile(
                              diningPrice: widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice.toString(),
                              title: widget.data[initPosition].menuAddon![menuAddonIndex].addon!.name,
                              price: widget.data[initPosition].menuAddon![menuAddonIndex].price.toString(),
                              checkboxValue: widget.data[initPosition].menuAddon![menuAddonIndex].addon!.isChecked==0?false:true,
                              onChange: (bool? value){
                                setState(() {

                                  if(value==true){
                                    int checkedCount=0;
                                    for(int i=0;i<widget.data[initPosition].menuAddon!.length;i++){
                                      if(widget.data[initPosition].groupMenuAddon![groupMenuAddonIndex].addonCategoryId!=widget.data[initPosition].menuAddon![i].addonCategoryId){
                                        continue;
                                      }
                                      if(widget.data[initPosition].menuAddon![i].addon!.isChecked==1)
                                        checkedCount++;
                                    }
                                    if(checkedCount<widget.data[initPosition].groupMenuAddon![groupMenuAddonIndex].addonCategory!.max)
                                      widget.data[initPosition].menuAddon![menuAddonIndex].addon!.isChecked=1;
                                    else
                                      widget.data[initPosition].menuAddon![menuAddonIndex].addon!.isChecked=0;

                                  }else{
                                    widget.data[initPosition].menuAddon![menuAddonIndex].addon!.isChecked=0;
                                  }
                                });
                                Set set={};
                                double totalAmount=double.parse(widget.data[initPosition].price.toString());
                                double diningAmount=double.parse(widget.data[initPosition].sizeDiningPrice??'0.0');
                                List<cartMaster.AddonCartMaster> addonsList=[];
                                for(int i=0;i<widget.data[initPosition].groupMenuAddon!.length;i++){
                                  if(set.contains(widget.data[initPosition].groupMenuAddon![i].addonCategoryId)){

                                  }else{
                                    set.add(widget.data[initPosition].groupMenuAddon![i].addonCategoryId);
                                    for(int menuAddonIndex=0;menuAddonIndex<widget.data[initPosition].menuAddon!.length;menuAddonIndex++){
                                      if(widget.data[initPosition].groupMenuAddon![i].addonCategoryId==widget.data[initPosition].menuAddon![menuAddonIndex].addonCategoryId){
                                        if(widget.data[initPosition].menuAddon![menuAddonIndex].addon!.isChecked==1){
                                          addonsList.add(cartMaster.AddonCartMaster(
                                            id: widget.data[initPosition].menuAddon![menuAddonIndex].id,
                                            name:widget.data[initPosition].menuAddon![menuAddonIndex].addon!.name ,
                                            price: double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].price!),
                                            diningPrice: double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice??'0.0'),
                                          ));
                                          totalAmount+=double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].price.toString());
                                          diningAmount+=double.parse(widget.data[initPosition].menuAddon![menuAddonIndex].addonDiningPrice??'0.0');
                                        }
                                      }
                                    }

                                  }

                                }
                                _cartController.quantity.value=_cartController.getQuantity(cartMaster.Cart(
                                    quantity: 1,
                                    totalAmount: totalAmount,
                                    diningAmount: diningAmount,
                                    category:widget.category,menu:[cartMaster.MenuCartMaster(id: widget.menu.id,name:widget.menu.name,image:widget.menu.image ,totalAmount:totalAmount, addons: addonsList)],size: Size(sizeName: widget.data[initPosition].itemSize!.name.toString(), id: widget.data[initPosition].itemSize!.id!)), widget.menu.vendorId);


                              }):Container();


                        }),
                ],
              );
            }),
            ),
          ),
        ],
      ),
    );
  }
  getPrice(MenuSize menuSize){
    if(menuSize.displayDiscountPrice==null){
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
              Text(menuSize.itemSize!.name!),
              Text(menuSize.price!),
            ],
          ),
        ),
      );


    } else{
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.redAccent, width: 1)),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.0,horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(menuSize.itemSize!.name.toString()),
                Row(
                  children: [
                    Text(menuSize.displayPrice!,style: TextStyle(decoration:  TextDecoration.lineThrough,
                        fontWeight: FontWeight.w700),),
                    Text(' '),
                    Text(menuSize.displayDiscountPrice!),
                  ],
                ),
                Text(menuSize.sizeDiningPrice.toString(),style: TextStyle(
                    fontWeight: FontWeight.w700),),
              ],
            ),
          ),
        ),
      );

    }
  }
}
//ignore: must_be_immutable
class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  Widget? stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    this.stub,
    required this.onPositionChange,
    required this.onScroll,
    required this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView> with TickerProviderStateMixin {
  TabController? controller;
  int? _currentCount;
  int? _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition!,
    );
    controller!.addListener(onPositionChange);
    controller!.animation!.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller!.animation!.removeListener(onScroll);
      controller!.removeListener(onPositionChange);
      controller!.dispose();

      _currentPosition = widget.initPosition;

      if (_currentPosition! > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition! < 0 ? 0 :
        _currentPosition;
        WidgetsBinding.instance.addPostFrameCallback((_){
          if(mounted) {
            widget.onPositionChange(_currentPosition!);
          }
        });
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition!,
        );
        controller!.addListener(onPositionChange);
        controller!.animation!.addListener(onScroll);
      });
    } else  {
      controller!.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller!.animation!.removeListener(onScroll);
    controller!.removeListener(onPositionChange);
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: TabBar(
            isScrollable: true,
            controller: controller,
            // labelColor: Colors.red,
            // unselectedLabelColor: Theme.of(context).hintColor,
            //   indicatorColor: Colors.transparent,

            // indicator: BoxDecoration(
            //   border: Border(
            //     bottom: BorderSide(
            //       color: Theme.of(context).primaryColor,
            //       width: 2,
            //     ),
            //   ),
            // ),
            unselectedLabelColor: Colors.redAccent,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.redAccent),
            tabs: List.generate(
              widget.itemCount,
                  (index) => widget.tabBuilder(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
                  (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller!.indexIsChanging) {
      _currentPosition = controller!.index;
      widget.onPositionChange(_currentPosition!);
    }
  }

  onScroll() {
    widget.onScroll(controller!.animation!.value);
  }
}