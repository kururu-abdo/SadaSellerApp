import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';

class PriceConverter {
  static String convertPrice(BuildContext context, double price, {double discount, String discountType}) {
    if(discount != null && discountType != null){
      if(discountType == 'amount' || discountType == 'flat') {
        price = price - discount;
      }else if(discountType == 'percent' || discountType == 'percentage') {
        price = price - ((discount / 100) * price);
      }
    }
    bool _singleCurrency = Provider.of<SplashProvider>(context, listen: false).configModel.currencyModel == 'single_currency';

    return '${Provider.of<SplashProvider>(context, listen: false).myCurrency.symbol}${(_singleCurrency? price : price
        * Provider.of<SplashProvider>(context, listen: false).myCurrency.exchangeRate
        * (1/Provider.of<SplashProvider>(context, listen: false).usdCurrency.exchangeRate)).toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }


  static String convertPriceWithoutSymbol(BuildContext context, double price, {double discount, String discountType}) {
    if(discount != null && discountType != null){
      if(discountType == 'amount' || discountType == 'flat') {
        price = price - discount;
      }else if(discountType == 'percent' || discountType == 'percentage') {
        price = price - ((discount / 100) * price);
      }
    }
    bool _singleCurrency = Provider.of<SplashProvider>(context, listen: false).configModel.currencyModel == 'single_currency';

    return '${(_singleCurrency? price : price
        * Provider.of<SplashProvider>(context, listen: false).myCurrency.exchangeRate
        * (1/Provider.of<SplashProvider>(context, listen: false).usdCurrency.exchangeRate)).toStringAsFixed(2)
        }';
  }


  static double systemCurrencyToDefaultCurrency(double price, BuildContext context) {
    bool _singleCurrency = Provider.of<SplashProvider>(context, listen: false).configModel.currencyModel == 'single_currency';
    if(_singleCurrency) {
      return price / 1;
    }else {
      return price / Provider.of<SplashProvider>(context, listen: false).myCurrency.exchangeRate;
    }
  }

  static double convertAmount(double amount, BuildContext context) {
    return double.parse('${(amount * Provider.of<SplashProvider>(context, listen: false).myCurrency.exchangeRate *
        (1/Provider.of<SplashProvider>(context, listen: false).usdCurrency.exchangeRate)).toStringAsFixed(2)}');
  }
  static String percentageCalculation(BuildContext context, double price, double discount, String discountType) {
    return '${(discountType == 'percent' || discountType == 'percentage') ? '$discount %'
        : convertPrice(context, discount)} OFF';
  }
}