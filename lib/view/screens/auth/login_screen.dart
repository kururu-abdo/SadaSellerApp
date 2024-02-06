import 'package:flutter/material.dart';
import 'package:eamar_seller_app/view/base/textfeild/phone_field.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/helper/email_checker.dart';
import 'package:eamar_seller_app/localization/language_constrants.dart';
import 'package:eamar_seller_app/provider/auth_provider.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/phone_number_utils.dart';
import 'package:eamar_seller_app/utill/styles.dart';
import 'package:eamar_seller_app/view/base/custom_button.dart';
import 'package:eamar_seller_app/view/base/custom_snackbar.dart';
import 'package:eamar_seller_app/view/base/textfeild/custom_pass_textfeild.dart';
import 'package:eamar_seller_app/view/base/textfeild/custom_text_feild.dart';
import 'package:eamar_seller_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:eamar_seller_app/view/screens/forgetPassword/forget_password_screen.dart';
import 'package:eamar_seller_app/view/screens/forgetPassword/widget/code_picker_widget.dart';
import 'package:validate_ksa_number/validate_ksa_number.dart';

class SignInWidget extends StatefulWidget {
  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController!.text =
        Provider.of<AuthProvider>(context, listen: false).getUserEmail()!;
    _passwordController!.text =
        Provider.of<AuthProvider>(context, listen: false).getUserPassword()!;
  }

  String _countryDialCode = "+966";

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).isActiveRememberMe;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => Form(
        key: _formKeyLogin,
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_LARGE),
          child: Column(
            children: [
              // for Email
              // Container(
              //   margin: EdgeInsets.only(
              //       left: Dimensions.MARGIN_SIZE_LARGE,
              //       right: Dimensions.MARGIN_SIZE_LARGE,
              //       bottom: Dimensions.MARGIN_SIZE_SMALL),
              //   child: Row(
              //     children: [
              //       CodePickerWidget(
              //         onChanged: (CountryCode countryCode) {
              //           _countryDialCode = countryCode.dialCode;
              //         },
              //         initialSelection: _countryDialCode,
              //         favorite: [_countryDialCode],
              //         showDropDownButton: true,
              //         padding: EdgeInsets.zero,
              //         showFlagMain: true,
              //         textStyle: TextStyle(
              //             color: Theme.of(context).textTheme.headline1.color),
              //       ),
              //       Expanded(
              //           child: CustomTextField(
              //         hintText: getTranslated('number_hint', context),

              //         focusNode: _emailFocus,
              //         nextNode: _passwordFocus,
              //         controller: _emailController,
              //         isPhoneNumber: true,
              //         textInputAction: TextInputAction.next,
              //         textInputType: TextInputType.phone,
              //       )),
              //     ],
              //   ),
              // ),

              Container(
                margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_LARGE,
                    right: Dimensions.MARGIN_SIZE_LARGE,
                    bottom: Dimensions.MARGIN_SIZE_SMALL),
                child: PhoneField(
                  hintText: getTranslated('ENTER_MOBILE_NUMBER', context),
                  focusNode: _emailFocus,
                  nextNode: _passwordFocus,
                  controller: _emailController,
                  isPhoneNumber: true,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.phone,
                ),
              ),

              // Container(margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_LARGE, right: Dimensions.PADDING_SIZE_LARGE,
              //         bottom: Dimensions.PADDING_SIZE_SMALL),
              //     child: CustomTextField(
              //       border: true,
              //       hintText: getTranslated('enter_email_address', context),
              //       focusNode: _emailFocus,
              //       nextNode: _passwordFocus,
              //       textInputType: TextInputType.emailAddress,
              //       controller: _emailController,
              //     )),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              Container(
                  margin: EdgeInsets.only(
                      left: Dimensions.PADDING_SIZE_LARGE,
                      right: Dimensions.PADDING_SIZE_LARGE,
                      bottom: Dimensions.PADDING_SIZE_DEFAULT),
                  child: CustomPasswordTextField(
                    border: true,
                    hintTxt: getTranslated('password_hint', context),
                    textInputAction: TextInputAction.done,
                    focusNode: _passwordFocus,
                    controller: _passwordController,
                  )),

              Container(
                margin: EdgeInsets.only(
                    left: 24, right: Dimensions.PADDING_SIZE_LARGE),
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => InkWell(
                    onTap: () => authProvider.toggleRememberMe(),
                    child: Row(
                      children: [
                        Container(
                          width: Dimensions.ICON_SIZE_DEFAULT,
                          height: Dimensions.ICON_SIZE_DEFAULT,
                          decoration: BoxDecoration(
                              color: authProvider.isActiveRememberMe
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.1)
                                  : ColorResources.WHITE,
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(3)),
                          child: authProvider.isActiveRememberMe
                              ? Icon(Icons.done,
                                  color: authProvider.isActiveRememberMe
                                      ? Theme.of(context).primaryColor
                                      : ColorResources.WHITE,
                                  size: Dimensions.ICON_SIZE_SMALL)
                              : SizedBox.shrink(),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Text(
                          getTranslated('remember_me', context),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                  color: ColorResources.getHintColor(context)),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ForgetPasswordScreen())),
                          child: Text(getTranslated('FORGET_PASSWORD', context),
                              style: robotoRegular.copyWith(
                                  color: Theme.of(context).primaryColor)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(
                    left: Dimensions.PADDING_SIZE_LARGE,
                    right: Dimensions.PADDING_SIZE_LARGE,
                    top: Dimensions.PADDING_SIZE_LARGE,
                    bottom: Dimensions.PADDING_SIZE_DEFAULT),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    authProvider.loginErrorMessage.length > 0
                        ? CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 5)
                        : SizedBox.shrink(),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        authProvider.loginErrorMessage ?? "",
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                  color: Theme.of(context).primaryColor,
                                ),
                      ),
                    )
                  ],
                ),
              ),

              !authProvider.isLoading
                  ? Container(
                      margin: EdgeInsets.only(
                          left: Dimensions.PADDING_SIZE_LARGE,
                          right: Dimensions.PADDING_SIZE_LARGE,
                          bottom: Dimensions.PADDING_SIZE_DEFAULT),
                      child: CustomButton(
                        backgroundColor: Theme.of(context).primaryColor,
                        btnTxt: getTranslated('login', context),
                        onTap: () async {
                          var ksaValidate = KsaNumber();

                          String _email = _countryDialCode.trim() +
                              PhoneNumberUtils.getPhoneNumberFromInputs(
                                  _emailController!.text.trim());

                          String _password = _passwordController!.text.trim();
                          if (_email.isEmpty) {
                            showCustomSnackBar(
                                getTranslated(
                                    'PHONE_MUST_BE_REQUIRED', context),
                                context);
                          } else if (!ksaValidate.isValidNumber(_email)) {
                            showCustomSnackBar(
                                getTranslated('enter_valid_phone', context),
                                context);
                          } else if (_password.isEmpty) {
                            showCustomSnackBar(
                                getTranslated('enter_password', context),
                                context);
                          } else if (_password.length < 6) {
                            showCustomSnackBar(
                                getTranslated('password_should_be', context),
                                context);
                          } else {
                            authProvider
                                .login(
                                    emailAddress: _email, password: _password)
                                .then((status) async {
                              if (status.isSuccess) {
                                if (authProvider.isActiveRememberMe) {
                                  authProvider.saveUserNumberAndPassword(
                                      _emailController!.text.trim(), _password);
                                } else {
                                  authProvider.clearUserEmailAndPassword();
                                }
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (_) => DashboardScreen()));
                              }
                            });
                          }
                        },
                      ))
                  : Center(
                      child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
