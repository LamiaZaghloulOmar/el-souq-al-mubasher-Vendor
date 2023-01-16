import 'package:efood_multivendor_restaurant/data/model/body/place_order_body.dart';
import 'package:efood_multivendor_restaurant/data/model/cart_product.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/data/repository/order_repo.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  OrderRepo _orderRepo = Get.find<OrderRepo>();
  final List<CartProduct> products = [];

  void addProduct(Product product) {
    products.add(CartProduct(product: product));
    update();
  }

  int get cartLength => products.length;

  num get _totalPrice => products
      .map((element) => element.totalPrice)
      .reduce((value, element) => value + element);

  String get price => '${_totalPrice.toStringAsFixed(2)} EGP';

  void removeProduct(Product product) {
    products.removeWhere((element) => product.id == element.product.id);
    update();
  }

  int index(Product product) =>
      products.indexWhere((element) => element.product.id == product.id);

  CartProduct cartProduct(Product product) =>
      products.singleWhere((element) => element.product.id == product.id);

  bool isProductInCart(Product product) => index(product) != -1;

  void increaseQuantity(Product product) {
    products[index(product)].incrementQuantity();
    update();
  }

  void decreaseQuantity(Product product) {
    final cartItem = cartProduct(product);
    if (cartItem.quantity == 1) {
      removeProduct(product);
    } else {
      products[index(product)].decrementQuantity();
    }
    update();
  }

/*
I/flutter (20427): Header: {Content-Type: application/json; charset=UTF-8, zoneId: 11, X-localization: en, Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiZTU0MzZkYTdiNzc4NmQyNjRiMzU4NDNkMmMxMjg3MDJlNjc0Y2Y0MWM5NmNlOTMzYjNkMmEzMTNhZTRiZmVkZjc0ZDU1YjA2NGMwMWRmMzAiLCJpYXQiOjE2NTM2ODYxMDguNzIyNTMyLCJuYmYiOjE2NTM2ODYxMDguNzIyNTM0LCJleHAiOjE2ODUyMjIxMDguNzIxMTI2LCJzdWIiOiI1MSIsInNjb3BlcyI6W119.aNipzSufyEq9EXOvlbWu_NPEbY7lnMpqSWKW0ORQB7JS3POo4lIGFmK1OCGdsETMJlVNHTjw_z3ISpLI7MQM9y3I4JLGnF1umxhh8hFjk4e8hcYgBC_Olice_bOkJqzL6xsV7JXg9atv5uHxhGD9g3Mt7igIKOEHTfUzflKLxLdn3wE5odzXZr9CD2p9ap_qiocko-jdwT4S9LJBcyeC0sQM2tc0Mmi2XMYWIhsVK4rrkTcTIafDyhqst6FCDYRhSrdVMqWxqMYvm_21sETsGArFKiv7ISuDILZTL7iLaRjBvTqPKB3_7Sk49BsFSHebaFnMdNhKaHvR_IlNt3lnsYzeex_aAJ_I8O2M4gpW1-jylCzyRfphAMPI3rdpSG0EHVRlQFJV_6RBeZRqk5trrgGk9e65XbW40xXa3DguPNtv1ajSQTT5Wib_liHctFAfdHjt8XKZj0qEdly9-6f5eZmYTqkySuVtSlrd3aUrLgAx7nGVgfIuvg36CLDmDq1Nnc5Xuj_cp0uvOSaau7LoceDkbJCeb6V9cnYYdf3M0bCOuKmo6jOiKKwT7xt0wsDVfAhod3nnmP_6N1UaDcSrGcEPvrF90NOHfYeiChh
I/flutter (20427): ====> API Body: {cart: [{food_id: 155, item_campaign_id: null,
 price: 90.0, variant: ,
  variation: [{type: dss, price: 100.0}],
   quantity: 1,
    add_on_ids: [41],
    add_ons: [{id: 41, name: مكسرات, price: 100.0}],
     add_on_qtys: [1]}],
      coupon_discount_amount: 0.0,
      coupon_discount_title: null,
       order_amount: 354.53807808020747,
        order_type: delivery,
        payment_method: cash_on_delivery,
         order_note: , coupon_code: null,
         restaurant_id: 18, distance: 70.86903904010373,
         schedule_at: null, discount_amount: 10.0,
         tax_amount: 22.8, address: 8G3F35CR+7M, latitude: 31.070678430196978, longitude: 29.191629365086555, contact_person_name: Mohamed Gaber, contact_person_number: +201283894969, address_type: others}
I/flutter (20427): ====> API Response: [200] /api/v1/customer/order/place
I/flutter (20427): {message: Order placed successfully!, order_id: 100089, total_ammount: 354.8}

 */

  createOrder() {
    _orderRepo.placeOrder(PlaceOrderBody(
      cart: products
          .map((e) =>
              Cart(e.product.id, null, price, '', [], e.quantity, [], [], []))
          .toList(),
      couponDiscountAmount: 0,
      distance: 0,
      couponDiscountTitle: null,
      scheduleAt: '',
      orderAmount: 300,
      orderNote: '',
      orderType: 'delivery',
      paymentMethod: 'cash_on_delivery',
      couponCode: null,
      restaurantId: 18,
      address: '',
      latitude: '30',
      longitude: '30',
      addressType: '',
      contactPersonName: '',
      contactPersonNumber: '',
      discountAmount: 0,
      taxAmount: 0,
    ));
  }
}
