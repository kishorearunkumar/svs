// To parse this JSON data, do
//
//     final taxSetting = taxSettingFromJson(jsonString);

import 'dart:convert';

List<TaxSetting> taxSettingFromJson(String str) => new List<TaxSetting>.from(
    json.decode(str).map((x) => TaxSetting.fromJson(x)));

String taxSettingToJson(List<TaxSetting> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class TaxSetting {
  String gstin;

  TaxSetting({
    this.gstin,
  });

  factory TaxSetting.fromJson(Map<String, dynamic> json) => new TaxSetting(
        gstin: json["gstin"] == null ? null : json["gstin"],
      );

  Map<String, dynamic> toJson() => {
        "gstin": gstin == null ? null : gstin,
      };
}
