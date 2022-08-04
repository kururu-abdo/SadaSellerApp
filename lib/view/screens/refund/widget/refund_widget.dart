import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/refund_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_divider.dart';
import 'package:sixvalley_vendor_app/view/screens/refund/widget/refund_details.dart';

class RefundWidget extends StatelessWidget {
  final RefundModel refundModel;
  RefundWidget({@required this.refundModel});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(splashColor: ColorResources.mainCardThreeColor(context).withOpacity(.10)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RefundDetailScreen(
            refundModel: refundModel, orderDetailsId: refundModel.orderDetailsId,
            variation: refundModel.orderDetails.variant))),
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_ORDER, vertical: Dimensions.PADDING_SIZE_SMALL),

            child: refundModel != null ?
            Row(children: [Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${getTranslated('order_no', context)}# ${refundModel.orderId.toString()}',
                  style: titilliumBold.copyWith(color: ColorResources.getTextColor(context),
                      fontSize: Dimensions.FONT_SIZE_LARGE),),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),

     refundModel.product != null?
                Text('${refundModel.product.name.toString()}',
                  maxLines: 2,overflow: TextOverflow.ellipsis,
                  style: titilliumRegular.copyWith(color: ColorResources.getHint(context),
                      fontSize: Dimensions.FONT_SIZE_DEFAULT),):SizedBox(),
                refundModel.product != null?
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE,):SizedBox(),

                Text('${getTranslated('refund_no', context)}# ${refundModel.id.toString()}',
                  style: titilliumBold.copyWith(color: ColorResources.getTextColor(context),
                      fontSize: Dimensions.FONT_SIZE_LARGE),),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),

                Text('${getTranslated('requested_on', context)}:',
                    style: titilliumRegular.copyWith(color: Theme.of(context).hintColor)),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),

                Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(refundModel.createdAt)),
                    style: titilliumRegular.copyWith(color: Theme.of(context).hintColor)),
              ],),),




              Column(children: [
                refundModel.product != null?
                Container(
                      width: Dimensions.image_size, height: Dimensions.image_size,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_SMALL),),
                        child: FadeInImage.assetNetwork(placeholder: Images.placeholder_image,
                          image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.productThumbnailUrl}/'
                              '${refundModel.product.thumbnail}',
                          width: 50, height: 50, fit: BoxFit.cover,
                          imageErrorBuilder: (c,o,x)=> Image.asset(Images.placeholder_image),),
                      ) ,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_SMALL))),
                    ):SizedBox(),
                Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                    child: Text('${getTranslated('view_details', context)}',
                              style: titilliumRegular.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: ColorResources.getPrimary(context),
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT)),),


                  Container(width: Dimensions.ICON_SIZE_DEFAULT,height: Dimensions.ICON_SIZE_DEFAULT,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_LARGE),
                          color: Theme.of(context).primaryColor),
                      child: Icon(Icons.arrow_forward_outlined, color: Theme.of(context).cardColor,
                        size: Dimensions.ICON_SIZE_SMALL,))
                ],
                )],)
            ],
            ):SizedBox(),
          ),
          refundModel != null && refundModel.product != null?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
            child: CustomDivider(),
          ):SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
