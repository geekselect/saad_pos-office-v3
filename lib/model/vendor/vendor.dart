class Vendor {
  bool? success;
  Data? data;

  Vendor({
    this.success,
    this.data,
  });

  Vendor.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool?;
    data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['success'] = success;
    json['data'] = data?.toJson();
    return json;
  }
}

class Data {
  int? id;
  String? name;
  String? image;
  String? emailId;
  dynamic emailVerifiedAt;
  String? deviceToken;
  dynamic phone;
  dynamic phoneCode;
  int? isVerified;
  int? status;
  dynamic otp;
  dynamic faviroute;
  dynamic vendorId;
  dynamic language;
  dynamic ifscCode;
  dynamic accountName;
  dynamic accountNumber;
  dynamic micrCode;
  dynamic providerType;
  dynamic providerToken;
  String? createdAt;
  String? updatedAt;
  String? token;
  int? vendorOwnDriver;
  List<Roles>? roles;

  Data({
    this.id,
    this.name,
    this.image,
    this.emailId,
    this.emailVerifiedAt,
    this.deviceToken,
    this.phone,
    this.phoneCode,
    this.isVerified,
    this.status,
    this.otp,
    this.faviroute,
    this.vendorId,
    this.language,
    this.ifscCode,
    this.accountName,
    this.accountNumber,
    this.micrCode,
    this.providerType,
    this.providerToken,
    this.createdAt,
    this.updatedAt,
    this.token,
    this.vendorOwnDriver,
    this.roles,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    image = json['image'] as String?;
    emailId = json['email_id'] as String?;
    emailVerifiedAt = json['email_verified_at'];
    deviceToken = json['device_token'] as String?;
    phone = json['phone'];
    phoneCode = json['phone_code'];
    isVerified = json['is_verified'] as int?;
    status = json['status'] as int?;
    otp = json['otp'];
    faviroute = json['faviroute'];
    vendorId = json['vendor_id'];
    language = json['language'];
    ifscCode = json['ifsc_code'];
    accountName = json['account_name'];
    accountNumber = json['account_number'];
    micrCode = json['micr_code'];
    providerType = json['provider_type'];
    providerToken = json['provider_token'];
    createdAt = json['created_at'] as String?;
    updatedAt = json['updated_at'] as String?;
    token = json['token'] as String?;
    vendorOwnDriver = json['vendor_own_driver'] as int?;
    roles = (json['roles'] as List?)?.map((dynamic e) => Roles.fromJson(e as Map<String,dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['image'] = image;
    json['email_id'] = emailId;
    json['email_verified_at'] = emailVerifiedAt;
    json['device_token'] = deviceToken;
    json['phone'] = phone;
    json['phone_code'] = phoneCode;
    json['is_verified'] = isVerified;
    json['status'] = status;
    json['otp'] = otp;
    json['faviroute'] = faviroute;
    json['vendor_id'] = vendorId;
    json['language'] = language;
    json['ifsc_code'] = ifscCode;
    json['account_name'] = accountName;
    json['account_number'] = accountNumber;
    json['micr_code'] = micrCode;
    json['provider_type'] = providerType;
    json['provider_token'] = providerToken;
    json['created_at'] = createdAt;
    json['updated_at'] = updatedAt;
    json['token'] = token;
    json['vendor_own_driver'] = vendorOwnDriver;
    json['roles'] = roles?.map((e) => e.toJson()).toList();
    return json;
  }
}

class Roles {
  int? id;
  String? title;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Roles({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    title = json['title'] as String?;
    createdAt = json['created_at'] as String?;
    updatedAt = json['updated_at'] as String?;
    pivot = (json['pivot'] as Map<String,dynamic>?) != null ? Pivot.fromJson(json['pivot'] as Map<String,dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['title'] = title;
    json['created_at'] = createdAt;
    json['updated_at'] = updatedAt;
    json['pivot'] = pivot?.toJson();
    return json;
  }
}

class Pivot {
  int? userId;
  int? roleId;

  Pivot({
    this.userId,
    this.roleId,
  });

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] as int?;
    roleId = json['role_id'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['user_id'] = userId;
    json['role_id'] = roleId;
    return json;
  }
}