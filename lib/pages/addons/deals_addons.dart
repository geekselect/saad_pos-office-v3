import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/model/deals_sizes.dart';
import 'package:pos/model/cart_master.dart' as cartMaster;
import 'package:pos/utils/constants.dart';
import 'package:pos/utils/custom_list_tile.dart';
class DealsAddons extends StatefulWidget {
  final MenuSize menuSize;
  const DealsAddons({Key? key,required this.menuSize}) : super(key: key);

  @override
  _DealsAddonsState createState() => _DealsAddonsState();
}

class _DealsAddonsState extends State<DealsAddons> {
  Set set=Set();
  @override
  Widget build(BuildContext context) {
    set.clear();
    return Scaffold(
      body: SingleChildScrollView(
        child: ListView.builder(
         // padding: EdgeInsets.all(0.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.menuSize.groupMenuAddon!.length,
            itemBuilder: (context, groupMenuAddonIndex) {
              if(set.contains(widget.menuSize.groupMenuAddon![groupMenuAddonIndex].addonCategoryId)){
                return Container();
              }else{
                set.add(widget.menuSize.groupMenuAddon![groupMenuAddonIndex].addonCategoryId);
                final key =  GlobalKey();
                return Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('${widget.menuSize.groupMenuAddon![groupMenuAddonIndex]
                                .addonCategory!.name}(${widget.menuSize
                                .groupMenuAddon![groupMenuAddonIndex].addonCategory!
                                .min}-${widget.menuSize
                                .groupMenuAddon![groupMenuAddonIndex].addonCategory!
                                .max})',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(Constants.colorTheme),
                                fontSize: 18,
                              ),),
                          ),
                          Tooltip(
                            message: 'Minimum Selection ${widget.menuSize
                                .groupMenuAddon![groupMenuAddonIndex].addonCategory!
                                .min}\n'
                                'Maximum Selection ${widget.menuSize
                                .groupMenuAddon![groupMenuAddonIndex].addonCategory!
                                .max}',
                            key: key,),
                          IconButton(onPressed: (){
                            final dynamic tooltip = key.currentState;
                            tooltip.ensureTooltipVisible();

                          }, icon:Icon(Icons.help,color: Color(Constants.colorTheme),),
                          ),
                        ],
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          // padding: EdgeInsets.all(0.0),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.menuSize.menuAddon!.length,
                          itemBuilder: (context, menuAddonIndex) {
                            if ((widget.menuSize
                                .groupMenuAddon![groupMenuAddonIndex]
                                .addonCategoryId ==
                                widget.menuSize.menuAddon![menuAddonIndex]
                                    .addonCategoryId)) {
                              return Padding(
                                padding: EdgeInsets.only(right: Get.width*0.05),
                                child: CustomListTile(
                                    diningPrice: widget.menuSize.menuAddon![menuAddonIndex].addonDiningPrice.toString(),
                                    title:   widget.menuSize.menuAddon![menuAddonIndex].addon!.name,
                                    price:   widget.menuSize.menuAddon![menuAddonIndex].price,
                                    checkboxValue:widget.menuSize.menuAddon![menuAddonIndex]
                                    .addon!.isChecked == 0 ? false : true, onChange: (bool? value) {
                                  setState(() {
                                    int checkedCount = 0;
                                    for (int i = 0; i <
                                        widget.menuSize.menuAddon!.length; i++) {
                                      if(widget.menuSize
                                          .groupMenuAddon![groupMenuAddonIndex]
                                          .addonCategoryId !=
                                          widget.menuSize.menuAddon![i]
                                              .addonCategoryId){
                                        continue;
                                      }
                                      if (widget.menuSize.menuAddon![i].addon!
                                          .isChecked == 1) {
                                        checkedCount++;
                                      }
                                    }
                                    if (value == true) {
                                      if (checkedCount < widget.menuSize
                                          .groupMenuAddon![groupMenuAddonIndex]
                                          .addonCategory!.max){
                                        widget.menuSize.menuAddon![menuAddonIndex]
                                            .addon!.isChecked = 1;
                                      }else if(checkedCount == widget.menuSize
                                          .groupMenuAddon![groupMenuAddonIndex]
                                          .addonCategory!.max){
                                      for(var menuAddon in widget.menuSize.menuAddon!){
                                        menuAddon.addon!.isChecked=0;
                                      }
                                      widget.menuSize.menuAddon![menuAddonIndex]
                                          .addon!.isChecked = 1;
                                      } else{
                                        widget.menuSize.menuAddon![menuAddonIndex]
                                            .addon!.isChecked = 0;
                                      }

                                    } else {
                                      if (checkedCount == widget.menuSize
                                          .groupMenuAddon![groupMenuAddonIndex]
                                          .addonCategory!.min){

                                      }else{
                                        widget.menuSize.menuAddon![menuAddonIndex]
                                            .addon!.isChecked = 0;
                                      }

                                    }
                                  });
                                }),
                              );
                            } else {
                              return Container();
                            }
                          }
                      ),
                    ]
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(Constants.colorTheme),
        onPressed: () {

          Set set={};
          List<cartMaster.AddonCartMaster> addonsList=[];
          for(int groupMenuAddonIndex=0;groupMenuAddonIndex<widget.menuSize.groupMenuAddon!.length;groupMenuAddonIndex++){
            if(set.contains(widget.menuSize.groupMenuAddon![groupMenuAddonIndex].addonCategoryId)){

            }else{
              set.add(widget.menuSize.groupMenuAddon![groupMenuAddonIndex].addonCategoryId);
              for(int menuAddonIndex=0;menuAddonIndex<widget.menuSize.menuAddon!.length;menuAddonIndex++){
                if(widget.menuSize
                    .groupMenuAddon![groupMenuAddonIndex]
                    .addonCategoryId ==
                    widget.menuSize.menuAddon![menuAddonIndex]
                        .addonCategoryId){
                  if(widget.menuSize.menuAddon![menuAddonIndex]
                      .addon!.isChecked==1){
                    addonsList.add(cartMaster.AddonCartMaster(
                        id: widget.menuSize.menuAddon![menuAddonIndex].id,
                        name: widget.menuSize.menuAddon![menuAddonIndex].addon!.name,
                        price: double.parse(widget.menuSize.menuAddon![menuAddonIndex].price)
                    )
                    );
                  }



                }
              }
            }
          }
          Navigator.pop(context,addonsList);
        },

        child: Icon(Icons.add),
      ),
    );
  }
}
