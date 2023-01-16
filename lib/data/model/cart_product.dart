import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';

class CartProduct {
  final Product product;
  int quantity = 1;

  CartProduct({this.product});

  num get totalPrice => (product.price) * quantity;

  void incrementQuantity() {
    quantity++;
  }

  void decrementQuantity() {
    quantity--;
  }
}
