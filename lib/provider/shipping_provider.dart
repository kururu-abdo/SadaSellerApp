import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/error_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/category_wise_shipping_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/shipping_model.dart';
import 'package:sixvalley_vendor_app/data/repository/shipping_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';

import 'auth_provider.dart';

class ShippingProvider extends ChangeNotifier {
  final ShippingRepo shippingRepo;
  ShippingProvider({@required this.shippingRepo});
  List<ShippingModel> _shippingList;
  List<ShippingModel> get  shippingList => _shippingList;
  int _shippingIndex;
  int get shippingIndex => _shippingIndex;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<AllCategoryShippingCost> _categoryWiseShipping;
  List<AllCategoryShippingCost> get categoryWiseShipping => _categoryWiseShipping;


  Future<void> getShippingList(BuildContext context, String token) async {
    _shippingIndex = null;
    ApiResponse apiResponse = await shippingRepo.getShippingMethod(token);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _shippingList = [];
      apiResponse.response.data.forEach((shippingMethod) => _shippingList.add(ShippingModel.fromJson(shippingMethod)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }


  Future addShippingMethod(ShippingModel shipping, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await shippingRepo.addShipping(shipping);

    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      callback(true, '');
      notifyListeners();
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
  }
  Future updateShippingMethod( String title,String duration,double cost, int id, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await shippingRepo.updateShipping(title,duration,cost,id);

    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      callback(true, '');
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
  }
  Future<void> deleteShipping(BuildContext context,int id) async {
    _isLoading = true;
    notifyListeners();
    print('-------$id');
    ApiResponse response = await shippingRepo.deleteShipping(id);
    if(response.response.statusCode == 200) {
      Navigator.pop(context);
      showCustomSnackBar(getTranslated('shipping_method_deleted_successfully', context),context, isError: false);
     getShippingList(context,Provider.of<AuthProvider>(context,listen: false).getUserToken());
    }else {
      ApiChecker.checkApi(context,response);
    }
    _isLoading = false;
    notifyListeners();
  }

  List<bool> _isMultiply = [];
  List<int> _isMultiplyInt = [];
  List<int> get isMultiplyInt =>_isMultiplyInt;
  List<bool> get isMultiply => _isMultiply;
  void toggleMultiply(BuildContext context, bool isOk, int index) {
    _isMultiply[index] = isOk;
    if(_isMultiply[index]){
      _isMultiplyInt[index] = 1;
    }else{
      _isMultiplyInt[index] = 0;
    }
    notifyListeners();

  }

  List<int> _ids =[];
  List<int> get ids => _ids;
  Future<void> getCategoryWiseShippingMethod(BuildContext context) async {
    ApiResponse apiResponse = await shippingRepo.getCategoryWiseShippingMethod();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _categoryWiseShipping =[];
      _isMultiply =[];
      _isMultiplyInt =[];
      _ids =[];
      _categoryWiseShipping.addAll(CategoryWiseShippingModel.fromJson(apiResponse.response.data).allCategoryShippingCost);
      apiResponse.response.data['all_category_shipping_cost'].forEach((isMulti) {

        AllCategoryShippingCost shippingCost = AllCategoryShippingCost.fromJson(isMulti);
        _ids.add(shippingCost.id);
        if(shippingCost.multiplyQty == 1){
          _isMultiply.add(true);
          _isMultiplyInt.add(1);
        }else{
          _isMultiply.add(false);
          _isMultiplyInt.add(0);
        }


      });
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  String _selectedShippingType ='';
  String get selectedShippingType =>_selectedShippingType;
  Future<void> getSelectedShippingMethodType(BuildContext context) async {
    ApiResponse apiResponse = await shippingRepo.getSelectedShippingMethodType();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _selectedShippingType = apiResponse.response.data['type'];
      Provider.of<SplashProvider>(context,listen: false).initShippingType(_selectedShippingType);
      // getSelectedShippingMethodType(context);
      print('selected shipping type=======> $_selectedShippingType');
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> setShippingMethodType(BuildContext context, String type) async {
    ApiResponse apiResponse = await shippingRepo.setShippingMethodType(type);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(getTranslated('shipping_method_updated_successfully', context)),
        backgroundColor: Colors.green,
      ));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();

  }

  Future<ApiResponse> setCategoryWiseShippingCost(BuildContext context, List<int >  ids, List<double> cost, List<int> multiPly) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await shippingRepo.setCategoryWiseShippingCost(ids, cost, multiPly);

    print('=====Update category cost ====>${_ids.toString()}===>${cost.toString()}===>${multiPly.toString()}');
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      getCategoryWiseShippingMethod(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(getTranslated('category_cost_updated_successfully', context)),
        backgroundColor: Colors.green,
      ));


    } else {
       ApiChecker.checkApi(context, apiResponse);

    }
    _isLoading = false;
    notifyListeners();
    return apiResponse;
  }

   List<TextEditingController> _shippingCostController = [];
   List<TextEditingController> get shippingCostController=>_shippingCostController;
   List<FocusNode> _shippingCostNode = [];
   List<FocusNode> get shippingCostNode=> _shippingCostNode;

  void setShippingCost(){
    _shippingCostController =[];
    _shippingCostNode =[];
    for(int i= 0; i<categoryWiseShipping.length; i++){
      categoryWiseShipping.forEach((categoryWiseShipping) {
        _shippingCostController.add(TextEditingController(text: categoryWiseShipping.cost.toString()?? 0.0)) ;
        _shippingCostNode.add(FocusNode()) ;

      });
    }
  }

  Future<ApiResponse> assignThirdPartyDeliveryMan(BuildContext context, String name,String trackingId, int orderId) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await shippingRepo.assignThirdPartyDeliveryMan(name, trackingId, orderId);

    print('=====Set third party shipping ====>${name.toString()}===>${trackingId.toString()}===>${orderId.toString()}');
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(getTranslated('third_party_delivery_type_successfully', context)),
        backgroundColor: Colors.green,
      ));
      _isLoading = false;
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    _isLoading = false;
    notifyListeners();
    return apiResponse;
  }


}