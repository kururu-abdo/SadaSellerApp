import 'package:flutter/material.dart';
import 'package:joseeder_seller/localization/language_constrants.dart';
import 'package:joseeder_seller/view/base/custom_app_bar.dart';
import 'package:joseeder_seller/view/screens/home/widget/stock_out_product_widget.dart';
class StockOutProductScreen extends StatelessWidget {
  const StockOutProductScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          CustomAppBar(title: getTranslated('stock_out_product',context)),
          Expanded(child: StockOutProductView(isHome: false)),
        ],),
      ),
    );
  }
}
