import 'dart:convert';

class OrderHistoryListModel {
  bool? success;
  List<OrderHistoryData>? data;

  OrderHistoryListModel({this.success, this.data});

  OrderHistoryListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(OrderHistoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderHistoryData {
  int? id;
  dynamic order_id;
  dynamic payment_type;
  dynamic user_name;
  dynamic mobile;
  dynamic notes;
  String? amount;
  int? vendorId;
  String? orderStatus;
  int? deliveryPersonId;
  String? deliveryCharge;
  String? date;
  String? time;
  int? addressId;
  String? deliveryType;
  DeliveryPerson? deliveryPerson;
  Vendor? vendor;
  User? user;
  List<OrderItems>? orderItems;
  UserAddress? userAddress;
  String? orderData;
  int? tableNo;

  OrderHistoryData(
      {this.id,
      this.amount,
      this.order_id,
      this.payment_type,
      this.user_name,
      this.mobile,
      this.notes,
      this.vendorId,
      this.orderStatus,
      this.deliveryPersonId,
      this.deliveryCharge,
      this.date,
      this.time,
      this.addressId,
      this.deliveryType,
      this.deliveryPerson,
      this.vendor,
      this.user,
      this.orderItems,
      this.userAddress,
      required this.orderData,
      required this.tableNo});

  OrderHistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    order_id = json['order_id'];
    user_name = json['user_name'];
    mobile = json['mobile'];
    notes = json['notes'];
    payment_type = json['payment_type'];
    amount = json['amount'];
    vendorId = json['vendor_id'];
    orderStatus = json['order_status'];
    deliveryPersonId = json['delivery_person_id'];
    deliveryCharge = json['delivery_charge'];
    date = json['date'];
    time = json['time'];
    addressId = json['address_id'];
    deliveryType = json['delivery_type'];
    orderData = json['order_data'];
    // orderData = json['order_data'] != null
    //     ? OrderData.fromJson(json['order_data'])
    //     : null;
    tableNo = json['table_no'];
    deliveryPerson = json['delivery_person'] != null
        ? DeliveryPerson.fromJson(json['delivery_person'])
        : null;
    vendor = json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
    user = User.fromMap(json['user']);
    if (json['orderItems'] != null) {
      orderItems = [];
      json['orderItems'].forEach((v) {
        orderItems!.add(OrderItems.fromJson(v));
      });
    }
    userAddress = json['user_address'] != null
        ? UserAddress.fromJson(json['user_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.order_id;
    data['payment_type'] = this.payment_type;
    data['user_name'] = this.user_name;
    data['mobile'] = this.mobile;
    data['notes'] = notes;
    data['amount'] = this.amount;
    data['vendor_id'] = this.vendorId;
    data['order_status'] = this.orderStatus;
    data['delivery_person_id'] = this.deliveryPersonId;
    data['delivery_charge'] = this.deliveryCharge;
    data['date'] = this.date;
    data['time'] = this.time;
    data['address_id'] = this.addressId;
    data['delivery_type'] = this.deliveryType;
    data['table_no'] = tableNo;
    data['order_data'] = orderData!;
    if (this.deliveryPerson != null) {
      data['delivery_person'] = this.deliveryPerson!.toJson();
    }
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
    data['user'] = this.user;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    if (this.userAddress != null) {
      data['user_address'] = this.userAddress!.toJson();
    }
    return data;
  }
}


OrderDataModel orderDataModelFromJson(String str) => OrderDataModel.fromJson(json.decode(str));

String orderDataModelToJson(OrderDataModel data) => json.encode(data.toJson());

class OrderDataModel {
  int? vendorId;
  List<Cart>? cart;

  OrderDataModel({
    this.vendorId,
    this.cart,
  });

  factory OrderDataModel.fromJson(Map<String, dynamic> json) => OrderDataModel(
    vendorId: json["vendor_id"],
    cart: json["cart"] == null ? [] : List<Cart>.from(json["cart"]!.map((x) => Cart.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "vendor_id": vendorId,
    "cart": cart == null ? [] : List<dynamic>.from(cart!.map((x) => x.toJson())),
  };
}

class Cart {
  String? category;
  dynamic totalAmount;
  dynamic diningAmount;
  List<Menu>? menu;
  dynamic size;
  dynamic menuCategory;
  dynamic quantity;

  Cart({
    this.category,
    this.totalAmount,
    this.diningAmount,
    this.menu,
    this.size,
    this.menuCategory,
    this.quantity,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    category: json["category"],
    totalAmount: json["total_amount"],
    diningAmount: json["dining_amount"],
    menu: json["menu"] == null ? [] : List<Menu>.from(json["menu"]!.map((x) => Menu.fromJson(x))),
    size: json["size"],
    menuCategory: json["menu_category"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "total_amount": totalAmount,
    "dining_amount": diningAmount,
    "menu": menu == null ? [] : List<dynamic>.from(menu!.map((x) => x.toJson())),
    "size": size,
    "menu_category": menuCategory,
    "quantity": quantity,
  };
}

class Menu {
  int? id;
  String? name;
  String? image;
  double? totalAmount;
  dynamic diningAmount;
  List<Addon>? addons;
  dynamic dealsItems;

  Menu({
    this.id,
    this.name,
    this.image,
    this.totalAmount,
    this.diningAmount,
    this.addons,
    this.dealsItems,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    totalAmount: json["total_amount"]?.toDouble(),
    diningAmount: json["dining_amount"],
    addons: json["addons"] == null ? [] : List<Addon>.from(json["addons"]!.map((x) => Addon.fromMap(x))),
    dealsItems: json["deals_items"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "total_amount": totalAmount,
    "dining_amount": diningAmount,
    "addons": addons == null ? [] : List<dynamic>.from(addons!.map((x) => x)),
    "deals_items": dealsItems,
  };
}

class Addon {
  Addon({
    required this.id,
    required this.name,
    required this.price,
    this.diningPrice,
  });

  int id;
  String name;
  dynamic price;
  dynamic diningPrice;

  factory Addon.fromMap(Map<String, dynamic> json) => Addon(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    diningPrice: json['dining_price'],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name ,
    "price":price,
    'dining_price':diningPrice,
  };
}

class Size {
  Size({
    required this.id,
    required this.sizeName,
  });

  int id;
  String sizeName;

  factory Size.fromMap(Map<String, dynamic> json) => Size(
    id: json["id"],
    sizeName: json["size_name"] == null ? null : json["size_name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "size_name": sizeName,
  };
}
class MenuCategory {
  MenuCategory({
    required this.name,
    required this.image,
    required this.id,
  });

  String name;
  String image;
  int id;

  factory MenuCategory.fromMap(Map<String, dynamic> json) => MenuCategory(
    name: json["name"],
    image: json["image"],
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "image": image,
    "id": id,
  };
}




class DeliveryPerson {
  String? name;
  String? image;
  String? contact;

  DeliveryPerson({this.name, this.image, this.contact});

  DeliveryPerson.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['contact'] = this.contact;
    return data;
  }
}

class Vendor {
  int? id;
  int? userId;
  String? name;
  String? vendorLogo;
  String? emailId;
  String? image;
  String? password;
  String? contact;
  String? cuisineId;
  String? address;
  String? lat;
  String? lang;
  String? mapAddress;
  String? minOrderAmount;
  String? forTwoPerson;
  String? avgDeliveryTime;
  String? licenseNumber;
  String? adminComissionType;
  String? adminComissionValue;
  String? vendorType;
  String? timeSlot;
  String? tax;
  Null deliveryTypeTimeSlot;
  int? isExplorer;
  int? isTop;
  int? vendorOwnDriver;
  Null paymentOption;
  int? status;
  String? vendorLanguage;
  String? createdAt;
  String? updatedAt;
  List<Cuisine>? cuisine;
  double? rate;
  int? review;

  Vendor(
      {this.id,
      this.userId,
      this.name,
      this.vendorLogo,
      this.emailId,
      this.image,
      this.password,
      this.contact,
      this.cuisineId,
      this.address,
      this.lat,
      this.lang,
      this.mapAddress,
      this.minOrderAmount,
      this.forTwoPerson,
      this.avgDeliveryTime,
      this.licenseNumber,
      this.adminComissionType,
      this.adminComissionValue,
      this.vendorType,
      this.timeSlot,
      this.tax,
      this.deliveryTypeTimeSlot,
      this.isExplorer,
      this.isTop,
      this.vendorOwnDriver,
      this.paymentOption,
      this.status,
      this.vendorLanguage,
      this.createdAt,
      this.updatedAt,
      this.cuisine,
      this.rate,
      this.review});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    vendorLogo = json['vendor_logo'];
    emailId = json['email_id'];
    image = json['image'];
    password = json['password'];
    contact = json['contact'];
    cuisineId = json['cuisine_id'];
    address = json['address'];
    lat = json['lat'];
    lang = json['lang'];
    mapAddress = json['map_address'];
    minOrderAmount = json['min_order_amount'];
    forTwoPerson = json['for_two_person'];
    avgDeliveryTime = json['avg_delivery_time'];
    licenseNumber = json['license_number'];
    adminComissionType = json['admin_comission_type'];
    adminComissionValue = json['admin_comission_value'];
    vendorType = json['vendor_type'];
    timeSlot = json['time_slot'];
    tax = json['tax'];
    deliveryTypeTimeSlot = json['delivery_type_timeSlot'];
    isExplorer = json['isExplorer'];
    isTop = json['isTop'];
    vendorOwnDriver = json['vendor_own_driver'];
    paymentOption = json['payment_option'];
    status = json['status'];
    vendorLanguage = json['vendor_language'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['cuisine'] != null) {
      cuisine = [];
      json['cuisine'].forEach((v) {
        cuisine!.add(Cuisine.fromJson(v));
      });
    }
    rate = json['rate'].toDouble();
    review = json['review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['vendor_logo'] = this.vendorLogo;
    data['email_id'] = this.emailId;
    data['image'] = this.image;
    data['password'] = this.password;
    data['contact'] = this.contact;
    data['cuisine_id'] = this.cuisineId;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    data['map_address'] = this.mapAddress;
    data['min_order_amount'] = this.minOrderAmount;
    data['for_two_person'] = this.forTwoPerson;
    data['avg_delivery_time'] = this.avgDeliveryTime;
    data['license_number'] = this.licenseNumber;
    data['admin_comission_type'] = this.adminComissionType;
    data['admin_comission_value'] = this.adminComissionValue;
    data['vendor_type'] = this.vendorType;
    data['time_slot'] = this.timeSlot;
    data['tax'] = this.tax;
    data['delivery_type_timeSlot'] = this.deliveryTypeTimeSlot;
    data['isExplorer'] = this.isExplorer;
    data['isTop'] = this.isTop;
    data['vendor_own_driver'] = this.vendorOwnDriver;
    data['payment_option'] = this.paymentOption;
    data['status'] = this.status;
    data['vendor_language'] = this.vendorLanguage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.cuisine != null) {
      data['cuisine'] = this.cuisine!.map((v) => v.toJson()).toList();
    }
    data['rate'] = this.rate;
    data['review'] = this.review;
    return data;
  }
}

class Cuisine {
  String? name;
  String? image;

  Cuisine({this.name, this.image});

  Cuisine.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class OrderItems {
  int? id;
  int? orderId;
  int? item;
  dynamic price;
  int? qty;
  List<Custimization>? custimization;
  String? createdAt;
  String? updatedAt;
  String? itemName;

  OrderItems(
      {this.id,
      this.orderId,
      this.item,
      this.price,
      this.qty,
      this.custimization,
      this.createdAt,
      this.updatedAt,
      this.itemName});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    item = json['item'];
    price = json['price'];
    qty = json['qty'];
    if (json['custimization'] != null) {
      custimization = [];
      json['custimization'].forEach((v) {
        custimization!.add(Custimization.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    itemName = json['item_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['item'] = this.item;
    data['price'] = this.price;
    data['qty'] = this.qty;
    if (this.custimization != null) {
      data['custimization'] =
          this.custimization!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['item_name'] = this.itemName;
    return data;
  }
}

class Custimization {
  String? mainMenu;
  OrderHistoryData? data;

  Custimization({this.mainMenu, this.data});

  Custimization.fromJson(Map<String, dynamic> json) {
    mainMenu = json['main_menu'];
    data =
        json['data'] != null ? OrderHistoryData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['main_menu'] = this.mainMenu;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? name;
  String? price;

  Data({this.name, this.price});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}

class UserAddress {
  String? lat;
  String? lang;
  String? address;

  UserAddress({this.lat, this.lang, this.address});

  UserAddress.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lang = json['lang'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    data['address'] = this.address;
    return data;
  }
  // To parse this JSON data, do
//
//     final user = userFromMap(jsonString);
}

User userFromMap(String str) => User.fromMap(jsonDecode(str));

String userToMap(User data) => jsonEncode(data.toMap());

class User {
  User({
    required this.id,
    required this.name,
    required this.image,
    required this.emailId,
    required this.emailVerifiedAt,
    required this.deviceToken,
    required this.phone,
    required this.phoneCode,
    required this.isVerified,
    required this.status,
    required this.otp,
    required this.faviroute,
    required this.vendorId,
    required this.language,
    required this.ifscCode,
    required this.accountName,
    required this.accountNumber,
    required this.micrCode,
    required this.providerType,
    required this.providerToken,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String image;
  final String emailId;
  final String? emailVerifiedAt;
  final String? deviceToken;
  final String phone;
  final String? phoneCode;
  final int isVerified;
  final int status;
  final dynamic otp;
  final String? faviroute;
  final dynamic vendorId;
  final String? language;
  final dynamic ifscCode;
  final dynamic accountName;
  final dynamic accountNumber;
  final dynamic micrCode;
  final dynamic providerType;
  final dynamic providerToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        emailId: json["email_id"],
        emailVerifiedAt: json["email_verified_at"],
        deviceToken: json["device_token"],
        phone: json["phone"],
        phoneCode: json["phone_code"],
        isVerified: json["is_verified"],
        status: json["status"],
        otp: json["otp"],
        faviroute: json["faviroute"],
        vendorId: json["vendor_id"],
        language: json["language"],
        ifscCode: json["ifsc_code"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        micrCode: json["micr_code"],
        providerType: json["provider_type"],
        providerToken: json["provider_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "image": image,
        "email_id": emailId,
        "email_verified_at": emailVerifiedAt,
        "device_token": deviceToken,
        "phone": phone,
        "phone_code": phoneCode,
        "is_verified": isVerified,
        "status": status,
        "otp": otp,
        "faviroute": faviroute,
        "vendor_id": vendorId,
        "language": language,
        "ifsc_code": ifscCode,
        "account_name": accountName,
        "account_number": accountNumber,
        "micr_code": micrCode,
        "provider_type": providerType,
        "provider_token": providerToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

// To parse this JSON data, do
//
//     final orderData = orderDataFromJson(jsonString);

// OrderData orderDataFromJson(String str) => OrderData.fromJson(json.decode(str));
//
// String orderDataToJson(OrderData data) => json.encode(data.toJson());
//
// class OrderData {
//   OrderData({
//     this.vendorId,
//     this.cart,
//   });
//
//   int? vendorId;
//   List<Cart>? cart;
//
//   factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
//         vendorId: json["vendor_id"],
//         cart: json["cart"] == null
//             ? []
//             : List<Cart>.from(json["cart"]!.map((x) => Cart.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "vendor_id": vendorId,
//         "cart": cart == null
//             ? []
//             : List<dynamic>.from(cart!.map((x) => x.toJson())),
//       };
// }

// class Cart {
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
//   String? category;
//   int? totalAmount;
//   int? diningAmount;
//   List<Menu>? menu;
//   dynamic size;
//   dynamic menuCategory;
//   int? quantity;
//
//   factory Cart.fromJson(Map<String, dynamic> json) => Cart(
//         category: json["category"],
//         totalAmount: json["total_amount"],
//         diningAmount: json["dining_amount"],
//         menu: json["menu"] == null
//             ? []
//             : List<Menu>.from(json["menu"]!.map((x) => Menu.fromJson(x))),
//         size: json["size"],
//         menuCategory: json["menu_category"],
//         quantity: json["quantity"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "category": category,
//         "total_amount": totalAmount,
//         "dining_amount": diningAmount,
//         "menu": menu == null
//             ? []
//             : List<dynamic>.from(menu!.map((x) => x.toJson())),
//         "size": size,
//         "menu_category": menuCategory,
//         "quantity": quantity,
//       };
// }
//
// class Menu {
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
//   int? id;
//   String? name;
//   String? image;
//   int? totalAmount;
//   dynamic diningAmount;
//   List<Addon>? addons;
//   dynamic dealsItems;
//
//   factory Menu.fromJson(Map<String, dynamic> json) => Menu(
//         id: json["id"],
//         name: json["name"],
//         image: json["image"],
//         totalAmount: json["total_amount"],
//         diningAmount: json["dining_amount"],
//         addons: json["addons"] == null
//             ? []
//             : List<Addon>.from(json["addons"]!.map((x) => Addon.fromJson(x))),
//         dealsItems: json["deals_items"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "image": image,
//         "total_amount": totalAmount,
//         "dining_amount": diningAmount,
//         "addons": addons == null
//             ? []
//             : List<dynamic>.from(addons!.map((x) => x.toJson())),
//         "deals_items": dealsItems,
//       };
// }
//
// class Addon {
//   Addon({
//     this.id,
//     this.name,
//     this.price,
//     this.diningPrice,
//   });
//
//   int? id;
//   String? name;
//   int? price;
//   int? diningPrice;
//
//   factory Addon.fromJson(Map<String, dynamic> json) => Addon(
//         id: json["id"],
//         name: json["name"],
//         price: json["price"],
//         diningPrice: json["dining_price"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "price": price,
//         "dining_price": diningPrice,
//       };
// }
