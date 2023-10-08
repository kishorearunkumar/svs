import 'package:flutter/material.dart';
import 'package:svs/models/billing.dart';
import 'package:svs/models/complaint.dart';
import 'package:svs/models/customer.dart';
import 'package:svs/models/general.dart';
import 'package:svs/models/payment.dart';
import 'package:svs/services/basic_service.dart';
import 'package:svs/models/dashboard.dart';
import 'dart:convert';
import 'package:svs/models/login-response.dart';
import 'package:svs/widgets/my_drawer.dart';
import 'package:svs/widgets/loader.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:svs/screens/payment/add_payment_screen.dart';
import 'package:svs/screens/complaint/add_complaint_screen.dart';
import 'package:svs/screens/customers/customer_list_screen.dart';
import 'package:svs/screens/billing/billing_list_screen.dart';
import 'package:svs/screens/complaint/complaint_list_screen.dart';
import 'package:svs/models/tax-settings.dart';

// import 'package:svs/screens/dashboard/check.dart';
// import 'package:carousel_pro/carousel_pro.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:polygon_clipper/polygon_clipper.dart';
// import 'package:svs/checkwidget/checkwidget.dart';

// final List<String> boxes = [];

// final CarouselSlider coverScreenExample = CarouselSlider(
//   viewportFraction: 1.0,
//   aspectRatio: 2.0,
//   autoPlay: true,
//   enlargeCenterPage: false,
//   items: map<Widget>(
//     boxes,
//     (index, i) {
//       return Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(image: NetworkImage(i), fit: BoxFit.cover),
//         ),
//       );
//     },
//   ),
// );

// final List child = map<Widget>(
//   boxes,
//   (index, i) {
//     return Container(
//       margin: EdgeInsets.all(5.0),
//       child: ClipRRect(
//         borderRadius: BorderRadius.all(Radius.circular(5.0)),
//         child: Stack(children: <Widget>[
//           Image.network(i, fit: BoxFit.cover, width: 1000.0),
//           Positioned(
//             bottom: 0.0,
//             left: 0.0,
//             right: 0.0,
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color.fromARGB(200, 0, 0, 0),
//                     Color.fromARGB(0, 0, 0, 0)
//                   ],
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                 ),
//               ),
//               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//               child: Text(
//                 'No. $index image',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   },
// ).toList();

// List<T> map<T>(List list, Function handler) {
//   List<T> result = [];
//   for (var i = 0; i < list.length; i++) {
//     result.add(handler(i, list[i]));
//   }

//   return result;
// }

class HomeScreen extends StatefulWidget {
  final int filterIndex;
  HomeScreen({Key key, @required this.filterIndex}) : super(key: key);
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Size deviceSize;
  // double screenWidth = 0.0;
  Dashboard dashboardData;
  bool _isLoading = true;
  bool _ishomebutton = false;
  bool _isCustomerDetails = false;
  bool _isCollectionDetails = false;
  bool _isComplaintDetails = false;
  bool _isBillDetails = false;
  bool _isrefresh = false;
  var currency = NumberFormat("##,##,###");
  final GlobalKey<ScaffoldState> homeKey = new GlobalKey<ScaffoldState>();
  int imageCount = 5;
  LoginResponse user;
  List<TaxSetting> taxSetting = [TaxSetting(gstin: "")];
  String gstin;
  List<Payment> _offlineSubscriptionPayments = [];
  List<Payment> _offlineInstallationPayments = [];
  List<Payment> _offlineOthersPayments = [];
  List<Payment> _tempOfflineSubscriptionPayments1 = [];
  List<Payment> _tempOfflineInstallationPayments1 = [];
  List<Payment> _tempOfflineOthersPayments1 = [];
  List<Payment> _tempOfflineSubscriptionPayments2 = [];
  List<Payment> _tempOfflineInstallationPayments2 = [];
  List<Payment> _tempOfflineOthersPayments2 = [];
  List<Payment> _tempOfflineSubscriptionPayments3 = [];
  List<Payment> _tempOfflineInstallationPayments3 = [];
  List<Payment> _tempOfflineOthersPayments3 = [];
  List<Customer> _customerList = [];
  List<Billing> _billingList = [];
  List<Payment> _paymentList = [];
  List<General> general = [];
  List<Complaint> _complaintList = [];
  bool _isGetListData = false;
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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

  @override
  void initState() {
    super.initState();
    generalSetting();
    // getListOldData();
    getListData();
    getData();
    // Future.delayed(const Duration(seconds: 5), () {
    //   updateOfflinePayment();
    // });
  }

  // updateOfflinePayment() {
  //   // _offlineSubscriptionPayments.clear();
  //   // _offlineInstallationPayments.clear();
  //   // _offlineOthersPayments.clear();
  //   // _tempOfflineSubscriptionPayments.clear();
  //   // _tempOfflineInstallationPayments.clear();
  //   // _tempOfflineOthersPayments.clear();
  //   if (_offlineSubscriptionPayments.isNotEmpty &&
  //       _offlineSubscriptionPayments != null &&
  //       _offlineSubscriptionPayments.length > 0) {
  //     for (var i = 0; i < _offlineSubscriptionPayments.length; i++) {
  //       if (_offlineSubscriptionPayments[i].created[0].userName ==
  //           user.userName) {
  //         _tempOfflineSubscriptionPayments1.add(
  //           Payment(
  //             customerId: _offlineSubscriptionPayments[i].customerId,
  //             amountPaid: _offlineSubscriptionPayments[i].amountPaid,
  //             serviceType: _offlineSubscriptionPayments[i].serviceType,
  //             paymentMode: _offlineSubscriptionPayments[i].paymentMode,
  //             receiptPhoneNumber:
  //                 _offlineSubscriptionPayments[i].receiptPhoneNumber,
  //             paymentFor: _offlineSubscriptionPayments[i].paymentFor,
  //             ccomment: _offlineSubscriptionPayments[i].ccomment,
  //           ),
  //         );
  //       } else {
  //         _tempOfflineSubscriptionPayments2
  //             .add(_offlineSubscriptionPayments[i]);
  //       }
  //     }
  //     if (_tempOfflineSubscriptionPayments1.isNotEmpty &&
  //         _tempOfflineSubscriptionPayments1 != null &&
  //         _tempOfflineSubscriptionPayments1.length > 0) {
  //       saveOfflineSubscriptionPayment(_tempOfflineSubscriptionPayments1)
  //           .then((response) {
  //         if (response.statusCode == 201) {
  //           AppSharedPreferences.setOfflineSubscriptionPayments(
  //               _tempOfflineSubscriptionPayments2);
  //         }
  //       }).catchError((error) {
  //         print('error : $error');
  //         paymentList().then((response) {
  //           if (response.statusCode == 200) {
  //             setState(() {
  //               _paymentList =
  //                   paymentsFromJson(Utf8Codec().decode(response.bodyBytes));
  //               AppSharedPreferences.setPayments(_paymentList);
  //               getListOldData();
  //               for (var i = 0; i < _offlineSubscriptionPayments.length; i++) {
  //                 if (_paymentList.isNotEmpty &&
  //                     _paymentList != null &&
  //                     _paymentList.length > 0) {
  //                   for (var j = 0; j < _paymentList.length; j++) {
  //                     if (_paymentList[j].customDate != null &&
  //                         _paymentList[j].customDate != "" &&
  //                         _paymentList[j].customDate.isNotEmpty) {
  //                       if (_offlineSubscriptionPayments[i].customDate !=
  //                           _paymentList[j].customDate) {
  //                         _tempOfflineSubscriptionPayments3.add(
  //                           Payment(
  //                             customerId:
  //                                 _offlineSubscriptionPayments[i].customerId,
  //                             amountPaid:
  //                                 _offlineSubscriptionPayments[i].amountPaid,
  //                             serviceType:
  //                                 _offlineSubscriptionPayments[i].serviceType,
  //                             paymentMode:
  //                                 _offlineSubscriptionPayments[i].paymentMode,
  //                             receiptPhoneNumber:
  //                                 _offlineSubscriptionPayments[i]
  //                                     .receiptPhoneNumber,
  //                             paymentFor:
  //                                 _offlineSubscriptionPayments[i].paymentFor,
  //                             ccomment:
  //                                 _offlineSubscriptionPayments[i].ccomment,
  //                           ),
  //                         );
  //                       }
  //                     }
  //                   }
  //                 }
  //               }
  //               AppSharedPreferences.setOfflineSubscriptionPayments(
  //                   _tempOfflineSubscriptionPayments3);
  //             });
  //           } else {
  //             setState(() {
  //               getListOldData();
  //               for (var i = 0; i < _offlineSubscriptionPayments.length; i++) {
  //                 if (_paymentList.isNotEmpty &&
  //                     _paymentList != null &&
  //                     _paymentList.length > 0) {
  //                   for (var j = 0; j < _paymentList.length; j++) {
  //                     if (_paymentList[j].customDate != null &&
  //                         _paymentList[j].customDate != "" &&
  //                         _paymentList[j].customDate.isNotEmpty) {
  //                       if (_offlineSubscriptionPayments[i].customDate !=
  //                           _paymentList[j].customDate) {
  //                         _tempOfflineSubscriptionPayments3.add(
  //                           Payment(
  //                             customerId:
  //                                 _offlineSubscriptionPayments[i].customerId,
  //                             amountPaid:
  //                                 _offlineSubscriptionPayments[i].amountPaid,
  //                             serviceType:
  //                                 _offlineSubscriptionPayments[i].serviceType,
  //                             paymentMode:
  //                                 _offlineSubscriptionPayments[i].paymentMode,
  //                             receiptPhoneNumber:
  //                                 _offlineSubscriptionPayments[i]
  //                                     .receiptPhoneNumber,
  //                             paymentFor:
  //                                 _offlineSubscriptionPayments[i].paymentFor,
  //                             ccomment:
  //                                 _offlineSubscriptionPayments[i].ccomment,
  //                           ),
  //                         );
  //                       }
  //                     }
  //                   }
  //                 }
  //               }
  //               AppSharedPreferences.setOfflineSubscriptionPayments(
  //                   _tempOfflineSubscriptionPayments3);
  //             });
  //           }
  //         }).catchError((error) {
  //           setState(() {
  //             getListOldData();
  //             for (var i = 0; i < _offlineSubscriptionPayments.length; i++) {
  //               if (_paymentList.isNotEmpty &&
  //                   _paymentList != null &&
  //                   _paymentList.length > 0) {
  //                 for (var j = 0; j < _paymentList.length; j++) {
  //                   if (_paymentList[j].customDate != null &&
  //                       _paymentList[j].customDate != "" &&
  //                       _paymentList[j].customDate.isNotEmpty) {
  //                     if (_offlineSubscriptionPayments[i].customDate !=
  //                         _paymentList[j].customDate) {
  //                       _tempOfflineSubscriptionPayments3.add(
  //                         Payment(
  //                           customerId:
  //                               _offlineSubscriptionPayments[i].customerId,
  //                           amountPaid:
  //                               _offlineSubscriptionPayments[i].amountPaid,
  //                           serviceType:
  //                               _offlineSubscriptionPayments[i].serviceType,
  //                           paymentMode:
  //                               _offlineSubscriptionPayments[i].paymentMode,
  //                           receiptPhoneNumber: _offlineSubscriptionPayments[i]
  //                               .receiptPhoneNumber,
  //                           paymentFor:
  //                               _offlineSubscriptionPayments[i].paymentFor,
  //                           ccomment: _offlineSubscriptionPayments[i].ccomment,
  //                         ),
  //                       );
  //                     }
  //                   }
  //                 }
  //               }
  //             }
  //             AppSharedPreferences.setOfflineSubscriptionPayments(
  //                 _tempOfflineSubscriptionPayments3);
  //           });
  //         });
  //       });
  //     }
  //   }
  //   if (_offlineInstallationPayments.isNotEmpty &&
  //       _offlineInstallationPayments != null &&
  //       _offlineInstallationPayments.length > 0) {
  //     for (var i = 0; i < _offlineInstallationPayments.length; i++) {
  //       if (_offlineInstallationPayments[i].created[0].userName ==
  //           user.userName) {
  //         _tempOfflineInstallationPayments1.add(
  //           Payment(
  //             customerId: _offlineInstallationPayments[i].customerId,
  //             amountPaid: _offlineInstallationPayments[i].amountPaid,
  //             serviceType: _offlineInstallationPayments[i].serviceType,
  //             paymentMode: _offlineInstallationPayments[i].paymentMode,
  //             receiptPhoneNumber:
  //                 _offlineInstallationPayments[i].receiptPhoneNumber,
  //             paymentFor: _offlineInstallationPayments[i].paymentFor,
  //             ccomment: _offlineInstallationPayments[i].ccomment,
  //           ),
  //         );
  //       } else {
  //         _tempOfflineInstallationPayments2
  //             .add(_offlineInstallationPayments[i]);
  //       }
  //     }
  //     if (_tempOfflineInstallationPayments1.isNotEmpty &&
  //         _tempOfflineInstallationPayments1 != null &&
  //         _tempOfflineInstallationPayments1.length > 0) {
  //       saveOfflineInstallationPayment(_tempOfflineInstallationPayments1)
  //           .then((response) {
  //         if (response.statusCode == 201) {
  //           AppSharedPreferences.setOfflineInstallationPayments(
  //               _tempOfflineInstallationPayments2);
  //         }
  //       }).catchError((error) {
  //         print('error : $error');
  //         paymentList().then((response) {
  //           if (response.statusCode == 200) {
  //             setState(() {
  //               _paymentList =
  //                   paymentsFromJson(Utf8Codec().decode(response.bodyBytes));
  //               AppSharedPreferences.setPayments(_paymentList);
  //               getListOldData();
  //               for (var i = 0; i < _offlineInstallationPayments.length; i++) {
  //                 if (_paymentList.isNotEmpty &&
  //                     _paymentList != null &&
  //                     _paymentList.length > 0) {
  //                   for (var j = 0; j < _paymentList.length; j++) {
  //                     if (_paymentList[j].customDate != null &&
  //                         _paymentList[j].customDate != "" &&
  //                         _paymentList[j].customDate.isNotEmpty) {
  //                       if (_offlineInstallationPayments[i].customDate !=
  //                           _paymentList[j].customDate) {
  //                         _tempOfflineInstallationPayments3.add(
  //                           Payment(
  //                             customerId:
  //                                 _offlineInstallationPayments[i].customerId,
  //                             amountPaid:
  //                                 _offlineInstallationPayments[i].amountPaid,
  //                             serviceType:
  //                                 _offlineInstallationPayments[i].serviceType,
  //                             paymentMode:
  //                                 _offlineInstallationPayments[i].paymentMode,
  //                             receiptPhoneNumber:
  //                                 _offlineInstallationPayments[i]
  //                                     .receiptPhoneNumber,
  //                             paymentFor:
  //                                 _offlineInstallationPayments[i].paymentFor,
  //                             ccomment:
  //                                 _offlineInstallationPayments[i].ccomment,
  //                           ),
  //                         );
  //                       }
  //                     }
  //                   }
  //                 }
  //               }
  //               AppSharedPreferences.setOfflineInstallationPayments(
  //                   _tempOfflineInstallationPayments3);
  //             });
  //           } else {
  //             setState(() {
  //               getListOldData();
  //               for (var i = 0; i < _offlineInstallationPayments.length; i++) {
  //                 if (_paymentList.isNotEmpty &&
  //                     _paymentList != null &&
  //                     _paymentList.length > 0) {
  //                   for (var j = 0; j < _paymentList.length; j++) {
  //                     if (_paymentList[j].customDate != null &&
  //                         _paymentList[j].customDate != "" &&
  //                         _paymentList[j].customDate.isNotEmpty) {
  //                       if (_offlineInstallationPayments[i].customDate !=
  //                           _paymentList[j].customDate) {
  //                         _tempOfflineInstallationPayments3.add(
  //                           Payment(
  //                             customerId:
  //                                 _offlineInstallationPayments[i].customerId,
  //                             amountPaid:
  //                                 _offlineInstallationPayments[i].amountPaid,
  //                             serviceType:
  //                                 _offlineInstallationPayments[i].serviceType,
  //                             paymentMode:
  //                                 _offlineInstallationPayments[i].paymentMode,
  //                             receiptPhoneNumber:
  //                                 _offlineInstallationPayments[i]
  //                                     .receiptPhoneNumber,
  //                             paymentFor:
  //                                 _offlineInstallationPayments[i].paymentFor,
  //                             ccomment:
  //                                 _offlineInstallationPayments[i].ccomment,
  //                           ),
  //                         );
  //                       }
  //                     }
  //                   }
  //                 }
  //               }
  //               AppSharedPreferences.setOfflineInstallationPayments(
  //                   _tempOfflineInstallationPayments3);
  //             });
  //           }
  //         }).catchError((error) {
  //           setState(() {
  //             getListOldData();
  //             for (var i = 0; i < _offlineInstallationPayments.length; i++) {
  //               if (_paymentList.isNotEmpty &&
  //                   _paymentList != null &&
  //                   _paymentList.length > 0) {
  //                 for (var j = 0; j < _paymentList.length; j++) {
  //                   if (_paymentList[j].customDate != null &&
  //                       _paymentList[j].customDate != "" &&
  //                       _paymentList[j].customDate.isNotEmpty) {
  //                     if (_offlineInstallationPayments[i].customDate !=
  //                         _paymentList[j].customDate) {
  //                       _tempOfflineInstallationPayments3.add(
  //                         Payment(
  //                           customerId:
  //                               _offlineInstallationPayments[i].customerId,
  //                           amountPaid:
  //                               _offlineInstallationPayments[i].amountPaid,
  //                           serviceType:
  //                               _offlineInstallationPayments[i].serviceType,
  //                           paymentMode:
  //                               _offlineInstallationPayments[i].paymentMode,
  //                           receiptPhoneNumber: _offlineInstallationPayments[i]
  //                               .receiptPhoneNumber,
  //                           paymentFor:
  //                               _offlineInstallationPayments[i].paymentFor,
  //                           ccomment: _offlineInstallationPayments[i].ccomment,
  //                         ),
  //                       );
  //                     }
  //                   }
  //                 }
  //               }
  //             }
  //             AppSharedPreferences.setOfflineInstallationPayments(
  //                 _tempOfflineInstallationPayments3);
  //           });
  //         });
  //       });
  //     }
  //   }
  //   if (_offlineOthersPayments.isNotEmpty &&
  //       _offlineOthersPayments != null &&
  //       _offlineOthersPayments.length > 0) {
  //     for (var i = 0; i < _offlineOthersPayments.length; i++) {
  //       if (_offlineOthersPayments[i].created[0].userName == user.userName) {
  //         _tempOfflineOthersPayments1.add(
  //           Payment(
  //             customerId: _offlineOthersPayments[i].customerId,
  //             amountPaid: _offlineOthersPayments[i].amountPaid,
  //             serviceType: _offlineOthersPayments[i].serviceType,
  //             paymentMode: _offlineOthersPayments[i].paymentMode,
  //             receiptPhoneNumber: _offlineOthersPayments[i].receiptPhoneNumber,
  //             paymentFor: _offlineOthersPayments[i].paymentFor,
  //             ccomment: _offlineOthersPayments[i].ccomment,
  //           ),
  //         );
  //       } else {
  //         _tempOfflineOthersPayments2.add(_offlineOthersPayments[i]);
  //       }
  //     }
  //     if (_tempOfflineOthersPayments1.isNotEmpty &&
  //         _tempOfflineOthersPayments1 != null &&
  //         _tempOfflineOthersPayments1.length > 0) {
  //       saveOfflineOthersPayment(_tempOfflineOthersPayments1).then((response) {
  //         if (response.statusCode == 201) {
  //           AppSharedPreferences.setOfflineOthersPayments(
  //               _tempOfflineOthersPayments2);
  //         }
  //       }).catchError((error) {
  //         print('error : $error');
  //         paymentList().then((response) {
  //           if (response.statusCode == 200) {
  //             setState(() {
  //               _paymentList =
  //                   paymentsFromJson(Utf8Codec().decode(response.bodyBytes));
  //               AppSharedPreferences.setPayments(_paymentList);
  //               getListOldData();
  //               for (var i = 0; i < _offlineOthersPayments.length; i++) {
  //                 if (_paymentList.isNotEmpty &&
  //                     _paymentList != null &&
  //                     _paymentList.length > 0) {
  //                   for (var j = 0; j < _paymentList.length; j++) {
  //                     if (_paymentList[j].customDate != null &&
  //                         _paymentList[j].customDate != "" &&
  //                         _paymentList[j].customDate.isNotEmpty) {
  //                       if (_offlineOthersPayments[i].customDate !=
  //                           _paymentList[j].customDate) {
  //                         _tempOfflineOthersPayments3.add(
  //                           Payment(
  //                             customerId: _offlineOthersPayments[i].customerId,
  //                             amountPaid: _offlineOthersPayments[i].amountPaid,
  //                             serviceType:
  //                                 _offlineOthersPayments[i].serviceType,
  //                             paymentMode:
  //                                 _offlineOthersPayments[i].paymentMode,
  //                             receiptPhoneNumber:
  //                                 _offlineOthersPayments[i].receiptPhoneNumber,
  //                             paymentFor: _offlineOthersPayments[i].paymentFor,
  //                             ccomment: _offlineOthersPayments[i].ccomment,
  //                           ),
  //                         );
  //                       }
  //                     }
  //                   }
  //                 }
  //               }
  //               AppSharedPreferences.setOfflineOthersPayments(
  //                   _tempOfflineOthersPayments3);
  //             });
  //           } else {
  //             setState(() {
  //               getListOldData();
  //               for (var i = 0; i < _offlineOthersPayments.length; i++) {
  //                 if (_paymentList.isNotEmpty &&
  //                     _paymentList != null &&
  //                     _paymentList.length > 0) {
  //                   for (var j = 0; j < _paymentList.length; j++) {
  //                     if (_paymentList[j].customDate != null &&
  //                         _paymentList[j].customDate != "" &&
  //                         _paymentList[j].customDate.isNotEmpty) {
  //                       if (_offlineOthersPayments[i].customDate !=
  //                           _paymentList[j].customDate) {
  //                         _tempOfflineOthersPayments3.add(
  //                           Payment(
  //                             customerId: _offlineOthersPayments[i].customerId,
  //                             amountPaid: _offlineOthersPayments[i].amountPaid,
  //                             serviceType:
  //                                 _offlineOthersPayments[i].serviceType,
  //                             paymentMode:
  //                                 _offlineOthersPayments[i].paymentMode,
  //                             receiptPhoneNumber:
  //                                 _offlineOthersPayments[i].receiptPhoneNumber,
  //                             paymentFor: _offlineOthersPayments[i].paymentFor,
  //                             ccomment: _offlineOthersPayments[i].ccomment,
  //                           ),
  //                         );
  //                       }
  //                     }
  //                   }
  //                 }
  //               }
  //               AppSharedPreferences.setOfflineOthersPayments(
  //                   _tempOfflineOthersPayments3);
  //             });
  //           }
  //         }).catchError((error) {
  //           setState(() {
  //             getListOldData();
  //             for (var i = 0; i < _offlineOthersPayments.length; i++) {
  //               if (_paymentList.isNotEmpty &&
  //                   _paymentList != null &&
  //                   _paymentList.length > 0) {
  //                 for (var j = 0; j < _paymentList.length; j++) {
  //                   if (_paymentList[j].customDate != null &&
  //                       _paymentList[j].customDate != "" &&
  //                       _paymentList[j].customDate.isNotEmpty) {
  //                     if (_offlineOthersPayments[i].customDate !=
  //                         _paymentList[j].customDate) {
  //                       _tempOfflineOthersPayments3.add(
  //                         Payment(
  //                           customerId: _offlineOthersPayments[i].customerId,
  //                           amountPaid: _offlineOthersPayments[i].amountPaid,
  //                           serviceType: _offlineOthersPayments[i].serviceType,
  //                           paymentMode: _offlineOthersPayments[i].paymentMode,
  //                           receiptPhoneNumber:
  //                               _offlineOthersPayments[i].receiptPhoneNumber,
  //                           paymentFor: _offlineOthersPayments[i].paymentFor,
  //                           ccomment: _offlineOthersPayments[i].ccomment,
  //                         ),
  //                       );
  //                     }
  //                   }
  //                 }
  //               }
  //             }
  //             AppSharedPreferences.setOfflineOthersPayments(
  //                 _tempOfflineOthersPayments3);
  //           });
  //         });
  //       });
  //     }
  //   }
  //   // print(_offlineSubscriptionPayments.length);
  //   // if (_offlineSubscriptionPayments.isNotEmpty &&
  //   //     _offlineSubscriptionPayments != null &&
  //   //     _offlineSubscriptionPayments.length > 0) {
  //   //   for (var i = 0; i < _offlineSubscriptionPayments.length; i++) {
  //   //     _tempOfflineSubscriptionPayments.add(Payment(
  //   //       customerId: _offlineSubscriptionPayments[i].customerId,
  //   //       amountPaid: _offlineSubscriptionPayments[i].amountPaid,
  //   //       serviceType: _offlineSubscriptionPayments[i].serviceType,
  //   //       paymentMode: _offlineSubscriptionPayments[i].paymentMode,
  //   //       receiptPhoneNumber:
  //   //           _offlineSubscriptionPayments[i].receiptPhoneNumber,
  //   //       paymentFor: _offlineSubscriptionPayments[i].paymentFor,
  //   //       ccomment: _offlineSubscriptionPayments[i].ccomment,
  //   //     ));
  //   //   }
  //   //   saveOfflineSubscriptionPayment(_tempOfflineSubscriptionPayments)
  //   //       .then((response) {
  //   //     if (response.statusCode == 201) {
  //   //       _offlineSubscriptionPayments.clear();
  //   //       _tempOfflineSubscriptionPayments.clear();
  //   //       AppSharedPreferences.setOfflineSubscriptionPayments(
  //   //           _offlineSubscriptionPayments);
  //   //     }
  //   //   }).catchError((error) {
  //   //     print('error : $error');
  //   //   });
  //   // }
  //   // if (_offlineSubscriptionPayments.isNotEmpty &&
  //   //     _offlineSubscriptionPayments != null &&
  //   //     _offlineSubscriptionPayments.length > 0) {
  //   //   if (user.userName ==
  //   //       _offlineSubscriptionPayments[0].created[0].userName) {
  //   //     saveOfflineSubscriptionPayment(_offlineSubscriptionPayments)
  //   //         .then((response) {
  //   //       if (response.statusCode == 201) {
  //   //         _offlineSubscriptionPayments.clear();
  //   //         AppSharedPreferences.setOfflineSubscriptionPayments(
  //   //             _offlineSubscriptionPayments);
  //   //       }
  //   //     }).catchError((error) {
  //   //       print('error : $error');
  //   //     });
  //   //   }
  //   // }
  //   // if (_offlineInstallationPayments.isNotEmpty &&
  //   //     _offlineInstallationPayments != null &&
  //   //     _offlineInstallationPayments.length > 0) {
  //   //   if (user.userName ==
  //   //       _offlineInstallationPayments[0].created[0].userName) {
  //   //     saveOfflineInstallationPayment(_offlineInstallationPayments)
  //   //         .then((response) {
  //   //       if (response.statusCode == 201) {
  //   //         _offlineInstallationPayments.clear();
  //   //         AppSharedPreferences.setOfflineInstallationPayments(
  //   //             _offlineInstallationPayments);
  //   //       }
  //   //     }).catchError((error) {
  //   //       print('error : $error');
  //   //     });
  //   //   }
  //   // }
  //   // if (_offlineOthersPayments.isNotEmpty &&
  //   //     _offlineOthersPayments != null &&
  //   //     _offlineOthersPayments.length > 0) {
  //   //   if (user.userName == _offlineOthersPayments[0].created[0].userName) {
  //   //     saveOfflineOthersPayment(_offlineOthersPayments).then((response) {
  //   //       if (response.statusCode == 201) {
  //   //         _offlineOthersPayments.clear();
  //   //         AppSharedPreferences.setOfflineOthersPayments(
  //   //             _offlineOthersPayments);
  //   //       }
  //   //     }).catchError((error) {
  //   //       print('error : $error');
  //   //     });
  //   //   }
  //   // }
  // }

  generalSetting() {
    setState(() {
      generalList("null").then((response) {
        if (response.statusCode == 200) {
          general = generalsFromJson(Utf8Codec().decode(response.bodyBytes));
          AppSharedPreferences.setGeneralSettings(general);
        }
        if (general == null || general.isEmpty) {
          general.add(General(
              id: "",
              lcoName: "",
              phoneNumber: "",
              alternateNumber: "",
              emailId: "",
              address: ""));
          AppSharedPreferences.setGeneralSettings(general);
        }
      }).catchError((error) {
        if (general == null || general.isEmpty) {
          general.add(General(
              id: "",
              lcoName: "",
              phoneNumber: "",
              alternateNumber: "",
              emailId: "",
              address: ""));
          AppSharedPreferences.setGeneralSettings(general);
        }
        print(error);
      });
      AppSharedPreferences.setGeneralSettings(general);
    });
  }

  getListData() async {
    try {
      _isGetListData = await AppSharedPreferences.isGetListData();
      Future.delayed(const Duration(seconds: 3), () {
        print("1=>" + _isGetListData.toString());
        if (_isGetListData == null || _isGetListData != true) {
          print("2=>" + _isGetListData.toString());
          customerList().then((response) {
            if (response.statusCode == 200) {
              setState(() {
                _customerList =
                    customerFromJson(Utf8Codec().decode(response.bodyBytes));
                AppSharedPreferences.setCustomers(_customerList);
                // getListOldData();
              });
            } else {
              setState(() {
                // getListOldData();
              });
            }
          }).catchError((error) {
            setState(() {
              // getListOldData();
            });
          });
          print("3=>" + _isGetListData.toString());
          billingList().then((response) {
            if (response.statusCode == 200) {
              setState(() {
                _billingList =
                    billingFromJson(Utf8Codec().decode(response.bodyBytes));
                AppSharedPreferences.setBillings(_billingList);
                // getListOldData();
              });
            } else {
              setState(() {
                // getListOldData();
              });
            }
          }).catchError((error) {
            setState(() {
              // getListOldData();
            });
          });
          print("4=>" + _isGetListData.toString());
          paymentList().then((response) {
            if (response.statusCode == 200) {
              setState(() {
                _paymentList =
                    paymentsFromJson(Utf8Codec().decode(response.bodyBytes));
                AppSharedPreferences.setPayments(_paymentList);
                // getListOldData();
              });
            } else {
              setState(() {
                // getListOldData();
              });
            }
          }).catchError((error) {
            setState(() {
              // getListOldData();
            });
          });
          print("5=>" + _isGetListData.toString());
          complaintList().then((response) {
            if (response.statusCode == 200) {
              setState(() {
                _complaintList =
                    complaintsFromJson(Utf8Codec().decode(response.bodyBytes));
                AppSharedPreferences.setComplaints(_complaintList);
                // getListOldData();
              });
            } else {
              setState(() {
                // getListOldData();
              });
            }
          }).catchError((error) {
            setState(() {
              // getListOldData();
            });
          });
          print("6=>" + _isGetListData.toString());
          setState(() {
            _isGetListData = true;
          });
          print("7=>" + _isGetListData.toString());
          AppSharedPreferences.setGetListData(_isGetListData);
          print("8=>" + _isGetListData.toString());
        }
      });
    } catch (e) {
      print(e);
    }
  }

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
  //   try {
  //     _paymentList = await AppSharedPreferences.getPayments();
  //   } catch (e) {
  //     print(e);
  //   }
  //   try {
  //     _customerList = await AppSharedPreferences.getCustomers();
  //   } catch (e) {
  //     print(e);
  //   }
  //   try {
  //     _billingList = await AppSharedPreferences.getBillings();
  //   } catch (e) {
  //     print(e);
  //   }
  //   try {
  //     _complaintList = await AppSharedPreferences.getComplaints();
  //   } catch (e) {
  //     print(e);
  //   }
  //   // _offlineSubscriptionPayments.clear();
  //   // _offlineInstallationPayments.clear();
  //   // _offlineOthersPayments.clear();
  //   // _paymentList.clear();
  //   // _customerList.clear();
  //   // _billingList.clear();
  //   // AppSharedPreferences.setOfflineSubscriptionPayments(
  //   //     _offlineSubscriptionPayments);
  //   // AppSharedPreferences.setOfflineInstallationPayments(
  //   //     _offlineInstallationPayments);
  //   // AppSharedPreferences.setOfflineOthersPayments(_offlineOthersPayments);
  //   // AppSharedPreferences.setPayments(_paymentList);
  //   // AppSharedPreferences.setCustomers(_customerList);
  //   // AppSharedPreferences.setBillings(_billingList);
  //   // try {
  //   //   _offlineSubscriptionPayments =
  //   //       await AppSharedPreferences.getOfflineSubscriptionPayments();
  //   //   _offlineInstallationPayments =
  //   //       await AppSharedPreferences.getOfflineInstallationPayments();
  //   //   _offlineOthersPayments =
  //   //       await AppSharedPreferences.getOfflineOthersPayments();
  //   //   _paymentList = await AppSharedPreferences.getPayments();
  //   //   _customerList = await AppSharedPreferences.getCustomers();
  //   //   _billingList = await AppSharedPreferences.getBillings();
  //   // _offlineSubscriptionPayments.clear();
  //   // _offlineInstallationPayments.clear();
  //   // _offlineOthersPayments.clear();
  //   // _paymentList.clear();
  //   // _customerList.clear();
  //   // _billingList.clear();
  //   // AppSharedPreferences.setOfflineSubscriptionPayments(
  //   //     _offlineSubscriptionPayments);
  //   // AppSharedPreferences.setOfflineInstallationPayments(
  //   //     _offlineInstallationPayments);
  //   // AppSharedPreferences.setOfflineOthersPayments(_offlineOthersPayments);
  //   // AppSharedPreferences.setPayments(_paymentList);
  //   // AppSharedPreferences.setCustomers(_customerList);
  //   // AppSharedPreferences.setBillings(_billingList);
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  // }

  homescreens() {
    setState(() {
      _isCustomerDetails = false;
      _isCollectionDetails = false;
      _isComplaintDetails = false;
      _isBillDetails = false;
      _ishomebutton = false;
    });
  }

  Future pause(Duration d) => new Future.delayed(d);

  Future<void> getData() async {
    // await pause(const Duration(milliseconds: 1000));
    await getOldData();
    dashboard().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          dashboardData =
              dashboardFromJson(Utf8Codec().decode(response.bodyBytes));
        });
        AppSharedPreferences.setDashboard(dashboardData);
        _isLoading = false;
        _isrefresh = false;
      } else if (response.statusCode == 401) {
        AppSharedPreferences.clear();
        setState(() {
          Navigator.pushReplacementNamed(context, "/login");
        });
        _isrefresh = false;
      } else {
        homeKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("Something went Wrong !!"),
        ));
        _isrefresh = false;
      }
    }).catchError((error) {
      print('error : $error');
      homeKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.redAccent[400],
        content: new Text("No Internet Connection. Loading Offline Content."),
      ));
      setState(() {
        getOldData();
        _isLoading = false;
      });
      _isrefresh = false;
    });

    taxSettings().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          taxSetting =
              taxSettingFromJson(Utf8Codec().decode(response.bodyBytes));
          AppSharedPreferences.setTaxSetting(taxSetting[0].gstin);
        });
      }
    }).catchError((error) {
      print(error);
    });
    _isrefresh = false;
  }

  Future getOldData() async {
    try {
      await pause(const Duration(milliseconds: 500));
      dashboardData = await AppSharedPreferences.getDashboard();
      _isLoading = false;
      _isrefresh = false;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // deviceSize = MediaQuery.of(context).size;
    // for (var i = 0; i < imageCount; i++) {
    //   boxes.add("http://www.pondernew.com/images/SVS1.jpg");
    // }
    return Scaffold(
      key: homeKey,
      drawer: MyDrawer(),
      backgroundColor: Color(0xFFdae2f0),
      // appBar: AppBar(
      //   title: Text("SVS"),
      // ),
      // body: SingleChildScrollView(
      //   child: Stack(
      //     children: <Widget>[
      //       Column(mainAxisSize: MainAxisSize.min, children: [
      //         coverScreenExample,
      //       ]),
      //       Positioned(
      //         top: 30.0,
      //         left: 4.0,
      //         child: IconButton(
      //           onPressed: () {
      //             homeKey.currentState.openDrawer();
      //           },
      //           icon: Icon(
      //             Icons.menu,
      //             color: Colors.white,
      //           ),
      //         ),
      //       ),
      //       _isLoading
      //           ? Container(
      //               margin: EdgeInsets.all(30.0),
      //               child: Center(
      //                   child: Column(
      //                 children: <Widget>[
      //                   Container(
      //                     height: 220.0,
      //                   ),
      //                   Loader()
      //                 ],
      //               )))
      //           : Container(
      //               child: Column(
      //                 children: <Widget>[
      //                   _isCustomerDetails
      //                       ? customerDetailWidget()
      //                       : _isCollectionDetails
      //                           ? collectionDetailWidget()
      //                           : _isComplaintDetails
      //                               ? complaintDetailWidget()
      //                               : _isBillDetails
      //                                   ? billDetailWidget()
      //                                   : _dashboardWidget(),
      //                 ],
      //               ),
      //             ),
      //     ],
      //   ),
      // ),
      body: new CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("SVS"),
            expandedHeight: 162.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/SVS_Home_Screen_1.jpg',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _isLoading
                  ? Container(
                      margin: EdgeInsets.all(30.0),
                      child: Center(child: Loader()))
                  : Container(
                      child: Column(
                        children: <Widget>[
                          _isCustomerDetails
                              ? customerDetailWidget()
                              : _isCollectionDetails
                                  ? collectionDetailWidget()
                                  : _isComplaintDetails
                                      ? complaintDetailWidget()
                                      : _isBillDetails
                                          ? billDetailWidget()
                                          : _dashboardWidget(),
                        ],
                      ),
                    ),
              childCount: 1,
            ),
          )
        ],
      ),
      floatingActionButton: _ishomebutton
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: "Refresh",
                  clipBehavior: Clip.antiAlias,
                  onPressed: () {
                    setState(() {
                      _isrefresh = true;
                      getData();
                    });
                  },
                  child: Ink(
                    decoration: new BoxDecoration(
                      color: Colors.teal,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        _isrefresh
                            ? Padding(
                                padding: EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                FloatingActionButton(
                  heroTag: "Back",
                  clipBehavior: Clip.antiAlias,
                  onPressed: () {
                    setState(() {
                      _isCustomerDetails = false;
                      _isCollectionDetails = false;
                      _isComplaintDetails = false;
                      _isBillDetails = false;
                      _ishomebutton = false;
                    });
                  },
                  child: Ink(
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  // Widget _imageCarousel() {
  //   List boxes = [];
  //   for (var i = 0; i < imageCount; i++) {
  //     boxes.add(NetworkImage("http://www.pondernew.com/images/SVS1.jpg"));
  //   }
  //   return Container(
  //     height: 220.0,
  //     child: Carousel(
  //       boxFit: BoxFit.cover,
  //       images: boxes,

  //       // [
  //       //   NetworkImage("http://www.pondernew.com/images/SVS1.jpg"),
  //       //   NetworkImage("http://www.pondernew.com/images/SVS1.jpg"),

  //       //   // AssetImage('assets/images/SVS_Home_Screen_1.jpg'),
  //       //   // AssetImage('assets/images/SVS_Home_Screen_1.jpg'),
  //       // ],
  //       // autoplay: true,
  //       // autoplayDuration: const Duration(seconds: 5),
  //       overlayShadowColors: Color(0xFFdae2f0),
  //       overlayShadowSize: 0.8,
  //       overlayShadow: true,
  //       indicatorBgPadding: 5.0,
  //       dotSize: 4.0,
  //       dotSpacing: 15.0,
  //     ),
  //   );
  // }

  Widget _dashboardWidget() {
    var smallItemPadding = EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Container(
          //   height: 220.0,
          // ),
          Container(
            height: 125.0,
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCustomerDetails = true;
                        _ishomebutton = true;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: smallItemPadding,
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/icons/Customer.png",
                                    height: 70,
                                    // scale: 2.5,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 15.0),
                              child: Text(
                                'Customer Details',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w800),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCollectionDetails = true;
                        _ishomebutton = true;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: smallItemPadding,
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/icons/Collection.png",
                                    height: 70,
                                    // scale: 2.5,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 15.0),
                              child: Text(
                                'Collection Details',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w800),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 125.0,
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isComplaintDetails = true;
                        _ishomebutton = true;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: smallItemPadding,
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/icons/Complaint.png",
                                    height: 70,
                                    // scale: 2.5,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 15.0),
                              child: Text(
                                'Complaint Details',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w800),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isBillDetails = true;
                        _ishomebutton = true;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: smallItemPadding,
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/icons/Bill.png",
                                    height: 70,
                                    // scale: 2.5,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 15.0),
                              child: Text(
                                'Bill Details',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w800),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 125.0,
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddPaymentScreen()));
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: smallItemPadding,
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/icons/Add_Payment.png",
                                    height: 70,
                                    // scale: 2.5,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 15.0),
                              child: Text(
                                'Add Payment',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w800),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddComplaintScreen()));
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: smallItemPadding,
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/icons/Add_Complaint.png",
                                    height: 70,
                                    // scale: 2.5,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 15.0),
                              child: Text(
                                'Add Complaint',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w800),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  customerDetailWidget() => user.userType == "Full Agent"
      ? Column(
          children: <Widget>[
            _permisstionNotGranted(),
          ],
        )
      : Column(
          children: <Widget>[
            // Container(
            //   height: 220.0,
            // ),
            _customersWidget(),
            dashboardData.cable > 0 ? _cableConnectionWidget() : Container(),
            dashboardData.internet > 0 ? _internetWidget() : Container(),
            Container(
              height: 70.0,
            )
          ],
        );

  collectionDetailWidget() => Column(
        children: <Widget>[
          // Container(
          //   height: 220.0,
          // ),
          _collectionListWidget(),
          Container(
            height: 70.0,
          )
        ],
      );

  complaintDetailWidget() => Column(
        children: <Widget>[
          // Container(
          //   height: 220.0,
          // ),
          _cableComplaintWidget(),
          _internetComplaintWidget(),
          Container(
            height: 70.0,
          )
        ],
      );

  billDetailWidget() => Column(
        children: <Widget>[
          // Container(
          //   height: 220.0,
          // ),
          user.userType == "Admin" || user.userType == "Sub-Admin"
              ? _currentMonthBillWidget()
              : Container(),
          _paymentCollectionWidget(),
          Container(
            height: 70.0,
          )
        ],
      );

  Widget _permisstionNotGranted() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 10.0,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Permission Not Granted",
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customersWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 10.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        elevation: 10.0,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        shape: StadiumBorder(
                            side: BorderSide(
                                width: 5.0,
                                color: Color.fromARGB(255, 255, 224, 236))),
                        color: Color.fromARGB(255, 174, 39, 95),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.people,
                                        color: Colors.white,
                                      ),
                                      Container(
                                        width: 2.0,
                                      ),
                                      Text(
                                          "Customers : " +
                                              dashboardData.totalCustomers
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0)),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CustomerListScreen(
                                              filterIndex: 1,
                                            ))),
                                child: Container(
                                  child: Card(
                                    elevation: 5.0,
                                    color: Color.fromARGB(255, 100, 154, 11),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          dashboardData
                                                              .activeCustomers
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 40.0)),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Active",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 2.0,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CustomerListScreen(
                                              filterIndex: 2,
                                            ))),
                                child: Container(
                                  child: Card(
                                    elevation: 5.0,
                                    color: Color.fromARGB(255, 228, 45, 64),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          dashboardData
                                                              .inactiveCustomers
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 40.0)),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Inactive",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 5.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cableConnectionWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 10.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        elevation: 10.0,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        shape: StadiumBorder(
                            side: BorderSide(
                                width: 5.0,
                                color: Color.fromARGB(255, 221, 243, 255))),
                        color: Color.fromARGB(255, 57, 175, 234),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.ondemand_video,
                                        color: Colors.white,
                                      ),
                                      Container(
                                        width: 2.0,
                                      ),
                                      Text(
                                          "Cable : " +
                                              dashboardData.cable.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CustomerListScreen(
                                              filterIndex: 3,
                                            ))),
                                child: Container(
                                  child: Card(
                                    elevation: 5.0,
                                    color: Color.fromARGB(255, 100, 154, 11),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          dashboardData
                                                              .activeCable
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 40.0)),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Active",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 2.0,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CustomerListScreen(
                                              filterIndex: 4,
                                            ))),
                                child: Container(
                                  child: Card(
                                    elevation: 5.0,
                                    color: Color.fromARGB(255, 228, 45, 64),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          dashboardData
                                                              .inactiveCable
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 40.0)),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Inactive",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Card(
                                  elevation: 5.0,
                                  color: Color.fromARGB(255, 250, 187, 61),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 100.0,
                                        width: 160.0,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                        dashboardData.sd
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 40.0)),
                                                  ],
                                                ),
                                                Container(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text("SD",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.0)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 2.0,
                              ),
                              Container(
                                child: Card(
                                  elevation: 5.0,
                                  color: Color.fromARGB(255, 174, 39, 95),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 100.0,
                                        width: 160.0,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                        dashboardData.hd
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 40.0)),
                                                  ],
                                                ),
                                                Container(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text("HD",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.0)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Card(
                                  elevation: 5.0,
                                  color: Color.fromARGB(255, 126, 116, 240),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 100.0,
                                        width: 160.0,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                        dashboardData.analog
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 40.0)),
                                                  ],
                                                ),
                                                Container(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text("Analog",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.0)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 2.0,
                              ),
                              Container(
                                child: Card(
                                  elevation: 5.0,
                                  color: Color.fromARGB(255, 57, 175, 234),
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 100.0,
                                        width: 160.0,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                        dashboardData.freeCable
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 40.0)),
                                                  ],
                                                ),
                                                Container(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text("Free",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.0)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 5.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _internetWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 10.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        elevation: 10.0,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        shape: StadiumBorder(
                            side: BorderSide(
                                width: 5.0,
                                color: Color.fromARGB(255, 255, 233, 186))),
                        color: Color.fromARGB(255, 250, 187, 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.signal_wifi_4_bar,
                                        color: Colors.white,
                                      ),
                                      Container(
                                        width: 2.0,
                                      ),
                                      Text(
                                          "Internet : " +
                                              dashboardData.internet.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CustomerListScreen(
                                              filterIndex: 5,
                                            ))),
                                child: Container(
                                  child: Card(
                                    elevation: 5.0,
                                    color: Color.fromARGB(255, 100, 154, 11),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          dashboardData
                                                              .activeInternet
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 40.0)),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Active",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 2.0,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CustomerListScreen(
                                              filterIndex: 6,
                                            ))),
                                child: Container(
                                  child: Card(
                                    elevation: 5.0,
                                    color: Color.fromARGB(255, 228, 45, 64),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          dashboardData
                                                              .inactiveInternet
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 40.0)),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Inactive",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Card(
                                  elevation: 5.0,
                                  color: Color.fromARGB(255, 57, 175, 234),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 100.0,
                                        width: 160.0,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                        dashboardData
                                                            .freeInternet
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 40.0)),
                                                  ],
                                                ),
                                                Container(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text("Free",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.0)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 5.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cableComplaintWidget() {
    var _totalCableComplaints = dashboardData.cComplaintClosed.toInt() +
        dashboardData.cComplaintOpen.toInt();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 10.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        elevation: 10.0,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        shape: StadiumBorder(
                            side: BorderSide(
                                width: 5.0,
                                color: Color.fromARGB(255, 255, 224, 236))),
                        color: Color.fromARGB(255, 174, 39, 95),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.report,
                                        color: Colors.white,
                                      ),
                                      Container(
                                        width: 2.0,
                                      ),
                                      Text(
                                          "Cable Complaints : " +
                                              _totalCableComplaints.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ComplaintListScreen(
                                              filterIndex: 1,
                                            ))),
                                child: Container(
                                  child: Card(
                                    elevation: 5.0,
                                    color: Color.fromARGB(255, 100, 154, 11),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          dashboardData
                                                              .cComplaintClosed
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 40.0)),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Closed",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 2.0,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ComplaintListScreen(
                                              filterIndex: 2,
                                            ))),
                                child: Container(
                                  child: Card(
                                    elevation: 5.0,
                                    color: Color.fromARGB(255, 228, 45, 64),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          dashboardData
                                                              .cComplaintOpen
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 40.0)),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Open",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 5.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _internetComplaintWidget() {
    var _totalInternetComplaints = dashboardData.iComplaintClosed.toInt() +
        dashboardData.iComplaintOpen.toInt();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 10.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        elevation: 10.0,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        shape: StadiumBorder(
                            side: BorderSide(
                                width: 5.0,
                                color: Color.fromARGB(255, 255, 224, 236))),
                        color: Color.fromARGB(255, 174, 39, 95),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Icon(
                                      Icons.report_problem,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      width: 2.0,
                                    ),
                                    Text(
                                        "Internet Complaints : " +
                                            _totalInternetComplaints.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0))
                                  ]),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ComplaintListScreen(
                                              filterIndex: 3,
                                            ))),
                                child: Container(
                                  child: Card(
                                    elevation: 5.0,
                                    color: Color.fromARGB(255, 100, 154, 11),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          dashboardData
                                                              .iComplaintClosed
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 40.0)),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Closed",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 2.0,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ComplaintListScreen(
                                              filterIndex: 4,
                                            ))),
                                child: Container(
                                  child: Card(
                                    elevation: 5.0,
                                    color: Color.fromARGB(255, 228, 45, 64),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          dashboardData
                                                              .iComplaintOpen
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 40.0)),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Open",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 5.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentMonthBillWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 10.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        elevation: 10.0,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        shape: StadiumBorder(
                            side: BorderSide(
                                width: 5.0,
                                color: Color.fromARGB(255, 196, 206, 255))),
                        color: Color.fromARGB(255, 39, 52, 112),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Icon(
                                      Icons.payment,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      width: 2.0,
                                    ),
                                    Text("Current Month Bill",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0))
                                  ]),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            BillingListScreen(
                                              filterIndex: 0,
                                            ))),
                                child: Container(
                                  child: Card(
                                    elevation: 5.0,
                                    color: Color.fromARGB(255, 58, 34, 79),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          dashboardData
                                                              .totalBill
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 22.5)),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Bill",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 2.0,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            BillingListScreen(
                                              filterIndex: 0,
                                            ))),
                                child: Container(
                                  child: Card(
                                    elevation: 5.0,
                                    color: Color.fromARGB(255, 24, 66, 46),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          "Rs. " +
                                                              currency.format(
                                                                  dashboardData
                                                                      .totalAmount),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 22.5)),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text("Amount",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 5.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentCollectionWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 10.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        elevation: 10.0,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        shape: StadiumBorder(
                            side: BorderSide(
                                width: 5.0,
                                color: Color.fromARGB(255, 255, 232, 250))),
                        color: Color.fromARGB(255, 112, 20, 92),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Icon(
                                      Icons.payment,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      width: 2.0,
                                    ),
                                    Text("Payment Collection",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0))
                                  ]),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            BillingListScreen(
                                              filterIndex: 1,
                                            ))),
                                child: Container(
                                  child: Card(
                                    elevation: 5.0,
                                    color: Color.fromARGB(255, 100, 154, 11),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          dashboardData
                                                                  .cablePaid
                                                                  .toString() +
                                                              " - Paid",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  user.userType == "Admin" ||
                                                          user.userType ==
                                                              "Sub-Admin"
                                                      ? Container(
                                                          height: 10.0,
                                                        )
                                                      : Container(),
                                                  user.userType == "Admin" ||
                                                          user.userType ==
                                                              "Sub-Admin"
                                                      ? Row(
                                                          children: <Widget>[
                                                            Text(
                                                                "Rs. " +
                                                                    currency.format(
                                                                        dashboardData
                                                                            .amountPaid),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        22.5)),
                                                          ],
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 2.0,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            BillingListScreen(
                                              filterIndex: 2,
                                            ))),
                                child: Container(
                                  child: Card(
                                    elevation: 5.0,
                                    color: Color.fromARGB(255, 228, 45, 64),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 160.0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                          dashboardData
                                                                  .cableUnpaid
                                                                  .toString() +
                                                              " - Unpaid",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  user.userType == "Admin" ||
                                                          user.userType ==
                                                              "Sub-Admin"
                                                      ? Container(
                                                          height: 10.0,
                                                        )
                                                      : Container(),
                                                  user.userType == "Admin" ||
                                                          user.userType ==
                                                              "Sub-Admin"
                                                      ? Row(
                                                          children: <Widget>[
                                                            Text(
                                                                "Rs. " +
                                                                    currency.format(
                                                                        dashboardData
                                                                            .amountUnpaid),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        22.5)),
                                                          ],
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 5.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _collectionListWidget() {
    var collectionList = List<Widget>();
    var totalTodayCustomer = 0;
    var totalMonthlyCustomer = 0;
    var totalTodayCollection = 0;
    var totalMontlyCollection = 0;
    var totalUser = 0;

    for (var i = 0; i < dashboardData.collection.length; i++) {
      if (dashboardData.collection[i].monthlyCustomers > 0) {
        totalTodayCustomer = totalTodayCustomer +
            dashboardData.collection[i].todayCustomers.toInt();

        totalMonthlyCustomer = totalMonthlyCustomer +
            dashboardData.collection[i].monthlyCustomers.toInt();

        totalTodayCollection = totalTodayCollection +
            dashboardData.collection[i].todayCollection.toInt();

        totalMontlyCollection = totalMontlyCollection +
            dashboardData.collection[i].monthlyCollection.toInt();

        totalUser = totalUser + 1;
      }
    }

    for (var i = 0; i < dashboardData.collection.length; i++) {
      var collection = new Container(
        margin: new EdgeInsets.symmetric(horizontal: 10.0),
        child: _collectionView(dashboardData.collection[i]),
      );
      if (dashboardData.collection[i].monthlyCustomers > 0) {
        collectionList.add(collection);
      }
    }

    return Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
            Widget>[
          Card(
              elevation: 10.0,
              child: Column(children: <Widget>[
                Container(
                  height: 10.0,
                ),
                Row(children: <Widget>[
                  Expanded(
                      child: Card(
                          elevation: 10.0,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          shape: StadiumBorder(
                              side: BorderSide(
                                  width: 5.0,
                                  color: Color.fromARGB(255, 224, 221, 255))),
                          color: Color.fromARGB(255, 126, 116, 240),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    height: 50.0,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          Icon(
                                            Icons.payment,
                                            color: Colors.white,
                                          ),
                                          Container(
                                            width: 2.0,
                                          ),
                                          Text("Collection Details",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0)),
                                        ]),
                                      ],
                                    )),
                              ]))),
                ]),
                Container(
                  height: 10.0,
                ),
                Column(children: <Widget>[
                  Container(
                    margin: new EdgeInsets.symmetric(horizontal: 10.0),
                    child: InkWell(
                        onTap: () {},
                        child: Card(
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 2.0, vertical: 5.0),
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              Table(
                                children: [
                                  TableRow(children: [
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 5,
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: 80,
                                            height: 20,
                                            child: Text(
                                              " Users - " +
                                                  totalUser.toString(),
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      "Raleway-Regular"),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 115,
                                            height: 20,
                                            child: Text(
                                              "Customers",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      "Raleway-Regular"),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.0,
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: 115,
                                            height: 20,
                                            child: Text(
                                              "Amount",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      "Raleway-Regular"),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                                  TableRow(children: [
                                    Container(
                                      color: Color.fromARGB(255, 240, 222, 252),
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 5,
                                            height: 20,
                                          ),
                                          SizedBox(
                                            height: 20,
                                            child: Text(
                                              " Today",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      "Raleway-Regular"),
                                              textAlign: TextAlign.start,
                                            ),
                                            width: 80,
                                          ),
                                          SizedBox(
                                            width: 115,
                                            height: 20,
                                            child: Text(
                                              totalTodayCustomer.toString(),
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      "Raleway-Regular"),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.0,
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: 115,
                                            height: 20,
                                            child: Text(
                                              "₹ " +
                                                  currency.format(
                                                      totalTodayCollection),
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      "Raleway-Regular"),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                                  TableRow(children: [
                                    Container(
                                      color: Color.fromARGB(255, 219, 255, 249),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 5,
                                            height: 20,
                                          ),
                                          SizedBox(
                                            child: Text(
                                              " Monthly",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      "Raleway-Regular"),
                                              textAlign: TextAlign.start,
                                            ),
                                            width: 80,
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: 115,
                                            height: 20,
                                            child: Text(
                                              totalMonthlyCustomer.toString(),
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      "Raleway-Regular"),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.0,
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: 115,
                                            height: 20,
                                            child: Text(
                                              "₹ " +
                                                  currency.format(
                                                      totalMontlyCollection),
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      "Raleway-Regular"),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    )
                                  ])
                                ],
                              ),
                            ],
                          )),
                        )),
                  )
                ]),
                Column(
                  children: collectionList,
                ),
                Container(
                  height: 10.0,
                ),
              ]))
        ]));
  }

  Widget _collectionView(Collection collection) {
    return InkWell(
        onTap: () {},
        child: Card(
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          margin: new EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
          child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 10.0,
                      ),
                      CircleAvatar(
                        radius: 27.0,
                        backgroundImage: AssetImage("assets/images/user.png"),
                      ),
                      Container(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            collection.user.name.toUpperCase(),
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w900),
                          ),
                          Container(
                            height: 2.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  collection.user.activeStatus == true
                                      ? " Active "
                                      : " Inactive ",
                                  style: TextStyle(
                                      fontSize: 10.0, color: Colors.white),
                                ),
                                decoration: BoxDecoration(
                                    color: collection.user.activeStatus == true
                                        ? Colors.green
                                        : Colors.redAccent[100],
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.elliptical(10, 10),
                                        right: Radius.elliptical(10, 10))),
                              ),
                              Container(
                                child: Text(
                                  " | ",
                                ),
                              ),
                              Container(
                                child: Text(
                                  collection.user.phoneNumber.toString(),
                                  style: TextStyle(fontSize: 10.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    height: 10.0,
                  ),
                  Table(
                    children: [
                      TableRow(children: [
                        Container(
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                                height: 20,
                              ),
                              SizedBox(
                                width: 80,
                                height: 20,
                              ),
                              SizedBox(
                                width: 115,
                                height: 20,
                                child: Text(
                                  "Customers",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Raleway-Regular"),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 3.0,
                                height: 20,
                              ),
                              SizedBox(
                                width: 115,
                                height: 20,
                                child: Text(
                                  "Amount",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Raleway-Regular"),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ]),
                      TableRow(children: [
                        Container(
                          color: Color.fromARGB(255, 240, 222, 252),
                          alignment: Alignment.center,
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                                child: Text(
                                  " Today",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Raleway-Regular"),
                                  textAlign: TextAlign.start,
                                ),
                                width: 80,
                              ),
                              SizedBox(
                                width: 115,
                                height: 20,
                                child: Text(
                                  collection.todayCustomers.toString(),
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Raleway-Regular"),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 3.0,
                                height: 20,
                              ),
                              SizedBox(
                                width: 115,
                                height: 20,
                                child: Text(
                                  "₹ " +
                                      currency
                                          .format(collection.todayCollection),
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Raleway-Regular"),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ]),
                      TableRow(children: [
                        Container(
                          color: Color.fromARGB(255, 219, 255, 249),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                                height: 20,
                              ),
                              SizedBox(
                                child: Text(
                                  " Monthly",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Raleway-Regular"),
                                  textAlign: TextAlign.start,
                                ),
                                width: 80,
                                height: 20,
                              ),
                              SizedBox(
                                width: 115,
                                height: 20,
                                child: Text(
                                  collection.monthlyCustomers.toString(),
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Raleway-Regular"),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 3.0,
                                height: 20,
                              ),
                              SizedBox(
                                width: 115,
                                height: 20,
                                child: Text(
                                  "₹ " +
                                      currency
                                          .format(collection.monthlyCollection),
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Raleway-Regular"),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ])
                    ],
                  ),
                ],
              )),
        ));
  }
}

// class MyActionButton extends StatelessWidget {

//   const MyActionButton({

//     Key key,

//   }) : super(key: key);

//   @override

//   Widget build(BuildContext context) {

//     return Container(

//       height: 100.0,

//       width: 100.0,

//       child: ClipPolygon(

//         sides: 6,

//         child: Container(

//           color: Color(0xFFf4bf47),

//           child: Column(

//             mainAxisAlignment: MainAxisAlignment.center,

//             children: <Widget>[

//               Icon(Icons.home),

//               SizedBox(height: 4.0,),

//               Text('Menu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),)

//             ],

//           ),

//         ),

//       ),

//     );

//   }

// }

// Widget _testWidget() {
//   return Container(
//     margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
//     child: Column(
//       children: <Widget>[
//         Card(
//           child: Row(
//             children: <Widget>[
//               Column(
//                 children: <Widget>[
//                   Card(
//                     margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.vertical(
//                             top: Radius.elliptical(10, 10),
//                             bottom: Radius.elliptical(10, 10))),
//                     color: Color.fromARGB(255, 174, 39, 95),
//                     child: Icon(
//                       Icons.people,
//                       color: Colors.white,
//                       size: 100.0,
//                     ),
//                   )
//                 ],
//               ),
//               Column(
//                 children: <Widget>[
//                   Row(
//                     children: <Widget>[
//                       Text(
//                         "Customer -[",
//                         style: TextStyle(fontSize: 20.0),
//                       ),
//                       Text("TOTAL: " +
//                           dashboardData.totalCustomers.toString()),
//                       Text(
//                         "]",
//                         style: TextStyle(fontSize: 20.0),
//                       ),
//                     ],
//                   ),
//                   Container(height: 10.0,),
//                   Row(
//                     children: <Widget>[
//                       Column(
//                         children: <Widget>[
//                           Text("Active"),
//                           Card(
//                             margin: const EdgeInsets.all(4.0),
//                             shape: StadiumBorder(),
//                             color: Colors.green,
//                             child: Text("  "+
//                               dashboardData.activeCustomers.toString()+"  ",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           )
//                         ],
//                       ),
//                       Container(width: 20.0,),
//                       Column(
//                         children: <Widget>[
//                           Text("Inactive"),
//                           Card(
//                             margin: const EdgeInsets.all(4.0),
//                             shape: StadiumBorder(),
//                             color: Colors.red,
//                             child: Text("  "+
//                               dashboardData.inactiveCustomers.toString()+"  ",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         )
//       ],
//     ),
//   );
// }

//   Container(
//     height: 10.0,
//   ),
//   Row(
//     children: <Widget>[
//       Container(
//         width: 10.0,
//       ),
//       Container(
//         child: Text(
//           "Today :",
//           style: TextStyle(
//               color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w800),
//         ),
//       )
//     ],
//   ),
//   Container(
//     height: 10.0,
//   ),
//   Row(
//   children: <Widget>[
//     Expanded(
//       child: Card(
//         elevation: 10.0,
//         margin: const EdgeInsets.symmetric(horizontal: 20.0),
//         shape: StadiumBorder(
//             side: BorderSide(
//                 width: 1.0,
//                 color: Color.fromARGB(255, 255, 219, 224))
//                 ),
//         color: Color.fromARGB(255, 193, 19, 45),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               height: 30.0,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Container(width: 10.0),
//                   Text(
//                       "Customers : " +
//                           collection.todayCustomers.toString(),
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18.0))
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     ),
//   ],
// ),
// Container(
//     height: 10.0,
//   ),
// Row(
//   children: <Widget>[
//     Expanded(
//       child: Card(
//         elevation: 10.0,
//         margin: const EdgeInsets.symmetric(horizontal: 20.0),
//         shape: StadiumBorder(
//             side: BorderSide(
//                 width: 1.0,
//                 color: Color.fromARGB(255, 212, 247, 223))
//                 ),
//         color: Color.fromARGB(255, 42, 132, 69),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               height: 30.0,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Container(width: 10.0),
//                   Text(
//                       "Amount : Rs. " +
//                           collection.todayCollection.toString(),
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18.0))
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     ),
//   ],
// ),
//   Container(
//     height: 10.0,
//   ),
//   Row(
//     children: <Widget>[
//       Container(
//         width: 10.0,
//       ),
//       Container(
//         child: Text(
//           "Monthly :",
//           style: TextStyle(
//               color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w800),
//         ),
//       )
//     ],
//   ),
//   Container(
//     height: 10.0,
//   ),
//   Row(
//   children: <Widget>[
//     Expanded(
//       child: Card(
//         elevation: 10.0,
//         margin: const EdgeInsets.symmetric(horizontal: 20.0),
//         shape: StadiumBorder(
//             side: BorderSide(
//                 width: 1.0,
//                 color: Color.fromARGB(255, 255, 219, 224))
//                 ),
//         color: Color.fromARGB(255, 193, 19, 45),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               height: 30.0,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Container(width: 10.0),
//                   Text(
//                       "Customers : " +
//                           collection.monthlyCustomers.toString(),
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18.0))
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     ),
//   ],
// ),
// Container(
//     height: 10.0,
//   ),
// Row(
//   children: <Widget>[
//     Expanded(
//       child: Card(
//         elevation: 10.0,
//         margin: const EdgeInsets.symmetric(horizontal: 20.0),
//         shape: StadiumBorder(
//             side: BorderSide(
//                 width: 1.0,
//                 color: Color.fromARGB(255, 212, 247, 223))
//                 ),
//         color: Color.fromARGB(255, 42, 132, 69),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               height: 30.0,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Container(width: 10.0),
//                   Text(
//                       "Amount : Rs. " +
//                           collection.monthlyCollection.toString(),
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18.0))
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     ),
//   ],
// ),
// Widget _collectionTotalWidget(Collection collection) {
//   return Container(
//     child: Card(
//       child: Column(
//         children: <Widget>[
//           Container(
//             height: 10.0,
//           ),
//           Row(
//             children: <Widget>[
//               Container(
//                 width: 10.0,
//               ),
//               Container(
//                 child: Text(
//                   "Total User :" + dashboardData.collection.length.toString(),
//                   style:
//                       TextStyle(fontSize: 17.0, fontWeight: FontWeight.w800),
//                 ),
//               )
//             ],
//           ),
//           Container(
//             height: 10.0,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 margin: EdgeInsets.all(5.0),
//                 height: 12.0,
//                 width: 12.0,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30.0),
//                     color: collection.user.activeStatus == true
//                         ? Colors.green
//                         : Colors.red),
//               ),
//               Container(
//                   margin: EdgeInsets.all(5.0),
//                   child: Text(
//                     collection.user.name.toUpperCase() +
//                         " - " +
//                         collection.user.phoneNumber.toString(),
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   )),
//             ],
//           ),
//           Container(
//             height: 10.0,
//           ),
//           Row(
//             children: <Widget>[
//               Container(
//                 width: 10.0,
//               ),
//               Container(
//                 child: Text(
//                   "Today :",
//                   style:
//                       TextStyle(fontSize: 17.0, fontWeight: FontWeight.w800),
//                 ),
//               )
//             ],
//           ),
//           Container(
//             height: 10.0,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               Container(
//                   margin: EdgeInsets.all(5.0),
//                   child: Text(
//                     "Customers - " + collection.todayCustomers.toString(),
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   )),
//               Container(
//                   margin: EdgeInsets.all(5.0),
//                   child: Text(
//                     "Amount - Rs. " + collection.todayCollection.toString(),
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   )),
//             ],
//           ),
//           Container(
//             height: 10.0,
//           ),
//           Row(
//             children: <Widget>[
//               Container(
//                 width: 10.0,
//               ),
//               Container(
//                 child: Text(
//                   "Monthly :",
//                   style:
//                       TextStyle(fontSize: 17.0, fontWeight: FontWeight.w800),
//                 ),
//               )
//             ],
//           ),
//           Container(
//             height: 10.0,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               Container(
//                   margin: EdgeInsets.all(5.0),
//                   child: Text(
//                     "Customers - " + collection.monthlyCustomers.toString(),
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   )),
//               Container(
//                   margin: EdgeInsets.all(5.0),
//                   child: Text(
//                     "Amount - Rs. " + collection.monthlyCollection.toString(),
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   )),
//             ],
//           ),
//           Container(
//             height: 10.0,
//           )
//         ],
//       ),
//     ),
//   );
// }
