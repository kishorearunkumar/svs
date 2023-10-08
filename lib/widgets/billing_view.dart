import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:svs/models/billing.dart';
import 'package:svs/models/login-response.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
// import 'package:whatsapp_launch/whatsapp_launch.dart';
// import 'package:flutter_launch/flutter_launch.dart';
import 'package:svs/screens/customers/add_customer_payment_screen.dart';
import 'package:simple_sms/simple_sms.dart';

// import 'package:svs/utils/app_shared_preferences.dart';
// import 'package:svs/models/login-response.dart';

billingView(BuildContext context, Billing billing) async {
  LoginResponse user = await AppSharedPreferences.getUserProfile();

  var formatter = new DateFormat('dd-MM-yyyy ');
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
                                  title: Center(
                                      child: Text(
                                          billing.customerData.customerName
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0))),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Text(
                                              "ID : " +
                                                  billing
                                                      .customerData.customerId,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0))),
                                      Expanded(
                                          child: Text(
                                              "Bill : " + billing.billId,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0)))
                                    ],
                                  )),
                              Row(children: <Widget>[
                                Expanded(
                                    child: Text(
                                        billing.customerData.address.doorNo +
                                            ' ' +
                                            billing.customerData.address
                                                .houseName +
                                            ' ' +
                                            billing
                                                .customerData.address.street +
                                            ' ' +
                                            billing.customerData.address.area +
                                            ' ' +
                                            billing.customerData.address.city,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black54))),
                                Expanded(
                                  child: Text(
                                    formatter.format(
                                        DateTime.tryParse(billing.createdAt)
                                            .toLocal()),
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.black54),
                                    textAlign: TextAlign.right,
                                  ),
                                )
                              ]),
                              billing.outstandingAmount != ''
                                  ? Divider()
                                  : Container(),
                              billing.outstandingAmount != ''
                                  ? ListTile(
                                      dense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 3.0),
                                      title: Text("Outstanding"),
                                      trailing: Text(
                                          'Rs. ' + billing.outstandingAmount,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    )
                                  : Container(
                                      height: 0,
                                    ),
                              Divider(),
                              ListTile(
                                dense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 3.0),
                                title: Text(billing.billFor + " subscription"),
                                trailing: Text('Rs. ' + billing.monthlyRent,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              billing.discountAmount != ''
                                  ? Divider()
                                  : Container(),
                              billing.discountAmount != ''
                                  ? ListTile(
                                      dense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      title: Text("Discount"),
                                      trailing:
                                          Text('Rs. ' + billing.discountAmount,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                    )
                                  : Container(),
                              Divider(),
                              ListTile(
                                title: Text("Total Amount"),
                                trailing: Text('Rs. ' + billing.billAmount,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
                              ),
                              Divider(),
                              mobileView(billing, user),
                              Divider(),
                              Row(
                                children: <Widget>[
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color:
                                            billing.paidStatus == 'Fully Paid'
                                                ? Colors.green
                                                : billing.paidStatus ==
                                                        'Partial Paid'
                                                    ? Colors.orange
                                                    : Colors.red,
                                      ),
                                      child: Text(
                                        billing.paidStatus,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Color(0xfff4f4f4),
                                        ),
                                      )),
                                  Container(
                                    width: 100,
                                  ),
                                  // FlatButton(
                                  //   color: Colors.indigo,
                                  //   shape: StadiumBorder(),
                                  //   onPressed: () {
                                  //     Navigator.push(
                                  //         context,
                                  //         new MaterialPageRoute(
                                  //             builder: (BuildContext context) =>
                                  //                 AddCustomerPaymentScreen(
                                  //                   customer:
                                  //                       billing.customerData,
                                  //                   internet: false,
                                  //                 )));
                                  //   },
                                  //   child: Text(
                                  //     "+ Payment",
                                  //     style: TextStyle(color: Colors.white),
                                  //   ),
                                  // ),
                                  Expanded(
                                    child: FloatingActionButton(
                                      mini: true,
                                      shape: StadiumBorder(),
                                      backgroundColor: Colors.indigo,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    AddCustomerPaymentScreen(
                                                      customer:
                                                          billing.customerData,
                                                      internet: false,
                                                    )));
                                      },
                                      foregroundColor: Colors.white,
                                      child: Text("+ Payment"),
                                    ),
                                  ),
                                ],
                              )
                            ]),
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

addPayment() {}

Widget mobileView(Billing billing, LoginResponse user) {
  if (billing.customerData.address.mobile != '') {
    return Row(
      children: <Widget>[
        Icon(Icons.phone_android, color: Colors.black54),
        SizedBox(width: 5.0),
        Text(billing.customerData.address.mobile,
            style: TextStyle(fontSize: 16.0, color: Colors.black87)),
        Expanded(
            child: FloatingActionButton(
                elevation: 1.0,
                mini: true,
                onPressed: () => whatsAppOpen(billing, user),
                backgroundColor: Colors.green,
                child: Image.asset('assets/images/whatsapp.png', width: 35.0))),
        Expanded(
            child: FloatingActionButton(
          elevation: 1.0,
          mini: true,
          onPressed: () => _sendSMS(billing, user),
          backgroundColor: Colors.cyan,
          child: new Icon(Icons.message, color: Colors.white),
        )),
        Expanded(
            child: FloatingActionButton(
          elevation: 1.0,
          mini: true,
          onPressed: () => launch("tel:" + billing.customerData.address.mobile),
          backgroundColor: Colors.blue,
          child: new Icon(Icons.call, color: Colors.white),
        )),
      ],
    );
  } else
    return Container();
}

void whatsAppOpen(Billing billing, LoginResponse user) async {
  // bool whatsapp = await FlutterLaunch.hasApp(name: "whatsapp");

  // if (whatsapp) {
  //   await FlutterLaunch.launchWathsApp(
  //       phone: "+91" + billing.customerData.address.mobile,
  //       message: "Dear " +
  //           billing.customerData.customerName +
  //           " [  ID: " +
  //           billing.customerData.customerId +
  //           " ] your billing of Rs." +
  //           billing.billAmount +
  //           " for cable subscription is successfully received. Bill Number :" +
  //           billing.billId +
  //           ". Outstanding Amount : Rs. " +
  //           billing.customerData.cable.cableOutstandingAmount +
  //           ".");
  // } else {
  //   print("Whatsapp not Installed");
  // }
  if (billing.billFor.toLowerCase().contains("cable")) {
    FlutterOpenWhatsapp.sendSingleMessage(
        "+91" + billing.customerData.address.mobile,
        "Dear " +
            billing.customerData.customerName +
            " [  ID: " +
            billing.customerData.customerId +
            " ] your billing of Rs." +
            billing.billAmount +
            " for cable subscription is successfully generated. Bill Number :" +
            billing.billId +
            ". Outstanding Amount : Rs. " +
            billing.customerData.cable.cableOutstandingAmount +
            ". For Online Payment : https://app.getsvs.in/%23/pay/" +
            user.operatorId +
            "/" +
            billing.customerData.customerId);
  } else if (billing.billFor.toLowerCase().contains("internet")) {
    FlutterOpenWhatsapp.sendSingleMessage(
        "+91" + billing.customerData.address.mobile,
        "Dear " +
            billing.customerData.customerName +
            " [  ID: " +
            billing.customerData.customerId +
            " ] your billing of Rs." +
            billing.billAmount +
            " for internet subscription is successfully generated. Bill Number :" +
            billing.billId +
            ". Outstanding Amount : Rs. " +
            billing.customerData.internet.internetOutstandingAmount +
            ". For Online Payment : https://app.getsvs.in/%23/ipay/" +
            user.operatorId +
            "/" +
            billing.customerData.customerId);
  } else {
    FlutterOpenWhatsapp.sendSingleMessage(
        "+91" + billing.customerData.address.mobile,
        "Dear " +
            billing.customerData.customerName +
            " [  ID: " +
            billing.customerData.customerId +
            " ] your billing of Rs." +
            billing.billAmount +
            " for " +
            billing.billFor +
            "is successfully generated. Bill Number :" +
            billing.billId +
            ".");
  }
  // if (billing.paidStatus.toLowerCase() == "paid") {
  //   if (billing.billFor.toLowerCase().contains("cable")) {
  //     FlutterOpenWhatsapp.sendSingleMessage(
  //         "+91" + billing.customerData.address.mobile,
  //         "Hi " +
  //             billing.customerData.customerName +
  //             " [  ID: " +
  //             billing.customerData.customerId +
  //             " ], We have received the payment of Rs. " +
  //             billing.billAmount +
  //             " for SMR CABLE NETWORK settop box recharge.Balance due: Rs. " +
  //             billing.customerData.cable.cableOutstandingAmount +
  //             ". To pay instantly with easy online payment in future just click here " +
  //             "https://app.getsvs.in/%23/pay/" +
  //             user.operatorId +
  //             "/" +
  //             billing.customerData.customerId);
  //   } else if (billing.billFor.toLowerCase().contains("internet")) {
  //     FlutterOpenWhatsapp.sendSingleMessage(
  //         "+91" + billing.customerData.address.mobile,
  //         "Hi " +
  //             billing.customerData.customerName +
  //             " [  ID: " +
  //             billing.customerData.customerId +
  //             " ], We have received the payment of Rs. " +
  //             billing.billAmount +
  //             " for SMR CABLE NETWORK settop box recharge.Balance due: Rs. " +
  //             billing.customerData.internet.internetOutstandingAmount +
  //             ". To pay instantly with easy online payment in future just click here " +
  //             "https://app.getsvs.in/%23/ipay/" +
  //             user.operatorId +
  //             "/" +
  //             billing.customerData.customerId);
  //   } else {
  //     FlutterOpenWhatsapp.sendSingleMessage(
  //         "+91" + billing.customerData.address.mobile,
  //         "Hi " +
  //             billing.customerData.customerName +
  //             " [  ID: " +
  //             billing.customerData.customerId +
  //             " ], We have received the payment of Rs. " +
  //             billing.billAmount +
  //             " for " +
  //             billing.billFor +
  //             ".");
  //   }
  // } else {
  //   if (billing.billFor.toLowerCase().contains("cable")) {
  //     FlutterOpenWhatsapp.sendSingleMessage(
  //         "+91" + billing.customerData.address.mobile,
  //         "Dear " +
  //             billing.customerData.customerName +
  //             " [  ID: " +
  //             billing.customerData.customerId +
  //             " ] Your SMR CABLE NETWORK settop box recharge payment due is Rs. " +
  //             billing.billAmount +
  //             " Please To pay instantly with easy online payment click here " +
  //             "https://app.getsvs.in/%23/pay/" +
  //             user.operatorId +
  //             "/" +
  //             billing.customerData.customerId);
  //   } else if (billing.billFor.toLowerCase().contains("internet")) {
  //     FlutterOpenWhatsapp.sendSingleMessage(
  //         "+91" + billing.customerData.address.mobile,
  //         "Dear " +
  //             billing.customerData.customerName +
  //             " [  ID: " +
  //             billing.customerData.customerId +
  //             " ] Your SMR CABLE NETWORK settop box recharge payment due is Rs. " +
  //             billing.billAmount +
  //             " Please To pay instantly with easy online payment click here " +
  //             "https://app.getsvs.in/%23/ipay/" +
  //             user.operatorId +
  //             "/" +
  //             billing.customerData.customerId);
  //   } else {
  //     FlutterOpenWhatsapp.sendSingleMessage(
  //         "+91" + billing.customerData.address.mobile,
  //         "Dear " +
  //             billing.customerData.customerName +
  //             " [  ID: " +
  //             billing.customerData.customerId +
  //             " ] Your SMR CABLE NETWORK settop box recharge payment due is Rs. " +
  //             billing.billAmount +
  //             ".");
  //   }
  // }
}

void _sendSMS(Billing billing, LoginResponse user) {
  final SimpleSms simpleSms = SimpleSms();
  List<String> address = ["+91" + billing.customerData.address.mobile];
  if (billing.billFor.toLowerCase().contains("cable")) {
    simpleSms.sendSms(
        address,
        "Dear " +
            billing.customerData.customerName +
            " [  ID: " +
            billing.customerData.customerId +
            " ] your billing of Rs." +
            billing.billAmount +
            " for cable subscription is successfully generated. Bill Number :" +
            billing.billId +
            ". Outstanding Amount : Rs. " +
            billing.customerData.cable.cableOutstandingAmount +
            ". For Online Payment : https://app.getsvs.in/#/pay/" +
            user.operatorId +
            "/" +
            billing.customerData.customerId);
  } else if (billing.billFor.toLowerCase().contains("internet")) {
    simpleSms.sendSms(
        address,
        "Dear " +
            billing.customerData.customerName +
            " [  ID: " +
            billing.customerData.customerId +
            " ] your billing of Rs." +
            billing.billAmount +
            " for internet subscription is successfully generated. Bill Number :" +
            billing.billId +
            ". Outstanding Amount : Rs. " +
            billing.customerData.internet.internetOutstandingAmount +
            ". For Online Payment : https://app.getsvs.in/#/ipay/" +
            user.operatorId +
            "/" +
            billing.customerData.customerId);
  } else {
    simpleSms.sendSms(
        address,
        "Dear " +
            billing.customerData.customerName +
            " [  ID: " +
            billing.customerData.customerId +
            " ] your billing of Rs." +
            billing.billAmount +
            " for " +
            billing.billFor +
            "is successfully generated. Bill Number :" +
            billing.billId +
            ".");
  }
  // if (billing.paidStatus.toLowerCase() == "paid") {
  //   if (billing.billFor.toLowerCase().contains("cable")) {
  //     simpleSms.sendSms(
  //         address,
  //         "Hi " +
  //             billing.customerData.customerName +
  //             " [  ID: " +
  //             billing.customerData.customerId +
  //             " ], We have received the payment of Rs. " +
  //             billing.billAmount +
  //             " for SMR CABLE NETWORK settop box recharge.Balance due: Rs. " +
  //             billing.customerData.cable.cableOutstandingAmount +
  //             ". To pay instantly with easy online payment in future just click here " +
  //             "https://app.getsvs.in/#/pay/" +
  //             user.operatorId +
  //             "/" +
  //             billing.customerData.customerId);
  //   } else if (billing.billFor.toLowerCase().contains("internet")) {
  //     simpleSms.sendSms(
  //         address,
  //         "Hi " +
  //             billing.customerData.customerName +
  //             " [  ID: " +
  //             billing.customerData.customerId +
  //             " ], We have received the payment of Rs. " +
  //             billing.billAmount +
  //             " for SMR CABLE NETWORK settop box recharge.Balance due: Rs. " +
  //             billing.customerData.internet.internetOutstandingAmount +
  //             ". To pay instantly with easy online payment in future just click here " +
  //             "https://app.getsvs.in/#/ipay/" +
  //             user.operatorId +
  //             "/" +
  //             billing.customerData.customerId);
  //   } else {
  //     simpleSms.sendSms(
  //         address,
  //         "Hi " +
  //             billing.customerData.customerName +
  //             " [  ID: " +
  //             billing.customerData.customerId +
  //             " ], We have received the payment of Rs. " +
  //             billing.billAmount +
  //             " for " +
  //             billing.billFor +
  //             ".");
  //   }
  // } else {
  //   if (billing.billFor.toLowerCase().contains("cable")) {
  //     simpleSms.sendSms(
  //         address,
  //         "Dear " +
  //             billing.customerData.customerName +
  //             " [  ID: " +
  //             billing.customerData.customerId +
  //             " ] Your SMR CABLE NETWORK settop box recharge payment due is Rs. " +
  //             billing.billAmount +
  //             " Please To pay instantly with easy online payment click here " +
  //             "https://app.getsvs.in/#/pay/" +
  //             user.operatorId +
  //             "/" +
  //             billing.customerData.customerId);
  //   } else if (billing.billFor.toLowerCase().contains("internet")) {
  //     simpleSms.sendSms(
  //         address,
  //         "Dear " +
  //             billing.customerData.customerName +
  //             " [  ID: " +
  //             billing.customerData.customerId +
  //             " ] Your SMR CABLE NETWORK settop box recharge payment due is Rs. " +
  //             billing.billAmount +
  //             " Please To pay instantly with easy online payment click here " +
  //             "https://app.getsvs.in/#/ipay/" +
  //             user.operatorId +
  //             "/" +
  //             billing.customerData.customerId);
  //   } else {
  //     simpleSms.sendSms(
  //         address,
  //         "Dear " +
  //             billing.customerData.customerName +
  //             " [  ID: " +
  //             billing.customerData.customerId +
  //             " ] Your SMR CABLE NETWORK settop box recharge payment due is Rs. " +
  //             billing.billAmount +
  //             ".");
  //   }
  // }
}
