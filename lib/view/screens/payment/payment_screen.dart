
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_pass_textfeild.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';
import 'package:sixvalley_vendor_app/view/screens/dashboard/dashboard_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {

  FocusNode _cardNumber;
  FocusNode _passwordFocus;
  FocusNode _cvvFocus;
  FocusNode _expiredFocus;
  TextEditingController _cardController;
  TextEditingController _passwordController;
  TextEditingController _cvvController;
  TextEditingController _expiredController;

  @override
  void initState() {
    super.initState();
    _cardController = TextEditingController();
    _passwordController = TextEditingController();
    _cvvController = TextEditingController();
    _expiredController = TextEditingController();

  }

  @override
  void dispose() {
    _cardController.dispose();
    _passwordController.dispose();
    _cvvController.dispose();
    _expiredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: getTranslated('add_payment_method', context)),
      backgroundColor: ColorResources.getHomeBg(context),

      body: SafeArea(
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            children: [

              SizedBox(height: 20),
              Consumer<OrderProvider>(
                builder: (context, paymentList, child) => SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: paymentList.paymentImageList.length,
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

                            child: Image.asset(paymentList.paymentImageList[index],
                                height: 30,width: 30,),
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



              SizedBox(height: 20),
              Text(
                getTranslated('card_number', context),
                style:  titilliumRegular.copyWith(fontSize: Dimensions.PADDING_SIZE_DEFAULT, color: ColorResources.getHintColor(context),
                )),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              CustomTextField(
                hintText: getTranslated('card_hint', context),
                controller: _cardController,
                focusNode: _cardNumber,
                nextNode: _passwordFocus,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.number,
              ),


              SizedBox(height: 20),
              Text(
                getTranslated('password', context),
                style: titilliumRegular.copyWith(fontSize: Dimensions.PADDING_SIZE_DEFAULT, color: ColorResources.getHintColor(context),
                )),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              CustomPasswordTextField(
                hintTxt: getTranslated('password_hint', context),
                textInputAction: TextInputAction.next,
                focusNode: _passwordFocus,
                nextNode: _cvvFocus,
                controller: _passwordController,
              ),

              SizedBox(height: 20),
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    getTranslated('cvv', context),
                    style: titilliumRegular.copyWith(fontSize: Dimensions.PADDING_SIZE_DEFAULT, color: ColorResources.getHintColor(context),
                    )),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  CustomTextField(
                    hintText: getTranslated('password_hint', context),
                    controller: _cvvController,
                    focusNode: _cvvFocus,
                    nextNode: _expiredFocus,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.number,
                  ),

                ],)),

                SizedBox(width: 20),
                Expanded(child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    getTranslated('expired_date', context),
                    style: titilliumRegular.copyWith(fontSize: Dimensions.PADDING_SIZE_DEFAULT, color: ColorResources.getHintColor(context),
                    )),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  CustomTextField(
                    hintText: '04/21',
                    controller: _expiredController,
                    focusNode: _expiredFocus,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.number,
                  ),

                ],)),
              ],),


              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

              Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: CustomButton(btnTxt: getTranslated('add_card', context),
                  backgroundColor: ColorResources.WHITE,
                  onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>DashboardScreen()));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully Added'), backgroundColor: Colors.green,));
                },),
              )
            ],
          )
      ),
    );
  }
}

