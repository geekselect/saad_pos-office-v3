import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/config/screen_config.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/pages/addons/deals_addons.dart';

class DealsWithSizes extends StatefulWidget {
  const DealsWithSizes({Key? key}) : super(key: key);

  @override
  _DealsWithSizesState createState() => _DealsWithSizesState();
}

class _DealsWithSizesState extends State<DealsWithSizes> {
  OrderCustimizationController _orderCustimizationController=Get.find<OrderCustimizationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView.builder(
        itemCount: _orderCustimizationController.dealsSizes!.data!.menuSize!.length,
          itemBuilder: (context,index){
        //if(_orderCustimizationController.menuSizeList[MenuSizeIndex].menu!.singleMenu![0].singleMenuItemCategory!.isNotEmpty){
        if(_orderCustimizationController.dealsSizes!.data!.menuSize![index].menu!.singleMenu.isNotEmpty &&_orderCustimizationController.dealsSizes!.data!.menuSize![index].menu!.singleMenu[0].singleMenuItemCategory!.isNotEmpty){
          return Card(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 5.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15.0,
                    backgroundImage: CachedNetworkImageProvider(_orderCustimizationController.dealsSizes!.data!.menuSize![index].menu!.image),
                  ),
                  SizedBox(
                    width: ScreenConfig.blockWidth*2,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(_orderCustimizationController.dealsSizes!.data!.menuSize![index].menu!.name
                        ,style: TextStyle(
                            fontSize: 10
                        ),),
                      Text(_orderCustimizationController.dealsSizes!.data!.menuSize![index].menu!.description
                        ,style: TextStyle(
                            fontSize: 10
                        ),),
                    ],
                  ),
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(12.0),
                  //
                  //   child: Text('Customizable',style: TextStyle(
                  //     backgroundColor: Colors.red,
                  //     fontSize: 8,
                  //   ),),
                  // ),
                  Spacer(),
                  (_orderCustimizationController.dealsSizes!.data!.menuSize![index].menuAddon!.isEmpty)?
                  TextButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(BorderSide(
                          width: 2.0,
                          color: Colors.red,
                        )),
                      ),
                      onPressed: ()async{
                      },
                      child: Text("ADD")):
                  TextButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(BorderSide(
                          width: 2.0,
                          color: Colors.red,
                        )),
                      ),
                      onPressed: ()async{
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DealsAddons(menuSize: _orderCustimizationController.dealsSizes!.data!.menuSize![index],),
                          ),);
                      },
                      child: Text("EDIT"))


                ],
              ),
            ),
          );
        }else{
          return Container();
        }
      }),

    );
  }
}
