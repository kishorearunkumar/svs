// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

List<Customer> customerFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Customer>.from(jsonData.map((x) => Customer.fromJson(x)));
}

String customerToJson(List<Customer> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

String customersToJson(Customer data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Customer {
  String id;
  String lcoId;
  String customerName;
  String customerId;
  String sortCustomerId;
  String barCode;
  String cafNo;
  String dob;
  String gender;
  String collectionAgent;
  bool activeStatus;
  double rent;
  double outstandc;
  double outstandi;
  double outstandt;
  Cable cable;
  Internet internet;
  Address address;
  String ebNumber;
  String postNumber;
  List<Created> created;
  List<Created> modified;
  String createdAt;
  String sortCreatedAt;
  String updatedAt;
  bool boxEdited;

  Customer({
    this.id,
    this.lcoId,
    this.customerName,
    this.customerId,
    this.sortCustomerId,
    this.barCode,
    this.cafNo,
    this.dob,
    this.gender,
    this.collectionAgent,
    this.activeStatus,
    this.rent,
    this.outstandc,
    this.outstandi,
    this.outstandt,
    this.cable,
    this.internet,
    this.address,
    this.ebNumber,
    this.postNumber,
    this.created,
    this.modified,
    this.createdAt,
    this.sortCreatedAt,
    this.updatedAt,
    this.boxEdited,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => new Customer(
        id: json["id"] == null ? null : json["id"],
        lcoId: json["lcoId"] == null ? null : json["lcoId"],
        customerName: json["customerName"] == null ? '' : json["customerName"],
        customerId: json["customerId"] == null ? '' : json["customerId"],
        barCode: json["barCode"] == null ? '' : json["barCode"],
        cafNo: json["cafNo"] == null ? null : json["cafNo"],
        dob: json["dob"] == null ? null : json["dob"],
        gender: json["gender"] == null ? null : json["gender"],
        collectionAgent:
            json["collectionAgent"] == null ? null : json["collectionAgent"],
        activeStatus:
            json["activeStatus"] == null ? null : json["activeStatus"],
        rent: json["rent"] == null ? null : json["rent"].toDouble(),
        cable: json["cable"] == null ? null : Cable.fromJson(json["cable"]),
        internet: json["internet"] == null
            ? null
            : Internet.fromJson(json["internet"]),
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        ebNumber: json["ebNumber"] == null ? null : json["ebNumber"],
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
        boxEdited: json["boxEdited"] == null ? null : json["boxEdited"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "lcoId": lcoId == null ? null : lcoId,
        "customerName": customerName == null ? '' : customerName,
        "customerId": customerId == null ? '' : customerId,
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
        "ebNumber": ebNumber == null ? null : ebNumber,
        "postNumber": postNumber == null ? null : postNumber,
        "Created": created == null
            ? null
            : new List<dynamic>.from(created.map((x) => x.toJson())),
        "Modified": modified == null
            ? null
            : new List<dynamic>.from(modified.map((x) => x.toJson())),
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
        "boxEdited": boxEdited == null ? null : boxEdited,
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
            json["residenceType"] == null ? '' : json["residenceType"],
        doorNo: json["doorNo"] == null ? '' : json["doorNo"],
        houseName: json["houseName"] == null ? '' : json["houseName"],
        street: json["street"] == null ? '' : json["street"],
        area: json["area"] == null ? '' : json["area"],
        landmark: json["landmark"] == null ? '' : json["landmark"],
        city: json["city"] == null ? '' : json["city"],
        state: json["state"] == null ? '' : json["state"],
        pincode: json["pincode"] == null ? '' : json["pincode"],
        emailId: json["emailId"] == null ? '' : json["emailId"],
        mobile: json["mobile"] == null ? '' : json["mobile"],
        alternateNumber:
            json["alternateNumber"] == null ? '' : json["alternateNumber"],
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
  String cableAdvanceInstallment;
  String cableAdvanceAmountPaid;
  String cableOutstandingAmount;
  String sortcableOutstandingAmount;
  String cableMonthlyRent;
  String cableDiscount;
  String cableComments;

  Cable({
    this.noCableConnection,
    this.boxDetails,
    this.cableAdvanceAmount,
    this.cableAdvanceInstallment,
    this.cableAdvanceAmountPaid,
    this.cableOutstandingAmount,
    this.sortcableOutstandingAmount,
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
            ? "0"
            : json["cableAdvanceAmount"],
        cableAdvanceInstallment: json["cableAdvanceInstallment"] == null
            ? "0"
            : json["cableAdvanceInstallment"],
        cableAdvanceAmountPaid: json["cableAdvanceAmountPaid"] == null
            ? "0"
            : json["cableAdvanceAmountPaid"],
        cableOutstandingAmount: json["cableOutstandingAmount"] == null
            ? "0"
            : json["cableOutstandingAmount"],
        cableMonthlyRent:
            json["cableMonthlyRent"] == null ? "0" : json["cableMonthlyRent"],
        cableDiscount:
            json["cableDiscount"] == null ? "0" : json["cableDiscount"],
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
            cableAdvanceAmount == null ? "0" : cableAdvanceAmount,
        "cableAdvanceInstallment":
            cableAdvanceInstallment == null ? null : cableAdvanceAmount,
        "cableAdvanceAmountPaid":
            cableAdvanceAmountPaid == null ? "0" : cableAdvanceAmountPaid,
        "cableOutstandingAmount":
            cableOutstandingAmount == null ? "0" : cableOutstandingAmount,
        "cableMonthlyRent": cableMonthlyRent == null ? "0" : cableMonthlyRent,
        "cableDiscount": cableDiscount == null ? "0" : cableDiscount,
        "cableComments": cableComments == null ? null : cableComments,
      };
}

class BoxDetail {
  String cableType;
  String boxType;
  String msoId;
  String activationDate;
  bool freeConnection;
  String nuidNo;
  String irdNo;
  String vcNo;
  String mainPackageName;
  String mainPackageId;
  String mainPackageBillable;
  String mainPackageCost;
  Package mainPackage;
  AddonPackage addonPackage;
  String boxComment;

  BoxDetail({
    this.cableType,
    this.boxType,
    this.msoId,
    this.activationDate,
    this.freeConnection,
    this.nuidNo,
    this.irdNo,
    this.vcNo,
    this.mainPackageName,
    this.mainPackageId,
    this.mainPackageBillable,
    this.mainPackageCost,
    this.mainPackage,
    this.addonPackage,
    this.boxComment,
  });

  factory BoxDetail.fromJson(Map<String, dynamic> json) => new BoxDetail(
        cableType: json["cableType"] == null ? null : json["cableType"],
        boxType: json["boxType"] == null ? null : json["boxType"],
        msoId: json["msoId"] == null ? null : json["msoId"],
        activationDate:
            json["activationDate"] == null ? null : json["activationDate"],
        freeConnection: json["freeConnection"],
        nuidNo: json["nuidNo"] == null ? "" : json["nuidNo"],
        irdNo: json["irdNo"] == null ? "" : json["irdNo"],
        vcNo: json["vcNo"] == null ? "" : json["vcNo"],
        mainPackageName: json["main_package_name"] == null
            ? null
            : json["main_package_name"],
        mainPackageId:
            json["main_package_id"] == null ? null : json["main_package_id"],
        mainPackageBillable: json["main_package_billable"] == null
            ? null
            : json["main_package_billable"],
        mainPackageCost: json["main_package_cost"],
        mainPackage: json["mainPackage"] == null
            ? null
            : Package.fromJson(json["mainPackage"]),
        addonPackage: json["addonPackage"] == null
            ? null
            : AddonPackage.fromJson(json["addonPackage"]),
        boxComment: json["boxComment"] == null ? "" : json["boxComment"],
      );

  Map<String, dynamic> toJson() => {
        "cableType": cableType == null ? null : cableType,
        "boxType": boxType == null ? null : boxType,
        "msoId": msoId == null ? null : msoId,
        "activationDate": activationDate == null ? null : activationDate,
        "freeConnection": freeConnection,
        "nuidNo": nuidNo == null ? null : nuidNo,
        "irdNo": irdNo == null ? null : irdNo,
        "vcNo": vcNo == null ? null : vcNo,
        "main_package_name": mainPackageName == null ? null : mainPackageName,
        "main_package_id": mainPackageId == null ? null : mainPackageId,
        "main_package_billable":
            mainPackageBillable == null ? null : mainPackageBillable,
        "main_package_cost": mainPackageCost,
        "mainPackage": mainPackage == null ? null : mainPackage.toJson(),
        "addonPackage": addonPackage == null ? null : addonPackage.toJson(),
        "boxComment": boxComment == null ? null : boxComment,
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
            ? []
            : new List<AddonPackageChannel>.from(
                json["channels"].map((x) => AddonPackageChannel.fromJson(x))),
        subPackages: json["subPackages"] == null
            ? []
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
  String packageCost;
  String packageName;
  String billable;
  List<MainPackageChannel> channels;

  Package({
    this.packageId,
    this.packageCost,
    this.packageName,
    this.billable,
    this.channels,
  });

  factory Package.fromJson(Map<String, dynamic> json) => new Package(
        packageId: json["packageId"] == null ? null : json["packageId"],
        packageCost: json["packageCost"] == null ? null : json["packageCost"],
        packageName: json["packageName"] == null ? null : json["packageName"],
        billable: json["billable"] == null ? null : json["billable"],
        channels: json["channels"] == null
            ? null
            : new List<MainPackageChannel>.from(
                json["channels"].map((x) => MainPackageChannel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "packageId": packageId == null ? null : packageId,
        "packageCost": packageCost == null ? null : packageCost,
        "packageName": packageName == null ? null : packageName,
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
  String internetBillType;
  String internetBillingDate;
  String planName;
  String internetAdvanceAmount;
  String internetOutstandingAmount;
  String internetMonthlyRent;
  String internetDiscount;
  String internetComments;
  String ontNo;
  String macId;
  String vLan;
  String voip;
  bool freeConnection;

  Internet({
    this.noInternetConnection,
    this.internetActivationDate,
    this.internetBillType,
    this.internetBillingDate,
    this.planName,
    this.internetAdvanceAmount,
    this.internetOutstandingAmount,
    this.internetMonthlyRent,
    this.internetDiscount,
    this.internetComments,
    this.ontNo,
    this.macId,
    this.vLan,
    this.voip,
    this.freeConnection,
  });

  factory Internet.fromJson(Map<String, dynamic> json) => new Internet(
        noInternetConnection: json["noInternetConnection"] == null
            ? null
            : json["noInternetConnection"],
        internetActivationDate: json["internetActivationDate"] == null
            ? null
            : json["internetActivationDate"],
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
            ? "0"
            : json["internetOutstandingAmount"],
        internetMonthlyRent: json["internetMonthlyRent"] == null
            ? "0"
            : json["internetMonthlyRent"],
        internetDiscount:
            json["internetDiscount"] == null ? null : json["internetDiscount"],
        internetComments:
            json["internetComments"] == null ? null : json["internetComments"],
        ontNo: json["ontNo"] == null ? null : json["ontNo"],
        macId: json["macId"] == null ? null : json["macId"],
        vLan: json["vLan"] == null ? null : json["vLan"],
        voip: json["voip"] == null ? null : json["voip"],
        freeConnection: json["freeConnection"],
      );

  Map<String, dynamic> toJson() => {
        "noInternetConnection":
            noInternetConnection == null ? null : noInternetConnection,
        "internetActivationDate":
            internetActivationDate == null ? null : internetActivationDate,
        "internetBillType": internetBillType == null ? null : internetBillType,
        "internetBillingDate":
            internetBillingDate == null ? null : internetBillingDate,
        "planName": planName == null ? null : planName,
        "internetAdvanceAmount":
            internetAdvanceAmount == null ? null : internetAdvanceAmount,
        "internetOutstandingAmount":
            internetOutstandingAmount == null ? "0" : internetOutstandingAmount,
        "internetMonthlyRent":
            internetMonthlyRent == null ? "0" : internetMonthlyRent,
        "internetDiscount": internetDiscount == null ? null : internetDiscount,
        "internetComments": internetComments == null ? null : internetComments,
        "ontNo": ontNo == null ? null : ontNo,
        "macId": macId == null ? null : macId,
        "vLan": vLan == null ? null : vLan,
        "voip": voip == null ? null : voip,
        "freeConnection": freeConnection,
      };
}
