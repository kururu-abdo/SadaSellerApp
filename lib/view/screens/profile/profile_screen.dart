import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/body/seller_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/seller_info.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/provider/bank_info_provider.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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

  _updateUserAccount() async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _firstNameController.text.trim();
    String _phoneNumber = _phoneController.text.trim();

    if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName == _firstNameController.text
        && Provider.of<ProfileProvider>(context, listen: false).userInfoModel.lName == _lastNameController.text
        && Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone == _phoneController.text && file == null) {
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Change something to update'),
         backgroundColor: ColorResources.RED));
    }else if (_firstName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('enter_first_name', context)),
          backgroundColor: ColorResources.RED));
    }else if (_lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('enter_first_name', context)),
          backgroundColor: ColorResources.RED));
    }else if (_phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('enter_phone_number', context)),
          backgroundColor: ColorResources.RED));
    }else {
      SellerModel updateUserInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
      updateUserInfoModel.fName = _firstNameController.text ?? "";
      updateUserInfoModel.lName = _lastNameController.text ?? "";
      updateUserInfoModel.phone = _phoneController.text ?? '';

      SellerModel _bank = Provider.of<BankInfoProvider>(context, listen: false).bankInfo;
      SellerBody _sellerBody = SellerBody(
          sMethod: '_put', fName: _firstNameController.text ?? "", lName: _lastNameController.text ?? "",
        image: updateUserInfoModel.image,
          bankName: _bank.bankName, branch: _bank.branch, holderName: _bank.holderName, accountNo: _bank.accountNo,
      );

      await Provider.of<ProfileProvider>(context, listen: false).updateUserInfo(
        updateUserInfoModel, _sellerBody, file, Provider.of<AuthProvider>(context, listen: false).getUserToken(),
      ).then((response) {
        if(response.isSuccess) {
          Provider.of<ProfileProvider>(context, listen: false).getSellerInfo(context);
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Updated Successfully'), backgroundColor: Colors.green));
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
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          final created = profile.userInfoModel.createdAt;
          DateTime parseDate =
          new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(created);
          final today = DateTime.now();
          final joined = today.difference(parseDate).inDays;


          if(_firstNameController.text.isEmpty) {
            _firstNameController.text = profile.userInfoModel.fName;
            _lastNameController.text = profile.userInfoModel.lName;
            _phoneController.text = profile.userInfoModel.phone;
          }
          return Stack(
            clipBehavior: Clip.none,
            children: [

              Container(height: 400,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color:ColorResources.getPrimary(context),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE,),
                        bottomLeft: Radius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE))
                ),),



              Container(height: MediaQuery.of(context).size.width/1.3,
                width: MediaQuery.of(context).size.width/1.3,
                decoration: BoxDecoration(color: Theme.of(context).cardColor.withOpacity(.10),
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(MediaQuery.of(context).size.width))),),


              Container(
                padding: EdgeInsets.only(top: 400),
                child: Column(
                  children: [
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
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person, color: ColorResources.getLightSkyBlue(context), size: 20),
                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Text(getTranslated('first_name', context), style: titilliumRegular)
                                    ],
                                  ),

                                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType: TextInputType.name,
                                    focusNode: _fNameFocus,
                                    nextNode: _lNameFocus,
                                    hintText: profile.userInfoModel.fName ?? '',
                                    controller: _firstNameController,
                                  ),

                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Icon(Icons.person, color: ColorResources.getLightSkyBlue(context), size: 20),
                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Text(getTranslated('last_name', context), style: titilliumRegular)
                                    ],
                                  ),

                                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType: TextInputType.name,
                                    focusNode: _lNameFocus,
                                    nextNode: _phoneFocus,
                                    hintText: profile.userInfoModel.lName,
                                    controller: _lastNameController,
                                  ),
                                ],
                              ),
                            ),

                            // for Phone No
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.PADDING_SIZE_DEFAULT,
                                  left: Dimensions.PADDING_SIZE_DEFAULT,
                                  right: Dimensions.PADDING_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.dialpad, color: ColorResources.getLightSkyBlue(context), size: 20),
                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Text(getTranslated('phone_no', context), style: titilliumRegular)
                                    ],
                                  ),

                                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType: TextInputType.number,
                                    focusNode: _phoneFocus,
                                    hintText: profile.userInfoModel.phone ?? "",
                                    controller: _phoneController,
                                    isPhoneNumber: true,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/4),
                              child: Container(
                                width: MediaQuery.of(context).size.width/2.5,
                                margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
                                child: !profile.isLoading
                                    ? CustomButton(backgroundColor: Theme.of(context).primaryColor, onTap: _updateUserAccount,
                                    btnTxt: getTranslated('update_profile', context))
                                    : Center(child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Positioned(top: MediaQuery.of(context).size.width/4, left: 0,right: 0,
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      border: Border.all(color: Colors.white, width: 3),
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
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
                              imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.sellerImageUrl}/${profile.userInfoModel.image ?? ''}',
                            )
                                : Image.file(file, width: 100, height: 100, fit: BoxFit.fill),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0, top: 0, left: 0,
                            child: InkWell(
                              onTap: _choose,
                              child: CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.4),
                                radius: 14,
                                child: IconButton(
                                  onPressed: _choose,
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.camera_enhance, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Text('${profile.userInfoModel.fName} ${profile.userInfoModel.lName}',
                      textAlign: TextAlign.center,
                      style: titilliumSemiBold.copyWith(color:  ColorResources.getProfileTextColor(context),
                          fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),),
                  ),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                        vertical: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [


                      Column(mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Text(profile.userInfoModel.productCount.toString(),
                              style: titilliumBold.copyWith(color:  ColorResources.getProfileTextColor(context),
                                  fontSize: Dimensions.FONT_SIZE_MAX_LARGE)),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                          Text(getTranslated('total_products', context),
                            textAlign: TextAlign.center,
                            style: titilliumRegular.copyWith(color: ColorResources.getProfileTextColor(context),
                                fontSize: Dimensions.FONT_SIZE_LARGE),),],),


                      Column(mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(profile.userInfoModel.ordersCount.toString(),
                            style: titilliumBold.copyWith(color:  ColorResources.getProfileTextColor(context),
                                fontSize: Dimensions.FONT_SIZE_MAX_LARGE),),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),



                          Text(getTranslated('total_order', context),
                            style: titilliumRegular.copyWith(color:  ColorResources.getProfileTextColor(context),
                                fontSize: Dimensions.FONT_SIZE_LARGE),),
                        ],),

                      Column(mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(joined.toString(),
                            style: titilliumBold.copyWith(color:  ColorResources.getProfileTextColor(context),
                                fontSize: Dimensions.FONT_SIZE_MAX_LARGE),),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                          Text(getTranslated('days_since_joined', context),
                            textAlign: TextAlign.center,
                            style: titilliumRegular.copyWith(color:  ColorResources.getProfileTextColor(context),
                                fontSize: Dimensions.FONT_SIZE_LARGE),),
                        ],),
                    ],),
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
