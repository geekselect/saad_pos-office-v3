
import 'dart:convert';

SingleRestaurantsDetailsModel singleRestaurantsDetailsModelFromMap(String str) => SingleRestaurantsDetailsModel.fromMap(json.decode(str));

String singleRestaurantsDetailsModelToMap(SingleRestaurantsDetailsModel data) => json.encode(data.toMap());

class SingleRestaurantsDetailsModel {
  SingleRestaurantsDetailsModel({
    required this.success,
    this.data,
  });

  bool success;
  DataSingleVendor? data;
  factory SingleRestaurantsDetailsModel.fromJson(String str) => SingleRestaurantsDetailsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());
  factory SingleRestaurantsDetailsModel.fromMap(Map<String, dynamic> json) => SingleRestaurantsDetailsModel(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : DataSingleVendor.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "success": success ,
    "data": data == null ? null : data!.toMap(),
  };
}

class DataSingleVendor {
  DataSingleVendor({
    required this.vendor,
    required this.menuCategory,
    required this.vendorDiscount,
    required this.deliveryTimeslot,
    required this.pickUpTimeslot,
    required this.sellingTimeslot,
  });

  Vendor? vendor;
  List<MenuCategory>? menuCategory;
  dynamic vendorDiscount;
  List<Timeslot>? deliveryTimeslot;
  List<Timeslot>? pickUpTimeslot;
  List<SellingTimeslot>? sellingTimeslot;

  factory DataSingleVendor.fromMap(Map<String, dynamic> json) => DataSingleVendor(
    vendor: json["vendor"] == null ? null : Vendor.fromMap(json["vendor"]),
    menuCategory: json["MenuCategory"] == null ? null : List<MenuCategory>.from(json["MenuCategory"].map((x) => MenuCategory.fromMap(x))),
    vendorDiscount: json["vendor_discount"],
    deliveryTimeslot: json["delivery_timeslot"] == null ? null : List<Timeslot>.from(json["delivery_timeslot"].map((x) => Timeslot.fromMap(x))),
    pickUpTimeslot: json["pick_up_timeslot"] == null ? null : List<Timeslot>.from(json["pick_up_timeslot"].map((x) => Timeslot.fromMap(x))),
    sellingTimeslot: json["selling_timeslot"] == null ? null : List<SellingTimeslot>.from(json["selling_timeslot"].map((x) => SellingTimeslot.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "vendor": vendor == null ? null : vendor!.toMap(),
    "MenuCategory": menuCategory == null ? null : List<dynamic>.from(menuCategory!.map((x) => x.toMap())),
    "vendor_discount": vendorDiscount,
    "delivery_timeslot": deliveryTimeslot == null ? null : List<dynamic>.from(deliveryTimeslot!.map((x) => x.toMap())),
    "pick_up_timeslot": pickUpTimeslot == null ? null : List<dynamic>.from(pickUpTimeslot!.map((x) => x.toMap())),
    "selling_timeslot": sellingTimeslot == null ? null : List<dynamic>.from(sellingTimeslot!.map((x) => x.toMap())),
  };
}

class Timeslot {
  Timeslot({
    required this.id,
    required this.dayIndex,
    required this.periodList,
    required this.status,
  });

  int id;
  String dayIndex;
  List<PeriodList>? periodList;
  int status;

  factory Timeslot.fromMap(Map<String, dynamic> json) => Timeslot(
    id: json["id"] == null ? null : json["id"],
    dayIndex: json["day_index"] == null ? null : json["day_index"],
    periodList: json["period_list"] == null ? null : List<PeriodList>.from(json["period_list"].map((x) => PeriodList.fromMap(x))),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "day_index": dayIndex ,
    "period_list":  List<dynamic>.from(periodList!.map((x) => x.toMap())),
    "status": status,
  };
}

class PeriodList {
  PeriodList({
    required this.startTime,
    required this.endTime,
    required this.newStartTime,
    required this.newEndTime,
  });

  String startTime;
  String endTime;
  DateTime? newStartTime;
  DateTime? newEndTime;

  factory PeriodList.fromMap(Map<String, dynamic> json) => PeriodList(
    startTime: json["start_time"] == null ? null : json["start_time"],
    endTime: json["end_time"] == null ? null : json["end_time"],
    newStartTime: json["new_start_time"] == null ? null : DateTime.parse(json["new_start_time"]),
    newEndTime: json["new_end_time"] == null ? null : DateTime.parse(json["new_end_time"]),
  );

  Map<String, dynamic> toMap() => {
    "start_time": startTime ,
    "end_time": endTime ,
    "new_start_time": newStartTime == null ? null : newStartTime!.toIso8601String(),
    "new_end_time": newEndTime == null ? null : newEndTime!.toIso8601String(),
  };
}

class MenuCategory {
  MenuCategory({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.singleMenu,
    required this.halfNHalfMenu,
    required this.dealsMenu,
  });

  int id;
  int vendorId;
  String name;
  int status;
  String type;
  DateTime? createdAt;
  dynamic updatedAt;
  List<SingleMenu>? singleMenu;
  List<HalfNHalfMenu>? halfNHalfMenu;
  List<DealsMenu>? dealsMenu;
  bool selected=false;

  // List<Menu> getFilteredMenuItems(String? searchQuery) {
  //   List<Menu> filteredList = [];
  //
  //   if (singleMenu != null && type == 'SINGLE') {
  //     for (SingleMenu item in singleMenu!) {
  //       if (searchQuery == null || item.menu!.name.contains(searchQuery)) {
  //         filteredList.add(item.menu!);
  //       }
  //     }
  //   } else if (halfNHalfMenu != null && type == 'HALF_N_HALF') {
  //     for (HalfNHalfMenu item in halfNHalfMenu!) {
  //       if (searchQuery == null || item.name.contains(searchQuery)) {
  //         filteredList.add(Menu(name: item.name, id: item.id, vendorId: item.vendorId, image: item.image, description: item.description, price: item.itemCategory.p, displayPrice: '', diningPrice: '', displayDiscountPrice: '', createdAt: DateTime.now(), ));
  //       }
  //     }
  //   } else if (dealsMenu != null && type == 'DEALS') {
  //     for (DealsMenu item in dealsMenu!) {
  //       if (searchQuery == null || item.name.contains(searchQuery)) {
  //         filteredList.add(Menu(name: item.name));
  //       }
  //     }
  //   } else {
  //     if (singleMenu != null) {
  //       for (SingleMenu item in singleMenu!) {
  //         if (searchQuery == null || item.menu!.name.contains(searchQuery)) {
  //           filteredList.add(item.menu!);
  //         }
  //       }
  //     }
  //
  //     if (halfNHalfMenu != null) {
  //       for (HalfNHalfMenu item in halfNHalfMenu!) {
  //         if (searchQuery == null || item.name.contains(searchQuery)) {
  //           filteredList.add(Menu(name: item.name));
  //         }
  //       }
  //     }
  //
  //     if (dealsMenu != null) {
  //       for (DealsMenu item in dealsMenu!) {
  //         if (searchQuery == null || item.name.contains(searchQuery)) {
  //           filteredList.add(Menu(name: item.name));
  //         }
  //       }
  //     }
  //   }
  //
  //   return filteredList;
  // }

  factory MenuCategory.fromMap(Map<String, dynamic> json) => MenuCategory(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    name: json["name"] == null ? null : json["name"],
    status: json["status"] == null ? null : json["status"],
    type: json["type"] == null ? null : json["type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    singleMenu: json["single_menu"] == null ? null : List<SingleMenu>.from(json["single_menu"].map((x) => SingleMenu.fromMap(x))),
    halfNHalfMenu: json["half_n_half_menu"] == null ? null : List<HalfNHalfMenu>.from(json["half_n_half_menu"].map((x) => HalfNHalfMenu.fromMap(x))),
    dealsMenu: json["deals_menu"] == null ? null : List<DealsMenu>.from(json["deals_menu"].map((x) => DealsMenu.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "vendor_id": vendorId,
    "name": name ,
    "status": status,
    "type": type ,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "single_menu": singleMenu == null ? null : List<dynamic>.from(singleMenu!.map((x) => x.toMap())),
    "half_n_half_menu": halfNHalfMenu == null ? null : List<dynamic>.from(halfNHalfMenu!.map((x) => x.toMap())),
    "deals_menu": dealsMenu == null ? null : List<dynamic>.from(dealsMenu!.map((x) => x.toMap())),
  };
}

class DealsMenu {
  DealsMenu({
    required this.id,
    required this.vendorId,
    required this.menuCategoryId,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.displayPrice,
    required this.displayDiscountPrice,
    required this.dealsDiningPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.dealsItems,
  });

  int id;
  int vendorId;
  int menuCategoryId;
  String name;
  String image;
  String description;
  String? price;
  String? displayPrice;
  String? displayDiscountPrice;
  String? dealsDiningPrice;
  int status;
  DateTime? createdAt;
  dynamic updatedAt;
  List<DealsItem>? dealsItems;

  factory DealsMenu.fromMap(Map<String, dynamic> json) => DealsMenu(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    menuCategoryId: json["menu_category_id"] == null ? null : json["menu_category_id"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    description: json["description"] == null ? null : json["description"],
    price: json["price"] == null ? null : json["price"],
    displayPrice: json["display_price"] == null ? null : json["display_price"],
    displayDiscountPrice: json["display_discount_price"] == null ? null : json["display_discount_price"],
    dealsDiningPrice: json["deals_dining_price"] ,
    status: json["status"] == null ? null : json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    dealsItems: json["deals_items"] == null ? null : List<DealsItem>.from(json["deals_items"].map((x) => DealsItem.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "vendor_id": vendorId ,
    "menu_category_id": menuCategoryId,
    "name": name ,
    "image": image ,
    "description": description,
    "price": price == null ? null : price,
    "display_price": displayPrice == null ? null : displayPrice,
    "display_discount_price": displayDiscountPrice == null ? null : displayDiscountPrice,
    "deals_dining_price": dealsDiningPrice,
    "status": status ,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "deals_items": dealsItems == null ? null : List<dynamic>.from(dealsItems!.map((x) => x.toMap())),
  };
}

class DealsItem {
  DealsItem({
    required this.id,
    required this.vendorId,
    required this.menuCategoryId,
    required this.itemCategoryId,
    required this.dealsMenuId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.itemCategory,
    required this.itemSizeId,
    required this.itemSize,
  });

  int id;
  int vendorId;
  int menuCategoryId;
  int itemCategoryId;
  int dealsMenuId;
  String name;
  DateTime? createdAt;
  dynamic updatedAt;
  Item? itemCategory;
  int itemSizeId;
  Item? itemSize;

  factory DealsItem.fromMap(Map<String, dynamic> json) => DealsItem(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    menuCategoryId: json["menu_category_id"] == null ? null : json["menu_category_id"],
    itemCategoryId: json["item_category_id"] == null ? null : json["item_category_id"],
    dealsMenuId: json["deals_menu_id"] == null ? null : json["deals_menu_id"],
    name: json["name"] == null ? null : json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    itemCategory: json["item_category"] == null ? null : Item.fromMap(json["item_category"]),
    itemSizeId: json["item_size_id"] == null ? null : json["item_size_id"],
    itemSize: json["item_size"] == null ? null : Item.fromMap(json["item_size"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "vendor_id": vendorId ,
    "menu_category_id": menuCategoryId,
    "item_category_id": itemCategoryId,
    "deals_menu_id": dealsMenuId ,
    "name": name,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "item_category": itemCategory == null ? null : itemCategory!.toMap(),
    "item_size_id": itemSizeId ,
    "item_size": itemSize == null ? null : itemSize!.toMap(),
  };
}

class Item {
  Item({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.itemDiningPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  int? vendorId;
  String? name;
  String? itemDiningPrice;
  DateTime? createdAt;
  dynamic updatedAt;

  factory Item.fromMap(Map<String, dynamic> json) => Item(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    name: json["name"] == null ? null : json["name"],
    itemDiningPrice: json["item_dining_price"] == null ? null : json["item_dining_price"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "vendor_id": vendorId == null ? null : vendorId,
    "name": name == null ? null : name,
    "item_dining_price": itemDiningPrice == null ? null : itemDiningPrice,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt,
  };
}

class HalfNHalfMenu {
  HalfNHalfMenu({
    required this.id,
    required this.vendorId,
    required this.menuCategoryId,
    required this.itemCategoryId,
    required this.name,
    required this.image,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.itemCategory,
  });

  int id;
  int vendorId;
  int menuCategoryId;
  int itemCategoryId;
  String name;
  String image;
  String description;
  int status;
  DateTime? createdAt;
  dynamic updatedAt;
  Item? itemCategory;

  factory HalfNHalfMenu.fromMap(Map<String, dynamic> json) => HalfNHalfMenu(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    menuCategoryId: json["menu_category_id"] == null ? null : json["menu_category_id"],
    itemCategoryId: json["item_category_id"] == null ? null : json["item_category_id"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    description: json["description"] == null ? null : json["description"],
    status: json["status"] == null ? null : json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    itemCategory: json["item_category"] == null ? null : Item.fromMap(json["item_category"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "vendor_id": vendorId,
    "menu_category_id": menuCategoryId ,
    "item_category_id": itemCategoryId ,
    "name": name ,
    "image": image,
    "description": description,
    "status": status ,
    "created_at":  createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "item_category": itemCategory == null ? null : itemCategory!.toMap(),
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
    required this.menu,
    required this.singleMenuItemCategory,
  });

  int id;
  int vendorId;
  int menuCategoryId;
  int menuId;
  int status;
  DateTime? createdAt;
  dynamic updatedAt;
  Menu? menu;
  List<SingleMenuItemCategory>? singleMenuItemCategory;

  factory SingleMenu.fromMap(Map<String, dynamic> json) => SingleMenu(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    menuCategoryId: json["menu_category_id"] == null ? null : json["menu_category_id"],
    menuId: json["menu_id"] == null ? null : json["menu_id"],
    status: json["status"] == null ? null : json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    menu: json["menu"] == null ? null : Menu.fromMap(json["menu"]),
    singleMenuItemCategory: json["single_menu_item_category"] == null ? null : List<SingleMenuItemCategory>.from(json["single_menu_item_category"].map((x) => SingleMenuItemCategory.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id ,
    "vendor_id": vendorId ,
    "menu_category_id": menuCategoryId,
    "menu_id": menuId,
    "status": status ,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "menu": menu == null ? null : menu!.toMap(),
    "single_menu_item_category": singleMenuItemCategory == null ? null : List<dynamic>.from(singleMenuItemCategory!.map((x) => x.toMap())),
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
    required this.displayPrice,
    required this.diningPrice,
    required this.displayDiscountPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.groupMenuAddon,
    required this.menuAddon,
    required this.menuSize,
  });

  int id;
  int vendorId;
  String name;
  String image;
  String description;
  String? price;
  String? displayPrice;
  String? diningPrice;
  String? displayDiscountPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<MenuAddon>? menuAddon;
  List<MenuAddon>? groupMenuAddon;
  List<MenuSize>? menuSize;
  bool isAdded=false;
  int count=0;

  factory Menu.fromMap(Map<String, dynamic> json) => Menu(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    description: json["description"] == null ? null : json["description"],
    price: json["price"] == null ? null : json["price"],
    displayPrice: json["display_price"] == null ? null : json["display_price"],
    diningPrice: json["dining_price"] == null ? null : json["dining_price"],
    displayDiscountPrice: json["display_discount_price"] == null ? null : json["display_discount_price"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    groupMenuAddon: json["group_menu_addon"] == null ? null : List<MenuAddon>.from(json["group_menu_addon"].map((x) => MenuAddon.fromMap(x))),
    menuAddon: json["menu_addon"] == null ? null : List<MenuAddon>.from(json["menu_addon"].map((x) => MenuAddon.fromMap(x))),
    menuSize: json["menu_size"] == null ? null : List<MenuSize>.from(json["menu_size"].map((x) => MenuSize.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id ,
    "vendor_id": vendorId ,
    "name": name,
    "image": image,
    "description": description,
    "price": price == null ? null : price,
    "display_price": displayPrice == null ? null : displayPrice,
    "dining_price": diningPrice == null ? null : diningPrice,
    "display_discount_price": displayDiscountPrice == null ? null : displayDiscountPrice,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "group_menu_addon": groupMenuAddon == null ? null : List<dynamic>.from(groupMenuAddon!.map((x) => x.toMap())),
    "menu_addon": menuAddon == null ? null : List<dynamic>.from(menuAddon!.map((x) => x.toMap())),
    "menu_size": menuSize == null ? null : List<dynamic>.from(menuSize!.map((x) => x.toMap())),
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
    required this.addon,
    required this.addonCategory,
  });

  int id;
  int? vendorId;
  int? menuId;
  int? menuSizeId;
  int? addonCategoryId;
  bool isDuplicate=false;
  int? addonId;
  String? price;
  String? addonDiningPrice;
  DateTime? createdAt;
  dynamic updatedAt;
  Addon? addon;
  AddonCategory? addonCategory;

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
    addon: json["addon"] == null ? null : Addon.fromMap(json["addon"]),
    addonCategory: json["addon_category"] == null ? null : AddonCategory.fromMap(json["addon_category"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id ,
    "vendor_id": vendorId == null ? null : vendorId,
    "menu_id": menuId == null ? null : menuId,
    "menu_size_id": menuSizeId == null ? null : menuSizeId,
    "addon_category_id": addonCategoryId == null ? null : addonCategoryId,
    "addon_id": addonId == null ? null : addonId,
    "price": price == null ? null : price,
    "addon_dining_price":addonDiningPrice==null?null:addonDiningPrice,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "addon": addon == null ? null : addon!.toMap(),
    "addon_category": addonCategory == null ? null : addonCategory!.toMap(),
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
    isChecked:json['is_checked'],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    addonCategory: json["addon_category"] == null ? null : AddonCategory.fromMap(json["addon_category"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id ,
    "vendor_id": vendorId,
    "addon_category_id": addonCategoryId,
    "name": name,
    "is_checked":isChecked,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
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
    "vendor_id": vendorId ,
    "name": name ,
    "min": min ,
    "max": max ,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
  };
}

class MenuSize {
  MenuSize({
    required this.id,
    required this.vendorId,
    required this.menuId,
    required this.itemSizeId,
    required this.sizeDiningPrice,
    required this.price,
    required this.displayPrice,
    required this.displayDiscountPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.groupMenuAddon,
    required this.menuAddon,
    required this.itemSize,
  });

  int id;
  int vendorId;
  int menuId;
  int itemSizeId;
  String? sizeDiningPrice;
  String? price;
  String? displayPrice;
  String? displayDiscountPrice;
  DateTime? createdAt;
  dynamic updatedAt;
  List<MenuAddon>? groupMenuAddon;
  List<MenuAddon>? menuAddon;
  Item? itemSize;

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
    groupMenuAddon: json["group_menu_addon"] == null ? null : List<MenuAddon>.from(json["group_menu_addon"].map((x) => MenuAddon.fromMap(x))),
    menuAddon: json["menu_addon"] == null ? null : List<MenuAddon>.from(json["menu_addon"].map((x) => MenuAddon.fromMap(x))),
    itemSize: json["item_size"] == null ? null : Item.fromMap(json["item_size"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id ,
    "vendor_id": vendorId ,
    "menu_id": menuId ,
    "item_size_id": itemSizeId,
    "size_dining_price":sizeDiningPrice==null?null:sizeDiningPrice,
    "price": price == null ? null : price,
    "display_price": displayPrice == null ? null : displayPrice,
    "display_discount_price": displayDiscountPrice == null ? null : displayDiscountPrice,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "group_menu_addon": groupMenuAddon == null ? null : List<dynamic>.from(groupMenuAddon!.map((x) => x.toMap())),
    "menu_addon": menuAddon == null ? null : List<dynamic>.from(menuAddon!.map((x) => x.toMap())),
    "item_size": itemSize == null ? null : itemSize!.toMap(),
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
    required this.itemCategory,
  });

  int id;
  int vendorId;
  int singleMenuId;
  int itemCategoryId;
  DateTime? createdAt;
  dynamic updatedAt;
  Item? itemCategory;

  factory SingleMenuItemCategory.fromMap(Map<String, dynamic> json) => SingleMenuItemCategory(
    id: json["id"] == null ? null : json["id"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    singleMenuId: json["single_menu_id"] == null ? null : json["single_menu_id"],
    itemCategoryId: json["item_category_id"] == null ? null : json["item_category_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    itemCategory: json["item_category"] == null ? null : Item.fromMap(json["item_category"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "vendor_id": vendorId ,
    "single_menu_id": singleMenuId ,
    "item_category_id": itemCategoryId,
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "item_category": itemCategory == null ? null : itemCategory!.toMap(),
  };
}

class SellingTimeslot {
  SellingTimeslot({
    required this.id,
    required this.dayIndex,
    required this.periodList,
    required this.status,
  });

  int id;
  String dayIndex;
  String periodList;
  int status;

  factory SellingTimeslot.fromMap(Map<String, dynamic> json) => SellingTimeslot(
    id: json["id"] == null ? null : json["id"],
    dayIndex: json["day_index"] == null ? null : json["day_index"],
    periodList: json["period_list"] == null ? null : json["period_list"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id ,
    "day_index": dayIndex ,
    "period_list": periodList,
    "status": status ,
  };
}

class Vendor {
  Vendor({
    required this.id,
    required this.image,
    required this.tax,
    required this.taxType,
    required this.name,
    required this.mapAddress,
    required this.forTwoPerson,
    required this.vendorType,
    required this.lat,
    required this.lang,
    required this.cuisineId,
    required this.contact,
    required this.cuisine,
    required this.rate,
    required this.review,
    required this.modifiers,
  });

  int id;
  String image;
  String tax;
  int? taxType;
  int modifiers;
  String name;
  String mapAddress;
  String forTwoPerson;
  String vendorType;
  String? lat;
  String? lang;
  String cuisineId;
  String? contact;

  List<Cuisine>? cuisine;
  int rate;
  int review;

  factory Vendor.fromMap(Map<String, dynamic> json) => Vendor(
    id: json["id"] == null ? null : json["id"],
    modifiers: json["modifiers"] == null ? null : json["modifiers"],
    image: json["image"] == null ? null : json["image"],
    tax: json["tax"] == null ? null : json["tax"],
    taxType: json["tax_type"] == null ? null : json["tax_type"],
    name: json["name"] == null ? null : json["name"],
    mapAddress: json["map_address"] == null ? null : json["map_address"],
    forTwoPerson: json["for_two_person"] == null ? null : json["for_two_person"],
    vendorType: json["vendor_type"] == null ? null : json["vendor_type"],
    lat: json["lat"] == null ? null : json["lat"],
    lang: json["lang"] == null ? null : json["lang"],
    cuisineId: json["cuisine_id"] == null ? null : json["cuisine_id"],
    contact: json["contact"] == null ? null : json["contact"],
    cuisine: json["cuisine"] == null ? null : List<Cuisine>.from(json["cuisine"].map((x) => Cuisine.fromMap(x))),
    rate: json["rate"] == null ? null : json["rate"],
    review: json["review"] == null ? null : json["review"],
  );

  Map<String, dynamic> toMap() => {
    "id": id ,
    "image": image,
    "tax": tax ,
    "tax_type": taxType == null ? null : taxType,
    "modifiers": modifiers,
    "name": name,
    "map_address": mapAddress ,
    "for_two_person": forTwoPerson,
    "vendor_type": vendorType ,
    "lat": lat == null ? null : lat,
    "lang": lang == null ? null : lang,
    "cuisine_id": cuisineId ,
    "contact": contact == null ? null : contact,
    "cuisine": cuisine == null ? null : List<dynamic>.from(cuisine!.map((x) => x.toMap())),
    "rate": rate ,
    "review": review ,
  };
}

class Cuisine {
  Cuisine({
    required this.name,
    required this.image,
  });

  String name;
  String image;

  factory Cuisine.fromMap(Map<String, dynamic> json) => Cuisine(
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
  );

  Map<String, dynamic> toMap() => {
    "name": name ,
    "image": image ,
  };
}
