import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/cart_pref_controller.dart';
import 'package:efood_multivendor_restaurant/controller/coupon_controller.dart';
import 'package:efood_multivendor_restaurant/controller/localization_controller.dart';
import 'package:efood_multivendor_restaurant/controller/location_controller.dart';
import 'package:efood_multivendor_restaurant/controller/order_controller.dart';
import 'package:efood_multivendor_restaurant/controller/restaurant_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/body/place_order_body.dart';
import 'package:efood_multivendor_restaurant/data/model/response/address_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/cart_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart'
    as productModel;
import 'package:efood_multivendor_restaurant/helper/date_converter.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_text_field.dart';
import 'package:efood_multivendor_restaurant/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor_restaurant/view/screens/cart/widget/delivery_option_button.dart';
import 'package:efood_multivendor_restaurant/view/screens/checkout/widget/payment_button.dart';
import 'package:efood_multivendor_restaurant/view/screens/checkout/widget/slot_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final bool fromCart;

  CheckoutScreen({@required this.fromCart, @required this.cartList});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  double _taxPercent = 0;
  bool _isCashOnDeliveryActive;
  bool _isDigitalPaymentActive;
  bool _isWalletActive;
  bool _isLoggedIn;
  List<CartModel> _cartList;
  AddressModel selectedAddress;

  @override
  void initState() {
    super.initState();
    final authController = Get.find<AuthController>();
    _isLoggedIn = authController.isLoggedIn();
    if (_isLoggedIn) {
      print('Logged in');
      if (authController.profileModel == null) {
        authController.getProfile();
      }
      if (Get.find<LocationController>().addressList == null ||
          Get.find<LocationController>().addressList.length == 0) {
        print('Getting address list');
        Get.find<LocationController>().getAddressList();
        Get.find<OrderController>()
            .getDistanceInMeter(LatLng(30, 30), LatLng(40, 30));
      }
      _isCashOnDeliveryActive =
          Get.find<SplashController>().configModel.cashOnDelivery;
      _isDigitalPaymentActive =
          Get.find<SplashController>().configModel.digitalPayment;
      _isWalletActive = false;
      _cartList = [];
      widget.fromCart
          ? _cartList.addAll(Get.find<CartController>().cartList)
          : _cartList.addAll(widget.cartList);
      Get.find<RestaurantController>()
          .initCheckoutData(_cartList[0].product.restaurantId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'checkout'.tr),
      body: _isLoggedIn
          ? GetBuilder<LocationController>(builder: (locationController) {
              /*  List<DropdownMenuItem<int>> _addressList = [];
              _addressList.add(DropdownMenuItem<int>(
                  value: -1,
                  child: SizedBox(
                    width: context.width > Dimensions.WEB_MAX_WIDTH
                        ? Dimensions.WEB_MAX_WIDTH - 50
                        : context.width - 50,
                    child: AddressWidget(
                      address: Get.find<LocationController>().getUserAddress(),
                      fromAddress: false,
                      fromCheckout: true,
                    ),
                  )));
              if (locationController.addressList != null) {
                for (int index = 0;
                    index < locationController.addressList.length;
                    index++) {
                  if (locationController.addressList[index].zoneId ==
                      Get.find<LocationController>().getUserAddress().zoneId) {
                    _addressList.add(DropdownMenuItem<int>(
                        value: index,
                        child: SizedBox(
                          width: context.width > Dimensions.WEB_MAX_WIDTH
                              ? Dimensions.WEB_MAX_WIDTH - 50
                              : context.width - 50,
                          child: AddressWidget(
                            address: locationController.addressList[index],
                            fromAddress: false,
                            fromCheckout: true,
                          ),
                        )));
                  }
                }
              }
*/
              return GetBuilder<RestaurantController>(
                  builder: (restController) {
                bool _todayClosed = false;
                bool _tomorrowClosed = false;
                if (restController.restaurant != null) {
                  _todayClosed = restController.isRestaurantClosed(
                      true,
                      restController.restaurant.active,
                      restController.restaurant.schedules);
                  _tomorrowClosed = restController.isRestaurantClosed(
                      false,
                      restController.restaurant.active,
                      restController.restaurant.schedules);
                  _taxPercent = restController.restaurant.tax;
                }
                return GetBuilder<CouponController>(
                    builder: (couponController) {
                  return GetBuilder<OrderController>(
                      builder: (orderController) {
                    double _deliveryCharge = -1;
                    double _charge = -1;
                    if (restController.restaurant != null &&
                        restController.restaurant.selfDeliverySystem == 1) {
                      _deliveryCharge =
                          restController.restaurant.deliveryCharge;
                      _charge = restController.restaurant.deliveryCharge;
                    } else if (restController.restaurant != null &&
                        orderController.distance != null &&
                        orderController.distance != -1) {
                      _deliveryCharge = orderController.distance *
                          Get.find<SplashController>()
                              .configModel
                              .perKmShippingCharge;
                      _charge = orderController.distance *
                          Get.find<SplashController>()
                              .configModel
                              .perKmShippingCharge;
                      if (_deliveryCharge <
                          Get.find<SplashController>()
                              .configModel
                              .minimumShippingCharge) {
                        _deliveryCharge = Get.find<SplashController>()
                            .configModel
                            .minimumShippingCharge;
                        _charge = Get.find<SplashController>()
                            .configModel
                            .minimumShippingCharge;
                      }
                    }

                    double _price = 0;
                    double _discount = 0;
                    double _couponDiscount = couponController.discount;
                    double _tax = 0;
                    double _addOns = 0;
                    double _subTotal = 0;
                    double _orderAmount = 0;
                    if (restController.restaurant != null) {
                      _cartList.forEach((cartModel) {
                        List<productModel.AddOns> _addOnList = [];
                        cartModel.addOnIds.forEach((addOnId) {
                          for (productModel.AddOns addOns
                              in cartModel.product.addOns) {
                            if (addOns.id == addOnId.id) {
                              _addOnList.add(addOns);
                              break;
                            }
                          }
                        });

                        for (int index = 0;
                            index < _addOnList.length;
                            index++) {
                          _addOns = _addOns +
                              (_addOnList[index].price *
                                  cartModel.addOnIds[index].quantity);
                        }
                        _price =
                            _price + (cartModel.price * cartModel.quantity);
                        double _dis = (restController.restaurant.discount !=
                                    null &&
                                DateConverter.isAvailable(
                                    restController
                                        .restaurant.discount.startTime,
                                    restController.restaurant.discount.endTime))
                            ? restController.restaurant.discount.discount
                            : cartModel.product.discount;
                        String _disType = (restController.restaurant.discount !=
                                    null &&
                                DateConverter.isAvailable(
                                    restController
                                        .restaurant.discount.startTime,
                                    restController.restaurant.discount.endTime))
                            ? 'percent'
                            : cartModel.product.discountType;
                        _discount = _discount +
                            ((cartModel.price -
                                    PriceConverter.convertWithDiscount(
                                        cartModel.price, _dis, _disType)) *
                                cartModel.quantity);
                      });
                      if (restController.restaurant != null &&
                          restController.restaurant.discount != null) {
                        if (restController.restaurant.discount.maxDiscount !=
                                0 &&
                            restController.restaurant.discount.maxDiscount <
                                _discount) {
                          _discount =
                              restController.restaurant.discount.maxDiscount;
                        }
                        if (restController.restaurant.discount.minPurchase !=
                                0 &&
                            restController.restaurant.discount.minPurchase >
                                (_price + _addOns)) {
                          _discount = 0;
                        }
                      }
                      _subTotal = _price + _addOns;
                      _orderAmount =
                          (_price - _discount) + _addOns - _couponDiscount;

                      if (orderController.orderType == 'take_away' ||
                          /*     restController.restaurant.freeDelivery ||
                          (Get.find<SplashController>()
                                      .configModel
                                      .freeDeliveryOver !=
                                  null &&
                              _orderAmount >=
                                  Get.find<SplashController>()
                                      .configModel
                                      .freeDeliveryOver


                          ) ||*/
                          couponController.freeDelivery) {
                        _deliveryCharge = 0;
                      }
                    }

                    _tax = PriceConverter.calculation(
                        _orderAmount, _taxPercent, 'percent', 1);
                    double _total = _subTotal +
                        _deliveryCharge -
                        _discount -
                        _couponDiscount +
                        _tax;
                    print(orderController.distance);
                    print(locationController.addressList);
                    return (orderController.distance != null &&
                            locationController.addressList != null)
                        ? Column(
                            children: [
                              Expanded(
                                  child: Scrollbar(
                                      child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                child: Center(
                                    child: SizedBox(
                                  width: Dimensions.WEB_MAX_WIDTH,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Order type
                                        Text('delivery_option'.tr,
                                            style: robotoMedium),
                                        restController.restaurant.delivery
                                            ? DeliveryOptionButton(
                                                value: 'delivery',
                                                title: 'home_delivery'.tr,
                                                charge: _charge,
                                                isFree: restController
                                                    .restaurant.freeDelivery,
                                              )
                                            : SizedBox(),
                                        restController.restaurant.takeAway
                                            ? DeliveryOptionButton(
                                                value: 'take_away',
                                                title: 'take_away'.tr,
                                                charge: _deliveryCharge,
                                                isFree: true,
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),

                                        orderController.orderType != 'take_away'
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('deliver_to'.tr,
                                                              style:
                                                                  robotoMedium),
                                                          TextButton.icon(
                                                            onPressed:
                                                                () async {
/*
                                                              final result =
                                                                  await Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => AddAddressScreen(
                                                                                fromCheckout: true,
                                                                              )));
*/
                                                              final result = await Get
                                                                  .toNamed(RouteHelper
                                                                      .getAddAddressRoute(
                                                                          true));
                                                              selectedAddress =
                                                                  result;
                                                              setState(() {});

/*
                                                              print(result);
                                                              print(
                                                                  '-----------');
                                                              if (result !=
                                                                  null) {
                                                                print(result);
                                                              }
*/
                                                            },
                                                            icon: Icon(
                                                                Icons.add,
                                                                size: 20),
                                                            label: Text(
                                                                'add'.tr,
                                                                style: robotoMedium
                                                                    .copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeSmall)),
                                                          ),
                                                        ]),
/*
                                                    DropdownButton(
                                                      value: orderController
                                                          .addressIndex,
                                                      items: _addressList,
                                                      itemHeight:
                                                          ResponsiveHelper
                                                                  .isMobile(
                                                                      context)
                                                              ? 70
                                                              : 85,
                                                      elevation: 0,
                                                      iconSize: 30,
                                                      underline: SizedBox(),
                                                      onChanged: (int index) {
                                                        if (restController
                                                                .restaurant
                                                                .selfDeliverySystem ==
                                                            0) {
                                                          orderController
                                                              .getDistanceInMeter(
                                                            LatLng(
                                                              double.parse(index ==
                                                                      -1
                                                                  ? locationController
                                                                      .getUserAddress()
                                                                      .latitude
                                                                  : locationController
                                                                      .addressList[
                                                                          index]
                                                                      .latitude),
                                                              double.parse(index ==
                                                                      -1
                                                                  ? locationController
                                                                      .getUserAddress()
                                                                      .longitude
                                                                  : locationController
                                                                      .addressList[
                                                                          index]
                                                                      .longitude),
                                                            ),
                                                            LatLng(
                                                                double.parse(
                                                                    restController
                                                                        .restaurant
                                                                        .latitude),
                                                                double.parse(
                                                                    restController
                                                                        .restaurant
                                                                        .longitude)),
                                                          );
                                                        }
                                                        orderController
                                                            .setAddressIndex(
                                                                index);
                                                      },
                                                    ),
*/
                                                    SizedBox(
                                                        height: Dimensions
                                                            .PADDING_SIZE_LARGE),
                                                  ])
                                            : SizedBox(),

                                        // Time Slot
                                        restController.restaurant.scheduleOrder
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                    Text('preference_time'.tr,
                                                        style: robotoMedium),
                                                    SizedBox(
                                                        height: Dimensions
                                                            .PADDING_SIZE_SMALL),
                                                    SizedBox(
                                                      height: 50,
                                                      child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        shrinkWrap: true,
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        itemCount: 2,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return SlotWidget(
                                                            title: index == 0
                                                                ? 'today'.tr
                                                                : 'tomorrow'.tr,
                                                            isSelected:
                                                                orderController
                                                                        .selectedDateSlot ==
                                                                    index,
                                                            onTap: () =>
                                                                orderController
                                                                    .updateDateSlot(
                                                                        index),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: Dimensions
                                                            .PADDING_SIZE_SMALL),
                                                    SizedBox(
                                                      height: 50,
                                                      child: ((orderController
                                                                          .selectedDateSlot ==
                                                                      0 &&
                                                                  _todayClosed) ||
                                                              (orderController
                                                                          .selectedDateSlot ==
                                                                      1 &&
                                                                  _tomorrowClosed))
                                                          ? Center(
                                                              child: Text(
                                                                  'restaurant_is_closed'
                                                                      .tr))
                                                          : orderController
                                                                      .timeSlots !=
                                                                  null
                                                              ? orderController
                                                                          .timeSlots
                                                                          .length >
                                                                      0
                                                                  ? ListView
                                                                      .builder(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          BouncingScrollPhysics(),
                                                                      itemCount: orderController
                                                                          .timeSlots
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return SlotWidget(
                                                                          title: (index == 0 && orderController.selectedDateSlot == 0 && restController.isRestaurantOpenNow(restController.restaurant.active, restController.restaurant.schedules))
                                                                              ? 'now'.tr
                                                                              : '${DateConverter.dateToTimeOnly(orderController.timeSlots[index].startTime)} '
                                                                                  '- ${DateConverter.dateToTimeOnly(orderController.timeSlots[index].endTime)}',
                                                                          isSelected:
                                                                              orderController.selectedTimeSlot == index,
                                                                          onTap: () =>
                                                                              orderController.updateTimeSlot(index),
                                                                        );
                                                                      },
                                                                    )
                                                                  : Center(
                                                                      child: Text(
                                                                          'no_slot_available'
                                                                              .tr))
                                                              : Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                    ),
                                                    SizedBox(
                                                        height: Dimensions
                                                            .PADDING_SIZE_LARGE),
                                                  ])
                                            : SizedBox(),
                                        if (selectedAddress != null)
                                          Text(selectedAddress.fullAddress),
                                        // Coupon
                                        GetBuilder<CouponController>(
                                          builder: (couponController) {
                                            return Row(children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 50,
                                                  child: TextField(
                                                    controller:
                                                        _couponController,
                                                    style: robotoRegular.copyWith(
                                                        height: ResponsiveHelper
                                                                .isMobile(
                                                                    context)
                                                            ? null
                                                            : 2),
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'enter_promo_code'.tr,
                                                      hintStyle: robotoRegular
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor),
                                                      isDense: true,
                                                      filled: true,
                                                      enabled: couponController
                                                              .discount ==
                                                          0,
                                                      fillColor:
                                                          Theme.of(context)
                                                              .cardColor,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .horizontal(
                                                          left: Radius.circular(
                                                              Get.find<LocalizationController>()
                                                                      .isLtr
                                                                  ? 10
                                                                  : 0),
                                                          right: Radius.circular(
                                                              Get.find<LocalizationController>()
                                                                      .isLtr
                                                                  ? 0
                                                                  : 10),
                                                        ),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
/*
                                                  print('tap');
                                                  return;
*/
                                                  String _couponCode =
                                                      _couponController.text
                                                          .trim();
                                                  if (couponController
                                                              .discount <
                                                          1 &&
                                                      !couponController
                                                          .freeDelivery) {
                                                    if (_couponCode
                                                            .isNotEmpty &&
                                                        !couponController
                                                            .isLoading) {
                                                      couponController
                                                          .applyCoupon(
                                                              _couponCode,
                                                              (_price -
                                                                      _discount) +
                                                                  _addOns,
                                                              _deliveryCharge,
                                                              restController
                                                                  .restaurant
                                                                  .id)
                                                          .then((discount) {
                                                        if (discount > 0) {
                                                          showCustomSnackBar(
                                                            '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                                                            isError: false,
                                                          );
                                                        }
                                                      });
                                                    } else if (_couponCode
                                                        .isEmpty) {
                                                      showCustomSnackBar(
                                                          'enter_a_coupon_code'
                                                              .tr);
                                                    }
                                                  } else {
                                                    couponController
                                                        .removeCouponData(true);
                                                  }
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 100,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey[
                                                              Get.isDarkMode
                                                                  ? 800
                                                                  : 200],
                                                          spreadRadius: 1,
                                                          blurRadius: 5)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.horizontal(
                                                      left: Radius.circular(
                                                          Get.find<LocalizationController>()
                                                                  .isLtr
                                                              ? 0
                                                              : 10),
                                                      right: Radius.circular(
                                                          Get.find<LocalizationController>()
                                                                  .isLtr
                                                              ? 10
                                                              : 0),
                                                    ),
                                                  ),
                                                  child: (couponController
                                                                  .discount <=
                                                              0 &&
                                                          !couponController
                                                              .freeDelivery)
                                                      ? !couponController
                                                              .isLoading
                                                          ? Text(
                                                              'apply'.tr,
                                                              style: robotoMedium.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor),
                                                            )
                                                          : CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .white))
                                                      : Icon(Icons.clear,
                                                          color: Colors.white),
                                                ),
                                              ),
                                            ]);
                                          },
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),

                                        Text('choose_payment_method'.tr,
                                            style: robotoMedium),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        _isCashOnDeliveryActive
                                            ? PaymentButton(
                                                icon: Images.cash_on_delivery,
                                                title: 'cash_on_delivery'.tr,
                                                subtitle:
                                                    'pay_your_payment_after_getting_food'
                                                        .tr,
                                                index: 0,
                                              )
                                            : SizedBox(),
                                        /*     _isDigitalPaymentActive
                                            ? PaymentButton(
                                                icon: Images.digital_payment,
                                                title: 'digital_payment'.tr,
                                                subtitle:
                                                    'faster_and_safe_way'.tr,
                                                index: 1,
                                              )
                                            : SizedBox(),*/
                                        _isWalletActive
                                            ? PaymentButton(
                                                icon: Images.wallet,
                                                title: 'wallet_payment'.tr,
                                                subtitle:
                                                    'pay_from_your_existing_balance'
                                                        .tr,
                                                index: 2,
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),

                                        CustomTextField(
                                          controller: _noteController,
                                          hintText: 'additional_note'.tr,
                                          maxLines: 3,
                                          inputType: TextInputType.multiline,
                                          inputAction: TextInputAction.newline,
                                          capitalization:
                                              TextCapitalization.sentences,
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),

                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('subtotal'.tr,
                                                  style: robotoMedium),
                                              Text(
                                                  PriceConverter.convertPrice(
                                                      _subTotal),
                                                  style: robotoMedium),
                                            ]),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('discount'.tr,
                                                  style: robotoRegular),
                                              Text(
                                                  '(-) ${PriceConverter.convertPrice(_discount)}',
                                                  style: robotoRegular),
                                            ]),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        (couponController.discount > 0 ||
                                                couponController.freeDelivery)
                                            ? Column(children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('coupon_discount'.tr,
                                                          style: robotoRegular),
                                                      (couponController
                                                                      .coupon !=
                                                                  null &&
                                                              couponController
                                                                      .coupon
                                                                      .couponType ==
                                                                  'free_delivery')
                                                          ? Text(
                                                              'free_delivery'
                                                                  .tr,
                                                              style: robotoRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            )
                                                          : Text(
                                                              '(-) ${PriceConverter.convertPrice(couponController.discount)}',
                                                              style:
                                                                  robotoRegular,
                                                            ),
                                                    ]),
                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_SMALL),
                                              ])
                                            : SizedBox(),
/*
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('vat_tax'.tr,
                                                  style: robotoRegular),
                                              Text(
                                                  '(+) ${PriceConverter.convertPrice(_tax)}',
                                                  style: robotoRegular),
                                            ]),
*/
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
/*
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('delivery_fee'.tr,
                                                  style: robotoRegular),
                                              _deliveryCharge == -1
                                                  ? Text(
                                                      'calculating'.tr,
                                                      style: robotoRegular
                                                          .copyWith(
                                                              color:
                                                                  Colors.red),
                                                    )
                                                  : (_deliveryCharge == 0 ||
                                                          (couponController
                                                                      .coupon !=
                                                                  null &&
                                                              couponController
                                                                      .coupon
                                                                      .couponType ==
                                                                  'free_delivery'))
                                                      ? Text(
                                                          'free'.tr,
                                                          style: robotoRegular.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        )
                                                      : Text(
                                                          '(+) ${PriceConverter.convertPrice(_deliveryCharge)}',
                                                          style: robotoRegular,
                                                        ),
                                            ]),
*/
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          child: Divider(
                                              thickness: 1,
                                              color: Theme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.5)),
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'total_amount'.tr,
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeLarge,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              Text(
                                                PriceConverter.convertPrice(
                                                    _total),
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeLarge,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            ]),
                                      ]),
                                )),
                              ))),
//todo
                              Container(
                                width: Dimensions.WEB_MAX_WIDTH,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                child: !orderController.isLoading
                                    ? CustomButton(
                                        buttonText: 'confirm_order'.tr,
                                        onPressed: () {
                                          bool _isAvailable = true;
                                          DateTime _scheduleStartDate =
                                              DateTime.now();
                                          DateTime _scheduleEndDate =
                                              DateTime.now();
                                          if (orderController.timeSlots ==
                                                  null ||
                                              orderController
                                                      .timeSlots.length ==
                                                  0) {
                                            _isAvailable = false;
                                          } else {
                                            DateTime _date = orderController
                                                        .selectedDateSlot ==
                                                    0
                                                ? DateTime.now()
                                                : DateTime.now()
                                                    .add(Duration(days: 1));
                                            DateTime _startTime =
                                                orderController
                                                    .timeSlots[orderController
                                                        .selectedTimeSlot]
                                                    .startTime;
                                            DateTime _endTime = orderController
                                                .timeSlots[orderController
                                                    .selectedTimeSlot]
                                                .endTime;
                                            _scheduleStartDate = DateTime(
                                                _date.year,
                                                _date.month,
                                                _date.day,
                                                _startTime.hour,
                                                _startTime.minute + 1);
                                            _scheduleEndDate = DateTime(
                                                _date.year,
                                                _date.month,
                                                _date.day,
                                                _endTime.hour,
                                                _endTime.minute + 1);
                                            for (CartModel cart in _cartList) {
                                              if (!DateConverter.isAvailable(
                                                    cart.product
                                                        .availableTimeStarts,
                                                    cart.product
                                                        .availableTimeEnds,
                                                    time: restController
                                                            .restaurant
                                                            .scheduleOrder
                                                        ? _scheduleStartDate
                                                        : null,
                                                  ) &&
                                                  !DateConverter.isAvailable(
                                                    cart.product
                                                        .availableTimeStarts,
                                                    cart.product
                                                        .availableTimeEnds,
                                                    time: restController
                                                            .restaurant
                                                            .scheduleOrder
                                                        ? _scheduleEndDate
                                                        : null,
                                                  )) {
                                                _isAvailable = false;
                                                break;
                                              }
                                            }
                                          }
                                          /*  if (!_isCashOnDeliveryActive &&
                                              !_isDigitalPaymentActive &&
                                              !_isWalletActive) {
                                            showCustomSnackBar(
                                                'no_payment_method_is_enabled'
                                                    .tr);
                                          } else if (_orderAmount <
                                              restController
                                                  .restaurant.minimumOrder) {
                                            showCustomSnackBar(
                                                '${'minimum_order_amount_is'.tr} ${restController.restaurant.minimumOrder}');
                                          } else if ((orderController
                                                          .selectedDateSlot ==
                                                      0 &&
                                                  _todayClosed) ||
                                              (orderController
                                                          .selectedDateSlot ==
                                                      1 &&
                                                  _tomorrowClosed)) {
                                            showCustomSnackBar(
                                                'restaurant_is_closed'.tr);
                                          } else if (orderController
                                                      .timeSlots ==
                                                  null ||
                                              orderController
                                                      .timeSlots.length ==
                                                  0) {
                                            if (restController
                                                .restaurant.scheduleOrder) {
                                              showCustomSnackBar(
                                                  'select_a_time'.tr);
                                            } else {
                                              showCustomSnackBar(
                                                  'restaurant_is_closed'.tr);
                                            }
                                          } else*/
                                          /*   if (!_isAvailable) {
                                            showCustomSnackBar(
                                                'one_or_more_products_are_not_available_for_this_selected_time'
                                                    .tr);
                                          } else*/
                                          AddressModel _address =
                                              selectedAddress;

/*
                                          if (_address == null) {
                                            showCustomSnackBar(
                                                'choose_address_first'.tr);

                                            return;
                                          }
*/
                                          if (orderController.orderType !=
                                                  'take_away' &&
                                              orderController.distance == -1 &&
                                              _deliveryCharge == -1) {
                                            showCustomSnackBar(
                                                'delivery_fee_not_set_yet'.tr);
                                          }
                                          /*else if (orderController
                                                      .paymentMethodIndex ==
                                                  2 &&
                                              Get.find<UserController>()
                                                      .userInfoModel !=
                                                  null &&
                                              Get.find<UserController>()
                                                      .userInfoModel
                                                      .walletBalance <
                                                  _total) {
                                            showCustomSnackBar(
                                                'you_do_not_have_sufficient_balance_in_wallet'
                                                    .tr);
                                          }*/
                                          else {
                                            List<Cart> carts = [];
                                            for (int index = 0;
                                                index < _cartList.length;
                                                index++) {
                                              CartModel cart = _cartList[index];
                                              List<int> _addOnIdList = [];
                                              List<int> _addOnQtyList = [];
                                              cart.addOnIds.forEach((addOn) {
                                                _addOnIdList.add(addOn.id);
                                                _addOnQtyList
                                                    .add(addOn.quantity);
                                              });
                                              carts.add(Cart(
                                                cart.isCampaign
                                                    ? null
                                                    : cart.product.id,
                                                cart.isCampaign
                                                    ? cart.product.id
                                                    : null,
                                                cart.discountedPrice.toString(),
                                                '',
                                                cart.variation,
                                                cart.quantity,
                                                _addOnIdList,
                                                cart.addOns,
                                                _addOnQtyList,
                                              ));
                                            }
                                            orderController.placeOrder(
                                                PlaceOrderBody(
                                                  cart: carts,
                                                  couponDiscountAmount: Get.find<
                                                          CouponController>()
                                                      .discount,
                                                  distance:
                                                      orderController.distance,
                                                  couponDiscountTitle: Get.find<
                                                                  CouponController>()
                                                              .discount >
                                                          0
                                                      ? Get.find<
                                                              CouponController>()
                                                          .coupon
                                                          .title
                                                      : null,
                                                  scheduleAt: !restController
                                                          .restaurant
                                                          .scheduleOrder
                                                      ? null
                                                      : (orderController
                                                                      .selectedDateSlot ==
                                                                  0 &&
                                                              orderController
                                                                      .selectedTimeSlot ==
                                                                  0)
                                                          ? null
                                                          : DateConverter
                                                              .dateToDateAndTime(
                                                                  _scheduleEndDate),
                                                  orderAmount: _total,
                                                  orderNote:
                                                      _noteController.text,
                                                  orderType:
                                                      orderController.orderType,
                                                  paymentMethod: orderController
                                                              .paymentMethodIndex ==
                                                          0
                                                      ? 'cash_on_delivery'
                                                      : orderController
                                                                  .paymentMethodIndex ==
                                                              1
                                                          ? 'digital_payment'
                                                          : orderController
                                                                      .paymentMethodIndex ==
                                                                  2
                                                              ? 'wallet'
                                                              : 'digital_payment',
                                                  couponCode: (Get.find<
                                                                      CouponController>()
                                                                  .discount >
                                                              0 ||
                                                          (Get.find<CouponController>()
                                                                      .coupon !=
                                                                  null &&
                                                              Get.find<
                                                                      CouponController>()
                                                                  .freeDelivery))
                                                      ? Get.find<
                                                              CouponController>()
                                                          .coupon
                                                          .code
                                                      : null,
                                                  restaurantId: _cartList[0]
                                                      .product
                                                      .restaurantId,
                                                  address: _address?.address,
                                                  latitude: _address?.latitude,
                                                  longitude:
                                                      _address?.longitude,
                                                  addressType:
                                                      _address?.addressType,
                                                  contactPersonName: _address
                                                          ?.contactPersonName ??
                                                      '${Get.find<AuthController>().profileModel?.fName} '
                                                          '${Get.find<AuthController>().profileModel?.lName}',
                                                  contactPersonNumber: _address
                                                          ?.contactPersonNumber ??
                                                      Get.find<AuthController>()
                                                          .profileModel
                                                          ?.phone,
                                                  discountAmount: _discount,
                                                  taxAmount: _tax,
                                                ),
                                                _callback,
                                                _total);
                                          }
                                        })
                                    : Center(
                                        child: CircularProgressIndicator()),
                              ),
                            ],
                          )
                        : Center(child: CircularProgressIndicator());
                  });
                });
              });
            })
          : NotLoggedInScreen(),
    );
  }

  void _callback(
      bool isSuccess, String message, String orderID, double amount) async {
    if (isSuccess) {
      if (widget.fromCart) {
        Get.find<CartController>().clearCartList();
      }
      Get.find<OrderController>().stopLoader();
      if (Get.find<OrderController>().paymentMethodIndex == 0 ||
          Get.find<OrderController>().paymentMethodIndex == 2) {
        Get.close(2);
/*
        Get.offNamed(
            RouteHelper.getOrderSuccessRoute(orderID, 'success', amount));
*/
      } else {
/*
        if (GetPlatform.isWeb) {
          Get.back();
          String hostname = html.window.location.hostname;
          String protocol = html.window.location.protocol;
          String selectedUrl =
              '${AppConstants.BASE_URL}/payment-mobile?order_id=$orderID&customer_id=${Get.find<UserController>().userInfoModel.id}&&callback=$protocol//$hostname${RouteHelper.orderSuccess}?id=$orderID&amount=$amount&status=';
          html.window.open(selectedUrl, "_self");
        } else {
          Get.offNamed(RouteHelper.getPaymentRoute(
              orderID, Get.find<UserController>().userInfoModel.id, amount));
        }
*/
      }
      Get.find<OrderController>().clearPrevData();
      Get.find<CouponController>().removeCouponData(false);
    } else {
      showCustomSnackBar(message);
    }
  }
}
