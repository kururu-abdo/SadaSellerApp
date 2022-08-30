import 'package:flutter/material.dart';
import 'package:joseeder_seller/data/datasource/remote/dio/dio_client.dart';
import 'package:joseeder_seller/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joseeder_seller/data/model/response/base/api_response.dart';
import 'package:joseeder_seller/utill/app_constants.dart';

class ProductReviewRepo {
  final DioClient dioClient;
  ProductReviewRepo({@required this.dioClient});

  Future<ApiResponse> productReviewList() async {
    try {
      final response = await dioClient.get(AppConstants.PRODUCT_REVIEW_URI,
        // options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}