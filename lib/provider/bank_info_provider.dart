
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/body/seller_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/seller_info.dart';
import 'package:sixvalley_vendor_app/data/repository/bank_info_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:http/http.dart' as http;

class BankInfoProvider extends ChangeNotifier {
  final BankInfoRepo bankInfoRepo;

  BankInfoProvider({@required this.bankInfoRepo});

  SellerModel _bankInfo;
  List<double> _userEarnings;
  List<double> _userCommissions;
  SellerModel get bankInfo => _bankInfo;
  List<double> get userEarnings => _userEarnings;
  List<double> get userCommissions => _userCommissions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getBankInfo(BuildContext context) async {
    ApiResponse apiResponse = await bankInfoRepo.getBankList();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _bankInfo = SellerModel.fromJson(apiResponse.response.data);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> getUserEarnings(BuildContext context) async {
    ApiResponse apiResponse = await bankInfoRepo.getUserEarnings();
    if (apiResponse.response != null  && apiResponse.response.data != null && apiResponse.response.statusCode == 200) {
      List<String> _earnings = apiResponse.response.data.split(',');
      _earnings.removeAt(_earnings.length-1);
      _userEarnings = [];
      for(String earn in _earnings) {
        _userEarnings.add(double.parse(earn));
      }
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }


  Future<void> getUserCommissions(BuildContext context) async {
    ApiResponse apiResponse = await bankInfoRepo.getUserCommissions();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      List<String> _commissions = apiResponse.response.data.split(',');
      _commissions.removeAt(_commissions.length-1);
      _userCommissions = [];
      for(String earn in _commissions) {
        _userCommissions.add(double.parse(earn));
      }
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<ResponseModel> updateUserInfo(SellerModel updateUserModel, SellerBody seller, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response = await bankInfoRepo.updateBank(updateUserModel, seller, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      String message = 'Success';
      _bankInfo = updateUserModel;
      responseModel = ResponseModel(true, message);
      print(message);
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return responseModel;
  }

  String getBankToken() {
    return bankInfoRepo.getBankToken();
  }

}
