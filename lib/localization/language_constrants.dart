import 'package:flutter/material.dart';
import 'package:eamar_seller_app/localization/app_localization.dart';

String getTranslated(String key, BuildContext context) {
  return AppLocalization.of(context).translate(key);
}
