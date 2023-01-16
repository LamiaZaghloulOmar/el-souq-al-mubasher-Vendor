// import 'package:flutter/material.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart';
// import 'package:get/get.dart';

class ReceiptTable extends StatelessWidget {
  final List<OrderDetailsModel> orderDetailsModel;

  ReceiptTable(this.orderDetailsModel);

  //combine items quantity and price
  List<OrderDetailsModel> get items {
    List<OrderDetailsModel> newItems = [];
    for (int i = 0; i < orderDetailsModel.length; i++) {
      final item = orderDetailsModel[i];
      final index =
          newItems.indexWhere((element) => element.foodId == item.foodId);
      print('index $index');
      if (index == -1) {
        newItems.add(item);
      } else {
        newItems[index].quantity += item.quantity;
      }
    }
    print('newItems: ${newItems[0].toJson()}');
    return newItems;
  }

  Widget buildDataCellText(String text) {
    return SizedBox(
      // height: 30,
      // create: (context) => SubjectRepository(),
      child: Center(
          child: Text(text,
              // overflow: TextOverflow.span,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(fontSize: 16))),
    );
  }

  Widget buildColumn({@required String label}) {
    return SizedBox(
        // width: Get.width / 4,
        width: 150,
        child: Center(
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              )),
        ));
  }

  @override
  Widget build(context) {
    return Table(
        border: TableBorder(
          top: BorderSide(width: 2),
        ),
        children: [
          TableRow(children: [
            buildColumn(label: 'Qty'),
            buildColumn(label: 'Item'),
            buildColumn(label: 'Price'),
            buildColumn(label: 'Total'),
          ]),
          ...items
              .map((msg) => TableRow(children: [
                    buildDataCellText(msg.quantity.toString()),
                    buildDataCellText(msg.foodDetails.name),
                    buildDataCellText(msg.price.toString()),
                    buildDataCellText(msg.totalPrice.toString()),
                  ]))
              .toList(),
        ]);
  }
}

class RtlDirectionText extends StatelessWidget {
  final String text;

  RtlDirectionText(this.text);

  @override
  Widget build(context) {
    return Text(text, textDirection: TextDirection.rtl);
  }
}
