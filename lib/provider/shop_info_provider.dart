import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eamar_seller_app/data/model/response/base/api_response.dart';
import 'package:eamar_seller_app/data/model/response/response_model.dart';
import 'package:eamar_seller_app/data/model/response/shop_info_model.dart';
import 'package:eamar_seller_app/data/repository/shop_info_repo.dart';
import 'package:eamar_seller_app/helper/api_checker.dart';
import 'package:http/http.dart' as http;

class ShopProvider extends ChangeNotifier {
  final ShopRepo? shopRepo;

  ShopProvider({@required this.shopRepo});

  int? _selectedIndex = 0;
  int? get selectedIndex => _selectedIndex;

  updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  ShopModel? _shopModel;
  ShopModel? get shopModel => _shopModel;

  bool? _isLoading = false;
  bool? get isLoading => _isLoading;

  File? _file;

  File? get file => _file;
  final picker = ImagePicker();

  void choosePhoto() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    if (pickedFile != null) {
      _file = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    notifyListeners();
  }

  Future<ResponseModel> getShopInfo(BuildContext context) async {
    ResponseModel _responseModel;
    ApiResponse apiResponse = await shopRepo!.getShop();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _shopModel = ShopModel.fromJson(apiResponse.response!.data);
      _responseModel = ResponseModel(true, 'successful');
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      _responseModel = ResponseModel(false, _errorMessage);
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _responseModel;
  }

  Future<ResponseModel> updateShopInfo(
      ShopModel updateShopModel, File file, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response =
        await shopRepo!.updateShop(shopModel!, file, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      String message = 'Success';
      _shopModel = updateShopModel;
      responseModel = ResponseModel(true, message);
      print(message);
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel(
          false, '${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateBankInfo(
      ShopModel updateUserModel, File file, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response =
        await shopRepo!.updateShop(updateUserModel, file, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      String message = 'Success';
      _shopModel = updateUserModel;
      responseModel = ResponseModel(true, message);
      print(message);
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel(
        false,
        '${response.statusCode} ${response.reasonPhrase}',
      );
    }
    notifyListeners();
    return responseModel;
  }

  String getShopToken() {
    return shopRepo!.getShopToken();
  }
}
