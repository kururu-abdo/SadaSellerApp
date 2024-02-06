import 'package:flutter/material.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/images.dart';
import 'package:eamar_seller_app/utill/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? isBackButtonExist;
  final Function? onBackPressed;
  CustomAppBar(
      {@required this.title,
      this.isBackButtonExist = true,
      this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(double.infinity, 80),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(.10),
            offset: Offset(0, 2.0),
            blurRadius: 4.0,
          )
        ]),
        child: AppBar(
          shadowColor: Theme.of(context).primaryColor.withOpacity(.5),
          titleSpacing: 0,
          title: Text(title!,
              style: titilliumSemiBold.copyWith(
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                  color: Theme.of(context).textTheme.bodyText1!.color)),
          centerTitle: false,
          leading: isBackButtonExist!
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  onPressed: () => onBackPressed != null
                      ? onBackPressed!()
                      : Navigator.pop(context))
              : IconButton(
                  icon: Image.asset(
                    Images.logo,
                    color: Theme.of(context).primaryColor,
                    scale: 5,
                  ),
                  onPressed: () {},
                ),
          backgroundColor: Theme.of(context).highlightColor,
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}
