import 'package:efood_multivendor_restaurant/data/model/response/delivery_man.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';

class OrderDetailsModel {
  int id;
  int foodId;
  int orderId;
  double price;
  Product foodDetails;
  List<Variation> variation;
  List<AddOn> addOns;
  double discountOnFood;
  String discountType;
  int quantity;
  double taxAmount;
  String variant;
  String createdAt;
  String updatedAt;
  int itemCampaignId;
  DeliveryMan deliveryMan;
  double totalAddOnPrice;

  num get totalPrice => (price) * quantity;

  OrderDetailsModel(
      {this.id,
      this.foodId,
      this.deliveryMan,
      this.orderId,
      this.price,
      this.foodDetails,
      this.variation,
      this.addOns,
      this.discountOnFood,
      this.discountType,
      this.quantity,
      this.taxAmount,
      this.variant,
      this.createdAt,
      this.updatedAt,
      this.itemCampaignId,
      this.totalAddOnPrice});

  OrderDetailsModel.fromJson(
    Map<String, dynamic> details,
  ) {
    id = details['id'];
    // deliveryMan = DeliveryMan.fromMap(map['delivery_man']);
    foodId = details['food_id'];
    orderId = details['order_id'];
    price = details['price'].toDouble();
    foodDetails = details['food_details'] != null
        ? new Product.fromJson(details['food_details'])
        : null;
    final List jsonVariation = details['variation'];
    if (jsonVariation != null && jsonVariation.isNotEmpty) {
      variation = [];
      print(jsonVariation.runtimeType);
      jsonVariation.forEach((v) {
        if (v is Map) {
          variation.add(new Variation.fromJson(v));
        }
        print(v.runtimeType);
      });
    }
    if (details['add_ons'] != null) {
      addOns = [];
      details['add_ons'].forEach((v) {
        addOns.add(new AddOn.fromJson(v));
      });
    }
    discountOnFood = details['discount_on_food'].toDouble();
    discountType = details['discount_type'];
    quantity = details['quantity'];
    taxAmount = details['tax_amount'].toDouble();
    variant = details['variant'];
    createdAt = details['created_at'];
    updatedAt = details['updated_at'];
    itemCampaignId = details['item_campaign_id'];
    totalAddOnPrice = details['total_add_on_price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['food_id'] = this.foodId;
    data['order_id'] = this.orderId;
    data['price'] = this.price;
    if (this.foodDetails != null) {
      data['food_details'] = this.foodDetails.toJson();
    }
    if (this.variation != null) {
      data['variation'] = this.variation.map((v) => v.toJson()).toList();
    }
    if (this.addOns != null) {
      data['add_ons'] = this.addOns.map((v) => v.toJson()).toList();
    }
    data['discount_on_food'] = this.discountOnFood;
    data['discount_type'] = this.discountType;
    data['quantity'] = this.quantity;
    data['tax_amount'] = this.taxAmount;
    data['variant'] = this.variant;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['item_campaign_id'] = this.itemCampaignId;
    data['total_add_on_price'] = this.totalAddOnPrice;
    return data;
  }
}

class AddOn {
  String name;
  double price;
  int quantity;

  AddOn({this.name, this.price, this.quantity});

  AddOn.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'].toDouble();
    quantity = int.parse(json['quantity'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    return data;
  }
}
