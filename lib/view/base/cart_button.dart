import 'package:efood_multivendor_restaurant/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartButton extends StatelessWidget {
  const CartButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (logic) {
      return SizedBox(
        width: 80,
        child: IconButton(
          onPressed: () {},

          //  => Get.to(
          //   CartView(), ),

          icon: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.shopping_cart,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              Positioned(
                top: 0,
                right: 30,
                bottom: 20,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Center(child: GetBuilder<CartController>(
                    builder: (logic) {
                      return Text(
                        '${logic.cartLength}',
                        style: TextStyle(
                            height: 1, fontSize: 10, color: Colors.white),
                      );
                    },
                  )),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
