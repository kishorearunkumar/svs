import 'dart:async';
import "package:svs/utils/app_shared_preferences.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => new _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  final GlobalKey<ScaffoldState> bluetoothKey = new GlobalKey<ScaffoldState>();

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;

  String paperSize = "3 inch";
  String deviceName = "No Device";
  bool _isRefresh = false;
  bool _detailedbill = false;
  String detailedbill = "No";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // _deviceName();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
    _deviceName();
    setState(() {
      _isRefresh = false;
    });
  }

  saveDeviceName(String deviceName) {
    AppSharedPreferences.setDeviceName(deviceName);
  }

  savePaperSize(String ps) {
    AppSharedPreferences.setPaperSize(ps);
  }

  saveDetailedBill(String db) {
    detailedbill = db;
    AppSharedPreferences.setDetailedBill(db);
  }

  _deviceName() async {
    deviceName = await AppSharedPreferences.getDeviceName();
    String deviceMessage = "No Device";
    if (deviceName != null) {
      if (deviceName.isEmpty) {
        deviceName = "Unknown Device";
      }
      deviceMessage = deviceName;
    }

    setState(() {
      deviceName = deviceMessage;
    });
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void savePrinterDetails() {
    if (_device == null) {
      bluetoothKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.redAccent,
        content: new Text(
          "No Device Is Selected!!",
          textAlign: TextAlign.center,
        ),
      ));
    } else {
      setState(() {
        deviceName = _device.name;
        saveDeviceName(deviceName);
        savePaperSize(paperSize);
        saveDetailedBill(detailedbill);
        bluetoothKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.green,
          content: new Text(
            "Printer Details Saved Successfully!!",
            textAlign: TextAlign.center,
          ),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: bluetoothKey,
        backgroundColor: Color(0xFFdae2f0),
        appBar: AppBar(
          actions: <Widget>[
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
                        initPlatformState();
                      });
                    },
                    icon: Icon(Icons.refresh),
                  ),
          ],
          title: Text('Bluetooth Settings'),
          backgroundColor: Color(0xffae275f),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 5.0,
            ),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Text(
                    "Printer Settings:",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Card(
                margin: new EdgeInsets.symmetric(vertical: 5.0),
                shape: RoundedRectangleBorder(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text("Devices:"),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    items: _getDeviceItems(),
                                    onChanged: (value) =>
                                        setState(() => _device = value),
                                    value: _device,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text("Paper Size:"),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                        value: "2 inch",
                                        groupValue: paperSize,
                                        onChanged: (value) {
                                          setState(() {
                                            paperSize = value;
                                            savePaperSize(paperSize);
                                            saveDetailedBill("No");
                                            _detailedbill = false;
                                          });
                                        },
                                        activeColor: Color(0xffae275f),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            paperSize = "2 inch";
                                            savePaperSize(paperSize);
                                            saveDetailedBill("No");
                                            _detailedbill = false;
                                          });
                                        },
                                        child: Text(
                                          "2 inch",
                                        ),
                                      ),
                                      Radio(
                                        value: "3 inch",
                                        groupValue: paperSize,
                                        onChanged: (value) {
                                          setState(() {
                                            paperSize = value;
                                            savePaperSize(paperSize);
                                            saveDetailedBill("No");
                                            _detailedbill = false;
                                          });
                                        },
                                        activeColor: Color(0xffae275f),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            paperSize = "3 inch";
                                            savePaperSize(paperSize);
                                            saveDetailedBill("No");
                                            _detailedbill = false;
                                          });
                                        },
                                        child: Text(
                                          "3 inch",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            paperSize == "3 inch"
                                ? Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text("Detailed Bill:"),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: <Widget>[
                                            Checkbox(
                                              activeColor: Color(0xffae275f),
                                              onChanged: (value) {
                                                setState(() {
                                                  value
                                                      ? saveDetailedBill("Yes")
                                                      : saveDetailedBill("No");
                                                  _detailedbill = value;
                                                });
                                              },
                                              value: _detailedbill,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            RaisedButton(
                              color: Color(0xffae275f),
                              onPressed: savePrinterDetails,
                              child: Text(
                                "SAVE",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Container(
              height: 5.0,
            ),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Text(
                    "Saved Printer Details:",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Card(
                margin: new EdgeInsets.symmetric(vertical: 5.0),
                shape: RoundedRectangleBorder(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 5.0,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text("Device Name:"),
                            ),
                            Expanded(
                              child: Text(
                                deviceName,
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Row(children: <Widget>[
                          Expanded(
                            child: Text("Paper Size: "),
                          ),
                          Expanded(
                            child: Text(
                              paperSize,
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ])),
                    Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Row(children: <Widget>[
                          Expanded(
                            child: Text("Detailed Bill: "),
                          ),
                          Expanded(
                            child: Text(
                              detailedbill,
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ])),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
