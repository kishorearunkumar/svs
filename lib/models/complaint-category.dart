// To parse this JSON data, do
//
//     final complaintCategory = complaintCategoryFromJson(jsonString);

import 'dart:convert';

List<ComplaintCategory> complaintCategoryFromJson(String str) => new List<ComplaintCategory>.from(json.decode(str).map((x) => ComplaintCategory.fromJson(x)));

String complaintCategoryToJson(List<ComplaintCategory> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class ComplaintCategory {
    String id;
    String categoryName;

    ComplaintCategory({
        this.id,
        this.categoryName,
    });

    factory ComplaintCategory.fromJson(Map<String, dynamic> json) => new ComplaintCategory(
        id: json["id"] == null ? null : json["id"],
        categoryName: json["categoryName"] == null ? null : json["categoryName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "categoryName": categoryName == null ? null : categoryName,
    };
}
