class CommenRes {
  bool? success;
  String? data;
  dynamic order_id;

  CommenRes({this.success, this.data, this.order_id});

  CommenRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    order_id = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    data['order_id'] = this.order_id;
    return data;
  }
}

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
