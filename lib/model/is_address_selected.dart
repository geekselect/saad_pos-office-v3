import 'dart:convert';

class IsAddressSelectedModel {
  IsAddressSelectedModel({
    required this.success,
    required this.data,
  });

  final bool success;
  final Data? data;

  factory IsAddressSelectedModel.fromRawJson(String str) => IsAddressSelectedModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IsAddressSelectedModel.fromJson(Map<String, dynamic> json) => IsAddressSelectedModel(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success ,
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    required this.id,
    required this.lat,
    required this.lang,
    required this.address,
    required this.type,
    required this.selected,
  });

  final int id;
  final String lat;
  final String lang;
  final String address;
  final String type;
  final int selected;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    lat: json["lat"] == null ? null : json["lat"],
    lang: json["lang"] == null ? null : json["lang"],
    address: json["address"] == null ? null : json["address"],
    type: json["type"] == null ? null : json["type"],
    selected: json["selected"] == null ? null : json["selected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id ,
    "lat": lat ,
    "lang": lang ,
    "address": address,
    "type": type ,
    "selected": selected,
  };
}
