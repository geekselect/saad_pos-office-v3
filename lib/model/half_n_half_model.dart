import 'dart:convert';

HalfNHalfModel halfNHalfModelFromMap(String str) => HalfNHalfModel.fromMap(json.decode(str));

String halfNHalfModelToMap(HalfNHalfModel data) => json.encode(data.toMap());

class HalfNHalfModel {
  HalfNHalfModel({
    required this.success,
    required this.data,
  });

  final bool success;
  final List<Datum> data;

  factory HalfNHalfModel.fromMap(Map<String, dynamic> json) => HalfNHalfModel(
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
    required this.itemCategoryId,
    required this.name,
    required this.image,
    required this.description,
    required this.status,
  });

  final int id;
  final int vendorId;
  final int menuCategoryId;
  final int itemCategoryId;
  final String name;
  final String image;
  final String description;
  final int status;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    vendorId: json["vendor_id"],
    menuCategoryId: json["menu_category_id"],
    itemCategoryId: json["item_category_id"],
    name: json["name"],
    image: json["image"],
    description: json["description"],
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "vendor_id": vendorId,
    "menu_category_id": menuCategoryId,
    "item_category_id": itemCategoryId,
    "name": name,
    "image": image,
    "description": description,
    "status": status,
  };
}
