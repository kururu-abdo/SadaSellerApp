import 'package:flutter/material.dart';
import 'package:joseeder_seller/data/model/response/base/api_response.dart';
import 'package:joseeder_seller/data/model/response/business_model.dart';
import 'package:joseeder_seller/data/repository/business_repo.dart';
import 'package:joseeder_seller/helper/api_checker.dart';

class BusinessProvider extends ChangeNotifier {
  final BusinessRepo businessRepo;

  BusinessProvider({@required this.businessRepo});

  List<BusinessModel> _businessList;
  List<BusinessModel> get businessList => _businessList;



  Future<void> getBusinessList(BuildContext context) async {
    ApiResponse apiResponse = await businessRepo.getBusinessList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _businessList = [];
      apiResponse.response.data.forEach((business) => _businessList.add(business));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

}
