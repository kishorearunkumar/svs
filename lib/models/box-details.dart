class Cables {
  int noCableConnection;
  List<BoxDetails> boxDetails;
  String cableAdvanceAmount;
  String cableAdvanceInstallment;
  String cableAdvanceAmountPaid;
  String cableOutstandingAmount;
  String sortcableOutstandingAmount;
  String cableMonthlyRent;
  String cableDiscount;
  String cableComments;

  Cables({
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

  factory Cables.fromJson(Map<String, dynamic> json) => new Cables(
        noCableConnection: json["noCableConnection"] == null
            ? null
            : json["noCableConnection"],
        boxDetails: json["boxDetails"] == null
            ? null
            : new List<BoxDetails>.from(
                json["boxDetails"].map((x) => BoxDetails.fromJson(x))),
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

class BoxDetails {
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
  Packages mainPackage;
  AddonPackages addonPackage;
  String boxComment;

  BoxDetails({
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

  factory BoxDetails.fromJson(Map<String, dynamic> json) => new BoxDetails(
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
            : Packages.fromJson(json["mainPackage"]),
        addonPackage: json["addonPackage"] == null
            ? null
            : AddonPackages.fromJson(json["addonPackage"]),
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

class AddonPackages {
  List<AddonPackageChannels> channels;
  List<Packages> subPackages;
  String packageCost;

  AddonPackages({
    this.channels,
    this.subPackages,
    this.packageCost,
  });

  factory AddonPackages.fromJson(Map<String, dynamic> json) =>
      new AddonPackages(
        channels: json["channels"] == null
            ? []
            : new List<AddonPackageChannels>.from(
                json["channels"].map((x) => AddonPackageChannels.fromJson(x))),
        subPackages: json["subPackages"] == null
            ? []
            : new List<Packages>.from(
                json["subPackages"].map((x) => Packages.fromJson(x))),
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

class AddonPackageChannels {
  String channelId;
  String channelName;
  String channelCost;
  String billable;

  AddonPackageChannels({
    this.channelId,
    this.channelName,
    this.channelCost,
    this.billable,
  });

  factory AddonPackageChannels.fromJson(Map<String, dynamic> json) =>
      new AddonPackageChannels(
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

class Packages {
  String packageId;
  String packageCost;
  String packageName;
  String billable;
  List<MainPackageChannels> channels;

  Packages({
    this.packageId,
    this.packageCost,
    this.packageName,
    this.billable,
    this.channels,
  });

  factory Packages.fromJson(Map<String, dynamic> json) => new Packages(
        packageId: json["packageId"] == null ? null : json["packageId"],
        packageCost: json["packageCost"] == null ? null : json["packageCost"],
        packageName: json["packageName"] == null ? null : json["packageName"],
        billable: json["billable"] == null ? null : json["billable"],
        channels: json["channels"] == null
            ? null
            : new List<MainPackageChannels>.from(
                json["channels"].map((x) => MainPackageChannels.fromJson(x))),
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

class MainPackageChannels {
  String id;
  String name;

  MainPackageChannels({
    this.id,
    this.name,
  });

  factory MainPackageChannels.fromJson(Map<String, dynamic> json) =>
      new MainPackageChannels(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
