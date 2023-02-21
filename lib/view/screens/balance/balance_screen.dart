import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/localization/language_constrants.dart';
import 'package:eamar_seller_app/provider/order_provider.dart';
import 'package:eamar_seller_app/provider/theme_provider.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/styles.dart';
import 'package:eamar_seller_app/view/base/custom_app_bar.dart';
import 'package:eamar_seller_app/view/base/custom_button.dart';
import 'package:eamar_seller_app/view/base/custom_divider.dart';
import 'package:eamar_seller_app/view/screens/balance/widget/complete_withdraw_dialog.dart';


class BalanceScreen extends StatefulWidget {
  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {

  FocusNode _amountFocus = FocusNode();
  TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();

  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: getTranslated('balance_screen', context)),
      backgroundColor: ColorResources.getHomeBg(context),

      body: SafeArea(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [

              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(30),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorResources.getBottomSheetColor(context),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                ),
                child: Column( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getTranslated('current_balance', context), style: titilliumSemiBold.copyWith(color: ColorResources.getTextColor(context))),
                    Text('\$55.75', style: titilliumBold.copyWith(color: ColorResources.getPrimary(context), fontSize: 18)),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorResources.getBottomSheetColor(context),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                ),
                child: Column( mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SizedBox(height: 10),

                    Text(getTranslated('payment_method', context), style: titilliumSemiBold.copyWith( fontSize: 12, color: ColorResources.getTextColor(context))),
                    SizedBox(height: 10),

                    Consumer<OrderProvider>(
                      builder: (context, orderProvider, child) => SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: orderProvider.paymentImageList.length,
                          itemBuilder: (context,index) =>  InkWell(
                            onTap: (){
                              Provider.of<OrderProvider>(context,listen: false).setPaymentMethodIndex(index);
                            },
                            child: Stack(clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  alignment: Alignment.center,
                                  decoration:  Provider.of<OrderProvider>(context).paymentMethodIndex==index ?
                                  BoxDecoration(
                                    color: ColorResources.getHomeBg(context),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(
                                        color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200],
                                        spreadRadius: 0.5,
                                        blurRadius: .3, offset: Offset(0,2))]
                                  ) : BoxDecoration(
                                    color: ColorResources.getHomeBg(context),
                                    border: Border.all(width: 1, color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 300]),
                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  child: Image.asset(orderProvider.paymentImageList[index],
                                      height: 40,width: 40,
                                  ),

                                  /*Image.asset(paymentList.paymentImageList[index], height: 80, width: 50,),*/
                                ),
                                Provider.of<OrderProvider>(context).paymentMethodIndex==index ?
                                Positioned( top: 5,left: 5,
                                child: Icon(Icons.check_circle, color: Colors.green)) : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),


                    SizedBox(height: 15),
                    Text(getTranslated('enter_amount', context), style: titilliumSemiBold.copyWith(color: ColorResources.getTextColor(context), fontSize: 16)),

                    SizedBox(height: 15),
                    TextField(
                      controller: _amountController,
                      focusNode: _amountFocus,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0),
                          prefix: Text('\$')),
                      textAlign: TextAlign.center,
                      style: TextStyle( fontSize: 16),
                    ),

                   CustomDivider(height: 1, color: ColorResources.GREY,),

                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: CustomButton(btnTxt: getTranslated('withdraw', context),
                  backgroundColor: ColorResources.WHITE,
                  onTap: (){

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          child: CompleteOrderWidget(),
                        );
                      });
                },),
              )
            ],
          )
      ),
    );
  }
}
