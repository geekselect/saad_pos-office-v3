import 'dart:convert';

VendorItemModel vendorItemModelFromJson(String str) => VendorItemModel.fromJson(json.decode(str));

String vendorItemModelToJson(VendorItemModel data) => json.encode(data.toJson());

class VendorItemModel {
  VendorItemModel({
    required this.success,
    required this.data,
  });

  final bool success;
  final List<Datum> data;

  factory VendorItemModel.fromJson(Map<String, dynamic> json) => VendorItemModel(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int vendorId;
  final String name;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    vendorId: json["vendor_id"],
    name: json["name"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vendor_id": vendorId,
    "name": name,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
