import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/review_model.dart';
import 'package:efood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:efood_multivendor_restaurant/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;
  final bool hasDivider;
  ReviewWidget({@required this.review, @required this.hasDivider});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        ClipOval(
          child: CustomImage(
            image:
                '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${review.foodImage ?? ''}',
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
        Expanded(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(
                review.foodName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
              RatingBar(
                  rating: review.rating.toDouble(),
                  ratingCount: null,
                  size: 15),
              Text(
                review.customerName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall),
              ),
              Text(review.comment,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).disabledColor)),
            ])),
      ]),
      (hasDivider && ResponsiveHelper.isMobile(context))
          ? Padding(
              padding: EdgeInsets.only(left: 70),
              child: Divider(color: Theme.of(context).disabledColor),
            )
          : SizedBox(),
    ]);
  }
}
