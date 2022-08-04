import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/add_product_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/product_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/restaurant_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/restaurant_view_model.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:http/http.dart' as http;

class RestaurantRepo {
  final DioClient dioClient;
  RestaurantRepo({@required this.dioClient});

  Future<ApiResponse> getRestaurant() async {
    try {
      List<RestaurantModel> _restaurant = [
        RestaurantModel(image: Images.restaurant_image, id: 1, resName: 'Parallax Restaurant',location: 'Real Madrid, Spain', rating: '4.6', distance: '25', time: '9:30 am to 11:00 pm',availableTimeStarts: '10:30:00', availableTimeEnds: '2:30:00',discount: '20', description: 'description'),
      ];
      final response = Response(requestOptions: RequestOptions(path: ''), data: _restaurant, statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getPaymentView() async {
    try {
      List<RestaurantViewModel> _restaurantView = [
        RestaurantViewModel(id: 1, title: 'Pending Orders', item: 10 ),
        RestaurantViewModel(id: 2, title: 'Delivered', item: 7),
        RestaurantViewModel(id: 3, title: 'Return', item: 2),
        RestaurantViewModel(id: 4, title: 'Failed',item: 1),
      ];
      final response = Response(requestOptions: RequestOptions(path: ''), data: _restaurantView, statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getAttributeList(String languageCode) async {
    try {
      final response = await dioClient.get(AppConstants.ATTRIBUTE_URI,
        options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  Future<ApiResponse> getBrandList(String languageCode) async {
    try {
      final response = await dioClient.get(AppConstants.BRAND_URI,
        options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getEditProduct(int id) async {
    try {
      final response = await dioClient.get('${AppConstants.EDIT_PRODUCT_URI}/$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }

  }

  Future<ApiResponse> getCategoryList(String languageCode) async {
    try {
      final response = await dioClient.get(AppConstants.CATEGORY_URI,
        options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubCategoryList() async {
    try {
      final response = await dioClient.get('${AppConstants.CATEGORY_URI}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getSubSubCategoryList() async {
    try {
      final response = await dioClient.get('${AppConstants.CATEGORY_URI}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }

  }


  Future<ApiResponse> addImage(XFile image, String type) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.UPLOAD_PRODUCT_IMAGE_URI}',
    ));
    if(Platform.isAndroid || Platform.isIOS && image != null) {
      File _file = File(image.path);
      request.files.add(http.MultipartFile('image', _file.readAsBytes().asStream(), _file.lengthSync(), filename: _file.path.split('/').last));
    }
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'type': type,
    });
    request.fields.addAll(_fields);
    print('=====> ${request.url.path}\n'+request.fields.toString());
    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    print('=====Response body is here==>${res.body}');

    try {
      return ApiResponse.withSuccess(Response(statusCode: response.statusCode, requestOptions: null, statusMessage: response.reasonPhrase, data: res.body));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> addProduct(Product product, AddProductModel addProduct, Map<String, dynamic> attributes, List<String> productImages, String thumbnail, String metaImage, String token, bool isAdd, bool isActiveColor,) async {
    dioClient.dio.options.headers = {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'};
    Map<String, dynamic> _fields = Map();
    _fields.addAll(<String, dynamic>{
      'name': addProduct.titleList,
      'description': addProduct.descriptionList,
      'unit_price': product.unitPrice,
      'purchase_price': product.purchasePrice,
      'discount': product.discount,
      'discount_type': product.discountType,
      'tax': product.tax,
      'category_id': product.categoryIds[0].id,
      'unit': product.unit,
      'brand_id': product.brandId,
      'meta_title': product.metaTitle,
      'meta_description': product.metaDescription,
      'lang': addProduct.languageList,
      'colors':addProduct.colorCodeList,
      'images':productImages,
      'thumbnail':thumbnail,
      'colors_active': isActiveColor,
      'video_url': addProduct.videoUrl,
      'meta_image':metaImage,
      'current_stock':product.currentStock,
      'shipping_cost':product.shippingCost,
      'multiply_qty':product.multiplyWithQuantity

    });
    if(product.categoryIds.length > 1) {
      _fields.addAll(<String, dynamic> {'sub_category_id': product.categoryIds[1].id});
    }
    if(product.categoryIds.length > 2) {
      _fields.addAll(<String, dynamic> {'sub_sub_category_id': product.categoryIds[2].id});
    }
    if(!isAdd) {
      _fields.addAll(<String, dynamic> {'_method': 'put', 'id': product.id});
    }
    if(attributes.length > 0) {
      _fields.addAll(attributes);
    }

    print('==========Response Body======>$_fields');

    try {
      Response response = await dioClient.post('${AppConstants.BASE_URL}${isAdd ? AppConstants.ADD_PRODUCT_URI : '${AppConstants.UPDATE_PRODUCT_URI}/${product.id}'}',

          data: _fields,


      );
      return ApiResponse.withSuccess(response);

    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }





  Future<ApiResponse> deleteProduct(int productID) async {
    try {
      final response = await dioClient.post('${AppConstants.DELETE_PRODUCT_URI}/$productID',data: {
        '_method':'delete'
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }

  }





}