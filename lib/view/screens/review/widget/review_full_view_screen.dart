import 'package:flutter/material.dart';
import 'package:eamar_seller_app/data/model/response/review_model.dart';
import 'package:eamar_seller_app/localization/language_constrants.dart';
import 'package:eamar_seller_app/view/base/custom_app_bar.dart';
import 'package:eamar_seller_app/view/screens/review/widget/review_widget.dart';

class ReviewFullViewScreen extends StatelessWidget {
  final ReviewModel? reviewModel;
  final bool? isDetails;
  const ReviewFullViewScreen({Key? key, this.reviewModel, this.isDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(title: getTranslated('review_details', context)),
      body: ReviewWidget(reviewModel: reviewModel!, isDetails: isDetails!),
    ));
  }
}
