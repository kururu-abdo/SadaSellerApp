import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/data/model/response/product_model.dart';
import 'package:eamar_seller_app/helper/price_converter.dart';
import 'package:eamar_seller_app/localization/language_constrants.dart';
import 'package:eamar_seller_app/provider/product_provider.dart';
import 'package:eamar_seller_app/provider/profile_provider.dart';
import 'package:eamar_seller_app/provider/restaurant_provider.dart';
import 'package:eamar_seller_app/provider/splash_provider.dart';
import 'package:eamar_seller_app/provider/theme_provider.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/images.dart';
import 'package:eamar_seller_app/utill/styles.dart';
import 'package:eamar_seller_app/view/base/confirmation_dialog.dart';
import 'package:eamar_seller_app/view/screens/addProduct/add_product_screen.dart';


class ProductWidget extends StatelessWidget {
  final Product productModel;
  final bool isShop;
  final bool isHome;
  ProductWidget({@required this.productModel, this.isShop = false, this.isHome = false});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: isShop? null: MediaQuery.of(context).size.width/1.4,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isShop? 0 : 7.0,vertical: 4.0),
        child: Stack(
          children: [
            isShop?
            Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_MEDIUM),
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200],
                    spreadRadius: 0.5, blurRadius: 0.3)],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                  child: Container(
                    decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.10),
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),),
                    width: Dimensions.image_size,
                    height: Dimensions.image_size,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                      child: CachedNetworkImage(
                        placeholder: (ctx, url) => Image.asset(Images.placeholder_image,),
                        fit: BoxFit.cover,
                        height: Dimensions.image_size,width: Dimensions.image_size,
                        errorWidget: (ctx,url,err) => Image.asset(Images.placeholder_image,fit: BoxFit.cover,
                          height: Dimensions.image_size,width: Dimensions.image_size,),
                        imageUrl: '${Provider.of<SplashProvider>(context, listen: false).
                        baseUrls.productThumbnailUrl}/${productModel.thumbnail}',),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),


                Flexible(child: Padding(padding: const EdgeInsets.all(8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(productModel.name ?? '', style: robotoRegular.copyWith(color: ColorResources.titleColor(context)),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                    Row(
                      children: [
                        productModel.discount > 0 ?
                        Text(PriceConverter.convertPrice(context, productModel.unitPrice),
                          maxLines: 1,overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(color: ColorResources.mainCardFourColor(context),
                            decoration: TextDecoration.lineThrough,
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                          ),): SizedBox.shrink(),

                      ],
                    ),

                    productModel.discount > 0 ?SizedBox(height: Dimensions.PADDING_SIZE_SMALL):SizedBox.shrink(),


                    Row(children: [
                      Text(PriceConverter.convertPrice(context, productModel.unitPrice,
                          discountType: productModel.discountType, discount: productModel.discount),
                        style: robotoBold.copyWith(color: ColorResources.titleColor(context)),),
                      Expanded(child: SizedBox.shrink()),






                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),


                  ],),
                ),
                ),
              ],),
            ):

            Container(decoration: BoxDecoration(
              color: isHome? Theme.of(context).cardColor:Colors.transparent,


            ),
              child: Column(children: [
              Container(decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(.10),
                borderRadius: BorderRadius.only(topLeft:Radius.circular(Dimensions.PADDING_SIZE_SMALL),
                    topRight: Radius.circular(Dimensions.PADDING_SIZE_SMALL)),),
                width: 160,
                height: 120,


                child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft:Radius.circular(Dimensions.PADDING_SIZE_SMALL),
                    topRight: Radius.circular(Dimensions.PADDING_SIZE_SMALL)),
                  child: CachedNetworkImage(
                    placeholder: (ctx, url) => Image.asset(Images.placeholder_image,),
                    fit: BoxFit.cover,
                    height: Dimensions.image_size,width: Dimensions.image_size,
                    errorWidget: (ctx,url,err) => Image.asset(Images.placeholder_image,fit: BoxFit.cover,
                      height: Dimensions.image_size,width: Dimensions.image_size,),
                    imageUrl: '${Provider.of<SplashProvider>(context, listen: false).
                    baseUrls.productThumbnailUrl}/${productModel.thumbnail}',),
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),


              Flexible(child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(productModel.name ?? '', style: robotoRegular.copyWith(color: ColorResources.titleColor(context)),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),




                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        productModel.discount > 0 ?
                        Text(PriceConverter.convertPrice(context, productModel.unitPrice),
                          style: robotoRegular.copyWith(color: ColorResources.mainCardFourColor(context),
                            decoration: TextDecoration.lineThrough,
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                          ),): SizedBox.shrink(),


                        Text(PriceConverter.convertPrice(context, productModel.unitPrice,
                            discountType: productModel.discountType, discount: productModel.discount),
                          style: robotoBold.copyWith(color: ColorResources.getPrimary(context)),),

                      ],),

                      Expanded(child: SizedBox.shrink()),

                      // Row(crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [Text(productModel.rating != null ? productModel.rating.length != 0 ?
                      // double.parse(productModel.rating[0].average).toStringAsFixed(1) : '0.0' : '0.0',
                      //     style: robotoRegular.copyWith(
                      //       color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.orange,
                      //       fontSize: Dimensions.FONT_SIZE_DEFAULT,)),
                      //
                      //   Icon(Icons.star, color: Provider.of<ThemeProvider>(context).darkTheme ?
                      //   Colors.white : Colors.orange, size: Dimensions.ICON_SIZE_DEFAULT),],),

                    ],
                  ),

                  productModel.discount > 0 ?SizedBox(height: Dimensions.PADDING_SIZE_SMALL):SizedBox.shrink(),

                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),


                ],),
              ),
              ),
          ],),
            ),



            Positioned(top: isShop? 70 : 15, right: isShop? 80 : 15,
              child: Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              decoration: BoxDecoration(
                color: ColorResources.getPrimary(context),
                borderRadius: BorderRadius.circular(20),),
              child: Center(child:  InkWell(onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddProductScreen(product: productModel)));},
                child: Container( width: Dimensions.ICON_SIZE_DEFAULT,height: Dimensions.ICON_SIZE_DEFAULT,
                    child: Image.asset(Images.edit,color: Theme.of(context).cardColor)),),
              ),
            ),),
            Positioned(top: isShop? 70: 70, right: 15,
              child: Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                decoration: BoxDecoration(
                  color: ColorResources.mainCardFourColor(context),
                  borderRadius: BorderRadius.circular(20),),
                child: Center(child: InkWell(onTap: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return ConfirmationDialog(icon: Images.delete_product,
                        refund: false,
                        description: getTranslated('are_you_sure_want_to_delete_this_product', context),
                        onYesPressed: () {
                        Provider.of<RestaurantProvider>(context, listen:false).deleteProduct(context ,productModel.id).then((value) {
                          Provider.of<ProductProvider>(context,listen: false).getStockOutProductList(1, context, 'en');
                          Provider.of<ProductProvider>(context, listen: false).initSellerProductList(Provider.of<ProfileProvider>(context, listen: false).
                          userInfoModel.id.toString(), 1, context, 'en', reload: true);
                        });
                    }

                    );});
                },
                    child: SizedBox(width: Dimensions.ICON_SIZE_DEFAULT, height: Dimensions.ICON_SIZE_DEFAULT,
                      child: Image.asset(Images.delete,
                          color: Provider.of<ThemeProvider>(context).darkTheme ?
                          Colors.white : Theme.of(context).cardColor),
                    )),
                ),
              ),),
          ],
        ),
      ),
    );
  }
}
