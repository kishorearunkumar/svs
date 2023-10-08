// To parse this JSON data, do
//
//     final subLco = subLcoFromJson(jsonString);

import 'dart:convert';

SubLco subLcoFromJson(String str) {
    final jsonData = json.decode(str);
    return SubLco.fromJson(jsonData);
}

List<SubLco> subLcosFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<SubLco>.from(jsonData.map((x) => SubLco.fromJson(x)));
}

String subLcoToJson(SubLco data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

String subLcosToJson(List<SubLco> data) {
    final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
    return json.encode(dyn);
}

class SubLco {
    String id;
    String subLcoName;

    SubLco({
        this.id,
        this.subLcoName,
    });

    factory SubLco.fromJson(Map<String, dynamic> json) => new SubLco(
        id: json["id"] == null ? null : json["id"],
        subLcoName: json["subLcoName"] == null ? null : json["subLcoName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "subLcoName": subLcoName == null ? null : subLcoName,
    };
}
