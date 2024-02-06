import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/helper/network_info.dart';
import 'package:eamar_seller_app/provider/auth_provider.dart';
import 'package:eamar_seller_app/provider/splash_provider.dart';
import 'package:eamar_seller_app/provider/theme_provider.dart';
import 'package:eamar_seller_app/utill/app_constants.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/images.dart';
import 'package:eamar_seller_app/utill/styles.dart';
import 'package:eamar_seller_app/view/screens/auth/auth_screen.dart';
import 'package:eamar_seller_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:eamar_seller_app/view/screens/splash/widget/splash_painter.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    NetworkInfo.checkConnectivity(context);
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(context)
        .then((bool isSuccess) {
      if (isSuccess) {
        Provider.of<SplashProvider>(context, listen: false)
            .initShippingTypeList(context, '');
        Timer(Duration(seconds: 1), () {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            Provider.of<AuthProvider>(context, listen: false)
                .updateToken(context);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => DashboardScreen()));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => AuthScreen()));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      clipBehavior: Clip.none,
      children: [
        // Container(
        //   width: MediaQuery.of(context).size.width,
        //   height: MediaQuery.of(context).size.height,
        //   color: Colors.white,
        // //  color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : ColorResources.getPrimary(context),
        //   child: CustomPaint(
        //     painter: SplashPainter(),
        //   ),
        // ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Images.logo,
                // height: 100.0, width: 100.0,
                //color: Theme.of(context).highlightColor
                //  fit: BoxFit.scaleDown
              ),
              SizedBox(
                height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
              ),
              Text(
                AppConstants.APP_NAME,
                style: titilliumBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_WALLET,
                    color: Provider.of<ThemeProvider>(context).darkTheme
                        ? Colors.white
                        : ColorResources.BLACK),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
