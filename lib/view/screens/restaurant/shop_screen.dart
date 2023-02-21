import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/localization/language_constrants.dart';
import 'package:eamar_seller_app/provider/localization_provider.dart';
import 'package:eamar_seller_app/provider/product_provider.dart';
import 'package:eamar_seller_app/provider/product_review_provider.dart';
import 'package:eamar_seller_app/provider/profile_provider.dart';
import 'package:eamar_seller_app/provider/shop_info_provider.dart';
import 'package:eamar_seller_app/provider/splash_provider.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/images.dart';
import 'package:eamar_seller_app/utill/styles.dart';
import 'package:eamar_seller_app/view/base/custom_app_bar.dart';
import 'package:eamar_seller_app/view/base/no_data_screen.dart';
import 'package:eamar_seller_app/view/screens/restaurant/shop_update_screen.dart';
import 'package:eamar_seller_app/view/screens/restaurant/widget/all_product_widget.dart';
import 'package:eamar_seller_app/view/screens/review/product_review_screen.dart';

class ShopScreen extends StatefulWidget {
  final int initialPage;

  ShopScreen({this.initialPage = 0});

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String sellerId = '0';
  Future<void> _loadData(BuildContext context, bool reload) async {
    String languageCode = Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode == 'US'?
    'en':Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode.toLowerCase();
    Provider.of<ProductProvider>(context, listen: false).initSellerProductList(sellerId, 1, context, languageCode, reload: true);
    await Provider.of<ProductReviewProvider>(context, listen: false).getReviewList( context);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ShopProvider>(context, listen: false).selectedIndex;
    sellerId = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id.toString();
    _loadData(context, false);
    PageController _pageController = PageController(initialPage: widget.initialPage);
    Provider.of<ShopProvider>(context, listen: false).getShopInfo(context);
    return Scaffold(
      appBar: CustomAppBar(title : getTranslated('my_shop', context)),
        body: SafeArea(
            child: Consumer<ShopProvider>(
                builder: (context, resProvider, child) {
                  return resProvider.shopModel !=null ? resProvider.shopModel != null ?
                  Container(
                      child: Column(children: [
                        Stack(children: [
                          Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width/3,
                          child: ClipRRect(
                            child: CachedNetworkImage(fit: BoxFit.cover,
                              placeholder: (ctx, url) => Image.asset(Images.placeholder_image,),
                              errorWidget: (ctx,url,err) => Image.asset(Images.placeholder_image,fit: BoxFit.cover,),
                              imageUrl: '${Provider.of<SplashProvider>(context,listen: false).
                              baseUrls.shopImageUrl}/banner/${resProvider.shopModel.banner}',),
                          ),
                        ),

                      ],),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),


                        Padding(padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_MEDIUM),
                          child: Row(crossAxisAlignment :CrossAxisAlignment.start, children: [
                            Container(width: 60, height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),

                              child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: CachedNetworkImage(
                                  placeholder: (ctx, url) => Image.asset(Images.placeholder_image,),
                                  fit: BoxFit.cover,
                                  errorWidget: (ctx,url,err) => Image.asset(Images.placeholder_image,),
                                  imageUrl: '${Provider.of<SplashProvider>(context,listen: false).
                                  baseUrls.shopImageUrl}/${resProvider.shopModel.image}',),
                              ),
                            ),
                            SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),


                            Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${resProvider.shopModel.name ?? ''}',
                                style: robotoBold.copyWith(color: ColorResources.getTextColor(context),
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT),),
                                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                Text('${resProvider.shopModel.address ?? ''}',
                                  style: robotoRegular.copyWith(color: ColorResources.getSubTitleColor(context),
                                      fontSize: Dimensions.FONT_SIZE_SMALL), maxLines: 2,
                                  overflow: TextOverflow.ellipsis,softWrap: false,),
                                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                Row(children: [Container(width: Dimensions.ICON_SIZE_SMALL, height: Dimensions.ICON_SIZE_SMALL,
                                    child: Image.asset(Images.star)),
                                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL,),


                                  Text('${resProvider.shopModel.ratting.toDouble().toStringAsFixed(1) ?? ''}',
                                    style: robotoTitleRegular.copyWith(color: ColorResources.getTextColor(context),
                                        fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),),
                                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL,),

                                ],),

                                Row(children: [
                                  Text('${resProvider.shopModel.rattingCount ?? ''}',
                                    style: robotoRegular.copyWith(color: ColorResources.getTextColor(context),
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT),),
                                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL,),


                                  Text(getTranslated('reviews', context),
                                    style: robotoRegular.copyWith(color: ColorResources.getSubTitleColor(context),
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT),),


                                  Padding(
                                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    child: Container(width: 5,height: 5,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).hintColor,
                                        borderRadius: BorderRadius.circular(5)
                                      )),
                                  ),

                                  Consumer<ProductProvider>(
                                    builder: (context, product,_) {
                                      return Text('${product.sellerProductList.length ?? '0'}',
                                        style: robotoRegular.copyWith(color: ColorResources.getTextColor(context),
                                            fontSize: Dimensions.FONT_SIZE_DEFAULT),);
                                    }
                                  ),
                                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL,),


                                  Text(getTranslated('products', context),
                                    style: robotoRegular.copyWith(color: ColorResources.getSubTitleColor(context),
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT),)
                                ],)

                              ],),),
                            InkWell(
                              onTap: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ShopUpdateScreen())),
                              child: Align(alignment: Alignment.centerRight,
                                child: Column(
                                  children: [
                                    Container(width: Dimensions.ICON_SIZE_EXTRA_LARGE,height: Dimensions.ICON_SIZE_EXTRA_LARGE,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_LARGE)),
                                            color: Theme.of(context).primaryColor
                                        ),
                                        child: Padding(padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                          child: Image.asset(Images.edit,color: Colors.white,),)),
                                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
                                    Text(getTranslated('edit', context),
                                      style: titilliumRegular.copyWith(color: Theme.of(context).primaryColor),)
                                  ],
                                ),
                              ),
                            ),
                          ],),
                        ),




                        Padding(padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT), child: Stack(
                          clipBehavior: Clip.none, children: [
                            Positioned(bottom: 0, right: Dimensions.PADDING_SIZE_SMALL, left: 0,
                              child: Container(width: MediaQuery.of(context).size.width, height: 1,
                                color: ColorResources.getGainsBoro(context),),),


                          Consumer<ShopProvider>(
                            builder: (context,authProvider,child)=>Row(children: [
                              InkWell(
                                onTap: () => _pageController.animateToPage(0, duration: Duration(seconds: 1), curve: Curves.easeInOut),
                                child: Column(children: [
                                  Text(getTranslated('all_products', context), style: authProvider.selectedIndex == 0 ?
                                  titilliumSemiBold : titilliumRegular),
                                  Container(height: 1, width: MediaQuery.of(context).size.width/2-30,
                                    margin: EdgeInsets.only(top: 8),
                                    color: authProvider.selectedIndex == 0 ?
                                    Theme.of(context).primaryColor : Colors.transparent,
                                  ),
                                ],),),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),


                              InkWell(onTap: () => _pageController.animateToPage(1, duration: Duration(seconds: 1),
                                  curve: Curves.easeInOut),
                                child: Column(children: [
                                  Text(getTranslated('product_review', context), style: authProvider.selectedIndex == 1 ?
                                  titilliumSemiBold : titilliumRegular),
                                  Container(height: 1, width: MediaQuery.of(context).size.width/2-30, margin: EdgeInsets.only(top: 8),
                                      color: authProvider.selectedIndex == 1 ?
                                      Theme.of(context).primaryColor : Colors.transparent
                                  ),
                                ],
                                ),
                              ),
                            ],
                            ),
                          ),
                        ],
                        ),
                        ),



                        Expanded(child: Consumer<ShopProvider>(
                          builder: (context,shopProvider,child)=>PageView.builder(
                            itemCount: 2,
                            controller: _pageController,
                            itemBuilder: (context, index) {
                              if (shopProvider.selectedIndex == 0) {
                                return ProductView(sellerId: shopProvider.shopModel.id, isShop: true);
                              } else {
                                return ProductReview();
                              }
                              },
                            onPageChanged: (index) {
                              shopProvider.updateSelectedIndex(index);
                              },
                          ),
                        ),
                        ),
                      ],)
                  ) : NoDataScreen() :
                  Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
                })
        )
    );
  }
}

