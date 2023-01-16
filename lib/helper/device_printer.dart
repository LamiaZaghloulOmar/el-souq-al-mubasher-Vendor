import 'dart:typed_data';

import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/order_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/delivery_man.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_model.dart';
import 'package:efood_multivendor_restaurant/view/screens/receipt/receipt_first_section.dart';
import 'package:efood_multivendor_restaurant/view/screens/receipt/receipt_header.dart';
import 'package:efood_multivendor_restaurant/view/screens/receipt/receipt_last_section.dart';
import 'package:efood_multivendor_restaurant/view/screens/receipt/receipt_second_section.dart';
import 'package:efood_multivendor_restaurant/view/screens/receipt/receipt_table.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class DevicePrinter {
  static Future<Uint8List> printReceipt(OrderModel orderModel,
      OrderDetails orderDetails, DeliveryMan deliveryMan) async {
/*
    final logo = MemoryImage(
      (await rootBundle.load('assets/image/logo.png')).buffer.asUint8List(),
    );

    print(orderModel.restaurantLogo);
*/
    MemoryImage logo;
    try {
      final networkAssetLogo = (await NetworkAssetBundle(Uri.parse(
              '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}/${orderModel.restaurantLogo}'))
          .load(orderModel.restaurantLogo));

      logo = MemoryImage(networkAssetLogo.buffer.asUint8List());
    } catch (e) {
      logo = MemoryImage(
        (await rootBundle.load('assets/image/logo.png')).buffer.asUint8List(),
      );
    }

    final arabicFont =
        Font.ttf(await rootBundle.load("assets/font/hacen/hacen_tunisia.ttf"));
    final Document pdf = Document();

    pdf.addPage(
      MultiPage(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          margin: EdgeInsets.all(0),
          // pageFormat: PdfPageFormat.a4,
          theme: ThemeData(
              defaultTextStyle: TextStyle(font: arabicFont, fontSize: 16)),
          pageFormat: PdfPageFormat.a6,
          build: (Context context) {
            return [
              ReceiptHeader(memoryImage: (logo), orderModel: orderModel),
              ReceiptFirstSection(orderModel: orderModel),
              ReceiptSecondSection(orderModel, deliveryMan),
              ReceiptTable(orderDetails.orderDetailsModel),
              ReceiptLastSection(orderModel, orderDetails),

/*
                ReceiptLayout(arguments: arguments, logo: logo),
                ReceiptTable(arguments),
                BottomReceipt(arguments)
*/
            ];
          }),
    );
    return pdf.save();

/*
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
    });
*/
  }
}
