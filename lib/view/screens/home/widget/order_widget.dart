import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:joseeder_seller/data/model/response/order_model.dart';
import 'package:joseeder_seller/helper/date_converter.dart';
import 'package:joseeder_seller/localization/language_constrants.dart';
import 'package:joseeder_seller/provider/splash_provider.dart';
import 'package:joseeder_seller/utill/color_resources.dart';
import 'package:joseeder_seller/utill/dimensions.dart';
import 'package:joseeder_seller/utill/styles.dart';
import 'package:joseeder_seller/view/base/custom_divider.dart';
import 'package:joseeder_seller/view/screens/order/order_details_screen.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final int index;
  OrderWidget({@required this.orderModel, this.index});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(splashColor: Theme.of(context).primaryColor.withOpacity(.10)),
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_ORDER),

        child: Column( crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => OrderDetailsScreen (
                    orderModel: orderModel ,orderId: orderModel.id,orderType: orderModel.orderType,
                    shippingType: orderModel.shipping != null?Provider.of<SplashProvider>(context, listen: false).configModel.shippingMethod:'inhouse_shipping',
                    extraDiscount: orderModel.extraDiscount,extraDiscountType: orderModel.extraDiscountType,))),
              child: Container(child: Column( crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text('${getTranslated('order_no', context)}#${orderModel.id} ${orderModel.orderType == 'POS'? '(POS)':''} ',
                  style: titilliumSemiBold.copyWith(color: ColorResources.getTextColor(context),fontSize: Dimensions.FONT_SIZE_LARGE),),

                Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(orderModel.createdAt)),
                        style: titilliumRegular.copyWith(color: Theme.of(context).hintColor)),
                    Spacer(),

                    InkWell(onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => OrderDetailsScreen (
                          orderModel: orderModel ,orderId: orderModel.id,orderType: orderModel.orderType,
                          shippingType: orderModel.shipping != null?Provider.of<SplashProvider>(context, listen: false).configModel.shippingMethod:'inhouse_shipping',
                          extraDiscount: orderModel.extraDiscount,extraDiscountType: orderModel.extraDiscountType,))),
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                        child: Text('${getTranslated('view_details', context)}',
                            style: titilliumRegular.copyWith(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).primaryColor,
                                fontSize: Dimensions.FONT_SIZE_DEFAULT)),),),


                    Container(width: Dimensions.ICON_SIZE_DEFAULT,height: Dimensions.ICON_SIZE_DEFAULT,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_LARGE),
                            color: Theme.of(context).primaryColor),
                        child: Icon(Icons.arrow_forward_outlined, color: Theme.of(context).cardColor,
                          size: Dimensions.ICON_SIZE_SMALL,))
                  ],
                ),


                Row(mainAxisAlignment:MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(height: Dimensions.ICON_SIZE_EXTRA_SMALL, width: Dimensions.ICON_SIZE_EXTRA_SMALL,
                    decoration: BoxDecoration(shape: BoxShape.circle, color:orderModel.paymentStatus == 'paid' ?
                    ColorResources.mainCardThreeColor(context) : ColorResources.mainCardFourColor(context)),),


                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                  Text(orderModel.paymentStatus,
                      style: titilliumBold.copyWith(color: orderModel.paymentStatus == 'paid' ?
                      ColorResources.mainCardThreeColor(context) : ColorResources.mainCardFourColor(context),
                          fontSize: Dimensions.FONT_SIZE_DEFAULT)),],),
              ],),),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

            CustomDivider()
          ],
        ),
      ),
    );
  }
}

