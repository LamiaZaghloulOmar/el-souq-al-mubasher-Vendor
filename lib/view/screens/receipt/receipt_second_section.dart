// import 'package:flutter/material.dart';
import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/delivery_man.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_model.dart';
import 'package:efood_multivendor_restaurant/view/screens/receipt/receipt_text_row.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart';

class ReceiptSecondSection extends StatelessWidget {
  ReceiptSecondSection(this.orderModel, this.deliveryMan);

  final DeliveryMan deliveryMan;
  final OrderModel orderModel;

  @override
  Widget build(context) {
    print('ReceiptSecondSection');
    print(deliveryMan.fullName);
    return Column(
      children: [
        if (orderModel.customer != null &&
            !Get.find<AuthController>().isRestaurant(
                orderModel.deliveryAddress.contactPersonName,
                orderModel.deliveryAddress.contactPersonNumber)) ...[
          ReceiptTextRow(
              title: 'Name',
              value: orderModel.deliveryAddress.contactPersonName),
          ReceiptTextRow(
              title: 'Tel',
              value: orderModel.deliveryAddress.contactPersonNumber),

/*
        ReceiptTextRow(
            title: 'Area', value: orderModel.deliveryAddress.address),
*/
          ReceiptTextRow(
              title: 'St', value: orderModel.deliveryAddress.address),
          ReceiptTextRow(title: 'Pilot', value: deliveryMan.fullName),
        ],

        // ReceiptTextRow(title: 'Build', value: ''),
      ],
    );
  }
}
