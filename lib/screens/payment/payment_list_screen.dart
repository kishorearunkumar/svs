import 'package:flutter/material.dart';
import 'package:svs/models/billing.dart';
import 'package:svs/models/complaint.dart';
import 'package:svs/models/customer.dart';
import 'package:svs/widgets/my_drawer.dart';
import 'package:svs/models/payment.dart';
import 'package:svs/models/payment-category.dart';
import 'package:svs/services/basic_service.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:svs/models/street.dart';
import 'package:svs/models/area.dart';
import 'package:svs/screens/payment/add_payment_screen.dart';
import 'package:svs/widgets/payment_view.dart';
import 'package:svs/widgets/loader.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:svs/models/username.dart';
// import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:svs/models/login-response.dart';
// import "package:pull_to_refresh/pull_to_refresh.dart";

class PaymentListScreen extends StatefulWidget {
  final int filterIndex;
  PaymentListScreen({Key key, @required this.filterIndex}) : super(key: key);
  _PaymentListScreenState createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  // Size deviceSize;
  // double screenWidth = 0.0;
  List<Payment> payments;
  List<Payment> searchList;
  bool _isSearching = false;
  bool _isLoading = true;
  bool _isfilter = false;
  bool _isRefresh = false;
  List<Street> streets = [];
  List<Areas> areas = [];
  String street = "All";
  String area = "All";
  final GlobalKey<ScaffoldState> paymentListKey =
      new GlobalKey<ScaffoldState>();
  final TextEditingController _search = new TextEditingController();
  var dateFormatter = new DateFormat('dd-MM-yyyy');

  String _fromdate = "01-" +
      DateFormat("MM").format(DateTime.now()) +
      "-" +
      DateFormat("yyyy").format(DateTime.now());

  String _todate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  String _searchText = "";

  List<Username> collectedbys = [];
  String collectedby = "All";
  String connectionType = "All";
  String date = "All";
  String month = "All";
  String year = "All";
  List<PaymentCategory> paymentFors = [];
  String paymentFor = "All";
  String paymentMode = "All";
  String sortby = "Created Date";

  bool isorderby = false;
  bool isDateRange = false;
  LoginResponse user;

  var formatter = new DateFormat('dd-MM-yyyy hh:mm aaa');
  var formatters = new DateFormat('yyyyMMddHHmmssSSS');
  var currencyFormatter = NumberFormat("##,##,###");

  List<Payment> _offlineSubscriptionPayments = [];
  List<Payment> _offlineInstallationPayments = [];
  List<Payment> _offlineOthersPayments = [];
  List<Customer> _customerList = [];
  List<Billing> _billingList = [];
  List<Payment> _paymentList = [];
  List<Complaint> _complaintList = [];

  _PaymentListScreenState() {
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

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    _isLoading = true;
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
    // getListOldData();
    // getListData();
    getData();
  }

  Future pause(Duration d) => new Future.delayed(d);

  //------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _search.clear();
    // getListOldData();
    // getListData();
    getData();
    resetFilter();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  resetFilter() {
    setState(() {
      street = "All";
      area = "All";
      collectedby = "All";
      connectionType = "All";
      date = "All";
      month = "All";
      year = "All";
      paymentFor = "All";
      paymentMode = "All";
      _isfilter = false;
      sortby = "Created Date";
      isorderby = false;
      _fromdate = "01-" +
          DateFormat("MM").format(DateTime.now()) +
          "-" +
          DateFormat("yyyy").format(DateTime.now());
      _todate = dateFormatter.format(DateTime.now());
    });
  }
//------------------------------------------------------------------------------

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

  // getListData() {
  //   customerList().then((response) {
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         _customerList =
  //             customerFromJson(Utf8Codec().decode(response.bodyBytes));
  //         AppSharedPreferences.setCustomers(_customerList);
  //         getListOldData();
  //       });
  //     } else {
  //       setState(() {
  //         getListOldData();
  //       });
  //     }
  //   }).catchError((error) {
  //     setState(() {
  //       getListOldData();
  //     });
  //   });
  //   billingList().then((response) {
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         _billingList =
  //             billingFromJson(Utf8Codec().decode(response.bodyBytes));
  //         AppSharedPreferences.setBillings(_billingList);
  //         getListOldData();
  //       });
  //     } else {
  //       setState(() {
  //         getListOldData();
  //       });
  //     }
  //   }).catchError((error) {
  //     setState(() {
  //       getListOldData();
  //     });
  //   });
  // }

  // Future getListOldData() async {
  //   try {
  //     _offlineSubscriptionPayments =
  //         await AppSharedPreferences.getOfflineSubscriptionPayments();
  //   } catch (e) {
  //     print(e);
  //   }
  //   try {
  //     _offlineInstallationPayments =
  //         await AppSharedPreferences.getOfflineInstallationPayments();
  //   } catch (e) {
  //     print(e);
  //   }
  //   try {
  //     _offlineOthersPayments =
  //         await AppSharedPreferences.getOfflineOthersPayments();
  //   } catch (e) {
  //     print(e);
  //   }
  //   // try {
  //   //   _paymentList = await AppSharedPreferences.getPayments();
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  //   // try {
  //   //   _customerList = await AppSharedPreferences.getCustomers();
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  //   // try {
  //   //   _billingList = await AppSharedPreferences.getBillings();
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  //   // try {
  //   //   _complaintList = await AppSharedPreferences.getComplaints();
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  //   // try {
  //   //   _offlineSubscriptionPayments =
  //   //       await AppSharedPreferences.getOfflineSubscriptionPayments();
  //   //   _offlineInstallationPayments =
  //   //       await AppSharedPreferences.getOfflineInstallationPayments();
  //   //   _offlineOthersPayments =
  //   //       await AppSharedPreferences.getOfflineOthersPayments();
  //   //   _customerList = await AppSharedPreferences.getCustomers();
  //   //   _billingList = await AppSharedPreferences.getBillings();
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  // }

  Future<void> getData() async {
    await getOldData();
    if (isDateRange) {
      paymentListDateRange(_fromdate, _todate).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            payments = paymentsFromJson(Utf8Codec().decode(response.bodyBytes));
          });
          AppSharedPreferences.setPayments(payments);
          _isLoading = false;
          _isRefresh = false;
        } else {
          paymentListKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("Something went wrong !!"),
          ));
          _isRefresh = false;
        }
      }).catchError((error) {
        paymentListKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("No Internet Connection. Loading Offline Content."),
          behavior: SnackBarBehavior.floating,
        ));
        setState(() {
          getOldData();
          _isLoading = false;
          _isRefresh = false;
        });
      });
    } else {
      paymentList().then((response) {
        if (response.statusCode == 200) {
          setState(() {
            payments = paymentsFromJson(Utf8Codec().decode(response.bodyBytes));
          });
          AppSharedPreferences.setPayments(payments);
          _isLoading = false;
          _isRefresh = false;
        } else {
          paymentListKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("Something went wrong !!"),
          ));
          _isRefresh = false;
        }
      }).catchError((error) {
        paymentListKey.currentState.showSnackBar(new SnackBar(
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
    getCollectbyData();
    getPaymentforData();
    _isRefresh = false;
  }

  Future getOldData() async {
    try {
      await pause(const Duration(milliseconds: 500));
      payments = await AppSharedPreferences.getPayments();

      _isLoading = false;
      _isRefresh = false;
      collectedbys = await AppSharedPreferences.getUsername();
      collectedbys.sort((a, b) =>
          a.userName.toLowerCase().compareTo(b.userName.toLowerCase()));
      paymentFors = await AppSharedPreferences.getPaymentCategory();
    } catch (e) {
      print(e);
    }
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

  getCollectbyData() {
    usernameList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          collectedbys =
              usernamesFromJson(Utf8Codec().decode(response.bodyBytes));
        });
        collectedbys.sort((a, b) =>
            a.userName.toLowerCase().compareTo(b.userName.toLowerCase()));
        AppSharedPreferences.setUsername(collectedbys);
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
      });
    });
  }

  getPaymentforData() {
    paymentCategoryList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          paymentFors =
              paymentCategorysFromJson(Utf8Codec().decode(response.bodyBytes));
        });
        AppSharedPreferences.setPaymentCategory(paymentFors);
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: paymentListKey,
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: _isSearching
              ? searchBar()
              : new Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        child: Text('Payments'),
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
                paymentListKey.currentState.openEndDrawer();
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
                    ? paymentListView()
                    : _buildList(),
                user.operatorId != "OM_KALIAMMAN_CABLE_ERODE"
                    ? totalCountpaymentListView()
                    : Container(),
              ]),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "addPayment",
              clipBehavior: Clip.antiAlias,
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => AddPaymentScreen()));
              },
              child: Ink(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [Colors.pink, Colors.pinkAccent[200]])),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Icon(
                      Icons.add_circle,
                      color: Colors.white,
                      size: 32.0,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
          ],
        ));
  }

  Widget totalCountpaymentListView() {
    double amountPaidt = 0.0;
    setState(() {
      if (_search.text.isEmpty && !_isfilter) {
        amountPaidt = 0.0;
        for (var i = 0; i < payments.length; i++) {
          if (payments[i].amountPaid != null &&
              payments[i].amountPaid.isNotEmpty) {
            try {
              amountPaidt =
                  amountPaidt + double.tryParse(payments[i].amountPaid);
            } catch (e) {}
          }
        }
      } else {
        amountPaidt = 0.0;
        for (var i = 0; i < searchList.length; i++) {
          if (searchList[i].amountPaid != null &&
              searchList[i].amountPaid.isNotEmpty) {
            try {
              amountPaidt =
                  amountPaidt + double.tryParse(searchList[i].amountPaid);
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
                            payments.length.toString(),
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
                      "Rs. " + currencyFormatter.format(amountPaidt),
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

  Widget paymentListView() {
    if (payments != null) {
      switch (sortby) {
        case "Customer ID":
          for (var i = 0; i < payments.length; i++) {
            setState(() {
              try {
                if (int.tryParse(payments[i].customerId) -
                        int.tryParse(payments[i].customerId) ==
                    0) {
                  payments[i].sortCustomerId = payments[i].customerId;
                  int idLength;
                  idLength = 50 - payments[i].customerId.length;
                  for (var j = 0; j <= idLength; j++) {
                    payments[i].sortCustomerId =
                        "0" + payments[i].sortCustomerId;
                  }
                }
              } catch (e) {
                payments[i].sortCustomerId = payments[i].customerId;
              }
            });
          }
          if (isorderby) {
            payments
                .sort((a, b) => a.sortCustomerId.compareTo(b.sortCustomerId));
          } else {
            payments
                .sort((a, b) => a.sortCustomerId.compareTo(b.sortCustomerId));
            payments = payments.reversed.toList();
          }
          break;
        case "Customer Name":
          if (isorderby) {
            payments.sort((a, b) => a.customerData.customerName
                .compareTo(b.customerData.customerName));
          } else {
            payments.sort((a, b) => a.customerData.customerName
                .compareTo(b.customerData.customerName));
            payments = payments.reversed.toList();
          }
          break;
        case "Created Date":
          for (var i = 0; i < payments.length; i++) {
            payments[i].sortCreatedAt = formatters
                .format(DateTime.tryParse(payments[i].createdAt).toLocal());
          }
          if (isorderby) {
            payments.sort((a, b) => a.sortCreatedAt.compareTo(b.sortCreatedAt));
          } else {
            payments.sort((a, b) => a.sortCreatedAt.compareTo(b.sortCreatedAt));
            payments = payments.reversed.toList();
          }
          break;
        case "Amount Paid":
          if (isorderby) {
            payments.sort((a, b) => double.tryParse(a.amountPaid)
                .compareTo(double.tryParse(b.amountPaid)));
          } else {
            payments.sort((a, b) => double.tryParse(a.amountPaid)
                .compareTo(double.tryParse(b.amountPaid)));
            payments = payments.reversed.toList();
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
            //     itemCount: payments == null ? 0 : data.length,
            //     itemBuilder: (context, i) {
            //       return _paymentView(payments[i]);
            //     },
            //   ),
            // )

            new ListView.builder(
                itemCount: payments == null ? 0 : payments.length,
                itemBuilder: (BuildContext context, int i) {
                  return _paymentView(payments[i]);
                }));
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
                    children: <Widget>[
                      Container(height: 7.0),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              width: 85.0,
                              child: Text(
                                  "# " + payment.customerData.customerId,
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
                          Container(
                              width: 105.0,
                              child: Text(payment.paymentFor,
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
                          Container(
                              width: 118.0,
                              child: Text(
                                formatter.format(
                                    DateTime.tryParse(payment.createdAt)
                                        .toLocal()),
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
                          Text('Rs. ' + payment.amountPaid,
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
                          Text(payment.paymentMode,
                              style: TextStyle(color: Color(0xfff4f4f4))),
                          Container(
                            height: 15.0,
                            width: 1.0,
                            color: Colors.white30,
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Text(
                            payment.created.isNotEmpty
                                ? payment.created[0].userName
                                : '',
                            style: TextStyle(color: Color(0xfff4f4f4)),
                          )
                        ],
                      )
                    ],
                  ))),
        ));
  }

  Widget _buildList() {
    List<Payment> tempList = [];
    if (_searchText.isNotEmpty) {
      for (int i = 0; i < payments.length; i++) {
        try {
          if (payments[i]
                  .invoiceId
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              payments[i]
                  .amountPaid
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              payments[i]
                  .paymentFor
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              payments[i]
                  .paymentMode
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              payments[i]
                  .customerData
                  .customerName
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              payments[i]
                  .customerData
                  .customerId
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              payments[i]
                  .customerData
                  .address
                  .street
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              payments[i]
                  .customerData
                  .address
                  .area
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              payments[i]
                  .customerData
                  .address
                  .mobile
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              payments[i]
                  .customerData
                  .address
                  .alternateNumber
                  .toLowerCase()
                  .contains(_searchText.toLowerCase())) {
            tempList.add(payments[i]);
          }
        } catch (error) {
          print(error);
        }
      }
    }
    searchList = tempList;
    if (tempList.length == 0) {
      searchList = payments;
    }
    if (_isfilter == true) {
      List<Payment> tempList = [];
      for (int i = 0; i < searchList.length; i++) {
        try {
          if (paymentFor == "All") {
            tempList.add(searchList[i]);
          } else if (searchList[i].paymentFor == paymentFor) {
            tempList.add(searchList[i]);
          }
        } catch (e) {
          print(e);
        }
      }
      searchList = tempList;

      if (_isfilter == true) {
        String _createdbyid;
        for (var i = 0; i < collectedbys.length; i++) {
          if (collectedbys[i].userName == collectedby) {
            _createdbyid = collectedbys[i].id;
          }
        }
        List<Payment> tempList = [];
        for (int i = 0; i < searchList.length; i++) {
          try {
            if (collectedby == "All") {
              tempList.add(searchList[i]);
            } else if (searchList[i].createdBy == _createdbyid) {
              tempList.add(searchList[i]);
            }
          } catch (e) {
            print(e);
          }
        }
        searchList = tempList;
        if (_isfilter == true) {
          List<Payment> tempList = [];
          for (int i = 0; i < searchList.length; i++) {
            try {
              if (street == "All") {
                tempList.add(searchList[i]);
              } else if (searchList[i].customerData.address.street == street) {
                tempList.add(searchList[i]);
              }
            } catch (e) {
              print(e);
            }
          }
          searchList = tempList;
          if (_isfilter == true) {
            List<Payment> tempList = [];
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
              List<Payment> tempList = [];
              for (int i = 0; i < searchList.length; i++) {
                try {
                  if (paymentMode == "All") {
                    tempList.add(searchList[i]);
                  } else if (searchList[i].paymentMode == paymentMode) {
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
        case "Amount Paid":
          if (isorderby) {
            searchList.sort((a, b) => double.tryParse(a.amountPaid)
                .compareTo(double.tryParse(b.amountPaid)));
          } else {
            searchList.sort((a, b) => double.tryParse(a.amountPaid)
                .compareTo(double.tryParse(b.amountPaid)));
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
            return _paymentView(searchList[i]);
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
                  hintText: "Find Payment",
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
    List<String> collectedbyList = ['All'];
    List<String> paymentforList = [
      'All',
      'Cable Subscription',
      'Internet Subscription',
      'Installation'
    ];

    for (int i = 0; i < streets.length; i++) {
      streetList.add(streets[i].street);
    }
    for (int i = 0; i < areas.length; i++) {
      areaList.add(areas[i].area);
    }
    for (int i = 0; i < collectedbys.length; i++) {
      collectedbyList.add(collectedbys[i].userName);
    }
    for (int i = 0; i < paymentFors.length; i++) {
      paymentforList.add(paymentFors[i].paymentCategory);
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
                        "Payment Filter & Sort",
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
                            'Amount Paid'
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
              collectedbys.length < 0
                  ? Container()
                  : Row(
                      children: <Widget>[
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          'Collected By',
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                      ],
                    ),
              collectedbys.length < 0
                  ? Container()
                  : DropdownButton<String>(
                      elevation: 8,
                      isExpanded: true,
                      items: collectedbyList.map((String value) {
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
                      value: collectedby,
                      onChanged: (newVal) {
                        setState(() {
                          collectedby = newVal;
                        });
                      }),
              collectedbys.length < 0
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
                    'Payment For',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ],
              ),
              DropdownButton<String>(
                  elevation: 8,
                  isExpanded: true,
                  items: paymentforList.map((String value) {
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
                  value: paymentFor,
                  onChanged: (newVal) {
                    setState(() {
                      paymentFor = newVal;
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
                    'Payment Mode',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ],
              ),
              DropdownButton<String>(
                  elevation: 8,
                  isExpanded: true,
                  items: <String>[
                    'All',
                    'Cash',
                    'Card',
                    'Debit Card',
                    'Credit Card',
                    'Cheque',
                    'PayTM',
                    'Google Pay',
                    'Other',
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
                  value: paymentMode,
                  onChanged: (newVal) {
                    setState(() {
                      paymentMode = newVal;
                    });
                  }),
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
                                  resetFilter();
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
