import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svs/models/customer.dart';
import 'package:svs/models/login-response.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:svs/screens/customers/add_customer_payment_screen.dart';
import 'package:svs/screens/customers/add_customer_complaint_screen.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:svs/screens/customers/customer_full_detail.dart';
import 'package:svs/screens/customers/edit_customer_screen.dart';
import 'package:intl/intl.dart';

var formatter = NumberFormat("##,##,##0.00");
LoginResponse user;

Future<void> initUserProfile() async {
  try {
    LoginResponse up = await AppSharedPreferences.getUserProfile();
    user = up;
  } catch (e) {
    print(e);
  }
}

customerView(BuildContext context, Customer customer) {
  initUserProfile();
  double cable = 0;
  double internet = 0;

  if (customer.cable.cableOutstandingAmount != null &&
      customer.cable.cableOutstandingAmount != "") {
    try {
      cable = double.parse(customer.cable.cableOutstandingAmount);
    } catch (e) {}
  }
  if (customer.internet.internetOutstandingAmount != null &&
      customer.internet.internetOutstandingAmount != "") {
    try {
      internet = double.parse(customer.internet.internetOutstandingAmount);
    } catch (e) {}
  }

  double total = cable + internet;
  double cabler = 0;
  double internetr = 0;
  if (customer.cable.cableMonthlyRent != null &&
      customer.cable.cableMonthlyRent != "") {
    try {
      cabler = double.parse(customer.cable.cableMonthlyRent);
    } catch (e) {}
  }
  if (customer.internet.internetMonthlyRent != null &&
      customer.internet.internetMonthlyRent != "") {
    try {
      internetr = double.parse(customer.internet.internetMonthlyRent);
    } catch (e) {}
  }

  double rent = cabler + internetr;

  var boxes = List<Widget>();

  if (customer.cable.boxDetails != null &&
      customer.cable.boxDetails.isNotEmpty) {
    for (var i = 0; i < customer.cable.boxDetails.length; i++) {
      var box = _boxDetailView(customer.cable.boxDetails[i]);
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
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         new MaterialPageRoute(
                            //             builder: (BuildContext context) =>
                            //                 CustomerFullDetails(
                            //                   customer: customer,
                            //                 )));
                            //   },
                            //   child: ListTile(
                            //       trailing: IconButton(
                            //         onPressed: () {
                            //           Navigator.push(
                            //               context,
                            //               new MaterialPageRoute(
                            //                   builder: (BuildContext context) =>
                            //                       EditCustomerScreenTest(
                            //                           customer: customer)));
                            //         },
                            //         icon: Row(
                            //           children: <Widget>[
                            //             Icon(Icons.edit),
                            //           ],
                            //         ),
                            //       ),
                            //       dense: true,
                            //       leading: Container(
                            //           decoration: BoxDecoration(
                            //               borderRadius:
                            //                   BorderRadius.circular(50.0),
                            //               border: Border.all(
                            //                   width: 2.0,
                            //                   color:
                            //                       customer.activeStatus == true
                            //                           ? Colors.green
                            //                           : Colors.redAccent[100])),
                            //           child: CircleAvatar(
                            //             radius: 20.0,
                            //             child: Text(
                            //               customer.customerName[0]
                            //                   .toUpperCase(),
                            //               style: TextStyle(
                            //                   fontWeight: FontWeight.bold,
                            //                   fontSize: 26.0),
                            //             ),
                            //           )),
                            //       title: Text(
                            //           customer.customerName.toUpperCase(),
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.bold,
                            //               fontSize: 16.0)),
                            //       subtitle: Row(
                            //         children: <Widget>[
                            //           Container(
                            //             margin: EdgeInsets.only(right: 5.0),
                            //             height: 14.0,
                            //             width: 14.0,
                            //             decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(30.0),
                            //                 color: customer.activeStatus == true
                            //                     ? Colors.green
                            //                     : Colors.red),
                            //           ),
                            //           Text("ID : " + customer.customerId,
                            //               style: TextStyle(
                            //                   fontWeight: FontWeight.bold,
                            //                   fontSize: 14.0)),
                            //         ],
                            //       )),
                            // ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CustomerFullDetails(
                                              customer: customer,
                                            )));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          border: Border.all(
                                              width: 2.0,
                                              color:
                                                  customer.activeStatus == true
                                                      ? Colors.green
                                                      : Colors.redAccent[100])),
                                      child: CircleAvatar(
                                        radius: 20.0,
                                        child: Text(
                                          customer.customerName[0]
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26.0),
                                        ),
                                      )),
                                  Container(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            customer.customerName.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0)),
                                        Container(
                                          height: 5.0,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 5.0),
                                              height: 14.0,
                                              width: 14.0,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  color:
                                                      customer.activeStatus ==
                                                              true
                                                          ? Colors.green
                                                          : Colors.red),
                                            ),
                                            Text("ID : " + customer.customerId,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                    color: Colors.grey)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  user.userType == "Admin"
                                      ? FloatingActionButton(
                                          backgroundColor: Color(0xffae275f),
                                          mini: true,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        EditCustomerScreen(
                                                            customer:
                                                                customer)));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.edit,
                                                size: 16.0,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            Container(
                              height: 5.0,
                            ),
                            Text(
                              customer.address.doorNo +
                                  ' ' +
                                  customer.address.houseName +
                                  ' ' +
                                  customer.address.street +
                                  ' ' +
                                  customer.address.area +
                                  ' ' +
                                  customer.address.city,
                              style: TextStyle(color: Colors.black54),
                            ),
                            Divider(),
                            mobileView(customer),
                            Divider(),
                            Text(customer.cable.noCableConnection == null
                                ? ''
                                : "Number of Connections : " +
                                    customer.cable.noCableConnection
                                        .toString()),
                            Divider(),
                            customer.cable.boxDetails == null
                                ? 0
                                : Column(
                                    // children: boxes,
                                    children: <Widget>[
                                      Material(
                                        elevation: 2.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
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
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
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
                            new Row(
                              children: <Widget>[
                                Expanded(
                                    child: Container(
                                        child: ListTile(
                                            title: Center(
                                              child: Text(
                                                "Rs." + rent.toString(),
                                                style: TextStyle(
                                                    color: Colors.pinkAccent,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ),
                                            subtitle: Center(
                                                child: Text(
                                                    "Monthly Subscription",
                                                    style: TextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight: FontWeight
                                                            .bold)))))),
                                Expanded(
                                    child: Container(
                                        child: ListTile(
                                            title: Center(
                                                child: Text(
                                                    "Rs." + total.toString(),
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18.0))),
                                            subtitle: Center(
                                                child: Text(
                                                    "Outstanding Amount",
                                                    style: TextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight: FontWeight
                                                            .bold))))))
                              ],
                            ),
                            new Row(
                              children: <Widget>[
                                Expanded(
                                  child: FloatingActionButton(
                                    mini: true,
                                    shape: StadiumBorder(),
                                    backgroundColor: Colors.purple,
                                    foregroundColor: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AddCustomerComplaintScreen(
                                                      customer: customer)));
                                    },
                                    child: Text("+ Complaint"),
                                  ),
                                ),
                                Container(
                                  height: 20.0,
                                  width: 1.0,
                                  color: Colors.black38,
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                ),
                                Expanded(
                                  child: FloatingActionButton(
                                    mini: true,
                                    shape: StadiumBorder(),
                                    backgroundColor: Colors.indigo,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AddCustomerPaymentScreen(
                                                    customer: customer,
                                                    internet: false,
                                                  )));
                                    },
                                    foregroundColor: Colors.white,
                                    child: Text("+ Payment"),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
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

addComplaint() {}
Widget boxView(Customer customer) {
  return Text(customer.cable.boxDetails.isNotEmpty
      ? customer.cable.boxDetails[0].vcNo
      : 'No Box Details');
  // return ListView.builder(
  //   shrinkWrap: true,
  //     itemCount: customer.cable.boxDetails == null? 0: customer.cable.boxDetails.length,
  //     itemBuilder: (BuildContext context,int i) {
  //        Text(customer.cable.boxDetails[i].vcNo);
  //     }

  //   );
}

Widget mobileView(Customer customer) {
  if (customer.address.mobile != '') {
    return Row(
      children: <Widget>[
        Icon(Icons.phone_android, color: Colors.black54),
        SizedBox(width: 5.0),
        Text(customer.address.mobile,
            style: TextStyle(fontSize: 16.0, color: Colors.black87)),
        Expanded(
            child: FloatingActionButton(
                elevation: 1.0,
                mini: true,
                onPressed: () => launch(
                    "https://api.whatsapp.com/send?phone=+91" +
                        customer.address.mobile),
                backgroundColor: Colors.green,
                child: Image.asset('assets/images/whatsapp.png', width: 35.0))),
        Expanded(
            child: FloatingActionButton(
          elevation: 1.0,
          mini: true,
          onPressed: () => launch("sms:" + customer.address.mobile),
          backgroundColor: Colors.cyan,
          child: new Icon(Icons.message, color: Colors.white),
        )),
        Expanded(
            child: FloatingActionButton(
          elevation: 1.0,
          mini: true,
          onPressed: () => launch("tel:" + customer.address.mobile),
          backgroundColor: Colors.blue,
          child: new Icon(Icons.call, color: Colors.white),
        )),
      ],
    );
  } else
    return Container();
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
                Table(
                    border: TableBorder.all(width: 1.0, color: Colors.black45),
                    children: addons),
                SizedBox(
                  height: 0.5,
                ),
                Table(
                    border: TableBorder.all(width: 1.0, color: Colors.black45),
                    children: channels),
                SizedBox(
                  height: 1.0,
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
                                        // (formatter.format(((18 / 100) *
                                        //             (double.tryParse(box
                                        //                     .mainPackage
                                        //                     .packageCost) +
                                        //                 double.tryParse(box
                                        //                     .addonPackage
                                        //                     .packageCost))) +
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
