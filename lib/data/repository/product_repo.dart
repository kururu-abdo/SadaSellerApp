import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:eamar_seller_app/data/datasource/remote/dio/dio_client.dart';
import 'package:eamar_seller_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:eamar_seller_app/data/model/response/base/api_response.dart';
import 'package:eamar_seller_app/utill/app_constants.dart';

class ProductRepo {
  final DioClient? dioClient;
  ProductRepo({@required this.dioClient});

  Future<ApiResponse> getSellerProductList(
      String sellerId, int offset, String languageCode) async {
    try {
      final response = await dioClient!.get(
        AppConstants.SELLER_PRODUCT_URI +
            sellerId +
            '/products?limit=10&&offset=$offset',
        options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getStockLimitedProductList(
      int offset, String languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.STOCK_OUT_PRODUCT_URI}$offset',
        options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
