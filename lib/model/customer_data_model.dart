// To parse this JSON data, do
//
//     final customerDataModel = customerDataModelFromJson(jsonString);

import 'dart:convert';

CustomerDataModel customerDataModelFromJson(String str) =>
    CustomerDataModel.fromJson(json.decode(str));

String customerDataModelToJson(CustomerDataModel data) =>
    json.encode(data.toJson());

class CustomerDataModel {
  CustomerDataModel({
    this.tempUser,
    this.registeredUser,
  });

  List<User>? tempUser;
  List<User>? registeredUser;

  factory CustomerDataModel.fromJson(Map<String, dynamic> json) =>
      CustomerDataModel(
        tempUser: json["Temp user"] == null
            ? []
            : List<User>.from(json["Temp user"]!.map((x) => User.fromJson(x))),
        registeredUser: json["Registered User"] == null
            ? []
            : List<User>.from(
                json["Registered User"]!.map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Temp user": tempUser == null
            ? []
            : List<dynamic>.from(tempUser!.map((x) => x.toJson())),
        "Registered User": registeredUser == null
            ? []
            : List<dynamic>.from(registeredUser!.map((x) => x.toJson())),
      };
}

class User {
  User({
    this.name,
    this.phone,
  });

  String? name;
  String? phone;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
      };
}
