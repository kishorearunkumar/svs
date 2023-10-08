import 'package:flutter/material.dart';
import 'package:svs/widgets/my_drawer.dart';
import 'package:svs/models/complaint.dart';
import 'package:svs/services/basic_service.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:svs/models/street.dart';
import 'package:svs/models/area.dart';
import 'package:svs/screens/complaint/add_complaint_screen.dart';
import 'package:svs/widgets/loader.dart';
import 'package:svs/widgets/complaint_view.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:svs/models/username.dart';
// import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:svs/models/login-response.dart';
// import 'package:svs/widgets/slide.dart';

class ComplaintListScreen extends StatefulWidget {
  final int filterIndex;
  ComplaintListScreen({Key key, @required this.filterIndex}) : super(key: key);
  _ComplaintListScreenState createState() => _ComplaintListScreenState();
}

class _ComplaintListScreenState extends State<ComplaintListScreen> {
  Size deviceSize;
  double screenWidth = 0.0;
  List<Complaint> complaints;
  String connectionType = "All";
  List<Complaint> searchList;
  bool _isSearching = false;
  bool _isfilter = false;
  bool _isLoading = true;
  bool _isRefresh = false;
  List<Street> streets = [];
  List<Areas> areas = [];
  String street = "All";
  String area = "All";
  final GlobalKey<ScaffoldState> complaintListKey =
      new GlobalKey<ScaffoldState>();
  final TextEditingController _search = new TextEditingController();
  String _searchText = "";
  List<Username> createdbys = [];
  String createdby = "All";
  List<Username> assignedtos = [];
  String assignedto = "All";
  String complaintStatus = "All";
  LoginResponse user;
  int filterIndex;
  String sortby = "Created Date";

  bool isorderby = false;
  var formatter = new DateFormat('dd-MM-yyyy hh:mm aaa');
  var formatters = new DateFormat('yyyyMMddHHmmssSSS');

  _ComplaintListScreenState() {
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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
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

  //------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    filterIndex = widget.filterIndex;
    _search.clear();
    // initUserProfile();
    getData();
    // _loadMore();

    resetFilter(filterIndex);
  }
//------------------------------------------------------------------------------

  resetFilter(int filterIndex) {
    switch (filterIndex) {
      case 0:
        setState(() {
          street = "All";
          area = "All";
          connectionType = "All";
          createdby = "All";
          assignedto = "All";
          complaintStatus = "All";
          _isfilter = false;
          sortby = "Created Date";

          isorderby = false;
        });
        break;
      case 1:
        setState(() {
          street = "All";
          area = "All";
          connectionType = "Cable";
          createdby = "All";
          assignedto = "All";
          complaintStatus = "Closed";
          _isfilter = true;
          sortby = "Created Date";

          isorderby = false;
        });
        break;
      case 2:
        setState(() {
          street = "All";
          area = "All";
          connectionType = "Cable";
          createdby = "All";
          assignedto = "All";
          complaintStatus = "Open";
          _isfilter = true;
          sortby = "Created Date";

          isorderby = false;
        });
        break;
      case 3:
        setState(() {
          street = "All";
          area = "All";
          connectionType = "Internet";
          createdby = "All";
          assignedto = "All";
          complaintStatus = "Closed";
          _isfilter = true;
          sortby = "Created Date";

          isorderby = false;
        });
        break;
      case 4:
        setState(() {
          street = "All";
          area = "All";
          connectionType = "Internet";
          createdby = "All";
          assignedto = "All";
          complaintStatus = "Open";
          _isfilter = true;
          sortby = "Created Date";

          isorderby = false;
        });
        break;
      default:
        setState(() {
          street = "All";
          area = "All";
          createdby = "All";
          assignedto = "All";
          complaintStatus = "All";
          _isfilter = false;
          sortby = "Created Date";

          isorderby = false;
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

  Future pause(Duration d) => new Future.delayed(d);

  Future<void> getData() async {
    // await pause(const Duration(milliseconds: 1000));

    await getOldData();

    complaintList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          complaints =
              complaintsFromJson(Utf8Codec().decode(response.bodyBytes));
          // _loadMore();
        });
        AppSharedPreferences.setComplaints(complaints);

        _isLoading = false;
        _isRefresh = false;
      } else {
        complaintListKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("Something went wrong !!"),
        ));
        _isRefresh = false;
      }
    }).catchError((error) {
      complaintListKey.currentState.showSnackBar(new SnackBar(
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
    getCreatedByData();
    getAssignedToData();
    _isRefresh = false;
  }

  getCreatedByData() {
    usernameList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          createdbys =
              usernamesFromJson(Utf8Codec().decode(response.bodyBytes));
        });
        createdbys.sort((a, b) =>
            a.userName.toLowerCase().compareTo(b.userName.toLowerCase()));
        AppSharedPreferences.setUsername(createdbys);
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

  getAssignedToData() {
    usernameList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          assignedtos =
              usernamesFromJson(Utf8Codec().decode(response.bodyBytes));
        });
        assignedtos.sort((a, b) =>
            a.userName.toLowerCase().compareTo(b.userName.toLowerCase()));
        AppSharedPreferences.setUsername(assignedtos);
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
      complaints = await AppSharedPreferences.getComplaints();
      _isLoading = false;
      _isRefresh = false;
      createdbys = await AppSharedPreferences.getUsername();
      createdbys.sort((a, b) =>
          a.userName.toLowerCase().compareTo(b.userName.toLowerCase()));
      assignedtos = await AppSharedPreferences.getUsername();
      assignedtos.sort((a, b) =>
          a.userName.toLowerCase().compareTo(b.userName.toLowerCase()));
    } catch (e) {
      print(e);
    }
  }

  // Future _loadMore() async {
  //   if (currentLength < complaints.length - increment) {
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
  //   } else if (currentLength == complaints.length) {
  //     setState(() {
  //       isLoadings = false;
  //     });
  //   } else {
  //     setState(() {
  //       isLoadings = true;
  //       inc = complaints.length - currentLength;
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

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        key: complaintListKey,
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: _isSearching
              ? searchBar()
              : new Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        child: Text('Complaints'),
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
                complaintListKey.currentState.openEndDrawer();
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
                    ? complaintListView()
                    : _buildList(),
                user.operatorId != "OM_KALIAMMAN_CABLE_ERODE"
                    ? totalCountcomplaintListView()
                    : Container(),
              ]),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "addComplaint",
              clipBehavior: Clip.antiAlias,
              onPressed: () {
                //  Navigator.of(context).pop();
                // Navigator.push(
                //     context, Slide(builder: (context) => AddComplaintScreen()));
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddComplaintScreen()));
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

  Widget totalCountcomplaintListView() {
    int opent = 0;
    int closedt = 0;
    setState(() {
      if (_search.text.isEmpty && !_isfilter) {
        opent = 0;
        closedt = 0;
        for (var i = 0; i < complaints.length; i++) {
          if (complaints[i].complaintStatus != null &&
              complaints[i].complaintStatus.isNotEmpty &&
              complaints[i].complaintStatus == "open") {
            try {
              opent++;
            } catch (e) {}
          }
          if (complaints[i].complaintStatus != null &&
              complaints[i].complaintStatus.isNotEmpty &&
              complaints[i].complaintStatus == "closed") {
            try {
              closedt++;
            } catch (e) {}
          }
          if (complaints[i].complaintStatus == null ||
              complaints[i].complaintStatus.isEmpty) {
            try {
              closedt++;
            } catch (e) {}
          }
        }
      } else {
        opent = 0;
        closedt = 0;
        for (var i = 0; i < searchList.length; i++) {
          if (searchList[i].complaintStatus != null &&
              searchList[i].complaintStatus.isNotEmpty &&
              searchList[i].complaintStatus == "open") {
            try {
              opent++;
            } catch (e) {}
          }
          if (searchList[i].complaintStatus != null &&
              searchList[i].complaintStatus.isNotEmpty &&
              searchList[i].complaintStatus == "closed") {
            try {
              closedt++;
            } catch (e) {}
          }
          if (searchList[i].complaintStatus == null ||
              searchList[i].complaintStatus.isEmpty) {
            try {
              closedt++;
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
                  Expanded(
                    child: Text(
                      closedt.toString(),
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
                      opent.toString(),
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
                      "Closed",
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
                      "Open",
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

  Widget complaintListView() {
    if (complaints != null) {
      switch (sortby) {
        case "Customer ID":
          for (var i = 0; i < complaints.length; i++) {
            setState(() {
              try {
                if (int.tryParse(complaints[i].customerId) -
                        int.tryParse(complaints[i].customerId) ==
                    0) {
                  complaints[i].sortCustomerId = complaints[i].customerId;
                  int idLength;
                  idLength = 50 - complaints[i].customerId.length;
                  for (var j = 0; j <= idLength; j++) {
                    complaints[i].sortCustomerId =
                        "0" + complaints[i].sortCustomerId;
                  }
                }
              } catch (e) {
                complaints[i].sortCustomerId = complaints[i].customerId;
              }
            });
          }
          if (isorderby) {
            complaints
                .sort((a, b) => a.sortCustomerId.compareTo(b.sortCustomerId));
          } else {
            complaints
                .sort((a, b) => a.sortCustomerId.compareTo(b.sortCustomerId));
            complaints = complaints.reversed.toList();
          }
          break;
        case "Customer Name":
          if (isorderby) {
            complaints.sort((a, b) => a.customerData.customerName
                .compareTo(b.customerData.customerName));
          } else {
            complaints.sort((a, b) => a.customerData.customerName
                .compareTo(b.customerData.customerName));
            complaints = complaints.reversed.toList();
          }
          break;
        case "Created Date":
          for (var i = 0; i < complaints.length; i++) {
            complaints[i].sortCreatedAt = formatters
                .format(DateTime.tryParse(complaints[i].createdAt).toLocal());
          }
          if (isorderby) {
            complaints
                .sort((a, b) => a.sortCreatedAt.compareTo(b.sortCreatedAt));
          } else {
            complaints
                .sort((a, b) => a.sortCreatedAt.compareTo(b.sortCreatedAt));
            complaints = complaints.reversed.toList();
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
            //     itemCount: complaints == null ? 0 : data.length,
            //     itemBuilder: (context, i) {
            //       return _complaintView(complaints[i]);
            //     },
            //   ),
            // )

            new ListView.builder(
                itemCount: complaints == null ? 0 : complaints.length,
                itemBuilder: (BuildContext context, int i) {
                  return _complaintView(complaints[i]);
                }));
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
                    children: <Widget>[
                      Container(height: 7.0),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              width: 330,
                              child: Text(
                                complaint.customerData.address.doorNo +
                                    ' ' +
                                    complaint.customerData.address.street +
                                    ' ' +
                                    complaint.customerData.address.area,
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
                                style: TextStyle(
                                    fontSize: 12.0, color: Color(0xfff4f4f4))),
                          ),
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
                              ? Text(
                                  formatter.format(
                                      DateTime.tryParse(complaint.closedAt)
                                          .toLocal()),
                                  style: TextStyle(
                                      fontSize: 12.0, color: Color(0xfff4f4f4)),
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
                          Text(
                              complaint.assigned.isNotEmpty
                                  ? complaint.assigned[0].userName
                                  : 'Not Assigned',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow)),
                        ],
                      )
                    ],
                  ))),
        ));
  }

  Widget _buildList() {
    List<Complaint> tempList = [];
    if (_searchText.isNotEmpty) {
      for (int i = 0; i < complaints.length; i++) {
        try {
          if (complaints[i]
                  .complaintId
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              complaints[i]
                  .complaintStatus
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              complaints[i]
                  .complaintFor
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              complaints[i]
                  .complaintDetail
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              complaints[i]
                  .customerData
                  .customerName
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              complaints[i]
                  .customerData
                  .customerId
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              complaints[i]
                  .customerData
                  .address
                  .street
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              complaints[i]
                  .customerData
                  .address
                  .area
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              complaints[i]
                  .customerData
                  .address
                  .mobile
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
              complaints[i]
                  .customerData
                  .address
                  .alternateNumber
                  .toLowerCase()
                  .contains(_searchText.toLowerCase())) {
            tempList.add(complaints[i]);
          }
        } catch (error) {
          print(error);
        }
      }
    }
    searchList = tempList;
    if (tempList.length == 0) {
      searchList = complaints;
    }
    if (_isfilter == true) {
      List<Complaint> tempList = [];
      for (int i = 0; i < searchList.length; i++) {
        try {
          if (connectionType == "All") {
            tempList.add(searchList[i]);
          } else if (searchList[i].complaintFor == connectionType) {
            tempList.add(searchList[i]);
          }
        } catch (e) {
          print(e);
        }
      }
      searchList = tempList;
      if (_isfilter == true) {
        List<Complaint> tempList = [];
        for (int i = 0; i < searchList.length; i++) {
          try {
            if (createdby == "All") {
              tempList.add(searchList[i]);
            } else if (searchList[i].created[0].userName == createdby) {
              tempList.add(searchList[i]);
            }
          } catch (e) {
            print(e);
          }
        }
        searchList = tempList;
        if (_isfilter == true) {
          List<Complaint> tempList = [];
          for (int i = 0; i < searchList.length; i++) {
            try {
              if (complaintStatus == "All") {
                tempList.add(searchList[i]);
              } else if (searchList[i].complaintStatus.toLowerCase() ==
                  complaintStatus.toLowerCase()) {
                tempList.add(searchList[i]);
              }
            } catch (e) {
              print(e);
            }
          }
          searchList = tempList;
          if (_isfilter == true) {
            List<Complaint> tempList = [];
            for (int i = 0; i < searchList.length; i++) {
              try {
                if (assignedto == "All") {
                  tempList.add(searchList[i]);
                } else if (searchList[i].assigned[0].userName == assignedto) {
                  tempList.add(searchList[i]);
                }
              } catch (e) {
                print(e);
              }
            }
            searchList = tempList;
            if (_isfilter == true) {
              List<Complaint> tempList = [];
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
                List<Complaint> tempList = [];
                for (int i = 0; i < searchList.length; i++) {
                  try {
                    if (area == "All") {
                      tempList.add(searchList[i]);
                    } else if (searchList[i].customerData.address.area ==
                        area) {
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
          for (var i = 0; i < complaints.length; i++) {
            complaints[i].sortCreatedAt = formatters
                .format(DateTime.tryParse(complaints[i].createdAt).toLocal());
          }
          if (isorderby) {
            complaints
                .sort((a, b) => a.sortCreatedAt.compareTo(b.sortCreatedAt));
          } else {
            complaints
                .sort((a, b) => a.sortCreatedAt.compareTo(b.sortCreatedAt));
            complaints = complaints.reversed.toList();
          }
          break;
        default:
      }
    }

    return Expanded(
      child: new ListView.builder(
          itemCount: searchList == null ? 0 : searchList.length,
          itemBuilder: (BuildContext context, int i) {
            return _complaintView(searchList[i]);
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
                  hintText: "Find Complaint",
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
    List<String> createdbyList = ['All'];
    List<String> assignedtoList = ['All'];

    for (int i = 0; i < streets.length; i++) {
      streetList.add(streets[i].street);
    }
    for (int i = 0; i < areas.length; i++) {
      areaList.add(areas[i].area);
    }
    for (int i = 0; i < createdbys.length; i++) {
      createdbyList.add(createdbys[i].userName);
    }
    for (int i = 0; i < assignedtos.length; i++) {
      assignedtoList.add(assignedtos[i].userName);
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
                        "Complaint Filter & Sort",
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
                            // 'Outstanding'
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
              createdbys.length > 0
                  ? Row(
                      children: <Widget>[
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          'Created By',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              createdbys.length > 0
                  ? DropdownButton<String>(
                      elevation: 8,
                      isExpanded: true,
                      items: createdbyList.map((String value) {
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
                      value: createdby,
                      onChanged: (newVal) {
                        setState(() {
                          createdby = newVal;
                        });
                      })
                  : Container(),
              createdbys.length > 0
                  ? Container(
                      height: 10.0,
                    )
                  : Container(),
              Row(
                children: <Widget>[
                  Container(
                    width: 10.0,
                  ),
                  Text(
                    'Complaint Status',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              DropdownButton<String>(
                  elevation: 8,
                  isExpanded: true,
                  items: <String>['All', 'Open', 'Closed'].map((String value) {
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
                  value: complaintStatus,
                  onChanged: (newVal) {
                    setState(() {
                      complaintStatus = newVal;
                    });
                  }),
              Container(
                height: 10.0,
              ),
              assignedtos.length > 0
                  ? Row(
                      children: <Widget>[
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          'Assigned To',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              assignedtos.length > 0
                  ? DropdownButton<String>(
                      elevation: 8,
                      isExpanded: true,
                      items: assignedtoList.map((String value) {
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
                      value: assignedto,
                      onChanged: (newVal) {
                        setState(() {
                          assignedto = newVal;
                        });
                      })
                  : Container(),
              assignedtos.length > 0
                  ? Container(
                      height: 10.0,
                    )
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
