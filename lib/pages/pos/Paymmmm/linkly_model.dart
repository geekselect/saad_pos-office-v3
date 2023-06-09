// To parse this JSON data, do
//
//     final linklyModel = linklyModelFromJson(jsonString);

import 'dart:convert';

import 'package:pos/pages/pos/Core%20Payments/linkly_refund_response_model.dart';

LinklyModel linklyModelFromJson(String str) => LinklyModel.fromJson(json.decode(str));

String linklyModelToJson(LinklyModel data) => json.encode(data.toJson());

// class LinklyModel {
//   bool? success;
//   dynamic data;
//
//   LinklyModel({
//     this.success,
//     this.data,
//   });
//
//   factory LinklyModel.fromJson(Map<String, dynamic> json) => LinklyModel(
//     success: json["success"],
//     data: json["data"] is String
//         ? json["data"]
//         : DataLinkly.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "data": data is DataLinkly ? data.toJson() : data,
//   };
// }
//
// class DataLinkly {
//   int? id;
//   String? sessionId;
//   String? type;
//   RequestRefund? request;
//
//   DataLinkly({
//     this.id,
//     this.sessionId,
//     this.type,
//     this.request,
//   });
//
//   factory DataLinkly.fromJson(Map<String, dynamic> json) => DataLinkly(
//     id: json["id"],
//     sessionId: json["session_id"],
//     type: json["type"],
//     request: json["request"] == null ? null : RequestRefund.fromJson(json["request"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "session_id": sessionId,
//     "type": type,
//     "request": request?.toJson(),
//   };
// }

class LinklyModel {
  bool? success;
  dynamic data;

  LinklyModel({
    this.success,
    this.data,
  });

  factory LinklyModel.fromJson(Map<String, dynamic> json) => LinklyModel(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null
        ? null
        : json["data"] is String
        ? json["data"]
        : DataLinkly.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data is DataLinkly ? data.toJson() : data,
  };
}

class DataLinkly {
  int? id;
  String? sessionId;
  String? type;
  dynamic request;

  DataLinkly({
    this.id,
    this.sessionId,
    this.type,
    this.request,
  });

  factory DataLinkly.fromJson(Map<String, dynamic> json) {
    return DataLinkly(
      id: json["id"],
      sessionId: json["session_id"],
      type: json["type"],
      request: json["request"] == null ? null : RequestRefund.fromJson(json["request"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "session_id": sessionId,
    "type": type,
    "request": request?.toJson(),
  };
}



// class Request {
//   String? sessionId;
//   String? responseType;
//   Response? response;
//
//   Request({
//     this.sessionId,
//     this.responseType,
//     this.response,
//   });
//
//   factory Request.fromJson(Map<String, dynamic> json) => Request(
//     sessionId: json["SessionId"],
//     responseType: json["ResponseType"],
//     response: json["Response"] == null ? null : Response.fromJson(json["Response"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "SessionId": sessionId,
//     "ResponseType": responseType,
//     "Response": response?.toJson(),
//   };
// }
//
// class Response {
//   int? numberOfLines;
//   int? lineLength;
//   List<String?>? displayText;
//
//   Response({
//     this.numberOfLines,
//     this.lineLength,
//     this.displayText,
//   });
//
//   factory Response.fromJson(Map<String, dynamic> json) => Response(
//     numberOfLines: json["NumberOfLines"],
//     lineLength: json["LineLength"],
//     displayText: json["DisplayText"] == null ? [] : List<String?>.from(json["DisplayText"]!.map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "NumberOfLines": numberOfLines,
//     "LineLength": lineLength,
//     "DisplayText": displayText == null ? [] : List<dynamic>.from(displayText!.map((x) => x)),
//   };
// }
