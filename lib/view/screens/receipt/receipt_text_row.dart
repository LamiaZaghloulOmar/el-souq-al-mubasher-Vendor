// import 'package:flutter/material.dart';
import 'package:efood_multivendor_restaurant/view/screens/receipt/receipt_table.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart';

class ReceiptTextRow extends StatelessWidget {
  ReceiptTextRow({@required this.title, @required this.value});

  final String title, value;

  @override
  Widget build(context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // verticalDirection: languageController.isArabic
        //     ? VerticalDirection.up
        //     : VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RtlDirectionText(
            (title).toString(),
          ),
          Expanded(
            child: RtlDirectionText(value),
          )
        ]);
  }
}
