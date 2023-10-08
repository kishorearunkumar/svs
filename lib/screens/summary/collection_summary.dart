import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:intl/intl.dart';
import 'package:svs/models/general.dart';
import 'package:svs/models/login-response.dart';
import 'package:svs/models/payment.dart';
import 'package:svs/models/username.dart';
import 'package:svs/services/basic_service.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:svs/widgets/loader.dart';
import "package:flutter/services.dart";

class CollectionSummary extends StatefulWidget {
  @override
  _CollectionSummaryState createState() => _CollectionSummaryState();
}

class _CollectionSummaryState extends State<CollectionSummary> {
  String _fromdate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  String _todate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  var dateFormatter = new DateFormat('dd-MM-yyyy');
  var currency = NumberFormat("##,##,###");
  List<Payment> payments;
  bool _isLoading = true;
  LoginResponse user;
  final GlobalKey<ScaffoldState> paymentListKey =
      new GlobalKey<ScaffoldState>();
  double total = 0.0;
  List<String> paymentMode = [];
  List<int> paymentModeCount = [];
  List<double> paymentModeAmt = [];
  List<General> general = [];
  List<Username> collectedbys = [];
  Username collectedby;
  String printPaymentMode = "No Payment Collected\x0A";
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
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
        initialLastDate: (new DateTime.now()).add(new Duration(days: 0)),
        firstDate: new DateTime(1950),
        lastDate: new DateTime(2025));
    if (picked != null && picked.length == 2) {
      setState(() {
        _isLoading = true;
        _fromdate = dateFormatter
            .format(DateTime.tryParse(picked[0].toString()).toLocal());
        _todate = dateFormatter
            .format(DateTime.tryParse(picked[1].toString()).toLocal());
        getData();
      });
    }
  }

  Future<void> getData() async {
    paymentListDateRange(_fromdate, _todate).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          payments = paymentsFromJson(Utf8Codec().decode(response.bodyBytes));
          generalSetting();
          getCollectbyData();
        });
        _isLoading = false;
      } else {
        paymentListKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("Something went wrong !!"),
        ));
      }
    }).catchError((error) {
      paymentListKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.redAccent[400],
        content: new Text("No Internet Connection. Loading Offline Content."),
        behavior: SnackBarBehavior.floating,
      ));
      setState(() {
        _isLoading = false;
      });
    });
  }

  generalSetting() async {
    generalList("null").then((response) {
      if (response.statusCode == 200) {
        general = generalsFromJson(Utf8Codec().decode(response.bodyBytes));
        generateSummary();
      }
    }).catchError((error) {
      print(error);
    });
    if (general == null || general.isEmpty) {
      general = await AppSharedPreferences.getGeneralSettings();
      generateSummary();
    }
  }

  getCollectbyData() {
    usernameList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          collectedbys =
              usernamesFromJson(Utf8Codec().decode(response.bodyBytes));
          generateSummary();
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  generateSummary() {
    paymentMode.clear();
    paymentModeCount.clear();
    paymentModeAmt.clear();
    total = 0.0;

    for (var i = 0; i < payments.length; i++) {
      if (payments[i].paymentMode != null &&
          payments[i].paymentMode != "" &&
          payments[i].paymentMode.isNotEmpty) {
        paymentMode.add(payments[i].paymentMode);
      }
      if (payments[i].amountPaid != null &&
          payments[i].amountPaid != "" &&
          payments[i].amountPaid.isNotEmpty) {
        total = total + double.tryParse(payments[i].amountPaid);
      }
    }
    paymentMode = paymentMode.toSet().toList();
    for (var i = 0; i < paymentMode.length; i++) {
      paymentModeCount.add(0);
      paymentModeAmt.add(0.0);
      for (var j = 0; j < payments.length; j++) {
        if (payments[j].paymentMode != null &&
            payments[j].paymentMode != "" &&
            payments[j].paymentMode.isNotEmpty) {
          if (payments[j].amountPaid != null &&
              payments[j].amountPaid != "" &&
              payments[j].amountPaid.isNotEmpty) {
            if (paymentMode[i] == payments[j].paymentMode) {
              paymentModeCount[i] = paymentModeCount[i] + 1;
              paymentModeAmt[i] =
                  paymentModeAmt[i] + double.tryParse(payments[j].amountPaid);
            }
          }
        }
      }
    }
    for (var i = 0; i < collectedbys.length; i++) {
      if (collectedbys[i].userName == user.userName) {
        collectedby = collectedbys[i];
      }
    }
  }

  Widget _collectionView() {
    var pms = List<Widget>();

    for (var i = 0; i < paymentMode.length; i++) {
      var pm = pmView(paymentMode[i], paymentModeCount[i], paymentModeAmt[i]);
      pms.add(pm);
    }

    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      margin: new EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
      child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    "Mode",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Expanded(
                      child: Text(
                    "Payment",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Expanded(
                      child: Text(
                    "Amount",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ],
              ),
              Container(
                height: 10.0,
              ),
              Column(
                children: pms,
              ),
              Container(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    "Total",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Expanded(
                      child: Text(
                    payments.length.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Expanded(
                      child: Text(
                    "Rs." + total.toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ],
              ),
              Container(
                height: 10.0,
              ),
            ],
          )),
    );
  }

  Widget pmView(String _pm, int _pmp, double _pma) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Text(_pm)),
            Expanded(
                child: Text(
              _pmp.toString(),
              textAlign: TextAlign.center,
            )),
            Expanded(
                child: Text(
              "Rs." + _pma.toString(),
              textAlign: TextAlign.right,
            )),
          ],
        ),
        Container(
          height: 5.0,
        ),
      ],
    );
  }

  Future<void> _printBill(General general) async {
    if (paymentMode != null &&
        paymentMode.length > 0 &&
        paymentMode.isNotEmpty) {
      printPaymentMode = "";
    }
    for (var i = 0; i < paymentMode.length; i++) {
      printPaymentMode = printPaymentMode +
          (paymentMode[i] == "Cash" || paymentMode[i] == "Card"
              ? paymentMode[i] + "           "
              : paymentMode[i] == "Debit Card"
                  ? paymentMode[i] + "     "
                  : paymentMode[i] == "Credit Card"
                      ? paymentMode[i] + "    "
                      : paymentMode[i] == "Cheque"
                          ? paymentMode[i] + "         "
                          : paymentMode[i] == "PayTM"
                              ? paymentMode[i] + "          "
                              : paymentMode[i] == "Google Pay"
                                  ? paymentMode[i] + "     "
                                  : paymentMode[i] == "Other"
                                      ? paymentMode[i] + "          "
                                      : paymentMode[i] + "") +
          " -    " +
          paymentModeCount[i].toString() +
          "    - Rs." +
          paymentModeAmt[i].toString() +
          "\x0A";
    }
    String printData = "\x1B" +
        "\x40" +
        "\x1B" +
        "\x61" +
        "\x31" +
        "\x1B" +
        "\x45" +
        "\x0D" +
        "\x0A" +
        "\x0A" +
        general.lcoName +
        "\x0A" +
        "\x1B" +
        "\x45" +
        "\x0A" +
        general.address +
        "\x0A" +
        "Phone: " +
        general.phoneNumber +
        " " +
        general.alternateNumber +
        "\x0A" +
        "------------------------------------------------" +
        "\x0A" +
        "\x1B" +
        "\x61" +
        "\x30" +
        "Agent Name: " +
        collectedby.name +
        "\x0A" +
        "User Name: " +
        collectedby.userName +
        "\x0A" +
        "------------------------------------------------" +
        "\x0A" +
        "From : " +
        _fromdate +
        "\x0A" +
        "To : " +
        _todate +
        "\x0A" +
        "------------------------------------------------" +
        "\x0A" +
        "Mode            - Payment - Amount" +
        "\x0A" +
        "------------------------------------------------" +
        "\x0A" +
        printPaymentMode +
        "------------------------------------------------" +
        "\x0A" +
        "Total           -    " +
        payments.length.toString() +
        "   - Rs." +
        total.toString() +
        "\x0A" +
        "------------------------------------------------" +
        "\x0A" +
        "\x0A" +
        "\x1B" +
        "\x69";

    print(printData);
    FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

    BluetoothDevice _device;
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException catch (e) {
      print(e);
    }

    String deviceName = await AppSharedPreferences.getDeviceName();

    devices.forEach((device) {
      if (device.name == deviceName) {
        _device = device;
      }
    });

    bluetooth.isConnected.then((isConnected) async {
      if (isConnected) {
        bluetooth.write(printData);
      } else {
        await bluetooth.connect(_device).then((_) {
          bluetooth.isConnected.then((isConnected) async {
            if (isConnected) {
              bluetooth.write(printData);
            }
          });
        }).catchError((error) {
          print(error);
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Collection Summary'),
        backgroundColor: new Color(0xffae275f),
      ),
      body: _isLoading
          ? Loader()
          : Column(
              children: <Widget>[
                Expanded(
                    child: ListView(
                  padding: EdgeInsets.all(10.0),
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _dateRange(context);
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text("Date Range : ( " +
                                _fromdate +
                                "  to  " +
                                _todate +
                                " )"),
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
                        ],
                      ),
                    ),
                    _collectionView(),
                    FloatingActionButton(
                      onPressed: () {
                        _printBill(general[0]);
                      },
                      child: Text("Print"),
                      shape: StadiumBorder(),
                      mini: true,
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    )
                  ],
                )),
              ],
            ),
    );
  }
}
