// To parse this JSON data, do
//
//     final linklyPurchaseResponseModel = linklyPurchaseResponseModelFromJson(jsonString);

import 'dart:convert';

LinklyPurchaseResponseModel linklyPurchaseResponseModelFromJson(String str) => LinklyPurchaseResponseModel.fromJson(json.decode(str));

String linklyPurchaseResponseModelToJson(LinklyPurchaseResponseModel data) => json.encode(data.toJson());

class LinklyPurchaseResponseModel {
  String? sessionId;
  String? responseType;
  Response? response;

  LinklyPurchaseResponseModel({
    this.sessionId,
    this.responseType,
    this.response,
  });

  factory LinklyPurchaseResponseModel.fromJson(Map<String, dynamic> json) => LinklyPurchaseResponseModel(
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
  String? txnType;
  String? merchant;
  String? cardType;
  String? cardName;
  String? rrn;
  DateTime? dateSettlement;
  int? amtCash;
  int? amtPurchase;
  int? amtTip;
  int? authCode;
  String? txnRef;
  String? pan;
  String? dateExpiry;
  String? track2;
  String? accountType;
  TxnFlags? txnFlags;
  bool? balanceReceived;
  int? availableBalance;
  int? clearedFundsBalance;
  bool? success;
  String? responseCode;
  String? responseText;
  DateTime? date;
  String? catid;
  String? caid;
  int? stan;
  PurchaseAnalysisData? purchaseAnalysisData;

  Response({
    this.txnType,
    this.merchant,
    this.cardType,
    this.cardName,
    this.rrn,
    this.dateSettlement,
    this.amtCash,
    this.amtPurchase,
    this.amtTip,
    this.authCode,
    this.txnRef,
    this.pan,
    this.dateExpiry,
    this.track2,
    this.accountType,
    this.txnFlags,
    this.balanceReceived,
    this.availableBalance,
    this.clearedFundsBalance,
    this.success,
    this.responseCode,
    this.responseText,
    this.date,
    this.catid,
    this.caid,
    this.stan,
    this.purchaseAnalysisData,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    txnType: json["TxnType"],
    merchant: json["Merchant"],
    cardType: json["CardType"],
    cardName: json["CardName"],
    rrn: json["RRN"],
    dateSettlement: json["DateSettlement"] == null ? null : DateTime.parse(json["DateSettlement"]),
    amtCash: json["AmtCash"],
    amtPurchase: json["AmtPurchase"],
    amtTip: json["AmtTip"],
    authCode: json["AuthCode"],
    txnRef: json["TxnRef"],
    pan: json["Pan"],
    dateExpiry: json["DateExpiry"],
    track2: json["Track2"],
    accountType: json["AccountType"],
    txnFlags: json["TxnFlags"] == null ? null : TxnFlags.fromJson(json["TxnFlags"]),
    balanceReceived: json["BalanceReceived"],
    availableBalance: json["AvailableBalance"],
    clearedFundsBalance: json["ClearedFundsBalance"],
    success: json["Success"],
    responseCode: json["ResponseCode"],
    responseText: json["ResponseText"],
    date: json["Date"] == null ? null : DateTime.parse(json["Date"]),
    catid: json["Catid"],
    caid: json["Caid"],
    stan: json["Stan"],
    purchaseAnalysisData: json["PurchaseAnalysisData"] == null ? null : PurchaseAnalysisData.fromJson(json["PurchaseAnalysisData"]),
  );

  Map<String, dynamic> toJson() => {
    "TxnType": txnType,
    "Merchant": merchant,
    "CardType": cardType,
    "CardName": cardName,
    "RRN": rrn,
    "DateSettlement": dateSettlement?.toIso8601String(),
    "AmtCash": amtCash,
    "AmtPurchase": amtPurchase,
    "AmtTip": amtTip,
    "AuthCode": authCode,
    "TxnRef": txnRef,
    "Pan": pan,
    "DateExpiry": dateExpiry,
    "Track2": track2,
    "AccountType": accountType,
    "TxnFlags": txnFlags?.toJson(),
    "BalanceReceived": balanceReceived,
    "AvailableBalance": availableBalance,
    "ClearedFundsBalance": clearedFundsBalance,
    "Success": success,
    "ResponseCode": responseCode,
    "ResponseText": responseText,
    "Date": date?.toIso8601String(),
    "Catid": catid,
    "Caid": caid,
    "Stan": stan,
    "PurchaseAnalysisData": purchaseAnalysisData?.toJson(),
  };
}

class PurchaseAnalysisData {
  String? rfn;
  String? ref;
  String? hrc;
  String? hrt;

  PurchaseAnalysisData({
    this.rfn,
    this.ref,
    this.hrc,
    this.hrt,
  });

  factory PurchaseAnalysisData.fromJson(Map<String, dynamic> json) => PurchaseAnalysisData(
    rfn: json["RFN"],
    ref: json["REF"],
    hrc: json["HRC"],
    hrt: json["HRT"],
  );

  Map<String, dynamic> toJson() => {
    "RFN": rfn,
    "REF": ref,
    "HRC": hrc,
    "HRT": hrt,
  };
}

class TxnFlags {
  String? offline;
  String? receiptPrinted;
  String? cardEntry;
  String? commsMethod;
  String? currency;
  String? payPass;
  String? undefinedFlag6;
  String? undefinedFlag7;

  TxnFlags({
    this.offline,
    this.receiptPrinted,
    this.cardEntry,
    this.commsMethod,
    this.currency,
    this.payPass,
    this.undefinedFlag6,
    this.undefinedFlag7,
  });

  factory TxnFlags.fromJson(Map<String, dynamic> json) => TxnFlags(
    offline: json["Offline"],
    receiptPrinted: json["ReceiptPrinted"],
    cardEntry: json["CardEntry"],
    commsMethod: json["CommsMethod"],
    currency: json["Currency"],
    payPass: json["PayPass"],
    undefinedFlag6: json["UndefinedFlag6"],
    undefinedFlag7: json["UndefinedFlag7"],
  );

  Map<String, dynamic> toJson() => {
    "Offline": offline,
    "ReceiptPrinted": receiptPrinted,
    "CardEntry": cardEntry,
    "CommsMethod": commsMethod,
    "Currency": currency,
    "PayPass": payPass,
    "UndefinedFlag6": undefinedFlag6,
    "UndefinedFlag7": undefinedFlag7,
  };
}
