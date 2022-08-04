import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/delivery_man_provider.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/provider/shipping_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/base/custom_divider.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:sixvalley_vendor_app/view/base/no_data_screen.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';


class OrderDetailsScreen extends StatefulWidget {
  final OrderModel orderModel;
  final int orderId;
  final String orderType;
  final String shippingType;
  final double extraDiscount;
  final String extraDiscountType;
  OrderDetailsScreen({this.orderModel, @required this.orderId, @required this.orderType, this.shippingType, this.extraDiscount, this.extraDiscountType});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _loadData(BuildContext context, String type) async {
    if(widget.orderModel == null) {
      await Provider.of<SplashProvider>(context, listen: false).initConfig(context);
    }
    Provider.of<OrderProvider>(context, listen: false).getOrderDetails(widget.orderId.toString(), context);
    Provider.of<OrderProvider>(context, listen: false).initOrderStatusList(context, widget.shippingType);
    Provider.of<DeliveryManProvider>(context, listen: false).getDeliveryManList(widget.orderModel, context);
  }

  TextEditingController _thirdPartyShippingNameController = TextEditingController();

  TextEditingController _thirdPartyShippingIdController = TextEditingController();

  FocusNode _thirdPartyShippingNameNode = FocusNode();

  FocusNode _thirdPartyShippingIdNode = FocusNode();
  String deliveryType = 'select delivery type';

  @override
  void initState() {
    if(widget.orderModel.thirdPartyServiceName!=null){
      _thirdPartyShippingNameController.text = widget.orderModel.thirdPartyServiceName;
    }
    if(widget.orderModel.thirdPartyTrackingId!=null){
      _thirdPartyShippingIdController.text = widget.orderModel.thirdPartyTrackingId;
    }
    Provider.of<OrderProvider>(context, listen: false).setPaymentStatus(widget.orderModel.paymentStatus);

    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    _loadData(context,widget.shippingType);
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: getTranslated('order_details', context)),
      body: Consumer<OrderProvider>(
          builder: (context, order, child) {

            double _itemsPrice = 0;
            double _discount = 0;
            double eeDiscount = 0;
            double _coupon = widget.orderModel.discountAmount;
            double _tax = 0;
            double _shipping = widget.orderModel.shippingCost;
            if (order.orderDetails != null) {
              order.orderDetails.forEach((orderDetails) {
                _itemsPrice = _itemsPrice + (orderDetails.price * orderDetails.qty);
                _discount = _discount + orderDetails.discount;
                _tax = _tax + orderDetails.tax ;
              });
            }
            double _subTotal = _itemsPrice +_tax - _discount;

            if(widget.orderType == 'POS'){
              if(widget.extraDiscountType == 'percent'){
                eeDiscount = _itemsPrice * (widget.extraDiscount/100);
              }else{
                eeDiscount = widget.extraDiscount;
              }
            }
            double _totalPrice = _subTotal + _shipping - _coupon - eeDiscount;

            return order.orderDetails != null ? order.orderDetails.length > 0 ?
            ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_EXTRA_SMALL, right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      bottom: Dimensions.PADDING_SIZE_DEFAULT),
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_DEFAULT),

                  child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [



                    //assign delivery man
                    Provider.of<SplashProvider>(context,listen: false).configModel.shippingMethod =='sellerwise_shipping' && widget.orderType != 'POS'?
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getTranslated('shipping_info', context), style: robotoBold,),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                        Container(
                          child: Container( padding: EdgeInsets.symmetric(horizontal:Dimensions.FONT_SIZE_EXTRA_SMALL ),
                              decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                border: Border.all(width: .5,color: Theme.of(context).hintColor.withOpacity(.5)),
                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL)),
                              child: DropdownButton<String>(
                                value: deliveryType,
                                isExpanded: true,
                                underline: SizedBox(),
                                onChanged: (String newValue) {
                              setState(() {
                                deliveryType = newValue;

                              });
                            },
                            items: <String>['select delivery type', getTranslated('by_self_delivery_man', context),
                              getTranslated('by_third_party_delivery_service', context)]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),





                        deliveryType == getTranslated('by_self_delivery_man', context) || widget.orderModel.deliveryType == 'self_delivery'?
                        Padding(padding: const EdgeInsets.only(bottom: 20.0),
                          child: widget.orderType == 'POS'? SizedBox(): Consumer<DeliveryManProvider>(builder: (context, deliveryMan, child) {
                            return Row(children: [Expanded(child: Container(
                              padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL, right: Dimensions.PADDING_SIZE_SMALL,),
                              decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                                border: Border.all(width: .5,color: Theme.of(context).hintColor.withOpacity(.5)),
                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),),
                              alignment: Alignment.center,
                              child: DropdownButtonFormField<int>(
                                value: deliveryMan.deliveryManIndex,
                                isExpanded: true,
                                decoration: InputDecoration(border: InputBorder.none),
                                iconSize: 24, elevation: 16, style: titilliumRegular,
                                items: deliveryMan.deliveryManIds.map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: deliveryMan.deliveryManIds.indexOf(value),
                                    child: Text(value != 0?
                                    '${deliveryMan.deliveryManList[(deliveryMan.deliveryManIds.indexOf(value) -1)].fName} '
                                        '${deliveryMan.deliveryManList[(deliveryMan.deliveryManIds.indexOf(value) -1)].lName}':
                                    getTranslated('select_delivery_man', context),
                                      style: TextStyle(color: ColorResources.getTextColor(context)),),);
                                }).toList(),
                                onChanged: (int value) {
                                  deliveryMan.setDeliverymanIndex(value, true);
                                  deliveryMan.assignDeliveryMan(context,widget.orderId, deliveryMan.deliveryManList[value-1].id);
                                  },
                              ),),),],);}),) :


                        deliveryType == 'By third party delivery service' || widget.orderModel.deliveryType == "third_party_delivery"?
                        Padding(padding: const EdgeInsets.only(bottom: 20.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                            children: [Container(child: Row(children: [
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(getTranslated('third_party_delivery_service', context),
                                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                                CustomTextField(
                                  border: true,
                                  hintText: 'Ex: xyz service',
                                  controller: _thirdPartyShippingNameController,
                                  focusNode: _thirdPartyShippingNameNode,
                                  nextNode: _thirdPartyShippingIdNode,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.name,
                                  isAmount: false,
                                ),],),),
                              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),


                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(getTranslated('third_party_delivery_tracking_id', context),
                                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: Theme.of(context).disabledColor),),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                CustomTextField(
                                  hintText: 'Ex: xyz-12345678',
                                  border: true,
                                  controller: _thirdPartyShippingIdController,
                                  focusNode: _thirdPartyShippingIdNode,
                                  textInputAction: TextInputAction.done,
                                  textInputType: TextInputType.text,
                                  isAmount: false,
                                ),
                              ],),),
                            ],),),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),



                              Consumer<ShippingProvider>(
                                builder: (context, shipping,_) {
                                  return Container( width: 120,
                                    child: CustomButton(btnTxt: getTranslated('add', context), onTap: (){
                                      String serviceName =_thirdPartyShippingNameController.text.trim().toString();
                                      String trackingId =_thirdPartyShippingIdController.text.trim().toString();
                                      if(serviceName.isEmpty){
                                        showCustomSnackBar(getTranslated('delivery_service_provider_name_required',context), context);
                                      } else{
                                        shipping.isLoading? CircularProgressIndicator(color: Theme.of(context).primaryColor) :
                                        Provider.of<ShippingProvider>(context,listen: false).assignThirdPartyDeliveryMan(context,
                                            serviceName, trackingId, widget.orderModel.id);
                                      }},),
                                  );
                                }
                              )
                            ],
                          ),
                        ):SizedBox(),
                      ],
                    ):SizedBox(),
                    Provider.of<SplashProvider>(context,listen: false).configModel.shippingMethod =='sellerwise_shipping' && widget.orderType != 'POS'?
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT),
                      child: CustomDivider(),
                    ):SizedBox.shrink(),



                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${getTranslated('order_no', context)}#${widget.orderModel.id}',
                        style: titilliumSemiBold.copyWith(color: ColorResources.titleColor(context),
                            fontSize: Dimensions.FONT_SIZE_LARGE),),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,
                            vertical: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(color: ColorResources.mainCardThreeColor(context).withOpacity(.085),
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE),),
                        child: Center(child: Text(widget.orderModel.orderStatus,
                              style: titilliumRegular.copyWith(color: ColorResources.mainCardThreeColor(context))),
                        ),),]),



                    Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(widget.orderModel.createdAt)),
                        style: titilliumRegular.copyWith(color: ColorResources.getHint(context),
                            fontSize: Dimensions.FONT_SIZE_SMALL)),

                    widget.orderType != 'POS'?
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT),
                      child: CustomDivider(),
                    ):SizedBox.shrink(),





                    widget.orderType != 'POS'?
                    Row(children: [
                      Text( '${getTranslated('payment_method', context)}:',
                        style: titilliumSemiBold.copyWith(color: ColorResources.getTextColor(context),
                            fontSize: Dimensions.FONT_SIZE_DEFAULT),),
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),


                        Text((widget.orderModel.paymentMethod != null && widget.orderModel.paymentMethod.length > 0) ?
                        '${widget.orderModel.paymentMethod[0]}${widget.orderModel.paymentMethod.substring(1).replaceAll('_', ' ')}' :
                        'Digital Payment', style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                      Expanded(child: SizedBox()),

                      Row( mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [

                        Builder(
                          builder: (context) {
                            return FlutterSwitch(width: 100.0, height: 35.0, toggleSize: 30.0,
                              value: order.paymentStatus == 'paid',
                              borderRadius: 25.0,
                              activeColor: Theme.of(context).primaryColor,
                              activeText: 'paid',
                              inactiveText: 'unpaid',
                              padding: 5.0,
                              activeTextFontWeight: FontWeight.w400,
                              inactiveTextFontWeight: FontWeight.w400,
                              showOnOff: true,
                              onToggle:(bool isActive) {
                              print('==status==>${order.paymentStatus}');
                                order.updatePaymentStatus(orderId: widget.orderId,
                                    status:order.paymentStatus == 'paid' ?'unpaid':'paid',context: context);
                              }
                            );
                          }
                        ),
                        ],)
                    ],
                    ):SizedBox.shrink(),

                    SizedBox(height: widget.orderType != 'POS'? Dimensions.PADDING_SIZE_DEFAULT : 0),
                    widget.orderType != 'POS'? CustomDivider():SizedBox.shrink(),

                  ]),
                ),




                widget.orderType == 'POS'? SizedBox():
                Container(margin: EdgeInsets.only(left: 5, right: 5,),
                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [


                    Text(getTranslated('shipping_details', context),
                        style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                          color: ColorResources.titleColor(context),)),

                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Text('${getTranslated('name', context)} : '
                        '${widget.orderModel.customer != null?widget.orderModel.customer.fName ?? '': ""}'
                        '${widget.orderModel.customer != null?widget.orderModel.customer.lName ?? '':""}',
                      style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context)),),




                    Text('${getTranslated('address', context)} : '
                        '${widget.orderModel.shippingAddressData != null ?
                    jsonDecode(widget.orderModel.shippingAddressData)['address']  :
                    widget.orderModel.shippingAddress ?? ''}',
                        style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),

                    Text('${getTranslated('phone', context)} : '
                        '${widget.orderModel.shippingAddressData != null ?
                    jsonDecode(widget.orderModel.shippingAddressData)['phone']  :
                    widget.orderModel.shippingAddress ?? ''}',
                        style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),
                    Text('${getTranslated('zip_code', context)} : '
                        '${widget.orderModel.shippingAddressData != null ?
                    jsonDecode(widget.orderModel.shippingAddressData)['zip']  :
                    widget.orderModel.shippingAddress ?? ''}',
                        style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),
                    Text('${getTranslated('city', context)} : '
                        '${widget.orderModel.shippingAddressData != null ?
                    jsonDecode(widget.orderModel.shippingAddressData)['city']  :
                    widget.orderModel.shippingAddress ?? ''}',
                        style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),

                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),



                    Text(getTranslated('billing_address', context),
                        style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                          color: ColorResources.titleColor(context),)),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                    Text('${getTranslated('name', context)} : '
                        '${widget.orderModel.billingAddressData != null ?
                    widget.orderModel.billingAddressData.contactPersonName :
                    widget.orderModel.billingAddress ?? ''}',
                        style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),


                    Text('${getTranslated('billing_address', context)} : '
                        '${widget.orderModel.billingAddressData != null ?
                    widget.orderModel.billingAddressData.address :
                    widget.orderModel.billingAddress ?? ''}',
                        style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),



                    Text('${getTranslated('phone', context)} : '
                        '${widget.orderModel.customer != null?
                    widget.orderModel.customer.phone ?? '':""}',
                        style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),

                    Text('${getTranslated('zip_code', context)} : '
                        '${widget.orderModel.billingAddressData != null?
                    widget.orderModel.billingAddressData.zip ?? '':""}',
                        style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),

                    Text('${getTranslated('city', context)} : '
                        '${widget.orderModel.customer != null?
                    widget.orderModel.billingAddressData.city ?? '':""}',
                        style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),

                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),



                    Text(getTranslated('order_note', context),
                        style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                          color: ColorResources.titleColor(context),)),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Text('${getTranslated('order_note', context)} : '
                        '${widget.orderModel.orderNote != null?widget.orderModel.orderNote ?? '': ""}',
                        style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),

                  ]),
                ),

                widget.orderType != 'POS'?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                  child: CustomDivider(),
                ):SizedBox.shrink(),

                Container(margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                    right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                    bottom: Dimensions.PADDING_SIZE_DEFAULT),
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,
                      vertical: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(getTranslated('order_summery', context),
                        style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                      color: ColorResources.titleColor(context),) ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),



                    ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: order.orderDetails.length,
                      itemBuilder: (context, index) {
                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [Container(height: Dimensions.image_size,
                                width: Dimensions.image_size, child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),

                                  child: FadeInImage.assetNetwork(
                                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, fit: BoxFit.cover,),
                                    placeholder: Images.placeholder_image,
                                    image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/'
                                        '${order.orderDetails[index].productDetails.thumbnail}',
                                    height: Dimensions.image_size, width: Dimensions.image_size,
                                    fit: BoxFit.cover,),),),
                                SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),


                                Expanded(
                                  child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
                                    Text(order.orderDetails[index].productDetails.name,
                                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                          color: ColorResources.getTextColor(context)),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),


                                    Row( children: [
                                      (order.orderDetails[index].productDetails.discount > 0 &&
                                          order.orderDetails[index].productDetails.discount!= null)?
                                      Text(PriceConverter.convertPrice(context,
                                          order.orderDetails[index].productDetails.unitPrice.toDouble()),
                                        style: titilliumRegular.copyWith(color: ColorResources.mainCardFourColor(context),fontSize: Dimensions.FONT_SIZE_SMALL,
                                            decoration: TextDecoration.lineThrough),):SizedBox(),
                                      SizedBox(width: order.orderDetails[index].productDetails.discount > 0?
                                      Dimensions.PADDING_SIZE_DEFAULT : 0),



                                      Text(PriceConverter.convertPrice(context,
                                          order.orderDetails[index].productDetails.unitPrice.toDouble(),
                                          discount :order.orderDetails[index].productDetails.discount,
                                          discountType :order.orderDetails[index].productDetails.discountType),
                                        style: titilliumSemiBold.copyWith(color: Theme.of(context).primaryColor),),


                                    ],),
                                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                    Row(children: [
                                      Text(getTranslated('qty', context),
                                          style: titilliumRegular.copyWith(color: Theme.of(context).hintColor)),

                                      Text(': ${order.orderDetails[index].qty}',
                                          style: titilliumRegular.copyWith(color: ColorResources.getTextColor(context))),],),
                                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),


                                    (order.orderDetails[index].variant != null && order.orderDetails[index].variant.isNotEmpty) ?
                                    Padding(padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      child: Text(order.orderDetails[index].variant,
                                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                                            color: Theme.of(context).disabledColor,)),) : SizedBox(),
                                  ],),
                                ),

                              ],
                            ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomDivider(),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                          ],
                        );
                      },
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),



                    // Total
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('sub_total', context),
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.titleColor(context))),
                      Text(PriceConverter.convertPrice(context, _itemsPrice),
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.titleColor(context))),]),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),



                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('tax', context),
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.titleColor(context))),
                      Text('+ ${PriceConverter.convertPrice(context, _tax)}',
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.titleColor(context))),]),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),




                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('discount', context),
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.titleColor(context))),
                      Text('- ${PriceConverter.convertPrice(context, _discount)}',
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.titleColor(context))),]),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),



                    widget.orderType == "POS"?
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('extra_discount', context),
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.titleColor(context))),
                      Text('- ${PriceConverter.convertPrice(context, eeDiscount)}',
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.titleColor(context))),
                    ]):SizedBox(),
                    SizedBox(height:  widget.orderType == "POS"? Dimensions.PADDING_SIZE_SMALL: 0),


                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('coupon_discount', context),
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.titleColor(context))),
                      Text('- ${PriceConverter.convertPrice(context, _coupon)}',
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.titleColor(context))),]),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),



                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('shipping_fee', context),
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.titleColor(context))),
                      Text('+ ${PriceConverter.convertPrice(context, _shipping)}',
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.titleColor(context))),]),


                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomDivider(),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),



                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('total_amount', context),
                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                              color: Theme.of(context).primaryColor)),
                      Text(PriceConverter.convertPrice(context, _totalPrice),
                        style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                            color: Theme.of(context).primaryColor),),]),

                  ]),
                ),




                widget.orderModel.customer != null?
                Container(
                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                  margin: EdgeInsets.only(left: 5, right: 5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),

                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(getTranslated('customer_contact_details', context),
                        style: titilliumSemiBold.copyWith(color: ColorResources.titleColor(context),
                          fontSize: Dimensions.FONT_SIZE_LARGE,)),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                    Row(children: [ClipRRect(borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(errorWidget: (ctx, url, err) => Image.asset(Images.placeholder_image),
                          placeholder: (ctx, url) => Image.asset(Images.placeholder_image),
                          imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/'
                              '${widget.orderModel.customer.image}',
                          height: 50,width: 50, fit: BoxFit.cover),),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),


                        Expanded(child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('${widget.orderModel.customer.fName ?? ''} '
                              '${widget.orderModel.customer.lName ?? ''}',
                              style: titilliumRegular.copyWith(color: ColorResources.titleColor(context),
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT)),


                            Text('${getTranslated('email', context)} : '
                                '${widget.orderModel.customer.email ?? ''}',
                                style: titilliumRegular.copyWith(color: ColorResources.titleColor(context),
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT)),


                            Text('${getTranslated('contact', context)} : ${widget.orderModel.customer.phone}',
                                style: titilliumRegular.copyWith(color: ColorResources.titleColor(context),
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT)),],))
                      ],
                    )
                  ]),
                ):SizedBox(),




              ],
            ) : NoDataScreen() : Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
          }
      ),

      bottomNavigationBar: widget.orderType =='POS'? SizedBox.shrink():
      Consumer<OrderProvider>(
        builder: (context, order, _) {
          return Container(height: 85,
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [

              order.isLoading ?
              Center(child: CircularProgressIndicator(key: Key(''),
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))) :

              Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Consumer<OrderProvider>(builder: (context, order, child) {
                  return Row(mainAxisAlignment:MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,children: [

                    Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                      child: Container(height: 50,
                        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL,
                        right: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.5))
                        ),
                        alignment: Alignment.center,
                        child: DropdownButtonFormField<String>(
                          value: order.orderStatusType,
                          isExpanded: true,
                          decoration: InputDecoration(border: InputBorder.none),
                          iconSize: 24, elevation: 16, style: titilliumRegular,
                          onChanged: order.updateStatus,
                          items: order.orderStatusList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: titilliumRegular.copyWith(color: Theme.of(context).textTheme.bodyText1.color)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),


                    Align(alignment: Alignment.bottomRight,
                      child: InkWell(onTap: () async {
                        if(order.orderStatusType == order.orderStatusList[0]) {
                          ScaffoldMessenger.of(c).showSnackBar(SnackBar(
                            content: Text(getTranslated('select_order_type', context)),
                            backgroundColor: Colors.red,));
                        }else {order.setOrderStatusErrorText('');
                        List<int> _productIds = [];
                        order.orderDetails.forEach((orderDetails) {
                          _productIds.add(orderDetails.id);
                        });
                        await order.updateOrderStatus(widget.orderModel.id, order.orderStatusType,context).then((value) {
                          if(value.response.statusCode==200){

                          }
                        });
                        }},

                          child: Container(height: 50,
                              decoration: BoxDecoration(color: ColorResources.getPrimary(context),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                  child: Text(getTranslated('change_status', context),
                                    style: titilliumSemiBold.copyWith(color: Theme.of(context).cardColor),),
                                ),
                              ))),
                    ),
                  ],);}),),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE)
          ],),
            ),);
        }
      ),
    );
  }
}
