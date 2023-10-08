import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:svs/models/complaint.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:svs/services/basic_service.dart';
// import 'package:whatsapp_launch/whatsapp_launch.dart';
// import 'package:flutter_launch/flutter_launch.dart';
import 'package:simple_sms/simple_sms.dart';

import 'package:svs/models/login-response.dart';
import 'package:svs/screens/complaint/edit_complaint_screen.dart';

complaintView(BuildContext context, Complaint complaint, LoginResponse user) {
  var formatter = new DateFormat('dd-MM-yyyy hh:mm aaa');
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
                                  leading: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          border: Border.all(
                                              width: 2.0,
                                              color: complaint.customerData
                                                          .activeStatus ==
                                                      true
                                                  ? Colors.green
                                                  : Colors.redAccent[100])),
                                      child: CircleAvatar(
                                        radius: 20.0,
                                        child: Text(
                                          complaint.customerData.customerName[0]
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26.0),
                                        ),
                                      )),
                                  title: Text(
                                      complaint.customerData.customerName
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(right: 5.0),
                                        height: 14.0,
                                        width: 14.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            color: complaint.customerData
                                                        .activeStatus ==
                                                    true
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                      Text(
                                          "ID : " +
                                              complaint.customerData.customerId,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0)),
                                    ],
                                  )),
                              Text(
                                complaint.customerData.address.doorNo +
                                    ' ' +
                                    complaint.customerData.address.houseName +
                                    ' ' +
                                    complaint.customerData.address.street +
                                    ' ' +
                                    complaint.customerData.address.area +
                                    ' ' +
                                    complaint.customerData.address.city,
                                style: TextStyle(color: Colors.black54),
                              ),
                              Divider(),
                              mobileView(complaint),
                              Divider(),
                              Column(children: <Widget>[
                                Row(children: <Widget>[
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.black54,
                                  ),
                                  Container(
                                      width: 284,
                                      child: Text(complaint.complaintDetail,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0),
                                          textAlign: TextAlign.left))
                                ]),
                                Container(
                                  width: 320,
                                  child: Text(complaint.complaintRemarks,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 13.0)),
                                )
                              ]),
                              Divider(),
                              Row(children: <Widget>[
                                Expanded(
                                    child: Column(children: <Widget>[
                                  Text("Created at",
                                      style: TextStyle(color: Colors.black54)),
                                  Text(
                                    formatter.format(
                                        DateTime.tryParse(complaint.createdAt)
                                            .toLocal()),
                                    style: TextStyle(fontSize: 12.0),
                                    textAlign: TextAlign.left,
                                  )
                                ])),
                                Expanded(
                                  child: complaint.complaintStatus == 'closed'
                                      ? Column(
                                          children: <Widget>[
                                            Text(
                                              "Closed at ",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                            Text(
                                              formatter.format(
                                                  DateTime.tryParse(
                                                          complaint.closedAt)
                                                      .toLocal()),
                                              style: TextStyle(fontSize: 12.0),
                                              textAlign: TextAlign.right,
                                            )
                                          ],
                                        )
                                      : Container(),
                                ),
                                user.userType == "Admin" ||
                                        user.userName ==
                                            complaint.assigned[0].userName
                                    ? Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            complaint.complaintStatus ==
                                                    'closed'
                                                ? Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child:
                                                            FloatingActionButton(
                                                          mini: true,
                                                          shape:
                                                              StadiumBorder(),
                                                          backgroundColor:
                                                              Colors.red,
                                                          onPressed: () {
                                                            _confirmOpen(
                                                                context,
                                                                complaint);
                                                          },
                                                          foregroundColor:
                                                              Colors.white,
                                                          child:
                                                              Text("Re-Open"),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                // FlatButton(
                                                //     color: Colors.red,
                                                //     shape: StadiumBorder(),
                                                //     onPressed: () {
                                                //       _confirmOpen(
                                                //           context, complaint);
                                                //     },
                                                //     child: Text(
                                                //       "Re-Open",
                                                //       style: TextStyle(
                                                //           color: Colors.white),
                                                //     ))
                                                : Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child:
                                                            FloatingActionButton(
                                                          mini: true,
                                                          shape:
                                                              StadiumBorder(),
                                                          backgroundColor:
                                                              Colors.green,
                                                          onPressed: () {
                                                            _confirmClose(
                                                                context,
                                                                complaint);
                                                          },
                                                          foregroundColor:
                                                              Colors.white,
                                                          child: Text("Close"),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                            // FlatButton(
                                            //     color: Colors.green,
                                            //     shape: StadiumBorder(),
                                            //     onPressed: () {
                                            //       _confirmClose(
                                            //           context, complaint);
                                            //     },
                                            //     child: Text(
                                            //       "Close",
                                            //       style: TextStyle(
                                            //           color: Colors.white),
                                            //     )),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ]),
                              Divider(),
                              Row(children: <Widget>[
                                Expanded(
                                  child: Center(
                                    child: complaint.assigned.isNotEmpty
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Assigned to: ",
                                                style: TextStyle(
                                                    color: Colors.purple,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                complaint.assigned[0].userName,
                                                style: TextStyle(
                                                    color: Colors.purple,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          )
                                        : Text("Not Assigned",
                                            style: TextStyle(
                                              color: Colors.red,
                                            )),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      user.userType == 'Admin' ||
                                              user.userName ==
                                                  complaint.assigned[0].userName
                                          ? Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: FloatingActionButton(
                                                    mini: true,
                                                    shape: StadiumBorder(),
                                                    backgroundColor:
                                                        Colors.blue,
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  EditCustomerComplaintScreen(
                                                                      complaint:
                                                                          complaint)));
                                                    },
                                                    foregroundColor:
                                                        Colors.white,
                                                    child: Text("Edit"),
                                                  ),
                                                ),
                                              ],
                                            )
                                          // FlatButton(
                                          //     color: Colors.blue,
                                          //     shape: StadiumBorder(),
                                          //     onPressed: () {
                                          //       Navigator.push(
                                          //           context,
                                          //           new MaterialPageRoute(
                                          //               builder: (BuildContext
                                          //                       context) =>
                                          //                   EditCustomerComplaintScreen(
                                          //                       complaint:
                                          //                           complaint)));
                                          //     },
                                          //     child: Text(
                                          //       "Edit",
                                          //       style: TextStyle(
                                          //           color: Colors.white),
                                          //     ))
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ]),
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

Widget mobileView(Complaint complaint) {
  if (complaint.customerData.address.mobile != '') {
    return Row(
      children: <Widget>[
        Icon(Icons.phone_android, color: Colors.black54),
        SizedBox(width: 5.0),
        Text(complaint.customerData.address.mobile,
            style: TextStyle(fontSize: 16.0, color: Colors.black87)),
        Expanded(
            child: FloatingActionButton(
                elevation: 1.0,
                mini: true,
                onPressed: () => whatsAppOpen(complaint),
                backgroundColor: Colors.green,
                child: Image.asset('assets/images/whatsapp.png', width: 35.0))),
        Expanded(
            child: FloatingActionButton(
          elevation: 1.0,
          mini: true,
          onPressed: () => _sendSMS(complaint),
          backgroundColor: Colors.cyan,
          child: new Icon(Icons.message, color: Colors.white),
        )),
        Expanded(
            child: FloatingActionButton(
          elevation: 1.0,
          mini: true,
          onPressed: () =>
              launch("tel:" + complaint.customerData.address.mobile),
          backgroundColor: Colors.blue,
          child: new Icon(Icons.call, color: Colors.white),
        )),
      ],
    );
  } else
    return Container();
}

void _confirmClose(BuildContext context, Complaint complaint) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Are you sure close the complaint?"),
        actions: <Widget>[
          new FlatButton(
            shape: StadiumBorder(),
            child: new Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
            onPressed: () {
              closeComplaint(context, complaint);
            },
          ),
          new FlatButton(
            shape: StadiumBorder(),
            child: new Text(
              "No",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _confirmOpen(BuildContext context, Complaint complaint) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Are you sure reopen the complaint?"),
        actions: <Widget>[
          new FlatButton(
            shape: StadiumBorder(),
            child: new Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
            onPressed: () {
              openComplaint(context, complaint);
            },
          ),
          new FlatButton(
            shape: StadiumBorder(),
            child: new Text(
              "No",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

closeComplaint(BuildContext context, Complaint complaint) async {
  Complaint complaintData = Complaint(
      customerId: complaint.customerData.id,
      complaintId: complaint.id,
      complaintFor: complaint.complaintFor,
      complaintPriority: complaint.complaintPriority,
      complaintDetail: complaint.complaintDetail,
      complaintRemarks: complaint.complaintRemarks,
      complaintStatus: "closed",
      assignedTo: complaint.assignedTo);

  updateComplaint(complaintData, complaint.id).then((response) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }).catchError((error) {
    print('error : $error');
  });
}

openComplaint(BuildContext context, Complaint complaint) async {
  Complaint complaintData = Complaint(
      customerId: complaint.customerData.id,
      complaintId: complaint.id,
      complaintFor: complaint.complaintFor,
      complaintPriority: complaint.complaintPriority,
      complaintDetail: complaint.complaintDetail,
      complaintRemarks: complaint.complaintRemarks,
      complaintStatus: "open",
      assignedTo: complaint.assignedTo);

  updateComplaint(complaintData, complaint.id).then((response) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }).catchError((error) {
    print('error : $error');
  });
}

void whatsAppOpen(Complaint complaint) async {
  // bool whatsapp = await FlutterLaunch.hasApp(name: "whatsapp");

  // if (whatsapp) {
  //   await FlutterLaunch.launchWathsApp(
  //       phone: "+91" + complaint.customerData.address.mobile,
  //       message: "Dear " +
  //           complaint.customerData.customerName +
  //           " [  ID: " +
  //           complaint.customerData.customerId +
  //           " ] your complaint for " +
  //           complaint.complaintFor +
  //           " with " +
  //           complaint.complaintDetail +
  //           " has been assigned to " +
  //           complaint.assigned[0].name +
  //           ". Your complaint will be resolved soon.");
  // } else {
  //   print("Whatsapp not Installed");
  // }
  FlutterOpenWhatsapp.sendSingleMessage(
      "+91" + complaint.customerData.address.mobile,
      "Dear " +
          complaint.customerData.customerName +
          " [  ID: " +
          complaint.customerData.customerId +
          " ] your complaint for " +
          complaint.complaintFor +
          " with " +
          complaint.complaintDetail +
          " has been assigned to " +
          complaint.assigned[0].name +
          ". Your complaint will be resolved soon.");
}

void _sendSMS(Complaint complaint) {
  final SimpleSms simpleSms = SimpleSms();
  List<String> address = ["+91" + complaint.customerData.address.mobile];

  simpleSms.sendSms(
      address,
      "Dear " +
          complaint.customerData.customerName +
          " [  ID: " +
          complaint.customerData.customerId +
          " ] your complaint for " +
          complaint.complaintFor +
          " with " +
          complaint.complaintDetail +
          " has been assigned to " +
          complaint.assigned[0].name +
          ". Your complaint will be resolved soon.");
}
