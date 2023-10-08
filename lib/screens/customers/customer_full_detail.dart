import 'package:flutter/material.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:svs/models/login-response.dart';
import 'package:svs/models/customer.dart';
import 'package:svs/widgets/loader.dart';
import 'package:svs/services/basic_service.dart';
import 'dart:convert';
import 'package:svs/models/payment.dart';
import 'package:svs/models/complaint.dart';
import 'package:svs/models/billing.dart';
import 'package:svs/models/customer-status.dart';
import 'package:svs/widgets/payment_view.dart';
import 'package:svs/widgets/billing_view.dart';
import 'package:svs/widgets/complaint_view.dart';
import 'package:intl/intl.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:flutter/services.dart';

class CustomerFullDetails extends StatefulWidget {
  final Customer customer;
  CustomerFullDetails({Key key, @required this.customer}) : super(key: key);
  _CustomerFullDetailsState createState() => _CustomerFullDetailsState();
}

class _CustomerFullDetailsState extends State<CustomerFullDetails>
    with SingleTickerProviderStateMixin {
  LoginResponse user;
  TabController controller;
  List<Payment> payments;
  List<Billing> billings;
  List<Complaint> complaints;
  List<CustomerStatus> customerStatus;
  var formatter = new DateFormat('dd-MM-yyyy hh:mm aaa');
  var currency = NumberFormat("##,##,##0.00");
  bool _isRefresh = false;
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> customerFullDetailKey =
      new GlobalKey<ScaffoldState>();

  //------------------------------------------------------------------------------
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // _isLoading = true;
    bool loggedIn = await AppSharedPreferences.isUserLoggedIn();

    try {
      if (loggedIn) {
        if (user == null) {
          await initUserProfile();
        }
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    } catch (error) {
      print(error);
      Navigator.pushReplacementNamed(context, "/login");
    }
    // getData();
  }

//------------------------------------------------------------------------------

  Future<void> initUserProfile() async {
    LoginResponse up = await AppSharedPreferences.getUserProfile();
    setState(() {
      user = up;
    });
  }

//------------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    getData();
    controller = new TabController(
      vsync: this,
      length: 5,
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getData() {
    customerPaymentHistory(widget.customer.id).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          payments = paymentsFromJson(Utf8Codec().decode(response.bodyBytes));
        });
        _isRefresh = false;
      } else {
        customerFullDetailKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("Something went wrong !!"),
        ));
        _isRefresh = false;
      }
    }).catchError((error) {
      customerFullDetailKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.redAccent[400],
        content: new Text("No Internet Connection. Loading Offline Content."),
      ));
      setState(() {
        _isLoading = false;
        _isRefresh = false;
      });
    });
    customerInvoiceHistory(widget.customer.id).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          billings = billingFromJson(Utf8Codec().decode(response.bodyBytes));
        });
      } else {
        customerFullDetailKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("Something went wrong !!"),
        ));
      }
    }).catchError((error) {
      customerFullDetailKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.redAccent[400],
        content: new Text("No Internet Connection. Loading Offline Content."),
      ));
      setState(() {
        _isLoading = false;
      });
    });
    customerComplaintHistory(widget.customer.id).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          complaints =
              complaintsFromJson(Utf8Codec().decode(response.bodyBytes));
        });
      } else {
        customerFullDetailKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("Something went wrong !!"),
        ));
      }
    }).catchError((error) {
      customerFullDetailKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.redAccent[400],
        content: new Text("No Internet Connection. Loading Offline Content."),
      ));
      setState(() {
        _isLoading = false;
      });
    });
    customerStatusHistory(widget.customer.id).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          customerStatus =
              customersStatusFromJson(Utf8Codec().decode(response.bodyBytes));
          _isLoading = false;
        });
      } else {
        customerFullDetailKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("Something went wrong !!"),
        ));
      }
    }).catchError((error) {
      customerFullDetailKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.redAccent[400],
        content: new Text("No Internet Connection. Loading Offline Content."),
      ));
      setState(() {
        _isLoading = false;
      });
    });
    _isRefresh = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFdae2f0),
      appBar: AppBar(
        title: Text(
            widget.customer.customerName + " - " + widget.customer.customerId),
        bottom: bottomNavigation(),
        actions: <Widget>[
          SizedBox(
            width: 5.0,
          ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         new MaterialPageRoute(
          //             builder: (BuildContext context) =>
          //                 EditCustomerScreenTest(customer: widget.customer)));
          //   },
          //   icon: Icon(Icons.edit),
          // ),
          _isRefresh
              ? Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _isRefresh = true;
                      getData();
                    });
                  },
                  icon: Icon(Icons.refresh),
                ),
        ],
      ),
      body: _isLoading
          ? Loader()
          : TabBarView(
              controller: controller,
              children: <Widget>[
                customerDetails(),
                paymentHistory(),
                invoiceHistory(),
                complaintHistory(),
                statusHistory(),
              ],
            ),
    );
  }

  bottomNavigation() => TabBar(
        isScrollable: true,
        controller: controller,
        labelPadding: EdgeInsets.symmetric(horizontal: 10),
        indicatorColor: Colors.yellow,
        labelColor: Colors.white,
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        unselectedLabelColor: Colors.white70,
        tabs: <Widget>[
          new Tab(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Customers Details", style: TextStyle(fontSize: 11.0)),
            ],
          )),
          new Tab(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Payment History", style: TextStyle(fontSize: 11.0)),
            ],
          )),
          new Tab(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Invoice History", style: TextStyle(fontSize: 11.0)),
            ],
          )),
          new Tab(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Complaint History", style: TextStyle(fontSize: 11.0)),
            ],
          )),
          new Tab(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Activation / Deactivation History",
                  style: TextStyle(fontSize: 11.0)),
            ],
          )),
        ],
      );

  Widget customerDetails() {
    double a = 119;
    double b = 8.0;
    double c = 200.0;

    var boxes = List<Widget>();

    if (widget.customer.cable.boxDetails != null &&
        widget.customer.cable.boxDetails.isNotEmpty) {
      for (var i = 0; i < widget.customer.cable.boxDetails.length; i++) {
        var box = _boxDetailView(widget.customer.cable.boxDetails[i]);
        boxes.add(box);
      }
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              Container(
                height: 10.0,
              ),
              Card(
                margin: new EdgeInsets.symmetric(vertical: 5.0),
                shape: RoundedRectangleBorder(),
                child: Column(
                  children: <Widget>[
                    ListTile(
                        dense: true,
                        leading: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                border: Border.all(
                                    width: 2.0,
                                    color: widget.customer.activeStatus == true
                                        ? Colors.green
                                        : Colors.redAccent[100])),
                            child: CircleAvatar(
                              radius: 20.0,
                              child: Text(
                                widget.customer.customerName[0].toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26.0),
                              ),
                            )),
                        title: Text(widget.customer.customerName.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                        subtitle: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 5.0),
                              height: 14.0,
                              width: 14.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: widget.customer.activeStatus == true
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            Text("ID : " + widget.customer.customerId,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0)),
                          ],
                        )),
                    Container(
                      height: 5.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Table(
                        children: [
                          widget.customer.cafNo == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "CAF Number",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.cafNo == null
                                                ? "-"
                                                : widget.customer.cafNo,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.cafNo == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.dob == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Date of Birth",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.dob == null
                                                ? "-"
                                                : widget.customer.dob,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.dob == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.gender == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Gender",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.gender == null
                                                ? "-"
                                                : widget.customer.gender,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.gender == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          TableRow(children: [
                            TableCell(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    width: a,
                                    child: Text(
                                      "Status",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                  Container(
                                    width: b,
                                    child: Text(
                                      ":",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                  Container(
                                      width: c,
                                      child: Text(
                                        widget.customer.activeStatus == true
                                            ? "Active"
                                            : "Inactive",
                                        style: TextStyle(
                                            color:
                                                widget.customer.activeStatus ==
                                                        true
                                                    ? Colors.green
                                                    : Colors.red,
                                            fontWeight: FontWeight.w800),
                                      )),
                                ],
                              ),
                            )
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 5.0,
                                  )
                                ],
                              ),
                            )
                          ]),
                          widget.customer.collectionAgent == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Collection Agent",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.collectionAgent ==
                                                    null
                                                ? "-"
                                                : widget
                                                    .customer.collectionAgent,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.collectionAgent == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.address == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Address",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.address == null
                                                ? "-"
                                                : widget.customer.address.doorNo +
                                                    ' ' +
                                                    widget.customer.address
                                                        .houseName +
                                                    ' ' +
                                                    widget.customer.address
                                                        .street +
                                                    ' ' +
                                                    widget
                                                        .customer.address.area +
                                                    ' ' +
                                                    widget
                                                        .customer.address.city,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.address == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.ebNumber == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "EB Number",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.ebNumber == null
                                                ? "-"
                                                : widget.customer.ebNumber,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.ebNumber == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.postNumber == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Post Number",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.postNumber == null
                                                ? "-"
                                                : widget.customer.postNumber,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.postNumber == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.address.emailId == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Email Id",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.address.emailId ==
                                                    null
                                                ? "-"
                                                : widget
                                                    .customer.address.emailId,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w800,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.address.emailId == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.address.mobile == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Mobile",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.address.mobile ==
                                                    null
                                                ? "-"
                                                : widget
                                                    .customer.address.mobile,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.address.mobile == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.address.alternateNumber == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Alternate Number",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.address
                                                        .alternateNumber ==
                                                    null
                                                ? "-"
                                                : widget.customer.address
                                                    .alternateNumber,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.address.alternateNumber == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.created.isEmpty
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Created by",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.created.isEmpty
                                                ? "-"
                                                : widget.customer.created[0]
                                                        .name +
                                                    " on " +
                                                    formatter.format(
                                                        DateTime.tryParse(widget
                                                                .customer
                                                                .createdAt)
                                                            .toLocal()),
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.created.isEmpty
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.modified.isEmpty
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Updated by",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.modified.isEmpty
                                                ? "-"
                                                : widget.customer.modified[0]
                                                        .name +
                                                    " on " +
                                                    formatter.format(
                                                        DateTime.tryParse(widget
                                                                .customer
                                                                .updatedAt)
                                                            .toLocal()),
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.modified.isEmpty
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 10.0,
                  ),
                  Text(
                    "Cable Details :",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Container(
                height: 5.0,
              ),
              Card(
                margin: new EdgeInsets.symmetric(vertical: 5.0),
                shape: RoundedRectangleBorder(),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 10.0,
                    ),
                    Divider(),
                    Text(widget.customer.cable.noCableConnection == null
                        ? ''
                        : "Number of Connections : " +
                            widget.customer.cable.noCableConnection.toString()),
                    Divider(),
                    widget.customer.cable.boxDetails == null
                        ? 0
                        : Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10.0),
                                child: Material(
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: GroovinExpansionTile(
                                    defaultTrailingIconColor:
                                        Colors.indigoAccent,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.indigoAccent,
                                      child: Icon(
                                        Icons.live_tv,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      "Subscription Details",
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5.0),
                                          bottomRight: Radius.circular(5.0),
                                        ),
                                        child: Column(
                                          children: boxes,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Table(
                        children: [
                          widget.customer.cable.cableAdvanceAmount == null ||
                                  widget
                                      .customer.cable.cableAdvanceAmount.isEmpty
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Installation Amount",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.cable
                                                            .cableAdvanceAmount ==
                                                        null ||
                                                    widget
                                                        .customer
                                                        .cable
                                                        .cableAdvanceAmount
                                                        .isEmpty
                                                ? "-"
                                                : "Rs. " +
                                                    currency.format(
                                                        double.tryParse(widget
                                                            .customer
                                                            .cable
                                                            .cableAdvanceAmount)),
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.cable.cableAdvanceAmount == null ||
                                  widget
                                      .customer.cable.cableAdvanceAmount.isEmpty
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.cable.cableDiscount == null ||
                                  widget.customer.cable.cableDiscount.isEmpty
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Discount Given",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.cable
                                                            .cableDiscount ==
                                                        null ||
                                                    widget.customer.cable
                                                        .cableDiscount.isEmpty
                                                ? "-"
                                                : "Rs. " +
                                                    currency.format(
                                                        double.tryParse(widget
                                                            .customer
                                                            .cable
                                                            .cableDiscount)),
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.cable.cableDiscount == null ||
                                  widget.customer.cable.cableDiscount.isEmpty
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.cable.cableMonthlyRent == null ||
                                  widget.customer.cable.cableMonthlyRent.isEmpty
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Monthly Rent",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.cable
                                                            .cableMonthlyRent ==
                                                        null ||
                                                    widget
                                                        .customer
                                                        .cable
                                                        .cableMonthlyRent
                                                        .isEmpty
                                                ? "-"
                                                : "Rs. " +
                                                    currency.format(
                                                        double.tryParse(widget
                                                            .customer
                                                            .cable
                                                            .cableMonthlyRent)),
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.cable.cableMonthlyRent == null ||
                                  widget.customer.cable.cableMonthlyRent.isEmpty
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.cable.cableOutstandingAmount ==
                                      null ||
                                  widget.customer.cable.cableOutstandingAmount
                                      .isEmpty
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Outstanding Due",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.cable
                                                            .cableOutstandingAmount ==
                                                        null ||
                                                    widget
                                                        .customer
                                                        .cable
                                                        .cableOutstandingAmount
                                                        .isEmpty
                                                ? "-"
                                                : "Rs. " +
                                                    currency.format(
                                                        double.tryParse(widget
                                                            .customer
                                                            .cable
                                                            .cableOutstandingAmount)),
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.cable.cableOutstandingAmount ==
                                      null ||
                                  widget.customer.cable.cableOutstandingAmount
                                      .isEmpty
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.cable.cableComments == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          width: a,
                                          child: Text(
                                            "Comment",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: b,
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          width: c,
                                          child: Text(
                                            widget.customer.cable
                                                        .cableComments ==
                                                    null
                                                ? "-"
                                                : widget.customer.cable
                                                    .cableComments,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                          widget.customer.cable.cableComments == null
                              ? TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[Container()],
                                    ),
                                  )
                                ])
                              : TableRow(children: [
                                  TableCell(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 5.0,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              widget.customer.internet == null
                  ? Container()
                  : Container(
                      height: 10.0,
                    ),
              widget.customer.internet == null
                  ? Container()
                  : Row(
                      children: <Widget>[
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          "Internet Details :",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
              widget.customer.internet == null
                  ? Container()
                  : Container(
                      height: 5.0,
                    ),
              widget.customer.internet == null
                  ? Container()
                  : Card(
                      margin: new EdgeInsets.symmetric(vertical: 5.0),
                      shape: RoundedRectangleBorder(),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 5.0,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Table(
                              children: [
                                widget.customer.internet.planName == null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                width: a,
                                                child: Text(
                                                  "Active Plan",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: b,
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: c,
                                                child: Text(
                                                  widget.customer.internet
                                                              .planName ==
                                                          null
                                                      ? "-"
                                                      : widget.customer.internet
                                                          .planName,
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.planName == null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                height: 5.0,
                                              )
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.ontNo == null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                width: a,
                                                child: Text(
                                                  "ONT Number",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: b,
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: c,
                                                child: Text(
                                                  widget.customer.internet
                                                              .ontNo ==
                                                          null
                                                      ? "-"
                                                      : widget.customer.internet
                                                          .ontNo,
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.ontNo == null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                height: 5.0,
                                              )
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.macId == null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                width: a,
                                                child: Text(
                                                  "MAC ID",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: b,
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: c,
                                                child: Text(
                                                  widget.customer.internet
                                                              .macId ==
                                                          null
                                                      ? "-"
                                                      : widget.customer.internet
                                                          .macId,
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.macId == null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                height: 5.0,
                                              )
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.vLan == null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                width: a,
                                                child: Text(
                                                  "V LAN",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: b,
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: c,
                                                child: Text(
                                                  widget.customer.internet
                                                              .vLan ==
                                                          null
                                                      ? "-"
                                                      : widget.customer.internet
                                                          .vLan,
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.vLan == null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                height: 5.0,
                                              )
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.voip == null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                width: a,
                                                child: Text(
                                                  "VOIP",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: b,
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: c,
                                                child: Text(
                                                  widget.customer.internet
                                                              .voip ==
                                                          null
                                                      ? "-"
                                                      : widget.customer.internet
                                                          .voip,
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.voip == null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                height: 5.0,
                                              )
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet
                                            .internetAdvanceAmount ==
                                        null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                width: a,
                                                child: Text(
                                                  "Installation Amount",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: b,
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: c,
                                                child: Text(
                                                  widget.customer.internet
                                                              .internetAdvanceAmount ==
                                                          null
                                                      ? "-"
                                                      : "Rs. " +
                                                          currency.format(double
                                                              .tryParse(widget
                                                                  .customer
                                                                  .internet
                                                                  .internetAdvanceAmount)),
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet
                                            .internetAdvanceAmount ==
                                        null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                height: 5.0,
                                              )
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.internetDiscount ==
                                        null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                width: a,
                                                child: Text(
                                                  "Discount Given",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: b,
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: c,
                                                child: Text(
                                                  widget.customer.internet
                                                              .internetDiscount ==
                                                          null
                                                      ? "-"
                                                      : "Rs. " +
                                                          currency.format(double
                                                              .tryParse(widget
                                                                  .customer
                                                                  .internet
                                                                  .internetDiscount)),
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.internetDiscount ==
                                        null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                height: 5.0,
                                              )
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.internetMonthlyRent ==
                                        null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                width: a,
                                                child: Text(
                                                  "Monthly Rent",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: b,
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: c,
                                                child: Text(
                                                  widget.customer.internet
                                                              .internetMonthlyRent ==
                                                          null
                                                      ? "-"
                                                      : "Rs. " +
                                                          currency.format(double
                                                              .tryParse(widget
                                                                  .customer
                                                                  .internet
                                                                  .internetMonthlyRent)),
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.internetMonthlyRent ==
                                        null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                height: 5.0,
                                              )
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet
                                            .internetOutstandingAmount ==
                                        null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                width: a,
                                                child: Text(
                                                  "Outstanding Due",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: b,
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: c,
                                                child: Text(
                                                  widget.customer.internet
                                                              .internetOutstandingAmount ==
                                                          null
                                                      ? "-"
                                                      : "Rs. " +
                                                          currency.format(double
                                                              .tryParse(widget
                                                                  .customer
                                                                  .internet
                                                                  .internetOutstandingAmount)),
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet
                                            .internetOutstandingAmount ==
                                        null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                height: 5.0,
                                              )
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.internetComments ==
                                        null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                width: a,
                                                child: Text(
                                                  "Comment",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: b,
                                                child: Text(
                                                  ":",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              Container(
                                                width: c,
                                                child: Text(
                                                  widget.customer.internet
                                                              .internetComments ==
                                                          null
                                                      ? "-"
                                                      : widget.customer.internet
                                                          .internetComments,
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                widget.customer.internet.internetComments ==
                                        null
                                    ? TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[Container()],
                                          ),
                                        )
                                      ])
                                    : TableRow(children: [
                                        TableCell(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                height: 5.0,
                                              )
                                            ],
                                          ),
                                        )
                                      ]),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
              Container(
                height: 10.0,
              ),
            ],
          ),
        ),
      ],
    );
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 5.0,
                        ),
                        Text(box.msoId == null ? '' : "MSO : "),
                        Expanded(
                            child: Text(box.msoId == null ? '' : box.msoId)),
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
                          border: TableBorder.all(
                              width: 1.0, color: Colors.black45),
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
                                            child: Text(
                                                box.mainPackage.packageName),
                                            width: 100.0,
                                          ),
                                          SizedBox(
                                            child: Text(
                                              (currency.format(double.tryParse(
                                                      box.mainPackage
                                                          .packageCost)))
                                                  .toString(),
                                              textAlign: TextAlign.right,
                                            ),
                                            width: 60.0,
                                          ),
                                          SizedBox(
                                            child: Text(
                                              (currency.format((18 / 100) *
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
                                              (currency.format(((18 / 100) *
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
                      border:
                          TableBorder.all(width: 1.0, color: Colors.black45),
                      children: addons),
                  SizedBox(
                    height: 0.5,
                  ),
                  Table(
                      border:
                          TableBorder.all(width: 1.0, color: Colors.black45),
                      children: channels),
                  SizedBox(
                    height: 1.0,
                  ),
                  (box.mainPackage.packageCost != null &&
                          box.addonPackage.packageCost != null &&
                          box.mainPackage.packageCost != "" &&
                          box.addonPackage.packageCost != "")
                      ? Table(
                          border: TableBorder.all(
                              width: 1.0, color: Colors.black45),
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
                                          (currency.format(double.tryParse(box
                                                      .mainPackage
                                                      .packageCost) +
                                                  addonsPackageCost +
                                                  channelsPackageCost))
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        ),
                                        width: 60.0,
                                      ),
                                      SizedBox(
                                        child: Text(
                                          (currency.format((18 / 100) *
                                                  (double.tryParse(box
                                                          .mainPackage
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
                                      SizedBox(
                                        child: Text(
                                          (currency.format(((18 / 100) *
                                                      (double.tryParse(box
                                                              .mainPackage
                                                              .packageCost) +
                                                          addonsPackageCost +
                                                          channelsPackageCost)) +
                                                  (double.tryParse(box
                                                          .mainPackage
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
                  (currency.format(double.tryParse(addon.packageCost)))
                      .toString(),
                  textAlign: TextAlign.right,
                ),
                width: 60.0,
              ),
              SizedBox(
                child: Text(
                  (currency.format(
                          (18 / 100) * double.tryParse(addon.packageCost)))
                      .toString(),
                  textAlign: TextAlign.right,
                ),
                width: 60.0,
              ),
              SizedBox(
                child: Text(
                  (currency.format(
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
                  (currency.format(double.tryParse(channel.channelCost)))
                      .toString(),
                  textAlign: TextAlign.right,
                ),
                width: 60.0,
              ),
              SizedBox(
                child: Text(
                  (currency.format(
                          (18 / 100) * double.tryParse(channel.channelCost)))
                      .toString(),
                  textAlign: TextAlign.right,
                ),
                width: 60.0,
              ),
              SizedBox(
                child: Text(
                  (currency.format(
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

  Widget paymentHistory() {
    return Column(
      children: <Widget>[
        Expanded(
            child: ListView.builder(
                itemCount: payments == null ? 0 : payments.length,
                itemBuilder: (BuildContext context, int i) {
                  return _paymentView(payments[i]);
                })),
      ],
    );
  }

  Widget _paymentView(Payment payment) {
    return InkWell(
        onTap: () => paymentView(context, payment, false),
        child: Card(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
          child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(64, 75, 96, .9),
                  borderRadius: BorderRadius.circular(5.0)),
              child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  title: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 5.0),
                      height: 12.0,
                      width: 12.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: payment.customerData.activeStatus == true
                              ? Colors.green
                              : Colors.red),
                    ),
                    Container(
                        width: 249,
                        child: Text(
                          payment.customerData.customerName.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(height: 7.0),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: Text(
                                  "# " + payment.customerData.customerId,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                          ),
                          Expanded(
                              child: Text(payment.paymentFor,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Color(0xfff4f4f4)))),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                          ),
                          Expanded(
                              child: Text(
                            formatter.format(
                                DateTime.tryParse(payment.createdAt).toLocal()),
                            style: TextStyle(
                                fontSize: 12.0, color: Color(0xfff4f4f4)),
                            textAlign: TextAlign.right,
                          ))
                        ],
                      )),
                      Container(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text('Rs. ' + payment.amountPaid,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow)),
                          ),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Expanded(
                            child: Text(payment.paymentMode,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xfff4f4f4))),
                          ),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Expanded(
                              child: Text(
                            payment.created.isNotEmpty
                                ? payment.created[0].userName
                                : '',
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Color(0xfff4f4f4)),
                          ))
                        ],
                      )
                    ],
                  ))),
        ));
  }

  Widget invoiceHistory() {
    return Column(
      children: <Widget>[
        Expanded(
            child: ListView.builder(
                itemCount: billings == null ? 0 : billings.length,
                itemBuilder: (BuildContext context, int i) {
                  return _billingView(billings[i]);
                })),
      ],
    );
  }

  Widget _billingView(Billing billing) {
    return InkWell(
        onTap: () => billingView(context, billing),
        child: Card(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
          child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(64, 75, 96, .9),
                  borderRadius: BorderRadius.circular(5.0)),
              child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  title: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 5.0),
                      height: 12.0,
                      width: 12.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: billing.customerData.activeStatus == true
                              ? Colors.green
                              : Colors.red),
                    ),
                    Container(
                        width: 249,
                        child: Text(
                          billing.customerData.customerName.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(height: 7.0),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: Text(
                                  "# " + billing.customerData.customerId,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                          ),
                          Expanded(
                              child: Center(
                                  child: Text(billing.billFor,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Color(0xfff4f4f4))))),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                          ),
                          Expanded(
                              child: Text(
                            formatter.format(
                                DateTime.tryParse(billing.createdAt).toLocal()),
                            style: TextStyle(
                                fontSize: 12.0, color: Color(0xfff4f4f4)),
                            textAlign: TextAlign.right,
                          ))
                        ],
                      )),
                      Container(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text('Rs. ' + billing.billAmount,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow)),
                          ),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Expanded(
                            child: Text(billing.billId,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xfff4f4f4))),
                          ),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Flexible(
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: billing.paidStatus == 'Fully Paid'
                                        ? Colors.green
                                        : billing.paidStatus == 'Partial Paid'
                                            ? Colors.orange
                                            : Colors.red,
                                  ),
                                  child: Text(
                                    billing.paidStatus,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color(0xfff4f4f4),
                                    ),
                                  ))),
                        ],
                      )
                    ],
                  ))),
        ));
  }

  Widget complaintHistory() {
    return Column(
      children: <Widget>[
        Expanded(
            child: ListView.builder(
                itemCount: complaints == null ? 0 : complaints.length,
                itemBuilder: (BuildContext context, int i) {
                  return _complaintView(complaints[i]);
                })),
      ],
    );
  }

  Widget _complaintView(Complaint complaint) {
    return InkWell(
        onTap: () => complaintView(context, complaint, user),
        child: Card(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
          child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(64, 75, 96, .9),
                  borderRadius: BorderRadius.circular(5.0)),
              child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  title: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 5.0),
                      height: 12.0,
                      width: 12.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: complaint.customerData.activeStatus == true
                              ? Colors.green
                              : Colors.red),
                    ),
                    Container(
                        width: 249,
                        child: Text(
                          complaint.customerData.customerName.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(height: 7.0),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            complaint.customerData.address.doorNo +
                                ' ' +
                                complaint.customerData.address.street +
                                ' ' +
                                complaint.customerData.address.area,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 12.0, color: Color(0xfff4f4f4)),
                          )),
                        ],
                      )),
                      Container(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: Text(complaint.complaintDetail,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Color(0xfff4f4f4)))),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                          ),
                          Text(
                            formatter.format(
                                DateTime.tryParse(complaint.createdAt)
                                    .toLocal()),
                            style: TextStyle(
                                fontSize: 12.0, color: Color(0xfff4f4f4)),
                            textAlign: TextAlign.right,
                          )
                        ],
                      ),
                      Container(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: complaint.complaintStatus == 'closed'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              child: Text(
                                complaint.complaintStatus,
                                style: TextStyle(color: Color(0xfff4f4f4)),
                              )),
                          complaint.complaintStatus == 'closed'
                              ? Container(
                                  height: 15.0,
                                  width: 1.0,
                                  color: Colors.white30,
                                  margin: const EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                )
                              : Container(),
                          complaint.complaintStatus == 'closed'
                              ? Expanded(
                                  child: Text(
                                      formatter.format(
                                          DateTime.tryParse(complaint.closedAt)
                                              .toLocal()),
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Color(0xfff4f4f4)),
                                      textAlign: TextAlign.center),
                                )
                              : Container(),
                          complaint.complaintStatus == 'closed'
                              ? Container(
                                  height: 15.0,
                                  width: 1.0,
                                  color: Colors.white30,
                                  margin: const EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                )
                              : Container(),
                          Expanded(
                              child: Text(
                                  complaint.assigned.isNotEmpty
                                      ? complaint.assigned[0].userName
                                      : 'Not Assigned',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow))),
                        ],
                      )
                    ],
                  ))),
        ));
  }

  Widget statusHistory() {
    return Column(
      children: <Widget>[
        Expanded(
            child: ListView.builder(
                itemCount: customerStatus == null ? 0 : customerStatus.length,
                itemBuilder: (BuildContext context, int i) {
                  return _statusView(customerStatus[i]);
                })),
      ],
    );
  }

  Widget _statusView(CustomerStatus customerStatus) {
    return InkWell(
        onTap: () {},
        child: Card(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
          child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(64, 75, 96, .9),
                  borderRadius: BorderRadius.circular(5.0)),
              child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                  title: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 5.0),
                      height: 12.0,
                      width: 12.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: widget.customer.activeStatus == true
                              ? Colors.green
                              : Colors.red),
                    ),
                    Container(
                        width: 249,
                        child: Text(
                          widget.customer.customerName.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(height: 7.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: customerStatus.service == 'Reactivated'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              child: Text(
                                customerStatus.service,
                                style: TextStyle(color: Color(0xfff4f4f4)),
                              )),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                          ),
                          Expanded(
                            child: Text(
                              formatter.format(DateTime.tryParse(
                                      customerStatus.createdAt.toString())
                                  .toLocal()),
                              style: TextStyle(
                                  fontSize: 12.0, color: Color(0xfff4f4f4)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                          ),
                          Expanded(
                              child: Text(
                                  customerStatus.created.isNotEmpty
                                      ? customerStatus.created[0].name
                                      : "",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow))),
                        ],
                      )
                    ],
                  ))),
        ));
  }
}
