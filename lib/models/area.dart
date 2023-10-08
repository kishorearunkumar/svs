// To parse this JSON data, do
//
//     final area = areaFromJson(jsonString);

import 'dart:convert';

Areas areaFromJson(String str) {
    final jsonData = json.decode(str);
    return Areas.fromJson(jsonData);
}

List<Areas> areasFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<Areas>.from(jsonData.map((x) => Areas.fromJson(x)));
}

String areaToJson(Areas data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

String areasToJson(List<Areas> data) {
    final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
    return json.encode(dyn);
}

class Areas {
    String id;
    String area;
    String city;
    String state;
    String pincode;
    String createdBy;
    String modifiedBy;
    String createdAt;
    String updatedAt;

    Areas({
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

    factory Areas.fromJson(Map<String, dynamic> json) => new Areas(
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