import 'dart:convert';

LinklyRefundResponseModel linklyRefundResponseModelFromJson(String str) => LinklyRefundResponseModel.fromJson(json.decode(str));

String linklyRefundResponseModelToJson(LinklyRefundResponseModel data) => json.encode(data.toJson());

class LinklyRefundResponseModel {
  bool? success;
  dynamic data;

  LinklyRefundResponseModel({
    this.success,
    this.data,
  });

  factory LinklyRefundResponseModel.fromJson(Map<String, dynamic> json) {
    return LinklyRefundResponseModel(
      success: json["success"],
      data: json["data"] is String ? json["data"] : DataRefundLinkly.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data is DataRefundLinkly ? data.toJson() : data,
  };
}

class DataRefundLinkly {
  dynamic id;
  dynamic sessionId;
  dynamic type;
  RequestRefund? request;

  DataRefundLinkly({
    this.id,
    this.sessionId,
    this.type,
    this.request,
  });

  factory DataRefundLinkly.fromJson(Map<String, dynamic> json) {
    return DataRefundLinkly(
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

class RequestRefund {
  dynamic sessionId;
  dynamic responseType;
  dynamic response;

  RequestRefund({
    this.sessionId,
    this.responseType,
    this.response,
  });

  // factory RequestRefund.fromJson(Map<String, dynamic> json) {
  //   return RequestRefund(
  //     sessionId: json["SessionId"],
  //     responseType: json["ResponseType"],
  //     response: json["Response"] == null
  //         ? null
  //         : json["ResponseType"] == "display"
  //         ? AboveResponse.fromJson(json["Response"])
  //         : BeneathResponse.fromJson(json["Response"]),
  //   );
  // }

  factory RequestRefund.fromJson(Map<String, dynamic> json) {
    dynamic responseJson = json["Response"];

    if (responseJson != null) {
      if (responseJson is Map<String, dynamic> && responseJson.containsKey("DisplayText")) {
        return RequestRefund(
          sessionId: json["SessionId"],
          response:  AboveResponse.fromJson(responseJson),
        );
      }
      else{
        return RequestRefund(
          sessionId: json["SessionId"],
          response: BeneathResponse.fromJson(responseJson),
        );
      }
    }

    return RequestRefund(
      sessionId: json["SessionId"],
      response: null,
    );
  }



  // factory RequestRefund.fromJson(Map<String, dynamic> json) {
  //   // if (json["ResponseType"] == "display" &&
  //   //     json["Response"]["DisplayText"][0] == "TRANSACTION DECLINED") {
  //   //   return RequestRefund(
  //   //     sessionId: json["SessionId"],
  //   //     responseType: json["ResponseType"],
  //   //     response: BeneathResponse.fromJson(json["Response"]),
  //   //   );
  //   // } else {
  //     return RequestRefund(
  //       sessionId: json["SessionId"],
  //       responseType: json["ResponseType"],
  //       response: json["ResponseType"] == "display"
  //           ?  AboveResponse.fromJson(json["Response"])
  //           : BeneathResponse.fromJson(json["Response"]),
  //     );
  //   // }
  // }

  ///
  // factory RequestRefund.fromJson(Map<String, dynamic> json) {
  //   if (json["ResponseType"] == "display" ){
  //     if(json["Response"]["DisplayText"][0] == "TRANSACTION DECLINED") {
  //       return RequestRefund(
  //         sessionId: json["SessionId"],
  //         responseType: json["ResponseType"],
  //         response: AboveResponse.fromJson(json["Response"]),
  //       );
  //     } else {
  //       return RequestRefund(
  //         sessionId: json["SessionId"],
  //         responseType: json["ResponseType"],
  //         response: BeneathResponse.fromJson(json["Response"]),
  //       );
  //     }
  //   } else {
  //     return RequestRefund(
  //       sessionId: json["SessionId"],
  //       responseType: json["ResponseType"],
  //       response: BeneathResponse.fromJson(json["Response"]),
  //     );
  //   }
  // // Return null if the condition is not met
  // }

  Map<String, dynamic> toJson() {
    return {
      "SessionId": sessionId,
      "ResponseType": responseType,
      "Response": response?.toJson(),
    };
  }
}

class AboveResponse {
  dynamic numberOfLines;
  dynamic lineLength;
  List<String?>? displayText;
  bool? cancelKeyFlag;
  bool? acceptYesKeyFlag;
  bool? declineNoKeyFlag;
  bool? authoriseKeyFlag;
  bool? okKeyFlag;
  dynamic inputType;
  dynamic graphicCode;
  List<dynamic>? purchaseAnalysisData;
  dynamic responseType;

  AboveResponse({
    this.numberOfLines,
    this.lineLength,
    this.displayText,
    this.cancelKeyFlag,
    this.acceptYesKeyFlag,
    this.declineNoKeyFlag,
    this.authoriseKeyFlag,
    this.okKeyFlag,
    this.inputType,
    this.graphicCode,
    this.purchaseAnalysisData,
    this.responseType,
  });

  factory AboveResponse.fromJson(Map<String, dynamic> json) {
    return AboveResponse(
      numberOfLines: json["NumberOfLines"],
      lineLength: json["LineLength"],
      displayText: List<String?>.from(json["DisplayText"].map((x) => x)),
      cancelKeyFlag: json["CancelKeyFlag"],
      acceptYesKeyFlag: json["AcceptYesKeyFlag"],
      declineNoKeyFlag: json["DeclineNoKeyFlag"],
      authoriseKeyFlag: json["AuthoriseKeyFlag"],
      okKeyFlag: json["OKKeyFlag"],
      inputType: json["InputType"],
      graphicCode: json["GraphicCode"],
      purchaseAnalysisData: List<dynamic>.from(json["PurchaseAnalysisData"].map((x) => x)),
      responseType: json["ResponseType"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "NumberOfLines": numberOfLines,
      "LineLength": lineLength,
      "DisplayText": List<dynamic>.from(displayText!.map((x) => x)),
      "CancelKeyFlag": cancelKeyFlag,
      "AcceptYesKeyFlag": acceptYesKeyFlag,
      "DeclineNoKeyFlag": declineNoKeyFlag,
      "AuthoriseKeyFlag": authoriseKeyFlag,
      "OKKeyFlag": okKeyFlag,
      "InputType": inputType,
      "GraphicCode": graphicCode,
      "PurchaseAnalysisData": List<dynamic>.from(purchaseAnalysisData!.map((x) => x)),
      "ResponseType": responseType,
    };
  }
}

class BeneathResponse {
  dynamic txnType;
  dynamic merchant;
  dynamic cardType;
  dynamic cardName;
  dynamic rrn;
  DateTime? dateSettlement;
  double? amtCash;
  double? amtPurchase;
  double? amtTip;
  dynamic authCode;
  dynamic txnRef;
  dynamic pan;
  dynamic dateExpiry;
  dynamic track2;
  dynamic accountType;
  Map<String, dynamic>? txnFlags;
  bool? balanceReceived;
  double? availableBalance;
  double? clearedFundsBalance;
  bool? success;
  dynamic responseCode;
  dynamic responseText;
  DateTime? date;
  dynamic catid;
  dynamic caid;
  dynamic stan;
  List<dynamic>? purchaseAnalysisData;
  List<Map<String, dynamic>>? receipts;
  dynamic responseType;

  BeneathResponse({
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
    this.receipts,
    this.responseType,
  });

  factory BeneathResponse.fromJson(Map<String, dynamic> json) {
    return BeneathResponse(
      txnType: json["TxnType"],
      merchant: json["Merchant"],
      cardType: json["CardType"],
      cardName: json["CardName"],
      rrn: json["RRN"] == null ? null : json["RRN"],
      dateSettlement: json["DateSettlement"] != null ? DateTime.tryParse(json["DateSettlement"]) : null,
      amtCash: json["AmtCash"],
      amtPurchase: json["AmtPurchase"],
      amtTip: json["AmtTip"],
      authCode: json["AuthCode"],
      txnRef: json["TxnRef"],
      pan: json["Pan"],
      dateExpiry: json["DateExpiry"],
      track2: json["Track2"],
      accountType: json["AccountType"],
      txnFlags: json["TxnFlags"],
      balanceReceived: json["BalanceReceived"],
      availableBalance: json["AvailableBalance"],
      clearedFundsBalance: json["ClearedFundsBalance"],
      success: json["Success"],
      responseCode: json["ResponseCode"],
      responseText: json["ResponseText"],
      date: json["Date"] != null ? DateTime.tryParse(json["Date"]) : null,
      catid: json["Catid"],
      caid: json["Caid"],
      stan: json["Stan"],
      // purchaseAnalysisData: List<dynamic>.from(json["PurchaseAnalysisData"].map((x) => x)),
      // receipts: List<Map<String, dynamic>>.from(json["Receipts"].map((x) => x)),
      purchaseAnalysisData: List<dynamic>.from(json["PurchaseAnalysisData"].map((x) => x)),
      receipts: json["Receipts"] == null ? null : List<Map<String, dynamic>>.from(json["Receipts"].map((x) => Map<String, dynamic>.from(x))),
      responseType: json["ResponseType"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "TxnType": txnType,
      "Merchant": merchant,
      "CardType": cardType,
      "CardName": cardName,
      "RRN": rrn,
      "DateSettlement": dateSettlement!.toIso8601String(),
      "AmtCash": amtCash,
      "AmtPurchase": amtPurchase,
      "AmtTip": amtTip,
      "AuthCode": authCode,
      "TxnRef": txnRef,
      "Pan": pan,
      "DateExpiry": dateExpiry,
      "Track2": track2,
      "AccountType": accountType,
      "TxnFlags": txnFlags,
      "BalanceReceived": balanceReceived,
      "AvailableBalance": availableBalance,
      "ClearedFundsBalance": clearedFundsBalance,
      "Success": success,
      "ResponseCode": responseCode,
      "ResponseText": responseText,
      "Date": date!.toIso8601String(),
      "Catid": catid,
      "Caid": caid,
      "Stan": stan,
      "PurchaseAnalysisData": List<dynamic>.from(purchaseAnalysisData!.map((x) => x)),
      "Receipts": List<dynamic>.from(receipts!.map((x) => x)),
      "ResponseType": responseType,
    };
  }
}

class RecieptModel {
  String? type;
  List<String?>? receiptText;
  bool? isPrePrint;
  String? responseType;

  RecieptModel({
    this.type,
    this.receiptText,
    this.isPrePrint,
    this.responseType,
  });

  factory RecieptModel.fromJson(Map<String, dynamic> json) => RecieptModel(
    type: json["Type"],
    receiptText: json["ReceiptText"] == null ? [] : List<String?>.from(json["ReceiptText"]!.map((x) => x)),
    isPrePrint: json["IsPrePrint"],
    responseType: json["ResponseType"],
  );

  Map<String, dynamic> toJson() => {
    "Type": type,
    "ReceiptText": receiptText == null ? [] : List<dynamic>.from(receiptText!.map((x) => x)),
    "IsPrePrint": isPrePrint,
    "ResponseType": responseType,
  };
}


