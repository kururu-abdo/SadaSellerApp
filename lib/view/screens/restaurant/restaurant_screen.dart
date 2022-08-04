import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/restaurant_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/restaurant_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/no_data_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/restaurant/restaurant_settings.dart';

class RestaurantScreen extends StatelessWidget {
  final RestaurantModel restaurantModel;
  RestaurantScreen({this.restaurantModel});

  @override
  Widget build(BuildContext context) {

    Provider.of<RestaurantProvider>(context, listen: false).getRestaurant(context);
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('my_shop', context)),
      body: SafeArea(
          child: Consumer<RestaurantProvider>(
              builder: (context, resProvider, child) {
                return resProvider.restaurant !=null ? resProvider.restaurant.length > 0 ?
                 ListView.builder(
                  itemCount: resProvider.restaurant.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantSettingsScreen())),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                      margin: EdgeInsets.all( Dimensions.PADDING_SIZE_EXTRA_LARGE),
                      decoration: BoxDecoration(
                        color: ColorResources.getBottomSheetColor(context),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                      ),
                      child: Column(
                        children: [
                          Row(children: [
                            Container(
                              height: 70,
                              width: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  resProvider.restaurant[index].image,
                                  height: 70,
                                  width: 85,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column( crossAxisAlignment: CrossAxisAlignment.start,children: [
                              Text('Name : ${resProvider.restaurant[index].resName}', style: titilliumBold.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_LARGE)),
                              Text('Phone :  ${'0123456789'}', style: titilliumBold.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_SMALL)),
                              Row(
                                children: [
                                  Text('Address : ', style: titilliumBold.copyWith(color: ColorResources.getTextColor(context), fontSize: 11)),
                                  Text( '3460, Pallet Street, New York', style: titilliumBold.copyWith(color: ColorResources.getTextColor(context), fontSize: 11)),
                                ],
                              ),
                            ],)
                          ],),
                        ],
                      ),
                    ),
                  ),
               )
                    : NoDataScreen()
                    : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));

              })
      )
    );
  }
}
