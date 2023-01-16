import 'package:efood_multivendor_restaurant/controller/cart_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControlQuantity extends StatelessWidget {
  ControlQuantity({
    Key key,
    this.product,
    this.size = const Size(70, 40),
  }) : super(key: key);
  final Size size;
  final Product product;
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    if (cartController.isProductInCart(product)) {
      return SizedBox(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            QuantityFloatingActionButton(
                iconData: Icons.remove,
                onPressed: () => cartController.decreaseQuantity(product)),
            Text(
              '${cartController.cartProduct(product).quantity}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            QuantityFloatingActionButton(
                iconData: Icons.add,
                onPressed: () => cartController.increaseQuantity(product)),
          ],
        ),
      );
    } else {
      return TextButton(
        style: ButtonStyle(
            textStyle:
                MaterialStateProperty.all(TextStyle(color: Colors.white)),
            backgroundColor: MaterialStateProperty.all(Colors.green),
            minimumSize: MaterialStateProperty.all(size)),
        onPressed: () => cartController.addProduct(product),
        child: Text(
          'add to cart',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      );
    }
  }
}

class QuantityFloatingActionButton extends StatelessWidget {
  const QuantityFloatingActionButton({
    Key key,
    this.iconData,
    this.onPressed,
  }) : super(key: key);
  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: FloatingActionButton(
        heroTag: null,
        onPressed: onPressed,
        backgroundColor: Colors.orange,
        child: Icon(
          iconData,
          size: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
