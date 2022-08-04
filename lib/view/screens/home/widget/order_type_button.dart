import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class OrderTypeButton extends StatelessWidget {
  final String text;
  final String icon;
  final int index;
  final Color color;
  final Function callback;
  final List<OrderModel> orderList;
  OrderTypeButton({@required this.text,this.icon ,@required this.index, @required this.callback, @required this.orderList, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<OrderProvider>(context, listen: false).setIndex(index);
        callback();},

      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,

            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical : Dimensions.PADDING_SIZE_SMALL,
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: Dimensions.ICON_SIZE_LARGE,
                      child: Image.asset(icon)),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Text(text, style: robotoRegular.copyWith(color: ColorResources.getTextColor(context))),

                  Spacer(),
                  Container(decoration: BoxDecoration(
                      color: color.withOpacity(.10),
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_LARGE)
                    ),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,
                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Text(orderList.length.toString(),
                          style: robotoRegular.copyWith(color : color)),
                    ),
                  )


                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal : Dimensions.PADDING_SIZE_EXTRA_LARGE),
            child: Divider(thickness: 1,height: 1,),
          ),
        ],
      ),
    );
  }
}
