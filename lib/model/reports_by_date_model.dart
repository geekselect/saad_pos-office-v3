// To parse this JSON data, do
//
//     final reportByDateModel = reportByDateModelFromJson(jsonString);

import 'dart:convert';

ReportByDateModel reportByDateModelFromJson(String str) => ReportByDateModel.fromJson(json.decode(str));

String reportByDateModelToJson(ReportByDateModel data) => json.encode(data.toJson());

class ReportByDateModel {
  DateTime? from;
  DateTime? to;
  List<Datum>? data;
  List<TotalItemSold>? totalItemSold;
  dynamic sumPosCash;
  dynamic sumPosCard;
  int? sumTotalOrders;
  int? sumTotalTakeaway;
  int? sumTotalDining;

  ReportByDateModel({
    this.from,
    this.to,
    this.data,
    this.totalItemSold,
    this.sumPosCash,
    this.sumPosCard,
    this.sumTotalOrders,
    this.sumTotalTakeaway,
    this.sumTotalDining,
  });

  factory ReportByDateModel.fromJson(Map<String, dynamic> json) => ReportByDateModel(
    from: json["From"] == null ? null : DateTime.parse(json["From"]),
    to: json["To"] == null ? null : DateTime.parse(json["To"]),
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    totalItemSold: json["totalItemSold"] == null ? [] : List<TotalItemSold>.from(json["totalItemSold"]!.map((x) => TotalItemSold.fromJson(x))),
    sumPosCash: json["sumPosCash"],
    sumPosCard: json["sumPosCard"],
    sumTotalOrders: json["sumTotalOrders"],
    sumTotalTakeaway: json["sumTotalTakeaway"],
    sumTotalDining: json["sumTotalDining"],
  );

  Map<String, dynamic> toJson() => {
    "From": "${from!.year.toString().padLeft(4, '0')}-${from!.month.toString().padLeft(2, '0')}-${from!.day.toString().padLeft(2, '0')}",
    "To": "${to!.year.toString().padLeft(4, '0')}-${to!.month.toString().padLeft(2, '0')}-${to!.day.toString().padLeft(2, '0')}",
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "totalItemSold": totalItemSold == null ? [] : List<dynamic>.from(totalItemSold!.map((x) => x.toJson())),
    "sumPosCash": sumPosCash,
    "sumPosCard": sumPosCard,
    "sumTotalOrders": sumTotalOrders,
    "sumTotalTakeaway": sumTotalTakeaway,
    "sumTotalDining": sumTotalDining,
  };
}

class Datum {
  DateTime? date;
  PosCa? posCash;
  PosCa? posCard;
  OrderPlaced? orderPlaced;
  List<Order>? orders;

  Datum({
    this.date,
    this.posCash,
    this.posCard,
    this.orderPlaced,
    this.orders,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    posCash: json["Pos cash"] == null ? null : PosCa.fromJson(json["Pos cash"]),
    posCard: json["Pos card"] == null ? null : PosCa.fromJson(json["Pos card"]),
    orderPlaced: json["order placed"] == null ? null : OrderPlaced.fromJson(json["order placed"]),
    orders: json["orders"] == null ? [] : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "Pos cash": posCash?.toJson(),
    "Pos card": posCard?.toJson(),
    "order placed": orderPlaced?.toJson(),
    "orders": orders == null ? [] : List<dynamic>.from(orders!.map((x) => x.toJson())),
  };
}

class OrderPlaced {
  int? totalOrders;
  int? totalTakeaway;
  int? totalTotalDining;

  OrderPlaced({
    this.totalOrders,
    this.totalTakeaway,
    this.totalTotalDining,
  });

  factory OrderPlaced.fromJson(Map<String, dynamic> json) => OrderPlaced(
    totalOrders: json["total orders"],
    totalTakeaway: json["total takeaway"],
    totalTotalDining: json["total total_dining"],
  );

  Map<String, dynamic> toJson() => {
    "total orders": totalOrders,
    "total takeaway": totalTakeaway,
    "total total_dining": totalTotalDining,
  };
}

class Order {
  String? itemName;
  int? quantity;

  Order({
    this.itemName,
    this.quantity,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    itemName: json["item_name"]!,
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "item_name": itemName,
    "quantity": quantity,
  };
}


class PosCa {
  String? name;
  dynamic amount;

  PosCa({
    this.name,
    this.amount,
  });

  factory PosCa.fromJson(Map<String, dynamic> json) => PosCa(
    name: json["name"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "amount": amount,
  };
}

class TotalItemSold {
  String? itemName;
  int? quantity;

  TotalItemSold({
    this.itemName,
    this.quantity,
  });

  factory TotalItemSold.fromJson(Map<String, dynamic> json) => TotalItemSold(
    itemName: json["itemName"]!,
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "itemName": itemName,
    "quantity": quantity,
  };
}

