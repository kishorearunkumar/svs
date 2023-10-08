// To parse this JSON data, do
//
//     final internetPlan = internetPlanFromJson(jsonString);

import 'dart:convert';

List<InternetPlan> internetPlanFromJson(String str) =>
    new List<InternetPlan>.from(
        json.decode(str).map((x) => InternetPlan.fromJson(x)));

String internetPlanToJson(List<InternetPlan> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class InternetPlan {
  String id;
  String planName;
  String planSpeed;
  String fup;
  String postFup;
  int validityDays;
  int planCost;
  int msoCost;
  bool activeStatus;
  String createdBy;
  String modifiedBy;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> created;
  List<Modified> modified;

  InternetPlan({
    this.id,
    this.planName,
    this.planSpeed,
    this.fup,
    this.postFup,
    this.validityDays,
    this.planCost,
    this.msoCost,
    this.activeStatus,
    this.createdBy,
    this.modifiedBy,
    this.createdAt,
    this.updatedAt,
    this.created,
    this.modified,
  });

  factory InternetPlan.fromJson(Map<String, dynamic> json) => new InternetPlan(
        id: json["id"] == null ? null : json["id"],
        planName: json["planName"] == null ? null : json["planName"],
        planSpeed: json["planSpeed"] == null ? null : json["planSpeed"],
        fup: json["fup"] == null ? null : json["fup"],
        postFup: json["postFup"] == null ? null : json["postFup"],
        validityDays:
            json["validityDays"] == null ? null : json["validityDays"],
        planCost: json["planCost"] == null ? null : json["planCost"],
        msoCost: json["msoCost"] == null ? null : json["msoCost"],
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
        created: json["Created"] == null
            ? null
            : new List<dynamic>.from(json["Created"].map((x) => x)),
        modified: json["Modified"] == null
            ? null
            : new List<Modified>.from(
                json["Modified"].map((x) => Modified.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "planName": planName == null ? null : planName,
        "planSpeed": planSpeed == null ? null : planSpeed,
        "fup": fup == null ? null : fup,
        "postFup": postFup == null ? null : postFup,
        "validityDays": validityDays == null ? null : validityDays,
        "planCost": planCost == null ? null : planCost,
        "msoCost": msoCost == null ? null : msoCost,
        "activeStatus": activeStatus == null ? null : activeStatus,
        "createdBy": createdBy == null ? null : createdBy,
        "modifiedBy": modifiedBy == null ? null : modifiedBy,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
        "Created": created == null
            ? null
            : new List<dynamic>.from(created.map((x) => x)),
        "Modified": modified == null
            ? null
            : new List<dynamic>.from(modified.map((x) => x.toJson())),
      };
}

class Modified {
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

  Modified({
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

  factory Modified.fromJson(Map<String, dynamic> json) => new Modified(
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
