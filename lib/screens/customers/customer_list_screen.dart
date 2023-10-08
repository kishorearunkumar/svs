import 'package:flutter/material.dart';
import 'package:svs/models/customer.dart';
import 'package:svs/models/street.dart';
import 'package:svs/models/area.dart';
import 'package:svs/services/basic_service.dart';
import 'dart:convert';
import 'package:svs/widgets/customer_view.dart';
import 'package:svs/widgets/my_drawer.dart';
import 'package:svs/screens/customers/add_customer_screen.dart';
import 'package:svs/widgets/loader.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:svs/models/username.dart';
import 'package:svs/models/sublco.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_pagewise/flutter_pagewise.dart';
// import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:svs/models/login-response.dart';

// import "package:pull_to_refresh/pull_to_refresh.dart";
// import 'package:svs/screens/layout/home_layout.dart';

class CustomerListScreen extends StatefulWidget {
  final int filterIndex;
  CustomerListScreen({Key key, @required this.filterIndex}) : super(key: key);
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  double screenWidth = 0.0;
  List<Customer> customers;
  List<Street> streets = [];
  List<Areas> areas = [];
  List<Username> collectionagents = [];
  List<SubLco> sublcos = [];
  List<Customer> searchList;
  LoginResponse user;
  bool _isSearching = false;
  bool _isLoading = true;
  bool _isfilter = false;
  bool _isRefresh = false;

  final TextEditingController _search = new TextEditingController();
  final TextEditingController _outstandingAmountController =
      new TextEditingController();
  String outstandingAmount = "0";
  final TextEditingController _installationDueController =
      new TextEditingController();
  String installationDue = "0";
  final TextEditingController _monthlyRentController =
      new TextEditingController();
  String monthlyRent = "0";
  final GlobalKey<ScaffoldState> customerListKey =
      new GlobalKey<ScaffoldState>();
  String _searchText = "";

  int filterIndex;
  var formatters = new DateFormat('yyyyMMddHHmmssSSS');
  var currencyFormatter = NumberFormat("##,##,##,###");

  String customerStatus = "All";
  String connectionType = "All";
  String residentType = "All";
  String street = "All";
  String area = "All";
  String collectionAgent = "All";
  String subLco = "All";
  String outstandingComparison = "Greater than";
  String installationDueComparison = "Greater than";
  String monthlyRentComparison = "Greater than";
  String sortby = "Customer ID";

  bool isorderby = true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _CustomerListScreenState() {
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

  // Future<void> initUserProfile() async {
  //   try {
  //     LoginResponse up = await AppSharedPreferences.getUserProfile();
  //     setState(() {
  //       user = up;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  //------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    filterIndex = widget.filterIndex;
    _search.clear();

    getData();
    // _loadMore();

    resetFilter(filterIndex);
  }

  //------------------------------------------------------------------------------
  Future<void> getData() async {
    // await pause(const Duration(milliseconds: 2000));
    // await initUserProfile();

    await getOldData();

    String statusCode = await AppSharedPreferences.getCustomerSuccess();
    if (statusCode == "201") {
      customerListKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.green,
        content: new Text("Customer Added Successfully!!"),
      ));

      setState(() {
        AppSharedPreferences.setCustomerSuccess("");
      });
    }

    customerList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          customers = customerFromJson(Utf8Codec().decode(response.bodyBytes));

          // _loadMore();
        });
        AppSharedPreferences.setCustomers(customers);
        _isLoading = false;
        _isRefresh = false;
      } else {
        customerListKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("Something went wrong !!"),
        ));
        _isRefresh = false;
      }
    }).catchError((error) {
      print(error);
      customerListKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.redAccent[400],
        content: new Text("No Internet Connection. Loading Offline Content."),
      ));
      setState(() {
        getOldData();
        _isLoading = false;
        _isRefresh = false;
      });
    });
    getStreetData();
    getAreaData();
    getCollectionAgentData();
    getSubLcoData();
    _isRefresh = false;
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

  Future getOldData() async {
    try {
      await pause(const Duration(milliseconds: 500));
      customers = await AppSharedPreferences.getCustomers();
      // _loadMore();
      _isLoading = false;
      _isRefresh = false;
      streets = await AppSharedPreferences.getStreets();
      streets.sort(
          (a, b) => a.street.toLowerCase().compareTo(b.street.toLowerCase()));
      areas = await AppSharedPreferences.getAreas();
      areas
          .sort((a, b) => a.area.toLowerCase().compareTo(b.area.toLowerCase()));
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
  //------------------------------------------------------------------------------

  resetFilter(int fitlerIndex) {
    switch (fitlerIndex) {
      case 0:
        setState(() {
          customerStatus = "All";
          connectionType = "All";
          residentType = "All";
          street = "All";
          area = "All";
          collectionAgent = "All";
          subLco = "All";
          _outstandingAmountController.clear();
          _installationDueController.clear();
          _monthlyRentController.clear();
          _isfilter = false;
          sortby = "Customer ID";

          isorderby = true;
        });
        break;
      case 1:
        setState(() {
          customerStatus = "Active";
          connectionType = "All";
          residentType = "All";
          street = "All";
          area = "All";
          collectionAgent = "All";
          subLco = "All";
          _outstandingAmountController.clear();
          _installationDueController.clear();
          _monthlyRentController.clear();
          _isfilter = true;
          sortby = "Customer ID";

          isorderby = true;
        });
        break;
      case 2:
        setState(() {
          customerStatus = "Inactive";
          connectionType = "All";
          residentType = "All";
          street = "All";
          area = "All";
          collectionAgent = "All";
          subLco = "All";
          _outstandingAmountController.clear();
          _installationDueController.clear();
          _monthlyRentController.clear();
          _isfilter = true;
          sortby = "Customer ID";

          isorderby = true;
        });
        break;
      case 3:
        setState(() {
          customerStatus = "Active";
          connectionType = "Cable";
          residentType = "All";
          street = "All";
          area = "All";
          collectionAgent = "All";
          subLco = "All";
          _outstandingAmountController.clear();
          _installationDueController.clear();
          _monthlyRentController.clear();
          _isfilter = true;
          sortby = "Customer ID";

          isorderby = true;
        });
        break;
      case 4:
        setState(() {
          customerStatus = "Inactive";
          connectionType = "Cable";
          residentType = "All";
          street = "All";
          area = "All";
          collectionAgent = "All";
          subLco = "All";
          _outstandingAmountController.clear();
          _installationDueController.clear();
          _monthlyRentController.clear();
          _isfilter = true;
          sortby = "Customer ID";

          isorderby = true;
        });
        break;
      case 5:
        setState(() {
          customerStatus = "Active";
          connectionType = "Internet";
          residentType = "All";
          street = "All";
          area = "All";
          collectionAgent = "All";
          subLco = "All";
          _outstandingAmountController.clear();
          _installationDueController.clear();
          _monthlyRentController.clear();
          _isfilter = true;
          sortby = "Customer ID";

          isorderby = true;
        });
        break;
      case 6:
        setState(() {
          customerStatus = "Inactive";
          connectionType = "Internet";
          residentType = "All";
          street = "All";
          area = "All";
          collectionAgent = "All";
          subLco = "All";
          _outstandingAmountController.clear();
          _installationDueController.clear();
          _monthlyRentController.clear();
          _isfilter = true;
          sortby = "Customer ID";

          isorderby = true;
        });
        break;
      default:
        setState(() {
          customerStatus = "All";
          connectionType = "All";
          residentType = "All";
          street = "All";
          area = "All";
          collectionAgent = "All";
          subLco = "All";
          _outstandingAmountController.clear();
          _installationDueController.clear();
          _monthlyRentController.clear();
          _isfilter = false;
          sortby = "Customer ID";

          isorderby = true;
        });
    }
  }

  //------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: customerListKey,
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: _isSearching
            ? searchBar()
            : new Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      child: Text('Customers'),
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
          IconButton(
            onPressed: () {
              customerListKey.currentState.openEndDrawer();
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      drawer: MyDrawer(),
      endDrawer: filter(),
      // appBar: new PreferredSize(
      //   child: new Container(
      //     padding: new EdgeInsets.only(
      //       top: MediaQuery.of(context).padding.top
      //     ),
      //     child: new Padding(
      //       padding: const EdgeInsets.only(
      //         left: 30.0,
      //         top: 20.0,
      //         bottom: 20.0
      //       ),
      //       child: new Text(
      //         'Arnold Parge',
      //         style: new TextStyle(
      //           fontSize: 20.0,
      //           fontWeight: FontWeight.w500,
      //           color: Colors.white
      //         ),
      //       ),
      //     ),
      //     decoration: new BoxDecoration(
      //       gradient:
      //             LinearGradient(colors: [Colors.pink, Colors.deepPurple]),
      //       boxShadow: [
      //         new BoxShadow(
      //           color: Colors.grey[500],
      //           blurRadius: 20.0,
      //           spreadRadius: 1.0,
      //         )
      //       ]
      //     ),
      //   ),
      //   preferredSize: new Size(
      //     MediaQuery.of(context).size.width,
      //     150.0
      //   ),
      // ),
      backgroundColor: Color(0xFFdae2f0),
      body: _isLoading
          ? Loader()
          : Column(
              children: <Widget>[
                (_search.text.isEmpty && !_isfilter)
                    ? customersListView()
                    : _buildList(),
                user.operatorId != "OM_KALIAMMAN_CABLE_ERODE"
                    ? totalCountcustomersListView()
                    : Container(),
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "addCustomer",
            clipBehavior: Clip.antiAlias,
            onPressed: () {
              //  Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => AddCustomerScreen()));
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
      ),
    );
  }

//------------------------------------------------------------------------------

  Widget totalCountcustomersListView() {
    double outstandt = 0.0;
    setState(() {
      if (_search.text.isEmpty && !_isfilter) {
        outstandt = 0.0;
        for (var i = 0; i < customers.length; i++) {
          customers[i].outstandc = 0.0;
          customers[i].outstandi = 0.0;
          customers[i].outstandt = 0.0;
          if (customers[i].cable.cableOutstandingAmount != null &&
              customers[i].cable.cableOutstandingAmount.isNotEmpty) {
            try {
              customers[i].outstandc =
                  double.tryParse(customers[i].cable.cableOutstandingAmount);
              if (customers[i].outstandc == null) {
                customers[i].outstandc = 0.0;
              }
            } catch (e) {
              customers[i].outstandc = 0.0;
            }
          }
          if (customers[i].internet.internetOutstandingAmount != null &&
              customers[i].internet.internetOutstandingAmount.isNotEmpty) {
            try {
              customers[i].outstandi = double.tryParse(
                  customers[i].internet.internetOutstandingAmount);
              if (customers[i].outstandi == null) {
                customers[i].outstandi = 0.0;
              }
            } catch (e) {
              customers[i].outstandi = 0.0;
            }
          }
          customers[i].outstandt =
              customers[i].outstandc + customers[i].outstandi;
          if (customers[i].outstandt >= 0) {
            outstandt = outstandt + customers[i].outstandt;
          }
        }
      } else {
        outstandt = 0.0;
        for (var j = 0; j < searchList.length; j++) {
          searchList[j].outstandc = 0.0;
          searchList[j].outstandi = 0.0;
          searchList[j].outstandt = 0.0;
          if (searchList[j].cable.cableOutstandingAmount != null &&
              searchList[j].cable.cableOutstandingAmount.isNotEmpty) {
            try {
              searchList[j].outstandc =
                  double.tryParse(searchList[j].cable.cableOutstandingAmount);
            } catch (e) {}
          }
          if (searchList[j].internet.internetOutstandingAmount != null &&
              searchList[j].internet.internetOutstandingAmount.isNotEmpty) {
            try {
              searchList[j].outstandi = double.tryParse(
                  searchList[j].internet.internetOutstandingAmount);
            } catch (e) {}
          }
          print(searchList[j].customerId.toString() +
              " - " +
              searchList[j].outstandc.toString() +
              " - " +
              searchList[j].outstandi.toString());
          searchList[j].outstandt =
              searchList[j].outstandc + searchList[j].outstandi;
          if (searchList[j].outstandt >= 0) {
            outstandt = outstandt + searchList[j].outstandt;
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
                            customers.length.toString(),
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
                      "Rs. " + currencyFormatter.format(outstandt),
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
                      "Outstanding",
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

  Widget customersListView() {
    if (customers != null) {
      switch (sortby) {
        case "Customer ID":
          for (var i = 0; i < customers.length; i++) {
            setState(() {
              try {
                if (int.tryParse(customers[i].customerId) -
                        int.tryParse(customers[i].customerId) ==
                    0) {
                  customers[i].sortCustomerId = customers[i].customerId;
                  int idLength;
                  idLength = 50 - customers[i].customerId.length;
                  for (var j = 0; j <= idLength; j++) {
                    customers[i].sortCustomerId =
                        "0" + customers[i].sortCustomerId;
                  }
                }
              } catch (e) {
                customers[i].sortCustomerId = customers[i].customerId;
              }
            });
          }
          if (isorderby) {
            customers
                .sort((a, b) => a.sortCustomerId.compareTo(b.sortCustomerId));
          } else {
            customers
                .sort((a, b) => a.sortCustomerId.compareTo(b.sortCustomerId));
            customers = customers.reversed.toList();
          }
          break;
        case "Customer Name":
          if (isorderby) {
            customers.sort((a, b) => a.customerName.compareTo(b.customerName));
          } else {
            customers.sort((a, b) => a.customerName.compareTo(b.customerName));
            customers = customers.reversed.toList();
          }
          break;
        case "Created Date":
          for (var i = 0; i < customers.length; i++) {
            customers[i].sortCreatedAt = formatters
                .format(DateTime.tryParse(customers[i].createdAt).toLocal());
          }
          if (isorderby) {
            customers
                .sort((a, b) => a.sortCreatedAt.compareTo(b.sortCreatedAt));
          } else {
            customers
                .sort((a, b) => a.sortCreatedAt.compareTo(b.sortCreatedAt));
            customers = customers.reversed.toList();
          }
          break;
        case "Outstanding":
          for (var i = 0; i < customers.length; i++) {
            setState(() {
              if (customers[i].cable.cableOutstandingAmount == null ||
                  customers[i].cable.cableOutstandingAmount == "") {
                customers[i].cable.sortcableOutstandingAmount = "0";
              } else {
                customers[i].cable.sortcableOutstandingAmount =
                    customers[i].cable.cableOutstandingAmount;
              }
            });
          }
          if (isorderby) {
            customers.sort((a, b) =>
                double.tryParse(a.cable.sortcableOutstandingAmount).compareTo(
                    double.tryParse(b.cable.sortcableOutstandingAmount)));
          } else {
            customers.sort((a, b) =>
                double.tryParse(a.cable.sortcableOutstandingAmount).compareTo(
                    double.tryParse(b.cable.sortcableOutstandingAmount)));
            customers = customers.reversed.toList();
          }
          break;
        default:
      }
    }

    return Expanded(
        child:
            // LazyLoadScrollView(
            //   isLoading: isLoadings,
            //   onEndOfPage: () => _loadMore(),
            //   child: ListView.builder(
            //     itemCount: customers == null ? 0 : data.length,
            //     itemBuilder: (context, i) {
            //       return _customerView(customers[i]);
            //     },
            //   ),
            // ),
            new ListView.builder(
                itemCount: customers == null ? 0 : customers.length,
                itemBuilder: (BuildContext context, int i) {
                  return _customerView(customers[i]);
                }));
  }

  // Future _loadMore() async {
  //   if (currentLength < customers.length - increment) {
  //     setState(() {
  //       isLoadings = true;
  //     });
  //     await new Future.delayed(const Duration(seconds: 0));
  //     for (var i = currentLength; i < currentLength + increment; i++) {
  //       data.add(i);
  //     }
  //     setState(() {
  //       isLoadings = false;
  //       currentLength = data.length;
  //     });
  //   } else if (currentLength == customers.length) {
  //     setState(() {
  //       isLoadings = false;
  //     });
  //   } else {
  //     setState(() {
  //       isLoadings = true;
  //       inc = customers.length - currentLength;
  //     });
  //     await new Future.delayed(const Duration(seconds: 0));
  //     for (var i = currentLength; i < currentLength + inc; i++) {
  //       data.add(i);
  //     }
  //     setState(() {
  //       isLoadings = false;
  //       currentLength = data.length;
  //     });
  //   }
  // }

  // int increment = 25;
  // bool isLoadings = false;
  // List<int> data = [];
  // int currentLength = 0;
  // int inc = 0;

  Widget _customerView(Customer customer) {
    double cable = 0;
    double internet = 0;
    if (customer.cable.cableOutstandingAmount != null &&
        customer.cable.cableOutstandingAmount != "") {
      try {
        cable = double.parse(customer.cable.cableOutstandingAmount);
      } catch (e) {
        print(e);
      }
    }
    if (customer.internet.internetOutstandingAmount != null &&
        customer.internet.internetOutstandingAmount != "") {
      try {
        internet = double.parse(customer.internet.internetOutstandingAmount);
      } catch (e) {
        print(e);
      }
    }

    double total = cable + internet;

    return InkWell(
        onTap: () => customerView(context, customer),
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
                        color: customer.activeStatus == true
                            ? Colors.green
                            : Colors.red),
                  ),
                  Container(
                      width: 300,
                      child: Text(
                        customer.customerName.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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
                        Expanded(
                          child: Text(
                              customer.cable.cableOutstandingAmount == null
                                  ? ''
                                  : 'Rs. ' + total.toString(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow)),
                        )
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
                          customer.address.area,
                      style: TextStyle(color: Color(0xfff4f4f4)),
                    )
                  ],
                ),
              )),
        ));
  }

  Widget searchBar() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: TextField(
              // enableInteractiveSelection: true,
              controller: _search,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Find Customer",
                  hintStyle: TextStyle(color: Colors.white30)),
              cursorColor: Colors.white,
              autofocus: true,
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              // onSubmitted: (value) {
              //   setState(() {
              //     _search.text = value;
              //     _searchText = _search.text;
              //   });
              // },
            ),
          ),
        ],
      );

  Widget _buildList() {
    List<Customer> tempList = [];
    if (_searchText.isNotEmpty) {
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
                  .contains(_searchText.toLowerCase()) ||
              customers[i]
                  .address
                  .doorNo
                  .toLowerCase()
                  .contains(_searchText.toLowerCase())) {
            tempList.add(customers[i]);
          } else {
            for (var j = 0; j < customers[i].cable.boxDetails.length; j++) {
              if (customers[i]
                      .cable
                      .boxDetails[j]
                      .vcNo
                      .toLowerCase()
                      .contains(_searchText.toLowerCase()) ||
                  customers[i]
                      .cable
                      .boxDetails[j]
                      .irdNo
                      .toLowerCase()
                      .contains(_searchText.toLowerCase()) ||
                  customers[i]
                      .cable
                      .boxDetails[j]
                      .nuidNo
                      .toLowerCase()
                      .contains(_searchText.toLowerCase())) {
                tempList.add(customers[i]);
              }
            }
          }
        } catch (error) {
          print(error);
        }
      }
    }

    searchList = tempList;
    if (tempList.length == 0) {
      searchList = customers;
    }
    if (_isfilter == true) {
      List<Customer> tempList = [];
      for (int i = 0; i < searchList.length; i++) {
        try {
          if (street == "All") {
            tempList.add(searchList[i]);
          } else if (searchList[i].address.street == street) {
            tempList.add(searchList[i]);
          }
        } catch (e) {
          print(e);
        }
      }
      searchList = tempList;
      if (_isfilter == true) {
        List<Customer> tempList = [];
        for (int i = 0; i < searchList.length; i++) {
          try {
            if (area == "All") {
              tempList.add(searchList[i]);
            } else if (searchList[i].address.area == area) {
              tempList.add(searchList[i]);
            }
          } catch (e) {
            print(e);
          }
        }
        searchList = tempList;
        if (_isfilter == true) {
          List<Customer> tempList = [];
          for (int i = 0; i < searchList.length; i++) {
            try {
              if (collectionAgent == "All") {
                tempList.add(searchList[i]);
              } else if (searchList[i].collectionAgent == collectionAgent) {
                tempList.add(searchList[i]);
              }
            } catch (e) {
              print(e);
            }
          }
          searchList = tempList;

          if (_isfilter == true) {
            List<Customer> tempList = [];
            for (int i = 0; i < searchList.length; i++) {
              try {
                if (customerStatus == "All") {
                  tempList.add(searchList[i]);
                } else if (customerStatus == "Active") {
                  if (searchList[i].activeStatus == true) {
                    tempList.add(searchList[i]);
                  }
                } else if (customerStatus == "Inactive") {
                  if (searchList[i].activeStatus == false ||
                      searchList[i].activeStatus == null) {
                    tempList.add(searchList[i]);
                  }
                }
              } catch (e) {
                print(e);
              }
            }
            searchList = tempList;
            if (_isfilter == true) {
              List<Customer> tempList = [];
              for (int i = 0; i < searchList.length; i++) {
                try {
                  if (connectionType == "All") {
                    tempList.add(searchList[i]);
                  } else if (connectionType == "Cable") {
                    if (double.parse(searchList[i].cable.cableMonthlyRent) >
                        0) {
                      tempList.add(searchList[i]);
                    }
                  } else if (connectionType == "Internet") {
                    if (double.parse(
                            searchList[i].internet.internetMonthlyRent) >
                        0) {
                      tempList.add(searchList[i]);
                    }
                  }
                } catch (e) {
                  print(e);
                }
              }
              searchList = tempList;
              if (_isfilter == true) {
                List<Customer> tempList = [];
                for (int i = 0; i < searchList.length; i++) {
                  try {
                    if (residentType == "All") {
                      tempList.add(searchList[i]);
                    } else if (searchList[i].address.residenceType ==
                        residentType) {
                      tempList.add(searchList[i]);
                    }
                  } catch (e) {
                    print(e);
                  }
                }
                searchList = tempList;
                if (_isfilter == true) {
                  List<Customer> tempList = [];
                  for (int i = 0; i < searchList.length; i++) {
                    try {
                      if (_outstandingAmountController.text.isEmpty) {
                        tempList.add(searchList[i]);
                      } else if (_outstandingAmountController.text.isNotEmpty) {
                        if (outstandingComparison == "Greater than") {
                          if ((double.parse(searchList[i]
                                      .cable
                                      .cableOutstandingAmount) +
                                  double.parse(searchList[i]
                                      .internet
                                      .internetOutstandingAmount)) >
                              double.parse(outstandingAmount)) {
                            tempList.add(searchList[i]);
                          }
                        } else if (outstandingComparison == "Lesser than") {
                          if ((double.parse(searchList[i]
                                      .cable
                                      .cableOutstandingAmount) +
                                  double.parse(searchList[i]
                                      .internet
                                      .internetOutstandingAmount)) <
                              double.parse(outstandingAmount)) {
                            tempList.add(searchList[i]);
                          }
                        } else if (outstandingComparison == "Equal to") {
                          if ((double.parse(searchList[i]
                                      .cable
                                      .cableOutstandingAmount) +
                                  double.parse(searchList[i]
                                      .internet
                                      .internetOutstandingAmount)) ==
                              double.parse(outstandingAmount)) {
                            tempList.add(searchList[i]);
                          }
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                  searchList = tempList;
                  if (_isfilter == true) {
                    List<Customer> tempList = [];
                    for (int i = 0; i < searchList.length; i++) {
                      try {
                        if (_installationDueController.text.isEmpty) {
                          tempList.add(searchList[i]);
                        } else if (_installationDueController.text.isNotEmpty) {
                          if (installationDueComparison == "Greater than") {
                            if ((double.parse(searchList[i]
                                        .cable
                                        .cableAdvanceAmount) -
                                    double.parse(searchList[i]
                                        .cable
                                        .cableAdvanceAmountPaid)) >
                                double.parse(installationDue)) {
                              tempList.add(searchList[i]);
                            }
                          } else if (installationDueComparison ==
                              "Lesser than") {
                            if ((double.parse(searchList[i]
                                        .cable
                                        .cableAdvanceAmount) -
                                    double.parse(searchList[i]
                                        .cable
                                        .cableAdvanceAmountPaid)) <
                                double.parse(installationDue)) {
                              tempList.add(searchList[i]);
                            }
                          } else if (installationDueComparison == "Equal to") {
                            if ((double.parse(searchList[i]
                                        .cable
                                        .cableAdvanceAmount) -
                                    double.parse(searchList[i]
                                        .cable
                                        .cableAdvanceAmountPaid)) ==
                                double.parse(installationDue)) {
                              tempList.add(searchList[i]);
                            }
                          }
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                    searchList = tempList;
                    if (_isfilter == true) {
                      List<Customer> tempList = [];
                      for (int i = 0; i < searchList.length; i++) {
                        try {
                          if (_monthlyRentController.text.isEmpty) {
                            tempList.add(searchList[i]);
                          } else if (_monthlyRentController.text.isNotEmpty) {
                            if (monthlyRentComparison == "Greater than") {
                              if ((double.parse(searchList[i]
                                          .cable
                                          .cableMonthlyRent) +
                                      double.parse(searchList[i]
                                          .internet
                                          .internetMonthlyRent)) >
                                  double.parse(monthlyRent)) {
                                tempList.add(searchList[i]);
                              }
                            } else if (monthlyRentComparison == "Lesser than") {
                              if ((double.parse(searchList[i]
                                          .cable
                                          .cableMonthlyRent) +
                                      double.parse(searchList[i]
                                          .internet
                                          .internetMonthlyRent)) <
                                  double.parse(monthlyRent)) {
                                tempList.add(searchList[i]);
                              }
                            } else if (monthlyRentComparison == "Equal to") {
                              if ((double.parse(searchList[i]
                                          .cable
                                          .cableMonthlyRent) +
                                      double.parse(searchList[i]
                                          .internet
                                          .internetMonthlyRent)) ==
                                  double.parse(monthlyRent)) {
                                tempList.add(searchList[i]);
                              }
                            }
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
                        List<Customer> tempList = [];
                        for (int i = 0; i < searchList.length; i++) {
                          try {
                            if (subLco == "All") {
                              tempList.add(searchList[i]);
                            } else if (searchList[i].lcoId == _sublcoid) {
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
            searchList.sort((a, b) => a.customerName.compareTo(b.customerName));
          } else {
            searchList.sort((a, b) => a.customerName.compareTo(b.customerName));
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
        case "Outstanding":
          for (var i = 0; i < searchList.length; i++) {
            setState(() {
              if (searchList[i].cable.cableOutstandingAmount == null ||
                  searchList[i].cable.cableOutstandingAmount == "") {
                searchList[i].cable.sortcableOutstandingAmount = "0";
              } else {
                searchList[i].cable.sortcableOutstandingAmount =
                    searchList[i].cable.cableOutstandingAmount;
              }
            });
          }
          if (isorderby) {
            searchList.sort((a, b) =>
                double.tryParse(a.cable.sortcableOutstandingAmount).compareTo(
                    double.tryParse(b.cable.sortcableOutstandingAmount)));
          } else {
            searchList.sort((a, b) =>
                double.tryParse(a.cable.sortcableOutstandingAmount).compareTo(
                    double.tryParse(b.cable.sortcableOutstandingAmount)));
            searchList = searchList.reversed.toList();
          }
          break;
        default:
      }
    }

    return Expanded(
      child:
          //     LazyLoadScrollView(
          //   isLoading: isLoadings,
          //   onEndOfPage: () => _searchLoadMore(),
          //   child: ListView.builder(
          //     itemCount: searchList == null ? 0 : searchData.length,
          //     itemBuilder: (context, i) {
          //       return _customerView(searchList[i]);
          //     },
          //   ),
          // )
          new ListView.builder(
              itemCount: searchList == null ? 0 : searchList.length,
              itemBuilder: (BuildContext context, int i) {
                return _customerView(searchList[i]);
              }),
    );
  }

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
                        "Customer Filter & Sort",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      )
                    ],
                  ),
                ],
              )),
          Container(
            color: Colors.grey[200],
            height: 10.0,
          ),
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
                            'Outstanding'
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
                    // Expanded(
                    //   child: DropdownButton<String>(
                    //       isExpanded: true,
                    //       elevation: 8,
                    //       items: <String>['Ascending', 'Descending']
                    //           .map((String value) {
                    //         return DropdownMenuItem<String>(
                    //           value: value,
                    //           child: Row(
                    //             children: <Widget>[
                    //               Container(
                    //                 width: 10.0,
                    //               ),
                    //               Text(
                    //                 value,
                    //                 style: TextStyle(fontSize: 14),
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       }).toList(),
                    //       value: orderby,
                    //       onChanged: (newVal) {
                    //         setState(() {
                    //           orderby = newVal;
                    //           if (orderby == 'Ascending') {
                    //             isorderby = true;
                    //           } else {
                    //             isorderby = false;
                    //           }
                    //         });
                    //       }),
                    // ),
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
              Row(
                children: <Widget>[
                  Container(
                    width: 10.0,
                  ),
                  Text(
                    'Customer Status',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              DropdownButton<String>(
                  elevation: 8,
                  isExpanded: true,
                  items:
                      <String>['All', 'Active', 'Inactive'].map((String value) {
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
              Row(
                children: <Widget>[
                  Container(
                    width: 10.0,
                  ),
                  Text(
                    'Connection Type',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
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
              Row(
                children: <Widget>[
                  Container(
                    width: 10.0,
                  ),
                  Text(
                    'Resident Type',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              DropdownButton<String>(
                  elevation: 8,
                  isExpanded: true,
                  items: <String>['All', 'Owned', 'Rental'].map((String value) {
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
                  value: residentType,
                  onChanged: (newVal) {
                    setState(() {
                      residentType = newVal;
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
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.0,
                          ),
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
                      value: collectionAgent,
                      onChanged: (newVal) {
                        setState(() {
                          collectionAgent = newVal;
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
                    'Outstanding Amount',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: DropdownButton<String>(
                    elevation: 8,
                    items: <String>['Greater than', 'Lesser than', 'Equal to']
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
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    value: outstandingComparison,
                    onChanged: (newVal) {
                      setState(() {
                        outstandingComparison = newVal;
                      });
                    }),
                title: TextField(
                  controller: _outstandingAmountController,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      outstandingAmount = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: "Amount",
                      labelStyle: TextStyle(fontSize: 12.0)),
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
                    'Installation Due',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: DropdownButton<String>(
                    elevation: 8,
                    items: <String>['Greater than', 'Lesser than', 'Equal to']
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
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    value: installationDueComparison,
                    onChanged: (newVal) {
                      setState(() {
                        installationDueComparison = newVal;
                      });
                    }),
                title: TextField(
                  controller: _installationDueController,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      installationDue = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: "Amount",
                      labelStyle: TextStyle(fontSize: 12.0)),
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
                    'Monthly Rent',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: DropdownButton<String>(
                    elevation: 8,
                    items: <String>['Greater than', 'Lesser than', 'Equal to']
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
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    value: monthlyRentComparison,
                    onChanged: (newVal) {
                      setState(() {
                        monthlyRentComparison = newVal;
                      });
                    }),
                title: TextField(
                  controller: _monthlyRentController,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      monthlyRent = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: "Amount",
                      labelStyle: TextStyle(fontSize: 12.0)),
                ),
              ),
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
                                  _isfilter = false;
                                  resetFilter(0);
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
                                  _isfilter = true;
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
