import 'dart:async';

import 'package:efood_multivendor_restaurant/controller/order_controller.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/screens/checkout/widget/payment_failed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSuccessfulScreen extends StatefulWidget {
  final String orderID;
  final int status;
  final double totalAmount;
  OrderSuccessfulScreen(
      {@required this.orderID,
      @required this.status,
      @required this.totalAmount});

  @override
  State<OrderSuccessfulScreen> createState() => _OrderSuccessfulScreenState();
}

class _OrderSuccessfulScreenState extends State<OrderSuccessfulScreen> {
  @override
  void initState() {
    super.initState();

    Get.find<OrderController>()
        .trackOrder(widget.orderID.toString(), null, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<OrderController>(builder: (orderController) {
        double total = 0;
        bool success = true;
        if (orderController.trackModel != null) {
          total = ((orderController.trackModel.orderAmount / 100) *
              1); /* Get.find<SplashController>()
                  .configModel
                  .loyaltyPointItemPurchasePoint)*/
          success = orderController.trackModel.paymentStatus == 'paid' ||
              orderController.trackModel.paymentMethod == 'cash_on_delivery';

          if (!success) {
            Future.delayed(Duration(seconds: 1), () {
              Get.dialog(PaymentFailedDialog(orderID: widget.orderID),
                  barrierDismissible: false);
            });
          }
        }

        return orderController.trackModel != null
            ? Center(
                child: SizedBox(
                    width: Dimensions.WEB_MAX_WIDTH,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(success ? Images.logo : Images.warning,
                              width: 100, height: 100),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          Text(
                            success
                                ? 'you_placed_the_order_successfully'.tr
                                : 'your_order_is_failed_to_place'.tr,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE,
                                vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: Text(
                              success
                                  ? 'your_order_is_placed_successfully'.tr
                                  : 'your_order_is_failed_to_place_because'.tr,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).disabledColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          (success &&
                                  true /* Get.find<SplashController>()
                                          .configModel
                                          .loyaltyPointStatus ==
                                      1*/
                              )
                              ? Column(children: [
                                  Image.asset(Images.order,
                                      width: 150, height: 150),
                                  Text('congratulations'.tr,
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeLarge)),
                                  SizedBox(
                                      height: Dimensions.PADDING_SIZE_SMALL),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.PADDING_SIZE_LARGE),
                                    child: Text(
                                      'you_have_earned'.tr +
                                          ' ${total.floor().toString()} ' +
                                          'points_it_will_add_to'.tr,
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                          color:
                                              Theme.of(context).disabledColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ])
                              : SizedBox.shrink(),
                          SizedBox(height: 30),
                          Padding(
                            padding:
                                EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            child: CustomButton(
                                buttonText: 'back_to_home'.tr,
                                onPressed: () => Get.offAllNamed(
                                    RouteHelper.getInitialRoute())),
                          ),
                        ])))
            : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
