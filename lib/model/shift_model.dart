// To parse this JSON data, do
//
//     final listShiftModel = listShiftModelFromJson(jsonString);

import 'dart:convert';

ListShiftModel listShiftModelFromJson(String str) => ListShiftModel.fromJson(json.decode(str));

String listShiftModelToJson(ListShiftModel data) => json.encode(data.toJson());

class ListShiftModel {
  List<ShiftModel>? data;
  bool? success;

  ListShiftModel({
    this.data,
    this.success,
  });

  factory ListShiftModel.fromJson(Map<String, dynamic> json) => ListShiftModel(
    data: json["data"] == null ? [] : List<ShiftModel>.from(json["data"]!.map((x) => ShiftModel.fromJson(x))),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
  };
}

class ShiftModel {
  dynamic id;
  dynamic vendorId;
  dynamic userId;
  dynamic shiftDate;
  dynamic shiftName;
  dynamic shiftCode;
  DateTime? createdAt;
  DateTime? updatedAt;

  ShiftModel({
    this.id,
    this.vendorId,
    this.userId,
    this.shiftDate,
    this.shiftName,
    this.shiftCode,
    this.createdAt,
    this.updatedAt,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) => ShiftModel(
    id: json["id"],
    vendorId: json["vendor_id"],
    userId: json["user_id"],
    shiftDate: json["shift_date"],
    shiftName: json["shift_name"],
    shiftCode: json["shift_code"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vendor_id": vendorId,
    "user_id": userId,
    "shift_date": shiftDate,
    "shift_name": shiftName,
    "shift_code": shiftCode,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
