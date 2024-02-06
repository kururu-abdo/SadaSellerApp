import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/data/model/response/review_model.dart';
import 'package:eamar_seller_app/provider/product_review_provider.dart';
import 'package:eamar_seller_app/view/screens/review/widget/review_full_view_screen.dart';
import 'package:eamar_seller_app/view/screens/review/widget/review_widget.dart';

class ProductReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ProductReviewProvider>(
        builder: (context, reviewProvider, child) {
          List<ReviewModel> reviewList;
          reviewList = reviewProvider.reviewList!;
          return Column(children: [
            ListView.builder(
              itemCount: reviewList.length,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ReviewFullViewScreen(
                                  reviewModel: reviewList[index],
                                  isDetails: true,
                                ))),
                    child: ReviewWidget(reviewModel: reviewList[index]));
              },
            ),
          ]);
        },
      ),
    );
  }
}
