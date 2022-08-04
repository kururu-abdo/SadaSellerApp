import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/bank_info_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/no_data_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/bank_info/bank_editing_screen.dart';

class BankInfoScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Provider.of<BankInfoProvider>(context, listen: false).getBankInfo(context);

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(title: getTranslated('bank_info', context)),
      body: SafeArea(
        child: Consumer<BankInfoProvider>(
          builder: (context, bankProvider, child) => bankProvider.bankInfo != null ?
          Stack(
            children: [
              Container(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,vertical: Dimensions.PADDING_SIZE_BUTTON),

                child: Column( mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(width: Dimensions.ICON_SIZE_MEDIUM, height: Dimensions.ICON_SIZE_MEDIUM,
                          child: Image.asset(Images.bank,color: ColorResources.titleColor(context),)),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Text(
                        '${getTranslated('bank_name', context)} : \t',
                        style: titilliumRegular.copyWith(color: ColorResources.titleColor(context),
                            fontSize: Dimensions.FONT_SIZE_LARGE),
                      ),
                      Text(
                        '${bankProvider.bankInfo.bankName ?? getTranslated('no_data_found', context)}',
                        style: robotoTitleRegular.copyWith(color: ColorResources.getHint(context),
                            fontSize: Dimensions.FONT_SIZE_DEFAULT),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                    Row(children: [
                      Container(width: Dimensions.ICON_SIZE_MEDIUM, height: Dimensions.ICON_SIZE_MEDIUM,
                          child: Image.asset(Images.branch, color: ColorResources.titleColor(context))),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Text(
                        '${getTranslated('branch_name', context)} : \t',
                        style: titilliumRegular.copyWith(color: ColorResources.titleColor(context),
                            fontSize: Dimensions.FONT_SIZE_LARGE),
                      ),
                      Text(
                        '${bankProvider.bankInfo.branch ?? getTranslated('no_data_found', context)}',
                        style: robotoTitleRegular.copyWith(color: ColorResources.getHint(context),
                            fontSize: Dimensions.FONT_SIZE_DEFAULT),
                        textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                    Row(children: [
                      Container(width: Dimensions.ICON_SIZE_MEDIUM, height: Dimensions.ICON_SIZE_MEDIUM,
                          child: Image.asset(Images.holder,color: ColorResources.titleColor(context))),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Text(
                        '${getTranslated('holder_name', context)} : \t',
                        style: titilliumRegular.copyWith(color: ColorResources.titleColor(context),
                            fontSize: Dimensions.FONT_SIZE_LARGE),
                      ),
                      Text(
                        '${bankProvider.bankInfo.holderName ?? getTranslated('no_data_found', context)}',
                        style: robotoTitleRegular.copyWith(color: ColorResources.getHint(context),
                            fontSize: Dimensions.FONT_SIZE_DEFAULT),
                        textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                    Row(children: [
                      Container(width: Dimensions.ICON_SIZE_MEDIUM, height: Dimensions.ICON_SIZE_MEDIUM,
                          child: Image.asset(Images.credit_card, color: ColorResources.titleColor(context))),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Text(
                        '${getTranslated('account_no', context)} : \t',
                        style: titilliumRegular.copyWith(color: ColorResources.titleColor(context),
                            fontSize: Dimensions.FONT_SIZE_LARGE),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${bankProvider.bankInfo.accountNo ?? getTranslated('no_data_found', context)}',
                        style: robotoTitleRegular.copyWith(color: ColorResources.getHint(context),
                            fontSize: Dimensions.FONT_SIZE_DEFAULT),
                        textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  ],
                ),
              ),
              Positioned(top: 10,right: 10,
                child: InkWell(
                  onTap: ()=>Navigator.push(context,
                      MaterialPageRoute(builder: (_) => BankEditingScreen(sellerModel: bankProvider.bankInfo))),
                  child: Container(width: 100,
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,
                        vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      border: Border.all(width: 1, color: Theme.of(context).primaryColor)
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Container(width: Dimensions.ICON_SIZE_SMALL,
                          child: Image.asset(Images.edit,color: Theme.of(context).primaryColor,)),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                      Text('${getTranslated('edit', context)}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Theme.of(context).primaryColor),)
                    ],),
                  ),
                ),
              ),
            ],
          ) : NoDataScreen(),
        ),
      ),
    );
  }
}