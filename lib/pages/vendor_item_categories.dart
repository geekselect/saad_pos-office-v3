import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:pos/controller/order_custimization_controller.dart';
import 'package:pos/model/vendor_item_model.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/utils/constants.dart';

class VendorItemCategories extends StatefulWidget {
  final int vendorId;
  const VendorItemCategories({Key? key,required this.vendorId}) : super(key: key);

  @override
  _VendorItemCategoriesState createState() => _VendorItemCategoriesState();
}

class _VendorItemCategoriesState extends State<VendorItemCategories> {
  OrderCustimizationController _orderCustimizationController=Get.find<OrderCustimizationController>();
  Future<BaseModel<VendorItemModel>>? getItemCategoryVendorRef;
  @override
  void initState() {
    getItemCategoryVendorRef=_orderCustimizationController.getItemCategoryVendor(widget.vendorId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<BaseModel<VendorItemModel>>(
        future: getItemCategoryVendorRef,
        builder: (context,snapshot){
          if(snapshot.hasData){
            VendorItemModel vendorItem=snapshot.data!.data!;
            return ListView.builder(
               itemCount: vendorItem.data.length,
                itemBuilder: (context,vendorItemIndex){
                 Datum datum=vendorItem.data[vendorItemIndex];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(datum.image),
                ),
                title: Text(datum.name),
              );
            });
          }
          return Center(child: SpinKitFadingCircle(color: Color(Constants.colorTheme),),);
        },
      ),
    );
  }
}
