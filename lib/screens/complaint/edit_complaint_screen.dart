import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:svs/models/customer.dart';
import 'package:svs/models/complaint.dart';
import 'package:svs/services/basic_service.dart';
import 'dart:convert';
import 'package:svs/models/username.dart';
import 'package:svs/models/complaint-category.dart';
import 'package:svs/widgets/loader.dart';
import 'package:svs/models/login-response.dart';
import 'package:svs/utils/app_shared_preferences.dart';
// import 'package:svs/screens/layout/home_layout.dart';

class EditCustomerComplaintScreen extends StatefulWidget {
  final Complaint complaint;
  EditCustomerComplaintScreen({Key key, @required this.complaint})
      : super(key: key);
  _EditCustomerComplaintScreenState createState() =>
      _EditCustomerComplaintScreenState();
}

class _EditCustomerComplaintScreenState
    extends State<EditCustomerComplaintScreen> {
  final _editComplaintKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> globalKey = new GlobalKey<ScaffoldState>();

  List<Customer> customers;
  LoginResponse user;

  Customer customer;

  bool _isAdding = false;
  bool _isLoading = true;

  String _complaint;
  TextEditingController _complaintController = new TextEditingController();
  String _remarks;
  TextEditingController _remarksController = new TextEditingController();

  String _complaintFor = "Cable";
  String _complaintPriority = "Normal";
  List<Username> assignedtos = [];
  String assignedto = "Select";

  List<ComplaintCategory> complaintCategorys = [];
  @override
  void initState() {
    super.initState();

    getData();

    setData();
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

  setData() {
    setState(() {
      if (widget.complaint.complaintFor == null ||
          widget.complaint.complaintFor == "") {
        _complaintFor = "Cable";
      } else {
        _complaintFor = widget.complaint.complaintFor;
      }
      if (widget.complaint.complaintPriority == null ||
          widget.complaint.complaintPriority == "") {
        _complaintPriority = "Normal";
      } else {
        _complaintPriority = widget.complaint.complaintPriority;
      }
      if (widget.complaint.assignedTo == null ||
          widget.complaint.assignedTo == "") {
        assignedto = "Select";
      } else {
        assignedto = widget.complaint.assigned[0].userName;
      }
      if (widget.complaint.complaintDetail == null ||
          widget.complaint.complaintDetail == "") {
        _complaint = "";
      } else {
        _complaintController.text = widget.complaint.complaintDetail;
      }
      if (widget.complaint.complaintRemarks == null ||
          widget.complaint.complaintRemarks == "") {
        _remarks = "";
      } else {
        _remarksController.text = widget.complaint.complaintRemarks;
      }
    });
  }

  _editComplaint(BuildContext context) async {
    if (_editComplaintKey.currentState.validate()) {
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
          complaintId: widget.complaint.complaintId,
          customerId: widget.complaint.customerData.id,
          complaintFor: _complaintFor,
          complaintPriority: _complaintPriority,
          assignedTo: assigntoid,
          complaintDetail: _complaintController.text,
          complaintRemarks: _remarks,
          complaintStatus: widget.complaint.complaintStatus);

      updateComplaint(complaint, widget.complaint.id).then((response) {
        if (response.statusCode == 200) {
          globalKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.green,
            content: new Text("Complaint Edited Successfully!!"),
          ));
          Navigator.of(context).pop();
          Navigator.of(context).pop();

          // Navigator.pushReplacementNamed(context, "/complaintlist");
          setState(() {
            _isAdding = false;
          });
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

        _isLoading = false;
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
        title: new Text('Edit Complaint'),
        backgroundColor: new Color(0xffae275f),
      ),
      backgroundColor: Color(0xFFdae2f0),
      body: Container(
          child: Column(children: <Widget>[
        _isLoading ? Loader() : payCard(context),
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
            key: _editComplaintKey,
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
                                  color: widget.complaint.customerData
                                              .activeStatus ==
                                          true
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            Container(
                                width: 300,
                                child: Text(
                                  widget.complaint.customerData.customerName
                                      .toUpperCase(),
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
                                          "ID : " + widget.complaint.customerId,
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
                                widget.complaint.customerData.address.doorNo +
                                    ' ' +
                                    widget
                                        .complaint.customerData.address.street +
                                    ' ' +
                                    widget.complaint.customerData.address.area +
                                    ' ' +
                                    widget.complaint.customerData.address.city,
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
                              // Expanded(
                              //     child: TextFormField(
                              //   controller: _complaintController,
                              //   maxLines: 1,
                              //   validator: (value) {
                              //     if (value.isEmpty) {
                              //       return 'Please enter complaint';
                              //     }
                              //     _complaint = value;
                              //   },
                              //   style: TextStyle(
                              //       color: Colors.black, fontSize: 16.0),
                              //   decoration: InputDecoration(
                              //     hintText: "Complaint Detail..",
                              //   ),
                              // )),
                            ]),
                            SizedBox(
                              height: 25.0,
                            ),
                            Row(children: <Widget>[
                              Expanded(
                                  child: TextFormField(
                                controller: _remarksController,
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
                                        "SUBMIT",
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
                                          _editComplaint(context);
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
