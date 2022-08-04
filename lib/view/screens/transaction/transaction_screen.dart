import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/transaction_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/no_data_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/transaction/widget/transaction_widget.dart';

class TransactionScreen extends StatefulWidget {


  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {


  void _loadData(BuildContext context){
    Provider.of<TransactionProvider>(context, listen: false).getTransactionList(context);
    Provider.of<TransactionProvider>(context, listen: false).initMonthTypeList();
    Provider.of<TransactionProvider>(context, listen: false).initYearList();
  }

  double filterHeight = 45;




  void initState() {
    super.initState();
    _loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('transaction_screen', context)),
      body: SafeArea(
        child: Consumer<TransactionProvider>(
          builder: (context, transactionProvider, child) {
            print('==Transaction===>${transactionProvider.yearList.length}');
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE),
                  child: Container(height: 120,width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            Text('${getTranslated('select_year', context)}',
                              style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,color: ColorResources.titleColor(context)),),

                            Text('${getTranslated('select_month', context)}',
                              style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: ColorResources.titleColor(context)),),
                            SizedBox(width: MediaQuery.of(context).size.width/4,)
                          ],),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_MEDIUM),
                          child: Row(children: [
                            Expanded(
                              flex:3,
                              child: Padding(padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                                child: Container(
                                  height: filterHeight,
                                  padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    border: Border.all(width: .8,color: Theme.of(context).hintColor),
                                  ),
                                  child: DropdownButton<int>(
                                    value: transactionProvider.yearIndex,
                                    items: transactionProvider.yearIds.map((int value) {
                                      return DropdownMenuItem<int>(
                                        value: transactionProvider.yearIds.indexOf(value),
                                        child: Text( value != 0?
                                        transactionProvider.yearList[(transactionProvider.yearIds.indexOf(value) -1)].year:
                                        getTranslated('select', context),style: robotoRegular),);}).toList(),
                                    onChanged: (int value) {
                                      transactionProvider.setYearIndex(value, true);
                                      },
                                    isExpanded: true, underline: SizedBox(),),
                                ),
                              ),
                            ),
                            Expanded(
                              flex:5,
                              child: Padding(padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                child: Container(
                                  height: filterHeight,
                                  padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    border: Border.all(width: .8,color: Theme.of(context).hintColor),
                                  ),
                                  child: DropdownButton<int>(
                                    value: transactionProvider.monthIndex,
                                    items: transactionProvider.monthIds.map((int value) {
                                      return DropdownMenuItem<int>(
                                        value: transactionProvider.monthIds.indexOf(value),
                                        child: Text( value != 0?
                                        transactionProvider.monthItemList[(transactionProvider.monthIds.indexOf(value) -1)].month:
                                        getTranslated('select', context),style: robotoRegular,),);}).toList(),
                                    onChanged: (int value) {
                                      transactionProvider.setMonthIndex(value, true);
                                      },
                                    isExpanded: true, underline: SizedBox(),),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: ()=>transactionProvider.filterTransaction(transactionProvider.monthIndex-1,
                                  int.parse(transactionProvider.yearList[transactionProvider.yearIndex-1].year),context),
                              child: Container(width: MediaQuery.of(context).size.width/4,
                                height: filterHeight,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL)
                                ),
                                child: Center(child: Text(getTranslated('filter', context),
                                  style: titilliumRegular.copyWith(color: Theme.of(context).cardColor,
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT),)),),
                            )
                  ],),
                        ),
                      ],
                    ),),
                ),





                Text('${getTranslated('transaction_length', context)}',
                  style: titilliumBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),),
                Expanded(child: transactionProvider.transactionList !=null ? transactionProvider.transactionList.length > 0 ?
                ListView.builder(itemCount: transactionProvider.transactionList.length,
                    itemBuilder: (context, index) => TransactionWidget(
                        transactionModel: transactionProvider.transactionList[index])):
                NoDataScreen() : Center(child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
