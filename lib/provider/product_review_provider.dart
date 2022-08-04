
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/review_model.dart';
import 'package:sixvalley_vendor_app/data/repository/product_review_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class ProductReviewProvider extends ChangeNotifier{
  final ProductReviewRepo productReviewRepo;
  ProductReviewProvider({@required this.productReviewRepo});


  List<ReviewModel> _reviewList;
  List<ReviewModel> get reviewList => _reviewList != null ? _reviewList.reversed.toList() : _reviewList;



  Future<void> getReviewList(BuildContext context) async{
    ApiResponse apiResponse = await productReviewRepo.productReviewList();

    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _reviewList = [];
      apiResponse.response.data.forEach((review) {
        ReviewModel reviewModel = ReviewModel.fromJson(review);
        _reviewList.add(reviewModel);
      });
      print(reviewList);

    }else{
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

}