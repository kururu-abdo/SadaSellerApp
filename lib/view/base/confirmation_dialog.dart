import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/localization/language_constrants.dart';
import 'package:eamar_seller_app/provider/shipping_provider.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/styles.dart';

import 'custom_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final String? icon;
  final String? title;
  final String? description;
  final Function? onYesPressed;
  final bool? isLogOut;
  final bool? refund;
  final TextEditingController? note;
  ConfirmationDialog(
      {@required this.icon,
      this.title,
      @required this.description,
      @required this.onYesPressed,
      this.isLogOut = false,
      this.refund = false,
      this.note});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
        insetPadding: EdgeInsets.all(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: SizedBox(
          width: 500,
          child: Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  child: Image.asset(icon!, width: 50, height: 50),
                ),
                title != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_LARGE),
                        child: Text(
                          title!,
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                              color: Colors.red),
                        ),
                      )
                    : SizedBox(),
                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  child: Column(
                    children: [
                      Text(description!,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE),
                          textAlign: TextAlign.center),
                      refund!
                          ? TextFormField(
                              controller: note,
                              decoration: InputDecoration(
                                hintText: getTranslated('note', context),
                              ),
                              textAlign: TextAlign.center,
                            )
                          : SizedBox()
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                Consumer<ShippingProvider>(
                    builder: (context, shippingProvider, child) {
                  return !shippingProvider.isLoading!
                      ? Row(children: [
                          Expanded(
                              child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: CustomButton(
                              btnTxt: getTranslated('no', context),
                              backgroundColor: ColorResources.getHint(context),
                              isColor: true,
                            ),
                          )),
                          SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                          Expanded(
                              child: CustomButton(
                            btnTxt: getTranslated('yes', context),
                            onTap: () => onYesPressed!(),
                          )),
                        ])
                      : Center(child: CircularProgressIndicator());
                }),
              ])),
        ));
  }
}
