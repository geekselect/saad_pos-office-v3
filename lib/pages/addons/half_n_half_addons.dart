import 'package:flutter/material.dart';
import 'package:pos/config/screen_config.dart';
import 'package:pos/model/SingleVendorRetrieveSize.dart';
import 'package:pos/model/cart_master.dart' as cartMaster;
import 'package:pos/utils/constants.dart';
import 'package:pos/utils/custom_list_tile.dart';

class HalfNHalfAddons extends StatefulWidget {
  final MenuSize menuSize;
  const HalfNHalfAddons({Key? key,required this.menuSize}) : super(key: key);

  @override
  _HalfNHalfAddonsState createState() => _HalfNHalfAddonsState();
}

class _HalfNHalfAddonsState extends State<HalfNHalfAddons> {
  Set set=Set();
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    set.clear();
    return Scaffold(
      body:SizedBox(
        height: ScreenConfig.blockHeight*80,
        width: ScreenConfig.screenWidth,
        child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: widget.menuSize.groupMenuAddon!.length,
            itemBuilder: (context,groupMenuAddonIndex){
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
                          child: Text('${widget.menuSize.groupMenuAddon![groupMenuAddonIndex].addonCategory!.name}(${
                              widget.menuSize.groupMenuAddon![groupMenuAddonIndex].addonCategory!.min}-${widget.menuSize.groupMenuAddon![groupMenuAddonIndex].addonCategory!.max})',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(Constants.colorTheme),
                              fontSize: 18,
                            ),),
                        ),
                        Tooltip(
                          message: 'Minimum Selection ${widget.menuSize.groupMenuAddon![groupMenuAddonIndex].addonCategory!.min}\n'
                              'Maximum Selection ${widget.menuSize.groupMenuAddon![groupMenuAddonIndex].addonCategory!.max}',
                          key: key,),
                        IconButton(onPressed: (){
                          final dynamic tooltip = key.currentState;
                          tooltip.ensureTooltipVisible();

                        }, icon:  Icon(Icons.help,color: Color(Constants.colorTheme),),),
                      ],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.menuSize.menuAddon!.length,
                        itemBuilder: (context,menuAddonIndex){
                          return (widget.menuSize.groupMenuAddon![groupMenuAddonIndex].addonCategoryId==widget.menuSize.menuAddon![menuAddonIndex].addonCategoryId)?
                          CustomListTile(
                              diningPrice:(double.parse(widget.menuSize.menuAddon![menuAddonIndex].addonDiningPrice??'0.0')/2).toStringAsFixed(2) ,
                              title: widget.menuSize.menuAddon![menuAddonIndex].addon!.name,
                              price: (double.parse(widget.menuSize.menuAddon![menuAddonIndex].price)/2).toStringAsFixed(2),
                              checkboxValue: widget.menuSize.menuAddon![menuAddonIndex].addon!.isChecked==0?false:true,
                              onChange: (bool? value){
                            setState(() {

                              if(value==true){
                                int checkedCount=0;
                                for(int i=0;i<widget.menuSize.menuAddon!.length;i++){
                                  if(widget.menuSize.groupMenuAddon![groupMenuAddonIndex].addonCategoryId!=widget.menuSize.menuAddon![i].addonCategoryId){
                                    continue;
                                  }
                                  if(widget.menuSize.menuAddon![i].addon!.isChecked==1)
                                    checkedCount++;
                                }
                                if(checkedCount<widget.menuSize.groupMenuAddon![groupMenuAddonIndex].addonCategory!.max)
                                  widget.menuSize.menuAddon![menuAddonIndex].addon!.isChecked=1;
                                else
                                  widget.menuSize.menuAddon![menuAddonIndex].addon!.isChecked=0;

                              }else{
                                widget.menuSize.menuAddon![menuAddonIndex].addon!.isChecked=0;
                              }
                            });


                          }):Container();

                        })
                  ],
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
                if(widget.menuSize.groupMenuAddon![groupMenuAddonIndex].addonCategoryId==widget.menuSize.menuAddon![menuAddonIndex].addonCategoryId){
                  if(widget.menuSize.menuAddon![menuAddonIndex].addon!.isChecked==1){
                    addonsList.add(cartMaster.AddonCartMaster(
                        id: widget.menuSize.menuAddon![menuAddonIndex].id,
                        name: widget.menuSize.menuAddon![menuAddonIndex].addon!.name,
                        price: double.parse(widget.menuSize.menuAddon![menuAddonIndex].price)/2,
                        diningPrice: double.parse(widget.menuSize.menuAddon![menuAddonIndex].addonDiningPrice??'0.0')/2,
                    )
                    );
                  }
                }
              }
            }
          }
          // print(addonsList[0].toMap());
          Navigator.pop(context,addonsList);
        },

        child: Icon(Icons.add),
      ),
    );
  }
}
