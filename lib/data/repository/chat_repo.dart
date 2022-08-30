import 'package:flutter/material.dart';
import 'package:joseeder_seller/data/datasource/remote/dio/dio_client.dart';
import 'package:joseeder_seller/data/datasource/remote/exception/api_error_handler.dart';
import 'package:joseeder_seller/data/model/body/MessageBody.dart';
import 'package:joseeder_seller/data/model/response/base/api_response.dart';
import 'package:joseeder_seller/utill/app_constants.dart';

class ChatRepo {
  final DioClient dioClient;
  ChatRepo({@required this.dioClient});

  Future<ApiResponse> getChatList() async {
    try {
      final response = await dioClient.get(AppConstants.MESSAGE_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> sendMessage(MessageBody messageBody) async {
    try {
      final response = await dioClient.post(AppConstants.SEND_MESSAGE_URI, data: messageBody.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}