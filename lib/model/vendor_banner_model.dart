import 'dart:convert';

VendorBanner vendorBannerFromMap(String str) => VendorBanner.fromMap(json.decode(str));

String vendorBannerToMap(VendorBanner data) => json.encode(data.toMap());

class VendorBanner {
  VendorBanner({
    required this.success,
    required this.data,
  });

  final bool success;
  final List<Datum> data;

  factory VendorBanner.fromMap(Map<String, dynamic> json) => VendorBanner(
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
    required this.image,
    required this.description,
  });

  final int id;
  final int vendorId;
  final String image;
  final String description;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    vendorId: json["vendor_id"],
    image: json["image"],
    description: json["description"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "vendor_id": vendorId,
    "image": image,
    "description": description,
  };
}
