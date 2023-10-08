// To parse this JSON data, do
//
//     final package = packageFromJson(jsonString);

import 'dart:convert';

AddOnPackage addOnPackageFromJson(String str) =>
    AddOnPackage.fromJson(json.decode(str));

String addOnPackageToJson(AddOnPackage data) => json.encode(data.toJson());

String addOnPackagesToJson(List<AddOnPackage> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

List<AddOnPackage> addOnPackagesFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<AddOnPackage>.from(
      jsonData.map((x) => AddOnPackage.fromJson(x)));
}

class AddOnPackage {
  String packageId;
  String packageType;
  String packageName;
  List<AddOnPackageChannel> channels;
  List<AddOnPackageSubPackage> subPackages;
  double packagecost;
  String packageCost;
  double packageDiscount;
  bool selected;
  String billable;

  AddOnPackage({
    this.packageId,
    this.packageType,
    this.packageName,
    this.channels,
    this.subPackages,
    this.packagecost,
    this.packageCost,
    this.packageDiscount,
    this.selected,
    this.billable,
  });

  factory AddOnPackage.fromJson(Map<String, dynamic> json) => new AddOnPackage(
        packageId: json["id"] == null ? null : json["id"],
        packageType: json["packageType"] == null ? null : json["packageType"],
        packageName: json["packageName"] == null ? null : json["packageName"],
        channels: json["channels"] == null
            ? null
            : new List<AddOnPackageChannel>.from(
                json["channels"].map((x) => AddOnPackageChannel.fromJson(x))),
        subPackages: json["subPackages"] == null
            ? null
            : new List<AddOnPackageSubPackage>.from(json["subPackages"]
                .map((x) => AddOnPackageSubPackage.fromJson(x))),
        packagecost:
            json["packageCost"] == null ? null : json["packageCost"].toDouble(),
        packageDiscount: json["packageDiscount"] == null
            ? null
            : json["packageDiscount"].toDouble(),
            selected: json["isAddOnPackage"] == null ? false : json["isAddOnPackage"],
      );

  Map<String, dynamic> toJson() => {
        "id": packageId == null ? null : packageId,
        "packageType": packageType == null ? null : packageType,
        "packageName": packageName == null ? null : packageName,
        "channels": channels == null
            ? null
            : new List<dynamic>.from(channels.map((x) => x.toJson())),
        "subPackages": subPackages == null
            ? null
            : new List<dynamic>.from(subPackages.map((x) => x.toJson())),
        "packageCost": packagecost == null ? null : packagecost,
        "packageDiscount": packageDiscount == null ? null : packageDiscount,
      };
}

class AddOnPackageChannel {
  String id;
  String name;

  AddOnPackageChannel({
    this.id,
    this.name,
  });

  factory AddOnPackageChannel.fromJson(Map<String, dynamic> json) =>
      new AddOnPackageChannel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}

class AddOnPackageSubPackage {
  String id;
  String name;

  AddOnPackageSubPackage({
    this.id,
    this.name,
  });

  factory AddOnPackageSubPackage.fromJson(Map<String, dynamic> json) =>
      new AddOnPackageSubPackage(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
