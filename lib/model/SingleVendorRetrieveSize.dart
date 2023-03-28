import 'dart:convert';

SingleVendorRetrieveSizes singleVendorRetrieveSizesFromMap(String str) => SingleVendorRetrieveSizes.fromMap(json.decode(str));

String singleVendorRetrieveSizesToMap(SingleVendorRetrieveSizes data) => json.encode(data.toMap());

class SingleVendorRetrieveSizes {
  SingleVendorRetrieveSizes({
    required this.success,
    required this.data,
  });

  bool success;
  List<Datum>? data;

  factory SingleVendorRetrieveSizes.fromMap(Map<String, dynamic> json) => SingleVendorRetrieveSizes(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.menuSize,
  });

  int id;
  int vendorId;
  String name;
  DateTime? createdAt;
  dynamic updatedAt;
  List<MenuSize>? menuSize;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    name: json["name"] == null ? null : json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    menuSize: json["menu_size"] == null ? null : List<MenuSize>.from(json["menu_size"].map((x) => MenuSize.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "vendor_id": vendorId,
    "name": name,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "menu_size": menuSize == null ? null : List<dynamic>.from(menuSize!.map((x) => x.toMap())),
  };
}

class MenuSize {
  MenuSize({
    required this.id,
    required this.vendorId,
    required this.menuId,
    required this.itemSizeId,
    required this.price,
    required this.displayPrice,
    required this.displayDiscountPrice,
    required this.sizeDiningPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.menu,
    required this.groupMenuAddon,
    required this.menuAddon,
  });

  int id;
  int vendorId;
  int menuId;
  int itemSizeId;
  String price;
  String? displayPrice;
  String? displayDiscountPrice;
  DateTime? createdAt;
  dynamic updatedAt;
  Menu? menu;
  List<MenuAddon>? groupMenuAddon;
  List<MenuAddon>? menuAddon;
  String? sizeDiningPrice;

  factory MenuSize.fromMap(Map<String, dynamic> json) => MenuSize(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    menuId: json["menu_id"] == null ? null : json["menu_id"],
    itemSizeId: json["item_size_id"] == null ? null : json["item_size_id"],
    sizeDiningPrice: json["size_dining_price"] == null ? null : json["size_dining_price"],
    price: json["price"] == null ? null : json["price"],
    displayPrice: json["display_price"] == null ? null : json["display_price"],
    displayDiscountPrice: json["display_discount_price"] == null ? null : json["display_discount_price"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    menu: json["menu"] == null ? null : Menu.fromMap(json["menu"]),
    groupMenuAddon: json["group_menu_addon"] == null ? null : List<MenuAddon>.from(json["group_menu_addon"].map((x) => MenuAddon.fromMap(x))),
    menuAddon: json["menu_addon"] == null ? null : List<MenuAddon>.from(json["menu_addon"].map((x) => MenuAddon.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id":  id,
    "vendor_id": vendorId,
    "menu_id": menuId ,
    "item_size_id": itemSizeId,
    "price": price ,
    "size_dining_price":sizeDiningPrice==null?null:sizeDiningPrice,
    "display_price": displayPrice == null ? null : displayPrice,
    "display_discount_price": displayDiscountPrice == null ? null : displayDiscountPrice,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "menu": menu == null ? null : menu!.toMap(),
    "group_menu_addon": groupMenuAddon == null ? null : List<dynamic>.from(groupMenuAddon!.map((x) => x.toMap())),
    "menu_addon": menuAddon == null ? null : List<dynamic>.from(menuAddon!.map((x) => x.toMap())),
  };
}

class MenuAddon {
  MenuAddon({
    required this.id,
    required this.vendorId,
    required this.menuId,
    required this.menuSizeId,
    required this.addonCategoryId,
    required this.addonId,
    required this.price,
    required this.addonDiningPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.addonCategory,
    required this.addon,
  });

  int id;
  int vendorId;
  int menuId;
  int menuSizeId;
  int addonCategoryId;
  int addonId;
  String price;
  String? addonDiningPrice;
  DateTime? createdAt;
  dynamic updatedAt;
  AddonCategory? addonCategory;
  Addon? addon;

  factory MenuAddon.fromMap(Map<String, dynamic> json) => MenuAddon(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    menuId: json["menu_id"] == null ? null : json["menu_id"],
    menuSizeId: json["menu_size_id"] == null ? null : json["menu_size_id"],
    addonCategoryId: json["addon_category_id"] == null ? null : json["addon_category_id"],
    addonId: json["addon_id"] == null ? null : json["addon_id"],
    price: json["price"] == null ? null : json["price"],
    addonDiningPrice: json["addon_dining_price"] == null ? null : json["addon_dining_price"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    addonCategory: json["addon_category"] == null ? null : AddonCategory.fromMap(json["addon_category"]),
    addon: json["addon"] == null ? null : Addon.fromMap(json["addon"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id ,
    "vendor_id": vendorId,
    "menu_id": menuId ,
    "menu_size_id": menuSizeId,
    "addon_category_id": addonCategoryId,
    "addon_id": addonId,
    "price": price ,
    "addon_dining_price":addonDiningPrice==null?null:addonDiningPrice,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "addon_category": addonCategory == null ? null : addonCategory!.toMap(),
    "addon": addon == null ? null : addon!.toMap(),
  };
}

class Addon {
  Addon({
    required this.id,
    required this.vendorId,
    required this.addonCategoryId,
    required this.name,
    required this.isChecked,
    required this.createdAt,
    required this.updatedAt,
    required this.addonCategory,
  });

  int id;
  int vendorId;
  int addonCategoryId;
  String name;
  int isChecked;
  DateTime? createdAt;
  dynamic updatedAt;
  AddonCategory? addonCategory;

  factory Addon.fromMap(Map<String, dynamic> json) => Addon(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    addonCategoryId: json["addon_category_id"] == null ? null : json["addon_category_id"],
    name: json["name"] == null ? null : json["name"],
    isChecked: json["is_checked"] == null ? null : json["is_checked"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    addonCategory: json["addon_category"] == null ? null : AddonCategory.fromMap(json["addon_category"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id ,
    "vendor_id": vendorId,
    "addon_category_id": addonCategoryId,
    "name": name ,
    "is_checked": isChecked,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "addon_category": addonCategory == null ? null : addonCategory!.toMap(),
  };
}

class AddonCategory {
  AddonCategory({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.min,
    required this.max,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int vendorId;
  String name;
  int min;
  int max;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AddonCategory.fromMap(Map<String, dynamic> json) => AddonCategory(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    name: json["name"] == null ? null : json["name"],
    min: json["min"] == null ? null : json["min"],
    max: json["max"] == null ? null : json["max"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id ,
    "vendor_id": vendorId,
    "name": name ,
    "min": min ,
    "max": max ,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}

class Menu {
  Menu({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.singleMenu,
  });

  int id;
  int vendorId;
  String name;
  String image;
  String description;
  dynamic price;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<SingleMenu>? singleMenu;

  factory Menu.fromMap(Map<String, dynamic> json) => Menu(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    description: json["description"] == null ? null : json["description"],
    price: json["price"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    singleMenu: json["single_menu"] == null ? null : List<SingleMenu>.from(json["single_menu"].map((x) => SingleMenu.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "vendor_id": vendorId,
    "name": name ,
    "image": image,
    "description": description,
    "price": price,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "single_menu": singleMenu == null ? null : List<dynamic>.from(singleMenu!.map((x) => x.toMap())),
  };
}

class SingleMenu {
  SingleMenu({
    required this.id,
    required this.vendorId,
    required this.menuCategoryId,
    required this.menuId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.singleMenuItemCategory,
  });

  int id;
  int vendorId;
  int menuCategoryId;
  int menuId;
  int status;
  DateTime? createdAt;
  dynamic updatedAt;
  List<SingleMenuItemCategory>? singleMenuItemCategory;

  factory SingleMenu.fromMap(Map<String, dynamic> json) => SingleMenu(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    menuCategoryId: json["menu_category_id"] == null ? null : json["menu_category_id"],
    menuId: json["menu_id"] == null ? null : json["menu_id"],
    status: json["status"] == null ? null : json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    singleMenuItemCategory: json["single_menu_item_category"] == null ? null : List<SingleMenuItemCategory>.from(json["single_menu_item_category"].map((x) => SingleMenuItemCategory.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id ,
    "vendor_id": vendorId ,
    "menu_category_id": menuCategoryId,
    "menu_id": menuId ,
    "status": status ,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "single_menu_item_category": singleMenuItemCategory == null ? null : List<dynamic>.from(singleMenuItemCategory!.map((x) => x.toMap())),
  };
}

class SingleMenuItemCategory {
  SingleMenuItemCategory({
    required this.id,
    required this.vendorId,
    required this.singleMenuId,
    required this.itemCategoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int vendorId;
  int singleMenuId;
  int itemCategoryId;
  DateTime? createdAt;
  dynamic updatedAt;

  factory SingleMenuItemCategory.fromMap(Map<String, dynamic> json) => SingleMenuItemCategory(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    singleMenuId: json["single_menu_id"] == null ? null : json["single_menu_id"],
    itemCategoryId: json["item_category_id"] == null ? null : json["item_category_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toMap() => {
    "id": id ,
    "vendor_id": vendorId ,
    "single_menu_id": singleMenuId,
    "item_category_id": itemCategoryId,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt,
  };
}
