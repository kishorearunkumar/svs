import 'package:flutter/material.dart';
import 'package:svs/widgets/my_drawer.dart';
import 'package:svs/models/billing.dart';
import 'package:svs/services/basic_service.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:svs/models/street.dart';
import 'package:svs/models/area.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:svs/widgets/loader.dart';
import 'package:svs/widgets/billing_view.dart';
import 'package:svs/models/username.dart';
import 'package:svs/models/sublco.dart';
// import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:svs/models/login-response.dart';
// import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

class BillingListScreen extends StatefulWidget {
  final int filterIndex;
  BillingListScreen({Key key, @required this.filterIndex}) : super(key: key);
  _BillingListScreenState createState() => _BillingListScreenState();
}

class _BillingListScreenState extends State<BillingListScreen> {
  // Size deviceSize;
  // double screenWidth = 0.0;
  List<Billing> billings;
  List<Billing> searchList;
  int filterIndex;
  LoginResponse user;
  List<SubLco> sublcos = [];
  // var dateFormatter = new DateFormat('dd');
  // var yearFormatter = new DateFormat('yyyy');
  bool _isSearching = false;
  bool _isLoading = true;
  bool _isfilter = false;
  bool _isRefresh = false;
  bool isDateRange = false;
  String subLco = "All";
  final GlobalKey<ScaffoldState> billingListKey =
      new GlobalKey<ScaffoldState>();
  final TextEditingController _search = new TextEditingController();
  String _searchText = "";
  List<Username> collectionagents = [];
  String collectionagent = "All";
  String customerStatus = "All";
  String connectionType = "All";
  String billStatus = "All";
  String date = "All";
  String month = "All";
  String year = "All";
  String sortby = "Created Date";
  List<Street> streets = [];
  List<Areas> areas = [];
  String street = "All";
  String area = "All";
  bool isorderby = false;

  var formatter = new DateFormat('dd-MM-yyyy');
  var formatters = new DateFormat('yyyyMMddHHmmssSSS');
  var currencyFormatter = NumberFormat("##,##,##,###");

  var dateFormatter = new DateFormat('dd-MM-yyyy');

  String _fromdate = "01-" +
      DateFormat("MM").format(DateTime.now()) +
      "-" +
      DateFormat("yyyy").format(DateTime.now());

  String _todate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  _BillingListScreenState() {
    _search.addListener(() {
      if (_search.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _search.text;
        });
      }
    });
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

  Future<Null> _dateRange(BuildContext context) async {
    final List<DateTime> picked = await DateRangePicker.showDatePicker(
        context: context,
        initialFirstDate: new DateTime.now(),
        initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
        firstDate: new DateTime(1950),
        lastDate: new DateTime(2025));
    if (picked != null && picked.length == 2) {
      setState(() {
        _fromdate = dateFormatter
            .format(DateTime.tryParse(picked[0].toString()).toLocal());

        _todate = dateFormatter
            .format(DateTime.tryParse(picked[1].toString()).toLocal());
        _isLoading = true;
        isDateRange = true;
        getData();
      });
    }
  }

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

  Future pause(Duration d) => new Future.delayed(d);

  //------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    filterIndex = widget.filterIndex;
    _search.clear();
    getData();

    resetFilter(filterIndex);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  resetFilter(int filterIndex) {
    switch (filterIndex) {
      case 0:
        setState(() {
          street = "All";
          area = "All";
          collectionagent = "All";
          customerStatus = "All";
          connectionType = "All";
          billStatus = "All";
          date = "All";
          month = "All";
          year = "All";
          _isfilter = false;
          sortby = "Created Date";
          subLco = "All";
          isorderby = false;
        });
        break;
      case 1:
        setState(() {
          street = "All";
          area = "All";
          collectionagent = "All";
          customerStatus = "All";
          connectionType = "All";
          billStatus = "Fully Paid";
          date = "All";
          month = "All";
          year = "All";
          _isfilter = true;
          sortby = "Created Date";
          subLco = "All";
          isorderby = false;
        });
        break;
      case 2:
        setState(() {
          street = "All";
          area = "All";
          collectionagent = "All";
          customerStatus = "All";
          connectionType = "All";
          billStatus = "Unpaid";
          date = "All";
          month = "All";
          year = "All";
          _isfilter = true;
          sortby = "Created Date";
          subLco = "All";
          isorderby = false;
        });
        break;
      default:
        setState(() {
          street = "All";
          area = "All";
          collectionagent = "All";
          customerStatus = "All";
          connectionType = "All";
          billStatus = "All";
          date = "All";
          month = "All";
          year = "All";
          _isfilter = false;
          sortby = "Created Date";
          subLco = "All";
          isorderby = false;
        });
    }
  }
//------------------------------------------------------------------------------

  Future<void> getData() async {
    await getOldData();
    if (isDateRange) {
      invoiceListDateRange(_fromdate, _todate).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            billings = billingFromJson(Utf8Codec().decode(response.bodyBytes));
          });

          _isLoading = false;
          _isRefresh = false;
          AppSharedPreferences.setBillings(billings);
        } else {
          billingListKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("Something went wrong !!"),
          ));
          _isRefresh = false;
        }
      }).catchError((error) {
        billingListKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("No Internet Connection. Loading Offline Content."),
        ));
        setState(() {
          getOldData();
          _isLoading = false;
          _isRefresh = false;
        });
      });
    } else {
      billingList().then((response) {
        if (response.statusCode == 200) {
          setState(() {
            billings = billingFromJson(Utf8Codec().decode(response.bodyBytes));
          });

          _isLoading = false;
          _isRefresh = false;
          AppSharedPreferences.setBillings(billings);
        } else {
          billingListKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("Something went wrong !!"),
          ));
          _isRefresh = false;
        }
      }).catchError((error) {
        billingListKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("No Internet Connection. Loading Offline Content."),
        ));
        setState(() {
          getOldData();
          _isLoading = false;
          _isRefresh = false;
        });
      });
    }

    getStreetData();
    getAreaData();
    getCollectionAgentData();
    getSubLcoData();
    _isRefresh = false;
  }

  getSubLcoData() {
    subLcoList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          sublcos = subLcosFromJson(Utf8Codec().decode(response.bodyBytes));
        });
        sublcos.sort((a, b) =>
            a.subLcoName.toLowerCase().compareTo(b.subLcoName.toLowerCase()));
        AppSharedPreferences.setSubLco(sublcos);
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
      });
    });
  }

  getStreetData() {
    streetList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          streets = streetsFromJson(Utf8Codec().decode(response.bodyBytes));
        });
        streets.sort(
            (a, b) => a.street.toLowerCase().compareTo(b.street.toLowerCase()));
        AppSharedPreferences.setStreets(streets);
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
      });
    });
  }

  getAreaData() {
    areaList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          areas = areasFromJson(Utf8Codec().decode(response.bodyBytes));
        });
        areas.sort(
            (a, b) => a.area.toLowerCase().compareTo(b.area.toLowerCase()));
        AppSharedPreferences.setAreas(areas);
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
      });
    });
  }

  getCollectionAgentData() {
    usernameList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          collectionagents =
              usernamesFromJson(Utf8Codec().decode(response.bodyBytes));
        });
        collectionagents.sort((a, b) =>
            a.userName.toLowerCase().compareTo(b.userName.toLowerCase()));
        AppSharedPreferences.setUsername(collectionagents);
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
      });
    });
  }

  Future getOldData() async {
    try {
      await pause(const Duration(milliseconds: 500));
      billings = await AppSharedPreferences.getBillings();

      _isLoading = false;
      _isRefresh = false;
      collectionagents = await AppSharedPreferences.getUsername();
      collectionagents.sort((a, b) =>
          a.userName.toLowerCase().compareTo(b.userName.toLowerCase()));
      sublcos = await AppSharedPreferences.getSubLco();
      sublcos.sort((a, b) =>
          a.subLcoName.toLowerCase().compareTo(b.subLcoName.toLowerCase()));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: billingListKey,
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: _isSearching
              ? searchBar()
              : new Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        child: Text('Invoices'),
                        onTap: () {
                          setState(() {
                            this._isSearching = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
          backgroundColor: new Color(0xffae275f),
          actions: <Widget>[
            SizedBox(
              width: 5.0,
            ),
            _isSearching
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        this._isSearching = false;
                        _search.clear();
                      });
                    },
                    icon: Icon(Icons.close),
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        this._isSearching = true;
                      });
                    },
                    icon: Icon(Icons.search),
                  ),
            _isRefresh
                ? Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
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
            IconButton(
              onPressed: () {
                billingListKey.currentState.openEndDrawer();
              },
              icon: Icon(Icons.filter_list),
            ),
          ],
        ),
        drawer: MyDrawer(),
        endDrawer: filter(),
        backgroundColor: Color(0xFFdae2f0),
        body: _isLoading
            ? Loader()
            : Column(children: <Widget>[
                (_search.text.isEmpty && !_isfilter)
                    ? billingListView()
                    : _buildList(),
                user.operatorId != "OM_KALIAMMAN_CABLE_ERODE"
                    ? totalCountbillingListView()
                    : Container(),
              ]));
  }

  Widget totalCountbillingListView() {
    double billAmountt = 0.0;
    setState(() {
      if (_search.text.isEmpty && !_isfilter) {
        billAmountt = 0.0;
        for (var i = 0; i < billings.length; i++) {
          if (billings[i].billAmount != null &&
              billings[i].billAmount.isNotEmpty) {
            try {
              billAmountt =
                  billAmountt + double.tryParse(billings[i].billAmount);
            } catch (e) {}
          }
        }
      } else {
        billAmountt = 0.0;
        for (var i = 0; i < searchList.length; i++) {
          if (searchList[i].billAmount != null &&
              searchList[i].billAmount.isNotEmpty) {
            try {
              billAmountt =
                  billAmountt + double.tryParse(searchList[i].billAmount);
            } catch (e) {}
          }
        }
      }
    });

    return InkWell(
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        margin: new EdgeInsets.all(0.0),
        child: Container(
          padding: EdgeInsets.all(3.7),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 5.0,
                  ),
                  (_search.text.isEmpty && !_isfilter)
                      ? Expanded(
                          child: Text(
                            billings.length.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                // color: Color.fromRGBO(64, 75, 96, .9),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        )
                      : Expanded(
                          child: Text(
                            searchList.length.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                // color: Color.fromRGBO(64, 75, 96, .9),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ),
                  Container(
                    width: (MediaQuery.of(context).size.width / 5),
                  ),
                  Expanded(
                    child: Text(
                      "Rs. " + currencyFormatter.format(billAmountt),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          // color: Color.fromRGBO(64, 75, 96, .9),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: Text(
                      "Customers",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          // color: Color.fromRGBO(64, 75, 96, .9),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 9),
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width / 5),
                  ),
                  Expanded(
                    child: Text(
                      "Amount",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          // color: Color.fromRGBO(64, 75, 96, .9),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 9),
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.pink, Colors.deepPurple]),
              borderRadius: BorderRadius.circular(0.0)),
        ),
      ),
    );
  }

  Widget billingListView() {
    if (billings != null) {
      switch (sortby) {
        case "Customer ID":
          for (var i = 0; i < billings.length; i++) {
            setState(() {
              try {
                if (int.tryParse(billings[i].customerId) -
                        int.tryParse(billings[i].customerId) ==
                    0) {
                  billings[i].sortCustomerId = billings[i].customerId;
                  int idLength;
                  idLength = 50 - billings[i].customerId.length;
                  for (var j = 0; j <= idLength; j++) {
                    billings[i].sortCustomerId =
                        "0" + billings[i].sortCustomerId;
                  }
                }
              } catch (e) {
                billings[i].sortCustomerId = billings[i].customerId;
              }
            });
          }
          if (isorderby) {
            billings
                .sort((a, b) => a.sortCustomerId.compareTo(b.sortCustomerId));
          } else {
            billings
                .sort((a, b) => a.sortCustomerId.compareTo(b.sortCustomerId));
            billings = billings.reversed.toList();
          }
          break;
        case "Customer Name":
          if (isorderby) {
            billings.sort((a, b) => a.customerData.customerName
                .compareTo(b.customerData.customerName));
          } else {
            billings.sort((a, b) => a.customerData.customerName
                .compareTo(b.customerData.customerName));
            billings = billings.reversed.toList();
          }
          break;
        case "Created Date":
          for (var i = 0; i < billings.length; i++) {
            billings[i].sortCreatedAt = formatters
                .format(DateTime.tryParse(billings[i].createdAt).toLocal());
          }
          if (isorderby) {
            billings.sort((a, b) => a.sortCreatedAt.compareTo(b.sortCreatedAt));
          } else {
            billings.sort((a, b) => a.sortCreatedAt.compareTo(b.sortCreatedAt));
            billings = billings.reversed.toList();
          }
          break;
        case "Invoice Amount":
          if (isorderby) {
            billings.sort((a, b) => double.tryParse(a.billAmount)
                .compareTo(double.tryParse(b.billAmount)));
          } else {
            billings.sort((a, b) => double.tryParse(a.billAmount)
                .compareTo(double.tryParse(b.billAmount)));
            billings = billings.reversed.toList();
          }
          break;
        default:
      }
    }

    return Expanded(
        child:
            //     LazyLoadScrollView(
            //   isLoading: isLoadings,
            //   onEndOfPage: () => _loadMore(),
            //   child: ListView.builder(
            //     itemCount: billings == null ? 0 : data.length,
            //     itemBuilder: (context, i) {
            //       return _billingView(billings[i]);
            //     },
            //   ),
            // )

            new ListView.builder(
                itemCount: billings == null ? 0 : billings.length,
                itemBuilder: (BuildContext context, int i) {
                  return _billingView(billings[i]);
                }));
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
                    children: <Widget>[
                      Container(height: 7.0),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("# " + billing.customerData.customerId,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                          ),
                          Text(billing.billFor,
                              style: TextStyle(
                                  fontSize: 12.0, color: Color(0xfff4f4f4))),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                          ),
                          Text(
                            formatter.format(
                                DateTime.tryParse(billing.createdAt).toLocal()),
                            style: TextStyle(
                                fontSize: 12.0, color: Color(0xfff4f4f4)),
                          )
                        ],
                      )),
                      Container(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Rs. ' + billing.billAmount,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow)),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Text(billing.billId,
                              style: TextStyle(color: Color(0xfff4f4f4))),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Container(
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
                                style: TextStyle(
                                  color: Color(0xfff4f4f4),
                                ),
                              )),
                        ],
                      )
                    ],
                  ))),
        ));
  }

  Widget _buildList() {
    List<Billing> tempList = [];
    if (_searchText.isNotEmpty) {
      for (int i = 0; i < billings.length; i++) {
        try {
          if (billings[i]
                  .billId
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              billings[i]
                  .billAmount
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              billings[i]
                  .billFor
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              billings[i]
                  .monthlyRent
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              billings[i]
                  .customerData
                  .customerName
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              billings[i]
                  .customerData
                  .customerId
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              billings[i]
                  .customerData
                  .address
                  .street
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              billings[i]
                  .customerData
                  .address
                  .area
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              billings[i]
                  .customerData
                  .address
                  .mobile
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              billings[i]
                  .customerData
                  .address
                  .alternateNumber
                  .toLowerCase()
                  .contains(_searchText.toLowerCase())) {
            tempList.add(billings[i]);
          }
        } catch (error) {
          print(error);
        }
      }
    }
    searchList = tempList;
    if (tempList.length == 0) {
      searchList = billings;
    }
    if (_isfilter == true) {
      List<Billing> tempList = [];
      for (int i = 0; i < searchList.length; i++) {
        try {
          if (billStatus == "All") {
            tempList.add(searchList[i]);
          } else if (searchList[i].paidStatus == billStatus) {
            tempList.add(searchList[i]);
          }
        } catch (e) {
          print(e);
        }
      }
      searchList = tempList;
      if (_isfilter == true) {
        List<Billing> tempList = [];
        for (int i = 0; i < searchList.length; i++) {
          try {
            if (customerStatus == "All") {
              tempList.add(searchList[i]);
            } else if (customerStatus == "Active") {
              if (searchList[i].customerData.activeStatus == true) {
                tempList.add(searchList[i]);
              }
            } else if (customerStatus == "Inactive") {
              if (searchList[i].customerData.activeStatus == false ||
                  searchList[i].customerData.activeStatus == null) {
                tempList.add(searchList[i]);
              }
            }
          } catch (e) {
            print(e);
          }
        }
        searchList = tempList;
        if (_isfilter == true) {
          List<Billing> tempList = [];
          for (int i = 0; i < searchList.length; i++) {
            try {
              if (connectionType == "All") {
                tempList.add(searchList[i]);
              } else if (searchList[i].billFor == connectionType) {
                tempList.add(searchList[i]);
              }
            } catch (e) {
              print(e);
            }
          }
          searchList = tempList;
        }
        if (_isfilter == true) {
          List<Billing> tempList = [];
          for (int i = 0; i < searchList.length; i++) {
            try {
              if (collectionagent == "All") {
                tempList.add(searchList[i]);
              } else if (searchList[i].customerData.collectionAgent ==
                  collectionagent) {
                tempList.add(searchList[i]);
              }
            } catch (e) {
              print(e);
            }
          }
          searchList = tempList;
          if (_isfilter == true) {
            List<Billing> tempList = [];
            for (int i = 0; i < searchList.length; i++) {
              try {
                if (street == "All") {
                  tempList.add(searchList[i]);
                } else if (searchList[i].customerData.address.street ==
                    street) {
                  tempList.add(searchList[i]);
                }
              } catch (e) {
                print(e);
              }
            }
            searchList = tempList;
            if (_isfilter == true) {
              List<Billing> tempList = [];
              for (int i = 0; i < searchList.length; i++) {
                try {
                  if (area == "All") {
                    tempList.add(searchList[i]);
                  } else if (searchList[i].customerData.address.area == area) {
                    tempList.add(searchList[i]);
                  }
                } catch (e) {
                  print(e);
                }
              }
              searchList = tempList;
              if (_isfilter == true) {
                String _sublcoid;
                for (var i = 0; i < sublcos.length; i++) {
                  if (sublcos[i].subLcoName == subLco) {
                    _sublcoid = sublcos[i].id;
                  }
                }
                List<Billing> tempList = [];
                for (int i = 0; i < searchList.length; i++) {
                  try {
                    if (subLco == "All") {
                      tempList.add(searchList[i]);
                    } else if (searchList[i].customerData.lcoId == _sublcoid) {
                      tempList.add(searchList[i]);
                    }
                  } catch (e) {
                    print(e);
                  }
                }
                searchList = tempList;
              }
            }
          }
        }
      }
    }
    if (searchList != null) {
      switch (sortby) {
        case "Customer ID":
          for (var i = 0; i < searchList.length; i++) {
            setState(() {
              try {
                if (int.tryParse(searchList[i].customerId) -
                        int.tryParse(searchList[i].customerId) ==
                    0) {
                  searchList[i].sortCustomerId = searchList[i].customerId;
                  int idLength;
                  idLength = 50 - searchList[i].customerId.length;
                  for (var j = 0; j <= idLength; j++) {
                    searchList[i].sortCustomerId =
                        "0" + searchList[i].sortCustomerId;
                  }
                }
              } catch (e) {
                searchList[i].sortCustomerId = searchList[i].customerId;
              }
            });
          }
          if (isorderby) {
            searchList
                .sort((a, b) => a.sortCustomerId.compareTo(b.sortCustomerId));
          } else {
            searchList
                .sort((a, b) => a.sortCustomerId.compareTo(b.sortCustomerId));
            searchList = searchList.reversed.toList();
          }
          break;
        case "Customer Name":
          if (isorderby) {
            searchList.sort((a, b) => a.customerData.customerName
                .compareTo(b.customerData.customerName));
          } else {
            searchList.sort((a, b) => a.customerData.customerName
                .compareTo(b.customerData.customerName));
            searchList = searchList.reversed.toList();
          }
          break;
        case "Created Date":
          for (var i = 0; i < searchList.length; i++) {
            searchList[i].sortCreatedAt = formatters
                .format(DateTime.tryParse(searchList[i].createdAt).toLocal());
          }
          if (isorderby) {
            searchList
                .sort((a, b) => a.sortCreatedAt.compareTo(b.sortCreatedAt));
          } else {
            searchList
                .sort((a, b) => a.sortCreatedAt.compareTo(b.sortCreatedAt));
            searchList = searchList.reversed.toList();
          }
          break;
        case "Invoice Amount":
          if (isorderby) {
            searchList.sort((a, b) => double.tryParse(a.billAmount)
                .compareTo(double.tryParse(b.billAmount)));
          } else {
            searchList.sort((a, b) => double.tryParse(a.billAmount)
                .compareTo(double.tryParse(b.billAmount)));
            searchList = searchList.reversed.toList();
          }
          break;
        default:
      }
    }

    return Expanded(
      child: new ListView.builder(
          itemCount: searchList == null ? 0 : searchList.length,
          itemBuilder: (BuildContext context, int i) {
            return _billingView(searchList[i]);
          }),
    );
  }

  Widget searchBar() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Find Invoice",
                  hintStyle: TextStyle(color: Colors.white30)),
              cursorColor: Colors.white,
              autofocus: true,
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
        ],
      );

  Widget filter() {
    List<String> streetList = ['All'];
    List<String> areaList = ['All'];
    List<String> collectionAgentList = ['All'];
    List<String> subLcoList = ['All'];
    for (int i = 0; i < streets.length; i++) {
      streetList.add(streets[i].street);
    }
    for (int i = 0; i < areas.length; i++) {
      areaList.add(areas[i].area);
    }
    for (int i = 0; i < collectionagents.length; i++) {
      collectionAgentList.add(collectionagents[i].userName);
    }
    for (int i = 0; i < sublcos.length; i++) {
      subLcoList.add(sublcos[i].subLcoName);
    }
    return Drawer(
      child: Column(
        children: <Widget>[
          Ink(
              height: 86,
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Color(0xffae275f), Colors.pink])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 50.0,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        "Invoice Filter & Sort",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      )
                    ],
                  ),
                ],
              )),
          Expanded(
            child:
                ListView(padding: new EdgeInsets.all(0.0), children: <Widget>[
              Container(
                color: Colors.grey[200],
                height: 10.0,
              ),
              Container(
                color: Colors.grey[200],
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 10.0,
                    ),
                    Text(
                      'Sort By',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[200],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButton<String>(
                          isExpanded: true,
                          elevation: 8,
                          items: <String>[
                            'Customer ID',
                            'Customer Name',
                            'Created Date',
                            'Invoice Amount'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      value,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          value: sortby,
                          onChanged: (newVal) {
                            setState(() {
                              sortby = newVal;
                            });
                          }),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    isorderby
                        ? IconButton(
                            color: Color(0xffae275f),
                            icon: Icon(Icons.arrow_downward),
                            onPressed: () {
                              setState(() {
                                isorderby = !isorderby;
                              });
                            },
                          )
                        : IconButton(
                            color: Color(0xffae275f),
                            icon: Icon(Icons.arrow_upward),
                            onPressed: () {
                              setState(() {
                                isorderby = !isorderby;
                              });
                            },
                          ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[200],
                height: 5.0,
              ),
              Container(
                height: 5.0,
              ),
              GestureDetector(
                onTap: () {
                  _dateRange(context);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Text(
                          "Date : ( " + _fromdate + "  to  " + _todate + " )"),
                    ),
                    Container(width: 5.0),
                    InkWell(
                      onTap: () {
                        // _setDateRange();
                        _dateRange(context);
                      },
                      highlightColor: Colors.green,
                      child: Icon(
                        Icons.date_range,
                        size: 30.0,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Container(width: 5.0),
                  ],
                ),
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Container(
                    width: 10.0,
                  ),
                  Text(
                    'Bill Status',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ],
              ),
              DropdownButton<String>(
                  elevation: 8,
                  isExpanded: true,
                  items: <String>[
                    'All',
                    'Fully Paid',
                    'Unpaid',
                    'Partial Paid',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Text(
                              value,
                              overflow: TextOverflow.visible,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  value: billStatus,
                  onChanged: (newVal) {
                    setState(() {
                      billStatus = newVal;
                    });
                  }),
              Container(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 10.0,
                  ),
                  Text(
                    'Customer Status',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ],
              ),
              DropdownButton<String>(
                  elevation: 8,
                  isExpanded: true,
                  items: <String>[
                    'All',
                    'Active',
                    'Inactive',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Text(
                              value,
                              overflow: TextOverflow.visible,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  value: customerStatus,
                  onChanged: (newVal) {
                    setState(() {
                      customerStatus = newVal;
                    });
                  }),
              Container(
                height: 10.0,
              ),
              streets.length > 0
                  ? Row(
                      children: <Widget>[
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          'Street',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              streets.length > 0
                  ? DropdownButton<String>(
                      elevation: 8,
                      isExpanded: true,
                      items: streetList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Text(
                                  value,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      value: street,
                      onChanged: (newVal) {
                        setState(() {
                          street = newVal;
                        });
                      })
                  : Container(),
              streets.length > 0
                  ? Container(
                      height: 10.0,
                    )
                  : Container(),
              areas.length > 0
                  ? Row(
                      children: <Widget>[
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          'Area',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              areas.length > 0
                  ? DropdownButton<String>(
                      elevation: 8,
                      isExpanded: true,
                      items: areaList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Text(
                                  value,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      value: area,
                      onChanged: (newVal) {
                        setState(() {
                          area = newVal;
                        });
                      })
                  : Container(),
              areas.length > 0
                  ? Container(
                      height: 10.0,
                    )
                  : Container(),
              collectionagents.length < 0
                  ? Container()
                  : Row(
                      children: <Widget>[
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          'Collection Agent',
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                      ],
                    ),
              collectionagents.length < 0
                  ? Container()
                  : DropdownButton<String>(
                      elevation: 8,
                      isExpanded: true,
                      items: collectionAgentList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Text(
                                  value,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      value: collectionagent,
                      onChanged: (newVal) {
                        setState(() {
                          collectionagent = newVal;
                        });
                      }),
              collectionagents.length < 0
                  ? Container()
                  : Container(
                      height: 10.0,
                    ),
              Row(
                children: <Widget>[
                  Container(
                    width: 10.0,
                  ),
                  Text(
                    'Connection Type',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ],
              ),
              DropdownButton<String>(
                  elevation: 8,
                  isExpanded: true,
                  items:
                      <String>['All', 'Cable', 'Internet'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Text(
                              value,
                              overflow: TextOverflow.visible,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  value: connectionType,
                  onChanged: (newVal) {
                    setState(() {
                      connectionType = newVal;
                    });
                  }),
              Container(
                height: 10.0,
              ),
              sublcos.length > 0
                  ? Row(
                      children: <Widget>[
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          'Sub Lco',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              sublcos.length > 0
                  ? DropdownButton<String>(
                      elevation: 8,
                      isExpanded: true,
                      items: subLcoList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Text(
                                  value,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      value: subLco,
                      onChanged: (newVal) {
                        setState(() {
                          subLco = newVal;
                        });
                      })
                  : Container(),
            ]),
          ),
          Container(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Divider(),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 10.0,
                          ),
                          Expanded(
                            child: FloatingActionButton(
                              mini: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(
                                  color: Color(0xffae275f),
                                  width: 1.0,
                                ),
                              ),
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xffae275f),
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                  _isfilter = false;
                                  resetFilter(0);
                                  isDateRange = false;
                                  getData();
                                });
                              },
                              child: Text("Reset Filter"),
                            ),
                          ),
                          Container(
                            height: 20.0,
                            width: 1.0,
                            color: Colors.black38,
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Expanded(
                            child: FloatingActionButton(
                              mini: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(
                                  color: Color.fromARGB(255, 41, 153, 102),
                                  width: 1.0,
                                ),
                              ),
                              backgroundColor: Colors.white,
                              foregroundColor:
                                  Color.fromARGB(255, 41, 153, 102),
                              onPressed: () {
                                setState(() {
                                  // _isLoading = true;
                                  _isfilter = true;
                                  // isDateRange = true;
                                  // getData();
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Text("Apply Filter"),
                            ),
                          ),
                          Container(
                            width: 5.0,
                          ),
                        ],
                      ),
                      Container(
                        height: 30.0,
                      ),
                    ],
                  )))),
        ],
      ),
    );
  }
}
