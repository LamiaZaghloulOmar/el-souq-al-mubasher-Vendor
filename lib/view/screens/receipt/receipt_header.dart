// import 'package:flutter/material.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_model.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';

class ReceiptHeader extends StatelessWidget {
  final MemoryImage memoryImage;
  final OrderModel orderModel;

  ReceiptHeader({this.orderModel, @required this.memoryImage});

  @override
  Widget build(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image(memoryImage, height: 80, fit: BoxFit.fill),
        Container(
            color: PdfColors.black,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                orderModel.restaurantName,
                style: TextStyle(color: PdfColors.white, fontSize: 20),
              )),
            )),
        Row(
          children: [
            Expanded(
              child: CenteredContainerBorder(
                text: 'Ord.No',
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 3,
              child: CenteredContainerBorder(
                text: orderModel.id.toString(),
              ),
            )
          ],
        )
      ],
    );
  }
}

class CenteredContainerBorder extends StatelessWidget {
  CenteredContainerBorder({@required this.text});
  final String text;

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: PdfColors.black)),
      child: Center(
          child: Text(
        text,
        style: TextStyle(color: PdfColors.black),
      )),
    );
  }
}
