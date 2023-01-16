import 'package:efood_multivendor_restaurant/data/model/order_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/delivery_man.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_model.dart';
import 'package:efood_multivendor_restaurant/helper/device_printer.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class ReceiptPreview extends StatelessWidget {
  const ReceiptPreview({Key key, this.orderModel, this.order, this.deliveryMan})
      : super(key: key);
  final OrderModel orderModel;
  final OrderDetails order;
  final DeliveryMan deliveryMan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PdfPreview(
            // pages: [20],
            onPrinted: (x) {},
            build: (PdfPageFormat format) {
              return DevicePrinter.printReceipt(orderModel, order, deliveryMan);
            }));
  }
}
