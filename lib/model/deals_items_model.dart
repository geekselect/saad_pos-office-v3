import 'dart:convert';

DealsItemsModel dealsItemsModelFromMap(String str) => DealsItemsModel.fromMap(json.decode(str));

String dealsItemsModelToMap(DealsItemsModel data) => json.encode(data.toMap());

class DealsItemsModel {
  DealsItemsModel({
    required this.success,
    required this.data,
  });

  final bool success;
  final List<Datum> data;

  factory DealsItemsModel.fromMap(Map<String, dynamic> json) => DealsItemsModel(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.vendorId,
    required this.menuCategoryId,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.displayPrice,
    required this.displayDiscountPrice,
    required this.status,
  });

  final int id;
  final int vendorId;
  final int menuCategoryId;
  final String name;
  final String image;
  final String description;
  final String price;
  final String displayPrice;
  final String displayDiscountPrice;
  final int status;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    vendorId: json["vendor_id"],
    menuCategoryId: json["menu_category_id"],
    name: json["name"],
    image: json["image"],
    description: json["description"],
    price: json["price"],
    displayPrice: json["display_price"],
    displayDiscountPrice: json["display_discount_price"],
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "vendor_id": vendorId,
    "menu_category_id": menuCategoryId,
    "name": name,
    "image": image,
    "description": description,
    "price": price,
    "display_price": displayPrice,
    "display_discount_price": displayDiscountPrice,
    "status": status,
  };
}
