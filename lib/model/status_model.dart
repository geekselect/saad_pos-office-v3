import 'dart:convert';

StatusModel statusModelFromJson(String str) => StatusModel.fromJson(json.decode(str));

String statusModelToJson(StatusModel data) => json.encode(data.toJson());

class StatusModel {
  StatusModel({
    required this.success,
    required this.data,
  });

  final bool success;
  final Data data;

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
    success: json["success"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.id,
    required this.vendorStatus,
    required this.deliveryStatus,
    required this.pickupStatus,
  });

  final int id;
  final int vendorStatus;
  final int deliveryStatus;
  final int pickupStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    vendorStatus: json["vendor_status"],
    deliveryStatus: json["delivery_status"],
    pickupStatus: json["pickup_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vendor_status": vendorStatus,
    "delivery_status": deliveryStatus,
    "pickup_status": pickupStatus,
  };
}
