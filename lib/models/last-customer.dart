// To parse this JSON data, do
//
//     final lastCustomer = lastCustomerFromJson(jsonString);

import 'dart:convert';

LastCustomer lastCustomerFromJson(String str) {
    final jsonData = json.decode(str);
    return LastCustomer.fromJson(jsonData);
}

List<LastCustomer> lastCustomersFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<LastCustomer>.from(jsonData.map((x) => LastCustomer.fromJson(x)));
}

String lastCustomerToJson(LastCustomer data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

class LastCustomer {
    String customerId;

    LastCustomer({
        this.customerId,
    });

    factory LastCustomer.fromJson(Map<String, dynamic> json) => new LastCustomer(
        customerId: json["customerId"] == null ? null : json["customerId"],
    );

    Map<String, dynamic> toJson() => {
        "customerId": customerId == null ? null : customerId,
    };
}