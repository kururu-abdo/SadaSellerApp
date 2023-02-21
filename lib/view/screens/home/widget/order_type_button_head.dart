import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/data/model/response/order_model.dart';
import 'package:eamar_seller_app/provider/localization_provider.dart';
import 'package:eamar_seller_app/provider/order_provider.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/styles.dart';

class OrderTypeButtonHead extends StatelessWidget {
  final String text;
  final String subText;
  final Color color;
  final int index;
  final Function callback;
  final List<OrderModel> orderList;
  OrderTypeButtonHead({@required this.text,this.subText,this.color ,@required this.index, @required this.callback, @required this.orderList});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<OrderProvider>(context, listen: false).setIndex(index);
        callback();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),),
        color: color,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE),
              child: Container(alignment: Alignment.center,
                child: Center(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(orderList.length.toString(),
                          style: robotoBold.copyWith(color: ColorResources.getWhite(context),
                              fontSize: Dimensions.FONT_SIZE_HEADER_LARGE)),
  Expanded(
    child: Text(text, 
                          overflow: TextOverflow.visible,
                            
                            style: robotoRegular.copyWith(color: ColorResources.getWhite(context),
                                fontSize: Dimensions.FONT_SIZE_LARGE)),
  ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(text, 
                      //   overflow: TextOverflow.ellipsis,
                          
                      //     style: robotoRegular.copyWith(color: ColorResources.getWhite(context),
                      //         fontSize: Dimensions.FONT_SIZE_LARGE)),
                      //     SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      //     Text(subText, style: robotoRegular.copyWith(color: ColorResources.getWhite(context))),
                      //   ],
                      // ),



                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Provider.of<LocalizationProvider>(context,listen: false).isLtr?SizedBox.shrink():Spacer(),
                Container(width: MediaQuery.of(context).size.width/3,height:100,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(.10),
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(100))
                  ),),
                Provider.of<LocalizationProvider>(context,listen: false).isLtr?Spacer():SizedBox.shrink(),
              ],
            )


          ],
        ),
      ),
    );
  }
}
