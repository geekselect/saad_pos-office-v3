class OrdersResponse {
  bool? success;
  List<Data>? data;

  OrdersResponse({this.success, this.data});

  OrdersResponse.fromJson(dynamic json) {
    success = json["success"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["success"] = success;
    if (data != null) {
      map["data"] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  int? id;
  String? orderId;
  int? vendorId;
  int? userId;
  dynamic deliveryPersonId;
  String? date;
  String? placedFrom;
  String? time;
  String? paymentType;
  dynamic paymentToken;
  String? paymentStatus;
  String? amount;
  String? adminCommission;
  String? vendorAmount;
  String? deliveryType;
  dynamic promoCodeId;
  String? promoCodePrice;
  dynamic vendorDiscountId;
  int? vendorDiscountPrice;
  dynamic addressId;
  dynamic deliveryCharge;
  String? orderStatus;
  dynamic cancelBy;
  dynamic cancelReason;
  String? tax;
  String? orderStartTime;
  String? orderEndTime;
  String? userName;
  String? userName1;
  String? userPhone;
  String? userAddress;
  String? mobile;
  String? discounts;
  String? notes;
  DeliveryPerson? deliveryPerson;
  String? vendorAddress;
  DateTime? deliveryTime;
  List<OrderItems>? orderItems;
  bool isDisable = false;
  String? orderData;
  int? table_no;

  Data({
    this.id,
    this.orderId,
    this.vendorId,
    this.userId,
    this.table_no,
    this.deliveryPersonId,
    this.date,
    this.placedFrom,
    this.time,
    this.paymentType,
    this.paymentToken,
    this.paymentStatus,
    this.amount,
    this.adminCommission,
    this.vendorAmount,
    this.deliveryType,
    this.promoCodeId,
    this.promoCodePrice,
    this.vendorDiscountId,
    this.vendorDiscountPrice,
    this.addressId,
    this.deliveryCharge,
    this.orderStatus,
    this.cancelBy,
    this.notes,
    this.discounts,
    this.mobile,
    this.cancelReason,
    this.tax,
    this.orderStartTime,
    this.orderEndTime,
    this.userName,
    this.userName1,
    this.userAddress,
    this.deliveryPerson,
    this.userPhone,
    this.vendorAddress,
    this.deliveryTime,
    this.orderItems,
    required this.orderData,
  });

  Data.fromJson(dynamic json) {
    id = json["id"];
    orderId = json["order_id"];
    table_no = json["table_no"];
    vendorId = json["vendor_id"];
    userId = json["user_id"];
    deliveryPersonId = json["delivery_person_id"];
    date = json["date"];
    placedFrom = json["placed_from"];
    time = json["time"];
    paymentType = json["payment_type"];
    paymentToken = json["payment_token"];
    paymentStatus = json["payment_status"];
    amount = json["amount"];
    adminCommission = json["admin_commission"];
    vendorAmount = json["vendor_amount"];
    deliveryType = json["delivery_type"];
    promoCodeId = json["promocode_id"];
    promoCodePrice = json["promocode_price"];
    vendorDiscountId = json["vendor_discount_id"];
    vendorDiscountPrice = json["vendor_discount_price"];
    addressId = json["address_id"];
    deliveryCharge = json["delivery_charge"];
    orderStatus = json["order_status"];
    cancelBy = json["cancel_by"];
    cancelReason = json["cancel_reason"];
    tax = json["tax"];
    orderStartTime = json["order_start_time"];
    orderEndTime = json["order_end_time"];
    userName = json["user_name"];
    userName1 = json["user_name1"];
    userPhone = json["user_phone"];
    vendorAddress = json["vendorAddress"];
    mobile = json["mobile"];
    discounts = json["discounts"];
    notes = json["notes"];
    userAddress = json["userAddress"];
    deliveryTime = json["delivery_time"] == null
        ? null
        : DateTime.parse(json["delivery_time"]);
    isDisable = json["delivery_time"] == null ? false : true;
    deliveryPerson = json["delivery_person"] != null
        ? DeliveryPerson.fromJson(json["delivery_person"])
        : null;
    orderData = json["order_data"];
    if (json["orderItems"] != null) {
      orderItems = [];
      json["orderItems"].forEach((v) {
        orderItems?.add(OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["order_id"] = orderId;
    map["vendor_id"] = vendorId;
    map["table_no"] = table_no;
    map["user_id"] = userId;
    map["delivery_person_id"] = deliveryPersonId;
    map["date"] = date;
    map["placed_from"] = placedFrom;
    map["time"] = time;
    map["payment_type"] = paymentType;
    map["payment_token"] = paymentToken;
    map["payment_status"] = paymentStatus;
    map["amount"] = amount;
    map["admin_commission"] = adminCommission;
    map["vendor_amount"] = vendorAmount;
    map["delivery_type"] = deliveryType;
    map["promocode_id"] = promoCodeId;
    map["promocode_price"] = promoCodePrice;
    map["vendor_discount_id"] = vendorDiscountId;
    map["vendor_discount_price"] = vendorDiscountPrice;
    map["address_id"] = addressId;
    map["delivery_charge"] = deliveryCharge;
    map["order_status"] = orderStatus;
    map["cancel_by"] = cancelBy;
    map["cancel_reason"] = cancelReason;
    map["tax"] = tax;
    map["order_start_time"] = orderStartTime;
    map["order_end_time"] = orderEndTime;
    map["user_name"] = userName;
    map["user_name1"] = userName1;
    map["user_phone"] = userPhone;
    map["vendorAddress"] = vendorAddress;
    map["userAddress"] = userAddress;
    map["mobile"] = mobile;
    map["discounts"] = discounts;
    map["notes"] = notes;
    map["delivery_time"] = deliveryTime;
    map['order_data'] = orderData;
    if (deliveryPerson != null) {
      map["delivery_person"] = deliveryPerson?.toJson();
    }
    if (orderItems != null) {
      map["orderItems"] = orderItems?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class OrderItems {
  int? id;
  int? orderId;
  int? item;
  dynamic price;
  int? qty;
  dynamic customization;
  String? createdAt;
  String? updatedAt;
  String? itemName;

  OrderItems(
      {this.id,
      this.orderId,
      this.item,
      this.price,
      this.qty,
      this.customization,
      this.createdAt,
      this.updatedAt,
      this.itemName});

  OrderItems.fromJson(dynamic json) {
    id = json["id"];
    orderId = json["order_id"];
    item = json["item"];
    price = json["price"];
    qty = json["qty"];
    customization = json["custimization"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    itemName = json["item_name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["order_id"] = orderId;
    map["item"] = item;
    map["price"] = price;
    map["qty"] = qty;
    map["custimization"] = customization;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    map["item_name"] = itemName;
    return map;
  }
}

class DeliveryPerson {
  String? firstName;
  String? lastName;
  String? contact;

  DeliveryPerson({this.firstName, this.lastName, this.contact});

  DeliveryPerson.fromJson(dynamic json) {
    firstName = json["first_name"];
    lastName = json["last_name"];
    contact = json["contact"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    map["contact"] = contact;
    return map;
  }
}
