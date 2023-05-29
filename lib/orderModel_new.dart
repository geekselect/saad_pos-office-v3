// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

///cc
import 'dart:convert';

OrderMainModel orderModelFromJson(String str) => OrderMainModel.fromJson(json.decode(str));

String orderModelToJson(OrderMainModel data) => json.encode(data.toJson());


class OrderMainModel {
  bool success;
  String data;
  OrderModel orderData;

  OrderMainModel({
    required this.success,
    required this.data,
    required this.orderData,
  });

  factory OrderMainModel.fromJson(Map<String, dynamic> json) => OrderMainModel(
    success: json["success"],
    data: json["data"],
    orderData: OrderModel.fromJson(json["order_data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data,
    "order_data": orderData.toJson(),
  };
}

class OrderModel {
  dynamic notes;
  dynamic discounts;
  int? vendorId;
  String? date;
  String? shiftCode;
  String? time;
  dynamic deliveryTime;
  dynamic deliveryDate;
  dynamic item;
  int? amount;
  dynamic cashAmount;
  int? cardAmount;
  String? deliveryType;
  int? deliveryCharge;
  String? paymentType;
  int? paymentStatus;
  String? orderStatus;
  dynamic userName;
  dynamic mobile;
  dynamic custimization;
  dynamic promocodeId;
  int? promocodePrice;
  double? tax;
  double? subTotal;
  String? tableNo;
  dynamic oldOrderId;
  int? userId;
  String? orderId;
  dynamic orderData;

  OrderModel({
    this.notes,
    this.discounts,
    this.vendorId,
    this.date,
    this.shiftCode,
    this.time,
    this.deliveryTime,
    this.deliveryDate,
    this.item,
    this.amount,
    this.cashAmount,
    this.cardAmount,
    this.deliveryType,
    this.deliveryCharge,
    this.paymentType,
    this.paymentStatus,
    this.orderStatus,
    this.userName,
    this.mobile,
    this.custimization,
    this.promocodeId,
    this.promocodePrice,
    this.tax,
    this.subTotal,
    this.tableNo,
    this.oldOrderId,
    this.userId,
    this.orderId,
    this.orderData,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    notes: json["notes"],
    discounts: json["discounts"],
    vendorId: json["vendor_id"],
    date: json["date"],
    shiftCode: json["shift_code"],
    time: json["time"],
    deliveryTime: json["delivery_time"],
    deliveryDate: json["delivery_date"],
    item: json["item"],
    amount: json["amount"],
    cashAmount: json["cash_amount"],
    cardAmount: json["card_amount"],
    deliveryType: json["delivery_type"],
    deliveryCharge: json["delivery_charge"],
    paymentType: json["payment_type"],
    paymentStatus: json["payment_status"],
    orderStatus: json["order_status"],
    userName: json["user_name"],
    mobile: json["mobile"],
    custimization: json["custimization"],
    promocodeId: json["promocode_id"],
    promocodePrice: json["promocode_price"],
    tax: json["tax"]?.toDouble(),
    subTotal: json["sub_total"]?.toDouble(),
    tableNo: json["table_no"],
    oldOrderId: json["old_order_id"],
    userId: json["user_id"],
    orderId: json["order_id"],
    orderData: json["order_data"],
  );

  Map<String, dynamic> toJson() => {
    "notes": notes,
    "discounts": discounts,
    "vendor_id": vendorId,
    "date": date,
    "shift_code": shiftCode,
    "time": time,
    "delivery_time": deliveryTime,
    "delivery_date": deliveryDate,
    "item": item,
    "amount": amount,
    "cash_amount": cashAmount,
    "card_amount": cardAmount,
    "delivery_type": deliveryType,
    "delivery_charge": deliveryCharge,
    "payment_type": paymentType,
    "payment_status": paymentStatus,
    "order_status": orderStatus,
    "user_name": userName,
    "mobile": mobile,
    "custimization": custimization,
    "promocode_id": promocodeId,
    "promocode_price": promocodePrice,
    "tax": tax,
    "sub_total": subTotal,
    "table_no": tableNo,
    "old_order_id": oldOrderId,
    "user_id": userId,
    "order_id": orderId,
    "order_data": orderData,
  };
}
