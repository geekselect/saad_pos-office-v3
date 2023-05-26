// class CommenRes {
//   bool? success;
//   String? data;
//   dynamic order_data;
//
//   CommenRes({this.success, this.data, this.order_data});
//
//   CommenRes.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     data = json['data'];
//     order_data = json['order_data'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     data['success'] = this.success;
//     data['data'] = this.data;
//     data['order_data'] = this.order_data;
//     return data;
//   }
// }

import 'dart:convert';

class CommenPaymentSwitchRes {
  String? success;

  CommenPaymentSwitchRes({this.success});

  CommenPaymentSwitchRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['success'] = this.success;
    return data;
  }
}


// To parse this JSON data, do
//
//     final commonResModel = commonResModelFromJson(jsonString);

// import 'dart:convert';
//
CommenRes commonResModelFromJson(String str) => CommenRes.fromJson(json.decode(str));

String commonResModelToJson(CommenRes data) => json.encode(data.toJson());

class CommenRes {
  bool? success;
  String? data;
  String? orderData;

  CommenRes({
    this.success,
    this.data,
    this.orderData,
  });

  factory CommenRes.fromJson(Map<String, dynamic> json) => CommenRes(
    success: json["success"],
    data: json["data"],
    orderData: json["order_data"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data,
    "order_data": orderData,
  };
}

// class OrderData {
//   dynamic notes;
//   dynamic discounts;
//   int? vendorId;
//   DateTime? date;
//   String? shiftCode;
//   String? time;
//   dynamic deliveryTime;
//   dynamic deliveryDate;
//   Item? item;
//   int? amount;
//   int? cashAmount;
//   dynamic cardAmount;
//   String? deliveryType;
//   int? deliveryCharge;
//   String? paymentType;
//   int? paymentStatus;
//   String? orderStatus;
//   dynamic userName;
//   dynamic mobile;
//   dynamic custimization;
//   dynamic promocodeId;
//   int? promocodePrice;
//   double? tax;
//   double? subTotal;
//   String? tableNo;
//   dynamic oldOrderId;
//   int? userId;
//   String? orderId;
//   Item? orderData;
//
//   OrderData({
//     this.notes,
//     this.discounts,
//     this.vendorId,
//     this.date,
//     this.shiftCode,
//     this.time,
//     this.deliveryTime,
//     this.deliveryDate,
//     this.item,
//     this.amount,
//     this.cashAmount,
//     this.cardAmount,
//     this.deliveryType,
//     this.deliveryCharge,
//     this.paymentType,
//     this.paymentStatus,
//     this.orderStatus,
//     this.userName,
//     this.mobile,
//     this.custimization,
//     this.promocodeId,
//     this.promocodePrice,
//     this.tax,
//     this.subTotal,
//     this.tableNo,
//     this.oldOrderId,
//     this.userId,
//     this.orderId,
//     this.orderData,
//   });
//
//   factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
//     notes: json["notes"],
//     discounts: json["discounts"],
//     vendorId: json["vendor_id"],
//     date: json["date"] == null ? null : DateTime.parse(json["date"]),
//     shiftCode: json["shift_code"],
//     time: json["time"],
//     deliveryTime: json["delivery_time"],
//     deliveryDate: json["delivery_date"],
//     item: json["item"] == null ? null : Item.fromJson(json["item"]),
//     amount: json["amount"],
//     cashAmount: json["cash_amount"],
//     cardAmount: json["card_amount"],
//     deliveryType: json["delivery_type"],
//     deliveryCharge: json["delivery_charge"],
//     paymentType: json["payment_type"],
//     paymentStatus: json["payment_status"],
//     orderStatus: json["order_status"],
//     userName: json["user_name"],
//     mobile: json["mobile"],
//     custimization: json["custimization"],
//     promocodeId: json["promocode_id"],
//     promocodePrice: json["promocode_price"],
//     tax: json["tax"]?.toDouble(),
//     subTotal: json["sub_total"]?.toDouble(),
//     tableNo: json["table_no"],
//     oldOrderId: json["old_order_id"],
//     userId: json["user_id"],
//     orderId: json["order_id"],
//     orderData: json["order_data"] == null ? null : Item.fromJson(json["order_data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "notes": notes,
//     "discounts": discounts,
//     "vendor_id": vendorId,
//     "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
//     "shift_code": shiftCode,
//     "time": time,
//     "delivery_time": deliveryTime,
//     "delivery_date": deliveryDate,
//     "item": item?.toJson(),
//     "amount": amount,
//     "cash_amount": cashAmount,
//     "card_amount": cardAmount,
//     "delivery_type": deliveryType,
//     "delivery_charge": deliveryCharge,
//     "payment_type": paymentType,
//     "payment_status": paymentStatus,
//     "order_status": orderStatus,
//     "user_name": userName,
//     "mobile": mobile,
//     "custimization": custimization,
//     "promocode_id": promocodeId,
//     "promocode_price": promocodePrice,
//     "tax": tax,
//     "sub_total": subTotal,
//     "table_no": tableNo,
//     "old_order_id": oldOrderId,
//     "user_id": userId,
//     "order_id": orderId,
//     "order_data": orderData?.toJson(),
//   };
// }
//
// class Item {
//   int? vendorId;
//   List<Cart>? cart;
//
//   Item({
//     this.vendorId,
//     this.cart,
//   });
//
//   factory Item.fromJson(Map<String, dynamic> json) => Item(
//     vendorId: json["vendor_id"],
//     cart: json["cart"] == null ? [] : List<Cart>.from(json["cart"]!.map((x) => Cart.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "vendor_id": vendorId,
//     "cart": cart == null ? [] : List<dynamic>.from(cart!.map((x) => x.toJson())),
//   };
// }
//
// class Cart {
//   String? category;
//   double? totalAmount;
//   double? diningAmount;
//   List<Menu>? menu;
//   Size? size;
//   MenuCategory? menuCategory;
//   int? quantity;
//
//   Cart({
//     this.category,
//     this.totalAmount,
//     this.diningAmount,
//     this.menu,
//     this.size,
//     this.menuCategory,
//     this.quantity,
//   });
//
//   factory Cart.fromJson(Map<String, dynamic> json) => Cart(
//     category: json["category"],
//     totalAmount: json["total_amount"]?.toDouble(),
//     diningAmount: json["dining_amount"]?.toDouble(),
//     menu: json["menu"] == null ? [] : List<Menu>.from(json["menu"]!.map((x) => Menu.fromJson(x))),
//     size: json["size"] == null ? null : Size.fromJson(json["size"]),
//     menuCategory: json["menu_category"] == null ? null : MenuCategory.fromMap(json["menu_category"]),
//     quantity: json["quantity"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "category": category,
//     "total_amount": totalAmount,
//     "dining_amount": diningAmount,
//     "menu": menu == null ? [] : List<dynamic>.from(menu!.map((x) => x.toJson())),
//     "size": size?.toJson(),
//     "menu_category":menuCategory == null ?null:menuCategory!.toMap(),
//     "quantity": quantity,
//   };
// }
//
//
//
// class Menu {
//   int? id;
//   String? name;
//   String? image;
//   double? totalAmount;
//   dynamic diningAmount;
//   List<Addon>? addons;
//   dynamic dealsItems;
//
//   Menu({
//     this.id,
//     this.name,
//     this.image,
//     this.totalAmount,
//     this.diningAmount,
//     this.addons,
//     this.dealsItems,
//   });
//
//   factory Menu.fromJson(Map<String, dynamic> json) => Menu(
//     id: json["id"],
//     name: json["name"],
//     image: json["image"],
//     totalAmount: json["total_amount"]?.toDouble(),
//     diningAmount: json["dining_amount"],
//     addons: json["addons"] == null ? [] : List<Addon>.from(json["addons"]!.map((x) => Addon.fromJson(x))),
//     dealsItems: json["deals_items"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "image": image,
//     "total_amount": totalAmount,
//     "dining_amount": diningAmount,
//     "addons": addons == null ? [] : List<dynamic>.from(addons!.map((x) => x.toJson())),
//     "deals_items": dealsItems,
//   };
// }
//
// class MenuCategory {
//   MenuCategory({
//     required this.id,
//     required this.name,
//     required this.image,
//     this.diningAmount,
//     required this.totalAmount,
//     required this.addons,
//     this.dealsItems
//
//   });
//
//   int id;
//   String name;
//   String image;
//   dynamic diningAmount;
//   dynamic totalAmount;
//   List<Addon> addons;
//   DealsItems? dealsItems;
//
//   factory MenuCategory.fromMap(Map<String, dynamic> json) => MenuCategory(
//     id: json["id"],
//     name:json['name'],
//     image:json['image'],
//     totalAmount: json['total_amount'],
//     diningAmount: json['dining_amount'],
//     addons: List<Addon>.from(json["addons"].map((x) => Addon.fromJson(x))),
//     dealsItems: json["deals_items"] == null ? null : DealsItems.fromMap(json["deals_items"]),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "id": id,
//     "name":name,
//     "image":image,
//     "total_amount":totalAmount,
//     "dining_amount":diningAmount,
//     "addons": List<dynamic>.from(addons.map((x) => x.toJson())),
//     "deals_items":dealsItems == null ?null:dealsItems!.toMap(),
//   };
// }
//
// class DealsItems {
//   DealsItems({
//     required this.name,
//     required this.id,
//   });
//
//   final String name;
//   final int id;
//
//   factory DealsItems.fromMap(Map<String, dynamic> json) => DealsItems(
//     name: json["name"],
//     id: json["id"],
//   );
//
//   Map<String, dynamic> toMap() => {
//     "name": name,
//     "id": id,
//   };
// }
//
// class Addon {
//   int? id;
//   String? name;
//   int? price;
//   int? diningPrice;
//
//   Addon({
//     this.id,
//     this.name,
//     this.price,
//     this.diningPrice,
//   });
//
//   factory Addon.fromJson(Map<String, dynamic> json) => Addon(
//     id: json["id"],
//     name: json["name"],
//     price: json["price"],
//     diningPrice: json["dining_price"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "price": price,
//     "dining_price": diningPrice,
//   };
// }
//
// class Size {
//   int? id;
//   String? sizeName;
//
//   Size({
//     this.id,
//     this.sizeName,
//   });
//
//   factory Size.fromJson(Map<String, dynamic> json) => Size(
//     id: json["id"],
//     sizeName: json["size_name"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "size_name": sizeName,
//   };
// }


