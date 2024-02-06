import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:eamar_seller_app/localization/language_constrants.dart';
import 'package:eamar_seller_app/provider/auth_provider.dart';
import 'package:eamar_seller_app/provider/theme_provider.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/images.dart';
import 'package:eamar_seller_app/utill/styles.dart';
import 'package:eamar_seller_app/view/screens/auth/login_screen.dart';
import 'package:eamar_seller_app/view/screens/splash/widget/splash_painter.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).isActiveRememberMe;
    double space = (MediaQuery.of(context).size.height / 2) - 270;
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          //   color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : Theme.of(context).cardColor,
          //   child: CustomPaint(
          //     painter: SplashPainter(),
          //   ),
          // ),

          Consumer<AuthProvider>(
            builder: (context, auth, child) => SafeArea(
              child: ListView(
                children: [
                  SizedBox(height: space),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    child: Container(
                        width: 200,
                        height: 200,
                        child: Image.asset(Images.logo_with_app_name,
                            color: Theme.of(context).primaryColor)),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  Center(
                      child: Text(
                    getTranslated('login', context),
                    style: titilliumBold.copyWith(
                        fontSize: Dimensions.FONT_SIZE_OVER_LARGE),
                  )),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  SignInWidget()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
