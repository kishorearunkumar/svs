// To parse this JSON data, do
//
//     final general = generalFromJson(jsonString);

import 'dart:convert';

General generalFromJson(String str) {
  final jsonData = json.decode(str);
  return General.fromJson(jsonData);
}

List<General> generalsFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<General>.from(jsonData.map((x) => General.fromJson(x)));
}

String generalToJson(General data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class General {
  String id;
  String lcoName;
  String phoneNumber;
  String alternateNumber;
  String emailId;
  String address;
  String operatorLogo;

  General({
    this.id,
    this.lcoName,
    this.phoneNumber,
    this.alternateNumber,
    this.emailId,
    this.address,
    this.operatorLogo,
  });

  factory General.fromJson(Map<String, dynamic> json) => new General(
        id: json["id"] == null ? null : json["id"],
        lcoName: json["lcoName"] == null ? null : json["lcoName"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        alternateNumber:
            json["alternateNumber"] == null ? null : json["alternateNumber"],
        emailId: json["emailId"] == null ? null : json["emailId"],
        address: json["address"] == null ? null : json["address"],
        operatorLogo:
            json["operatorLogo"] == null ? null : json["operatorLogo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "lcoName": lcoName == null ? null : lcoName,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "alternateNumber": alternateNumber == null ? null : alternateNumber,
        "emailId": emailId == null ? null : emailId,
        "address": address == null ? null : address,
        "operatorLogo": operatorLogo == null ? null : operatorLogo,
      };
}
