import 'dart:convert';

User userFromJson(String str) {
    final jsonData = json.decode(str);
    return User.fromJson(jsonData);
}

String userToJson(User data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

class User {
    String userName;
    String password;

    User({
        this.userName,
        this.password,
    });

    factory User.fromJson(Map<String, dynamic> json) => new User(
        userName: json["userName"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "userName": userName,
        "password": password,
    };
}
