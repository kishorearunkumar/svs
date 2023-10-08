// To parse this JSON data, do
//
//     final mso = msoFromJson(jsonString);

import 'dart:convert';

Mso msoFromJson(String str) {
    final jsonData = json.decode(str);
    return Mso.fromJson(jsonData);
}

List<Mso> msosFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<Mso>.from(jsonData.map((x) => Mso.fromJson(x)));
}

String msoToJson(Mso data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

String msosToJson(List<Mso> data) {
    final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
    return json.encode(dyn);
}

class Mso {
    String id;
    String msoName;
    String contactPerson;
    String phoneNumber;
    String officeNumber;
    String gst;
    String openingBalance;
    String balance;
    String emailId;
    String address;
    bool activeStatus;
    String createdBy;
    String modifiedBy;
    String createdAt;
    String updatedAt;
    List<Created> created;
    List<Created> modified;

    Mso({
        this.id,
        this.msoName,
        this.contactPerson,
        this.phoneNumber,
        this.officeNumber,
        this.gst,
        this.openingBalance,
        this.balance,
        this.emailId,
        this.address,
        this.activeStatus,
        this.createdBy,
        this.modifiedBy,
        this.createdAt,
        this.updatedAt,
        this.created,
        this.modified,
    });

    factory Mso.fromJson(Map<String, dynamic> json) => new Mso(
        id: json["id"] == null ? null : json["id"],
        msoName: json["msoName"] == null ? null : json["msoName"],
        contactPerson: json["contactPerson"] == null ? null : json["contactPerson"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        officeNumber: json["officeNumber"] == null ? null : json["officeNumber"],
        gst: json["gst"] == null ? null : json["gst"],
        openingBalance: json["openingBalance"] == null ? null : json["openingBalance"],
        balance: json["balance"] == null ? null : json["balance"],
        emailId: json["emailId"] == null ? null : json["emailId"],
        address: json["address"] == null ? null : json["address"],
        activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
        createdBy: json["createdBy"] == null ? null : json["createdBy"],
        modifiedBy: json["modifiedBy"] == null ? null : json["modifiedBy"],
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
        created: json["Created"] == null ? null : new List<Created>.from(json["Created"].map((x) => Created.fromJson(x))),
        modified: json["Modified"] == null ? null : new List<Created>.from(json["Modified"].map((x) => Created.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "msoName": msoName == null ? null : msoName,
        "contactPerson": contactPerson == null ? null : contactPerson,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "officeNumber": officeNumber == null ? null : officeNumber,
        "gst": gst == null ? null : gst,
        "openingBalance": openingBalance == null ? null : openingBalance,
        "balance": balance == null ? null : balance,
        "emailId": emailId == null ? null : emailId,
        "address": address == null ? null : address,
        "activeStatus": activeStatus == null ? null : activeStatus,
        "createdBy": createdBy == null ? null : createdBy,
        "modifiedBy": modifiedBy == null ? null : modifiedBy,
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
        "Created": created == null ? null : new List<dynamic>.from(created.map((x) => x.toJson())),
        "Modified": modified == null ? null : new List<dynamic>.from(modified.map((x) => x.toJson())),
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
    String lcoId;
    String wallet;
    bool activeStatus;
    String createdBy;
    String modifiedBy;
    String createdAt;
    String updatedAt;
    String lastLogin;
    String changedBy;
    String changedAt;

    Created({
        this.id,
        this.name,
        this.phoneNumber,
        this.emailId,
        this.userName,
        this.password,
        this.userType,
        this.operatorId,
        this.lcoId,
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
        lcoId: json["lcoID"] == null ? null : json["lcoID"],
        wallet: json["wallet"] == null ? null : json["wallet"],
        activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
        createdBy: json["createdBy"] == null ? null : json["createdBy"],
        modifiedBy: json["modifiedBy"] == null ? null : json["modifiedBy"],
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
        lastLogin: json["lastLogin"] == null ? null : json["lastLogin"],
        changedBy: json["changedBy"] == null ? null : json["changedBy"],
        changedAt: json["changedAt"] == null ? null : json["changedAt"],
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
        "lcoID": lcoId == null ? null : lcoId,
        "wallet": wallet == null ? null : wallet,
        "activeStatus": activeStatus == null ? null : activeStatus,
        "createdBy": createdBy == null ? null : createdBy,
        "modifiedBy": modifiedBy == null ? null : modifiedBy,
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
        "lastLogin": lastLogin == null ? null : lastLogin,
        "changedBy": changedBy == null ? null : changedBy,
        "changedAt": changedAt == null ? null : changedAt,
    };
}
