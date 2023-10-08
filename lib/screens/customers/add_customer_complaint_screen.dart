import 'package:flutter/material.dart';
import 'package:svs/models/complaint-category.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:svs/models/customer.dart';
import 'package:svs/models/complaint.dart';
import 'package:svs/services/basic_service.dart';
import 'dart:convert';
import 'package:svs/models/username.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:svs/models/login-response.dart';

class AddCustomerComplaintScreen extends StatefulWidget {
  final Customer customer;
  AddCustomerComplaintScreen({Key key, @required this.customer})
      : super(key: key);
  _AddCustomerComplaintScreenState createState() =>
      _AddCustomerComplaintScreenState();
}

class _AddCustomerComplaintScreenState
    extends State<AddCustomerComplaintScreen> {
  final TextEditingController _searchCustomer = new TextEditingController();
  final _addComplaintKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> globalKey = new GlobalKey<ScaffoldState>();

  List<Customer> customers;
  Customer customer;
  List<Username> assignedtos = [];
  String assignedto = "Select";

  bool pay = false;
  bool _isAdding = false;
  LoginResponse user;

  String _complaint;
  String _remarks;
  TextEditingController _complaintController = new TextEditingController();
  List<ComplaintCategory> complaintCategorys = [];
  String _complaintFor = "Cable";
  String _complaintPriority = "Normal";
  @override
  void initState() {
    super.initState();
    _searchCustomer.clear();
    getData();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> initUserProfile() async {
    try {
      LoginResponse up = await AppSharedPreferences.getUserProfile();
      setState(() {
        user = up;
      });
    } catch (e) {
      print(e);
    }
  }

  _addComplaint(BuildContext context) async {
    if (_addComplaintKey.currentState.validate()) {
      setState(() => _isAdding = true);
      String assigntoid;

      if (assignedto == "Select") {
        assigntoid = "";
      } else {
        for (var i = 0; i < assignedtos.length; i++) {
          if (assignedto == assignedtos[i].userName) {
            assigntoid = assignedtos[i].id;
          }
        }
      }

      Complaint complaint = Complaint(
          customerId: widget.customer.id,
          complaintFor: _complaintFor,
          complaintPriority: _complaintPriority,
          assignedTo: assigntoid,
          complaintDetail: _complaintController.text,
          complaintRemarks: _remarks,
          complaintStatus: "open");

      saveComplaint(complaint).then((response) {
        if (response.statusCode == 201) {
          globalKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.green,
            content: new Text("Complaint Added Successfully!!"),
          ));
          Navigator.pop(context, true);
          setState(() {
            _isAdding = false;
            _searchCustomer.text = "";

            pay = false;
          });

          getData();
        } else {
          globalKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("Something went wrong !!"),
          ));
          setState(() => _isAdding = false);
        }
      }).catchError((error) {
        print('error : $error');
        globalKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("No Internet Connection. Loading Offline Content."),
        ));
        setState(() => _isAdding = false);
      });
    }
  }

  Future<void> getData() async {
    await initUserProfile();
    customerList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          customers = customerFromJson(Utf8Codec().decode(response.bodyBytes));
        });
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("Something went wrong !!"),
        ));
      }
    }).catchError((error) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        backgroundColor: Colors.redAccent[400],
        content: new Text("No Internet Connection. Loading Offline Content."),
      ));
    });
    usernameList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          assignedtos =
              usernamesFromJson(Utf8Codec().decode(response.bodyBytes));
        });
      }
    }).catchError((error) {
      print(error);
    });
    complaintCategory().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          complaintCategorys =
              complaintCategoryFromJson(Utf8Codec().decode(response.bodyBytes));
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: new AppBar(
        title: new Text('Add Complaint'),
        backgroundColor: new Color(0xffae275f),
      ),
      backgroundColor: Color(0xFFdae2f0),
      body: Container(
          child: Column(children: <Widget>[
        payCard(context),
      ])),
    );
  }

  Widget payCard(BuildContext context) {
    List<String> assignedtoList = ['Select'];
    List<String> complaintCategoryList = [];
    for (int i = 0; i < complaintCategorys.length; i++) {
      complaintCategoryList.add(complaintCategorys[i].categoryName);
    }
    for (int i = 0; i < assignedtos.length; i++) {
      assignedtoList.add(assignedtos[i].userName);
    }
    return Expanded(
        child: Form(
            key: _addComplaintKey,
            child: ListView(
              children: <Widget>[
                Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    margin: new EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 3.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(64, 75, 96, .9),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
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
                                width: 300,
                                child: Text(
                                  widget.customer.customerName.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                          ]),
                          subtitle: Column(
                            children: <Widget>[
                              Container(height: 7.0),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                          "ID : " + widget.customer.customerId,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))),
                                ],
                              ),
                              Container(
                                height: 5.0,
                              ),
                              Text(
                                widget.customer.address.doorNo +
                                    ' ' +
                                    widget.customer.address.street +
                                    ' ' +
                                    widget.customer.address.area +
                                    ' ' +
                                    widget.customer.address.city,
                                style: TextStyle(color: Color(0xfff4f4f4)),
                              )
                            ],
                          ),
                        ))),
                Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    margin: new EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 3.0),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0)),
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 3.0),
                        child: Column(
                          children: <Widget>[
                            Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                "Complaint For ",
                                style: TextStyle(fontSize: 16.0),
                              )),
                              Expanded(
                                  child: DropdownButton<String>(
                                      isExpanded: true,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                      items: <String>['Cable', 'Internet']
                                          .map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: 10.0,
                                              ),
                                              Text(
                                                value,
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      value: _complaintFor,
                                      onChanged: (newVal) {
                                        _complaintFor = newVal;
                                        this.setState(() {});
                                      }))
                            ]),
                            SizedBox(
                              height: 15.0,
                            ),
                            Row(children: <Widget>[
                              Expanded(
                                  child: Text("Complaint Priority ",
                                      style: TextStyle(fontSize: 16.0))),
                              Expanded(
                                  child: DropdownButton<String>(
                                      isExpanded: true,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16.0),
                                      items: <String>['High', 'Normal', 'Low']
                                          .map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: 10.0,
                                              ),
                                              Text(
                                                value,
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      value: _complaintPriority,
                                      onChanged: (newVal) {
                                        _complaintPriority = newVal;
                                        this.setState(() {});
                                      }))
                            ]),
                            SizedBox(
                              height: 15.0,
                            ),
                            (user.userType == "Admin" ||
                                        user.userType == "Sub-Admin" ||
                                        user.userType == "Office Staff") &&
                                    assignedtos.length > 0
                                ? Row(children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "Assign To ",
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                    Expanded(
                                        child: DropdownButton<String>(
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16.0),
                                            elevation: 8,
                                            isExpanded: true,
                                            items: assignedtoList
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 10.0,
                                                    ),
                                                    Text(
                                                      value,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                            value: assignedto,
                                            onChanged: (newVal) {
                                              setState(() {
                                                assignedto = newVal;
                                              });
                                            }))
                                  ])
                                : Container(),
                            (user.userType == "Admin" ||
                                        user.userType == "Sub-Admin" ||
                                        user.userType == "Office Staff") &&
                                    assignedtos.length > 0
                                ? SizedBox(
                                    height: 15.0,
                                  )
                                : Container(),
                            Row(children: <Widget>[
                              Expanded(
                                child: TypeAheadField<String>(
                                  hideOnEmpty: true,
                                  hideSuggestionsOnKeyboardHide: false,
                                  getImmediateSuggestions: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                          controller: _complaintController,
                                          decoration: InputDecoration(
                                            labelText: "Complaint Detail..",
                                            // labelStyle:
                                            //     TextStyle(fontSize: 12.0),
                                          )),
                                  suggestionsCallback: (String pattern) async {
                                    return complaintCategoryList
                                        .where((item) => item
                                            .toLowerCase()
                                            .startsWith(pattern.toLowerCase()))
                                        .toList();
                                  },
                                  itemBuilder: (context, String suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  onSuggestionSelected: (String suggestion) {
                                    setState(() {
                                      _complaint = suggestion;
                                      _complaintController.text = _complaint;
                                    });
                                  },
                                ),
                              ),
                            ]),
                            SizedBox(
                              height: 25.0,
                            ),
                            Row(children: <Widget>[
                              Expanded(
                                  child: TextFormField(
                                maxLines: 1,
                                validator: (value) {
                                  _remarks = value;
                                },
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                                decoration: InputDecoration(
                                  hintText: "Complaint Remarks..",
                                ),
                              )),
                            ]),
                            SizedBox(
                              height: 30.0,
                            ),
                            _isAdding
                                ? new CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.green),
                                  )
                                : Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 30.0),
                                    width: double.infinity,
                                    child: RaisedButton(
                                      padding: EdgeInsets.all(12.0),
                                      shape: StadiumBorder(),
                                      splashColor: Colors.green,
                                      child: Text(
                                        "ADD COMPLAINT",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: new Color(0xffae275f),
                                      onPressed: () {
                                        if (_complaintController.text.isEmpty) {
                                          globalKey.currentState
                                              .showSnackBar(new SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            content: new Text(
                                                "Please enter complaint"),
                                          ));
                                        } else {
                                          _addComplaint(context);
                                        }
                                      },
                                    ),
                                  ),
                            SizedBox(
                              height: 20.0,
                            ),
                          ],
                        )))
              ],
            )));
  }
}
