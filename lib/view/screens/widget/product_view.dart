import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/profile_model.dart';
import 'package:efood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/view/base/product_shimmer.dart';
import 'package:efood_multivendor_restaurant/view/screens/widget/product_widget.dart';
import 'package:flutter/material.dart';

class ProductView extends StatelessWidget {
  final List<Product> products;
  final List<Restaurant> restaurants;
  final bool isRestaurant;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String noDataText;
  final bool isCampaign;
  final bool inRestaurantPage;
  final String type;
  final Function(String type) onVegFilterTap;
  ProductView(
      {@required this.restaurants,
      @required this.products,
      @required this.isRestaurant,
      this.isScrollable = false,
      this.shimmerLength = 20,
      this.padding = const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      this.noDataText,
      this.isCampaign = false,
      this.inRestaurantPage = false,
      this.type,
      this.onVegFilterTap});

  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;
    if (isRestaurant) {
      _isNull = restaurants == null;
      if (!_isNull) {
        _length = restaurants.length;
      }
    } else {
      _isNull = products == null;
      if (!_isNull) {
        _length = products.length;
      }
    }

    return Column(children: [
      // type != null
      //     ? VegFilterWidget(type: type, onSelected: onVegFilterTap)
      //     : SizedBox(),
      !_isNull
          ? _length > 0
              ? GridView.builder(
                  key: UniqueKey(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                    mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                        ? Dimensions.PADDING_SIZE_LARGE
                        : 0.01,
                    childAspectRatio:
                        ResponsiveHelper.isDesktop(context) ? 4 : 4,
                    crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                  ),
                  physics: isScrollable
                      ? BouncingScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  shrinkWrap: isScrollable ? false : true,
                  itemCount: _length,
                  padding: padding,
                  itemBuilder: (context, index) {
                    return ProductWidget(
                      isRestaurant: isRestaurant,
                      product: isRestaurant ? null : products[index],
                      restaurant: isRestaurant ? restaurants[index] : null,
                      index: index,
                      length: _length,
                      isCampaign: isCampaign,
                      inRestaurant: inRestaurantPage,
                    );
                  },
                )
              : SizedBox()
          /*NoDataScreen(
                  text: noDataText != null
                      ? noDataText
                      : isRestaurant
                          ? 'no_restaurant_available'.tr
                          : 'no_food_available'.tr,
                )*/
          : GridView.builder(
              key: UniqueKey(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                    ? Dimensions.PADDING_SIZE_LARGE
                    : 0.01,
                childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 : 4,
                crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
              ),
              physics: isScrollable
                  ? BouncingScrollPhysics()
                  : NeverScrollableScrollPhysics(),
              shrinkWrap: isScrollable ? false : true,
              itemCount: shimmerLength,
              padding: padding,
              itemBuilder: (context, index) {
                return ProductShimmer(
                    isEnabled: _isNull,
                    /*isRestaurant: isRestaurant,*/ hasDivider:
                        index != shimmerLength - 1);
              },
            ),
    ]);
  }
}
