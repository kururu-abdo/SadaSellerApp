
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/transaction_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_divider.dart';

class TransactionWidget extends StatelessWidget {
  final TransactionModel transactionModel;
  TransactionWidget({@required this.transactionModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Expanded(child: Column( mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,children: [
                      Text('${getTranslated('transaction_id', context)}# ${transactionModel.id}',
                        style: titilliumBold.copyWith(color: ColorResources.titleColor(context),
                            fontSize: Dimensions.FONT_SIZE_DEFAULT),),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

                        Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(transactionModel.createdAt)),
                          style: titilliumRegular.copyWith(color: ColorResources.getHint(context),
                              fontSize: Dimensions.FONT_SIZE_SMALL)),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

                        Text(PriceConverter.convertPrice(context, transactionModel.amount),
                          style: titilliumBold.copyWith(color: ColorResources.titleColor(context),
                              fontSize: Dimensions.FONT_SIZE_DEFAULT),),


                      ]),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                    child: Container(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,
                        vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE),
                      color: transactionModel.approved == 1 ?
                      Colors.green.withOpacity(.10) : transactionModel.approved == 2 ?
                      Colors.red.withOpacity(.10) : Theme.of(context).primaryColor.withOpacity(.10),),
                      child: Text(getTranslated(transactionModel.approved == 2 ?
                      'denied' : transactionModel.approved == 1 ? 'approved' : 'pending', context),
                        style: titilliumRegular.copyWith(color: transactionModel.approved == 1 ?
                        Colors.green : transactionModel.approved == 2 ?
                        Colors.red : Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_DEFAULT,),
                      ),
                    ),
                  ),

                ]),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                left: Dimensions.PADDING_SIZE_SMALL, right: Dimensions.PADDING_SIZE_SMALL),
            child: CustomDivider(),
          ),

        ],
      ),
    );
  }
}
