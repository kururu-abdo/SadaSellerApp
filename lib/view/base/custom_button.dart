import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/provider/theme_provider.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/styles.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String btnTxt;
  final bool isColor;
  final Color backgroundColor;
  CustomButton({this.onTap, @required this.btnTxt, this.backgroundColor, this.isColor = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(padding: EdgeInsets.all(0),
        backgroundColor: isColor? backgroundColor : onTap == null ? ColorResources.getGrey(context) : backgroundColor != null ?
        backgroundColor : Theme.of(context).primaryColor,
      ),
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1))],
            gradient: (Provider.of<ThemeProvider>(context).darkTheme || onTap == null) ? null : LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
            ]),

            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL)),
        child: Text(btnTxt,
            style: titilliumSemiBold.copyWith(
              fontSize: Dimensions.FONT_SIZE_LARGE,
              color: Theme.of(context).highlightColor,
            )),
      ),
    );
  }
}
