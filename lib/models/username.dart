// To parse this JSON data, do
//
//     final username = usernameFromJson(jsonString);

import 'dart:convert';

Username usernameFromJson(String str) {
    final jsonData = json.decode(str);
    return Username.fromJson(jsonData);
}

List<Username> usernamesFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<Username>.from(jsonData.map((x) => Username.fromJson(x)));
}

String usernameToJson(Username data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

String usernamesToJson(List<Username> data) {
    final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
    return json.encode(dyn);
}

class Username {
    String id;
    String name;
    String userName;
    String userType;

    Username({
        this.id,
        this.name,
        this.userName,
        this.userType,
    });

    factory Username.fromJson(Map<String, dynamic> json) => new Username(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        userName: json["userName"] == null ? null : json["userName"],
        userType: json["userType"] == null ? null : json["userType"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "userName": userName == null ? null : userName,
        "userType": userType == null ? null : userType,
    };
}
