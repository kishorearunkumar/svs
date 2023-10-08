import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:svs/models/customer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:svs/screens/customers/add_customer_payment_screen.dart';
import 'package:svs/screens/customers/add_customer_complaint_screen.dart';
// import 'package:groovin_widgets/groovin_widgets.dart';
// import 'package:svs/screens/customers/customer_full_detail.dart';

// import 'package:intl/intl.dart';

// var formatter = NumberFormat("##,##,##0.00");

internetView(BuildContext context, Customer customer) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Material(
                      clipBehavior: Clip.antiAlias,
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(4.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ListTile(
                                dense: true,
                                leading: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        border: Border.all(
                                            width: 2.0,
                                            color: customer.activeStatus == true
                                                ? Colors.green
                                                : Colors.redAccent[100])),
                                    child: CircleAvatar(
                                      radius: 20.0,
                                      child: Text(
                                        customer.customerName[0].toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26.0),
                                      ),
                                    )),
                                title: Text(customer.customerName.toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0)),
                                subtitle: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 5.0),
                                      height: 14.0,
                                      width: 14.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          color: customer.activeStatus == true
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                    Text("ID : " + customer.customerId,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0)),
                                  ],
                                )),
                            Text(
                              customer.address.doorNo +
                                  ' ' +
                                  customer.address.houseName +
                                  ' ' +
                                  customer.address.street +
                                  ' ' +
                                  customer.address.area +
                                  ' ' +
                                  customer.address.city,
                              style: TextStyle(color: Colors.black54),
                            ),
                            Divider(),
                            Text(
                              "Plan: " +
                                  customer.internet.planName +
                                  ' - Rs. ' +
                                  customer.internet.internetMonthlyRent,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(),
                            mobileView(customer),
                            Divider(),
                            new Row(
                              children: <Widget>[
                                Expanded(
                                  child: FloatingActionButton(
                                    mini: true,
                                    shape: StadiumBorder(),
                                    backgroundColor: Colors.purple,
                                    foregroundColor: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AddCustomerComplaintScreen(
                                                      customer: customer)));
                                    },
                                    child: Text("+ Complaint"),
                                  ),
                                ),
                                Container(
                                  height: 20.0,
                                  width: 1.0,
                                  color: Colors.black38,
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                ),
                                Expanded(
                                  child: FloatingActionButton(
                                    mini: true,
                                    shape: StadiumBorder(),
                                    backgroundColor: Colors.indigo,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AddCustomerPaymentScreen(
                                                    customer: customer,
                                                    internet: true,
                                                  )));
                                    },
                                    foregroundColor: Colors.white,
                                    child: Text("+ Payment"),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ));
}

Widget mobileView(Customer customer) {
  if (customer.address.mobile != '') {
    return Row(
      children: <Widget>[
        Icon(Icons.phone_android, color: Colors.black54),
        SizedBox(width: 5.0),
        Text(customer.address.mobile,
            style: TextStyle(fontSize: 16.0, color: Colors.black87)),
        Expanded(
            child: FloatingActionButton(
                elevation: 1.0,
                mini: true,
                onPressed: () => launch(
                    "https://api.whatsapp.com/send?phone=+91" +
                        customer.address.mobile),
                backgroundColor: Colors.green,
                child: Image.asset('assets/images/whatsapp.png', width: 35.0))),
        Expanded(
            child: FloatingActionButton(
          elevation: 1.0,
          mini: true,
          onPressed: () => launch("sms:" + customer.address.mobile),
          backgroundColor: Colors.cyan,
          child: new Icon(Icons.message, color: Colors.white),
        )),
        Expanded(
            child: FloatingActionButton(
          elevation: 1.0,
          mini: true,
          onPressed: () => launch("tel:" + customer.address.mobile),
          backgroundColor: Colors.blue,
          child: new Icon(Icons.call, color: Colors.white),
        )),
      ],
    );
  } else
    return Container();
}
