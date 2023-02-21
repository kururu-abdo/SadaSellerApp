import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/data/model/response/refund_model.dart';
import 'package:eamar_seller_app/helper/date_converter.dart';
import 'package:eamar_seller_app/helper/price_converter.dart';
import 'package:eamar_seller_app/localization/language_constrants.dart';
import 'package:eamar_seller_app/provider/refund_provider.dart';
import 'package:eamar_seller_app/provider/splash_provider.dart';
import 'package:eamar_seller_app/provider/theme_provider.dart';
import 'package:eamar_seller_app/utill/app_constants.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/images.dart';
import 'package:eamar_seller_app/utill/styles.dart';
import 'package:eamar_seller_app/view/base/confirmation_dialog.dart';
import 'package:eamar_seller_app/view/base/custom_app_bar.dart';
import 'package:eamar_seller_app/view/base/custom_divider.dart';
import 'package:eamar_seller_app/view/base/custom_snackbar.dart';

import 'image_diaglog.dart';

class RefundDetailScreen extends StatefulWidget {
  final RefundModel refundModel;
  final int orderDetailsId;
  final String variation;
  RefundDetailScreen({@required this.refundModel, @required this.orderDetailsId, this.variation});

  @override
  _RefundDetailScreenState createState() => _RefundDetailScreenState();
}

class _RefundDetailScreenState extends State<RefundDetailScreen> {
  @override
  Widget build(BuildContext context) {
    int count =0;
    final TextEditingController noteController = TextEditingController();
    Provider.of<RefundProvider>(context, listen: false).getRefundReqInfo(context, widget.orderDetailsId);

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('refund_details', context)),
      body: SingleChildScrollView(
        child: Consumer<RefundProvider>(
            builder: (context,refundReq,_) {
              return Container(
                child: Column(mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                     Container(
                       decoration: BoxDecoration(
                       color: Theme.of(context).cardColor,
                       boxShadow: [
                         BoxShadow(color: ColorResources.getPrimary(context).withOpacity(.05),
                             spreadRadius: -3, blurRadius: 12, offset: Offset.fromDirection(0,6))],
                     ),
                       child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_MEDIUM,
                               right: Dimensions.PADDING_SIZE_DEFAULT,
                               top: Dimensions.PADDING_SIZE_EXTRA_LARGE, bottom: Dimensions.PADDING_SIZE_SMALL),
                           child: Row(children: [
                             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                               Text('${getTranslated('order_no', context)}# ${widget.refundModel.orderId.toString()}',
                                 style: titilliumBold.copyWith(color: ColorResources.getTextColor(context),
                                     fontSize: Dimensions.FONT_SIZE_LARGE),),
                               Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(widget.refundModel.createdAt)),
                                   style: titilliumRegular.copyWith(color: Theme.of(context).hintColor)),
                             ],
                             ),

                             Expanded(child: SizedBox()),
                             Container(alignment: Alignment.center,
                               padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,
                                   vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                               decoration: BoxDecoration(color: widget.refundModel.status == 'approved' ?
                               ColorResources.mainCardThreeColor(context).withOpacity(.085):
                               ColorResources.mainCardFourColor(context).withOpacity(.085),
                                 borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE),),
                               child: Center(
                                 child: Text(widget.refundModel.status,
                                     style: titilliumBold.copyWith(color: widget.refundModel.status == 'approved' ?
                                     ColorResources.GREEN : ColorResources.RED, fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                               ),
                             ),
                           ]),
                         ),
                         SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                           child: CustomDivider(),
                         ),
                         SizedBox(height: Dimensions.PADDING_SIZE_SMALL),



                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                           child: Text('${getTranslated('product_details', context)}',
                             style: titilliumBold.copyWith(color: ColorResources.getTextColor(context),
                                 fontSize: Dimensions.FONT_SIZE_LARGE),),
                         ),
                         SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                         widget.refundModel.product != null?
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                           child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                             Stack(
                               children: [
                                 Container(width: 100, height: 100,
                                   child: ClipRRect(
                                     borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_SMALL)),
                                     child: FadeInImage.assetNetwork(placeholder: Images.placeholder_image,
                                       image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.productThumbnailUrl}/'
                                           '${widget.refundModel.product.thumbnail}',
                                       width: Dimensions.image_size, height: Dimensions.image_size, fit: BoxFit.cover,
                                       imageErrorBuilder: (c,o,x)=> Image.asset(Images.placeholder_image,
                                         width: Dimensions.image_size, height: Dimensions.image_size, fit: BoxFit.cover,),),
                                   ) ,
                                   decoration: BoxDecoration(color: Colors.white,
                                     borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_SMALL)),),),

                                 widget.refundModel.product.discount > 0 ?
                                 Positioned(top: 0, left: 0, child: Container(
                                   height: 20,
                                   padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                   decoration: BoxDecoration(
                                     color: ColorResources.getPrimary(context),
                                     borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                   ),


                                   child: Center(
                                     child: Text(PriceConverter.percentageCalculation(context, widget.refundModel.product.unitPrice,
                                         widget.refundModel.product.discount, widget.refundModel.product.discountType),
                                       style: robotoRegular.copyWith(color: Theme.of(context).highlightColor,
                                           fontSize: Dimensions.FONT_SIZE_SMALL),
                                     ),
                                   ),
                                 ),
                                 ) : SizedBox.shrink(),


                               ],
                             ),
                             SizedBox(width: Dimensions.PADDING_SIZE_SMALL),




                             Consumer<RefundProvider>(
                                 builder: (context, refund, _) {
                                   return refund.refundDetailsModel != null ?
                                   Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                     mainAxisAlignment: MainAxisAlignment.start, children: [
                                       Text('${widget.refundModel.product.name.toString()}',
                                         maxLines: 1, overflow: TextOverflow.ellipsis,
                                         style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context),
                                             fontSize: Dimensions.FONT_SIZE_DEFAULT),),


                                       Text('${PriceConverter.convertPrice(context,
                                           refund.refundDetailsModel.productPrice)}',
                                         maxLines: 1, overflow: TextOverflow.ellipsis,
                                         style: titilliumBold.copyWith(color: ColorResources.getPrimary(context),
                                             fontSize: Dimensions.FONT_SIZE_LARGE),),


                                       (widget.variation != null && widget.variation.isNotEmpty) ?
                                       Padding(padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                         child: Text(widget.variation,
                                             style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                                               color: Theme.of(context).disabledColor,)),
                                       ) : SizedBox(),

                                       Row(
                                         children: [
                                           Text('${getTranslated('qty', context)}:',
                                             maxLines: 1, overflow: TextOverflow.ellipsis,
                                             style: titilliumRegular.copyWith(color: ColorResources.getHint(context),
                                                 fontSize: Dimensions.FONT_SIZE_DEFAULT),),
                                           Text('${refund.refundDetailsModel.quntity}',
                                             maxLines: 1, overflow: TextOverflow.ellipsis,
                                             style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context),
                                                 fontSize: Dimensions.FONT_SIZE_DEFAULT),),
                                         ],
                                       ),
                                     ],),):SizedBox();
                                 }),]),
                         ):
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                           child: Text(getTranslated('product_was_deleted', context)),
                         ),



                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                               vertical: Dimensions.PADDING_SIZE_DEFAULT),
                           child: Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [

                             Text('${getTranslated('refund_reason', context)} : ',
                                 style: titilliumSemiBold.copyWith(color: ColorResources.mainCardFourColor(context))),
                             SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                             Text('${widget.refundModel.refundReason.toString()}',maxLines: 10,
                               style: titilliumRegular.copyWith(color: ColorResources.getHint(context)),),
                           ],),
                         ),






                         widget.refundModel.images != null && widget.refundModel.images.length>0?
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                           child: Text('${getTranslated('attachment', context)} : ',
                               style: titilliumSemiBold.copyWith(color: ColorResources.mainCardFourColor(context))),
                         ):SizedBox(),


                         widget.refundModel.images != null && widget.refundModel.images.length>0?
                         Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_EYE),
                           child: Container(height: Dimensions.image_size,
                             child: ListView.builder(
                               scrollDirection: Axis.horizontal,
                               shrinkWrap: true,
                               itemCount:  widget.refundModel.images.length,
                               itemBuilder: (BuildContext context, index){
                                 return  widget.refundModel.images.length > 0?
                                 Padding(padding: const EdgeInsets.all(8.0), child: Stack(children: [
                                   InkWell(onTap: () => showDialog(context: context, builder: (ctx)  =>
                                       ImageDialog(imageUrl:'${AppConstants.BASE_URL}/storage/app/public/refund/'
                                           '${widget.refundModel.images[index]}'), ),

                                     child: Container(width: Dimensions.image_size, height: Dimensions.image_size,
                                       child: ClipRRect(borderRadius: BorderRadius.all(
                                           Radius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL)),
                                         child: FadeInImage.assetNetwork(placeholder: Images.placeholder_image,
                                           image: '${AppConstants.BASE_URL}/storage/app/public/refund/'
                                               '${widget.refundModel.images[index]}',
                                           width: Dimensions.image_size, height: Dimensions.image_size,
                                           fit: BoxFit.cover,
                                           imageErrorBuilder: (c,o,x)=> Image.asset(Images.placeholder_image,
                                             fit: BoxFit.cover,width: Dimensions.image_size,height: Dimensions.image_size,),
                                         ),
                                       ) , decoration: BoxDecoration(color: Colors.white,
                                         borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_SMALL)),),),
                                   ),
                                 ],
                                 ),
                                 ):SizedBox();

                               },),
                           ),
                         ):SizedBox(),
                       ],
                     ),),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),



                      Container(
                        padding: EdgeInsets.only(top: Dimensions.PADDING_EYE, bottom: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(color: ColorResources.getPrimary(context).withOpacity(.05),
                                spreadRadius: -3, blurRadius: 12, offset: Offset.fromDirection(0,6))],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                          child: Consumer<RefundProvider>(
                              builder: (context, refund,_) {
                                return Padding(padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                  child: refund.refundDetailsModel != null?
                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                    Row(children: [
                                      Text('${getTranslated('product_price', context)} (x 1)',
                                        style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                          color: ColorResources.titleColor(context)),),
                                      Spacer(),
                                      Text('${PriceConverter.convertPrice(context,
                                          refund.refundDetailsModel.productPrice,)}',
                                        style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                          color: ColorResources.titleColor(context)),),
                                    ],),
                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),



                                    Row(children: [
                                      Text('${getTranslated('product_discount', context)}',
                                        style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                          color: ColorResources.titleColor(context)),),
                                      Spacer(),
                                      Text('-${PriceConverter.convertPrice(context,
                                          refund.refundDetailsModel.productTotalDiscount)}',
                                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                          color: ColorResources.titleColor(context))),
                                    ],),
                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

                                    Row(children: [
                                      Text('${getTranslated('coupon_discount', context)}',
                                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                          color: ColorResources.titleColor(context))),
                                      Spacer(),
                                      Text('-${PriceConverter.convertPrice(context,
                                          refund.refundDetailsModel.couponDiscount)}',
                                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                          color: ColorResources.titleColor(context))),
                                    ],),



                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

                                    Row(children: [
                                      Text('${getTranslated('product_tax', context)}',
                                        style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                          color: ColorResources.titleColor(context)),),
                                      Spacer(),
                                      Text('+${PriceConverter.convertPrice(context,
                                          refund.refundDetailsModel.productTotalTax)}',
                                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                          color: ColorResources.titleColor(context))),
                                    ],),


                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

                                    Row(children: [
                                      Text('${getTranslated('subtotal', context)}',
                                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                          color: ColorResources.titleColor(context))),
                                      Spacer(),
                                      Text('${PriceConverter.convertPrice(context,
                                          refund.refundDetailsModel.subtotal)}',
                                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                                          color: ColorResources.titleColor(context))),
                                    ],),




                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                                    CustomDivider(),
                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

                                    Row(children: [
                                      Text('${getTranslated('total_refund_amount', context)}',
                                        style: titilliumSemiBold.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.FONT_SIZE_LARGE),),
                                      Spacer(),
                                      Text('${PriceConverter.convertPrice(context,
                                          refund.refundDetailsModel.refundAmount)}',
                                        style: titilliumSemiBold.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.FONT_SIZE_LARGE),),
                                    ],),


                                  ]):SizedBox(),);}),
                        ),
                      ),

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),





                      widget.refundModel.customer != null?
                      Container(

                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_MEDIUM),
                        decoration: BoxDecoration(color: Theme.of(context).cardColor,
                          boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200],
                              spreadRadius: 0.5, blurRadius: 0.3)],),


                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(getTranslated('customer_contact_details', context),
                              style: titilliumBold.copyWith(color: ColorResources.getTextColor(context))),
                          SizedBox(height: Dimensions.PADDING_SIZE_MEDIUM),

                          Row(children: [ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                                errorWidget: (ctx, url, err) => Image.asset(Images.placeholder_image),
                                placeholder: (ctx, url) => Image.asset(Images.placeholder_image),
                                imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/'
                                    '${widget.refundModel.customer.image}',
                                height: 50,width: 50, fit: BoxFit.cover),),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),




                            Expanded(child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('${widget.refundModel.customer.fName ?? ''} ${widget.refundModel.customer.lName ?? ''}',
                                  style: titilliumBold.copyWith(color: ColorResources.getTextColor(context),
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT)),

                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),

                              Text('${getTranslated('email', context)} : ${widget.refundModel.customer.email ?? ''}',
                                  style: titilliumRegular.copyWith(color: ColorResources.titleColor(context),
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT)),

                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),

                              Text('${getTranslated('contact', context)} : ${widget.refundModel.customer.phone}',
                                  style: titilliumRegular.copyWith(color: ColorResources.titleColor(context),
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                                ],
                              ))
                            ],
                          )
                        ]),):SizedBox(),

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

                      (refundReq.refundDetailsModel !=null && refundReq.refundDetailsModel.deliverymanDetails != null)?
                      Container(margin: EdgeInsets.only(left: 5, right: 5),
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                            vertical: Dimensions.PADDING_SIZE_DEFAULT),
                        decoration: BoxDecoration(color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(getTranslated('deliveryman_contact_details', context),
                              style: titilliumBold.copyWith(color: ColorResources.getTextColor(context))),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                          Row(children: [ClipRRect(borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                                errorWidget: (ctx, url, err) => Image.asset(Images.placeholder_image),
                                placeholder: (ctx, url) => Image.asset(Images.placeholder_image),
                                imageUrl: '${Provider.of<SplashProvider>(context, listen: false).
                                baseUrls.reviewImageUrl}/delivery-man/'
                                    '${refundReq.refundDetailsModel.deliverymanDetails.image}',
                                height: 50,width: 50, fit: BoxFit.cover),),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),



                            Expanded(child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [

                              Text('${refundReq.refundDetailsModel.deliverymanDetails.fName ?? ''} '
                                  '${refundReq.refundDetailsModel.deliverymanDetails.lName ?? ''}',
                                  style: titilliumBold.copyWith(color: ColorResources.getTextColor(context),
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),

                              Text('${getTranslated('email', context)} : '
                                  '${refundReq.refundDetailsModel.deliverymanDetails.email ?? ''}',
                                  style: titilliumRegular.copyWith(color: ColorResources.getHintColor(context),
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),

                              Text('${getTranslated('contact', context)} : '
                                  '${refundReq.refundDetailsModel.deliverymanDetails.phone}',
                                  style: titilliumRegular.copyWith(color: ColorResources.getHintColor(context),
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                                ],
                              ))
                            ],
                          )
                        ]),
                      ):SizedBox(),

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      (refundReq.refundDetailsModel != null && refundReq.refundDetailsModel.refundRequest[0].refundStatus != null)?
                      Container(
                        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(color: Theme.of(context).cardColor,
                          boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200],
                              spreadRadius: 0.5, blurRadius: 0.3)],),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                              vertical: Dimensions.PADDING_SIZE_SMALL),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(getTranslated('refund_status_change_log', context),
                                style: titilliumBold.copyWith(color: ColorResources.getTextColor(context))),
                            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),



                            ConstrainedBox(constraints: refundReq.refundDetailsModel.refundRequest[0].refundStatus.length > 0 ?
                            BoxConstraints(maxHeight: 180 * double.parse(
                                refundReq.refundDetailsModel.refundRequest[0].refundStatus.length.toString())):
                            BoxConstraints(maxHeight: 0),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: refundReq.refundDetailsModel.refundRequest[0].refundStatus.length,
                                itemBuilder: (context,index) {
                                  if(refundReq.refundDetailsModel.refundRequest[0].refundStatus[index].changeBy =="admin"){
                                    count++;}
                                  return Row(mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Expanded(flex: 1, child:Column(crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center, children: [
                                          Container(
                                              width: 40,height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_LARGE),
                                                color: Theme.of(context).primaryColor,),
                                            child: Icon(Icons.info_outline,color: Theme.of(context).cardColor,),
                                          ),

                                          index == refundReq.refundDetailsModel.refundRequest[0].refundStatus.length-1? SizedBox():
                                          Container(height : 60,width: 2, color: Theme.of(context).primaryColor,),

                                        ],)),


                                      Expanded(flex:6,
                                        child: Container(margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                            right: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                            Text('${getTranslated('status', context)} : '
                                                '${refundReq.refundDetailsModel.refundRequest[0].refundStatus[index].status ?? ''}',
                                                style: titilliumRegular.copyWith(color: ColorResources.getHintColor(context),
                                                    fontSize: Dimensions.FONT_SIZE_DEFAULT)),



                                            Text('${getTranslated('updated_by', context)} : '
                                                '${refundReq.refundDetailsModel.refundRequest[0].refundStatus[index].changeBy ?? ''}',
                                                style: titilliumRegular.copyWith(color: ColorResources.getHintColor(context),
                                                    fontSize: Dimensions.FONT_SIZE_DEFAULT)),

                                            Text('${getTranslated('reason', context)} : '
                                                '${refundReq.refundDetailsModel.refundRequest[0].refundStatus[index].message ?? ''}',
                                                maxLines : 4,
                                                style: titilliumRegular.copyWith(color: ColorResources.getHintColor(context),
                                                    fontSize: Dimensions.FONT_SIZE_DEFAULT)),

                                            ]),
                                          ),
                                      ),
                                    ],
                                  );
                                  }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ):SizedBox(),

                    ]),
              );
            }
        ),
      ),
      bottomNavigationBar:  Consumer<RefundProvider>(
        builder: (context,refundReq,_) {
          return Container(height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(color: ColorResources.getPrimary(context).withOpacity(.10),
                    spreadRadius: 5, blurRadius: 3, offset: Offset.fromDirection(0,6))],
            ),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.FONT_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_SMALL),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Container(width: MediaQuery.of(context).size.width/2.2,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL)),
                    ),

                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: InkWell(onTap: (){
                        if(count > 0){
                          showCustomSnackBar(getTranslated('you_cant_override_admin_decision', context), context);
                        }else{Navigator.pop(context);
                        refundReq.toggleSendButtonActivity();
                        showDialog(context: context, builder: (BuildContext context){
                          return ConfirmationDialog(icon:  Images.cross,
                              description: getTranslated('are_you_sure_want_to_reject', context),
                              note: noteController,
                              refund: true,
                              onYesPressed: () {
                                if(noteController.text.trim().isEmpty){
                                  showCustomSnackBar(getTranslated('note_required', context), context);
                                }else{
                                  refundReq.isLoading?
                                  Center(child: CircularProgressIndicator()):refundReq.updateRefundStatus(context, widget.refundModel.id, 'rejected', noteController.text.trim()).then((value) {
                                    if(value.response.statusCode ==200){
                                      Provider.of<RefundProvider>(context, listen: false).getRefundList(context);
                                      Navigator.pop(context);
                                    }
                                  });
                                }

                              }
                          );});
                        }
                      }, child: Text(getTranslated('reject', context),
                          style: titilliumSemiBold.copyWith(color: Theme.of(context).cardColor))),
                    ))),
                Container(width: MediaQuery.of(context).size.width/2.2,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL)),
                    ),

                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: InkWell(
                          onTap: (){
                            if(count > 0){
                              showCustomSnackBar(getTranslated('you_cant_override_admin_decision', context), context);
                            }else{
                              Navigator.pop(context);
                              refundReq.toggleSendButtonActivity();
                              showDialog(context: context,barrierDismissible: false, builder: (BuildContext context){
                                return ConfirmationDialog(icon:  Images.ok_icon,
                                    description: getTranslated('are_you_sure_want_to_approve', context),
                                    note: noteController,
                                    refund: true,
                                    onYesPressed: () {

                                      if(noteController.text.trim().isEmpty){
                                        showCustomSnackBar(getTranslated('note_required', context), context);
                                      }else{
                                        refundReq.isLoading?
                                        Center(child: CircularProgressIndicator()):refundReq.updateRefundStatus(context, widget.refundModel.id, 'approved',noteController.text.trim()).then((value) {
                                          if(value.response.statusCode ==200){
                                            Provider.of<RefundProvider>(context, listen: false).getRefundList(context);
                                            Navigator.pop(context);
                                            noteController.clear();
                                          }
                                        });
                                      }});});}},

                          child: Text(getTranslated('approve', context),
                              style:titilliumSemiBold.copyWith(color: Theme.of(context).cardColor))),
                    ))),


              ],),
          );
        }
      ),
    );
  }
}

