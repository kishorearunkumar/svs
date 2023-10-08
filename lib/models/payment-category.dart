// To parse this JSON data, do
//
//     final paymentCategory = paymentCategoryFromJson(jsonString);

import 'dart:convert';

PaymentCategory paymentCategoryFromJson(String str) {
    final jsonData = json.decode(str);
    return PaymentCategory.fromJson(jsonData);
}

List<PaymentCategory> paymentCategorysFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<PaymentCategory>.from(jsonData.map((x) => PaymentCategory.fromJson(x)));
}

String paymentCategoryToJson(PaymentCategory data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

String paymentCategorysToJson(List<PaymentCategory> data) {
    final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
    return json.encode(dyn);
}

class PaymentCategory {
    String id;
    String paymentCategory;
    String amount;

    PaymentCategory({
        this.id,
        this.paymentCategory,
        this.amount,
    });

    factory PaymentCategory.fromJson(Map<String, dynamic> json) => new PaymentCategory(
        id: json["id"] == null ? null : json["id"],
        paymentCategory: json["paymentCategory"] == null ? null : json["paymentCategory"],
        amount: json["amount"] == null ? null : json["amount"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "paymentCategory": paymentCategory == null ? null : paymentCategory,
        "amount": amount == null ? null : amount,
    };
}