import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/data/model/response/shipping_model.dart';
import 'package:eamar_seller_app/helper/price_converter.dart';
import 'package:eamar_seller_app/localization/language_constrants.dart';
import 'package:eamar_seller_app/provider/auth_provider.dart';
import 'package:eamar_seller_app/provider/shipping_provider.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/styles.dart';
import 'package:eamar_seller_app/view/base/custom_app_bar.dart';
import 'package:eamar_seller_app/view/base/custom_button.dart';
import 'package:eamar_seller_app/view/base/custom_snackbar.dart';
import 'package:eamar_seller_app/view/base/textfeild/custom_text_feild.dart';

import 'business_setting.dart';

class ShippingMethodScreen extends StatefulWidget {
  final ShippingModel? shipping;
  ShippingMethodScreen({this.shipping});
  @override
  _ShippingMethodScreenState createState() => _ShippingMethodScreenState();
}

class _ShippingMethodScreenState extends State<ShippingMethodScreen> {
  TextEditingController? _titleController;
  TextEditingController? _durationController;
  TextEditingController? _costController;

  final FocusNode _resNameNode = FocusNode();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  GlobalKey<FormState>? _formKeyLogin;
  ShippingModel? shipping;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _titleController = TextEditingController();
    _durationController = TextEditingController();
    _costController = TextEditingController();
    shipping = ShippingModel();
  }

  @override
  void dispose() {
    _titleController!.dispose();
    _durationController!.dispose();
    _costController!.dispose();
    super.dispose();
  }

  void callback(bool route, String error) {
    if (route) {
      if (widget.shipping == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
              getTranslated('shipping_method_added_successfully', context)),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
              getTranslated('shipping_method_update_successfully', context)),
        ));
      }

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => BusinessScreen()));
    } else {
      showCustomSnackBar(error, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shipping != null) {
      _titleController!.text = widget.shipping!.title!;
      _durationController!.text = widget.shipping!.duration!;
      _costController!.text =
          PriceConverter.convertAmount(widget.shipping!.cost!, context)
              .toString();
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: getTranslated('shipping_method', context)),
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => Form(
            key: _formKeyLogin,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Text(getTranslated('title', context),
                    style: titilliumRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                      color: ColorResources.getHintColor(context),
                    )),

                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                CustomTextField(
                  border: true,
                  hintText: getTranslated('title', context),
                  focusNode: _resNameNode,
                  nextNode: _addressNode,
                  controller: _titleController,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Text(getTranslated('duration', context),
                    style: titilliumRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                      color: ColorResources.getHintColor(context),
                    )),

                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  border: true,
                  hintText: 'Ex: 4-6 days',
                  focusNode: _addressNode,
                  controller: _durationController,
                  textInputType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                ),

                SizedBox(height: 22),
                Text(getTranslated('cost', context),
                    style: titilliumRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                      color: ColorResources.getHintColor(context),
                    )),

                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  border: true,
                  hintText: 'Ex: \$100',
                  controller: _costController,
                  focusNode: _phoneNode,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.number,
                  isAmount: true,
                ),

                // for login button
                SizedBox(height: 50),

                Consumer<ShippingProvider>(
                    builder: (context, shipProvider, child) {
                  return !shipProvider.isLoading!
                      ? CustomButton(
                          btnTxt: widget.shipping == null
                              ? getTranslated('save', context)
                              : getTranslated('update', context),
                          backgroundColor: ColorResources.WHITE,
                          onTap: () {
                            String title = _titleController!.text.trim();
                            String cost = _costController!.text.trim();
                            String duration = _durationController!.text.trim();

                            if (title.isEmpty) {
                              showCustomSnackBar(
                                  getTranslated('enter_title', context),
                                  context);
                            } else if (cost.isEmpty) {
                              showCustomSnackBar(
                                  getTranslated('enter_cost', context),
                                  context);
                            } else if (duration.isEmpty) {
                              showCustomSnackBar(
                                  getTranslated('enter_duration', context),
                                  context);
                            } else {
                              shipping!.title = title;
                              shipping!.cost = PriceConverter
                                  .systemCurrencyToDefaultCurrency(
                                      double.parse(cost), context);
                              shipping!.duration = duration;
                              print('-------${shipping!.cost}');
                              if (widget.shipping == null) {
                                Provider.of<ShippingProvider>(context,
                                        listen: false)
                                    .addShippingMethod(shipping!, callback);
                              } else if (widget.shipping != null) {
                                Provider.of<ShippingProvider>(context,
                                        listen: false)
                                    .updateShippingMethod(
                                        shipping!.title!,
                                        shipping!.duration!,
                                        shipping!.cost!,
                                        widget.shipping!.id!,
                                        callback);
                              }
                            }
                          },
                        )
                      : Center(child: CircularProgressIndicator());
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
