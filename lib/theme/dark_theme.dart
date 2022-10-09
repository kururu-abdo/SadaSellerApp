import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Cairo',
  primaryColor: Color(0xFFfaf274),
  brightness: Brightness.dark,
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
  highlightColor: Color(0xFF252525),
  hintColor: Color(0xFFc7c7c7),
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
