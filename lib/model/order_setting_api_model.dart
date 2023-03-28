class OrderSettingModel {
  bool? success;
  Data? data;

  OrderSettingModel({this.success, this.data});

  OrderSettingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? vendorId;
  int? freeDelivery;
  int? freeDeliveryDistance;
  int? freeDeliveryAmount;
  String? minOrderValue;
  String? orderAssignManually;
  String? orderRefresh;
  int? orderCommission;
  String? orderDashboardDefaultTime;
  String? vendorOrderMaxTime;
  String? driverOrderMaxTime;
  String? deliveryChargeType;
  String? charges;
  String? createdAt;
  String? updatedAt;
  double? distance;
  int? taxType;
  String? tax;
  int? resturantDiningStatus;
  int? totalTablesNumber;
  List<BookedTable>? bookedTable;

  Data(
      {this.id,
        this.vendorId,
        this.freeDelivery,
        this.freeDeliveryDistance,
        this.freeDeliveryAmount,
        this.minOrderValue,
        this.orderAssignManually,
        this.orderRefresh,
        this.orderCommission,
        this.orderDashboardDefaultTime,
        this.vendorOrderMaxTime,
        this.driverOrderMaxTime,
        this.deliveryChargeType,
        this.charges,
        this.createdAt,
        this.updatedAt,
        this.distance,
        this.taxType,
        this.tax,
        this.resturantDiningStatus,
        this.totalTablesNumber,
        this.bookedTable});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    freeDelivery = json['free_delivery'];
    freeDeliveryDistance = json['free_delivery_distance'];
    freeDeliveryAmount = json['free_delivery_amount'];
    minOrderValue = json['min_order_value'];
    orderAssignManually = json['order_assign_manually'];
    orderRefresh = json['orderRefresh'];
    orderCommission = json['order_commission'];
    orderDashboardDefaultTime = json['order_dashboard_default_time'];
    vendorOrderMaxTime = json['vendor_order_max_time'];
    driverOrderMaxTime = json['driver_order_max_time'];
    deliveryChargeType = json['delivery_charge_type'];
    charges = json['charges'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    distance = json['distance'];
    taxType = json['tax_type'];
    tax = json['tax'];
    resturantDiningStatus = json['resturant_dining_status'];
    totalTablesNumber = json['total_tables_number'];
    if (json['bookedTable'] != null) {
      bookedTable = <BookedTable>[];
      json['bookedTable'].forEach((v) {
        bookedTable!.add(new BookedTable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['free_delivery'] = this.freeDelivery;
    data['free_delivery_distance'] = this.freeDeliveryDistance;
    data['free_delivery_amount'] = this.freeDeliveryAmount;
    data['min_order_value'] = this.minOrderValue;
    data['order_assign_manually'] = this.orderAssignManually;
    data['orderRefresh'] = this.orderRefresh;
    data['order_commission'] = this.orderCommission;
    data['order_dashboard_default_time'] = this.orderDashboardDefaultTime;
    data['vendor_order_max_time'] = this.vendorOrderMaxTime;
    data['driver_order_max_time'] = this.driverOrderMaxTime;
    data['delivery_charge_type'] = this.deliveryChargeType;
    data['charges'] = this.charges;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['distance'] = this.distance;
    data['tax_type'] = this.taxType;
    data['tax'] = this.tax;
    data['resturant_dining_status'] = this.resturantDiningStatus;
    data['total_tables_number'] = this.totalTablesNumber;
    if (this.bookedTable != null) {
      data['bookedTable'] = this.bookedTable!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookedTable {
  int? id;
  int? vendorId;
  int? bookedTableNumber;
  int? status;
  String? createdAt;
  String? updatedAt;

  BookedTable(
      {this.id,
        this.vendorId,
        this.bookedTableNumber,
        this.status,
        this.createdAt,
        this.updatedAt});

  BookedTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    bookedTableNumber = json['booked_table_number'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['booked_table_number'] = this.bookedTableNumber;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
