import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/api/api_checker.dart';
import 'package:efood_multivendor_restaurant/data/model/body/place_order_body.dart';
import 'package:efood_multivendor_restaurant/data/model/body/update_status_body.dart';
import 'package:efood_multivendor_restaurant/data/model/response/delivery_man.dart';
import 'package:efood_multivendor_restaurant/data/model/response/distance_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_details_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/response_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/running_order_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/timeslote_model.dart';
import 'package:efood_multivendor_restaurant/data/repository/order_repo.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;

  OrderController({@required this.orderRepo});

  List<OrderModel> _allOrderList;
  List<OrderModel> _orderList;
  List<OrderModel> _runningOrderList;
  List<RunningOrderModel> _runningOrders;
  List<OrderModel> _historyOrderList;
  List<OrderDetailsModel> _orderDetailsModel;
  OrderModel _trackModel;
  int _addressIndex = -1;

  int get addressIndex => _addressIndex;
  ResponseModel _responseModel;

  Future<bool> switchToCOD(String orderID) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.switchToCOD(orderID);
    bool _isSuccess;
    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
      showCustomSnackBar(response.body['message'], isError: false);
      _isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }

  List<OrderDetailsModel> _orderDetails;
  bool _showCancelled = false;

  Future<void> placeOrder(
      PlaceOrderBody placeOrderBody, Function callback, double amount) async {
    _isLoading = true;
    update();
    print(placeOrderBody.toJson());
    Response response = await orderRepo.placeOrder(placeOrderBody);
    _isLoading = false;
    if (response.statusCode == 200) {
      String message = response.body['message'];
      String orderID = response.body['order_id'].toString();
      callback(true, message, orderID, amount);
      print('-------- Order placed successfully $orderID ----------');
    } else {
      callback(false, response.statusText, '-1', amount);
    }
    update();
  }

  List<OrderDetailsModel> get orderDetails => _orderDetails;

  OrderModel get trackModel => _trackModel;

  Future<ResponseModel> trackOrder(
      String orderID, OrderModel orderModel, bool fromTracking) async {
    _trackModel = null;
    _responseModel = null;
    if (!fromTracking) {
      _orderDetails = null;
    }
    _showCancelled = false;
    if (orderModel == null) {
      _isLoading = true;
      Response response = await orderRepo.trackOrder(orderID);
      if (response.statusCode == 200) {
        _trackModel = OrderModel.fromJson(response.body);
        _responseModel = ResponseModel(true, response.body.toString());
      } else {
        _responseModel = ResponseModel(false, response.statusText);
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    } else {
      _trackModel = orderModel;
      _responseModel = ResponseModel(true, 'Successful');
    }
    return _responseModel;
  }

  void setPaymentMethod(int index) {
    _paymentMethodIndex = index;
    update();
  }

  bool _isLoading = false;
  int _orderIndex = 0;
  bool _campaignOnly = false;
  String _otp = '';
  int _historyIndex = 0;
  List<String> _statusList = ['all', 'delivered', 'refunded'];
  bool _paginate = false;
  int _pageSize;
  List<int> _offsetList = [];
  int _offset = 1;
  String _orderType = 'all';
  double _distance;

  void stopLoader() {
    _isLoading = false;
    update();
  }

  void updateTimeSlot(int index) {
    _selectedTimeSlot = index;
    update();
  }

  List<OrderModel> get orderList => _orderList;

  List<OrderModel> get runningOrderList => _runningOrderList;

  List<RunningOrderModel> get runningOrders => _runningOrders;

  List<OrderModel> get historyOrderList => _historyOrderList;

  List<OrderDetailsModel> get orderDetailsModel => _orderDetailsModel;

  bool get isLoading => _isLoading;

  int get orderIndex => _orderIndex;

  bool get campaignOnly => _campaignOnly;

  String get otp => _otp;

  int get historyIndex => _historyIndex;

  List<String> get statusList => _statusList;

  bool get paginate => _paginate;

  int get pageSize => _pageSize;

  int get offset => _offset;

  String get orderType => _orderType;
  int _paymentMethodIndex = 0;

  int get paymentMethodIndex => _paymentMethodIndex;

  void clearPrevData() {
    // _addressIndex = -1;
    _paymentMethodIndex = Get.find<SplashController>()
            .configModel
            .cashOnDelivery
        ? 0
        : Get.find<SplashController>().configModel.digitalPayment
            ? 1
            : null /*Get.find<SplashController>().configModel.customerWalletStatus == 1 ? 2 : 0*/;
    _selectedDateSlot = 0;
    _selectedTimeSlot = 0;
    _distance = null;
  }

  Future<void> getAllOrders() async {
    _historyIndex = 0;
    Response response = await orderRepo.getAllOrders();
    if (response.statusCode == 200) {
      _allOrderList = [];
      _orderList = [];
      response.body.forEach((order) {
        OrderModel _orderModel = OrderModel.fromJson(order);
        _allOrderList.add(_orderModel);
        _orderList.add(_orderModel);
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setAddressIndex(int index) {
    _addressIndex = index;
    update();
  }

  Future<double> getDistanceInMeter(
      LatLng originLatLng, LatLng destinationLatLng) async {
    _distance = -1;
    Response response =
        await orderRepo.getDistanceInMeter(originLatLng, destinationLatLng);
    try {
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        _distance = DistanceModel.fromJson(response.body)
                .rows[0]
                .elements[0]
                .distance
                .value /
            1000;
      } else {
        _distance = Geolocator.distanceBetween(
              originLatLng.latitude,
              originLatLng.longitude,
              destinationLatLng.latitude,
              destinationLatLng.longitude,
            ) /
            1000;
      }
    } catch (e) {
      _distance = Geolocator.distanceBetween(
            originLatLng.latitude,
            originLatLng.longitude,
            destinationLatLng.latitude,
            destinationLatLng.longitude,
          ) /
          1000;
    }
    update();
    return _distance;
  }

  List<TimeSlotModel> _timeSlots;
  List<TimeSlotModel> _allTimeSlots;

  double get distance => _distance;
  int _selectedDateSlot = 0;

  List<TimeSlotModel> get timeSlots => _timeSlots;

  List<TimeSlotModel> get allTimeSlots => _allTimeSlots;
  int _selectedTimeSlot = 0;

  int get selectedDateSlot => _selectedDateSlot;

  int get selectedTimeSlot => _selectedTimeSlot;

  void updateDateSlot(int index) {
    _selectedDateSlot = index;
    if (_allTimeSlots != null) {
      validateSlot(_allTimeSlots, index);
    }
    update();
  }

  void validateSlot(List<TimeSlotModel> slots, int dateIndex,
      {bool notify = true}) {
    _timeSlots = [];
    int _day = 0;
    if (dateIndex == 0) {
      _day = DateTime.now().weekday;
    } else {
      _day = DateTime.now().add(Duration(days: 1)).weekday;
    }
    if (_day == 7) {
      _day = 0;
    }
    slots.forEach((slot) {
      if (_day == slot.day &&
          (dateIndex == 0 ? slot.endTime.isAfter(DateTime.now()) : true)) {
        _timeSlots.add(slot);
      }
    });
    if (notify) {
      update();
    }
  }

  Future<void> getCurrentOrders() async {
    Response response = await orderRepo.getCurrentOrders();
    if (response.statusCode == 200) {
      _runningOrderList = [];
      _runningOrders = [
        RunningOrderModel(status: 'pending', orderList: []),
        RunningOrderModel(status: 'confirmed', orderList: []),
        //RunningOrderModel(status: 'cooking', orderList: []),
        RunningOrderModel(status: 'ready_for_handover', orderList: []),
        RunningOrderModel(status: 'food_on_the_way', orderList: []),
      ];
      response.body.forEach((order) {
        OrderModel _orderModel = OrderModel.fromJson(order);
        _runningOrderList.add(_orderModel);
      });
      _campaignOnly = true;
      toggleCampaignOnly();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  // Future<void> getCompletedOrders() async {
  //   Response response = await orderRepo.getCompletedOrders();
  //   if(response.statusCode == 200) {
  //     _historyOrderList = [];
  //     response.body.forEach((order) {
  //       OrderModel _orderModel = OrderModel.fromJson(order);
  //       _historyOrderList.add(_orderModel);
  //     });
  //   }else {
  //     ApiChecker.checkApi(response);
  //   }
  //   setHistoryIndex(0);
  // }

  Future<void> getPaginatedOrders(int offset, bool reload) async {
    if (offset == 1 || reload) {
      _offsetList = [];
      _offset = 1;
      if (reload) {
        _historyOrderList = null;
      }
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      Response response = await orderRepo.getPaginatedOrderList(
          offset, _statusList[_historyIndex]);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _historyOrderList = [];
        }
        _historyOrderList
            .addAll(PaginatedOrderModel.fromJson(response.body).orders);
        _pageSize = PaginatedOrderModel.fromJson(response.body).totalSize;
        _paginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if (_paginate) {
        _paginate = false;
        update();
      }
    }
  }

  void showBottomLoader() {
    _paginate = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void setOrderType(String type) {
    _orderType = type;
    print('order type: $type');
    getPaginatedOrders(1, true);
  }

  Future<bool> updateOrderStatus(int orderID, String status,
      {bool back = false}) async {
    _isLoading = true;
    update();
    UpdateStatusBody _updateStatusBody = UpdateStatusBody(
      orderId: orderID,
      status: status,
      otp: status == 'delivered' ? _otp : null,
    );
    Response response = await orderRepo.updateOrderStatus(_updateStatusBody);
    Get.back();
    bool _isSuccess;
    if (response.statusCode == 200) {
      if (back) {
        Get.back();
      }
      getCurrentOrders();
      showCustomSnackBar(response.body['message'], isError: false);
      _isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }

  DeliveryMan deliveryMan;

  Future<void> getOrderDetails(int orderID) async {
    _orderDetailsModel = null;
    Response response = await orderRepo.getOrderDetails(orderID);
    if (response.statusCode == 200) {
      _orderDetailsModel = [];
      final body = response.body;
      body['details'].forEach(
          (orderDetails) => _orderDetailsModel.add(OrderDetailsModel.fromJson(
                orderDetails,
              )));
      deliveryMan = DeliveryMan.fromMap(body['delivery_man'] ?? {});
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setOrderIndex(int index) {
    _orderIndex = index;
    update();
  }

  void toggleCampaignOnly() {
    _campaignOnly = !_campaignOnly;
    _runningOrders[0].orderList = [];
    _runningOrders[1].orderList = [];
    _runningOrders[2].orderList = [];
    _runningOrders[3].orderList = [];
    //_runningOrders[4].orderList = [];
    _runningOrderList.forEach((order) {
      if (order.orderStatus == 'pending' &&
          (Get.find<SplashController>().configModel.orderConfirmationModel !=
                  'deliveryman' ||
              order.orderType == 'take_away' ||
              Get.find<AuthController>()
                      .profileModel
                      .restaurants[0]
                      .selfDeliverySystem ==
                  1) &&
          (_campaignOnly ? order.foodCampaign == 1 : true)) {
        _runningOrders[0].orderList.add(order);
      } else if ((order.orderStatus == 'confirmed' ||
              (order.orderStatus == 'accepted' && order.confirmed != null)) &&
          (_campaignOnly ? order.foodCampaign == 1 : true)) {
        _runningOrders[1].orderList.add(order);
      } else if (order.orderStatus == 'processing' &&
          (_campaignOnly ? order.foodCampaign == 1 : true)) {
        _runningOrders[2].orderList.add(order);
      } else if (order.orderStatus == 'handover' &&
          (_campaignOnly ? order.foodCampaign == 1 : true)) {
        _runningOrders[3].orderList.add(order);
      } else if (order.orderStatus == 'picked_up' &&
          (_campaignOnly ? order.foodCampaign == 1 : true)) {
        _runningOrders[4].orderList.add(order);
      }
    });
    update();
  }

  void setOtp(String otp) {
    _otp = otp;
    if (otp != '') {
      update();
    }
  }

  void setHistoryIndex(int index) {
    _historyIndex = index;
    getPaginatedOrders(offset, true);
    update();
  }

// int countHistoryList(int index) {
//   int _length;
//   if(index == 0) {
//     _length = _historyOrderList.length;
//   }else {
//     _length = _historyOrderList.where((order) => order.orderStatus == _statusList[index]).length;
//   }
//   return _length;
// }

}
