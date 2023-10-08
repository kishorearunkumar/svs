import 'package:flutter/material.dart';
import 'package:svs/screens/home/home_screen.dart';
import 'package:svs/screens/customers/customer_list_screen.dart';
import 'package:svs/screens/payment/payment_list_screen.dart';
import 'package:svs/screens/billing/billing_list_screen.dart';
import 'package:svs/screens/complaint/complaint_list_screen.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:svs/models/login-response.dart';

class HomeLayout extends StatefulWidget {
  final int index;
  final int filterIndex;
  HomeLayout({Key key, @required this.index, @required this.filterIndex})
      : super(key: key);
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout>
    with SingleTickerProviderStateMixin {
  LoginResponse user;
  TabController controller;
  bool ishome = true;
  int index;
  int filterIndex;

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
  void initState() {
    super.initState();
    index = widget.index;
    filterIndex = widget.filterIndex;
    controller = new TabController(vsync: this, length: 5, initialIndex: index);
    ishome = true;
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            body: new TabBarView(
              controller: controller,
              children: <Widget>[
                CustomerListScreen(
                  filterIndex: filterIndex,
                ),
                PaymentListScreen(
                  filterIndex: filterIndex,
                ),
                HomeScreen(
                  filterIndex: filterIndex,
                ),
                BillingListScreen(
                  filterIndex: filterIndex,
                ),
                ComplaintListScreen(
                  filterIndex: filterIndex,
                ),
              ],
            ),
            bottomNavigationBar: bottomNavigation(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              clipBehavior: Clip.antiAlias,
              onPressed: () {
                controller.animateTo(2);
              },
              child: Ink(
                decoration: new BoxDecoration(
                    border: new Border.all(
                        color: Color(0xFFdae2f0),
                        width: 2.5,
                        style: BorderStyle.solid),
                    shape: BoxShape.circle,
                    gradient: new LinearGradient(
                        colors: [Colors.pink, Colors.deepPurple])),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
            )));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Do you want to exit SVS ? ",
              style: TextStyle(fontSize: 16.0)),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FloatingActionButton(
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
                    Navigator.pop(context, true);
                  },
                  child: Text("Yes"),
                ),
                Container(
                  height: 20.0,
                  width: 1.0,
                  color: Colors.black38,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                ),
                FloatingActionButton(
                  mini: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(
                      color: Color.fromARGB(255, 41, 153, 102),
                      width: 1.0,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Color.fromARGB(255, 41, 153, 102),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text("No"),
                ),
                //     new FlatButton(
                //   shape: StadiumBorder(),
                //   child: new Text(
                //     "Yes",
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   color: Colors.red,
                //   onPressed: () {
                //     Navigator.pop(context, true);
                //   },
                // ),
                // new FlatButton(
                //   shape: StadiumBorder(),
                //   child: new Text(
                //     "No",
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   color: Colors.green,
                //   onPressed: () {
                //     Navigator.pop(context, false);
                //   },
                // ),
              ],
            ),
          ],
        );
      },
    );
  }

  bottomNavigation() => new Material(
      color: new Color(0xff383e4b),
      child: new TabBar(
        controller: controller,
        labelPadding: EdgeInsets.symmetric(horizontal: 1),
        indicatorColor: Colors.yellow,
        labelColor: Colors.white,
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        unselectedLabelColor: Colors.white70,
        tabs: <Widget>[
          new Tab(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.people),
              Text("Customers", style: TextStyle(fontSize: 10.0))
            ],
          )),
          new Tab(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.account_balance_wallet),
              Text(" Payments ", style: TextStyle(fontSize: 10.0))
            ],
          )),
          new Tab(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.home),
              Text("   Home   ", style: TextStyle(fontSize: 10.0))
            ],
          )),
          new Tab(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.receipt),
              Text(" Invoices ", style: TextStyle(fontSize: 10.0))
            ],
          )),
          new Tab(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.build),
              Text(
                "Complaints",
                style: TextStyle(fontSize: 10.0),
              )
            ],
          )),
        ],
      ));
}
