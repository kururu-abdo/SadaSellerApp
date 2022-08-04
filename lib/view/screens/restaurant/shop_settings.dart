
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/shop_info_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/shop_info_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';

class ShopSettingsScreen extends StatefulWidget {

  final ShopModel shopInfoModel;
  ShopSettingsScreen({this.shopInfoModel});

  @override
  _ShopSettingsScreenState createState() => _ShopSettingsScreenState();
}

class _ShopSettingsScreenState extends State<ShopSettingsScreen> {

   TextEditingController _restaurantNameController ;
   TextEditingController _addressController ;
   TextEditingController _phoneController ;

  final FocusNode _resNameNode = FocusNode();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    _restaurantNameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();

    _restaurantNameController.text = widget.shopInfoModel.name ?? '';
    _addressController.text = widget.shopInfoModel.address ?? '';
    _phoneController.text = widget.shopInfoModel.contact ?? '';
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Consumer<ShopProvider>(
          builder: (context, shopProvider, child) => Form(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  margin: EdgeInsets.only(top: 25, bottom: 24),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorResources.getGrey(context), width: 3),
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: () {
                      shopProvider.choosePhoto();
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: shopProvider.file == null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholder_image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              image:
                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl}/${shopProvider.shopModel.image}',
                            ),
                          )
                              : Image.file(shopProvider.file, width: 80, height: 80, fit: BoxFit.fill),
                        ),
                        Positioned(
                          bottom: -5,
                          right: 0,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Icon(Icons.camera_alt_outlined, size: 20, color: ColorResources.WHITE,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Text(
                  getTranslated('restaurant_name', context),
                  style: titilliumRegular.copyWith(fontSize: Dimensions.PADDING_SIZE_DEFAULT, color: ColorResources.getHintColor(context),)),

                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  border: true,
                  hintText: getTranslated('restaurant_name', context),
                  focusNode: _resNameNode,
                  nextNode: _addressNode,
                  controller: _restaurantNameController,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),

                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                Text(
                  getTranslated('address_line_01', context),
                  style: titilliumRegular.copyWith(fontSize: Dimensions.PADDING_SIZE_DEFAULT, color: ColorResources.getHintColor(context),)),

                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  border: true,
                  hintText: getTranslated('address_line_02', context),
                  focusNode: _addressNode,
                  controller: _addressController,
                  textInputType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                ),

                SizedBox(height: 22),
                Text(
                  getTranslated('phone_no', context),
                  style: titilliumRegular.copyWith(fontSize: Dimensions.PADDING_SIZE_DEFAULT, color: ColorResources.getHintColor(context),)),

                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  border: true,
                  hintText: '012345678',
                  controller: _phoneController,
                  focusNode: _phoneNode,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.number,
                ),

                // for save button

                SizedBox(height: 50),
                !shopProvider.isLoading
                    ? TextButton(
                  onPressed: () async {
                    String _firstName = _restaurantNameController.text.trim();
                    String _address = _addressController.text.trim();
                    String _phoneNumber = _phoneController.text.trim();
                    if (shopProvider.shopModel.name == _firstName &&
                        shopProvider.shopModel.address == _address &&
                        shopProvider.shopModel.contact == _phoneNumber &&
                        shopProvider.file == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Change something to update'), backgroundColor: ColorResources.RED));
                    }else if (_firstName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('enter_first_name', context)), backgroundColor: ColorResources.RED));
                    }else if (_address.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('enter_address', context)), backgroundColor: ColorResources.RED));
                    }else if (_phoneNumber.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('enter_phone_number', context)), backgroundColor: ColorResources.RED));
                    } else {
                      ShopModel updateUserInfoModel = shopProvider.shopModel;
                      updateUserInfoModel.name = _restaurantNameController.text ?? "";
                      updateUserInfoModel.address = _addressController.text ?? "";
                      updateUserInfoModel.contact = _phoneController.text ?? '';

                      ResponseModel _responseModel = await shopProvider.updateBankInfo(
                        updateUserInfoModel,
                        shopProvider.file,
                        Provider.of<ShopProvider>(context, listen: false).getShopToken(),
                      );
                      if (_responseModel.isSuccess) {
                        shopProvider.getShopInfo(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Updated Successfully'), duration: Duration(milliseconds: 600),backgroundColor: Colors.green));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_responseModel.message), duration: Duration(milliseconds: 600),backgroundColor: Colors.red));
                      }
                      setState(() {});
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: ColorResources.getPrimary(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        getTranslated('save', context),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ) : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
