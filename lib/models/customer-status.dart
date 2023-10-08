// To parse this JSON data, do
//
//     final customerStatus = customerStatusFromJson(jsonString);

import 'dart:convert';

CustomerStatus customerStatusFromJson(String str) => CustomerStatus.fromJson(json.decode(str));

String customerStatusToJson(CustomerStatus data) => json.encode(data.toJson());

List<CustomerStatus> customersStatusFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<CustomerStatus>.from(jsonData.map((x) => CustomerStatus.fromJson(x)));
}

String customersStatusToJson(List<CustomerStatus> data) {
    final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
    return json.encode(dyn);
}

class CustomerStatus {
    String id;
    String customerId;
    String service;
    String createdBy;
    DateTime notify;
    DateTime createdAt;
    List<Created> created;

    CustomerStatus({
        this.id,
        this.customerId,
        this.service,
        this.createdBy,
        this.notify,
        this.createdAt,
        this.created,
    });

    factory CustomerStatus.fromJson(Map<String, dynamic> json) => new CustomerStatus(
        id: json["id"] == null ? null : json["id"],
        customerId: json["customerId"] == null ? null : json["customerId"],
        service: json["service"] == null ? null : json["service"],
        createdBy: json["createdBy"] == null ? null : json["createdBy"],
        notify: json["notify"] == null ? null : DateTime.parse(json["notify"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        created: json["Created"] == null ? null : new List<Created>.from(json["Created"].map((x) => Created.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "customerId": customerId == null ? null : customerId,
        "service": service == null ? null : service,
        "createdBy": createdBy == null ? null : createdBy,
        "notify": notify == null ? null : notify.toIso8601String(),
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "Created": created == null ? null : new List<dynamic>.from(created.map((x) => x.toJson())),
    };
}

class Created {
    String name;

    Created({
        this.name,
    });

    factory Created.fromJson(Map<String, dynamic> json) => new Created(
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
    };
}
