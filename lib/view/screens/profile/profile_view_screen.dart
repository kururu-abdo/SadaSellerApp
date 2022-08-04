import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/shipping_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:sixvalley_vendor_app/view/screens/profile/profile_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/settings/business_setting.dart';
import 'package:sixvalley_vendor_app/view/screens/shipping/category_wise_shipping.dart';



class ProfileScreenView extends StatefulWidget {
  @override
  _ProfileScreenViewState createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {



  @override
  void initState() {
    super.initState();
    if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel == null) {
      Provider.of<ProfileProvider>(context, listen: false).getSellerInfo(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          final created = profile.userInfoModel.createdAt;
          DateTime parseDate =
          new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(created);
          final today = DateTime.now();
          final joined = today.difference(parseDate).inDays;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(height: 400,
                width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color:ColorResources.getPrimary(context),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE,),
                bottomLeft: Radius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE))
              ),),



              Container(height: MediaQuery.of(context).size.width/1.3,
                width: MediaQuery.of(context).size.width/1.3,
                decoration: BoxDecoration(color: Theme.of(context).cardColor.withOpacity(.10),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(MediaQuery.of(context).size.width))),),



              Container(padding: EdgeInsets.only(top: 50, left: 15),
                child: Row(children: [
                  CupertinoNavigationBarBackButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.white,
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Text(getTranslated('my_profile', context),
                      style: robotoTitleRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE_TWENTY,
                      color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              ),



              Container(
                padding: EdgeInsets.only(top: 380),
                child: Column(
                  children: [Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200],
                              spreadRadius: 0.5, blurRadius: 0.3)],),
                        height : Dimensions.profile_card_height,
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,),
                          child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Container(width: Dimensions.ICON_SIZE_DEFAULT, height: Dimensions.ICON_SIZE_DEFAULT,
                                child: Image.asset(Images.dark)),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),

                              Text(!Provider.of<ThemeProvider>(context).darkTheme?
                              '${getTranslated('dark_theme', context)}':'${getTranslated('light_theme', context)}',
                                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                              Expanded(child: SizedBox()),

                              FlutterSwitch(width: 60.0, height: 35.0, toggleSize: 30.0,
                                value: !Provider.of<ThemeProvider>(context).darkTheme,
                                borderRadius: 20.0,
                                activeColor: Theme.of(context).primaryColor.withOpacity(.5),
                                padding: 3.0,
                                activeIcon: Image.asset(Images.dark_mode, width: 30,height: 30, fit: BoxFit.scaleDown),
                                inactiveIcon: Image.asset(Images.light_mode, width: 30,height: 30,fit: BoxFit.scaleDown,),
                                onToggle:(bool isActive) =>Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                              ),
                            ],),
                        ),
                      ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),

                        InkWell(onTap: (){
                          if(Provider.of<ShippingProvider>(context, listen: false).selectedShippingType == "category_wise"){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CategoryWiseShippingScreen()));
                          }else if(Provider.of<ShippingProvider>(context, listen: false).selectedShippingType == "order_wise"){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => BusinessScreen()));
                          }else{
                            showCustomSnackBar(getTranslated('selected_product_wise_shipping', context), context,isError: false);
                          }},

                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200],
                                  spreadRadius: 0.5, blurRadius: 0.3)],),
                            height: Dimensions.profile_card_height,
                            child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                              child: Row(children: [Container(width: Dimensions.ICON_SIZE_DEFAULT, height: Dimensions.ICON_SIZE_DEFAULT,
                                  child: Image.asset(Images.box)),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),

                                Expanded(child: Text(getTranslated('shipping_method', context),
                                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),),


                                Container(width: Dimensions.ICON_SIZE_DEFAULT,height: Dimensions.ICON_SIZE_DEFAULT,
                                    child: Icon(Icons.arrow_forward_ios,color: Theme.of(context).primaryColor,))
                              ],),
                            ),
                          ),),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),

                        InkWell(onTap: (){showModalBottomSheet(backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            context: context, builder: (_) => ProfileScreen());},
                          child: Container(width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200],
                                  spreadRadius: 0.5, blurRadius: 0.3)],),
                            height : Dimensions.profile_card_height,
                            child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                              child: Row(children: [
                                Container(width: Dimensions.ICON_SIZE_DEFAULT, height: Dimensions.ICON_SIZE_DEFAULT,
                                    child: Image.asset(Images.edit_profile)),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),

                                Expanded(child: Text(getTranslated('edit_profile', context),
                                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),),

                                Container(width: Dimensions.ICON_SIZE_DEFAULT,height: Dimensions.ICON_SIZE_DEFAULT,
                                    child: Icon(Icons.arrow_forward_ios,color: Theme.of(context).primaryColor,))
                              ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ],
                ),
              ),


              Positioned(top: MediaQuery.of(context).size.width/4, left: 0,right: 0,
                child: Column(children: [Container(
                  margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    border: Border.all(color: Colors.white, width: 3),
                    shape: BoxShape.circle,),
                  child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [CachedNetworkImage(
                        errorWidget: (ctx, url, err) => Image.asset(Images.placeholder_image, fit: BoxFit.cover,),
                        placeholder: (ctx, url) => Image.asset(Images.placeholder_image),
                        width: 100, height: 100,
                        fit: BoxFit.cover,
                        imageUrl: '${Provider.of<SplashProvider>(context, listen: false).
                        baseUrls.sellerImageUrl}/${profile.userInfoModel.image}',
                      ),
                      ],
                    ),
                  ),
                ),

                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                    child: Text('${profile.userInfoModel.fName} ${profile.userInfoModel.lName}',
                        maxLines: 2,textAlign: TextAlign.center,
                        style: titilliumRegular.copyWith(color:  ColorResources.getProfileTextColor(context),
                            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),),
                  ),


                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                          vertical: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [


                      Column(mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Text(profile.userInfoModel.productCount.toString(),
                              style: titilliumBold.copyWith(color:  ColorResources.getProfileTextColor(context),
                                  fontSize: Dimensions.FONT_SIZE_MAX_LARGE)),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                          Text(getTranslated('total_products', context),
                            textAlign: TextAlign.center,
                            style: titilliumRegular.copyWith(color: ColorResources.getProfileTextColor(context),
                                fontSize: Dimensions.FONT_SIZE_LARGE),),],),


                        Column(mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(profile.userInfoModel.ordersCount.toString(),
                              style: titilliumBold.copyWith(color:  ColorResources.getProfileTextColor(context),
                                  fontSize: Dimensions.FONT_SIZE_MAX_LARGE),),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),



                            Text(getTranslated('total_order', context),
                              style: titilliumRegular.copyWith(color:  ColorResources.getProfileTextColor(context),
                                  fontSize: Dimensions.FONT_SIZE_LARGE),),
                          ],),

                        Column(mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(joined.toString(),
                              style: titilliumBold.copyWith(color:  ColorResources.getProfileTextColor(context),
                                  fontSize: Dimensions.FONT_SIZE_MAX_LARGE),),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                            Text(getTranslated('days_since_joined', context),
                              textAlign: TextAlign.center,
                              style: titilliumRegular.copyWith(color:  ColorResources.getProfileTextColor(context),
                                  fontSize: Dimensions.FONT_SIZE_LARGE),),
                          ],),
                      ],),
                    ),
                  ],
                ),),
            ],
          );
        },
      ),
    );
  }
}
