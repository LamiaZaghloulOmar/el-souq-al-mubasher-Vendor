import 'package:efood_multivendor_restaurant/data/api/api_client.dart';
import 'package:efood_multivendor_restaurant/data/model/body/place_order_body.dart';
import 'package:efood_multivendor_restaurant/data/model/body/update_status_body.dart';
import 'package:efood_multivendor_restaurant/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo extends GetxService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepo({@required this.apiClient, @required this.sharedPreferences});
  Future<Response> cancelOrder(String orderID) async {
    return await apiClient.postData(
        AppConstants.ORDER_CANCEL_URI, {'_method': 'put', 'order_id': orderID});
  }

  Future<Response> getHistoryOrderList(int offset) async {
    return await apiClient.getData(
        '${AppConstants.HISTORY_ORDER_LIST_URI}?offset=$offset&limit=10');
  }

  Future<Response> getDistanceInMeter(
      LatLng originLatLng, LatLng destinationLatLng) async {
    return await apiClient.getData('${AppConstants.DISTANCE_MATRIX_URI}'
        '?origin_lat=${originLatLng.latitude}&origin_lng=${originLatLng.longitude}'
        '&destination_lat=${destinationLatLng.latitude}&destination_lng=${destinationLatLng.longitude}');
  }

  Future<Response> getRunningOrderList(int offset) async {
    return await apiClient.getData(
        '${AppConstants.RUNNING_ORDER_LIST_URI}?offset=$offset&limit=10');
  }

  Future<Response> trackOrder(String orderID) async {
    return await apiClient.getData('${AppConstants.TRACK_URI}$orderID');
  }

  Future<Response> getAllOrders() {
    return apiClient.getData(AppConstants.ALL_ORDERS_URI);
  }

  Future<Response> getCurrentOrders() {
    return apiClient.getData(AppConstants.CURRENT_ORDERS_URI);
  }

  Future<Response> getCompletedOrders() {
    return apiClient.getData(AppConstants.COMPLETED_ORDERS_URI);
  }

  Future<Response> getPaginatedOrderList(int offset, String status) async {
    return await apiClient.getData(
        '${AppConstants.COMPLETED_ORDERS_URI}?status=$status&offset=$offset&limit=10');
  }

  Future<Response> updateOrderStatus(UpdateStatusBody updateStatusBody) {
    return apiClient.postData(
        AppConstants.UPDATE_ORDER_STATUS_URI, updateStatusBody.toJson());
  }

/*
I/flutter (20427): ====> API Body: {cart: [{food_id: 155, item_campaign_id: null, price: 90.0, variant: , variation: [{type: dss, price: 100.0}], quantity: 1, add_on_ids: [], add_ons: [], add_on_qtys: []}], coupon_discount_amount: 0.0, coupon_discount_title: null, order_amount: 242.53807808020747, order_type: delivery, payment_method: cash_on_delivery, order_note: , coupon_code: null, restaurant_id: 18, distance: 70.86903904010373, schedule_at: null, discount_amount: 10.0, tax_amount: 10.799999999999999, address: 8G3F35CR+7M, latitude: 31.070678430196978, longitude: 29.191629365086555, contact_person_name: Mohamed Gaber, contact_person_number: +201283894969, address_type: others}
I/flutter (20427): ====> API Response: [200] /api/v1/customer/order/place
I/flutter (20427): {message: Order placed successfully!, order_id: 100088, total_ammount: 242.8}

 */
  Future<Response> placeOrder(PlaceOrderBody orderBody) async {
    return await apiClient.postData(
        AppConstants.PLACE_ORDER_URI, orderBody.toJson());
  }

  Future<Response> getOrderDetails(int orderID) {
    return apiClient.getData('${AppConstants.ORDER_DETAILS_URI}$orderID');
  }

  Future<Response> switchToCOD(String orderID) async {
    return await apiClient.postData(
        AppConstants.COD_SWITCH_URL, {'_method': 'put', 'order_id': orderID});
  }
}
