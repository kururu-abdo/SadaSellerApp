import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';
import 'package:sixvalley_vendor_app/view/screens/restaurant/restaurant_screen.dart';

class RestaurantSettingsScreen extends StatefulWidget {
  @override
  _RestaurantSettingsScreenState createState() => _RestaurantSettingsScreenState();
}

class _RestaurantSettingsScreenState extends State<RestaurantSettingsScreen> {

   TextEditingController _restaurantNameController ;
   TextEditingController _addressController ;
   TextEditingController _phoneController ;

  final FocusNode _resNameNode = FocusNode();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  GlobalKey<FormState> _formKeyLogin;


   File file;
   final picker = ImagePicker();
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _restaurantNameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();

    _restaurantNameController.text = 'Parallax Restaurant';
    _addressController.text = '3460, Pallet Street, New York';
    _phoneController.text = '012345678';
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
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => Form(
            key: _formKeyLogin,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(
                      color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                      blurRadius: 5, spreadRadius: 1,
                    )],
                  ),
                  child: InkWell(
                    onTap: _choose,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: file == null
                              ? Image.asset(
                            Images.restaurant_image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                              : Image.file(file,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height/ 3.5,
                              fit: BoxFit.cover),
                        ),
                        Positioned(
                          bottom: -5,
                          right: 0,
                          child: InkWell(onTap: _choose,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Icon(Icons.camera_alt_outlined, size: 20, color: ColorResources.WHITE,),
                          )),
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
                  hintText: '012345678',
                  controller: _phoneController,
                  focusNode: _phoneNode,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.number,
                ),

                // for login button
                SizedBox(height: 50),
               CustomButton(
                  btnTxt: getTranslated('save', context),
                  backgroundColor: ColorResources.WHITE,
                  onTap: ()  {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RestaurantScreen()));
                  },
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
