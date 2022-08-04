import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/shipping_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/base/no_shipping_method.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';
class CategoryWiseShippingScreen extends StatefulWidget {
  const CategoryWiseShippingScreen({Key key}) : super(key: key);

  @override
  State<CategoryWiseShippingScreen> createState() => _CategoryWiseShippingScreenState();
}

class _CategoryWiseShippingScreenState extends State<CategoryWiseShippingScreen> {

  @override
  void initState() {
   Provider.of<ShippingProvider>(context, listen: false).setShippingCost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ShippingProvider>(context,listen: false).getCategoryWiseShippingMethod(context);
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('shipping', context),),
      body: SafeArea(
        child: Consumer<ShippingProvider>(
          builder: (context, shipProv, child) {

            return  Stack(
              children: [
                Column(
                  children: [

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 6,
                              child: Text(getTranslated('category', context),
                                style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                              ),
                            ), Expanded(
                              flex: 3,
                              child: Text(getTranslated('shipping_cost', context),
                                style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                              ),
                            ), Expanded(
                              flex: 2,
                              child: Text(getTranslated('shipping_cost_multiply', context),
                                style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                              ),
                            ),
                          ]),
                    ),
                    shipProv.categoryWiseShipping !=null ? shipProv.categoryWiseShipping.length > 0 ?
                    Expanded(
                        child: ListView.builder(
                          itemCount: shipProv.categoryWiseShipping.length,
                          itemBuilder: (context, index){

                            return   shipProv.categoryWiseShipping[index].category != null?
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                              margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              decoration: BoxDecoration(
                                color: ColorResources.getBottomSheetColor(context),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                              ),
                              child: Row(children: [

                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(child: Text('${shipProv.categoryWiseShipping[index].category!=null?shipProv.categoryWiseShipping[index].category.name:''??''}', maxLines: 3,overflow: TextOverflow.ellipsis)),
                                  ],
                                )),
                                Container(width: 100,child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextField(
                                      controller: shipProv.shippingCostController[index],
                                      focusNode: shipProv.shippingCostNode[index],
                                      textInputAction: TextInputAction.next,
                                      textInputType: TextInputType.number,
                                      isAmount: true,
                                      // isAmount: true,
                                    ),
                                  ],
                                )),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                                Container(width: 50,child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  Switch(value:shipProv.isMultiply[index],
                                    onChanged: (value){
                                      shipProv.toggleMultiply(context,value,index);
                                      print('===IsMultiply=>${shipProv.isMultiply}');
                                    },
                                    activeColor: Theme.of(context).primaryColor,
                                    inactiveTrackColor: Colors.grey,
                                    inactiveThumbColor: Colors.grey,
                                  )
                                ])),

                              ]),
                            ):SizedBox();
                          }

                        ))
                        : NoShippingDataScreen()
                        : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                  ],
                ),
                Positioned(bottom: 10,left: 20,right: 20,
                    child:shipProv.isLoading? Container(width:30, height: 40,child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor))) : CustomButton(btnTxt: 'update',onTap: (){
                      List<int> _ids= [];
                      List<double> _cost= [];
                      List<int> _isMulti= [];
                      shipProv.shippingCostController.forEach((cost) {
                        _cost.add(double.parse(cost.text.trim().toString()));
                      });
                      _ids = shipProv.ids;
                      _isMulti = shipProv.isMultiplyInt;
                      shipProv.setCategoryWiseShippingCost(context, _ids, _cost, _isMulti).then((value) {
                        if(value.response.statusCode==200){
                          shipProv.getCategoryWiseShippingMethod(context);
                        }
                      });

                    },))
              ],
            );
          }

        ),
      ),
    );
  }
}
