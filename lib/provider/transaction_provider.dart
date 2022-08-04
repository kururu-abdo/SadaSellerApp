import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/month_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/transaction_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/year_model.dart';
import 'package:sixvalley_vendor_app/data/repository/transaction_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepo transactionRepo;

  TransactionProvider({@required this.transactionRepo});

  List<TransactionModel> _transactionList;
  List<TransactionModel> _allTransactionList;
  List<TransactionModel> get transactionList => _transactionList;



  List<MonthModel>  _monthItemList = [];
  List<MonthModel> get monthItemList => _monthItemList;
  List<YearModel>  _yearList = [];
  List<YearModel> get yearList => _yearList;
  int _yearIndex = 0;
  int _monthIndex = 0;
  int get yearIndex => _yearIndex;
  int get monthIndex => _monthIndex;
  List<int> _yearIds = [];
  List<int> _monthIds = [];
  List<int> get yearIds  => _yearIds;
  List<int> get monthIds  => _monthIds;


  void setYearIndex(int index, bool notify) {
    _yearIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  void setMonthIndex(int index, bool notify) {
    _monthIndex = index;
    if(notify) {
      notifyListeners();
    }
  }


  Future<void> getTransactionList(BuildContext context) async {
    ApiResponse apiResponse = await transactionRepo.getTransactionList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _transactionList = [];
      _allTransactionList = [];
      apiResponse.response.data.forEach((transaction) {
        _transactionList.add(TransactionModel.fromJson(transaction));
        _allTransactionList.add(TransactionModel.fromJson(transaction));
      });
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void  filterTransaction(int month, int year, BuildContext context) async {
    print('==month=>$month and year ==$year');
    if (month == 1) {
      _transactionList = [];
      _transactionList.addAll(_allTransactionList);
      print('==month=>${_transactionList.length}');

    } else {
      _transactionList = [];
      _allTransactionList.forEach((transaction) {
        // print('==month=>${transaction.createdAt} && ==year=>$month and ${DateConverter.getYear(transaction.createdAt)}');
        if(DateConverter.getMonthIndex(transaction.createdAt) == month && DateConverter.getYear(transaction.createdAt) == year) {
          _transactionList.add(transaction);
          print('==month=>${transaction.createdAt} && ==year=>$month and ${DateConverter.getYear(transaction.createdAt)}');
        }
      });

    }
    notifyListeners();
  }


  void initMonthTypeList() async {
    _monthIds = [];
    _monthIds.add(0);
    ApiResponse apiResponse = await transactionRepo.getMonthTypeList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {

      _monthItemList = [];
      _monthItemList.addAll(apiResponse.response.data);
      _monthIndex = 0;
      for(int index = 0; index < _monthItemList.length; index++) {
        _monthIds.add(_monthItemList[index].id);
      }
      notifyListeners();
    } else {
      print(apiResponse.error.toString());
    }
  }
  void initYearList() async {
    _yearIds = [];
    _yearIds.add(0);
    ApiResponse apiResponse = await transactionRepo.getYearList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _yearList = [];
      _yearList.addAll(apiResponse.response.data);

      _yearIndex = 0;
      for(int index = 0; index < _yearList.length; index++) {
        _yearIds.add(_yearList[index].id);
      }
      notifyListeners();
    } else {
      print(apiResponse.error.toString());
    }
  }
}
