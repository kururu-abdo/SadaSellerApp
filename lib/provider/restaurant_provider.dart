import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:joseeder_seller/data/model/response/add_product_model.dart';
import 'package:joseeder_seller/data/model/response/attr.dart';
import 'package:joseeder_seller/data/model/response/attribute_model.dart';
import 'package:joseeder_seller/data/model/response/base/api_response.dart';
import 'package:joseeder_seller/data/model/response/base/error_response.dart';
import 'package:joseeder_seller/data/model/response/brand_model.dart';
import 'package:joseeder_seller/data/model/response/category_model.dart';
import 'package:joseeder_seller/data/model/response/config_model.dart';
import 'package:joseeder_seller/data/model/response/edt_product_model.dart';
import 'package:joseeder_seller/data/model/response/product_model.dart';
import 'package:joseeder_seller/data/model/response/restaurant_model.dart';
import 'package:joseeder_seller/data/model/response/restaurant_view_model.dart';
import 'package:joseeder_seller/data/model/response/variant_type_model.dart';
import 'package:joseeder_seller/data/repository/restaurant_repo.dart';
import 'package:joseeder_seller/helper/api_checker.dart';
import 'package:joseeder_seller/helper/price_converter.dart';
import 'package:joseeder_seller/localization/language_constrants.dart';
import 'package:joseeder_seller/provider/product_provider.dart';
import 'package:joseeder_seller/provider/profile_provider.dart';
import 'package:joseeder_seller/provider/splash_provider.dart';
import 'package:joseeder_seller/view/base/custom_snackbar.dart';
import 'package:joseeder_seller/view/screens/dashboard/dashboard_screen.dart';

import 'localization_provider.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantRepo restaurantRepo;

  RestaurantProvider({@required this.restaurantRepo});

  List<RestaurantModel> _restaurant;
  List<RestaurantModel> get restaurant => _restaurant;
  int _totalQuantity =0;
  int get totalQuantity => _totalQuantity;
  String _unitValue;
  String get unitValue => _unitValue;


  List<RestaurantViewModel> _restaurantViewList;
  List<RestaurantViewModel> get restaurantViewList => _restaurantViewList;

  List<AttributeModel> _attributeList = [];
  int _discountTypeIndex = 0;
  List<CategoryModel> _categoryList;
  List<BrandModel> _brandList;
  List<SubCategory> _subCategoryList;
  List<SubSubCategory> _subSubCategoryList;
  int _categorySelectedIndex;
  int _subCategorySelectedIndex;
  int _subSubCategorySelectedIndex;
  int _categoryIndex = 0;
  int _subCategoryIndex = 0;
  int _subSubCategoryIndex = 0;
  int _brandIndex = 0;
  int _unitIndex = 0;
  int get unitIndex => _unitIndex;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int get categorySelectedIndex => _categorySelectedIndex;
  int get subCategorySelectedIndex => _subCategorySelectedIndex;
  int get subSubCategorySelectedIndex => _subSubCategorySelectedIndex;
  List<int> _selectedColor = [];
  List<int> get selectedColor =>_selectedColor;

  List<int> _categoryIds = [];
  List<int> _subCategoryIds = [];
  List<int> _subSubCategoryIds = [];
  List<int> get categoryIds => _categoryIds;
  List<int> get subCategoryIds => _subCategoryIds;
  List<int> get subSubCategoryIds => _subSubCategoryIds;




  EditProduct _editProduct;
  EditProduct get editProduct => _editProduct;
  List<VariantTypeModel> _variantTypeList =[];
  List<AttributeModel> get attributeList => _attributeList;
  int get discountTypeIndex => _discountTypeIndex;
  List<CategoryModel> get categoryList => _categoryList;
  List<SubCategory> get subCategoryList => _subCategoryList;
  List<SubSubCategory> get subSubCategoryList => _subSubCategoryList;
  List<BrandModel> get brandList => _brandList;
  XFile _pickedLogo;
  XFile _pickedCover;
  XFile _pickedMeta;
  XFile _coveredImage;
  List <XFile>_productImage = [];
  XFile get pickedLogo => _pickedLogo;
  XFile get pickedCover => _pickedCover;
  XFile get pickedMeta => _pickedMeta;
  XFile get coveredImage => _coveredImage;
  List<XFile> get productImage => _productImage;
  int get categoryIndex => _categoryIndex;
  int get subCategoryIndex => _subCategoryIndex;
  int get subSubCategoryIndex => _subSubCategoryIndex;
  int get brandIndex => _brandIndex;
  List<VariantTypeModel> get variantTypeList => _variantTypeList;
  final picker = ImagePicker();
  List<TextEditingController> _titleControllerList = [];
  List<TextEditingController> _descriptionControllerList = [];
  List<String> _colorCodeList =[];
  List<String> get colorCodeList => _colorCodeList;

  List<TextEditingController>  get titleControllerList=> _titleControllerList;
  List<TextEditingController> get descriptionControllerList=> _descriptionControllerList;

  List<FocusNode> _titleNode;
  List<FocusNode> _descriptionNode;
  List<FocusNode> get titleNode => _titleNode;
  List<FocusNode> get descriptionNode => _descriptionNode;

  void setTitle(int index, String title) {
    _titleControllerList[index].text = title;
  }
  void setDescription(int index, String description) {
    _descriptionControllerList[index].text = description;
  }


  getTitleAndDescriptionList(List<Language> languageList, EditProduct edtProduct){

    _titleControllerList = [];
    _descriptionControllerList = [];
    for(int i= 0; i<languageList.length; i++){

      if(edtProduct != null){

        if(i==0){
          _titleControllerList.insert(i,TextEditingController(text: edtProduct.name)) ;
          _descriptionControllerList.add(TextEditingController(text: edtProduct.details)) ;
        } else{
          edtProduct.translations.forEach((lan) {

            if(lan.locale == languageList[i].code && lan.key == 'name'){
              _titleControllerList.add(TextEditingController(text: lan.value)) ;

            }
            if(lan.locale == languageList[i].code && lan.key == 'description'){
              _descriptionControllerList.add(TextEditingController(text: lan.value));
            }
          });

        }

      }
      else{
        _titleControllerList.add(TextEditingController());
        _descriptionControllerList.add(TextEditingController());

      }
    }
    if(edtProduct != null){
      if(_titleControllerList.length < languageList.length) {
        int _l = languageList.length-_titleControllerList.length;
        for(int i=0; i<_l; i++) {
          _titleControllerList.add(TextEditingController(text: editProduct.name));
        }
      }
      if(_descriptionControllerList.length < languageList.length) {
        int _l = languageList.length-_descriptionControllerList.length;
        for(int i=0; i<_l; i++) {
          _descriptionControllerList.add(TextEditingController(text: editProduct.details));
        }
      }
    }else {
      if(_titleControllerList.length < languageList.length) {
        int _l = languageList.length-_titleControllerList.length;
        for(int i=0; i<_l; i++) {
          _titleControllerList.add(TextEditingController());
        }
      }
      if(_descriptionControllerList.length < languageList.length) {
        int _l = languageList.length-_descriptionControllerList.length;
        for(int i=0; i<_l; i++) {
          _descriptionControllerList.add(TextEditingController());
        }
      }
    }
  }

  Future<void> getRestaurant(BuildContext context) async {
    if(_restaurant == null ){
      ApiResponse apiResponse = await restaurantRepo.getRestaurant();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _restaurant = [];
        apiResponse.response.data.forEach((restaurant) => _restaurant.add(restaurant));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  void getAttributeList(BuildContext context, Product product, String language) async {
    _attributeList = null;
    _discountTypeIndex = 0;
    _categoryIndex = 0;
    _subCategoryIndex = 0;
    _subSubCategoryIndex = 0;
    _pickedLogo = null;
    _pickedMeta = null;
    _pickedCover = null;
    _selectedColor = [];
    _variantTypeList = [];
    ApiResponse response = await restaurantRepo.getAttributeList(language);
    if (response.response != null && response.response.statusCode == 200) {
      _attributeList = [];
      _attributeList.add(AttributeModel(attribute: Attr(id : 0, name:'ColorX'), active: false,
          controller: TextEditingController(), variants: []));
      response.response.data.forEach((attribute) {
        if (product != null && product.attributes!=null) {
          bool _active = product.attributes.contains(Attr.fromJson(attribute).id);
          List<String> _options = [];
          if (_active) {
            _options.addAll(product.choiceOptions[product.attributes.indexOf(Attr.fromJson(attribute).id)].options);
          }
          _attributeList.add(AttributeModel(
            attribute: Attr.fromJson(attribute),
            active: product.attributes.contains(Attr.fromJson(attribute).id),
            controller: TextEditingController(), variants: _options,
          ));
        } else {
          _attributeList.add(
              AttributeModel(attribute: Attr.fromJson(attribute), active: false,
                controller: TextEditingController(), variants: [],
              ));
        }
      });




    } else {
      ApiChecker.checkApi(context, response);
    }
   notifyListeners();

  }


  void setAttributeItemList(int index){
    _attributeList[index].active = true;


  }

  void removeImage(int index){
    productImage.removeAt(index);
    notifyListeners();
  }


  void setAttribute(){
    _attributeList[0].active = true;
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  void toggleAttribute(BuildContext context,int index, Product product) {
    _attributeList[index].active = !_attributeList[index].active;
    generateVariantTypes(context,product);
    notifyListeners();

  }
  bool _isMultiply = false;
  bool get isMultiply => _isMultiply;
  void toggleMultiply(BuildContext context) {
    _isMultiply = !_isMultiply;
    notifyListeners();

  }

  void addVariant(BuildContext context, int index, String variant, Product product, bool notify) {
    _attributeList[index].variants.add(variant);
    generateVariantTypes(context,product);
    if(notify) {
      notifyListeners();
    }
  }
  void  addColorCode(String colorCode){
    _colorCodeList.add(colorCode);
    notifyListeners();

  }
  void removeColorCode(int index){
    _colorCodeList.removeAt(index);
    notifyListeners();
  }

  void removeVariant(BuildContext context,int mainIndex, int index, Product product) {
    _attributeList[mainIndex].variants.removeAt(index);
    generateVariantTypes(context, product);
    notifyListeners();
  }


  Future<void> getBrandList(BuildContext context, String language) async {
    ApiResponse response = await restaurantRepo.getBrandList(language);
    if (response.response.statusCode == 200) {
      _brandList = [];
      response.response.data.forEach((brand) => _brandList.add(BrandModel.fromJson(brand)));
    } else {
      ApiChecker.checkApi(context,response);
    }

    notifyListeners();

  }


  Future<void> getCategoryList(BuildContext context, Product product, String language) async {
    _categoryIds =[];
    _subCategoryIds =[];
    _subSubCategoryIds =[];
    _categoryIds.add(0);
    _subCategoryIds.add(0);
    _subSubCategoryIds.add(0);

    _categoryIndex = 0;
    _colorCodeList =[];
    ApiResponse response = await restaurantRepo.getCategoryList(language);
    if (response.response != null && response.response.statusCode == 200) {
      _categoryList = [];
      response.response.data.forEach((category) => _categoryList.add(CategoryModel.fromJson(category)));
      _categoryIndex = 0;

      for(int index = 0; index < _categoryList.length; index++) {
        _categoryIds.add(_categoryList[index].id);
      }

      if(product != null){
        setCategoryIndex(_categoryIds.indexOf(int.parse(product.categoryIds[0].id)), false);
        getSubCategoryList(context,_categoryIds.indexOf(int.parse(product.categoryIds[0].id)), false, product);
        if (_subCategoryList != null) {
          for (int index = 0; index < _subCategoryList.length; index++) {
            _subCategoryIds.add(_subCategoryList[index].id);
          }

          if(product.categoryIds.length>1){
            setSubCategoryIndex(_subCategoryIds.indexOf(int.parse(product.categoryIds[1].id)), false);
            getSubSubCategoryList(context, _subCategoryIds.indexOf(int.parse(product.categoryIds[1].id)), false);

          }
        }

        if (_subSubCategoryList != null) {
          for (int index = 0; index < _subSubCategoryList.length; index++) {
            _subSubCategoryIds.add(_subSubCategoryList[index].id);
          }
          if(product.categoryIds.length>2){
            setSubSubCategoryIndex(_subSubCategoryIds.indexOf(int.parse(product.categoryIds[2].id)), false);
            setSubSubCategoryIndex(_subSubCategoryIds.indexOf(int.parse(product.categoryIds[2].id)), false);
          }
        }
      }



    } else {
      ApiChecker.checkApi(context,response);
    }
    notifyListeners();
  }



  Future<void> getSubCategoryList(BuildContext context, int selectedIndex, bool notify, Product product) async {

    _subCategoryIndex = 0;
    if(categoryIndex != 0) {
      _subCategoryList = [];
      _subCategoryList.addAll(_categoryList[categoryIndex-1].subCategories);
    }
    if(notify){
      _subCategoryIds = [];
      _subCategoryIds.add(0);
      _subCategoryIndex = 0;
      _subSubCategoryIds = [];
      _subSubCategoryIds.add(0);
      _subSubCategoryIndex = 0;
      _subCategoryList.forEach((element) {
        _subCategoryIds.add(element.id);
      });
      notifyListeners();
    }

  }

  Future<void> getEditProduct(BuildContext context,int id) async {
    _editProduct = null;
    ApiResponse response = await restaurantRepo.getEditProduct(id);
    if (response.response != null && response.response.statusCode == 200) {
      _editProduct = EditProduct.fromJson(response.response.data);
      getTitleAndDescriptionList(Provider.of<SplashProvider>(context,listen: false).configModel.languageList, _editProduct);
    } else {
      ApiChecker.checkApi(context,response);
    }
    notifyListeners();
  }



  Future<void> getSubSubCategoryList(BuildContext context,int selectedIndex, bool notify) async {
    _subSubCategoryIndex = 0;
    if(_subCategoryIndex != 0) {
      _subSubCategoryList = [];
      _subSubCategoryList.addAll(subCategoryList[_subCategoryIndex-1].subSubCategories);
    }
    if(notify){
      _subSubCategoryIds = [];
      _subSubCategoryIds.add(0);
      _subSubCategoryIndex = 0;
      _subSubCategoryList.forEach((element) {
        _subSubCategoryIds.add(element.id);
      });
      notifyListeners();
    }

  }

  void pickImage(bool isLogo,bool isMeta, bool isRemove) async {
    print('======>Again=====>');
    if(isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
      _pickedMeta = null;
      _coveredImage = null;
      _productImage = [];
    }else {
      if (isLogo) {
        _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);

      } else if(isMeta){
        _pickedMeta = await ImagePicker().pickImage(source: ImageSource.gallery);

      }else {
          _coveredImage = await ImagePicker().pickImage(source: ImageSource.gallery);
          if (_coveredImage != null) {
           _productImage.add(_coveredImage);

          }
      }
    }

    notifyListeners();

  }

  void setSelectedColorIndex(int index, bool notify) {
    if(!_selectedColor.contains(index)) {
      _selectedColor.add(index);
      if(notify) {
        notifyListeners();
      }
    }notifyListeners();
  }


  void setBrandIndex(int index, bool notify) {
    _brandIndex = index;
    if(notify) {
      notifyListeners();
    }
  }
  void setUnitIndex(int index, bool notify) {
    _unitIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  void setCategoryIndex(int index, bool notify) {
    _categoryIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  void setSubCategoryIndex(int index, bool notify) {
    _subCategoryIndex = index;
    if(notify) {
      notifyListeners();
    }
  }
  void setSubSubCategoryIndex(int index, bool notify) {
    _subSubCategoryIndex = index;
    if(notify) {
      notifyListeners();
    }
  }



  Future addProductImage(XFile pickedLogo,String type, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await restaurantRepo.addImage( pickedLogo, type);
    if(response.response != null && response.response.statusCode == 200) {
      _isLoading = false;

      Map map = jsonDecode(response.response.data);
      String name = map["image_name"];
      String type = map["type"];
      callback(true, name, type);
      notifyListeners();
    }else {
      _isLoading = false;
      String errorMessage;
      if (response.error is String) {
        print(response.error.toString());
        errorMessage = response.error.toString();
      } else {
        ErrorResponse errorResponse = response.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage, '');
      _isLoading = false;
      notifyListeners();
    }


  }




  Future<void> addProduct(BuildContext context, Product product, AddProductModel addProduct, List<String> productImages, String thumbnail, String metaImage, String token, bool isAdd,bool isActiveColor) async {
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> _fields = Map();
    if(_variantTypeList.length > 0) {
      List<int> _idList = [];
      List<String> _nameList = [];
      _attributeList.forEach((attributeModel) {
        if(attributeModel.active) {
          if(attributeModel.attribute.id != 0) {
            _idList.add(attributeModel.attribute.id);
            _nameList.add(attributeModel.attribute.name);
          }
          List<String> _variantString = [];
          attributeModel.variants.forEach((variant) {
            _variantString.add(variant);
          });
          _fields.addAll(<String, dynamic>{'choice_options_${attributeModel.attribute.id}': _variantString});
        }
      });
      _fields.addAll(<String, dynamic> {
        'choice_attributes': _idList, 'choice_no': _idList, 'choice': _nameList
      });

      for(int index=0; index<_variantTypeList.length; index++) {
        _fields.addAll(<String, dynamic> {'price_${_variantTypeList[index].variantType}': PriceConverter.systemCurrencyToDefaultCurrency(double.parse(_variantTypeList[index].controller.text), context)});
        _fields.addAll(<String, dynamic> {'qty_${_variantTypeList[index].variantType}': int.parse(_variantTypeList[index].qtyController.text)});
        _fields.addAll(<String, dynamic> {'sku_${_variantTypeList[index].variantType}': ""});

        _totalQuantity += int.parse(_variantTypeList[index].qtyController.text);

      }
      print('=====Total Quantity======>$_totalQuantity');
    }
    ApiResponse response = await restaurantRepo.addProduct(product,addProduct ,_fields, productImages, thumbnail, metaImage, token, isAdd, isActiveColor);
    if(response.response != null && response.response.statusCode == 200) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashboardScreen()), (route) => false);
      showCustomSnackBar(isAdd ? getTranslated('product_added_successfully', context): getTranslated('product_updated_successfully', context),context, isError: false);
       titleControllerList.clear();
      descriptionControllerList.clear();
      _pickedLogo = null;
      _pickedCover = null;
      _coveredImage =null;
      _productImage = [];
      _isLoading = false;
        }else {
      String errorMessage;
      if (response.error is String) {
        print(response.error.toString());
        errorMessage = response.error.toString();
      } else {
        ErrorResponse errorResponse = response.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      showCustomSnackBar(errorMessage.toString(),context);
      _isLoading = false;
      titleControllerList.clear();
      descriptionControllerList.clear();
      _productImage = [];
    }

    notifyListeners();
    _isLoading = false;
  }

  Future<void> deleteProduct(BuildContext context, int productID) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await restaurantRepo.deleteProduct(productID);
    if(response.response.statusCode == 200) {
      Provider.of<ProductProvider>(context,listen: false).initSellerProductList(Provider.of<ProfileProvider>(context,listen: false).
      userInfoModel.id.toString(), 1,context, Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode == 'US'?'en':
      Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode, reload: true);

      Provider.of<ProductProvider>(context,listen: false).getStockOutProductList(1, context, 'en');
      Navigator.pop(context);
      showCustomSnackBar(getTranslated('product_deleted_successfully', context),context, isError: false);

    }else {
      ApiChecker.checkApi(context,response);
    }
    notifyListeners();
  }

  void generateVariantTypes(BuildContext context, Product product) {
    List<List<String>> _mainList = [];
    int _length = 1;
    bool _hasData = false;
    List<int> _indexList = [];
    _variantTypeList = [];
    _attributeList.forEach((attribute) {
      if(attribute.active) {
        _hasData = true;
        _mainList.add(attribute.variants);
        _length = _length * attribute.variants.length;
        _indexList.add(0);
      }
    });
    if(!_hasData) {
      _length = 0;
    }
    for(int i=0; i<_length; i++) {
      String _value = '';
      for(int j=0; j<_mainList.length; j++) {
        _value = _value + '${_value.isEmpty ? '' : '-'}' + _mainList[j][_indexList[j]].trim();
      }
      if(product != null) {
        double _price = 0;
        int _quantity = 0;
        for(Variation variation in product.variation) {
          if(variation.type == _value) {
            _price = variation.price;
            _quantity = variation.qty;
            break;
          }
        }
        _variantTypeList.add(VariantTypeModel(
          variantType: _value, controller: TextEditingController(text: _price > 0 ? PriceConverter.convertPriceWithoutSymbol(context,_price) : ''), node: FocusNode(),
          qtyController: TextEditingController(text: _quantity.toString()), qtyNode: FocusNode(),
        ));
      }else {
        _variantTypeList.add(VariantTypeModel(variantType: _value, controller: TextEditingController(), node: FocusNode(),qtyController: TextEditingController(),qtyNode: FocusNode()));
      }


      for(int j=0; j<_mainList.length; j++) {
        if(_indexList[_indexList.length-(1+j)] < _mainList[_mainList.length-(1+j)].length-1) {
          _indexList[_indexList.length-(1+j)] = _indexList[_indexList.length-(1+j)] + 1;
          break;
        }else {
          _indexList[_indexList.length-(1+j)] = 0;
        }
      }
    }
  }

  bool hasAttribute() {
    bool _hasData = false;
    for(AttributeModel attribute in _attributeList) {
      if(attribute.active) {
        _hasData = true;
        break;
      }
    }
    return _hasData;
  }

  void setValueForUnit (String setValue){
    print('------$setValue====$_unitValue');
    _unitValue = setValue;
    // notifyListeners();
  }

}
