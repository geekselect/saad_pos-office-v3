// To parse this JSON data, do
//
//     final linklyModel = linklyModelFromJson(jsonString);

import 'dart:convert';

LinklyModel linklyModelFromJson(String str) => LinklyModel.fromJson(json.decode(str));

String linklyModelToJson(LinklyModel data) => json.encode(data.toJson());

class LinklyModel {
  bool? success;
  Data? data;

  LinklyModel({
    this.success,
    this.data,
  });

  factory LinklyModel.fromJson(Map<String, dynamic> json) => LinklyModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? sessionId;
  String? type;
  Request? request;

  Data({
    this.id,
    this.sessionId,
    this.type,
    this.request,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    sessionId: json["session_id"],
    type: json["type"],
    request: json["request"] == null ? null : Request.fromJson(json["request"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "session_id": sessionId,
    "type": type,
    "request": request?.toJson(),
  };
}

class Request {
  String? sessionId;
  String? responseType;
  Response? response;

  Request({
    this.sessionId,
    this.responseType,
    this.response,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    sessionId: json["SessionId"],
    responseType: json["ResponseType"],
    response: json["Response"] == null ? null : Response.fromJson(json["Response"]),
  );

  Map<String, dynamic> toJson() => {
    "SessionId": sessionId,
    "ResponseType": responseType,
    "Response": response?.toJson(),
  };
}

class Response {
  int? numberOfLines;
  int? lineLength;
  List<String?>? displayText;

  Response({
    this.numberOfLines,
    this.lineLength,
    this.displayText,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    numberOfLines: json["NumberOfLines"],
    lineLength: json["LineLength"],
    displayText: json["DisplayText"] == null ? [] : List<String?>.from(json["DisplayText"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "NumberOfLines": numberOfLines,
    "LineLength": lineLength,
    "DisplayText": displayText == null ? [] : List<dynamic>.from(displayText!.map((x) => x)),
  };
}
