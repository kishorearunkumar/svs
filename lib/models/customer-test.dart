// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

List<Customer> customerFromJson(String str) =>
    new List<Customer>.from(json.decode(str).map((x) => Customer.fromJson(x)));

String customerToJson(List<Customer> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class Customer {
  String id;
  String lcoId;
  String customerName;
  String customerId;
  String barCode;
  String cafNo;
  String dob;
  String gender;
  String collectionAgent;
  bool activeStatus;
  int rent;
  Cable cable;
  Internet internet;
  Address address;
  String postNumber;
  List<Created> created;
  List<Created> modified;
  String createdAt;
  String updatedAt;
  String gst;
  String customerSign;
  String ebNumber;

  Customer({
    this.id,
    this.lcoId,
    this.customerName,
    this.customerId,
    this.barCode,
    this.cafNo,
    this.dob,
    this.gender,
    this.collectionAgent,
    this.activeStatus,
    this.rent,
    this.cable,
    this.internet,
    this.address,
    this.postNumber,
    this.created,
    this.modified,
    this.createdAt,
    this.updatedAt,
    this.gst,
    this.customerSign,
    this.ebNumber,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => new Customer(
        id: json["id"] == null ? null : json["id"],
        lcoId: json["lcoId"] == null ? null : json["lcoId"],
        customerName:
            json["customerName"] == null ? null : json["customerName"],
        customerId: json["customerId"] == null ? null : json["customerId"],
        barCode: json["barCode"] == null ? null : json["barCode"],
        cafNo: json["cafNo"] == null ? null : json["cafNo"],
        dob: json["dob"] == null ? null : json["dob"],
        gender: json["gender"] == null ? null : json["gender"],
        collectionAgent:
            json["collectionAgent"] == null ? null : json["collectionAgent"],
        activeStatus:
            json["activeStatus"] == null ? null : json["activeStatus"],
        rent: json["rent"] == null ? null : json["rent"],
        cable: json["cable"] == null ? null : Cable.fromJson(json["cable"]),
        internet: json["internet"] == null
            ? null
            : Internet.fromJson(json["internet"]),
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        postNumber: json["postNumber"] == null ? null : json["postNumber"],
        created: json["Created"] == null
            ? null
            : new List<Created>.from(
                json["Created"].map((x) => Created.fromJson(x))),
        modified: json["Modified"] == null
            ? null
            : new List<Created>.from(
                json["Modified"].map((x) => Created.fromJson(x))),
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
        gst: json["gst"] == null ? null : json["gst"],
        customerSign:
            json["customerSign"] == null ? null : json["customerSign"],
        ebNumber: json["ebNumber"] == null ? null : json["ebNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "lcoId": lcoId == null ? null : lcoId,
        "customerName": customerName == null ? null : customerName,
        "customerId": customerId == null ? null : customerId,
        "barCode": barCode == null ? null : barCode,
        "cafNo": cafNo == null ? null : cafNo,
        "dob": dob == null ? null : dob,
        "gender": gender == null ? null : gender,
        "collectionAgent": collectionAgent == null ? null : collectionAgent,
        "activeStatus": activeStatus == null ? null : activeStatus,
        "rent": rent == null ? null : rent,
        "cable": cable == null ? null : cable.toJson(),
        "internet": internet == null ? null : internet.toJson(),
        "address": address == null ? null : address.toJson(),
        "postNumber": postNumber == null ? null : postNumber,
        "Created": created == null
            ? null
            : new List<dynamic>.from(created.map((x) => x.toJson())),
        "Modified": modified == null
            ? null
            : new List<dynamic>.from(modified.map((x) => x.toJson())),
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
        "gst": gst == null ? null : gst,
        "customerSign": customerSign == null ? null : customerSign,
        "ebNumber": ebNumber == null ? null : ebNumber,
      };
}

class Address {
  String residenceType;
  String doorNo;
  String houseName;
  String street;
  String area;
  String landmark;
  String city;
  String state;
  String pincode;
  String emailId;
  String mobile;
  String alternateNumber;

  Address({
    this.residenceType,
    this.doorNo,
    this.houseName,
    this.street,
    this.area,
    this.landmark,
    this.city,
    this.state,
    this.pincode,
    this.emailId,
    this.mobile,
    this.alternateNumber,
  });

  factory Address.fromJson(Map<String, dynamic> json) => new Address(
        residenceType:
            json["residenceType"] == null ? null : json["residenceType"],
        doorNo: json["doorNo"] == null ? null : json["doorNo"],
        houseName: json["houseName"] == null ? null : json["houseName"],
        street: json["street"] == null ? null : json["street"],
        area: json["area"] == null ? null : json["area"],
        landmark: json["landmark"] == null ? null : json["landmark"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        pincode: json["pincode"] == null ? null : json["pincode"],
        emailId: json["emailId"] == null ? null : json["emailId"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        alternateNumber:
            json["alternateNumber"] == null ? null : json["alternateNumber"],
      );

  Map<String, dynamic> toJson() => {
        "residenceType": residenceType == null ? null : residenceType,
        "doorNo": doorNo == null ? null : doorNo,
        "houseName": houseName == null ? null : houseName,
        "street": street == null ? null : street,
        "area": area == null ? null : area,
        "landmark": landmark == null ? null : landmark,
        "city": city == null ? null : city,
        "state": state == null ? null : state,
        "pincode": pincode == null ? null : pincode,
        "emailId": emailId == null ? null : emailId,
        "mobile": mobile == null ? null : mobile,
        "alternateNumber": alternateNumber == null ? null : alternateNumber,
      };
}

class Cable {
  int noCableConnection;
  List<BoxDetail> boxDetails;
  String cableAdvanceAmount;
  String cableAdvanceAmountPaid;
  String cableAdvanceInstallment;
  String cableOutstandingAmount;
  String cableMonthlyRent;
  String cableDiscount;
  String cableComments;

  Cable({
    this.noCableConnection,
    this.boxDetails,
    this.cableAdvanceAmount,
    this.cableAdvanceAmountPaid,
    this.cableAdvanceInstallment,
    this.cableOutstandingAmount,
    this.cableMonthlyRent,
    this.cableDiscount,
    this.cableComments,
  });

  factory Cable.fromJson(Map<String, dynamic> json) => new Cable(
        noCableConnection: json["noCableConnection"] == null
            ? null
            : json["noCableConnection"],
        boxDetails: json["boxDetails"] == null
            ? null
            : new List<BoxDetail>.from(
                json["boxDetails"].map((x) => BoxDetail.fromJson(x))),
        cableAdvanceAmount: json["cableAdvanceAmount"] == null
            ? null
            : json["cableAdvanceAmount"],
        cableAdvanceAmountPaid: json["cableAdvanceAmountPaid"] == null
            ? null
            : json["cableAdvanceAmountPaid"],
        cableAdvanceInstallment: json["cableAdvanceInstallment"] == null
            ? null
            : json["cableAdvanceInstallment"],
        cableOutstandingAmount: json["cableOutstandingAmount"] == null
            ? null
            : json["cableOutstandingAmount"],
        cableMonthlyRent:
            json["cableMonthlyRent"] == null ? null : json["cableMonthlyRent"],
        cableDiscount:
            json["cableDiscount"] == null ? null : json["cableDiscount"],
        cableComments:
            json["cableComments"] == null ? null : json["cableComments"],
      );

  Map<String, dynamic> toJson() => {
        "noCableConnection":
            noCableConnection == null ? null : noCableConnection,
        "boxDetails": boxDetails == null
            ? null
            : new List<dynamic>.from(boxDetails.map((x) => x.toJson())),
        "cableAdvanceAmount":
            cableAdvanceAmount == null ? null : cableAdvanceAmount,
        "cableAdvanceAmountPaid":
            cableAdvanceAmountPaid == null ? null : cableAdvanceAmountPaid,
        "cableAdvanceInstallment":
            cableAdvanceInstallment == null ? null : cableAdvanceInstallment,
        "cableOutstandingAmount":
            cableOutstandingAmount == null ? null : cableOutstandingAmount,
        "cableMonthlyRent": cableMonthlyRent == null ? null : cableMonthlyRent,
        "cableDiscount": cableDiscount == null ? null : cableDiscount,
        "cableComments": cableComments == null ? null : cableComments,
      };
}

class BoxDetail {
  String cableType;
  String boxType;
  String msoId;
  String activationDate;
  String nuidNo;
  String irdNo;
  String vcNo;
  Package mainPackage;
  AddonPackage addonPackage;

  BoxDetail({
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

  factory BoxDetail.fromJson(Map<String, dynamic> json) => new BoxDetail(
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
            : Package.fromJson(json["mainPackage"]),
        addonPackage: json["addonPackage"] == null
            ? null
            : AddonPackage.fromJson(json["addonPackage"]),
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

class AddonPackage {
  List<AddonPackageChannel> channels;
  List<Package> subPackages;
  String packageCost;

  AddonPackage({
    this.channels,
    this.subPackages,
    this.packageCost,
  });

  factory AddonPackage.fromJson(Map<String, dynamic> json) => new AddonPackage(
        channels: json["channels"] == null
            ? null
            : new List<AddonPackageChannel>.from(
                json["channels"].map((x) => AddonPackageChannel.fromJson(x))),
        subPackages: json["subPackages"] == null
            ? null
            : new List<Package>.from(
                json["subPackages"].map((x) => Package.fromJson(x))),
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

class AddonPackageChannel {
  String channelId;
  String channelName;
  String channelCost;
  String billable;

  AddonPackageChannel({
    this.channelId,
    this.channelName,
    this.channelCost,
    this.billable,
  });

  factory AddonPackageChannel.fromJson(Map<String, dynamic> json) =>
      new AddonPackageChannel(
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

class Package {
  String packageId;
  String packageName;
  String packageCost;
  String billable;
  List<MainPackageChannel> channels;

  Package({
    this.packageId,
    this.packageName,
    this.packageCost,
    this.billable,
    this.channels,
  });

  factory Package.fromJson(Map<String, dynamic> json) => new Package(
        packageId: json["packageId"] == null ? null : json["packageId"],
        packageName: json["packageName"] == null ? null : json["packageName"],
        packageCost: json["packageCost"] == null ? null : json["packageCost"],
        billable: json["billable"] == null ? null : json["billable"],
        channels: json["channels"] == null
            ? null
            : new List<MainPackageChannel>.from(
                json["channels"].map((x) => MainPackageChannel.fromJson(x))),
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

class MainPackageChannel {
  String id;
  String name;

  MainPackageChannel({
    this.id,
    this.name,
  });

  factory MainPackageChannel.fromJson(Map<String, dynamic> json) =>
      new MainPackageChannel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
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

class Internet {
  int noInternetConnection;
  String internetActivationDate;
  String internetExpiryDate;
  String internetBillType;
  String internetBillingDate;
  String planName;
  String internetAdvanceAmount;
  String internetOutstandingAmount;
  String internetMonthlyRent;
  String internetComments;
  String internetDiscount;

  Internet({
    this.noInternetConnection,
    this.internetActivationDate,
    this.internetExpiryDate,
    this.internetBillType,
    this.internetBillingDate,
    this.planName,
    this.internetAdvanceAmount,
    this.internetOutstandingAmount,
    this.internetMonthlyRent,
    this.internetComments,
    this.internetDiscount,
  });

  factory Internet.fromJson(Map<String, dynamic> json) => new Internet(
        noInternetConnection: json["noInternetConnection"] == null
            ? null
            : json["noInternetConnection"],
        internetActivationDate: json["internetActivationDate"] == null
            ? null
            : json["internetActivationDate"],
        internetExpiryDate: json["internetExpiryDate"] == null
            ? null
            : json["internetExpiryDate"],
        internetBillType:
            json["internetBillType"] == null ? null : json["internetBillType"],
        internetBillingDate: json["internetBillingDate"] == null
            ? null
            : json["internetBillingDate"],
        planName: json["planName"] == null ? null : json["planName"],
        internetAdvanceAmount: json["internetAdvanceAmount"] == null
            ? null
            : json["internetAdvanceAmount"],
        internetOutstandingAmount: json["internetOutstandingAmount"] == null
            ? null
            : json["internetOutstandingAmount"],
        internetMonthlyRent: json["internetMonthlyRent"] == null
            ? null
            : json["internetMonthlyRent"],
        internetComments:
            json["internetComments"] == null ? null : json["internetComments"],
        internetDiscount:
            json["internetDiscount"] == null ? null : json["internetDiscount"],
      );

  Map<String, dynamic> toJson() => {
        "noInternetConnection":
            noInternetConnection == null ? null : noInternetConnection,
        "internetActivationDate":
            internetActivationDate == null ? null : internetActivationDate,
        "internetExpiryDate":
            internetExpiryDate == null ? null : internetExpiryDate,
        "internetBillType": internetBillType == null ? null : internetBillType,
        "internetBillingDate":
            internetBillingDate == null ? null : internetBillingDate,
        "planName": planName == null ? null : planName,
        "internetAdvanceAmount":
            internetAdvanceAmount == null ? null : internetAdvanceAmount,
        "internetOutstandingAmount": internetOutstandingAmount == null
            ? null
            : internetOutstandingAmount,
        "internetMonthlyRent":
            internetMonthlyRent == null ? null : internetMonthlyRent,
        "internetComments": internetComments == null ? null : internetComments,
        "internetDiscount": internetDiscount == null ? null : internetDiscount,
      };
}
