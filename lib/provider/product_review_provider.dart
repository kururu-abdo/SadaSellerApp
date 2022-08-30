
import 'package:flutter/material.dart';
import 'package:joseeder_seller/data/model/response/base/api_response.dart';
import 'package:joseeder_seller/data/model/response/review_model.dart';
import 'package:joseeder_seller/data/repository/product_review_repo.dart';
import 'package:joseeder_seller/helper/api_checker.dart';

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