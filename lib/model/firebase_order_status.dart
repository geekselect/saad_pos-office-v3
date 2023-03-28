
import 'dart:convert';

Map<String, FirebaseOrderStatus> firebaseOrderStatusFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, FirebaseOrderStatus>(k, FirebaseOrderStatus.fromJson(v)));

String firebaseOrderStatusToJson(Map<String, FirebaseOrderStatus> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class FirebaseOrderStatus {
  FirebaseOrderStatus({
    required this.status,
  });

  final String status;

  factory FirebaseOrderStatus.fromJson(Map<dynamic, dynamic> json) => FirebaseOrderStatus(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
