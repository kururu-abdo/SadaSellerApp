import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/localization/language_constrants.dart';
import 'package:eamar_seller_app/provider/profile_provider.dart';
import 'package:eamar_seller_app/provider/splash_provider.dart';
import 'package:eamar_seller_app/provider/theme_provider.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/images.dart';
import 'package:eamar_seller_app/utill/styles.dart';
import 'package:eamar_seller_app/view/base/custom_bottom_sheet.dart';
import 'package:eamar_seller_app/view/screens/addProduct/add_product_screen.dart';
import 'package:eamar_seller_app/view/screens/bank_info/bank_info_screen.dart';
import 'package:eamar_seller_app/view/screens/chat/inbox_screen.dart';
import 'package:eamar_seller_app/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:eamar_seller_app/view/screens/more/html_view_screen.dart';
import 'package:eamar_seller_app/view/screens/profile/profile_view_screen.dart';
import 'package:eamar_seller_app/view/screens/restaurant/shop_screen.dart';
import 'package:eamar_seller_app/view/screens/settings/setting_screen.dart';
import 'package:eamar_seller_app/view/screens/wallet/wallet_screen.dart';

class MenuBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    String version = Provider.of<SplashProvider>(context,listen: false).configModel.version != null?
    Provider.of<SplashProvider>(context,listen: false).configModel.version:'version';
    return  Container(
      height: MediaQuery.of(context).size.width-50,
      decoration: BoxDecoration(
        color: ColorResources.getHomeBg(context),
        borderRadius: BorderRadius.only(
            topLeft:  Radius.circular(25),
            topRight: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Icon(Icons.keyboard_arrow_down_outlined,color: Theme.of(context).hintColor,
            size: Dimensions.ICON_SIZE_LARGE,),

          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
          Container(
            height: MediaQuery.of(context).size.width-99,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreenView()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: ColorResources.getBottomSheetColor(context),
                          borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],

                      ),
                      child: Consumer<ProfileProvider>(
                        builder: (context, profileProvider, child) =>
                            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Container(
                                height: MediaQuery.of(context).size.width/12, width: MediaQuery.of(context).size.width/12,
                                decoration: BoxDecoration(shape: BoxShape.circle,
                                    border: Border.all(color: ColorResources.WHITE, width: 2)),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    errorWidget: (ctx, url, err) => Image.asset(Images.placeholder_image),
                                      placeholder: (ctx, url) => Image.asset(Images.placeholder_image),
                                      imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.sellerImageUrl}/'
                                          '${profileProvider.userInfoModel.image}',
                                    height: MediaQuery.of(context).size.width/12, width: MediaQuery.of(context).size.width/12,
                                    fit: BoxFit.cover,)
                                ),
                              ),
                              Flexible(
                                child: Center(
                                  child: Text(getTranslated('profile', context),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  CustomBottomSheet(image: Images.message, title: getTranslated('message', context), widget: InboxScreen()),
                  CustomBottomSheet(image: Images.wallet, title: getTranslated('wallet', context), widget: WalletScreen()),
                  CustomBottomSheet(image: Images.bank_info, title: getTranslated('bank_info', context), widget: BankInfoScreen()),
                  CustomBottomSheet(image: Images.my_shop, title: getTranslated('my_shop', context), widget: ShopScreen()),
                  CustomBottomSheet(image: Images.settings, title: getTranslated('more', context), widget: SettingsScreen()),
                  CustomBottomSheet(image: Images.terms_and_condition, title: getTranslated('terms_and_condition', context), widget: HtmlViewScreen(
                    title: getTranslated('terms_and_condition', context),
                    url: Provider.of<SplashProvider>(context, listen: false).configModel.termsConditions,
                  )),
                  CustomBottomSheet(image: Images.about_us, title: getTranslated('about_us', context), widget: HtmlViewScreen(
                    title: getTranslated('about_us', context),
                    url: Provider.of<SplashProvider>(context, listen: false).configModel.aboutUs,
                  )),
                  CustomBottomSheet(image: Images.privacy_policy, title: getTranslated('privacy_policy', context), widget: HtmlViewScreen(
                    title: getTranslated('privacy_policy', context),
                    url: Provider.of<SplashProvider>(context, listen: false).configModel.privacyPolicy,
                  )),

                  CustomBottomSheet(image: Images.add_product, title: getTranslated('add_product', context), widget: AddProductScreen()),

                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      showCupertinoModalPopup(context: context, builder: (_) => SignOutConfirmationDialog());
                    },

                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: ColorResources.getBottomSheetColor(context),
                          borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Images.logOut, height: MediaQuery.of(context).size.width/12,
                                width: MediaQuery.of(context).size.width/12),
                            Center(
                              child: Text(getTranslated('logout', context),
                                textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                              ),
                            ),
                          ]),
                    ),
                  ),


                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorResources.getBottomSheetColor(context),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 20,height: 20,child: Image.asset(Images.app_info),),
                          Text(getTranslated('app_info', context),
                              style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                          Center(
                            child: Text('${getTranslated('version', context)} '+version??'0.0', textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                            ),
                          ),
                        ]),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
