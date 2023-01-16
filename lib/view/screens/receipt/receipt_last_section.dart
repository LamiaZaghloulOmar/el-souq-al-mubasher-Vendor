// import 'package:flutter/material.dart';
import 'package:efood_multivendor_restaurant/data/model/order_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_model.dart';
import 'package:efood_multivendor_restaurant/view/screens/receipt/receipt_text_row.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class ReceiptLastSection extends StatelessWidget {
  ReceiptLastSection(this.orderModel, this.order);

  final OrderModel orderModel;
  final OrderDetails order;

  @override
  Widget build(context) {
    return Column(
      children: [
        ReceiptTextRow(title: 'Total', value: order.totalPrice.toString()),
        // ReceiptTextRow(
        //     title: 'Delivery Charge', value: order.deliveryFee.toString()),
        ReceiptTextRow(title: 'Discount', value: order.discount.toString()),
        ReceiptTextRow(
            title: 'Coupon Discount',
            value: orderModel.couponDiscountAmount.toString()),
/*
        ReceiptTextRow(title: 'Reward Bites', value: order.),
        ReceiptTextRow(title: 'Redeem Bites', value: '\$12.00'),
        ReceiptTextRow(title: 'Your Balance', value: '\$12.00'),
*/
        ReceiptTextRow(title: 'Addons', value: order.addons.toString()),
        // ReceiptTextRow(title: 'vat/tax', value: order.vatTax.toString()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Total Duo'),
            Container(
                decoration:
                    BoxDecoration(border: Border.all(color: PdfColors.black)),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      order.totalPaid.toString(),
                      style: TextStyle(color: PdfColors.black),
                    )))),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Center(
            child: BarcodeWidget(
                data: orderModel.id.toString(),
                height: 80,
                width: 80,
                barcode: Barcode.qrCode()))
      ],
    );
  }
}
