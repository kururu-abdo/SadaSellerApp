import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/helper/price_converter.dart';
import 'package:eamar_seller_app/localization/language_constrants.dart';
import 'package:eamar_seller_app/provider/auth_provider.dart';
import 'package:eamar_seller_app/provider/business_provider.dart';
import 'package:eamar_seller_app/provider/shipping_provider.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/images.dart';
import 'package:eamar_seller_app/utill/styles.dart';
import 'package:eamar_seller_app/view/base/confirmation_dialog.dart';
import 'package:eamar_seller_app/view/base/custom_app_bar.dart';
import 'package:eamar_seller_app/view/base/no_shipping_method.dart';
import 'package:eamar_seller_app/view/screens/settings/business_setting_details.dart';

class BusinessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<BusinessProvider>(context, listen: false)
        .getBusinessList(context);
    Provider.of<ShippingProvider>(context, listen: false).getShippingList(
        context,
        Provider.of<AuthProvider>(context, listen: false).getUserToken());

    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      appBar: CustomAppBar(
          title: getTranslated('business_settings', context),
          isBackButtonExist: true),
      body: SafeArea(
        child: Consumer<ShippingProvider>(
          builder: (context, shipProv, child) => Column(
            children: [
              shipProv.shippingList != null
                  ? shipProv.shippingList!.length > 0
                      ? Expanded(
                          child: ListView.builder(
                          itemCount: shipProv.shippingList!.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ShippingMethodScreen(
                                          shipping:
                                              shipProv.shippingList![index])));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.PADDING_SIZE_SMALL,
                                    horizontal: Dimensions.PADDING_SIZE_LARGE),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            ColorResources.getPrimary(context)
                                                .withOpacity(.05),
                                        spreadRadius: -3,
                                        blurRadius: 12,
                                        offset: Offset.fromDirection(0, 6))
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                    'Title : ${shipProv.shippingList![index].title}',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: titilliumBold.copyWith(
                                                        color: ColorResources
                                                            .titleColor(
                                                                context),
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT)),
                                              ),
                                              SizedBox(
                                                height: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      '${PriceConverter.convertPrice(context, shipProv.shippingList![index].cost!)}',
                                                      style: titilliumRegular.copyWith(
                                                          color: ColorResources
                                                              .getHint(context),
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL)),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(
                                                    Icons.access_time_sharp,
                                                    color: Colors.grey,
                                                    size: Dimensions
                                                        .ICON_SIZE_DEFAULT,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                      '${shipProv.shippingList![index].duration}days',
                                                      style: titilliumRegular.copyWith(
                                                          color: ColorResources
                                                              .getHint(context),
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          ShippingMethodScreen(
                                                              shipping: shipProv
                                                                      .shippingList![
                                                                  index]))),
                                              child: Icon(Icons.edit,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_SMALL),
                                            InkWell(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return ConfirmationDialog(
                                                            icon: Images.delete,
                                                            description:
                                                                getTranslated(
                                                                    'are_you_sure_want_to_delete_this_product',
                                                                    context),
                                                            onYesPressed: () {
                                                              Provider.of<ShippingProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .deleteShipping(
                                                                      context,
                                                                      shipProv
                                                                          .shippingList![
                                                                              index]
                                                                          .id!);
                                                            });
                                                      });
                                                },
                                                child: Container(
                                                    width: Dimensions
                                                        .ICON_SIZE_LARGE,
                                                    child: Image.asset(
                                                        Images.delete)))
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                      : NoShippingDataScreen()
                  : Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => ShippingMethodScreen()));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Image.asset(Images.add_btn),
        ),
      ),
    );
  }
}
