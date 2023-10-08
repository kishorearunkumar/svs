import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:svs/models/customer.dart';
import 'package:svs/models/complaint.dart';
import 'package:svs/services/basic_service.dart';
import 'dart:convert';
import 'package:svs/widgets/loader.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:svs/models/login-response.dart';
import 'package:svs/models/username.dart';
import 'package:svs/models/complaint-category.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddComplaintScreen extends StatefulWidget {
  _AddComplaintScreenState createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  final TextEditingController _searchCustomer = new TextEditingController();
  final _addComplaintKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> addComplaintKey =
      new GlobalKey<ScaffoldState>();
  String barcode = "";
  List<Customer> customers;
  Customer customer;
  String _searchText = "";
  List searchList;
  bool pay = false;
  bool _isAdding = false;
  bool _isLoading = true;

  LoginResponse user;
  String assignedto = "Select";

  String _complaint;
  TextEditingController _complaintController = new TextEditingController();
  List<ComplaintCategory> complaintCategorys = [];
  String _remarks;
  List<Username> assignedtos = [];

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

  _AddComplaintScreenState() {
    _searchCustomer.addListener(() {
      if (_searchCustomer.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _searchCustomer.text;
        });
      }
    });
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
          customerId: customer.id,
          complaintFor: _complaintFor,
          complaintPriority: _complaintPriority,
          assignedTo: assigntoid,
          complaintDetail: _complaintController.text,
          complaintRemarks: _remarks,
          complaintStatus: "open");

      saveComplaint(complaint).then((response) {
        if (response.statusCode == 201) {
          addComplaintKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.green,
            content: new Text("Complaint Added Successfully!!"),
          ));
          setState(() {
            _isAdding = false;
            _searchCustomer.text = "";
            _searchText = "";
            barcode = "";
            pay = false;
            searchList = [];
          });

          getData();
        } else {
          addComplaintKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("Something went wrong !!"),
          ));
          setState(() => _isAdding = false);
        }
      }).catchError((error) {
        print('error : $error');
        addComplaintKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("No Internet Connection. Loading Offline Content."),
        ));
        setState(() => _isAdding = false);
      });
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

  Future<void> getData() async {
    await initUserProfile();
    await getOldData();

    customerList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          customers = customerFromJson(Utf8Codec().decode(response.bodyBytes));
        });
        AppSharedPreferences.setCustomers(customers);
        _isLoading = false;
      } else {
        addComplaintKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("Something went wrong !!"),
        ));
      }
    }).catchError((error) {
      addComplaintKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.redAccent[400],
        content: new Text("No Internet Connection. Loading Offline Content."),
      ));
      setState(() {
        getOldData();
        _isLoading = false;
      });
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

  Future getOldData() async {
    try {
      customers = await AppSharedPreferences.getCustomers();
      _isLoading = false;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: addComplaintKey,
      appBar: new AppBar(
        title: new Text('Add Complaint'),
        backgroundColor: new Color(0xffae275f),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                _searchCustomer.text = "";
                _searchText = "";
                barcode = "";
                pay = false;
                searchList = [];
              });
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      backgroundColor: Color(0xFFdae2f0),
      body: _isLoading
          ? Loader()
          : Container(
              child: Column(children: <Widget>[
              !pay ? searchCard() : emptyCard(),
              (_searchCustomer.text.isEmpty) ? emptyCard() : _buildList(),
              pay ? payCard(context) : emptyCard(),
            ])),
    );
  }

  Widget emptyCard() => Container();

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
                                  color: customer.activeStatus == true
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            Container(
                                width: 300,
                                child: Text(
                                  customer.customerName.toUpperCase(),
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
                                      child: Text("ID : " + customer.customerId,
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
                                customer.address.doorNo +
                                    ' ' +
                                    customer.address.street +
                                    ' ' +
                                    customer.address.area +
                                    ' ' +
                                    customer.address.city,
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
                                          addComplaintKey.currentState
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

  Widget searchCard() => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.search, size: 30.0, color: new Color(0xffae275f)),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: TextField(
                    controller: _searchCustomer,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Search Customer"),
                  ),
                ),
                InkWell(
                    onTap: scan,
                    highlightColor: Colors.green,
                    child: Icon(
                      Icons.center_focus_weak,
                      size: 40.0,
                      color: new Color(0xffae275f),
                    )),
              ],
            ),
          ),
        ),
      );

  Widget scanCard() => new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: RaisedButton(
                color: new Color(0xff383e4b),
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: scan,
                child: const Text('SCAN CODE')),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: Text(
              barcode,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      _searchCustomer.text = this.barcode;
      if (barcode.isNotEmpty) {
        List tempList = new List();
        for (int i = 0; i < customers.length; i++) {
          try {
            if (customers[i]
                    .barCode
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()) ||
                customers[i]
                    .customerId
                    .toLowerCase()
                    .contains(_searchText.toLowerCase())) {
              tempList.add(customers[i]);
            }
          } catch (error) {
            print(error);
          }
        }

        searchList = tempList;
      }
      return Expanded(
        child: new ListView.builder(
            itemCount: searchList == null ? 0 : searchList.length,
            itemBuilder: (BuildContext context, int i) {
              return _customerView(searchList[i]);
            }),
      );
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          Scaffold.of(context).showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("The user did not grant the camera permission!"),
          ));
        });
      } else {
        setState(() => Scaffold.of(context).showSnackBar(new SnackBar(
              backgroundColor: Colors.redAccent[400],
              content: new Text("Unknown error: $e'"),
            )));
      }
    } on FormatException {
      setState(() => Scaffold.of(context).showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text(
                '(User returned using the "back"-button before scanning anything. Result)'),
          )));
    } catch (e) {
      setState(() => Scaffold.of(context).showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("Unknown error: $e'"),
          )));
    }
  }

  Widget _customerView(Customer customer) {
    return InkWell(
        // onTap: () => customerView(context,customer),

        child: Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
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
                    color: customer.activeStatus == true
                        ? Colors.green
                        : Colors.red),
              ),
              Container(
                  width: 235,
                  child: Text(
                    customer.customerName.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ]),
            subtitle: Column(
              children: <Widget>[
                Container(height: 7.0),
                Container(
                    width: 270,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text("ID : " + customer.customerId,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                      ],
                    )),
                Container(
                  height: 5.0,
                ),
                Text(
                  customer.address.doorNo +
                      ' ' +
                      customer.address.street +
                      ' ' +
                      customer.address.area,
                  style: TextStyle(color: Color(0xfff4f4f4)),
                )
              ],
            ),
            trailing: new FloatingActionButton(
              heroTag: customer.id,
              mini: true,
              backgroundColor: Colors.green,
              onPressed: () => payCustomer(customer),
              child: Icon(Icons.add_circle),
              foregroundColor: Colors.white,
            ),
          )),
    ));
  }

  payCustomer(Customer cus) {
    setState(() {
      pay = true;
      searchList = [];
      _searchCustomer.text = "";
      customer = cus;
    });
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < customers.length; i++) {
        try {
          if (customers[i]
                  .customerName
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              customers[i]
                  .customerId
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              customers[i]
                  .barCode
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              customers[i]
                  .address
                  .street
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              customers[i]
                  .address
                  .area
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              customers[i]
                  .address
                  .mobile
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              customers[i]
                  .address
                  .alternateNumber
                  .toLowerCase()
                  .contains(_searchText.toLowerCase())) {
            tempList.add(customers[i]);
          }
        } catch (error) {
          print(error);
        }
      }

      searchList = tempList;
    }
    return Expanded(
      child: new ListView.builder(
          itemCount: searchList == null ? 0 : searchList.length,
          itemBuilder: (BuildContext context, int i) {
            return _customerView(searchList[i]);
          }),
    );
  }
}
