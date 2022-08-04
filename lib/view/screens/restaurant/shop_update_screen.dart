import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/shop_info_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/shop_info_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';
class ShopUpdateScreen extends StatefulWidget {
  @override
  _ShopUpdateScreenState createState() => _ShopUpdateScreenState();
}

class _ShopUpdateScreenState extends State<ShopUpdateScreen> {

  final FocusNode _sNameFocus = FocusNode();
  final FocusNode _cNumberFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();



  File file;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  void _choose() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }


  _updateShop() async {
    String _shopName = _shopNameController.text.trim();
    String _contactNumber = _contactNumberController.text.trim();
    String _address = _addressController.text.trim();

    if(Provider.of<ShopProvider>(context, listen: false).shopModel.name == _shopNameController.text
        && Provider.of<ShopProvider>(context, listen: false).shopModel.contact == _contactNumberController.text
        && Provider.of<ShopProvider>(context, listen: false).shopModel.address == _addressController.text && file == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Change something to update'), backgroundColor: ColorResources.RED));
    }else if (_shopName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('enter_first_name', context)), backgroundColor: ColorResources.RED));
    }else if (_contactNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('enter_first_name', context)), backgroundColor: ColorResources.RED));
    }else if (_address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('enter_phone_number', context)), backgroundColor: ColorResources.RED));
    }else {
      ShopModel updateShopModel = Provider.of<ShopProvider>(context, listen: false).shopModel;
      updateShopModel.name = _shopNameController.text ?? "";
      updateShopModel.contact = _contactNumberController.text ?? "";
      updateShopModel.address = _addressController.text ?? '';


      await Provider.of<ShopProvider>(context, listen: false).updateShopInfo(
        updateShopModel, file, Provider.of<ShopProvider>(context, listen: false).getShopToken(),
      ).then((response) {
        if(response.isSuccess) {
          Provider.of<ShopProvider>(context, listen: false).getShopInfo(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('shop_info_updated_successfully', context)), backgroundColor: Colors.green));
          Navigator.pop(context);
          setState(() {});
        }else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message), backgroundColor: Colors.red));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('shop_settings',context),),
      key: _scaffoldKey,
      body: Consumer<ShopProvider>(
        builder: (context, shop, child) {
          _shopNameController.text = shop.shopModel.name;
          _contactNumberController.text = shop.shopModel.contact;
          _addressController.text = shop.shopModel.address;

          return Stack(
            clipBehavior: Clip.none,
            children: [

              Container(
                padding: EdgeInsets.only(top: 55),
                child: Column(
                  children: [

                    SizedBox(height: 100,),


                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorResources.getIconBg(context),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.PADDING_SIZE_DEFAULT),
                              topRight: Radius.circular(Dimensions.PADDING_SIZE_DEFAULT),
                            )),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [

                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.PADDING_SIZE_DEFAULT,
                                  left: Dimensions.PADDING_SIZE_DEFAULT,
                                  right: Dimensions.PADDING_SIZE_DEFAULT),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getTranslated('shop_name', context), style: titilliumRegular),

                                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  CustomTextField(
                                    border: true,
                                    isDescription: true,
                                    textInputType: TextInputType.name,
                                    focusNode: _sNameFocus,
                                    nextNode: _cNumberFocus,
                                    hintText: shop.shopModel.name ?? '',
                                    controller: _shopNameController,
                                  ),

                                  SizedBox(height: 15),
                                  Text(getTranslated('contact_number', context), style: titilliumRegular),

                                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  CustomTextField(
                                    border: true,
                                    textInputType: TextInputType.number,
                                    focusNode: _cNumberFocus,
                                    nextNode: _addressFocus,
                                    hintText: shop.shopModel.contact,
                                    controller: _contactNumberController,
                                    isPhoneNumber: true,
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.PADDING_SIZE_DEFAULT,
                                  left: Dimensions.PADDING_SIZE_DEFAULT,
                                  right: Dimensions.PADDING_SIZE_DEFAULT),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getTranslated('address', context), style: titilliumRegular),

                                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  CustomTextField(
                                    border: true,
                                    textInputType: TextInputType.text,
                                    focusNode: _addressFocus,
                                    hintText: shop.shopModel.address ?? "",
                                    controller: _addressController,

                                  ),
                                ],
                              ),
                            ),


                            InkWell(
                              onTap: (){
                                _updateShop();

                              },
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL)),
                                    color: Theme.of(context).primaryColor
                                  ),
                                  child: Center(child: Text(getTranslated('update_shop', context),style: robotoTitleRegular.copyWith(color: Colors.white),)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: MediaQuery.of(context).size.width/2-60,
                child: Column(
                  children: [
                    Text(getTranslated('update_logo', context)),
                    Container(
                      width : 150,
                      height: 120,
                      margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.grey, width: 1),

                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: file == null
                                ? CachedNetworkImage(
                              errorWidget: (ctx, url, err) => Image.asset(Images.placeholder_image),
                              placeholder: (ctx, url) => Image.asset(Images.placeholder_image),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl}/${shop.shopModel.image}',
                            )
                                : Image.file(file, width: 100, height: 100, fit: BoxFit.fill),
                          ),
                          Positioned(
                            bottom: 25,
                            right: 25,
                            top: 25,
                            left: 25,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey,width: 2),
                                borderRadius: BorderRadius.all(Radius.circular(25),
                                )
                              ),
                              child: IconButton(
                                onPressed: _choose,
                                padding: EdgeInsets.all(0),
                                icon: Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),),
            ],
          );
        },
      ),
    );

  }
}
