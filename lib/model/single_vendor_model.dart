import 'dart:convert';

SingleVendorModel singleVendorModelFromMap(String str) => SingleVendorModel.fromMap(json.decode(str));

String singleVendorModelToMap(SingleVendorModel data) => json.encode(data.toMap());

class SingleVendorModel {
  SingleVendorModel({
    required this.success,
    required this.data,
  });

  final bool success;
  final List<Datum> data;

  factory SingleVendorModel.fromMap(Map<String, dynamic> json) => SingleVendorModel(
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
    required this.menuId,
    required this.status,
    required this.menu,
  });

  final int id;
  final int vendorId;
  final int menuCategoryId;
  final int menuId;
  final int status;
  final Menu menu;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    vendorId: json["vendor_id"],
    menuCategoryId: json["menu_category_id"],
    menuId: json["menu_id"],
    status: json["status"],
    menu: Menu.fromMap(json["menu"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "vendor_id": vendorId,
    "menu_category_id": menuCategoryId,
    "menu_id": menuId,
    "status": status,
    "menu": menu.toMap(),
  };
}

class Menu {
  Menu({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.displayPrice,
    required this.displayDiscountPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.isAdded,
  });

  final int id;
  final int vendorId;
  final String name;
  final String image;
  final String description;
  final String? price;
  final String? displayPrice;
  final String? displayDiscountPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isAdded;

  factory Menu.fromMap(Map<String, dynamic> json) => Menu(
    id: json["id"],
    vendorId: json["vendor_id"],
    name: json["name"],
    image: json["image"],
    description: json["description"],
    price: json["price"] == null ? null : json["price"],
    displayPrice: json["display_price"] == null ? null : json["display_price"],
    displayDiscountPrice: json["display_discount_price"] == null ? null : json["display_discount_price"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    isAdded: json["is_added"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "vendor_id": vendorId,
    "name": name,
    "image": image,
    "description": description,
    "price": price == null ? null : price,
    "display_price": displayPrice == null ? null : displayPrice,
    "display_discount_price": displayDiscountPrice == null ? null : displayDiscountPrice,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "is_added": isAdded,
  };
}
