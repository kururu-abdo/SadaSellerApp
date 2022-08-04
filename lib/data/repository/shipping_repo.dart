import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/shipping_model.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
class ShippingRepo{
  final DioClient dioClient;

  ShippingRepo({@required this.dioClient});


  Future<ApiResponse> getShipping() async {
    try {
      final response = await dioClient.get(AppConstants.SHOP_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getShippingMethod(String token) async {
    dioClient.dio.options.headers = {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'};

    try {
      final response = await dioClient.get('${AppConstants.GET_SHIPPING_URI}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> addShipping(ShippingModel shipping) async {
    try {
      final response = await dioClient.post(AppConstants.ADD_SHIPPING_URI,
          data: shipping);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> updateShipping(String title,String duration,double cost, int id) async {
    try {
      final response = await dioClient.post('${AppConstants.UPDATE_SHIPPING_URI}/$id',
          data: {'_method': 'put','title' : title, 'duration' : duration, 'cost' : cost});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> deleteShipping(int id) async {
    try {
      final response = await dioClient.delete('${AppConstants.DELETE_SHIPPING_URI}/$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCategoryWiseShippingMethod() async {
    try {
      final response = await dioClient.get('${AppConstants.SHOW_SHIPPING_COST_URI}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSelectedShippingMethodType() async {
    try {
      final response = await dioClient.get('${AppConstants.GET_SHIPPING_METHOD_TYPE_URI}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> setShippingMethodType( String type) async {
    try {
      final response = await dioClient.get('${AppConstants.SET_SHIPPING_METHOD_TYPE_URI}?shipping_type=$type');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> setCategoryWiseShippingCost(List<int >  ids, List<double> cost, List<int> multiPly) async {
    try {
      final response = await dioClient.post('${AppConstants.SET_CATEGORY_WISE_SHIPPING_COST_URI}',
          data: {'ids' : ids, 'cost' : cost, 'multiply_qty' : multiPly});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> assignThirdPartyDeliveryMan(String name,String trackingId, int orderId) async {
    try {
      final response = await dioClient.post('${AppConstants.THIRD_PARTY_DELIVERY_MAN_ASSIGN}',
          data: {'delivery_service_name' : name, 'third_party_delivery_tracking_id' : trackingId, 'order_id' : orderId});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}