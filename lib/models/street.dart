// To parse this JSON data, do
//
//     final street = streetFromJson(jsonString);

import 'dart:convert';

Street streetFromJson(String str) {
  final jsonData = json.decode(str);
  return Street.fromJson(jsonData);
}

List<Street> streetsFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Street>.from(jsonData.map((x) => Street.fromJson(x)));
}

String streetsToJson(List<Street> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

String streetToJson(Street data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Street {
  String id;
  String street;
  String areaId;
  String lcoId;
  String collectionAgent;
  Area area;
  String createdBy;
  String modifiedBy;
  String createdAt;
  String updatedAt;

  Street({
    this.id,
    this.street,
    this.areaId,
    this.lcoId,
    this.collectionAgent,
    this.area,
    this.createdBy,
    this.modifiedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Street.fromJson(Map<String, dynamic> json) => new Street(
        id: json["id"] == null ? null : json["id"],
        street: json["street"] == null ? null : json["street"],
        areaId: json["areaId"] == null ? null : json["areaId"],
        lcoId: json["lcoID"] == null ? null : json["lcoID"],
        collectionAgent:
            json["collectionAgent"] == null ? null : json["collectionAgent"],
        area: json["area"] == null ? null : Area.fromJson(json["area"]),
        createdBy: json["createdBy"] == null ? null : json["createdBy"],
        modifiedBy: json["modifiedBy"] == null ? null : json["modifiedBy"],
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "street": street == null ? null : street,
        "areaId": areaId == null ? null : areaId,
        "lcoID": lcoId == null ? null : lcoId,
        "collectionAgent": collectionAgent == null ? null : collectionAgent,
        "area": area == null ? null : area.toJson(),
        "createdBy": createdBy == null ? null : createdBy,
        "modifiedBy": modifiedBy == null ? null : modifiedBy,
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
      };
}

class Area {
  String id;
  String area;
  String city;
  String state;
  String pincode;
  String createdBy;
  String modifiedBy;
  String createdAt;
  String updatedAt;

  Area({
    this.id,
    this.area,
    this.city,
    this.state,
    this.pincode,
    this.createdBy,
    this.modifiedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Area.fromJson(Map<String, dynamic> json) => new Area(
        id: json["id"] == null ? null : json["id"],
        area: json["area"] == null ? null : json["area"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        pincode: json["pincode"] == null ? null : json["pincode"],
        createdBy: json["createdBy"] == null ? null : json["createdBy"],
        modifiedBy: json["modifiedBy"] == null ? null : json["modifiedBy"],
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "area": area == null ? null : area,
        "city": city == null ? null : city,
        "state": state == null ? null : state,
        "pincode": pincode == null ? null : pincode,
        "createdBy": createdBy == null ? null : createdBy,
        "modifiedBy": modifiedBy == null ? null : modifiedBy,
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
      };
}
