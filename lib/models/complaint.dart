// To parse this JSON data, do
//
//     final complaint = complaintFromJson(jsonString);

import 'dart:convert';
import 'package:svs/models/customer.dart';

List<Complaint> complaintsFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Complaint>.from(jsonData.map((x) => Complaint.fromJson(x)));
}

Complaint complaintFromJson(String str) {
  final jsonData = json.decode(str);
  return new Complaint.fromJson(jsonData);
}

String complaintToJson(Complaint data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Complaint {
  String id;
  String complaintId;
  String customerId;
  String sortCustomerId;
  Customer customerData;
  String complaintPriority;
  String complaintDetail;
  String complaintRemarks;
  String complaintFrom;
  String complaintFor;
  String assignedTo;
  List<Assigned> assigned;
  String complaintStatus;
  String createdBy;
  String modifiedBy;
  String createdAt;
  String sortCreatedAt;
  String updatedAt;
  List<Assigned> created;
  List<Assigned> modified;
  List<Assigned> closed;
  String closedBy;
  String closedAt;

  Complaint({
    this.id,
    this.complaintId,
    this.customerId,
    this.sortCustomerId,
    this.customerData,
    this.complaintPriority,
    this.complaintDetail,
    this.complaintRemarks,
    this.complaintFrom,
    this.complaintFor,
    this.assignedTo,
    this.assigned,
    this.complaintStatus,
    this.createdBy,
    this.modifiedBy,
    this.createdAt,
    this.sortCreatedAt,
    this.updatedAt,
    this.created,
    this.modified,
    this.closed,
    this.closedBy,
    this.closedAt,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) => new Complaint(
        id: json["id"] == null ? null : json["id"],
        complaintId: json["complaintId"] == null ? null : json["complaintId"],
        customerId: json["customerId"] == null ? null : json["customerId"],
        customerData: json["customerData"] == null
            ? null
            : Customer.fromJson(json["customerData"]),
        complaintPriority: json["complaintPriority"] == null
            ? null
            : json["complaintPriority"],
        complaintDetail:
            json["complaintDetail"] == null ? null : json["complaintDetail"],
        complaintRemarks:
            json["complaintRemarks"] == null ? null : json["complaintRemarks"],
        complaintFrom:
            json["complaintFrom"] == null ? null : json["complaintFrom"],
        complaintFor:
            json["complaintFor"] == null ? null : json["complaintFor"],
        assignedTo: json["assignedTo"] == null ? null : json["assignedTo"],
        assigned: json["Assigned"] == null
            ? null
            : new List<Assigned>.from(
                json["Assigned"].map((x) => Assigned.fromJson(x))),
        complaintStatus:
            json["complaintStatus"] == null ? null : json["complaintStatus"],
        createdBy: json["createdBy"] == null ? null : json["createdBy"],
        modifiedBy: json["modifiedBy"] == null ? null : json["modifiedBy"],
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
        created: json["Created"] == null
            ? null
            : new List<Assigned>.from(
                json["Created"].map((x) => Assigned.fromJson(x))),
        modified: json["Modified"] == null
            ? null
            : new List<Assigned>.from(
                json["Modified"].map((x) => Assigned.fromJson(x))),
        closed: json["Closed"] == null
            ? null
            : new List<Assigned>.from(
                json["Closed"].map((x) => Assigned.fromJson(x))),
        closedBy: json["closedBy"] == null ? null : json["closedBy"],
        closedAt: json["closedAt"] == null ? null : json["closedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "complaintId": complaintId == null ? null : complaintId,
        "customerId": customerId == null ? null : customerId,
        "customerData": customerData == null ? null : customerData,
        "complaintPriority":
            complaintPriority == null ? null : complaintPriority,
        "complaintDetail": complaintDetail == null ? null : complaintDetail,
        "complaintRemarks": complaintRemarks == null ? null : complaintRemarks,
        "complaintFrom": complaintFrom == null ? null : complaintFrom,
        "complaintFor": complaintFor == null ? null : complaintFor,
        "assignedTo": assignedTo == null ? null : assignedTo,
        "Assigned": assigned == null
            ? null
            : new List<dynamic>.from(assigned.map((x) => x.toJson())),
        "complaintStatus": complaintStatus == null ? null : complaintStatus,
        "createdBy": createdBy == null ? null : createdBy,
        "modifiedBy": modifiedBy == null ? null : modifiedBy,
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
        "Created": created == null
            ? null
            : new List<dynamic>.from(created.map((x) => x.toJson())),
        "Modified": modified == null
            ? null
            : new List<dynamic>.from(modified.map((x) => x.toJson())),
        "Closed": closed == null
            ? null
            : new List<dynamic>.from(closed.map((x) => x.toJson())),
        "closedBy": closedBy == null ? null : closedBy,
        "closedAt": closedAt == null ? null : closedAt,
      };
}

class Assigned {
  String id;
  String name;
  String phoneNumber;
  String emailId;
  String userName;
  String userType;
  bool activeStatus;

  Assigned({
    this.id,
    this.name,
    this.phoneNumber,
    this.emailId,
    this.userName,
    this.userType,
    this.activeStatus,
  });

  factory Assigned.fromJson(Map<String, dynamic> json) => new Assigned(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        emailId: json["emailID"] == null ? null : json["emailID"],
        userName: json["userName"] == null ? null : json["userName"],
        userType: json["userType"] == null ? null : json["userType"],
        activeStatus:
            json["activeStatus"] == null ? null : json["activeStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "emailID": emailId == null ? null : emailId,
        "userName": userName == null ? null : userName,
        "userType": userType == null ? null : userType,
        "activeStatus": activeStatus == null ? null : activeStatus,
      };
}
