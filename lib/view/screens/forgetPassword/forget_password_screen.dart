import 'dart:developer';

import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:joseeder_seller/utill/phone_number_utils.dart';
import 'package:joseeder_seller/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:joseeder_seller/localization/language_constrants.dart';
import 'package:joseeder_seller/provider/auth_provider.dart';
import 'package:joseeder_seller/provider/splash_provider.dart';
import 'package:joseeder_seller/provider/theme_provider.dart';
import 'package:joseeder_seller/utill/dimensions.dart';
import 'package:joseeder_seller/utill/images.dart';
import 'package:joseeder_seller/utill/styles.dart';
import 'package:joseeder_seller/view/base/custom_button.dart';
import 'package:joseeder_seller/view/base/custom_dialog.dart';
import 'package:joseeder_seller/view/base/textfeild/custom_text_feild.dart';
import 'package:joseeder_seller/view/screens/forgetPassword/widget/code_picker_widget.dart';
import 'package:joseeder_seller/view/screens/forgetPassword/widget/my_dialog.dart';
import 'package:joseeder_seller/view/screens/forgetPassword/widget/otp_verification_screen.dart';
import 'package:validate_ksa_number/validate_ksa_number.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _key = GlobalKey();
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _numberFocus = FocusNode();
  String _countryDialCode = '+966';

  @override
  void initState() {
    _countryDialCode = CountryCode.fromCountryCode(
        Provider.of<SplashProvider>(context, listen: false).configModel.countryCode).dialCode;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: _key,

      body: Container(
        decoration: BoxDecoration(
          image: Provider.of<ThemeProvider>(context).darkTheme ? null :
          DecorationImage(image: AssetImage(Images.background), fit: BoxFit.fill),
        ),


        child: Column(
          children: [

            SafeArea(child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(icon: Icon(Icons.arrow_back_ios_outlined),
                onPressed: () => Navigator.pop(context),
              ),
            )),

            Expanded(
              child: ListView(padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL), children: [

                Padding(
                  padding: EdgeInsets.all(50),
                  child: Image.asset(Images.logo_with_app_name, height: 150, width: 200),
                ),
                Text(getTranslated('FORGET_PASSWORD', context), style: robotoBold),


                Row(children: [
                  Expanded(flex: 1, child: Divider(thickness: 1,
                      color: Theme.of(context).primaryColor)),
                  Expanded(flex: 2, child: Divider(thickness: 0.2,
                      color: Theme.of(context).primaryColor)),
                ]),

                Provider.of<SplashProvider>(context,listen: false).configModel.forgetPasswordVerification == "phone"?
                Text(getTranslated('enter_phone_number_for_password_reset', context),
                    style: titilliumRegular.copyWith(color: Theme.of(context).hintColor,
                        fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)):
                Text(getTranslated('enter_email_for_password_reset', context),
                    style: titilliumRegular.copyWith(color: Theme.of(context).hintColor,
                        fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                // Provider.of<SplashProvider>(context,listen: false).configModel.forgetPasswordVerification == "phone"?
                // Row(children: [
                //   CodePickerWidget(
                //     onChanged: (CountryCode countryCode) {
                //       _countryDialCode = countryCode.dialCode;
                //     },
                //     initialSelection: _countryDialCode,
                //     favorite: [_countryDialCode],
                //     showDropDownButton: true,
                //     padding: EdgeInsets.zero,
                //     showFlagMain: true,
                //     textStyle: TextStyle(color: Theme.of(context).textTheme.headline1.color),
                //   ),


                //   Expanded(child: CustomTextField(
                //     hintText: getTranslated('number_hint', context),
                //     controller: _numberController,
                //     focusNode: _numberFocus,
                //     isPhoneNumber: true,
                //     textInputAction: TextInputAction.done,
                //     textInputType: TextInputType.phone,
                //   )),
                // ]) :

                // CustomTextField(
                //   controller: _controller,
                //   hintText: getTranslated('ENTER_YOUR_EMAIL', context),
                //   textInputAction: TextInputAction.done,
                //   textInputType: TextInputType.emailAddress,
                // ),







  Container(
            margin: EdgeInsets.only(
                left: Dimensions.MARGIN_SIZE_LARGE,
                right: Dimensions.MARGIN_SIZE_LARGE,
                bottom: Dimensions.MARGIN_SIZE_SMALL),
            child: Row(
              children: [
                CodePickerWidget(
                  onChanged: (CountryCode countryCode) {
                    _countryDialCode = countryCode.dialCode;
                  },
                  initialSelection: _countryDialCode,
                  favorite: [_countryDialCode],
                  showDropDownButton: true,
                  padding: EdgeInsets.zero,
                  showFlagMain: true,
                  textStyle: TextStyle(
                      color: Theme.of(context).textTheme.headline1.color),
                ),
                Expanded(
                    child: CustomTextField(
                  hintText: getTranslated('number_hint', context),
                  
                  // focusNode: _emailFocus,
                  nextNode: _numberFocus,
                  controller: _controller,
                  isPhoneNumber: true,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.phone,
                )),
              ],
            ),
          ),



                SizedBox(height: 100),


                Builder(
                  builder: (context) => !Provider.of<AuthProvider>(context).isLoading ?
                  CustomButton(
                    btnTxt: Provider.of<SplashProvider>(context,listen: false).configModel.forgetPasswordVerification == "phone"?
                    getTranslated('send_otp', context):getTranslated('send_email', context),
                    onTap: () {
                      String code;

log(_countryDialCode+_controller.text);
var _phone = _countryDialCode.trim()+PhoneNumberUtils.getPhoneNumberFromInputs(_controller.text.trim()).trim();
var ksaNumber =KsaNumber();
                      // if(Provider.of<SplashProvider>(context,listen: false).configModel.forgetPasswordVerification == "phone"){
                        if(_controller.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(getTranslated('PHONE_MUST_BE_REQUIRED', context)),
                                backgroundColor: Colors.red,)
                          );
                        }
                    else if (!ksaNumber.isValidNumber(_phone)) {
                      showCustomSnackBar(getTranslated('enter_valid_phone', context), context);
                    }
                        else{
                          // if(_countryDialCode.contains('+')){
                          //    code = _countryDialCode.replaceAll('+', '');
                          // }

                          Provider.of<AuthProvider>(context, listen: false).
                          forgetPassword(
                            
                            _phone.replaceAll('+', '').trim()
                          
                          // '6532001099'
                          
                          ).then((value) {
                            if(value.isSuccess) {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                  builder: (_) => VerificationScreen(
                                      _phone.trim()
                                      )),
                                      (route) => false);
                            }else {ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(getTranslated('input_valid_phone_number', context)),
                                    backgroundColor: Colors.red,)
                              );

                            }
                          }
                          
                          
                          );
                        }

                      // }else{
                      //   if(_controller.text.isEmpty) {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //         SnackBar(content: Text(getTranslated('EMAIL_MUST_BE_REQUIRED', context)),
                      //           backgroundColor: Colors.red,)
                      //     );
                      //   }
                      //   else {
                      //     Provider.of<AuthProvider>(context, listen: false).forgetPassword(_controller.text).then((value) {
                      //       if(value.isSuccess) {
                      //         FocusScopeNode currentFocus = FocusScope.of(context);
                      //         if (!currentFocus.hasPrimaryFocus) {
                      //           currentFocus.unfocus();
                      //         }
                      //         _controller.clear();

                      //         showAnimatedDialog(context, MyDialog(
                      //           icon: Icons.send,
                      //           title: getTranslated('sent', context),
                      //           description: getTranslated('recovery_link_sent', context),
                      //           rotateAngle: 5.5,
                      //         ), dismissible: false);
                      //       }else {
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //             SnackBar(content: Text(value.message),backgroundColor: Colors.red,)
                      //         );
                      //       }
                      //     });
                      //   }
                      // }


                    },
                  ) : Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

