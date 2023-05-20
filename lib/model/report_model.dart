// // class ReportModel {
// //   dynamic data;
// //
// //   ReportModel({this.data});
// //
// //   ReportModel.fromJson(Map<String, dynamic> json) {
// //     data = json['Pos cash'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data =  Map<String, dynamic>();
// //     data['Pos cash'] = this.data;
// //     return data;
// //   }
// // }
//
// ///For Both pos cash and pos card report model
// // import 'dart:convert';
// //
// // class ReportCashModel {
// //   ReportDetailModel? data;
// //
// //   ReportCashModel({ this.data});
// //
// //   ReportCashModel.fromJson(Map<String, dynamic> json) {
// //     data = json['Pos cash']!= null ?  ReportDetailModel.fromJson(json['Pos cash']) : null;
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data =  Map<String, dynamic>();
// //     if (this.data != null) {
// //       data['Pos cash'] = this.data!.toJson();
// //     }
// //     return data;
// //     // return data;
// //   }
// // }
// //
// // class ReportCardModel {
// //   ReportDetailModel? data;
// //
// //   ReportCardModel({ this.data});
// //
// //   ReportCardModel.fromJson(Map<String, dynamic> json) {
// //     data = json['Pos card']!= null ?  ReportDetailModel.fromJson(json['Pos card']) : null;
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data =  Map<String, dynamic>();
// //     if (this.data != null) {
// //       data['Pos card'] = this.data!.toJson();
// //     }
// //     return data;
// //     // return data;
// //   }
// // }
// //
// // // To parse this JSON data, do
// // //
// // //     final reportDetailModel = reportDetailModelFromJson(jsonString);
// //
// //
// // ReportDetailModel reportDetailModelFromJson(String str) => ReportDetailModel.fromJson(json.decode(str));
// //
// // String reportDetailModelToJson(ReportDetailModel data) => json.encode(data.toJson());
// //
// // class ReportDetailModel {
// //   ReportDetailModel({
// //     this.ids,
// //     this.names,
// //     this.amount,
// //   });
// //
// //   List<dynamic>? ids;
// //   List<dynamic>? names;
// //   List<dynamic>? amount;
// //
// //   factory ReportDetailModel.fromJson(Map<String, dynamic> json) => ReportDetailModel(
// //     ids: json["ids"] == null ? [] : List<dynamic>.from(json["ids"]!.map((x) => x)),
// //     names: json["names"] == null ? [] : List<dynamic>.from(json["names"]!.map((x) => x)),
// //     amount: json["amount"] == null ? [] : List<dynamic>.from(json["amount"]!.map((x) => x)),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "ids": ids == null ? [] : List<dynamic>.from(ids!.map((x) => x)),
// //     "names": names == null ? [] : List<dynamic>.from(names!.map((x) => x)),
// //     "amount": amount == null ? [] : List<dynamic>.from(amount!.map((x) => x)),
// //   };
// // }
// ///End
//
// // To parse this JSON data, do
// //
// //     final reportModel = reportModelFromJson(jsonString);
//
// ///Without Total order
// // import 'dart:convert';
// //
// // ReportModel reportModelFromJson(String str) => ReportModel.fromJson(json.decode(str));
// //
// // String reportModelToJson(ReportModel data) => json.encode(data.toJson());
// //
// // class ReportModel {
// //   ReportModel({
// //     this.payments,
// //     this.orders,
// //   });
// //
// //   Payments? payments;
// //   List<Order>? orders;
// //
// //   factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
// //     payments: json["payments"] == null ? null : Payments.fromJson(json["payments"]),
// //     orders: json["orders"] == null ? [] : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "payments": payments?.toJson(),
// //     "orders": orders == null ? [] : List<dynamic>.from(orders!.map((x) => x.toJson())),
// //   };
// // }
// //
// // class Order {
// //   Order({
// //     this.itemName,
// //     this.quantity,
// //   });
// //
// //   String? itemName;
// //   int? quantity;
// //
// //   factory Order.fromJson(Map<String, dynamic> json) => Order(
// //     itemName: json["item_name"],
// //     quantity: json["quantity"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "item_name": itemName,
// //     "quantity": quantity,
// //   };
// // }
// //
// // class Payments {
// //   Payments({
// //     this.posCash,
// //     this.posCard,
// //   });
// //
// //   PaymentType? posCash;
// //   PaymentType? posCard;
// //
// //   factory Payments.fromJson(Map<String, dynamic> json) => Payments(
// //     posCash: json["Pos cash"] == null ? null : PaymentType.fromJson(json["Pos cash"]),
// //     posCard: json["Pos card"] == null ? null : PaymentType.fromJson(json["Pos card"]),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "Pos cash": posCash?.toJson(),
// //     "Pos card": posCard?.toJson(),
// //   };
// // }
// //
// // class PaymentType {
// //   PaymentType({
// //     this.name,
// //     this.amount,
// //   });
// //
// //   List<String>? name;
// //   double? amount;
// //
// //   factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
// //     name: json["name"] == null ? [] : List<String>.from(json["name"]!.map((x) => x)),
// //     amount: json["amount"]?.toDouble(),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "name": name == null ? [] : List<dynamic>.from(name!.map((x) => x)),
// //     "amount": amount,
// //   };
// // }
//
// // To parse this JSON data, do
// //
// //     final reportModel = reportModelFromJson(jsonString);
//
// // To parse this JSON data, do
// //
// //     final reportModel = reportModelFromJson(jsonString);
//
// import 'dart:convert';
//
// ReportModel reportModelFromJson(String str) => ReportModel.fromJson(json.decode(str));
//
// String reportModelToJson(ReportModel data) => json.encode(data.toJson());
//
// class ReportModel {
//   Payments? payments;
//   int? totalOrders;
//   int? totalTakeaway;
//   int? totalDining;
//   double? totalDiscounts;
//   List<Order>? orders;
//
//   ReportModel({
//     this.payments,
//     this.totalOrders,
//     this.totalTakeaway,
//     this.totalDining,
//     this.totalDiscounts,
//     this.orders,
//   });
//
//   factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
//     payments: json["payments"] == null ? null : Payments.fromJson(json["payments"]),
//     totalOrders: json["Total Orders"],
//     totalTakeaway: json["Total Takeaway"],
//     totalDining: json["Total Dining"],
//     totalDiscounts: json["Total Discounts"]?.toDouble(),
//     orders: json["orders"] == null ? [] : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "payments": payments?.toJson(),
//     "Total Orders": totalOrders,
//     "Total Takeaway": totalTakeaway,
//     "Total Dining": totalDining,
//     "Total Discounts": totalDiscounts,
//     "orders": orders == null ? [] : List<dynamic>.from(orders!.map((x) => x.toJson())),
//   };
// }
//
// class Order {
//   String? itemName;
//   int? quantity;
//
//   Order({
//     this.itemName,
//     this.quantity,
//   });
//
//   factory Order.fromJson(Map<String, dynamic> json) => Order(
//     itemName: json["item_name"],
//     quantity: json["quantity"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "item_name": itemName,
//     "quantity": quantity,
//   };
// }
//
// class Payments {
//   PosCa? posCash;
//   PosCa? posCard;
//
//   Payments({
//     this.posCash,
//     this.posCard,
//   });
//
//   factory Payments.fromJson(Map<String, dynamic> json) => Payments(
//     posCash: json["Pos cash"] == null ? null : PosCa.fromJson(json["Pos cash"]),
//     posCard: json["Pos card"] == null ? null : PosCa.fromJson(json["Pos card"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Pos cash": posCash?.toJson(),
//     "Pos card": posCard?.toJson(),
//   };
// }
//
// class PosCa {
//   String? name;
//   double? amount;
//
//   PosCa({
//     this.name,
//     this.amount,
//   });
//
//   factory PosCa.fromJson(Map<String, dynamic> json) => PosCa(
//     name: json["name"],
//     amount: json["amount"]?.toDouble(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "amount": amount,
//   };
// }
//

///New DAta
// To parse this JSON data, do
//
//     final reportModel = reportModelFromJson(jsonString);

import 'dart:convert';

ReportModel reportModelFromJson(String str) => ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  Payments? payments;
  dynamic totalOrders;
  dynamic totalTakeaway;
  dynamic totalDining;
  dynamic totalDiscounts;
  dynamic totalCanceled;
  dynamic totalCanceledAmount;
  List<CancelledOrdersDetail>? cancelledOrdersDetail;
  int? totalIncomplete;
  List<IncompleteOrdersDetail>? incompleteOrdersDetail;
  List<Order>? orders;

  ReportModel({
    this.payments,
    this.totalOrders,
    this.totalTakeaway,
    this.totalDining,
    this.totalDiscounts,
    this.totalCanceled,
    this.totalCanceledAmount,
    this.cancelledOrdersDetail,
    this.totalIncomplete,
    this.incompleteOrdersDetail,
    this.orders,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    payments: json["payments"] == null ? null : Payments.fromJson(json["payments"]),
    totalOrders: json["Total Orders"],
    totalTakeaway: json["Total Takeaway"],
    totalDining: json["Total Dining"],
    totalDiscounts: json["Total Discounts"],
    totalCanceled: json["Total Canceled"],
    totalCanceledAmount: json["Total Canceled Amount"],
    cancelledOrdersDetail: json["Cancelled Orders Detail"] == null ? [] : List<CancelledOrdersDetail>.from(json["Cancelled Orders Detail"]!.map((x) => CancelledOrdersDetail.fromJson(x))),
    totalIncomplete: json["Total Incomplete"],
    incompleteOrdersDetail: json["Incomplete Orders Detail"] == null ? [] : List<IncompleteOrdersDetail>.from(json["Incomplete Orders Detail"]!.map((x) => IncompleteOrdersDetail.fromJson(x))),
    orders: json["orders"] == null ? [] : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "payments": payments?.toJson(),
    "Total Orders": totalOrders,
    "Total Takeaway": totalTakeaway,
    "Total Dining": totalDining,
    "Total Discounts": totalDiscounts,
    "Total Canceled": totalCanceled,
    "Total Canceled Amount": totalCanceledAmount,
    "Cancelled Orders Detail": cancelledOrdersDetail == null ? [] : List<dynamic>.from(cancelledOrdersDetail!.map((x) => x.toJson())),
    "Total Incomplete": totalIncomplete,
    "Incomplete Orders Detail": incompleteOrdersDetail == null ? [] : List<dynamic>.from(incompleteOrdersDetail!.map((x) => x.toJson())),
    "orders": orders == null ? [] : List<dynamic>.from(orders!.map((x) => x.toJson())),
  };
}

class CancelledOrdersDetail {
  String? orderId;
  String? amount;
  String? deliveryType;
  String? cancelReason;
  String? cancelBy;
  double? discounts;
  String? userName;
  String? mobile;
  String? notes;

  CancelledOrdersDetail({
    this.orderId,
    this.amount,
    this.deliveryType,
    this.cancelReason,
    this.cancelBy,
    this.discounts,
    this.userName,
    this.mobile,
    this.notes,
  });

  factory CancelledOrdersDetail.fromJson(Map<String, dynamic> json) => CancelledOrdersDetail(
    orderId: json["order_id"],
    amount: json["amount"],
    deliveryType: json["delivery_type"],
    cancelReason: json["cancel_reason"],
    cancelBy: json["cancel_by"],
    discounts: json["discounts"]?.toDouble(),
    userName: json["user_name"],
    mobile: json["mobile"],
    notes: json["notes"],
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
  };
}

class IncompleteOrdersDetail {
  String? orderId;
  String? amount;
  String? paymentType;
  String? deliveryType;
  String? orderStatus;
  String? userName;
  String? mobile;
  String? notes;

  IncompleteOrdersDetail({
    this.orderId,
    this.amount,
    this.paymentType,
    this.deliveryType,
    this.orderStatus,
    this.userName,
    this.mobile,
    this.notes,
  });

  factory IncompleteOrdersDetail.fromJson(Map<String, dynamic> json) => IncompleteOrdersDetail(
    orderId: json["order_id"],
    amount: json["amount"],
    paymentType: json["payment_type"],
    deliveryType: json["delivery_type"],
    orderStatus: json["order_status"],
    userName: json["user_name"],
    mobile: json["mobile"],
    notes: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "amount": amount,
    "payment_type": paymentType,
    "delivery_type": deliveryType,
    "order_status": orderStatus,
    "user_name": userName,
    "mobile": mobile,
    "notes": notes,
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

class Payments {
  PosCa? posCash;
  PosCa? posCard;

  Payments({
    this.posCash,
    this.posCard,
  });

  factory Payments.fromJson(Map<String, dynamic> json) => Payments(
    posCash: json["Pos cash"] == null ? null : PosCa.fromJson(json["Pos cash"]),
    posCard: json["Pos card"] == null ? null : PosCa.fromJson(json["Pos card"]),
  );

  Map<String, dynamic> toJson() => {
    "Pos cash": posCash?.toJson(),
    "Pos card": posCard?.toJson(),
  };
}

class PosCa {
  String? name;
  double? amount;

  PosCa({
    this.name,
    this.amount,
  });

  factory PosCa.fromJson(Map<String, dynamic> json) => PosCa(
    name: json["name"],
    amount: json["amount"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "amount": amount,
  };
}

