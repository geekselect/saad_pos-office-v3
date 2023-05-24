import 'dart:convert';

MsgResModel msgResModelFromJson(String str) => MsgResModel.fromJson(json.decode(str));

String msgResModelToJson(MsgResModel data) => json.encode(data.toJson());

class MsgResModel {
  MsgResModel({
    required this.success,
    required this.msg,
    required this.shiftTimer,
  });

  final bool success;
  final String msg;
  final String? shiftTimer;

  factory MsgResModel.fromJson(Map<String, dynamic> json) => MsgResModel(
    success: json["success"],
    shiftTimer: json["shift_timer"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "msg": msg,
    "shift_timer": shiftTimer,
  };
}
