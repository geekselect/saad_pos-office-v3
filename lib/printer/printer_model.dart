// To parse this JSON data, do
//
//     final printerModel = printerModelFromJson(jsonString);

import 'dart:convert';

PrinterModel printerModelFromJson(String str) =>
    PrinterModel.fromJson(json.decode(str));

String printerModelToJson(PrinterModel data) => json.encode(data.toJson());

class PrinterModel {
  PrinterModel({
    this.ipPos,
    this.portPos,
    this.ipKitchen,
    this.portKitchen,
    this.autoStatusKitchen,
    this.autoStatusPos,
  });

  String? ipPos;
  String? portPos;
  String? ipKitchen;
  String? portKitchen;
  dynamic autoStatusKitchen;
  String? autoStatusPos;

  factory PrinterModel.fromJson(Map<String, dynamic> json) => PrinterModel(
        ipPos: json["IP_POS"],
        portPos: json["port_pos"],
        ipKitchen: json["IP_Kitchen"],
        portKitchen: json["port_kitchen"],
        autoStatusKitchen: json["auto_status_kitchen"],
        autoStatusPos: json["auto_status_pos"],
      );

  Map<String, dynamic> toJson() => {
        "IP_POS": ipPos,
        "port_pos": portPos,
        "IP_Kitchen": ipKitchen,
        "port_kitchen": portKitchen,
        "auto_status_kitchen": autoStatusKitchen,
        "auto_status_pos": autoStatusPos,
      };
}
