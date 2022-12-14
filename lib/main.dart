import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:joseeder_seller/localization/app_localization.dart';
import 'package:joseeder_seller/provider/auth_provider.dart';
import 'package:joseeder_seller/provider/business_provider.dart';
import 'package:joseeder_seller/provider/chat_provider.dart';
import 'package:joseeder_seller/provider/delivery_man_provider.dart';
import 'package:joseeder_seller/provider/language_provider.dart';
import 'package:joseeder_seller/provider/localization_provider.dart';
import 'package:joseeder_seller/provider/order_provider.dart';
import 'package:joseeder_seller/provider/product_provider.dart';
import 'package:joseeder_seller/provider/product_review_provider.dart';
import 'package:joseeder_seller/provider/profile_provider.dart';
import 'package:joseeder_seller/provider/refund_provider.dart';
import 'package:joseeder_seller/provider/restaurant_provider.dart';
import 'package:joseeder_seller/provider/shipping_provider.dart';
import 'package:joseeder_seller/provider/shop_info_provider.dart';
import 'package:joseeder_seller/provider/splash_provider.dart';
import 'package:joseeder_seller/provider/theme_provider.dart';
import 'package:joseeder_seller/provider/bank_info_provider.dart';
import 'package:joseeder_seller/provider/transaction_provider.dart';
import 'package:joseeder_seller/theme/dark_theme.dart';
import 'package:joseeder_seller/theme/light_theme.dart';
import 'package:joseeder_seller/utill/app_constants.dart';
import 'package:joseeder_seller/view/screens/splash/splash_screen.dart';

import 'di_container.dart' as di;
import 'notification/my_notification.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  final NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  int _orderID;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    _orderID = (notificationAppLaunchDetails.payload != null && notificationAppLaunchDetails.payload.isNotEmpty)
        ? int.parse(notificationAppLaunchDetails.payload) : null;
  }
  await MyNotification.initialize(flutterLocalNotificationsPlugin);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ShopProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BankInfoProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BusinessProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TransactionProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<RestaurantProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductReviewProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ShippingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<DeliveryManProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<RefundProvider>()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    List<Locale> _locals = [];
    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode, language.countryCode));
    });
    return MaterialApp(
      title: 'Jose Seller',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
       builder: (context, child) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, child),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(450, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(color: const Color(0xFFF5F5F5))),
      theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
      locale: Provider.of<LocalizationProvider>(context).locale,
      localizationsDelegates: [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: _locals,
      home: SplashScreen(),
    );
  }
}
