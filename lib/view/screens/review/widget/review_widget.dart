import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eamar_seller_app/data/model/response/review_model.dart';
import 'package:eamar_seller_app/provider/splash_provider.dart';
import 'package:eamar_seller_app/provider/theme_provider.dart';
import 'package:eamar_seller_app/utill/color_resources.dart';
import 'package:eamar_seller_app/utill/dimensions.dart';
import 'package:eamar_seller_app/utill/images.dart';
import 'package:eamar_seller_app/utill/styles.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel? reviewModel;
  final bool? isDetails;
  ReviewWidget({@required this.reviewModel, this.isDetails = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT,
            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[
                    Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200]!,
                spreadRadius: 0.5,
                blurRadius: 0.3)
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Dimensions.image_size,
              height: Dimensions.image_size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.PADDING_SIZE_SMALL)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[
                          Provider.of<ThemeProvider>(context).darkTheme
                              ? 800
                              : 200]!,
                      spreadRadius: 0.5,
                      blurRadius: 0.3)
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.PADDING_SIZE_SMALL)),
                child: CachedNetworkImage(
                  placeholder: (ctx, url) => Image.asset(
                    Images.placeholder_image,
                  ),
                  errorWidget: (ctx, url, err) => Image.asset(
                    Images.placeholder_image,
                  ),
                  imageUrl:
                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productThumbnailUrl!}/${reviewModel!.product!.thumbnail}',
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${reviewModel!.customer!.fName ?? ''}'
                        '${reviewModel!.customer!.lName ?? ''}',
                        style: titilliumSemiBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(reviewModel!.product!.name ?? '',
                        style: robotoRegular.copyWith(
                            color: ColorResources.titleColor(context)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Row(children: [
                      Icon(Icons.star,
                          color: Provider.of<ThemeProvider>(context).darkTheme
                              ? Colors.white
                              : Colors.orange,
                          size: Dimensions.ICON_SIZE_DEFAULT),
                      Text(
                          '${reviewModel!.rating!.toDouble().toStringAsFixed(1)}/5'),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      reviewModel!.comment ?? '',
                      style: robotoHintRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT),
                      maxLines: isDetails! ? 100 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    reviewModel!.attachment!.length! > 0
                        ? SizedBox(
                            height: 40,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: reviewModel!.attachment!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      right: Dimensions.PADDING_SIZE_SMALL),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder_image,
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.cover,
                                      image:
                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.reviewImageUrl}/review/${reviewModel!.attachment![index]}',
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(Images.placeholder_image,
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
