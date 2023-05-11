// class ReportModel {
//   dynamic data;
//
//   ReportModel({this.data});
//
//   ReportModel.fromJson(Map<String, dynamic> json) {
//     data = json['Pos cash'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     data['Pos cash'] = this.data;
//     return data;
//   }
// }

///For Both pos cash and pos card report model
// import 'dart:convert';
//
// class ReportCashModel {
//   ReportDetailModel? data;
//
//   ReportCashModel({ this.data});
//
//   ReportCashModel.fromJson(Map<String, dynamic> json) {
//     data = json['Pos cash']!= null ?  ReportDetailModel.fromJson(json['Pos cash']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     if (this.data != null) {
//       data['Pos cash'] = this.data!.toJson();
//     }
//     return data;
//     // return data;
//   }
// }
//
// class ReportCardModel {
//   ReportDetailModel? data;
//
//   ReportCardModel({ this.data});
//
//   ReportCardModel.fromJson(Map<String, dynamic> json) {
//     data = json['Pos card']!= null ?  ReportDetailModel.fromJson(json['Pos card']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     if (this.data != null) {
//       data['Pos card'] = this.data!.toJson();
//     }
//     return data;
//     // return data;
//   }
// }
//
// // To parse this JSON data, do
// //
// //     final reportDetailModel = reportDetailModelFromJson(jsonString);
//
//
// ReportDetailModel reportDetailModelFromJson(String str) => ReportDetailModel.fromJson(json.decode(str));
//
// String reportDetailModelToJson(ReportDetailModel data) => json.encode(data.toJson());
//
// class ReportDetailModel {
//   ReportDetailModel({
//     this.ids,
//     this.names,
//     this.amount,
//   });
//
//   List<dynamic>? ids;
//   List<dynamic>? names;
//   List<dynamic>? amount;
//
//   factory ReportDetailModel.fromJson(Map<String, dynamic> json) => ReportDetailModel(
//     ids: json["ids"] == null ? [] : List<dynamic>.from(json["ids"]!.map((x) => x)),
//     names: json["names"] == null ? [] : List<dynamic>.from(json["names"]!.map((x) => x)),
//     amount: json["amount"] == null ? [] : List<dynamic>.from(json["amount"]!.map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "ids": ids == null ? [] : List<dynamic>.from(ids!.map((x) => x)),
//     "names": names == null ? [] : List<dynamic>.from(names!.map((x) => x)),
//     "amount": amount == null ? [] : List<dynamic>.from(amount!.map((x) => x)),
//   };
// }
///End

// To parse this JSON data, do
//
//     final reportModel = reportModelFromJson(jsonString);

///Without Total order
// import 'dart:convert';
//
// ReportModel reportModelFromJson(String str) => ReportModel.fromJson(json.decode(str));
//
// String reportModelToJson(ReportModel data) => json.encode(data.toJson());
//
// class ReportModel {
//   ReportModel({
//     this.payments,
//     this.orders,
//   });
//
//   Payments? payments;
//   List<Order>? orders;
//
//   factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
//     payments: json["payments"] == null ? null : Payments.fromJson(json["payments"]),
//     orders: json["orders"] == null ? [] : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "payments": payments?.toJson(),
//     "orders": orders == null ? [] : List<dynamic>.from(orders!.map((x) => x.toJson())),
//   };
// }
//
// class Order {
//   Order({
//     this.itemName,
//     this.quantity,
//   });
//
//   String? itemName;
//   int? quantity;
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
//   Payments({
//     this.posCash,
//     this.posCard,
//   });
//
//   PaymentType? posCash;
//   PaymentType? posCard;
//
//   factory Payments.fromJson(Map<String, dynamic> json) => Payments(
//     posCash: json["Pos cash"] == null ? null : PaymentType.fromJson(json["Pos cash"]),
//     posCard: json["Pos card"] == null ? null : PaymentType.fromJson(json["Pos card"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Pos cash": posCash?.toJson(),
//     "Pos card": posCard?.toJson(),
//   };
// }
//
// class PaymentType {
//   PaymentType({
//     this.name,
//     this.amount,
//   });
//
//   List<String>? name;
//   double? amount;
//
//   factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
//     name: json["name"] == null ? [] : List<String>.from(json["name"]!.map((x) => x)),
//     amount: json["amount"]?.toDouble(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name == null ? [] : List<dynamic>.from(name!.map((x) => x)),
//     "amount": amount,
//   };
// }

// To parse this JSON data, do
//
//     final reportModel = reportModelFromJson(jsonString);

import 'dart:convert';

ReportModel reportModelFromJson(String str) =>
    ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  ReportModel({
    this.payments,
    this.todaysTotalOrders,
    this.todaysTotalTakeaway,
    this.todaysTotalDiscounts,
    this.todaysTotalDining,
    this.orders,
  });

  Payments? payments;
  dynamic todaysTotalOrders;
  dynamic todaysTotalTakeaway;
  dynamic todaysTotalDiscounts;
  dynamic todaysTotalDining;
  List<Order>? orders;

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        payments: json["payments"] == null
            ? null
            : Payments.fromJson(json["payments"]),
        todaysTotalOrders: json["Todays total orders"],
        todaysTotalTakeaway: json["Todays total Takeaway"],
        todaysTotalDiscounts: json["Todays total discounts"],
        todaysTotalDining: json["Todays total dining"],
        orders: json["orders"] == null
            ? []
            : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "payments": payments?.toJson(),
        "Todays total orders": todaysTotalOrders,
        "Todays total Takeaway": todaysTotalTakeaway,
        "Todays total discounts": todaysTotalDiscounts,
        "Todays total dining": todaysTotalDining,
        "orders": orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    this.itemName,
    this.quantity,
  });

  String? itemName;
  int? quantity;

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
  Payments({
    this.posCash,
    this.posCard,
  });

  PaymentType? posCash;
  PaymentType? posCard;

  factory Payments.fromJson(Map<String, dynamic> json) => Payments(
        posCash: json["Pos cash"] == null
            ? null
            : PaymentType.fromJson(json["Pos cash"]),
        posCard: json["Pos card"] == null
            ? null
            : PaymentType.fromJson(json["Pos card"]),
      );

  Map<String, dynamic> toJson() => {
        "Pos cash": posCash?.toJson(),
        "Pos card": posCard?.toJson(),
      };
}

class PaymentType {
  PaymentType({
    this.name,
    this.amount,
  });

  List<String>? name;
  double? amount;

  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
        name: json["name"] == null
            ? []
            : List<String>.from(json["name"]!.map((x) => x)),
        amount: json["amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? [] : List<dynamic>.from(name!.map((x) => x)),
        "amount": amount,
      };
}
