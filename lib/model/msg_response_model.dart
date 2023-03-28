import 'dart:convert';

MsgResModel msgResModelFromJson(String str) => MsgResModel.fromJson(json.decode(str));

String msgResModelToJson(MsgResModel data) => json.encode(data.toJson());

class MsgResModel {
  MsgResModel({
    required this.success,
    required this.msg,
  });

  final bool success;
  final String msg;

  factory MsgResModel.fromJson(Map<String, dynamic> json) => MsgResModel(
    success: json["success"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "msg": msg,
  };
}
