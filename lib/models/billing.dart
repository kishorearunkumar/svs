// To parse this JSON data, do
//
//     final billing = billingFromJson(jsonString);

import 'dart:convert';
import 'package:svs/models/customer.dart';

List<Billing> billingFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Billing>.from(jsonData.map((x) => Billing.fromJson(x)));
}

String billingToJson(List<Billing> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

Billing billingsFromJson(String str) => Billing.fromJson(json.decode(str));

class Billing {
  String id;
  String billId;
  String customerId;
  String sortCustomerId;
  String outstandingAmount;
  String monthlyRent;
  String discountAmount;
  String billAmount;
  String billFor;
  String paidStatus;
  Customer customerData;
  String modifiedBy;
  String createdAt;
  String sortCreatedAt;
  String updatedAt;
  String lcoId;

  Billing({
    this.id,
    this.billId,
    this.customerId,
    this.sortCustomerId,
    this.outstandingAmount,
    this.monthlyRent,
    this.discountAmount,
    this.billAmount,
    this.billFor,
    this.customerData,
    this.modifiedBy,
    this.createdAt,
    this.sortCreatedAt,
    this.updatedAt,
    this.paidStatus,
    this.lcoId,
  });

  factory Billing.fromJson(Map<String, dynamic> json) => new Billing(
        id: json["id"] == null ? null : json["id"],
        billId: json["billId"] == null ? null : json["billId"],
        customerId: json["customerId"] == null ? null : json["customerId"],
        outstandingAmount: json["outstandingAmount"] == null
            ? null
            : json["outstandingAmount"],
        monthlyRent: json["monthlyRent"] == null ? null : json["monthlyRent"],
        discountAmount:
            json["discountAmount"] == null ? null : json["discountAmount"],
        billAmount: json["billAmount"] == null ? null : json["billAmount"],
        billFor: json["billFor"] == null ? null : json["billFor"],
        paidStatus: json["paidStatus"] == null ? 'Unpaid' : json["paidStatus"],
        customerData: json["customerData"] == null
            ? null
            : Customer.fromJson(json["customerData"]),
        modifiedBy: json["modifiedBy"] == null ? null : json["modifiedBy"],
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
        lcoId: json["lcoID"] == null ? null : json["lcoID"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "billId": billId == null ? null : billId,
        "customerId": customerId == null ? null : customerId,
        "outstandingAmount":
            outstandingAmount == null ? null : outstandingAmount,
        "monthlyRent": monthlyRent == null ? null : monthlyRent,
        "discountAmount": discountAmount == null ? null : discountAmount,
        "billAmount": billAmount == null ? null : billAmount,
        "billFor": billFor == null ? null : billFor,
        "paidStatus": paidStatus == null ? null : paidStatus,
        "customerData": customerData == null ? null : customerData,
        "modifiedBy": modifiedBy == null ? null : modifiedBy,
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
        "lcoID": lcoId == null ? null : lcoId,
      };
}
