import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/localization_provider.dart';
import 'package:sixvalley_vendor_app/provider/shipping_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class LanguageDialog extends StatelessWidget {
  final bool isCurrency;
  final bool isShipping;
  LanguageDialog({this.isCurrency = true, this.isShipping});

  @override
  Widget build(BuildContext context) {
    int index;
    if(isCurrency) {
      index = Provider.of<SplashProvider>(context, listen: false).currencyIndex;
    }else if(isShipping) {
      index = Provider.of<SplashProvider>(context, listen: false).shippingIndex;
    }
    else {
      index = Provider.of<LocalizationProvider>(context, listen: false).languageIndex;
    }

    return Dialog(
      backgroundColor: Theme.of(context).highlightColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          child: Text(isCurrency ? getTranslated('currency', context) :isShipping? getTranslated('shipping', context):getTranslated('language', context), style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        ),

        SizedBox(height: 150, child: Consumer<SplashProvider>(
          builder: (context, splash, child) {
            List<String> _valueList = [];
            if(isCurrency) {
              splash.configModel.currencyList.forEach((currency) => _valueList.add(currency.name));
            }
            else if(isShipping) {
              splash.shippingTypeList.forEach((shipping) => _valueList.add(getTranslated(shipping, context)));
            }
            else {
              AppConstants.languages.forEach((language) => _valueList.add(language.languageName));
            }
            return CupertinoPicker(
              itemExtent: 40,
              useMagnifier: false,
              magnification: 1,
              scrollController: FixedExtentScrollController(initialItem: index),
              onSelectedItemChanged: (int i) {
                index = i;
              },
              children: _valueList.map((value) {
                return Center(child: Text(value, style: robotoRegular.copyWith(color: ColorResources.titleColor(context))));
              }).toList(),
            );
          },
        )),

        Divider(height: Dimensions.PADDING_SIZE_EXTRA_SMALL, color: ColorResources.HINT_TEXT_COLOR),
        Row(children: [
          Expanded(child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(getTranslated('no', context), style: robotoRegular.copyWith(color: ColorResources.mainCardFourColor(context))),
          )),
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: VerticalDivider(width: Dimensions.PADDING_SIZE_EXTRA_SMALL, color: Theme.of(context).hintColor),
          ),
          Expanded(child: TextButton(
            onPressed: () {
              if(isCurrency) {
                Provider.of<SplashProvider>(context, listen: false).setCurrency(index);
              }
              else if(isShipping) {
                Provider.of<SplashProvider>(context, listen: false).setShippingType(index);
                String type;
                if(index==0){
                  type =  Provider.of<SplashProvider>(context, listen: false).shippingTypeList[0];
                }else if(index == 1){
                  type =  Provider.of<SplashProvider>(context, listen: false).shippingTypeList[1];
                }else if(index ==2){
                  type =  Provider.of<SplashProvider>(context, listen: false).shippingTypeList[2];
                }
                Provider.of<ShippingProvider>(context, listen: false).setShippingMethodType(context,  type);
                print('=======> selected shipping type ====>$type');
              }
              else {
                Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                  AppConstants.languages[index].languageCode,
                  AppConstants.languages[index].countryCode,
                ), index);
              }
              Navigator.pop(context);
            },
            child: Text(getTranslated('yes', context), style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
          )),
        ]),

      ]),
    );
  }
}