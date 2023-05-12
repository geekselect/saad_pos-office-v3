import 'dart:convert';

class BookedOrderModel {
  bool? success;
  Data? data;

  BookedOrderModel({this.success, this.data});

  BookedOrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromMap(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toMap();
    }
    return data;
  }
}

Data dataFromMap(String str) => Data.fromMap(json.decode(str));

String dataToMap(Data data) => json.encode(data.toMap());

class Data {
  Data({
    this.orderId,
    this.orderData,
    this.notes,
    this.userName,
    this.mobile,
  });

  int? orderId;
  String? orderData;
  String? userName;
  String? mobile;
  String? notes;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    orderId: json["order_id"],
    orderData: json["order_data"],
    userName: json["user_name"],
    mobile: json["mobile"],
    notes: json["notes"],
  );

  Map<String, dynamic> toMap() => {
    "order_id": orderId,
    "order_data": orderData,
    "user_name": userName,
    "notes": notes,
    "mobile": mobile,
  };
}

// class Data {
//   int? orderId;
//   String? orderData;
//   String? userName;
//
//   Data({this.orderId, this.orderData, this.userName});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     orderId = json['order_id'];
//     orderData = json['order_data'];
//     userName: json['user_name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['order_id'] = this.orderId;
//     data['user_name'] = this.userName;
//     data['order_data'] = this.orderData;
//     return data;
//   }
// }
