// To parse this JSON data, do
//
//     final mainPackage = mainPackageFromJson(jsonString);

import 'dart:convert';

MainPackage mainPackageFromJson(String str) {
    final jsonData = json.decode(str);
    return MainPackage.fromJson(jsonData);
}

List<MainPackage> mainPackagesFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<MainPackage>.from(jsonData.map((x) => MainPackage.fromJson(x)));
}

String mainPackageToJson(MainPackage data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

String mainPackagesToJson(List<MainPackage> data) {
    final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
    return json.encode(dyn);
}

class MainPackage {
    String id;
    String packageType;
    String packageName;
    dynamic packageItem;
    List<dynamic> channels;
    List<dynamic> subPackages;
    double packageCost;
    double packageDiscount;
    bool activeStatus;
    String createdBy;
    String modifiedBy;
    String createdAt;
    String updatedAt;
    dynamic created;
    dynamic modified;

    MainPackage({
        this.id,
        this.packageType,
        this.packageName,
        this.packageItem,
        this.channels,
        this.subPackages,
        this.packageCost,
        this.packageDiscount,
        this.activeStatus,
        this.createdBy,
        this.modifiedBy,
        this.createdAt,
        this.updatedAt,
        this.created,
        this.modified,
    });

    factory MainPackage.fromJson(Map<String, dynamic> json) => new MainPackage(
        id: json["id"] == null ? null : json["id"],
        packageType: json["packageType"] == null ? null : json["packageType"],
        packageName: json["packageName"] == null ? null : json["packageName"],
        packageItem: json["packageItem"],
        channels: json["channels"] == null ? null : new List<dynamic>.from(json["channels"].map((x) => x)),
        subPackages: json["subPackages"] == null ? null : new List<dynamic>.from(json["subPackages"].map((x) => x)),
        packageCost: json["packageCost"] == null ? null : json["packageCost"].toDouble(),
        packageDiscount: json["packageDiscount"] == null ? null : json["packageDiscount"].toDouble(),
        activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
        createdBy: json["createdBy"] == null ? null : json["createdBy"],
        modifiedBy: json["modifiedBy"] == null ? null : json["modifiedBy"],
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
        created: json["Created"],
        modified: json["Modified"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "packageType": packageType == null ? null : packageType,
        "packageName": packageName == null ? null : packageName,
        "packageItem": packageItem,
        "channels": channels == null ? null : new List<dynamic>.from(channels.map((x) => x)),
        "subPackages": subPackages == null ? null : new List<dynamic>.from(subPackages.map((x) => x)),
        "packageCost": packageCost == null ? null : packageCost,
        "packageDiscount": packageDiscount == null ? null : packageDiscount,
        "activeStatus": activeStatus == null ? null : activeStatus,
        "createdBy": createdBy == null ? null : createdBy,
        "modifiedBy": modifiedBy == null ? null : modifiedBy,
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
        "Created": created,
        "Modified": modified,
    };
}
