// To parse this JSON data, do
//
//     final reportByDateModel = reportByDateModelFromJson(jsonString);

import 'dart:convert';

ReportByDateModel reportByDateModelFromJson(String str) => ReportByDateModel.fromJson(json.decode(str));

String reportByDateModelToJson(ReportByDateModel data) => json.encode(data.toJson());

class ReportByDateModel {
  List<Datum>? data;
  List<TotalItemSold>? totalItemSold;
  double? sumPosCash;
  double? sumPosCard;
  int? sumPosTotal;
  int? sumTotalOrders;
  int? sumTotalTakeaway;
  int? sumTotalDining;
  int? sumTotalDiscounts;
  int? sumTotalCanceled;
  int? sunTotalIncomplete;

  ReportByDateModel({
    this.data,
    this.totalItemSold,
    this.sumPosCash,
    this.sumPosCard,
    this.sumPosTotal,
    this.sumTotalOrders,
    this.sumTotalTakeaway,
    this.sumTotalDining,
    this.sumTotalDiscounts,
    this.sumTotalCanceled,
    this.sunTotalIncomplete,
  });

  factory ReportByDateModel.fromJson(Map<String, dynamic> json) => ReportByDateModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    totalItemSold: json["totalItemSold"] == null ? [] : List<TotalItemSold>.from(json["totalItemSold"]!.map((x) => TotalItemSold.fromJson(x))),
    sumPosCash: json["sumPosCash"]?.toDouble(),
    sumPosCard: json["sumPosCard"]?.toDouble(),
    sumPosTotal: json["sumPosTotal"],
    sumTotalOrders: json["sumTotalOrders"],
    sumTotalTakeaway: json["sumTotalTakeaway"],
    sumTotalDining: json["sumTotalDining"],
    sumTotalDiscounts: json["sumTotalDiscounts"],
    sumTotalCanceled: json["sumTotalCanceled"],
    sunTotalIncomplete: json["sunTotalIncomplete"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "totalItemSold": totalItemSold == null ? [] : List<dynamic>.from(totalItemSold!.map((x) => x.toJson())),
    "sumPosCash": sumPosCash,
    "sumPosCard": sumPosCard,
    "sumPosTotal": sumPosTotal,
    "sumTotalOrders": sumTotalOrders,
    "sumTotalTakeaway": sumTotalTakeaway,
    "sumTotalDining": sumTotalDining,
    "sumTotalDiscounts": sumTotalDiscounts,
    "sumTotalCanceled": sumTotalCanceled,
    "sunTotalIncomplete": sunTotalIncomplete,
  };
}

class Datum {
  DateTime? date;
  String? shiftCode;
  String? shiftName;
  Pos? posCash;
  Pos? posCard;
  Pos? posTotalSale;
  OrderPlaced? orderPlaced;
  List<Order>? orders;

  Datum({
    this.date,
    this.shiftCode,
    this.shiftName,
    this.posCash,
    this.posCard,
    this.posTotalSale,
    this.orderPlaced,
    this.orders,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    date: json["Date"] == null ? null : DateTime.parse(json["Date"]),
    shiftCode: json["shift code"],
    shiftName: json["shift name"],
    posCash: json["Pos cash"] == null ? null : Pos.fromJson(json["Pos cash"]),
    posCard: json["Pos card"] == null ? null : Pos.fromJson(json["Pos card"]),
    posTotalSale: json["pos total sale"] == null ? null : Pos.fromJson(json["pos total sale"]),
    orderPlaced: json["order placed"] == null ? null : OrderPlaced.fromJson(json["order placed"]),
    orders: json["orders"] == null ? [] : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "shift code": shiftCode,
    "shift name": shiftName,
    "Pos cash": posCash?.toJson(),
    "Pos card": posCard?.toJson(),
    "pos total sale": posTotalSale?.toJson(),
    "order placed": orderPlaced?.toJson(),
    "orders": orders == null ? [] : List<dynamic>.from(orders!.map((x) => x.toJson())),
  };
}

class OrderPlaced {
  int? totalOrders;
  int? totalTakeaway;
  int? totalDining;
  int? totalDiscounts;
  int? totalCanceled;
  String? totalCanceledAmount;
  List<OrdersDetail>? cancelledOrdersDetail;
  int? totalIncomplete;
  List<OrdersDetail>? incompleteOrdersDetail;

  OrderPlaced({
    this.totalOrders,
    this.totalTakeaway,
    this.totalDining,
    this.totalDiscounts,
    this.totalCanceled,
    this.totalCanceledAmount,
    this.cancelledOrdersDetail,
    this.totalIncomplete,
    this.incompleteOrdersDetail,
  });

  factory OrderPlaced.fromJson(Map<String, dynamic> json) => OrderPlaced(
    totalOrders: json["total orders"],
    totalTakeaway: json["total takeaway"],
    totalDining: json["total total_dining"],
    totalDiscounts: json["total discounts"],
    totalCanceled: json["total_canceled"],
    totalCanceledAmount: json["total canceled amount"],
    cancelledOrdersDetail: json["cancelled orders detail"] == null ? [] : List<OrdersDetail>.from(json["cancelled orders detail"]!.map((x) => OrdersDetail.fromJson(x))),
    totalIncomplete: json["total incomplete"],
    incompleteOrdersDetail: json["incomplete orders detail"] == null ? [] : List<OrdersDetail>.from(json["incomplete orders detail"]!.map((x) => OrdersDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total orders": totalOrders,
    "total takeaway": totalTakeaway,
    "total total_dining": totalDining,
    "total discounts": totalDiscounts,
    "total_canceled": totalCanceled,
    "total canceled amount": totalCanceledAmount,
    "cancelled orders detail": cancelledOrdersDetail == null ? [] : List<dynamic>.from(cancelledOrdersDetail!.map((x) => x.toJson())),
    "total incomplete": totalIncomplete,
    "incomplete orders detail": incompleteOrdersDetail == null ? [] : List<dynamic>.from(incompleteOrdersDetail!.map((x) => x.toJson())),
  };
}

class OrdersDetail {
  String? orderId;
  String? amount;
  String? deliveryType;
  String? cancelReason;
  String? cancelBy;
  String? discounts;
  String? userName;
  String? mobile;
  String? notes;
  String? paymentType;
  String? orderStatus;

  OrdersDetail({
    this.orderId,
    this.amount,
    this.deliveryType,
    this.cancelReason,
    this.cancelBy,
    this.discounts,
    this.userName,
    this.mobile,
    this.notes,
    this.paymentType,
    this.orderStatus,
  });

  factory OrdersDetail.fromJson(Map<String, dynamic> json) => OrdersDetail(
    orderId: json["order_id"],
    amount: json["amount"],
    deliveryType: json["delivery_type"],
    cancelReason: json["cancel_reason"],
    cancelBy: json["cancel_by"],
    discounts: json["discounts"],
    userName: json["user_name"],
    mobile: json["mobile"],
    notes: json["notes"],
    paymentType: json["payment_type"],
    orderStatus: json["order_status"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "amount": amount,
    "delivery_type": deliveryType,
    "cancel_reason": cancelReason,
    "cancel_by": cancelBy,
    "discounts": discounts,
    "user_name": userName,
    "mobile": mobile,
    "notes": notes,
    "payment_type": paymentType,
    "order_status": orderStatus,
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
    itemName: json["item_name"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "item_name": itemName,
    "quantity": quantity,
  };
}

class Pos {
  String? name;
  String? amount;

  Pos({
    this.name,
    this.amount,
  });

  factory Pos.fromJson(Map<String, dynamic> json) => Pos(
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
    itemName: json["itemName"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "itemName": itemName,
    "quantity": quantity,
  };
}

