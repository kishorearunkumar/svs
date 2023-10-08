// To parse this JSON data, do
//
//     final dashboard = dashboardFromJson(jsonString);

import 'dart:convert';

Dashboard dashboardFromJson(String str) {
    final jsonData = json.decode(str);
    return Dashboard.fromJson(jsonData);
}

String dashboardToJson(Dashboard data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

class Dashboard {
    int totalCustomers;
    int activeCustomers;
    int inactiveCustomers;
    int cable;
    int activeCable;
    int inactiveCable;
    int activeInternet;
    int inactiveInternet;
    int freeCable;
    int freeInternet;
    int internet;
    int analog;
    int digital;
    int sd;
    int hd;
    int cablePaid;
    int cableUnpaid;
    int internetPaid;
    int internetUnpaid;
    int totalBill;
    int totalAmount;
    int amountPaid;
    int amountUnpaid;
    List<Collection> collection;
    int cComplaintOpen;
    int cComplaintClosed; 
    int iComplaintOpen;
    int iComplaintClosed;
    int messageUsed;
    int messageBalance;

    Dashboard({
        this.totalCustomers,
        this.activeCustomers,
        this.inactiveCustomers,
        this.cable,
        this.activeCable,
        this.inactiveCable,
        this.activeInternet,
        this.inactiveInternet,
        this.freeCable,
        this.freeInternet,
        this.internet,
        this.analog,
        this.digital,
        this.sd,
        this.hd,
        this.cablePaid,
        this.cableUnpaid,
        this.internetPaid,
        this.internetUnpaid,
        this.totalBill,
        this.totalAmount,
        this.amountPaid,
        this.amountUnpaid,
        this.collection,
        this.cComplaintOpen,
        this.cComplaintClosed,
        this.iComplaintOpen,
        this.iComplaintClosed,
        this.messageUsed,
        this.messageBalance,
    });

    factory Dashboard.fromJson(Map<String, dynamic> json) => new Dashboard(
        totalCustomers: json["totalCustomers"] == null ? null : json["totalCustomers"],
        activeCustomers: json["activeCustomers"] == null ? null : json["activeCustomers"],
        inactiveCustomers: json["inactiveCustomers"] == null ? null : json["inactiveCustomers"],
        cable: json["cable"] == null ? null : json["cable"],
        activeCable: json["activeCable"] == null ? null : json["activeCable"],
        inactiveCable: json["inactiveCable"] == null ? null : json["inactiveCable"],
        activeInternet: json["activeInternet"] == null ? null : json["activeInternet"],
        inactiveInternet: json["inactiveInternet"] == null ? null : json["inactiveInternet"],
        freeCable: json["freeCable"] == null ? null : json["freeCable"],
        freeInternet: json["freeInternet"] == null ? null : json["freeInternet"],
        internet: json["internet"] == null ? null : json["internet"],
        analog: json["analog"] == null ? null : json["analog"],
        digital: json["digital"] == null ? null : json["digital"],
        sd: json["sd"] == null ? null : json["sd"],
        hd: json["hd"] == null ? null : json["hd"],
        cablePaid: json["cablePaid"] == null ? null : json["cablePaid"],
        cableUnpaid: json["cableUnpaid"] == null ? null : json["cableUnpaid"],
        internetPaid: json["internetPaid"] == null ? null : json["internetPaid"],
        internetUnpaid: json["internetUnpaid"] == null ? null : json["internetUnpaid"],
        totalBill: json["totalBill"] == null ? null : json["totalBill"],
        totalAmount: json["totalAmount"] == null ? null : json["totalAmount"],
        amountPaid: json["amountPaid"] == null ? null : json["amountPaid"],
        amountUnpaid: json["amountUnpaid"] == null ? null : json["amountUnpaid"],
        collection: json["collection"] == null ? null : new List<Collection>.from(json["collection"].map((x) => Collection.fromJson(x))),
        cComplaintOpen: json["cComplaintOpen"] == null ? null : json["cComplaintOpen"],
        cComplaintClosed: json["cComplaintClosed"] == null ? null : json["cComplaintClosed"],
        iComplaintOpen: json["iComplaintOpen"] == null ? null : json["iComplaintOpen"],
        iComplaintClosed: json["iComplaintClosed"] == null ? null : json["iComplaintClosed"],
        messageUsed: json["messageUsed"] == null ? null : json["messageUsed"],
        messageBalance: json["messageBalance"] == null ? null : json["messageBalance"],
    );

    Map<String, dynamic> toJson() => {
        "totalCustomers": totalCustomers == null ? null : totalCustomers,
        "activeCustomers": activeCustomers == null ? null : activeCustomers,
        "inactiveCustomers": inactiveCustomers == null ? null : inactiveCustomers,
        "cable": cable == null ? null : cable,
        "activeCable": activeCable == null ? null : activeCable,
        "inactiveCable": inactiveCable == null ? null : inactiveCable,
        "activeInternet": activeInternet == null ? null : activeInternet,
        "inactiveInternet": inactiveInternet == null ? null : inactiveInternet,
        "freeCable": freeCable == null ? null : freeCable,
        "freeInternet": freeInternet == null ? null : freeInternet,
        "internet": internet == null ? null : internet,
        "analog": analog == null ? null : analog,
        "digital": digital == null ? null : digital,
        "sd": sd == null ? null : sd,
        "hd": hd == null ? null : hd,
        "cablePaid": cablePaid == null ? null : cablePaid,
        "cableUnpaid": cableUnpaid == null ? null : cableUnpaid,
        "internetPaid": internetPaid == null ? null : internetPaid,
        "internetUnpaid": internetUnpaid == null ? null : internetUnpaid,
        "totalBill": totalBill == null ? null : totalBill,
        "totalAmount": totalAmount == null ? null : totalAmount,
        "amountPaid": amountPaid == null ? null : amountPaid,
        "amountUnpaid": amountUnpaid == null ? null : amountUnpaid,
        "collection": collection == null ? null : new List<dynamic>.from(collection.map((x) => x.toJson())),
        "cComplaintOpen": cComplaintOpen == null ? null : cComplaintOpen,
        "cComplaintClosed": cComplaintClosed == null ? null : cComplaintClosed,
        "iComplaintOpen": iComplaintOpen == null ? null : iComplaintOpen,
        "iComplaintClosed": iComplaintClosed == null ? null : iComplaintClosed,
        "messageUsed": messageUsed == null ? null : messageUsed,
        "messageBalance": messageBalance == null ? null : messageBalance,
    };
}

class Collection {
    String userId;
    int todayCollection;
    int todayCustomers;
    int monthlyCollection;
    int monthlyCustomers;
    Users user;
    int outstanding;

    Collection({
        this.userId,
        this.todayCollection,
        this.todayCustomers,
        this.monthlyCollection,
        this.monthlyCustomers,
        this.user,
        this.outstanding,
    });

    factory Collection.fromJson(Map<String, dynamic> json) => new Collection(
        userId: json["userId"] == null ? null : json["userId"],
        todayCollection: json["todayCollection"] == null ? null : json["todayCollection"],
        todayCustomers: json["todayCustomers"] == null ? null : json["todayCustomers"],
        monthlyCollection: json["monthlyCollection"] == null ? null : json["monthlyCollection"],
        monthlyCustomers: json["monthlyCustomers"] == null ? null : json["monthlyCustomers"],
        user: json["user"] == null ? null : Users.fromJson(json["user"]),
        outstanding: json["outstanding"] == null ? null : json["outstanding"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId == null ? null : userId,
        "todayCollection": todayCollection == null ? null : todayCollection,
        "todayCustomers": todayCustomers == null ? null : todayCustomers,
        "monthlyCollection": monthlyCollection == null ? null : monthlyCollection,
        "monthlyCustomers": monthlyCustomers == null ? null : monthlyCustomers,
        "user": user == null ? null : user.toJson(),
        "outstanding": outstanding == null ? null : outstanding,
    };
}

class Users {
    String id;
    String name;
    String emailId;
    String userName;
    String password;
    String userType;
    String operatorId;
    String phoneNumber;
    bool activeStatus;

    Users({
        this.id,
        this.name,
        this.emailId,
        this.userName,
        this.password,
        this.userType,
        this.operatorId,
        this.phoneNumber,
        this.activeStatus,
    });

    factory Users.fromJson(Map<String, dynamic> json) => new Users(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        emailId: json["emailID"] == null ? null : json["emailID"],
        userName: json["userName"] == null ? null : json["userName"],
        password: json["password"] == null ? null : json["password"],
        userType: json["userType"] == null ? null : json["userType"],
        operatorId: json["operatorID"] == null ? null : json["operatorID"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "emailID": emailId == null ? null : emailId,
        "userName": userName == null ? null : userName,
        "password": password == null ? null : password,
        "userType": userType == null ? null : userType,
        "operatorID": operatorId == null ? null : operatorId,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "activeStatus": activeStatus == null ? null : activeStatus,
    };
}
