import 'package:flutter/material.dart';
import 'package:joseeder_seller/localization/language_constrants.dart';
import 'package:joseeder_seller/utill/dimensions.dart';
import 'package:joseeder_seller/utill/images.dart';
import 'package:joseeder_seller/utill/styles.dart';

class NoDataScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(Images.no_data, width: 150, height: 150),
          Text(
            getTranslated('nothing_found', context),
            style: titilliumBold.copyWith(color: Theme.of(context).primaryColor, fontSize: MediaQuery.of(context).size.height*0.023),
            textAlign: TextAlign.center,
          ),

        ]),
      ),
    );
  }
}
