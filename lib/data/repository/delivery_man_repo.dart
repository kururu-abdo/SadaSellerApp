import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class DeliveryManRepo {
  final DioClient dioClient;
  DeliveryManRepo({@required this.dioClient});

  Future<ApiResponse> getDeliveryManList() async {
    try {
      final response = await dioClient.get(AppConstants.GET_DELIVERY_MAN_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> assignDeliveryMan(int orderId, int deliveryManId) async {
    try {
      final response = await dioClient.post(AppConstants.ASSIGN_DELIVERY_MAN_URI, data: {'_method': 'put','order_id' : orderId, 'delivery_man_id' : deliveryManId});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}