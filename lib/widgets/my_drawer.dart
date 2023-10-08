import 'package:flutter/material.dart';
import 'package:svs/screens/summary/collection_summary.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:svs/utils/profile_tile.dart';
// import 'package:svs/screens/layout/home_layout.dart';
import 'package:svs/screens/payment/add_payment_screen.dart';
import 'package:svs/screens/complaint/add_complaint_screen.dart';
// import 'package:svs/screens/customers/customer_list_screen.dart';
// import 'package:svs/screens/payment/payment_list_screen.dart';
// import 'package:svs/screens/complaint/complaint_list_screen.dart';
import 'package:svs/screens/customers/add_customer_screen.dart';
// import 'package:svs/screens/customers/edit_customer_screen_test.dart';
import 'package:svs/models/login-response.dart';
import 'package:svs/screens/bluetooth/bluetooth_screen.dart';
// import 'package:svs/screens/billing/billing_list_screen.dart';
import 'package:svs/screens/internetexpiry/internet_expiry_screen.dart';

class MyDrawer extends StatefulWidget {
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  LoginResponse user;
//------------------------------------------------------------------------------

  void _logout() {
    AppSharedPreferences.clear();
    setState(() {
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

//------------------------------------------------------------------------------
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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

//------------------------------------------------------------------------------

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

//------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Ink(
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Color(0xffae275f), Colors.pink])),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 20.0, 0.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: AssetImage("assets/images/user.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 20.0, 0, 10.0),
                    child: ProfileTile(
                      title: ((user == null) ? "Your Name" : user.fullName),
                      subtitle: ((user == null) ? "Position" : user.userType),
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: new EdgeInsets.all(0.0),
              children: <Widget>[
                ListTile(
                  leading: new Icon(Icons.home),
                  trailing: new Icon(Icons.chevron_right),
                  title: Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.group_add),
                  trailing: new Icon(Icons.chevron_right),
                  title: Text(
                    'Add Customer',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddCustomerScreen()));
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.group),
                  trailing: new Icon(Icons.chevron_right),
                  title: Text(
                    'Customers List',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, "/customerlist");
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.add_circle_outline),
                  trailing: new Icon(Icons.chevron_right),
                  title: Text(
                    'Add Payment',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddPaymentScreen()));
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.list),
                  trailing: new Icon(Icons.chevron_right),
                  title: Text(
                    'Payments List',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, "/paymentlist");
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.list),
                  trailing: new Icon(Icons.chevron_right),
                  title: Text(
                    'Invoices List',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, "/invoicelist");
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.add_comment),
                  trailing: new Icon(Icons.chevron_right),
                  title: Text(
                    'Add Complaint',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddComplaintScreen()));
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.list),
                  trailing: new Icon(Icons.chevron_right),
                  title: Text(
                    'Complaints List',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, "/complaintlist");
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.list),
                  trailing: new Icon(Icons.chevron_right),
                  title: Text(
                    'Internet Expiry Report',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                InternetExpiryListScreen()));
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.list),
                  trailing: new Icon(Icons.chevron_right),
                  title: Text(
                    'Collection Summary',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CollectionSummary()));
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.print),
                  trailing: new Icon(Icons.chevron_right),
                  title: Text(
                    'Printer Settings',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                BluetoothScreen()));
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.lock),
                  trailing: new Icon(Icons.chevron_right),
                  title: Text(
                    'Logout',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    _logout();
                  },
                ),
                Container(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
