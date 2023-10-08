import 'dart:convert';
import "package:flutter/material.dart";
import 'package:svs/models/customer.dart';
import "package:svs/models/payment.dart";
import "package:url_launcher/url_launcher.dart";
import "package:intl/intl.dart";
// import "package:flutter_launch/flutter_launch.dart";
import "package:simple_sms/simple_sms.dart";
import "package:svs/utils/app_shared_preferences.dart";
import "package:svs/models/login-response.dart";
import "package:flutter/services.dart";
import 'package:svs/services/basic_service.dart';
import 'package:svs/models/general.dart';
import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:whatsapp_launch/whatsapp_launch.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:open_file/open_file.dart';

var formatter = NumberFormat("##,##,##0.00");
_addonPackList(Package addon) {
  if (addon.packageName != null && addon.packageCost != null) {
    return TableRow(children: [
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black54,
              ),
              width: 15.0,
            ),
            SizedBox(
              child: Text(addon.packageName),
              width: 100.0,
            ),
            SizedBox(
              child: Text(
                (formatter.format(double.tryParse(addon.packageCost)))
                    .toString(),
                textAlign: TextAlign.right,
              ),
              width: 50.0,
            ),
            SizedBox(
              child: Text(
                (formatter.format(
                        (18 / 100) * double.tryParse(addon.packageCost)))
                    .toString(),
                textAlign: TextAlign.right,
              ),
              width: 60.0,
            ),
            SizedBox(
              child: Text(
                (formatter.format(
                        ((18 / 100) * double.tryParse(addon.packageCost)) +
                            double.tryParse(addon.packageCost)))
                    .toString(),
                textAlign: TextAlign.right,
              ),
              width: 60.0,
            ),
          ],
        ),
      )
    ]);
  } else {
    return TableRow(children: [
      TableCell(
        child: Row(),
      )
    ]);
  }
}

_addonChannelList(AddonPackageChannel channel) {
  if (channel.channelName != null) {
    return TableRow(children: [
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black54,
              ),
              width: 15.0,
            ),
            SizedBox(
              child: Text(channel.channelName),
              width: 100.0,
            ),
            SizedBox(
              child: Text(
                (formatter.format(double.tryParse(channel.channelCost)))
                    .toString(),
                textAlign: TextAlign.right,
              ),
              width: 50.0,
            ),
            SizedBox(
              child: Text(
                (formatter.format(
                        (18 / 100) * double.tryParse(channel.channelCost)))
                    .toString(),
                textAlign: TextAlign.right,
              ),
              width: 60.0,
            ),
            SizedBox(
              child: Text(
                (formatter.format(
                        ((18 / 100) * double.tryParse(channel.channelCost)) +
                            double.tryParse(channel.channelCost)))
                    .toString(),
                textAlign: TextAlign.right,
              ),
              width: 60.0,
            ),
          ],
        ),
      )
    ]);
  } else {
    return TableRow(children: [
      TableCell(
        child: Row(),
      )
    ]);
  }
}

Widget _boxDetailView(BoxDetail box) {
  var addons = List<TableRow>();
  double addonsPackageCost = 0.0;

  for (var i = 0; i < box.addonPackage.subPackages.length; i++) {
    if (box.addonPackage.subPackages[i].packageCost.isNotEmpty) {
      addonsPackageCost = addonsPackageCost +
          double.tryParse(box.addonPackage.subPackages[i].packageCost);
    }

    var addon = _addonPackList(box.addonPackage.subPackages[i]);
    addons.add(addon);
  }
  var channels = List<TableRow>();
  double channelsPackageCost = 0.0;

  for (var i = 0; i < box.addonPackage.channels.length; i++) {
    if (box.addonPackage.channels[i].channelCost.isNotEmpty) {
      channelsPackageCost = channelsPackageCost +
          double.tryParse(box.addonPackage.channels[i].channelCost);
    }
    var channel = _addonChannelList(box.addonPackage.channels[i]);
    channels.add(channel);
  }

  return box != null
      ? Column(
          children: <Widget>[
            ((box.vcNo != "" && box.vcNo != null) ||
                    (box.nuidNo != "" && box.nuidNo != null) ||
                    (box.irdNo != "" && box.irdNo != null))
                ? Card(
                    color: Colors.indigo,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        box.vcNo != "" && box.vcNo != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "VC Number : " + box.vcNo,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    height: 17.0,
                                    child: IconButton(
                                        padding: EdgeInsets.all(0.0),
                                        tooltip: "VC Number Copied",
                                        iconSize: 14.0,
                                        color: Colors.white,
                                        icon: Icon(Icons.content_copy),
                                        onPressed: () {
                                          Clipboard.setData(new ClipboardData(
                                              text: box.vcNo));
                                        }),
                                  )
                                ],
                              )
                            : Container(),
                        box.vcNo != "" && box.vcNo != null
                            ? Divider()
                            : Container(),
                        box.nuidNo != "" && box.nuidNo != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("NUID Number : " + box.nuidNo,
                                      style: TextStyle(color: Colors.white)),
                                  Container(
                                    height: 17.0,
                                    child: IconButton(
                                        padding: EdgeInsets.all(0.0),
                                        tooltip: "NUID Number Copied",
                                        iconSize: 14.0,
                                        color: Colors.white,
                                        icon: Icon(Icons.content_copy),
                                        onPressed: () {
                                          Clipboard.setData(new ClipboardData(
                                              text: box.nuidNo));
                                        }),
                                  )
                                ],
                              )
                            : Container(),
                        box.nuidNo != "" && box.nuidNo != null
                            ? Divider()
                            : Container(),
                        box.irdNo != "" && box.irdNo != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("IRD Number : " + box.irdNo,
                                      style: TextStyle(color: Colors.white)),
                                  Container(
                                    height: 17.0,
                                    child: IconButton(
                                        padding: EdgeInsets.all(0.0),
                                        tooltip: "IRD Number Copied",
                                        iconSize: 14.0,
                                        color: Colors.white,
                                        icon: Icon(Icons.content_copy),
                                        onPressed: () {
                                          Clipboard.setData(new ClipboardData(
                                              text: box.irdNo));
                                        }),
                                  )
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ))
                : Container(),
            box.msoId == null ? Container() : Divider(),
            box.msoId == null
                ? Container()
                : Row(
                    children: <Widget>[
                      Container(
                        width: 5.0,
                      ),
                      Text(box.msoId == null ? '' : "MSO : "),
                      Expanded(child: Text(box.msoId == null ? '' : box.msoId)),
                      Container(
                        width: 5.0,
                      ),
                    ],
                  ),
            box.msoId == null ? Container() : Divider(),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                (box.mainPackage.packageCost != null &&
                        box.addonPackage.packageCost != null &&
                        box.mainPackage.packageCost != "" &&
                        box.addonPackage.packageCost != "")
                    ? Table(
                        border:
                            TableBorder.all(width: 1.0, color: Colors.black45),
                        children: [
                          TableRow(children: [
                            TableCell(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  SizedBox(
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black54,
                                    ),
                                    width: 15.0,
                                  ),
                                  SizedBox(
                                      child: Text(
                                        "Subscription",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      width: 100.0),
                                  SizedBox(
                                    child: Text(
                                      "MRP",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                    width: 60.0,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      "GST",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                    width: 60.0,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      "Total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                    width: 60.0,
                                  ),
                                ],
                              ),
                            )
                          ]),
                          box.mainPackage.packageName != null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        SizedBox(
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Colors.black54,
                                          ),
                                          width: 15.0,
                                        ),
                                        SizedBox(
                                          child:
                                              Text(box.mainPackage.packageName),
                                          width: 100.0,
                                        ),
                                        SizedBox(
                                          child: Text(
                                            (formatter.format(double.tryParse(
                                                    box.mainPackage
                                                        .packageCost)))
                                                .toString(),
                                            textAlign: TextAlign.right,
                                          ),
                                          width: 50.0,
                                        ),
                                        SizedBox(
                                          child: Text(
                                            (formatter.format((18 / 100) *
                                                    double.tryParse(box
                                                        .mainPackage
                                                        .packageCost)))
                                                .toString(),
                                            textAlign: TextAlign.right,
                                          ),
                                          width: 60.0,
                                        ),
                                        SizedBox(
                                          child: Text(
                                            (formatter.format(((18 / 100) *
                                                        double.tryParse(box
                                                            .mainPackage
                                                            .packageCost)) +
                                                    double.tryParse(box
                                                        .mainPackage
                                                        .packageCost)))
                                                .toString(),
                                            textAlign: TextAlign.right,
                                          ),
                                          width: 60.0,
                                        ),
                                      ],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(),
                                  )
                                ]),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 1.0,
                ),
                addons != null && addons.length > 0
                    ? Table(
                        border:
                            TableBorder.all(width: 1.0, color: Colors.black45),
                        children: addons)
                    : Container(),
                addons != null && addons.length > 0
                    ? SizedBox(
                        height: 0.5,
                      )
                    : Container(),
                channels != null && channels.length > 0
                    ? Table(
                        border:
                            TableBorder.all(width: 1.0, color: Colors.black45),
                        children: channels)
                    : Container(),
                channels != null && channels.length > 0
                    ? SizedBox(
                        height: 1.0,
                      )
                    : Container(),
                (box.mainPackage.packageCost != null &&
                        box.addonPackage.packageCost != null &&
                        box.mainPackage.packageCost != "" &&
                        box.addonPackage.packageCost != "")
                    ? Table(
                        border:
                            TableBorder.all(width: 1.0, color: Colors.black45),
                        children: [
                            TableRow(children: [
                              TableCell(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    SizedBox(
                                      child: Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.black,
                                      ),
                                      width: 15.0,
                                    ),
                                    SizedBox(
                                      child: Text("Total",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      width: 100.0,
                                    ),
                                    SizedBox(
                                      child: Text(
                                        (formatter.format(double.tryParse(box
                                                    .mainPackage.packageCost) +
                                                addonsPackageCost +
                                                channelsPackageCost))
                                            .toString(),
                                        // (formatter.format(double.tryParse(box
                                        //             .mainPackage.packageCost) +
                                        //         double.tryParse(box
                                        //             .addonPackage.packageCost)))
                                        //     .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                      width: 50.0,
                                    ),
                                    SizedBox(
                                      child: Text(
                                        (formatter.format((18 / 100) *
                                                (double.tryParse(box.mainPackage
                                                        .packageCost) +
                                                    addonsPackageCost +
                                                    channelsPackageCost)))
                                            .toString(),
                                        // (formatter.format((18 / 100) *
                                        //         (double.tryParse(box.mainPackage
                                        //                 .packageCost) +
                                        //             double.tryParse(box
                                        //                 .addonPackage
                                        //                 .packageCost))))
                                        //     .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                      width: 60.0,
                                    ),
                                    SizedBox(
                                      child: Text(
                                        (formatter.format(((18 / 100) *
                                                    (double.tryParse(box
                                                            .mainPackage
                                                            .packageCost) +
                                                        addonsPackageCost +
                                                        channelsPackageCost)) +
                                                (double.tryParse(box.mainPackage
                                                        .packageCost) +
                                                    addonsPackageCost +
                                                    channelsPackageCost)))
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                      width: 60.0,
                                    ),
                                  ],
                                ),
                              )
                            ])
                          ])
                    : Container(),
                SizedBox(
                  height: 10.0,
                )
              ],
            )
          ],
        )
      : Container();
}

paymentView(BuildContext context, Payment payment, bool now) async {
  LoginResponse user = await AppSharedPreferences.getUserProfile();

  var formatter = new DateFormat("dd-MM-yyyy hh:mm aaa");

  generalSetting(payment);
  var boxes = List<Widget>();

  if (payment.boxDetails != null && payment.boxDetails.isNotEmpty) {
    for (var i = 0; i < payment.boxDetails.length; i++) {
      var box = _boxDetailView(payment.boxDetails[i]);
      boxes.add(box);
    }
  }

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Material(
                      clipBehavior: Clip.antiAlias,
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(4.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ListTile(
                                  dense: true,
                                  title: Center(
                                      child: Text(
                                          payment.customerData.customerName
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0))),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Text(
                                              "ID : " +
                                                  payment
                                                      .customerData.customerId,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0))),
                                      Expanded(
                                          child: Text(
                                              "Bill : " + payment.invoiceId,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0)))
                                    ],
                                  )),
                              Row(children: <Widget>[
                                Expanded(
                                    child: Text(
                                        payment.customerData.address.doorNo +
                                            " " +
                                            payment.customerData.address
                                                .houseName +
                                            " " +
                                            payment
                                                .customerData.address.street +
                                            " " +
                                            payment.customerData.address.area +
                                            " " +
                                            payment.customerData.address.city,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black54))),
                                Expanded(
                                  child: Text(
                                    !now
                                        ? formatter.format(
                                            DateTime.tryParse(payment.createdAt)
                                                .toLocal())
                                        : formatter
                                            .format(DateTime.now().toLocal()),
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.black54),
                                    textAlign: TextAlign.right,
                                  ),
                                )
                              ]),
                              Divider(),
                              payment.serviceType == "internet" ||
                                      payment.serviceType == "others" ||
                                      payment.paymentFor == "Installation"
                                  ? Container()
                                  : Text(payment.customerData.cable
                                              .noCableConnection ==
                                          null
                                      ? ''
                                      : "Number of Connections : " +
                                          payment.customerData.cable
                                              .noCableConnection
                                              .toString()),
                              payment.serviceType == "internet" ||
                                      payment.serviceType == "others" ||
                                      payment.paymentFor == "Installation"
                                  ? Container()
                                  : Divider(),
                              payment.serviceType == "internet" ||
                                      payment.serviceType == "others" ||
                                      payment.paymentFor == "Installation"
                                  ? Container()
                                  : payment.customerData.cable.boxDetails ==
                                          null
                                      ? 0
                                      : Column(
                                          children: <Widget>[
                                            Material(
                                              elevation: 2.0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              8.0))),
                                              child: GroovinExpansionTile(
                                                defaultTrailingIconColor:
                                                    Colors.indigoAccent,
                                                leading: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.indigoAccent,
                                                  child: Icon(
                                                    Icons.live_tv,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                title: Text(
                                                  "Subscription Details",
                                                  textAlign: TextAlign.center,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(5.0),
                                                      bottomRight:
                                                          Radius.circular(5.0),
                                                    ),
                                                    child: Column(
                                                      children: boxes,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                              payment.serviceType == "internet" ||
                                      payment.serviceType == "others" ||
                                      payment.paymentFor == "Installation"
                                  ? Container()
                                  : Divider(
                                      height: 10.0,
                                    ),
                              ListTile(
                                title: Text(payment.paymentFor),
                                trailing: Text("Rs. " + payment.amountPaid,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
                              ),
                              payment.outstanding == ""
                                  ? Container()
                                  : Divider(
                                      height: 10.0,
                                    ),
                              payment.outstanding == ""
                                  ? Container()
                                  : Text(
                                      "Outstanding Amount : Rs. " +
                                          payment.outstanding,
                                      style: TextStyle(fontSize: 14.0),
                                      textAlign: TextAlign.left,
                                    ),
                              Divider(
                                height: 20.0,
                              ),
                              new Row(
                                children: <Widget>[
                                  Text("Mode : " + payment.paymentMode,
                                      textAlign: TextAlign.left),
                                  Container(
                                    height: 15.0,
                                    width: 1.0,
                                    color: Colors.white30,
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                  ),
                                  Expanded(
                                      child: Text(
                                          !now
                                              ? payment.created.isNotEmpty
                                                  ? "Collected by : " +
                                                      payment
                                                          .created[0].userName
                                                  : ""
                                              : "Collected by : " +
                                                  user.userName,
                                          textAlign: TextAlign.right)),
                                ],
                              ),
                              Divider(),
                              mobileView(payment, user),
                              Divider(),
                              payment.ccomment != null &&
                                      payment.ccomment.isNotEmpty &&
                                      payment.ccomment != "" &&
                                      payment.ccomment.trim() != null &&
                                      payment.ccomment.trim().isNotEmpty &&
                                      payment.ccomment.trim() != ""
                                  ? new Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Text(
                                                "Note: " + payment.ccomment,
                                                textAlign: TextAlign.left)),
                                      ],
                                    )
                                  : Container(),
                              payment.ccomment != null &&
                                      payment.ccomment.isNotEmpty &&
                                      payment.ccomment != "" &&
                                      payment.ccomment.trim() != null &&
                                      payment.ccomment.trim().isNotEmpty &&
                                      payment.ccomment.trim() != ""
                                  ? Divider()
                                  : Container(),
                              Center(
                                child: RaisedButton(
                                  padding: EdgeInsets.all(6.0),
                                  child: Text(
                                    "PRINT",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.green,
                                  onPressed: () {
                                    _printBill(payment, general[0], now);
                                  },
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ));
}

List<General> general = [];

generalSetting(Payment payment) async {
  generalList(payment.customerData.lcoId).then((response) {
    if (response.statusCode == 200) {
      general = generalsFromJson(Utf8Codec().decode(response.bodyBytes));
    }
  }).catchError((error) {
    print(error);
  });
  if (general == null || general.isEmpty) {
    generalList("null").then((response) {
      if (response.statusCode == 200) {
        general = generalsFromJson(Utf8Codec().decode(response.bodyBytes));
      }
    }).catchError((error) {
      print(error);
    });
    if (general == null || general.isEmpty) {
      general = await AppSharedPreferences.getGeneralSettings();
    }
  }
}

Widget mobileView(Payment payment, LoginResponse user) {
  generalSetting(payment);
  if (payment.customerData.address.mobile != "") {
    return Row(
      children: <Widget>[
        Icon(Icons.phone_android, color: Colors.black54),
        SizedBox(width: 5.0),
        Text(payment.customerData.address.mobile,
            style: TextStyle(fontSize: 16.0, color: Colors.black87)),
        Expanded(
            child: FloatingActionButton(
                elevation: 1.0,
                mini: true,
                onPressed: () => _whatsAppOpen(payment, general[0], user),
                backgroundColor: Colors.green,
                child: Image.asset("assets/images/whatsapp.png", width: 35.0))),
        Expanded(
            child: FloatingActionButton(
          elevation: 1.0,
          mini: true,
          onPressed: () => _sendSMS(payment, general[0], user),
          backgroundColor: Colors.cyan,
          child: new Icon(Icons.message, color: Colors.white),
        )),
        Expanded(
            child: FloatingActionButton(
          elevation: 1.0,
          mini: true,
          onPressed: () => _shareImage(payment, general[0], user),
          backgroundColor: Colors.blue,
          child: new Icon(Icons.share, color: Colors.white),
        )),
      ],
    );
  } else
    return Container();
}

Future<void> _whatsAppOpen(
    Payment payment, General general, LoginResponse user) async {
  var formatter = new DateFormat("dd-MM-yyyy");
  if (payment.paymentFor.toLowerCase().contains("cable")) {
    FlutterOpenWhatsapp.sendSingleMessage(
        "+91" + payment.customerData.address.mobile,
        "Hi " +
            payment.customerData.customerName +
            ", thanks for payment of Rs. " +
            payment.amountPaid +
            " on " +
            formatter.format(
                DateTime.tryParse(payment.createdAt.toString()).toLocal()) +
            " - " +
            general.lcoName +
            ". For Online Payment in future : https://app.getsvs.in/%23/pay/" +
            user.operatorId +
            "/" +
            payment.customerData.customerId);
  } else if (payment.paymentFor.toLowerCase().contains("internet")) {
    FlutterOpenWhatsapp.sendSingleMessage(
        "+91" + payment.customerData.address.mobile,
        "Hi " +
            payment.customerData.customerName +
            ", thanks for payment of Rs. " +
            payment.amountPaid +
            " on " +
            formatter.format(
                DateTime.tryParse(payment.createdAt.toString()).toLocal()) +
            " - " +
            general.lcoName +
            ". For Online Payment in future : https://app.getsvs.in/%23/ipay/" +
            user.operatorId +
            "/" +
            payment.customerData.customerId);
  } else {
    FlutterOpenWhatsapp.sendSingleMessage(
        "+91" + payment.customerData.address.mobile,
        "Hi " +
            payment.customerData.customerName +
            ", thanks for payment of Rs. " +
            payment.amountPaid +
            " on " +
            formatter.format(
                DateTime.tryParse(payment.createdAt.toString()).toLocal()) +
            " - " +
            general.lcoName +
            ".");
  }
}

Future<void> _shareImage(
    Payment payment, General general, LoginResponse user) async {
  var formatter = new DateFormat("dd-MM-yyyy");
  print(formatter
      .format(DateTime.tryParse(payment.createdAt.toString()).toLocal()));
  String gstin = "";
  gstin = await AppSharedPreferences.getTaxSetting();

  gstin == null || gstin.isEmpty || gstin == null || gstin == ""
      ? gstin = ""
      : gstin = "GSTIN: " + gstin;
  String htmlContent = """
  <!DOCTYPE html>
<html lang="en">
<style>
    body {
        margin: 0;
        padding: 0;
    }

    html {
        margin: 0;
        padding: 0;
    }

    p {
        margin: 0;
        padding: 0;
    }
</style>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>

<body>
    <div>
        <div
            style='padding-right: 4.5%;justify-content: space-between;margin-bottom: 25px;padding-left: 4.5%;padding-top:15px;padding-bottom:15px;text-align: center;background-color: #f4f4f4'>
            <div style=' align-items:center '>
            <img class="img-responsive display-block ng-star-inserted" width="150" src=${general.operatorLogo}>
                <h3>""" +
      general.lcoName +
      """</h3>
                <p>""" +
      general.address +
      """</p>
                <p>Phone: """ +
      general.phoneNumber +
      """, """ +
      general.alternateNumber +
      """</p>
                <p>GST : """ +
      gstin +
      """</p>
                <hr />
            </div>
            <div>
                <p style='text-align: left'> Bill Number : """ +
      payment.invoiceId +
      """</p>
                <p style='text-align: right'> Date : """ +
      formatter
          .format(DateTime.tryParse(payment.createdAt.toString()).toLocal()) +
      """</p>
            </div>
            <div style="margin-top: 20px;">
                <div style='text-align: left'>
                    <p>""" +
      payment.customerData.customerName +
      """</p>
                    <p>""" +
      payment.customerData.address.doorNo +
      """ """ +
      payment.customerData.address.houseName +
      """ """ +
      payment.customerData.address.street +
      """ """ +
      payment.customerData.address.area +
      """ """ +
      payment.customerData.address.city +
      """</p>
                </div>
                <p style='text-align: right'> """ +
      payment.customerData.customerId +
      """</p>
            </div>
            <hr />
            <div style='padding-left: 4.5%;padding-right: 4.5%; margin-top: 20px;'>
                <div style='box-shadow: 1px 4px 8px #EEEEEE;border-radius: 8px;border: 0.5px solid #E0E0E0;'>
                    <div>
                        <div
                            style="padding: 16px;display:flex;margin-bottom:16.5px;border-bottom: 0.5px solid #E0e0e0;">
                            <div style="width: 50%; border-right: 0.5px solid #E0E0E0">
                                <p style="color:#424242;font-size:20px;font-weight:bold">Description </p>
                            </div>
                            <div style="width: 50%;margin-left: 20px">
                                <p style="color:#424242;font-size:20px;font-weight:bold">Amount </p>
                            </div>
                        </div>
                        <div style="padding-left: 16px;padding-right: 16px;display:flex;margin-bottom:16.5px;">
                            <div style="width: 50%; border-right: 0.5px solid #E0E0E0">
                                <p style="color:#757575;margin-bottom:8px;font-weight:600"> """ +
      payment.paymentFor +
      """</p>
                            </div>
                            <div style="width: 50%;margin-left: 20px">
                                <p style="color:#757575;margin-bottom:8px;font-weight:600">""" +
      ((payment.discount != null &&
              payment.discount.isNotEmpty &&
              payment.discount != "" &&
              double.tryParse(payment.discount) > 0.0)
          ? (double.tryParse(payment.amountPaid) +
                  double.tryParse(payment.discount))
              .round()
              .toString()
          : double.tryParse(payment.amountPaid).round().toString()) +
      """</p>
                            </div>
                        </div>
           """ +
      ((payment.discount != null &&
              payment.discount.isNotEmpty &&
              payment.discount != "" &&
              double.tryParse(payment.discount) > 0.0)
          ? ("""<div style="padding-left: 16px;padding-right: 16px;display:flex;margin-bottom:16.5px;">
                            <div style="width: 50%; border-right: 0.5px solid #E0E0E0">
                                <p style="color:#757575;margin-bottom:8px;font-weight:600"> Discount</p>
                            </div>
                            <div style="width: 50%;margin-left: 20px">
                                <p style="color:#757575;margin-bottom:8px;font-weight:600">""" +
              double.tryParse(payment.discount).round().toString() +
              """</p>
                            </div>
                        </div>""")
          : """""") +
      ((payment.maintananceFee != null &&
              payment.maintananceFee.isNotEmpty &&
              payment.maintananceFee != "" &&
              double.tryParse(payment.maintananceFee) > 0.0)
          ? ("""<div style="padding-left: 16px;padding-right: 16px;display:flex;margin-bottom:16.5px;">
                            <div style="width: 50%; border-right: 0.5px solid #E0E0E0">
                                <p style="color:#757575;margin-bottom:8px;font-weight:600"> Maintenance Fee </p>
                            </div>
                            <div style="width: 50%;margin-left: 20px">
                                <p style="color:#757575;margin-bottom:8px;font-weight:600">""" +
              double.tryParse(payment.maintananceFee).round().toString() +
              """</p>
                            </div>
                        </div>""")
          : """""") +
      """<div style="padding: 10px;display:flex;margin-bottom:16.5px;border-top: 0.5px solid #E0e0e0;">
                            <div style="width: 50%; border-right: 0.5px solid #E0E0E0">
                                <p style="color:#424242;font-size:20px;font-weight:bold">Total </p>
                            </div>
                            <div style="width: 50%;margin-left: 20px">
                                <p style="color:#424242;font-size:20px;font-weight:bold">""" +
      double.tryParse(payment.amountPaid).round().toString() +
      """ </p>
                            </div>
                        </div>
                        <div style="height: 35px;border-top: 0.5px solid #E0E0E0; display: flex; align-items: center;">
                            <p style="margin: 16px; color: #424242;font-size: 12px;font-weight:600">Collected by : 2625
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <div>
            </div>
        </div>
    </div>
</body>

</html>
  """;
  Map<Permission, PermissionStatus> permissions =
      await [Permission.storage].request();
  if (permissions[Permission.storage].isGranted) {
    Directory appDir = await getApplicationDocumentsDirectory();
    var targetPath = appDir.path;
    var targetFileName =
        "Payment on " + DateFormat('hh:mm:ss').format(DateTime.now());
    String fileName = targetFileName;
    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, targetPath, targetFileName);
    String generatedPdfFilePath = generatedPdfFile.path;
    Share.shareFiles(
      ['$generatedPdfFilePath'],
      subject: fileName,
    );
  }
}

Future<void> _sendSMS(
    Payment payment, General general, LoginResponse user) async {
  var formatter = new DateFormat("dd-MM-yyyy");
  final SimpleSms simpleSms = SimpleSms();
  List<String> address = ["+91" + payment.customerData.address.mobile];
  if (payment.paymentFor.toLowerCase().contains("cable")) {
    simpleSms.sendSms(
        address,
        "Hi " +
            payment.customerData.customerName +
            ", thanks for payment of Rs. " +
            payment.amountPaid +
            " on " +
            formatter.format(
                DateTime.tryParse(payment.createdAt.toString()).toLocal()) +
            " - " +
            general.lcoName +
            ". For Online Payment in future : https://app.getsvs.in/#/pay/" +
            user.operatorId +
            "/" +
            payment.customerData.customerId);
  } else if (payment.paymentFor.toLowerCase().contains("internet")) {
    simpleSms.sendSms(
        address,
        "Hi " +
            payment.customerData.customerName +
            ", thanks for payment of Rs. " +
            payment.amountPaid +
            " on " +
            formatter.format(
                DateTime.tryParse(payment.createdAt.toString()).toLocal()) +
            " - " +
            general.lcoName +
            ". For Online Payment in future : https://app.getsvs.in/#/ipay/" +
            user.operatorId +
            "/" +
            payment.customerData.customerId);
  } else {
    simpleSms.sendSms(
        address,
        "Hi " +
            payment.customerData.customerName +
            ", thanks for payment of Rs. " +
            payment.amountPaid +
            " on " +
            formatter.format(
                DateTime.tryParse(payment.createdAt.toString()).toLocal()) +
            " - " +
            general.lcoName +
            ".");
  }
  // if (payment.paymentFor.toLowerCase().contains("cable")) {
  //   simpleSms.sendSms(
  //       address,
  //       "Hi " +
  //           payment.customerData.customerName +
  //           " [  ID: " +
  //           payment.customerData.customerId +
  //           " ], We have received the payment of Rs. " +
  //           payment.amountPaid +
  //           " for SMR CABLE NETWORK settop box recharge.Balance due: Rs. " +
  //           payment.customerData.cable.cableOutstandingAmount +
  //           ". To pay instantly with easy online payment in future just click here " +
  //           "https://app.getsvs.in/#/pay/" +
  //           user.operatorId +
  //           "/" +
  //           payment.customerData.customerId);
  // } else if (payment.paymentFor.toLowerCase().contains("internet")) {
  //   simpleSms.sendSms(
  //       address,
  //       "Hi " +
  //           payment.customerData.customerName +
  //           " [  ID: " +
  //           payment.customerData.customerId +
  //           " ], We have received the payment of Rs. " +
  //           payment.amountPaid +
  //           " for SMR CABLE NETWORK settop box recharge.Balance due: Rs. " +
  //           payment.customerData.internet.internetOutstandingAmount +
  //           ". To pay instantly with easy online payment in future just click here " +
  //           "https://app.getsvs.in/#/ipay/" +
  //           user.operatorId +
  //           "/" +
  //           payment.customerData.customerId);
  // } else {
  //   simpleSms.sendSms(
  //       address,
  //       "Hi " +
  //           payment.customerData.customerName +
  //           " [  ID: " +
  //           payment.customerData.customerId +
  //           " ], We have received the payment of Rs. " +
  //           payment.amountPaid +
  //           " for " +
  //           payment.paymentFor +
  //           ".");
  // }
}

Future<void> _printBill(Payment payment, General general, bool now) async {
  var formatter = new DateFormat("dd-MM-yyyy hh:mm aaa");
  LoginResponse user = await AppSharedPreferences.getUserProfile();
  String paperSize = await AppSharedPreferences.getPaperSize();
  String userName = "";
  String dateTime = "";
  String printData = "";
  String mainpackagesubs = "";
  List<String> subpackagesub = [];
  List<String> channelsub = [];
  String subpackagesubs = "";
  String channelsubs = "";
  double subtotal;
  double gst;
  double total;
  var currency = NumberFormat("##,##,##0.00");
  String detailedBill = await AppSharedPreferences.getDetailedBill();
  String gstin = "";

  if (payment.ccomment == null) {
    payment.ccomment = "";
  }

  if (detailedBill == "Yes") {
    if (payment.boxDetails[0].mainPackage.packageName != null) {
      if (payment.boxDetails[0].mainPackage.packageName.length > 33) {
        mainpackagesubs =
            payment.boxDetails[0].mainPackage.packageName.substring(0, 30) +
                "...   " +
                "Rs. " +
                currency.format(double.tryParse(
                    payment.boxDetails[0].mainPackage.packageCost)) +
                "\x0A";
      } else {
        int spacecount =
            33 - payment.boxDetails[0].mainPackage.packageName.length;
        String space = "";
        for (var i = 0; i < spacecount; i++) {
          space = space + " ";
        }
        mainpackagesubs = payment.boxDetails[0].mainPackage.packageName +
            space +
            "   Rs. " +
            currency.format(double.tryParse(
                payment.boxDetails[0].mainPackage.packageCost)) +
            "\x0A";
      }
    }

    if (payment.boxDetails[0].addonPackage.subPackages != null) {
      for (var i = 0;
          i < payment.boxDetails[0].addonPackage.subPackages.length;
          i++) {
        if (payment.boxDetails[0].addonPackage.subPackages[i].packageName !=
            null) {
          if (payment.boxDetails[0].addonPackage.subPackages[i].packageName
                  .length >
              33) {
            subpackagesub.add(payment
                    .boxDetails[0].addonPackage.subPackages[i].packageName
                    .substring(0, 30) +
                "...   " +
                "Rs. " +
                currency.format(double.tryParse(payment
                    .boxDetails[0].addonPackage.subPackages[i].packageCost)) +
                "\x0A");
          } else {
            int spacecount = 33 -
                payment.boxDetails[0].addonPackage.subPackages[i].packageName
                    .length;
            String space = "";
            for (var i = 0; i < spacecount; i++) {
              space = space + " ";
            }
            subpackagesub.add(
                payment.boxDetails[0].addonPackage.subPackages[i].packageName +
                    space +
                    "   Rs. " +
                    currency.format(double.tryParse(payment.boxDetails[0]
                        .addonPackage.subPackages[i].packageCost)) +
                    "\x0A");
          }
        }
      }
    }

    if (payment.boxDetails[0].addonPackage.channels != null) {
      for (var i = 0;
          i < payment.boxDetails[0].addonPackage.channels.length;
          i++) {
        if (payment.boxDetails[0].addonPackage.channels[i].channelName !=
            null) {
          if (payment
                  .boxDetails[0].addonPackage.channels[i].channelName.length >
              33) {
            channelsub.add(payment
                    .boxDetails[0].addonPackage.channels[i].channelName
                    .substring(0, 30) +
                "...   " +
                "Rs. " +
                currency.format(double.tryParse(payment
                    .boxDetails[0].addonPackage.channels[i].channelCost)) +
                "\x0A");
          } else {
            int spacecount = 33 -
                payment
                    .boxDetails[0].addonPackage.channels[i].channelName.length;
            String space = "";
            for (var i = 0; i < spacecount; i++) {
              space = space + " ";
            }
            channelsub.add(
                payment.boxDetails[0].addonPackage.channels[i].channelName +
                    space +
                    "   Rs. " +
                    currency.format(double.tryParse(payment
                        .boxDetails[0].addonPackage.channels[i].channelCost)) +
                    "\x0A");
          }
        }
      }
    }

    if (subpackagesub.isNotEmpty || subpackagesub != null) {
      for (var i = 0; i < subpackagesub.length; i++) {
        subpackagesubs = subpackagesubs + subpackagesub[i];
      }
    }
    if (channelsub.isNotEmpty || channelsub != null) {
      for (var i = 0; i < channelsub.length; i++) {
        channelsubs = channelsubs + channelsub[i];
      }
    }
    subtotal = double.tryParse(
            payment.boxDetails[0].addonPackage.packageCost.isNotEmpty
                ? payment.boxDetails[0].addonPackage.packageCost
                : "0.0") +
        double.tryParse(payment.boxDetails[0].mainPackage.packageCost.isNotEmpty
            ? payment.boxDetails[0].mainPackage.packageCost
            : "0.0");
    gst = subtotal * 0.18;
    total = subtotal + gst;

    gstin = await AppSharedPreferences.getTaxSetting();

    gstin == null || gstin.isEmpty || gstin == null || gstin == ""
        ? gstin = ""
        : gstin = "GSTIN: " + gstin;
  }
  if (now) {
    dateTime = DateTime.now().toString();
    userName = user.userName;
  } else {
    dateTime = payment.createdAt;
    userName = payment.created.isNotEmpty ? payment.created[0].userName : "";
  }
  if (user.operatorId == "OM_MURUGA_CABLE_NETOWRK_CHENNAI") {
    if (payment.maintananceFee != null &&
        payment.maintananceFee.isNotEmpty &&
        payment.maintananceFee != "" &&
        double.tryParse(payment.maintananceFee) > 0.0) {
      if (payment.ccomment != null &&
          payment.ccomment.isNotEmpty &&
          payment.ccomment != "" &&
          payment.ccomment.trim() != null &&
          payment.ccomment.trim().isNotEmpty &&
          payment.ccomment.trim() != "") {
        if (payment.discount != null &&
            payment.discount.isNotEmpty &&
            payment.discount != "" &&
            double.tryParse(payment.discount) > 0.0) {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount               Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee        Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Total                : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount   : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "                         Discount : Rs. " +
                currency.format(double.tryParse(payment.discount)).toString() +
                "\x0A" +
                "                  Maintenance Fee : Rs. " +
                currency
                    .format(double.tryParse(payment.maintananceFee))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(total -
                        double.tryParse(payment.discount) +
                        double.tryParse(payment.maintananceFee)))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount                        Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee                 Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Total                         : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount            : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        } else {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee      Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Total              : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "                  Maintenance Fee : Rs. " +
                currency
                    .format(double.tryParse(payment.maintananceFee))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(
                        total + double.tryParse(payment.maintananceFee)))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee                 Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Total                         : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        }
      } else {
        if (payment.discount != null &&
            payment.discount.isNotEmpty &&
            payment.discount != "" &&
            double.tryParse(payment.discount) > 0.0) {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount               Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee        Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Total                : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount   : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "                         Discount : Rs. " +
                currency.format(double.tryParse(payment.discount)).toString() +
                "\x0A" +
                "                  Maintenance Fee : Rs. " +
                currency
                    .format(double.tryParse(payment.maintananceFee))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(total -
                        double.tryParse(payment.discount) +
                        double.tryParse(payment.maintananceFee)))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount                        Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee                 Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Total                         : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount            : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        } else {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee      Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Total              : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "                  Maintenance Fee : Rs. " +
                currency
                    .format(double.tryParse(payment.maintananceFee))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(
                        total + double.tryParse(payment.maintananceFee)))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee                 Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Total                         : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount            : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        }
      }
    } else {
      if (payment.ccomment != null &&
          payment.ccomment.isNotEmpty &&
          payment.ccomment != "" &&
          payment.ccomment.trim() != null &&
          payment.ccomment.trim().isNotEmpty &&
          payment.ccomment.trim() != "") {
        if (payment.discount != null &&
            payment.discount.isNotEmpty &&
            payment.discount != "" &&
            double.tryParse(payment.discount) > 0.0) {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount               Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Total              : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "                         Discount : Rs. " +
                currency.format(double.tryParse(payment.discount)).toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(total - double.tryParse(payment.discount)))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount                        Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Total                         : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount            : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        } else {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(total)).toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        }
      } else {
        if (payment.discount != null &&
            payment.discount.isNotEmpty &&
            payment.discount != "" &&
            double.tryParse(payment.discount) > 0.0) {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount               Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Total              : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "                         Discount : Rs. " +
                currency.format(double.tryParse(payment.discount)).toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(total - double.tryParse(payment.discount)))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount                        Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Total                         : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount            : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        } else {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(total)).toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "Website: www.ommurugacabletvnetwork.com" +
                "\x0A" +
                "Email: ommurugactv@gmail.com" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        }
      }
    }
  } else {
    if (payment.maintananceFee != null &&
        payment.maintananceFee.isNotEmpty &&
        payment.maintananceFee != "" &&
        double.tryParse(payment.maintananceFee) > 0.0) {
      if (payment.ccomment != null &&
          payment.ccomment.isNotEmpty &&
          payment.ccomment != "" &&
          payment.ccomment.trim() != null &&
          payment.ccomment.trim().isNotEmpty &&
          payment.ccomment.trim() != "") {
        if (payment.discount != null &&
            payment.discount.isNotEmpty &&
            payment.discount != "" &&
            double.tryParse(payment.discount) > 0.0) {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount               Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee        Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Total                : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount   : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "                         Discount : Rs. " +
                currency.format(double.tryParse(payment.discount)).toString() +
                "\x0A" +
                "                  Maintenance Fee : Rs. " +
                currency
                    .format(double.tryParse(payment.maintananceFee))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(total -
                        double.tryParse(payment.discount) +
                        double.tryParse(payment.maintananceFee)))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount                        Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee                 Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Total                         : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount            : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        } else {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee      Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Total              : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "                  Maintenance Fee : Rs. " +
                currency
                    .format(double.tryParse(payment.maintananceFee))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(
                        total + double.tryParse(payment.maintananceFee)))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee                 Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Total                         : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        }
      } else {
        if (payment.discount != null &&
            payment.discount.isNotEmpty &&
            payment.discount != "" &&
            double.tryParse(payment.discount) > 0.0) {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount               Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee        Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Total                : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount   : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "                         Discount : Rs. " +
                currency.format(double.tryParse(payment.discount)).toString() +
                "\x0A" +
                "                  Maintenance Fee : Rs. " +
                currency
                    .format(double.tryParse(payment.maintananceFee))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(total -
                        double.tryParse(payment.discount) +
                        double.tryParse(payment.maintananceFee)))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount                        Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee                 Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Total                         : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount            : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        } else {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee      Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Total              : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "                  Maintenance Fee : Rs. " +
                currency
                    .format(double.tryParse(payment.maintananceFee))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(
                        total + double.tryParse(payment.maintananceFee)))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Maintenance Fee                 Rs." +
                payment.maintananceFee +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Total                         : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount            : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        }
      }
    } else {
      if (payment.ccomment != null &&
          payment.ccomment.isNotEmpty &&
          payment.ccomment != "" &&
          payment.ccomment.trim() != null &&
          payment.ccomment.trim().isNotEmpty &&
          payment.ccomment.trim() != "") {
        if (payment.discount != null &&
            payment.discount.isNotEmpty &&
            payment.discount != "" &&
            double.tryParse(payment.discount) > 0.0) {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount               Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Total              : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "                         Discount : Rs. " +
                currency.format(double.tryParse(payment.discount)).toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(total - double.tryParse(payment.discount)))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount                        Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Total                         : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount            : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        } else {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(total)).toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "Comment :" +
                "\x0A" +
                payment.ccomment +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        }
      } else {
        if (payment.discount != null &&
            payment.discount.isNotEmpty &&
            payment.discount != "" &&
            double.tryParse(payment.discount) > 0.0) {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount               Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Total              : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "                         Discount : Rs. " +
                currency.format(double.tryParse(payment.discount)).toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(total - double.tryParse(payment.discount)))
                    .toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                (double.tryParse(payment.amountPaid) +
                        double.tryParse(payment.discount))
                    .round()
                    .toString() +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Discount                        Rs." +
                payment.discount +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Total                         : Rs." +
                payment.amountPaid +
                "\x0A" +
                "Outstanding Amount            : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        } else {
          if (paperSize == "2 inch" && detailedBill == "No") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "\x0A" +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x31" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "             Amount" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "     Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "-------------------------------" +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else if (paperSize == "3 inch" && detailedBill == "Yes") {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                gstin +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Subscription" +
                "                        Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                mainpackagesubs +
                subpackagesubs +
                channelsubs +
                "------------------------------------------------" +
                "\x0A" +
                "                         Subtotal : Rs. " +
                (currency.format(subtotal)).toString() +
                "\x0A" +
                "                       GST( 18% ) : Rs. " +
                (currency.format(gst)).toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                            Total : Rs. " +
                (currency.format(total)).toString() +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "                      Paid Amount : Rs." +
                payment.amountPaid +
                "\x0A" +
                "               Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          } else {
            printData = "\x1B" +
                "\x40" +
                "\x1B" +
                "\x61" +
                "\x31" +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "\x0A" +
                "\x0A" +
                general.lcoName +
                "\x0A" +
                "\x1B" +
                "\x45" +
                "\x0A" +
                general.address +
                "\x0A" +
                "Phone: " +
                general.phoneNumber +
                " " +
                general.alternateNumber +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Bill No: " +
                payment.invoiceId +
                "         " +
                "Date: " +
                formatter.format(DateTime.tryParse(dateTime).toLocal()) +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                "Customer: " +
                payment.customerData.customerName +
                "\x0A" +
                "ID: " +
                payment.customerData.customerId +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                payment.customerData.address.doorNo +
                " " +
                payment.customerData.address.houseName +
                " " +
                payment.customerData.address.street +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x4D" +
                "\x30" +
                "Description" +
                "                     Amount" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "\x1B" +
                "\x61" +
                "\x30" +
                payment.paymentFor +
                "\x1B" +
                "\x45" +
                "\x0D" +
                "              Rs." +
                payment.amountPaid +
                "\x1B" +
                "\x45" +
                "\x0A" +
                "\x0A" +
                "------------------------------------------------" +
                "\x0A" +
                "Outstanding Amount : Rs." +
                payment.outstanding +
                "\x0A" +
                "Payment Mode: " +
                payment.paymentMode +
                "  | " +
                "Collected by : " +
                userName +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x0A" +
                "\x1B" +
                "\x69";
          }
        }
      }
    }
  }

  // print(printData);

  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  BluetoothDevice _device;
  List<BluetoothDevice> devices = [];

  try {
    devices = await bluetooth.getBondedDevices();
  } on PlatformException catch (e) {
    print(e);
  }

  String deviceName = await AppSharedPreferences.getDeviceName();

  devices.forEach((device) {
    if (device.name == deviceName) {
      _device = device;
    }
  });

  bluetooth.isConnected.then((isConnected) async {
    if (isConnected) {
      bluetooth.write(printData);
    } else {
      await bluetooth.connect(_device).then((_) {
        bluetooth.isConnected.then((isConnected) async {
          if (isConnected) {
            bluetooth.write(printData);
          }
        });
      }).catchError((error) {
        print(error);
      });
    }
  }).catchError((error) {
    print(error);
  });
}
