// To parse this JSON data, do
//
//     final linklyPairModel = linklyPairModelFromJson(jsonString);

import 'dart:convert';

LinklyPairModel linklyPairModelFromJson(String str) => LinklyPairModel.fromJson(json.decode(str));

String linklyPairModelToJson(LinklyPairModel data) => json.encode(data.toJson());

class LinklyPairModel {
  bool? success;
  Data? data;

  LinklyPairModel({
    this.success,
    this.data,
  });

  factory LinklyPairModel.fromJson(Map<String, dynamic> json) => LinklyPairModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  int? vendorId;
  int? id;
  String? userName;
  String? password;
  String? secretKey;
  String? token;

  Data({
    this.id,
    this.vendorId,
    this.userName,
    this.password,
    this.secretKey,
    this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    vendorId: json["vendor_id"],
    id: json["id"],
    userName: json["user_name"],
    password: json["password"],
    secretKey: json["secret_key"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "vendor_id": vendorId,
    "id": id,
    "user_name": userName,
    "password": password,
    "secret_key": secretKey,
    "token": token,
  };
}
