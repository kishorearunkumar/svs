// To parse this JSON data, do
//
//     final internetBilling = internetBillingFromJson(jsonString);

import 'dart:convert';

InternetBilling internetBillingFromJson(String str) =>
    InternetBilling.fromJson(json.decode(str));

String internetBillingToJson(InternetBilling data) =>
    json.encode(data.toJson());

class InternetBilling {
  String customerId;
  String plan;
  String activationDate;
  String expiryDate;
  String amount;
  bool payment;

  InternetBilling({
    this.customerId,
    this.plan,
    this.activationDate,
    this.expiryDate,
    this.amount,
    this.payment,
  });

  factory InternetBilling.fromJson(Map<String, dynamic> json) =>
      new InternetBilling(
        customerId: json["customerId"] == null ? null : json["customerId"],
        plan: json["plan"] == null ? null : json["plan"],
        activationDate:
            json["activationDate"] == null ? null : json["activationDate"],
        expiryDate: json["expiryDate"] == null ? null : json["expiryDate"],
        amount: json["amount"] == null ? null : json["amount"],
        payment: json["payment"] == null ? null : json["payment"],
      );

  Map<String, dynamic> toJson() => {
        "customerId": customerId == null ? null : customerId,
        "plan": plan == null ? null : plan,
        "activationDate": activationDate == null ? null : activationDate,
        "expiryDate": expiryDate == null ? null : expiryDate,
        "amount": amount == null ? null : amount,
        "payment": payment == null ? null : payment,
      };
}
