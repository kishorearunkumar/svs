// To parse this JSON data, do
//
//     final internetBillingSetting = internetBillingSettingFromJson(jsonString);

import 'dart:convert';

List<InternetBillingSetting> internetBillingSettingFromJson(String str) =>
    new List<InternetBillingSetting>.from(
        json.decode(str).map((x) => InternetBillingSetting.fromJson(x)));

String internetBillingSettingToJson(List<InternetBillingSetting> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class InternetBillingSetting {
  String id;
  String billingType;
  int generationDate;
  int deactivateAt;
  String createdBy;
  String modifiedBy;
  DateTime createdAt;
  DateTime updatedAt;
  List<Created> created;
  List<Created> modified;

  InternetBillingSetting({
    this.id,
    this.billingType,
    this.generationDate,
    this.deactivateAt,
    this.createdBy,
    this.modifiedBy,
    this.createdAt,
    this.updatedAt,
    this.created,
    this.modified,
  });

  factory InternetBillingSetting.fromJson(Map<String, dynamic> json) =>
      new InternetBillingSetting(
        id: json["id"] == null ? null : json["id"],
        billingType: json["billingType"] == null ? null : json["billingType"],
        generationDate:
            json["generationDate"] == null ? null : json["generationDate"],
        deactivateAt:
            json["deactivateAt"] == null ? null : json["deactivateAt"],
        createdBy: json["createdBy"] == null ? null : json["createdBy"],
        modifiedBy: json["modifiedBy"] == null ? null : json["modifiedBy"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        created: json["Created"] == null
            ? null
            : new List<Created>.from(
                json["Created"].map((x) => Created.fromJson(x))),
        modified: json["Modified"] == null
            ? null
            : new List<Created>.from(
                json["Modified"].map((x) => Created.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "billingType": billingType == null ? null : billingType,
        "generationDate": generationDate == null ? null : generationDate,
        "deactivateAt": deactivateAt == null ? null : deactivateAt,
        "createdBy": createdBy == null ? null : createdBy,
        "modifiedBy": modifiedBy == null ? null : modifiedBy,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "Created": created == null
            ? null
            : new List<dynamic>.from(created.map((x) => x.toJson())),
        "Modified": modified == null
            ? null
            : new List<dynamic>.from(modified.map((x) => x.toJson())),
      };
}

class Created {
  String id;
  String name;
  String phoneNumber;
  String emailId;
  String userName;
  String password;
  String userType;
  String operatorId;
  String wallet;
  bool activeStatus;
  String createdBy;
  String modifiedBy;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime lastLogin;
  String changedBy;
  DateTime changedAt;

  Created({
    this.id,
    this.name,
    this.phoneNumber,
    this.emailId,
    this.userName,
    this.password,
    this.userType,
    this.operatorId,
    this.wallet,
    this.activeStatus,
    this.createdBy,
    this.modifiedBy,
    this.createdAt,
    this.updatedAt,
    this.lastLogin,
    this.changedBy,
    this.changedAt,
  });

  factory Created.fromJson(Map<String, dynamic> json) => new Created(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        emailId: json["emailID"] == null ? null : json["emailID"],
        userName: json["userName"] == null ? null : json["userName"],
        password: json["password"] == null ? null : json["password"],
        userType: json["userType"] == null ? null : json["userType"],
        operatorId: json["operatorID"] == null ? null : json["operatorID"],
        wallet: json["wallet"] == null ? null : json["wallet"],
        activeStatus:
            json["activeStatus"] == null ? null : json["activeStatus"],
        createdBy: json["createdBy"] == null ? null : json["createdBy"],
        modifiedBy: json["modifiedBy"] == null ? null : json["modifiedBy"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        lastLogin: json["lastLogin"] == null
            ? null
            : DateTime.parse(json["lastLogin"]),
        changedBy: json["changedBy"] == null ? null : json["changedBy"],
        changedAt: json["changedAt"] == null
            ? null
            : DateTime.parse(json["changedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "emailID": emailId == null ? null : emailId,
        "userName": userName == null ? null : userName,
        "password": password == null ? null : password,
        "userType": userType == null ? null : userType,
        "operatorID": operatorId == null ? null : operatorId,
        "wallet": wallet == null ? null : wallet,
        "activeStatus": activeStatus == null ? null : activeStatus,
        "createdBy": createdBy == null ? null : createdBy,
        "modifiedBy": modifiedBy == null ? null : modifiedBy,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "lastLogin": lastLogin == null ? null : lastLogin.toIso8601String(),
        "changedBy": changedBy == null ? null : changedBy,
        "changedAt": changedAt == null ? null : changedAt.toIso8601String(),
      };
}
