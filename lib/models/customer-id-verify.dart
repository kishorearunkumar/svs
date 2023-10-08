// To parse this JSON data, do
//
//     final customerIdVerify = customerIdVerifyFromJson(jsonString);

import 'dart:convert';

List<CustomerIdVerify> customerIdVerifyFromJson(String str) =>
    List<CustomerIdVerify>.from(
        json.decode(str).map((x) => CustomerIdVerify.fromJson(x)));

String customerIdVerifyToJson(List<CustomerIdVerify> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerIdVerify {
  String customerId;

  CustomerIdVerify({
    this.customerId,
  });

  factory CustomerIdVerify.fromJson(Map<String, dynamic> json) =>
      CustomerIdVerify(
        customerId: json["customerId"] == null ? null : json["customerId"],
      );

  Map<String, dynamic> toJson() => {
        "customerId": customerId == null ? null : customerId,
      };
}
