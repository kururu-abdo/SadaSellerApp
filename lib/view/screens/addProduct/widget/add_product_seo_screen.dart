
import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/data/model/response/add_product_model.dart';
import 'package:eamar_seller_app/data/model/response/product_model.dart';
import 'package:eamar_seller_app/helper/price_converter.dart';
import 'package:eamar_seller_app/localization/language_constrants.dart';
import 'package:eamar_seller_app/provider/auth_provider.dart';
import 'package:eamar_seller_app/provider/restaurant_provider.dart';
import 'package:eamar_seller_app/provider/splash_provider.dart';
import 'package:eamar_seller_app/provider/theme_provider.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/images.dart';
import 'package:eamar_seller_app/utill/styles.dart';
import 'package:eamar_seller_app/view/base/custom_app_bar.dart';
import 'package:eamar_seller_app/view/base/custom_button.dart';
import 'package:eamar_seller_app/view/base/custom_snackbar.dart';
import 'package:eamar_seller_app/view/base/textfeild/custom_text_feild.dart';

class AddProductSeoScreen extends StatefulWidget {
  final ValueChanged<bool> isSelected;
  final Product product;
  final String unitPrice;
  final String purchasePrice;
  final String discount;
  final String currentStock;
  final String tax;
  final String shippingCost;
  final String categoryId;
  final String subCategoryId;
  final String subSubCategoryId;
  final String brandyId;
  final String unit;



  final AddProductModel addProduct;
  AddProductSeoScreen({this.isSelected, @required this.product,@required this.addProduct,
    this.unitPrice, this.purchasePrice,
    this.tax, this.discount, this.currentStock,
    this.shippingCost, this.categoryId, this.subCategoryId, this.subSubCategoryId, this.brandyId, this.unit});

  @override
  _AddProductSeoScreenState createState() => _AddProductSeoScreenState();
}

class _AddProductSeoScreenState extends State<AddProductSeoScreen> {
  bool isSelected = false;
  String _unitValue;

  final FocusNode _seoTitleNode = FocusNode();
  final FocusNode _seoDescriptionNode = FocusNode();
  final FocusNode _youtubeLinkNode = FocusNode();
  final TextEditingController _seoTitleController = TextEditingController();
  final TextEditingController _seoDescriptionController = TextEditingController();
  final TextEditingController _youtubeLinkController = TextEditingController();
  AutoCompleteTextField searchTextField;


  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;
  bool _update;
  Product _product;
  AddProductModel _addProduct;
  String thumbnailImage ='', metaImage ='';
  List<String> productImage =[];
  int counter = 0, total = 0;
  int addColor = 0;


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _product = widget.product;
    _update = widget.product != null;
    _addProduct = widget.addProduct;
    if(_update) {
      Provider.of<RestaurantProvider>(context,listen: false).getEditProduct(context, widget.product.id);
      _seoTitleController.text = _product.metaTitle;
      _seoDescriptionController.text = _product.metaDescription;
      Provider.of<RestaurantProvider>(context, listen: false).setDiscountTypeIndex(_product.discountType == 'percent' ? 0 : 1, false);
      thumbnailImage = _product.thumbnail;
      metaImage = _product.metaImage;
      productImage = _product.images;
      _unitValue = _product.unit.toString();

    }else {
      _product = Product();
      _addProduct = AddProductModel();


    }
    super.initState();
  }



  route(bool isRoute, String name, String type) async {
    if (isRoute) {
      if(_update){
        if(thumbnailImage=='' && metaImage ==''){
          total = Provider.of<RestaurantProvider>(context,listen: false).productImage.length;
        }else if(productImage.length == 0 && metaImage ==''){
          total = 1;
        }else if(thumbnailImage=='' && productImage.length == 0 && metaImage ==''){
          total = 0;
        }else if(thumbnailImage=='' && productImage.length == 0){
          total = 1;
        }
      }
      if(type == 'meta'){metaImage = name;}
      else if(type == 'thumbnail'){thumbnailImage = name;}
      else{
        productImage.add(name);
      }
      counter++;

      if(metaImage ==''){
        total = Provider.of<RestaurantProvider>(context,listen: false).productImage.length + 1;
      }else{

        total = Provider.of<RestaurantProvider>(context,listen: false).productImage.length + 2;
      }
      if(counter == total) {
        counter++;
        Provider.of<RestaurantProvider>(context,listen: false).addProduct(context, _product, _addProduct, productImage, thumbnailImage, metaImage, Provider.of<AuthProvider>(context,listen: false).getUserToken(),!_update,Provider.of<RestaurantProvider>(context,listen: false).attributeList[0].active);
      }
    } else {
      print('Image upload problem');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title:  widget.product != null ?
      getTranslated('update_product', context):
      getTranslated('add_product', context),),
      body: SafeArea(child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
          child: Consumer<RestaurantProvider>(
            builder: (context, resProvider, child){

             int xyz = resProvider.productImage.length;
             int spaceCount =1;

             for(int i=0; i< xyz; i+=4){
               spaceCount++;
             }


              return SingleChildScrollView(
                child: (resProvider.attributeList != null &&
                    resProvider.attributeList.length > 0 &&
                    resProvider.categoryList != null &&
                    Provider.of<SplashProvider>(context,listen: false).colorList!= null) ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                          child: Text(getTranslated('product_seo_settings', context),
                              style: robotoBold.copyWith(color: ColorResources.getHeadTextColor(context),
                              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Text(getTranslated('meta_title', context),
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                    CustomTextField(
                      border: true,
                      textInputType: TextInputType.name,
                      focusNode: _seoTitleNode,
                      controller: _seoTitleController,
                      nextNode: _seoDescriptionNode,
                      textInputAction: TextInputAction.next,
                      hintText: getTranslated('meta_title', context),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Text(getTranslated('meta_description', context),
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    CustomTextField(
                      isDescription:true,
                      border: true,
                      controller: _seoDescriptionController,
                      focusNode: _seoDescriptionNode,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.multiline,
                      maxLine: 3,
                      hintText: getTranslated('meta_description_hint', context),

                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),


                    Text(getTranslated('youtube_video_link', context),
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    CustomTextField(
                      textInputType: TextInputType.text,
                      controller: _youtubeLinkController,
                      focusNode: _youtubeLinkNode,
                      textInputAction: TextInputAction.done,
                      hintText: 'https://www.youtube.com/embed/HHE7patgw7U',

                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),



                    Text(getTranslated('meta_image', context),
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Align(alignment: Alignment.center, child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                        child: resProvider.pickedMeta != null? Image.file(
                          File(resProvider.pickedMeta.path), width: 150, height: 120, fit: BoxFit.cover,
                        ) :widget.product!=null? FadeInImage.assetNetwork(
                          placeholder: Images.placeholder_image,
                          image: '${Provider.of<SplashProvider>(context).configModel.
                          baseUrls.productImageUrl}/meta/${_product.metaImage != null ? _product.metaImage : ''}',
                          height: 120, width: 150, fit: BoxFit.cover,
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, height: 120,
                              width: 150, fit: BoxFit.cover),
                        ):Image.asset(Images.placeholder_image, height: 120,
                            width: 150, fit: BoxFit.cover),
                      ),
                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => resProvider.pickImage(false,true, false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                              border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.camera_alt, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ])),


                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                    Text(getTranslated('thumbnail', context),
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),




                    Align(alignment: Alignment.center, child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                        child: resProvider.pickedLogo != null ?  Image.file(File(resProvider.pickedLogo.path),
                          width: 150, height: 120, fit: BoxFit.cover,
                        ) :widget.product!=null? FadeInImage.assetNetwork(
                          placeholder: Images.placeholder_image,
                          image: '${Provider.of<SplashProvider>(context).configModel.
                          baseUrls.productThumbnailUrl}/${_product.thumbnail != null ? _product.thumbnail : ''}',
                          height: 120, width: 150, fit: BoxFit.cover,
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image,
                              height: 120, width: 150, fit: BoxFit.cover),
                        ):Image.asset(Images.placeholder_image,height: 120,
                          width: 150, fit: BoxFit.cover,),
                      ),
                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => resProvider.pickImage(true,false, false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                              border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.camera_alt, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ])),



                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    Text(getTranslated('product_image', context),
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),


                    ConstrainedBox(
                        constraints: resProvider.productImage.length >= 4?
                        BoxConstraints(maxHeight: (double.parse(spaceCount.toString()))* MediaQuery.of(context).size.width/4):
                        BoxConstraints(maxHeight: MediaQuery.of(context).size.width/4.3),
                        child: StaggeredGridView.countBuilder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: resProvider.productImage.length + 1,
                          crossAxisCount: 4,
                          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                          itemBuilder: (BuildContext context, index){
                          return index == resProvider.productImage.length ?
                          GestureDetector(
                            onTap: ()=> resProvider.pickImage(false, false, false),
                            child: Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                child:  Image.asset(Images.placeholder_image, height: MediaQuery.of(context).size.width/4.3,
                                    width: MediaQuery.of(context).size.width/4.3, fit: BoxFit.cover),
                              ),
                              Positioned(bottom: 0, right: 0, top: 0, left: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                    border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2, color: Colors.white),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.add, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                            ),
                          ) :
                          Stack(children: [
                            Container(child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT)),
                              child: Image.file(File(resProvider.productImage[index].path),
                                width: MediaQuery.of(context).size.width/4.3,
                                height: MediaQuery.of(context).size.width/4.3,
                                fit: BoxFit.cover,),) ,
                              decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20)),),),
                            Positioned(top:0,right:0,
                              child: InkWell(onTap :() => resProvider.removeImage(index),
                                child: Container(decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Icon(Icons.delete_forever_rounded,color: Colors.red,size: 15,),)),
                              ),
                            ),
                          ],
                          );

                        }, mainAxisSpacing: 3,crossAxisSpacing: 3, )

                    ),

                    SizedBox(height: 25,),

                  ],):Padding(
                  padding: const EdgeInsets.only(top: 300.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            },

          ),
        ),
      ),),
      bottomNavigationBar: Consumer<RestaurantProvider>(
        builder: (context, resProvider, _) {
          return Container(height: 80,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200],
                  spreadRadius: 0.5, blurRadius: 0.3)],
            ),
            child: !resProvider.isLoading ?
          CustomButton(
            btnTxt: _update ? getTranslated('update',context) : getTranslated('submit', context),
            onTap: (){

              String _seoDescription = _seoDescriptionController.text.trim();
              String _seoTitle = _seoTitleController.text.trim();
              String _unit = widget.unit;
              String _brandId = widget.brandyId;
              String _metaTitle =_seoTitleController.text.trim();
              String _metaDescription =_seoDescriptionController.text.trim();
              String _videoUrl = _youtubeLinkController.text.trim();
              String _multiPlyWithQuantity = resProvider.isMultiply?'1':'0';
              int _multi = int.parse(_multiPlyWithQuantity);




              List<String> titleList = [];
              List<String> descriptionList = [];
              Provider.of<RestaurantProvider>(context,listen: false).titleControllerList.forEach((title) {
                titleList.add(title.text.trim());});
              Provider.of<RestaurantProvider>(context,listen: false).descriptionControllerList.forEach((description) {
                descriptionList.add(description.text.trim());});




              if (!_update && resProvider.pickedLogo == null) {
                showCustomSnackBar(getTranslated('upload_thumbnail_image',context),context);
              }else if (!_update && resProvider.productImage.length == 0) {
                showCustomSnackBar(getTranslated('upload_product_image',context),context);
              }


              else {
                _addProduct = AddProductModel();
                _addProduct.titleList = titleList;
                _addProduct.descriptionList = descriptionList;
                _addProduct.videoUrl = _videoUrl;
                _product.tax = double.parse(widget.tax);
                _product.unitPrice = PriceConverter.systemCurrencyToDefaultCurrency(double.parse(widget.unitPrice), context);
                _product.purchasePrice = PriceConverter.systemCurrencyToDefaultCurrency(double.parse(widget.purchasePrice), context);
                _product.discount = resProvider.discountTypeIndex == 0 ?
                double.parse(widget.discount) : PriceConverter.systemCurrencyToDefaultCurrency(double.parse(widget.discount), context);
                _product.unit = _unit;
                _product.shippingCost = PriceConverter.systemCurrencyToDefaultCurrency(double.parse(widget.shippingCost), context);
                _product.multiplyWithQuantity = _multi;
                _product.brandId = int.parse(_brandId);
                _product.metaTitle = _metaTitle;
                _product.metaDescription = _metaDescription;
                _product.currentStock = int.parse(widget.currentStock);
                _product.metaTitle = _seoTitle;
                _product.metaDescription = _seoDescription;
                _product.discountType = resProvider.discountTypeIndex == 0 ? 'percent' : 'flat';
                _product.categoryIds = [];
                _product.categoryIds.add(CategoryIds(id: widget.categoryId));

                if (resProvider.subCategoryIndex != 0) {
                  _product.categoryIds.add(CategoryIds(
                      id: widget.subCategoryId));}

                if (resProvider.subSubCategoryIndex != 0) {
                  _product.categoryIds.add(CategoryIds(
                      id: widget.subSubCategoryId));}

                _addProduct.colorCodeList =[];
                if(resProvider.colorCodeList != null){
                  _addProduct.colorCodeList.addAll(resProvider.colorCodeList);
                }

                _addProduct.languageList = [];
                if(Provider.of<SplashProvider>(context, listen:false).configModel.languageList!=null &&
                    Provider.of<SplashProvider>(context, listen:false).configModel.languageList.length>0){
                  for(int i=0; i<Provider.of<SplashProvider>(context, listen:false).
                  configModel.languageList.length;i++){
                    _addProduct.languageList.insert(i,
                        Provider.of<SplashProvider>(context, listen:false).configModel.languageList[i].code) ;
                  }

                }


                if(_update){
                  if(resProvider.pickedLogo == null && resProvider.pickedMeta == null &&
                      resProvider.productImage.length == 0 || resProvider.productImage == null ){
                    Provider.of<RestaurantProvider>(context,listen: false).addProduct(context,
                        _product, _addProduct, productImage, thumbnailImage, metaImage,
                        Provider.of<AuthProvider>(context,listen: false).getUserToken(),
                        !_update,Provider.of<RestaurantProvider>(context,listen: false).attributeList[0].active);
                  } else{

                    if(resProvider.pickedLogo != null){
                      resProvider.addProductImage(resProvider.pickedLogo,'thumbnail', route);
                    }

                    if(resProvider.pickedMeta != null){
                      resProvider.addProductImage(resProvider.pickedMeta,'meta', route);
                    }

                    if(resProvider.productImage != null && resProvider.productImage.length > 0){
                      for(int i =0; i<resProvider.productImage.length;i++)
                      {
                        resProvider.addProductImage(resProvider.productImage[i],'product', route);
                      }
                    }

                  }


                }
                if(resProvider.pickedLogo != null){
                  resProvider.addProductImage(resProvider.pickedLogo,'thumbnail', route);
                }

                if(resProvider.pickedMeta != null){
                  resProvider.addProductImage(resProvider.pickedMeta,'meta', route);
                }

                if(resProvider.productImage != null){
                  for(int i =0; i<resProvider.productImage.length;i++)
                  {
                    resProvider.addProductImage(resProvider.productImage[i],'product', route);
                  }
                }

              }



            },
          ):Center(child: CircularProgressIndicator()),);
        }
      ),
    );
  }
}
