// To parse this JSON data, do
//
//     final payment = paymentFromJson(jsonString);

import 'dart:convert';
import 'package:svs/models/customer.dart';

List<Payment> paymentsFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Payment>.from(jsonData.map((x) => Payment.fromJson(x)));
}

Payment paymentFromJson(String str) {
  final jsonData = json.decode(str);
  return new Payment.fromJson(jsonData);
}

String paymentToJson(Payment data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

String paymentsToJson(List<Payment> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class Payment {
  String id;
  String invoiceId;
  String customerId;
  String sortCustomerId;
  String amountPaid;
  String outstanding;
  String serviceType;
  String paymentFor;
  String paymentMode;
  String ccomment;
  String discount;
  String comment;
  String maintananceFee;
  String receiptPhoneNumber;
  bool activeStatus;
  String createdBy;
  String modifiedBy;
  String createdAt;
  String sortCreatedAt;
  String updatedAt;
  Customer customerData;
  List<BoxDetail> boxDetails;
  List<PurpleCreated> created;
  List<PurpleCreated> modified;
  String customDate;

  Payment({
    this.id,
    this.invoiceId,
    this.customerId,
    this.sortCustomerId,
    this.amountPaid,
    this.outstanding,
    this.serviceType,
    this.paymentFor,
    this.paymentMode,
    this.ccomment,
    this.discount,
    this.comment,
    this.maintananceFee,
    this.receiptPhoneNumber,
    this.activeStatus,
    this.createdBy,
    this.modifiedBy,
    this.createdAt,
    this.sortCreatedAt,
    this.updatedAt,
    this.customerData,
    this.boxDetails,
    this.created,
    this.modified,
    this.customDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => new Payment(
        id: json["id"] == null ? null : json["id"],
        invoiceId: json["invoiceId"] == null ? null : json["invoiceId"],
        customerId: json["customerId"] == null ? null : json["customerId"],
        amountPaid: json["amountPaid"] == null ? null : json["amountPaid"],
        outstanding: json["outstanding"] == null ? "" : json["outstanding"],
        serviceType: json["serviceType"] == null ? null : json["serviceType"],
        paymentFor: json["paymentFor"] == null
            ? 'Cable Subscription'
            : json["paymentFor"],
        paymentMode: json["paymentMode"] == null ? null : json["paymentMode"],
        ccomment: json["ccomment"] == null ? null : json["ccomment"],
        discount: json["discount"] == null ? null : json["discount"],
        comment: json["comment"] == null ? null : json["comment"],
        maintananceFee:
            json["maintananceFee"] == null ? null : json["maintananceFee"],
        receiptPhoneNumber: json["receiptPhoneNumber"] == null
            ? null
            : json["receiptPhoneNumber"],
        activeStatus:
            json["activeStatus"] == null ? null : json["activeStatus"],
        createdBy: json["createdBy"] == null ? null : json["createdBy"],
        modifiedBy: json["modifiedBy"] == null ? null : json["modifiedBy"],
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
        customerData: json["customerData"] == null
            ? null
            : Customer.fromJson(json["customerData"]),
        boxDetails: json["boxDetails"] == null
            ? null
            : new List<BoxDetail>.from(
                json["boxDetails"].map((x) => BoxDetail.fromJson(x))),
        created: json["Created"] == null
            ? null
            : new List<PurpleCreated>.from(
                json["Created"].map((x) => PurpleCreated.fromJson(x))),
        modified: json["Modified"] == null
            ? null
            : new List<PurpleCreated>.from(
                json["Modified"].map((x) => PurpleCreated.fromJson(x))),
        customDate: json["customDate"] == null ? null : json["customDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "invoiceId": invoiceId == null ? null : invoiceId,
        "customerId": customerId == null ? null : customerId,
        "amountPaid": amountPaid == null ? null : amountPaid,
        "outstanding": outstanding == null ? null : outstanding,
        "serviceType": serviceType == null ? null : serviceType,
        "paymentFor": paymentFor == null ? null : paymentFor,
        "paymentMode": paymentMode == null ? null : paymentMode,
        "ccomment": ccomment == null ? null : ccomment,
        "discount": discount == null ? null : discount,
        "comment": comment == null ? null : comment,
        "maintananceFee": maintananceFee == null ? null : maintananceFee,
        "receiptPhoneNumber":
            receiptPhoneNumber == null ? null : receiptPhoneNumber,
        "activeStatus": activeStatus == null ? null : activeStatus,
        "createdBy": createdBy == null ? null : createdBy,
        "modifiedBy": modifiedBy == null ? null : modifiedBy,
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
        "customerData": customerData == null ? null : customerData,
        "boxDetails": boxDetails == null
            ? null
            : new List<dynamic>.from(boxDetails.map((x) => x.toJson())),
        "Created": created == null
            ? null
            : new List<dynamic>.from(created.map((x) => x.toJson())),
        "Modified": modified == null
            ? null
            : new List<dynamic>.from(modified.map((x) => x.toJson())),
        "customDate": customDate == null ? null : customDate,
      };
}

class PaymentBoxDetail {
  String cableType;
  String boxType;
  String msoId;
  String activationDate;
  String nuidNo;
  String irdNo;
  String vcNo;
  PurplePackage mainPackage;
  PurpleAddonPackage addonPackage;

  PaymentBoxDetail({
    this.cableType,
    this.boxType,
    this.msoId,
    this.activationDate,
    this.nuidNo,
    this.irdNo,
    this.vcNo,
    this.mainPackage,
    this.addonPackage,
  });

  factory PaymentBoxDetail.fromJson(Map<String, dynamic> json) =>
      new PaymentBoxDetail(
        cableType: json["cableType"] == null ? null : json["cableType"],
        boxType: json["boxType"] == null ? null : json["boxType"],
        msoId: json["msoId"] == null ? null : json["msoId"],
        activationDate:
            json["activationDate"] == null ? null : json["activationDate"],
        nuidNo: json["nuidNo"] == null ? null : json["nuidNo"],
        irdNo: json["irdNo"] == null ? null : json["irdNo"],
        vcNo: json["vcNo"] == null ? null : json["vcNo"],
        mainPackage: json["mainPackage"] == null
            ? null
            : PurplePackage.fromJson(json["mainPackage"]),
        addonPackage: json["addonPackage"] == null
            ? null
            : PurpleAddonPackage.fromJson(json["addonPackage"]),
      );

  Map<String, dynamic> toJson() => {
        "cableType": cableType == null ? null : cableType,
        "boxType": boxType == null ? null : boxType,
        "msoId": msoId == null ? null : msoId,
        "activationDate": activationDate == null ? null : activationDate,
        "nuidNo": nuidNo == null ? null : nuidNo,
        "irdNo": irdNo == null ? null : irdNo,
        "vcNo": vcNo == null ? null : vcNo,
        "mainPackage": mainPackage == null ? null : mainPackage.toJson(),
        "addonPackage": addonPackage == null ? null : addonPackage.toJson(),
      };
}

class PurpleAddonPackage {
  List<PurpleChannel> channels;
  List<PurplePackage> subPackages;
  String packageCost;

  PurpleAddonPackage({
    this.channels,
    this.subPackages,
    this.packageCost,
  });

  factory PurpleAddonPackage.fromJson(Map<String, dynamic> json) =>
      new PurpleAddonPackage(
        channels: json["channels"] == null
            ? null
            : new List<PurpleChannel>.from(
                json["channels"].map((x) => PurpleChannel.fromJson(x))),
        subPackages: json["subPackages"] == null
            ? null
            : new List<PurplePackage>.from(
                json["subPackages"].map((x) => PurplePackage.fromJson(x))),
        packageCost: json["packageCost"] == null ? null : json["packageCost"],
      );

  Map<String, dynamic> toJson() => {
        "channels": channels == null
            ? null
            : new List<dynamic>.from(channels.map((x) => x.toJson())),
        "subPackages": subPackages == null
            ? null
            : new List<dynamic>.from(subPackages.map((x) => x.toJson())),
        "packageCost": packageCost == null ? null : packageCost,
      };
}

class PurpleChannel {
  String channelId;
  String channelName;
  String channelCost;
  String billable;

  PurpleChannel({
    this.channelId,
    this.channelName,
    this.channelCost,
    this.billable,
  });

  factory PurpleChannel.fromJson(Map<String, dynamic> json) =>
      new PurpleChannel(
        channelId: json["channelId"] == null ? null : json["channelId"],
        channelName: json["channelName"] == null ? null : json["channelName"],
        channelCost: json["channelCost"] == null ? null : json["channelCost"],
        billable: json["billable"] == null ? null : json["billable"],
      );

  Map<String, dynamic> toJson() => {
        "channelId": channelId == null ? null : channelId,
        "channelName": channelName == null ? null : channelName,
        "channelCost": channelCost == null ? null : channelCost,
        "billable": billable == null ? null : billable,
      };
}

class PurplePackage {
  String packageId;
  String packageName;
  String packageCost;
  String billable;
  List<PurplePackageChannel> channels;

  PurplePackage({
    this.packageId,
    this.packageName,
    this.packageCost,
    this.billable,
    this.channels,
  });

  factory PurplePackage.fromJson(Map<String, dynamic> json) =>
      new PurplePackage(
        packageId: json["packageId"] == null ? null : json["packageId"],
        packageName: json["packageName"] == null ? null : json["packageName"],
        packageCost: json["packageCost"] == null ? null : json["packageCost"],
        billable: json["billable"] == null ? null : json["billable"],
        channels: json["channels"] == null
            ? null
            : new List<PurplePackageChannel>.from(
                json["channels"].map((x) => PurplePackageChannel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "packageId": packageId == null ? null : packageId,
        "packageName": packageName == null ? null : packageName,
        "packageCost": packageCost == null ? null : packageCost,
        "billable": billable == null ? null : billable,
        "channels": channels == null
            ? null
            : new List<dynamic>.from(channels.map((x) => x.toJson())),
      };
}

class PurplePackageChannel {
  String id;
  String name;

  PurplePackageChannel({
    this.id,
    this.name,
  });

  factory PurplePackageChannel.fromJson(Map<String, dynamic> json) =>
      new PurplePackageChannel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}

class PurpleCreated {
  String id;
  String name;
  String phoneNumber;
  String emailId;
  String userName;
  String password;
  String userType;
  bool activeStatus;

  PurpleCreated({
    this.id,
    this.name,
    this.phoneNumber,
    this.emailId,
    this.userName,
    this.password,
    this.userType,
    this.activeStatus,
  });

  factory PurpleCreated.fromJson(Map<String, dynamic> json) =>
      new PurpleCreated(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        emailId: json["emailID"] == null ? null : json["emailID"],
        userName: json["userName"] == null ? null : json["userName"],
        password: json["password"] == null ? null : json["password"],
        userType: json["userType"] == null ? null : json["userType"],
        activeStatus:
            json["activeStatus"] == null ? null : json["activeStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "emailID": emailId == null ? null : emailId,
        "userName": userName == null ? null : userName,
        "password": password == null ? null : password,
        "userType": userType == null ? null : userType,
        "activeStatus": activeStatus == null ? null : activeStatus,
      };
}
