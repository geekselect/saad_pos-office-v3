class CommonMsgModel {
  bool? success;
  String? message;

  CommonMsgModel({this.success, this.message});

  CommonMsgModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> message =  Map<String, dynamic>();
    message['success'] = this.success;
    message['message'] = this.message;
    return message;
  }
}