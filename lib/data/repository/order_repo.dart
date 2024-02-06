import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:eamar_seller_app/data/datasource/remote/dio/dio_client.dart';
import 'package:eamar_seller_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:eamar_seller_app/data/model/response/base/api_response.dart';
import 'package:eamar_seller_app/utill/app_constants.dart';

class OrderListRepo {
  final DioClient? dioClient;
  OrderListRepo({@required this.dioClient});

  Future<ApiResponse> getOrderList() async {
    try {
      final response = await dioClient!.get(AppConstants.ORDER_LIST_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOrderDetails(String orderID) async {
    try {
      final response =
          await dioClient!.get(AppConstants.ORDER_DETAILS + orderID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> orderStatus(int orderID, String status) async {
    print(
        'update order status ====>${orderID.toString()} =======>${status.toString()}');
    try {
      Response response = await dioClient!.post(
        '${AppConstants.UPDATE_ORDER_STATUS}$orderID',
        data: {'_method': 'put', 'order_status': status},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOrderStatusList(String type) async {
    try {
      List<String> addressTypeList = [];
      if (type == 'inhouse_shipping') {
        addressTypeList = [
          'Select Order Status',
          AppConstants.PENDING,
          AppConstants.CONFIRMED,
          AppConstants.PROCESSING,
        ];
      } else {
        addressTypeList = [
          'Select Order Status',
          AppConstants.PENDING,
          AppConstants.CONFIRMED,
          AppConstants.PROCESSING,
          AppConstants.OUT_FOR_DELIVERY,
          AppConstants.DELIVERED,
          AppConstants.RETURNED,
          AppConstants.FAILED,
          AppConstants.CANCELLED,
        ];
      }

      Response response = Response(
          requestOptions: RequestOptions(path: ''),
          data: addressTypeList,
          statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updatePaymentStatus(
      {int? orderId, String? status}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.PAYMENT_STATUS_UPDATE,
        data: {"order_id": orderId, "payment_status": status},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
