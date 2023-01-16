// import 'package:flutter/material.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_model.dart';
import 'package:efood_multivendor_restaurant/helper/date_time_helper.dart';
import 'package:efood_multivendor_restaurant/view/screens/receipt/receipt_text_row.dart';
import 'package:pdf/widgets.dart';

class ReceiptFirstSection extends StatelessWidget {
  ReceiptFirstSection({this.orderModel});

  final OrderModel orderModel;

  @override
  Widget build(context) {
    return Column(
      children: [
        ReceiptTextRow(title: 'Received Date', value: orderModel.createdAt),
        ReceiptTextRow(
            title: 'Print Date',
            value: DateTimeHelper.formatDateTime(DateTime.now())),
/*
        ReceiptTextRow(title: 'Order Taker', value: 'محمد عاطف'),
        ReceiptTextRow(title: 'Pilot', value: 'محمد عاطف'),
        ReceiptTextRow(
            title: 'Assign',
            value: DateTimeHelper.formatDateTime(DateTime.now())),
*/
      ],
    );
  }
}
