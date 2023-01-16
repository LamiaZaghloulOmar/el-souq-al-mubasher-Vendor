import 'package:efood_multivendor_restaurant/data/model/response/order_details_model.dart';

class OrderDetails {
  final List<OrderDetailsModel> orderDetailsModel;

  final num totalPrice,
      totalPaid,
      addons,
      subTotal,
      discount,
      vatTax,
      deliveryFee;

  OrderDetails({
    this.totalPaid,
    this.orderDetailsModel,
    this.totalPrice,
    this.addons,
    this.subTotal,
    this.discount,
    this.vatTax,
    this.deliveryFee,
  });
}
