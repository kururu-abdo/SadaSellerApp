
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:joseeder_seller/data/model/response/product_model.dart';
import 'package:joseeder_seller/localization/language_constrants.dart';
import 'package:joseeder_seller/provider/localization_provider.dart';
import 'package:joseeder_seller/provider/product_provider.dart';
import 'package:joseeder_seller/provider/theme_provider.dart';
import 'package:joseeder_seller/utill/dimensions.dart';
import 'package:joseeder_seller/view/base/product_widget.dart';
import 'package:joseeder_seller/view/base/title_row.dart';
import 'package:joseeder_seller/view/screens/stockOut/stock_out_product_screen.dart';


class StockOutProductView extends StatelessWidget {
  final bool isHome;
  final ScrollController scrollController;
  StockOutProductView({ @required this.isHome, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Provider.of<ProductProvider>(context, listen: false).stockOutProductList.length != 0
          && !Provider.of<ProductProvider>(context, listen: false).isLoading) {
        int pageSize;
        pageSize = (Provider.of<ProductProvider>(context, listen: false).stockOutProductPageSize/10).ceil();

        if(Provider.of<ProductProvider>(context, listen: false).offset < pageSize) {
          Provider.of<ProductProvider>(context, listen: false).setOffset(Provider.of<ProductProvider>(context, listen: false).offset+1);
          print('end of the page');
          Provider.of<ProductProvider>(context, listen: false).showBottomLoader();

          Provider.of<ProductProvider>(context, listen: false).getStockOutProductList(
              Provider.of<ProductProvider>(context, listen: false).
              offset, context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode == 'US'?
          'en':Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode.toLowerCase());

        }
      }
    });


    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product> productList;
        productList = prodProvider.stockOutProductList;


        return Column(children: [

          isHome && productList.length != 0 ?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal : Dimensions.PADDING_SIZE_DEFAULT,
                vertical: Dimensions.PADDING_SIZE_SMALL),
            child: TitleRow(title: getTranslated('stock_out_product', context),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StockOutProductScreen()))),
          ):SizedBox(),

          !prodProvider.isLoading ? productList.length != 0 ?
          Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            height: isHome? MediaQuery.of(context).size.width/1.7 : MediaQuery.of(context).size.height-140,
            child: isHome? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productList.length,
                itemBuilder: (ctx,index){
                  return Container(width: (MediaQuery.of(context).size.width/2)-40,
                      child: ProductWidget(productModel: productList[index]));

                }) :
            GridView.builder(
              itemCount: productList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1/1.28,
              ),
              padding: EdgeInsets.all(0),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,

              itemBuilder: (BuildContext context, int index) {
                return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      color: Theme.of(context).cardColor,
                      boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200],
                          spreadRadius: 0.5, blurRadius: 0.3)],),
                    child: ProductWidget(productModel: productList[index]));
              },
            ),
          ): SizedBox.shrink() :SizedBox.shrink(),

          prodProvider.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}


