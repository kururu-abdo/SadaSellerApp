import 'package:flutter/material.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/styles.dart';

class WalletCard extends StatelessWidget {
  final String? amount, title;
  final Color? color;
  const WalletCard({Key? key, this.amount, this.title, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
      ),
      color: color,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.width / 3.8,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(amount.toString(),
                      style: robotoBold.copyWith(
                          color: ColorResources.getWhite(context),
                          fontSize: Dimensions.FONT_SIZE_WALLET)),
                  Text(title!,
                      textAlign: TextAlign.center,
                      style: robotoRegular.copyWith(
                          color: ColorResources.getWhite(context),
                          fontSize: Dimensions.FONT_SIZE_LARGE)),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2.4,
            height: 100,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(.15),
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(100))),
          )
        ],
      ),
    );
  }
}
