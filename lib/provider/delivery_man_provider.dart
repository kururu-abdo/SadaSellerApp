import 'package:flutter/cupertino.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/delivery_man_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/data/repository/delivery_man_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';

class DeliveryManProvider extends ChangeNotifier {
  final DeliveryManRepo deliveryManRepo;
  DeliveryManProvider({@required this.deliveryManRepo});
  List<DeliveryManModel> _deliveryManList;
  List<DeliveryManModel> get  deliveryManList => _deliveryManList;
  int _deliveryManIndex = 0;
  int get deliveryManIndex => _deliveryManIndex;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _addOrderStatusErrorText;
  String get addOrderStatusErrorText => _addOrderStatusErrorText;
  List<int> _deliveryManIds = [];
  List<int> get deliveryManIds => _deliveryManIds;


  Future<void> getDeliveryManList(OrderModel orderModel, BuildContext context) async {
    _deliveryManIds =[];
    _deliveryManIds.add(0);
    _deliveryManIndex = 0;
    ApiResponse apiResponse = await deliveryManRepo.getDeliveryManList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _deliveryManList = [];
      apiResponse.response.data.forEach((deliveryMan) => _deliveryManList.add(DeliveryManModel.fromJson(deliveryMan)));
      _deliveryManIndex = 0;

      for(int index = 0; index < _deliveryManList.length; index++) {
        _deliveryManIds.add(_deliveryManList[index].id);
      }

      if(orderModel.deliveryManId != null){
        setDeliverymanIndex(deliveryManIds.indexOf(int.parse(orderModel.deliveryManId.toString())), false);
      }





    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<ResponseModel> assignDeliveryMan(BuildContext context,int orderId, int deliveryManId) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel;
    ApiResponse apiResponse;
    apiResponse = await deliveryManRepo.assignDeliveryMan(orderId, deliveryManId);
    _isLoading = false;

    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      String message = apiResponse.response.data.toString();
      int _status = apiResponse.response.data['success'];
      if(_status != null) {
        responseModel = ResponseModel(false, apiResponse.response.data['message']);
        _addOrderStatusErrorText = apiResponse.response.data['message'];
        showCustomSnackBar(_addOrderStatusErrorText, context,isError: false);
      }else {
        responseModel = ResponseModel(true, message);
        _addOrderStatusErrorText = message;
        showCustomSnackBar(_addOrderStatusErrorText, context);
      }
    } else {
      responseModel = ResponseModel(false, apiResponse.error['message'] ?? apiResponse.error.toString());
    }
    notifyListeners();
    return responseModel;
  }
  void setDeliverymanIndex(int index, bool notify) {
    _deliveryManIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

}