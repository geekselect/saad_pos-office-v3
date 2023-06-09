import 'dart:convert';

CartMaster cartMasterFromMap(String str) => CartMaster.fromMap(json.decode(str));

String cartMasterToMap(CartMaster data) => json.encode(data.toMap());

class CartMaster {
  CartMaster({
    this.oldOrderId,
    required this.vendorId,
    required this.cart,

  });
  int? oldOrderId;
  int vendorId;
  List<Cart> cart;

  factory CartMaster.fromMap(Map<String, dynamic> json) => CartMaster(
    vendorId: json["vendor_id"],
    oldOrderId: json["id"],
    cart: List<Cart>.from(json["cart"].map((x) => Cart.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "vendor_id": vendorId,
    "id": oldOrderId,
    "cart": List<dynamic>.from(cart.map((x) => x.toMap())),
  };
}

class Cart {
  Cart({
    required this.category,
    required this.menu,
    required this.size,
    required this.totalAmount,
     this.diningAmount,
    required this.quantity,
    this.menuCategory
  });
  String category;
  List<MenuCartMaster> menu;
  Size? size;
  MenuCategoryCartMaster? menuCategory;
  dynamic totalAmount;
  dynamic diningAmount;
  int quantity;
  factory Cart.fromMap(Map<String, dynamic> json) => Cart(
    category: json["category"],
    totalAmount: json["total_amount"],
    diningAmount: json["dining_amount"],
    menu: List<MenuCartMaster>.from(json["menu"].map((x) => MenuCartMaster.fromMap(x))),
    size: json["size"] == null ? null : Size.fromMap(json["size"]),
    menuCategory: json["menu_category"] == null ? null : MenuCategoryCartMaster.fromMap(json["menu_category"]),
    quantity: json['quantity']
  );

  Map<String, dynamic> toMap() => {
    "category": category,
    "total_amount": totalAmount,
    "dining_amount": diningAmount,
    "menu": List<dynamic>.from(menu.map((x) => x.toMap())),
    "size": size == null ? null : size!.toMap(),
    "menu_category":menuCategory == null ?null:menuCategory!.toMap(),
    'quantity':quantity,
  };
}

class MenuCartMaster {
  MenuCartMaster({
    required this.id,
    required this.name,
    required this.image,
     this.diningAmount,
    required this.totalAmount,
    required this.addons,
    required this.modifiers,
    this.dealsItems

  });

  int id;
  String name;
  String image;
  dynamic diningAmount;
  dynamic totalAmount;
  List<AddonCartMaster> addons;
  List<Modifier> modifiers;
  DealsItems? dealsItems;

  factory MenuCartMaster.fromMap(Map<String, dynamic> json) => MenuCartMaster(
    id: json["id"],
    name:json['name'],
    image:json['image'],
    totalAmount: json['total_amount'],
    diningAmount: json['dining_amount'],
    addons: List<AddonCartMaster>.from(json["addons"].map((x) => AddonCartMaster.fromMap(x))),
    modifiers: json["modifiers"] == null ? [] : List<Modifier>.from(json["modifiers"]!.map((x) => Modifier.fromJson(x))),
    dealsItems: json["deals_items"] == null ? null : DealsItems.fromMap(json["deals_items"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name":name,
    "image":image,
    "total_amount":totalAmount,
    "dining_amount":diningAmount,
    "addons": List<dynamic>.from(addons.map((x) => x.toMap())),
    "modifiers": List<dynamic>.from(modifiers.map((x) => x.toJson())),
    "deals_items":dealsItems == null ?null:dealsItems!.toMap(),
  };
}

class DealsItems {
DealsItems({
  required this.name,
  required this.id,
});

final String name;
final int id;

factory DealsItems.fromMap(Map<String, dynamic> json) => DealsItems(
name: json["name"],
id: json["id"],
);

Map<String, dynamic> toMap() => {
  "name": name,
  "id": id,
};
}

class AddonCartMaster {
  AddonCartMaster({
    required this.id,
    required this.name,
    required this.price,
     this.diningPrice,
  });

  int id;
  String name;
  dynamic price;
  dynamic diningPrice;

  factory AddonCartMaster.fromMap(Map<String, dynamic> json) => AddonCartMaster(
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

class ModifierModel {
  List<Modifier>? modifiers;

  ModifierModel({
    this.modifiers,
  });

  factory ModifierModel.fromJson(Map<String, dynamic> json) => ModifierModel(
    modifiers: json["modifiers"] == null ? [] : List<Modifier>.from(json["modifiers"]!.map((x) => Modifier.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "modifiers": modifiers == null ? [] : List<dynamic>.from(modifiers!.map((x) => x.toJson())),
  };
}

class Modifier {
  String? modifierType;
  List<ModifierDetail>? modifierDetails;

  Modifier({
    this.modifierType,
    this.modifierDetails,
  });

  factory Modifier.fromJson(Map<String, dynamic> json) => Modifier(
    modifierType: json["modifier_type"],
    modifierDetails: json["modifier_details"] == null ? [] : List<ModifierDetail>.from(json["modifier_details"]!.map((x) => ModifierDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "modifier_type": modifierType,
    "modifier_details": modifierDetails == null ? [] : List<dynamic>.from(modifierDetails!.map((x) => x.toJson())),
  };
}

class ModifierDetail {
  String? modifierName;
  double? modifierPrice;

  ModifierDetail({
    this.modifierName,
    this.modifierPrice,
  });

  factory ModifierDetail.fromJson(Map<String, dynamic> json) => ModifierDetail(
    modifierName: json["modifier_name"],
    modifierPrice: json["modifier_price"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "modifier_name": modifierName,
    "modifier_price": modifierPrice,
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
class MenuCategoryCartMaster {
  MenuCategoryCartMaster({
    required this.name,
    required this.image,
    required this.id,
  });

  String name;
  String image;
  int id;

  factory MenuCategoryCartMaster.fromMap(Map<String, dynamic> json) => MenuCategoryCartMaster(
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

