import 'package:flutter/material.dart';
import 'package:svs/models/complaint.dart';
import 'package:svs/models/payment-category.dart';
import 'package:flutter/services.dart';
import 'package:svs/models/customer.dart';
import 'package:svs/models/payment.dart';
import 'package:svs/services/basic_service.dart';
import 'package:svs/widgets/payment_view.dart';
import 'dart:convert';
import 'package:svs/utils/app_shared_preferences.dart';

import 'package:intl/intl.dart';
import 'package:svs/models/billing.dart';
import 'package:svs/widgets/loader.dart';
// import 'package:svs/widgets/billing_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:svs/models/login-response.dart';
import 'package:svs/models/internet-plan.dart';
import 'package:svs/models/internet-billing.dart';
import 'package:svs/models/internet-billing-setting.dart';
// import 'package:flutter/scheduler.dart';

class AddCustomerPaymentScreen extends StatefulWidget {
  final Customer customer;
  final bool internet;
  AddCustomerPaymentScreen(
      {Key key, @required this.customer, @required this.internet})
      : super(key: key);
  _AddCustomerPaymentScreenState createState() =>
      _AddCustomerPaymentScreenState();
}

class _AddCustomerPaymentScreenState extends State<AddCustomerPaymentScreen> {
  final _addPaymentKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> addPaymentKey = new GlobalKey<ScaffoldState>();
  // bool pay = false;
  bool _isAdding = false;
  bool _isLoading = true;
  String _receiptPhoneNumber;
  String _serviceType = "cable";
  String _outstanding = '0';
  String _paymentForCable = "Subscription";
  String _paymentForInternet = "Subscription";
  PaymentCategory _paymentForOthers;
  List<PaymentCategory> paymentCategories = [];
  String _paymentMode = "Cash";
  final TextEditingController _amountPaidCableController =
      new TextEditingController();
  final TextEditingController _amountPaidInternetController =
      new TextEditingController();
  final TextEditingController _amountPaidOthersController =
      new TextEditingController();
  final TextEditingController _commentCableController =
      new TextEditingController();
  final TextEditingController _commentInternetController =
      new TextEditingController();
  final TextEditingController _commentOthersController =
      new TextEditingController();
  // final TextEditingController _searchCustomer = new TextEditingController();
  // String barcode = "";
  List<InternetBillingSetting> _internetBillingSettings;
  Payment paymentData;
  // Billing billingData;
  String _internetPlanAmount;
  LoginResponse user;
  InternetPlan _internetPlans;
  List<InternetPlan> internetPlans = [];
  final TextEditingController _planAmountInternetController =
      new TextEditingController();
  bool _generateInternetInvoice = true;
  bool _addInternetPayment = false;
  var dateFormatter = new DateFormat('dd-MM-yyyy');
  String _actdate = "";
  final TextEditingController _actController = new TextEditingController();
  String _expdate = "";
  final TextEditingController _expController = new TextEditingController();
  bool _recordPayment = true;
  InternetBilling internetBillings;
  Payment payment;
  String _amountPaidCable;
  String _amountPaidInternet;
  String _amountPaidOthers;
  String _commentCable;
  String _commentInternet;
  String _commentOthers;
  bool _isDiscount = false;
  String _discountCable = "";
  String _discountCommentCable;
  final TextEditingController _discountCableController =
      new TextEditingController();
  final TextEditingController _discountCommentCableController =
      new TextEditingController();
  String _discountInternet = "";
  String _discountCommentInternet;
  final TextEditingController _discountInternetController =
      new TextEditingController();
  final TextEditingController _discountCommentInternetController =
      new TextEditingController();
  String _discountOthers = "";
  String _discountCommentOthers;
  final TextEditingController _discountOthersController =
      new TextEditingController();
  final TextEditingController _discountCommentOthersController =
      new TextEditingController();
  List<Payment> _offlineSubscriptionPayments = [];
  List<Payment> _offlineInstallationPayments = [];
  List<Payment> _offlineOthersPayments = [];
  List<Customer> _customerList = [];
  List<Billing> _billingList = [];
  List<Payment> _paymentList = [];
  int _currentPayment;

  List<Complaint> _complaintList = [];

  @override
  void initState() {
    super.initState();
    initUserProfile();
    getListOldData();
    // getListData();
    getInternetBillingSetting();
    getPaymentforData();
    getInternetPlan();
    _setTextField();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
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
  //   paymentList().then((response) {
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         _paymentList =
  //             paymentsFromJson(Utf8Codec().decode(response.bodyBytes));
  //         AppSharedPreferences.setPayments(_paymentList);
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

  Future getListOldData() async {
    try {
      _offlineSubscriptionPayments =
          await AppSharedPreferences.getOfflineSubscriptionPayments();
    } catch (e) {
      print(e);
    }
    try {
      _offlineInstallationPayments =
          await AppSharedPreferences.getOfflineInstallationPayments();
    } catch (e) {
      print(e);
    }
    try {
      _offlineOthersPayments =
          await AppSharedPreferences.getOfflineOthersPayments();
    } catch (e) {
      print(e);
    }
    try {
      _paymentList = await AppSharedPreferences.getPayments();
    } catch (e) {
      print(e);
    }
    try {
      _customerList = await AppSharedPreferences.getCustomers();
    } catch (e) {
      print(e);
    }
    try {
      _billingList = await AppSharedPreferences.getBillings();
    } catch (e) {
      print(e);
    }
    // try {
    //   _complaintList = await AppSharedPreferences.getComplaints();
    // } catch (e) {
    //   print(e);
    // }
    // try {
    //   _offlineSubscriptionPayments =
    //       await AppSharedPreferences.getOfflineSubscriptionPayments();
    //   _offlineInstallationPayments =
    //       await AppSharedPreferences.getOfflineInstallationPayments();
    //   _offlineOthersPayments =
    //       await AppSharedPreferences.getOfflineOthersPayments();
    //   _paymentList = await AppSharedPreferences.getPayments();
    //   _customerList = await AppSharedPreferences.getCustomers();
    //   _billingList = await AppSharedPreferences.getBillings();
    // } catch (e) {
    //   print(e);
    // }
  }

  getInternetBillingSetting() {
    internetBillingSettings().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          _internetBillingSettings = internetBillingSettingFromJson(
              Utf8Codec().decode(response.bodyBytes));
          payCustomer();
        });
        AppSharedPreferences.setInternetBillingSetting(
            _internetBillingSettings);
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
        payCustomer();
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getPaymentforData() {
    paymentCategoryList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          paymentCategories =
              paymentCategorysFromJson(Utf8Codec().decode(response.bodyBytes));
          payCustomer();
        });
        AppSharedPreferences.setPaymentCategory(paymentCategories);
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
        payCustomer();
      });
    });
  }

  Future<Null> _selectActDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2025));
    if (picked != null && picked != DateTime.tryParse(_actdate.toString())) {
      setState(() {
        _actdate = picked.toString();
        _actController.text = dateFormatter
            .format(DateTime.tryParse(_actdate.toString()).toLocal());
        _expController.text = dateFormatter.format(
            DateTime.tryParse(_actdate.toString()).toLocal().add(Duration(
                days: _internetPlans.validityDays == 0 ||
                        _internetPlans.validityDays.isNegative ||
                        _internetPlans.validityDays == null ||
                        _internetPlans.validityDays < 1
                    ? 0
                    : _internetPlans.validityDays - 1)));
      });
    }
  }

  Future<Null> _selectExpDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2025));
    if (picked != null && picked != DateTime.tryParse(_expdate.toString())) {
      setState(() {
        _expdate = picked.toString();
        _expController.text = dateFormatter
            .format(DateTime.tryParse(_expdate.toString()).toLocal());
      });
    }
  }

  _setTextField() {
    setState(() {
      _amountPaidCableController.text = "0";
      _amountPaidInternetController.text = "0";
      _amountPaidOthersController.text = "0";
      _commentCableController.text = "";
      _commentInternetController.text = "";
      _commentOthersController.text = "";
      _planAmountInternetController.text = "0";
      _actController.text = dateFormatter.format(DateTime.now());
      _expController.text = "";
      _discountCableController.text = "0";
      _discountInternetController.text = "0";
      _discountOthersController.text = "0";
      _discountCommentCableController.text = "";
      _discountCommentInternetController.text = "";
      _discountCommentOthersController.text = "";
      _isDiscount = false;
    });
  }

  _setAmountPaid() {
    setState(() {
      if (_serviceType == "cable") {
        if (_paymentForCable == "Subscription") {
          _amountPaidCableController.text =
              widget.customer.cable.cableOutstandingAmount;
        } else {
          _amountPaidCableController.text = (double.tryParse(
                      widget.customer.cable.cableAdvanceAmount) -
                  double.tryParse(widget.customer.cable.cableAdvanceAmountPaid))
              .toInt()
              .toString();
        }
      }
      if (_serviceType == "internet") {
        _amountPaidInternetController.text =
            widget.customer.internet.internetOutstandingAmount;

        if (_internetPlans == null) {
          _planAmountInternetController.text = "0";
        } else {
          _planAmountInternetController.text =
              _internetPlans.planCost.toString();
        }
      }
      if (_serviceType == "others") {
        _amountPaidOthersController.text =
            _paymentForOthers == null ? "0" : _paymentForOthers.amount;
      }
    });
  }

  _addPayment(BuildContext context) async {
    if (_addPaymentKey.currentState.validate()) {
      setState(() => _isAdding = true);

      if (_serviceType == "internet" && _generateInternetInvoice == true) {
        internetBillings = InternetBilling(
          customerId: widget.customer.id,
          plan: _internetPlans.id,
          activationDate: _actdate,
          expiryDate: _expdate,
          amount: _internetPlanAmount,
          payment: _recordPayment,
        );
      } else if (_isDiscount) {
        payment = Payment(
          customerId: widget.customer.id,
          amountPaid: _serviceType == "cable"
              ? (NumberFormat("##,##,###").format(
                      double.tryParse(_amountPaidCable) -
                          double.tryParse(_discountCable)))
                  .toString()
              : _serviceType == "internet"
                  ? (NumberFormat("##,##,###").format(
                          double.tryParse(_amountPaidInternet) -
                              double.tryParse(_discountInternet)))
                      .toString()
                  : (NumberFormat("##,##,###").format(
                          double.tryParse(_amountPaidOthers) -
                              double.tryParse(_discountOthers)))
                      .toString(),
          serviceType: _serviceType,
          paymentMode: _paymentMode,
          ccomment: _serviceType == "cable"
              ? _commentCable
              : _serviceType == "internet"
                  ? _commentInternet
                  : _commentOthers,
          receiptPhoneNumber: _receiptPhoneNumber,
          paymentFor: _serviceType == "cable"
              ? _paymentForCable
              : _serviceType == "internet"
                  ? _paymentForInternet
                  : _paymentForOthers.paymentCategory,
          discount: _serviceType == "cable"
              ? _discountCable
              : _serviceType == "internet"
                  ? _discountInternet
                  : _discountOthers,
          comment: _serviceType == "cable"
              ? _discountCommentCable
              : _serviceType == "internet"
                  ? _discountCommentInternet
                  : _discountCommentOthers,
          customDate: DateTime.now().toString(),
        );
      } else {
        payment = Payment(
          customerId: widget.customer.id,
          amountPaid: _serviceType == "cable"
              ? _amountPaidCable
              : _serviceType == "internet"
                  ? _amountPaidInternet
                  : _amountPaidOthers,
          serviceType: _serviceType,
          paymentMode: _paymentMode,
          ccomment: _serviceType == "cable"
              ? _commentCable
              : _serviceType == "internet"
                  ? _commentInternet
                  : _commentOthers,
          receiptPhoneNumber: _receiptPhoneNumber,
          paymentFor: _serviceType == "cable"
              ? _paymentForCable
              : _serviceType == "internet"
                  ? _paymentForInternet
                  : _paymentForOthers.paymentCategory,
          customDate: DateTime.now().toString(),
        );
      }

      var connectivityResult = await (new Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        if (_serviceType == "cable") {
          if (_paymentForCable == "Subscription") {
            saveSubscriptionPayment(payment).then((response) {
              paymentData =
                  paymentFromJson(Utf8Codec().decode(response.bodyBytes));
              if (response.statusCode == 201) {
                addPaymentKey.currentState.showSnackBar(new SnackBar(
                  backgroundColor: Colors.green,
                  content: new Text("Payment Added Successfully!!"),
                ));
                paymentData.customerData = widget.customer;
                setState(() {
                  _isAdding = false;
                  // _searchCustomer.text = "";

                  // barcode = "";
                  // pay = false;

                  _serviceType = "cable";
                  _paymentForCable = "Subscription";
                  _paymentForInternet = "Subscription";
                  _paymentMode = "Cash";
                  _paymentForOthers = null;
                  _internetPlans = null;
                  _generateInternetInvoice = true;
                  _addInternetPayment = false;
                  _setTextField();
                  Navigator.pop(context);

                  paymentView(context, paymentData, true);
                });
              } else {
                addPaymentKey.currentState.showSnackBar(new SnackBar(
                  backgroundColor: Colors.redAccent[400],
                  content: new Text("Something went wrong !!"),
                ));

                addPaymentKey.currentState.showSnackBar(new SnackBar(
                  backgroundColor: Colors.redAccent[400],
                  content: new Text("No Internet Connection !!"),
                ));
                // setState(() {
                //   if (payment.paymentFor == "Subscription") {
                //     _offlineSubscriptionPayments.add(payment);
                //     _currentPayment = _offlineSubscriptionPayments.length - 1;
                //     _offlineSubscriptionPayments[_currentPayment].createdAt =
                //         DateTime.now().toLocal().toString();
                //     _offlineSubscriptionPayments[_currentPayment].invoiceId =
                //         "Offline";
                //     _offlineSubscriptionPayments[_currentPayment].customerData =
                //         widget.customer;
                //     if (widget.customer.cable.boxDetails != null &&
                //         widget.customer.cable.boxDetails.isNotEmpty) {
                //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
                //           widget.customer.cable.boxDetails;
                //     }
                //     _offlineSubscriptionPayments[_currentPayment].created = [];
                //     _offlineSubscriptionPayments[_currentPayment].created.add(
                //           PurpleCreated(
                //             id: "",
                //             name: user.fullName,
                //             phoneNumber: "",
                //             emailId: "",
                //             userName: user.userName,
                //             password: "",
                //             userType: user.userType,
                //             activeStatus: true,
                //           ),
                //         );
                //     for (var i = 0; i < _customerList.length; i++) {
                //       if (_customerList[i].id == widget.customer.id) {
                //         _customerList[i].cable.cableOutstandingAmount =
                //             (double.tryParse(_customerList[i]
                //                         .cable
                //                         .cableOutstandingAmount) -
                //                     double.tryParse(payment.amountPaid))
                //                 .round()
                //                 .toString();
                //         _offlineSubscriptionPayments[_currentPayment]
                //                 .outstanding =
                //             _customerList[i].cable.cableOutstandingAmount;
                //       }
                //     }
                //     for (var i = 0; i < _billingList.length; i++) {
                //       if (_billingList[i].customerId == widget.customer.id) {
                //         if (double.tryParse(
                //                 _billingList[i].outstandingAmount) <=
                //             double.tryParse(payment.amountPaid)) {
                //           _billingList[i].paidStatus = "Fully Paid";
                //         } else {
                //           _billingList[i].paidStatus = "Partial Paid";
                //         }
                //         _billingList[i].outstandingAmount =
                //             _offlineSubscriptionPayments[_currentPayment]
                //                 .outstanding;
                //         _billingList[i]
                //                 .customerData
                //                 .cable
                //                 .cableOutstandingAmount =
                //             _offlineSubscriptionPayments[_currentPayment]
                //                 .outstanding;
                //       }
                //     }
                //     _paymentList
                //         .add(_offlineSubscriptionPayments[_currentPayment]);
                //     AppSharedPreferences.setOfflineSubscriptionPayments(
                //         _offlineSubscriptionPayments);
                //     AppSharedPreferences.setCustomers(_customerList);
                //     AppSharedPreferences.setBillings(_billingList);
                //     AppSharedPreferences.setPayments(_paymentList);
                //   }
                //   if (payment.paymentFor == "Installation") {
                //     _offlineInstallationPayments.add(payment);
                //     _currentPayment = _offlineInstallationPayments.length - 1;
                //     _offlineInstallationPayments[_currentPayment].createdAt =
                //         DateTime.now().toLocal().toString();
                //     _offlineInstallationPayments[_currentPayment].invoiceId =
                //         "Offline";
                //     _offlineInstallationPayments[_currentPayment].customerData =
                //         widget.customer;
                //     if (widget.customer.cable.boxDetails != null &&
                //         widget.customer.cable.boxDetails.isNotEmpty) {
                //       _offlineInstallationPayments[_currentPayment].boxDetails =
                //           widget.customer.cable.boxDetails;
                //     }
                //     _offlineInstallationPayments[_currentPayment].created = [];
                //     _offlineInstallationPayments[_currentPayment].created.add(
                //           PurpleCreated(
                //             id: "",
                //             name: user.fullName,
                //             phoneNumber: "",
                //             emailId: "",
                //             userName: user.userName,
                //             password: "",
                //             userType: user.userType,
                //             activeStatus: true,
                //           ),
                //         );
                //     for (var i = 0; i < _customerList.length; i++) {
                //       if (_customerList[i].id == widget.customer.id) {
                //         _customerList[i].cable.cableAdvanceAmountPaid =
                //             (double.tryParse(_customerList[i]
                //                         .cable
                //                         .cableAdvanceAmountPaid) +
                //                     double.tryParse(payment.amountPaid))
                //                 .round()
                //                 .toString();
                //         _offlineInstallationPayments[_currentPayment]
                //             .outstanding = (double.tryParse(
                //                     _customerList[i].cable.cableAdvanceAmount) -
                //                 double.tryParse(_customerList[i]
                //                     .cable
                //                     .cableAdvanceAmountPaid))
                //             .round()
                //             .toString();
                //       }
                //     }
                //     _paymentList
                //         .add(_offlineInstallationPayments[_currentPayment]);
                //     AppSharedPreferences.setOfflineSubscriptionPayments(
                //         _offlineInstallationPayments);
                //     AppSharedPreferences.setCustomers(_customerList);
                //     AppSharedPreferences.setBillings(_billingList);
                //     AppSharedPreferences.setPayments(_paymentList);
                //   }
                //   if (payment.serviceType == "others") {
                //     _offlineOthersPayments.add(payment);
                //     _currentPayment = _offlineOthersPayments.length - 1;
                //     _offlineOthersPayments[_currentPayment].createdAt =
                //         DateTime.now().toLocal().toString();
                //     _offlineOthersPayments[_currentPayment].invoiceId =
                //         "Offline";
                //     _offlineOthersPayments[_currentPayment].customerData =
                //         widget.customer;
                //     if (widget.customer.cable.boxDetails != null &&
                //         widget.customer.cable.boxDetails.isNotEmpty) {
                //       _offlineOthersPayments[_currentPayment].boxDetails =
                //           widget.customer.cable.boxDetails;
                //     }
                //     _offlineOthersPayments[_currentPayment].created = [];
                //     _offlineOthersPayments[_currentPayment].created.add(
                //           PurpleCreated(
                //             id: "",
                //             name: user.fullName,
                //             phoneNumber: "",
                //             emailId: "",
                //             userName: user.userName,
                //             password: "",
                //             userType: user.userType,
                //             activeStatus: true,
                //           ),
                //         );
                //     _paymentList.add(_offlineOthersPayments[_currentPayment]);
                //     AppSharedPreferences.setOfflineSubscriptionPayments(
                //         _offlineOthersPayments);
                //     AppSharedPreferences.setCustomers(_customerList);
                //     AppSharedPreferences.setBillings(_billingList);
                //     AppSharedPreferences.setPayments(_paymentList);
                //   }
                // });
                // addPaymentKey.currentState.showSnackBar(new SnackBar(
                //   backgroundColor: Colors.blue,
                //   content: new Text("Offline Payment Added Successfully !!"),
                // ));
                // setState(() {
                //   _isAdding = false;
                //   _serviceType = "cable";
                //   _paymentForCable = "Subscription";
                //   _paymentForInternet = "Subscription";
                //   _paymentMode = "Cash";
                //   _paymentForOthers = null;
                //   _internetPlans = null;
                //   _generateInternetInvoice = true;
                //   _addInternetPayment = false;
                //   _setTextField();
                //   Navigator.pop(context);
                //   if (payment.paymentFor == "Subscription") {
                //     paymentView(context,
                //         _offlineSubscriptionPayments[_currentPayment], true);
                //   }
                //   if (payment.paymentFor == "Installation") {
                //     paymentView(context,
                //         _offlineInstallationPayments[_currentPayment], true);
                //   }
                //   if (payment.serviceType == "others") {
                //     paymentView(
                //         context, _offlineOthersPayments[_currentPayment], true);
                //   }
                // });

                setState(() => _isAdding = false);
              }
            }).catchError((error) {
              print('error : $error');

              addPaymentKey.currentState.showSnackBar(new SnackBar(
                backgroundColor: Colors.redAccent[400],
                content: new Text("No Internet Connection !!"),
              ));
              // setState(() {
              //   if (payment.paymentFor == "Subscription") {
              //     _offlineSubscriptionPayments.add(payment);
              //     _currentPayment = _offlineSubscriptionPayments.length - 1;
              //     _offlineSubscriptionPayments[_currentPayment].createdAt =
              //         DateTime.now().toLocal().toString();
              //     _offlineSubscriptionPayments[_currentPayment].invoiceId =
              //         "Offline";
              //     _offlineSubscriptionPayments[_currentPayment].customerData =
              //         widget.customer;
              //     if (widget.customer.cable.boxDetails != null &&
              //         widget.customer.cable.boxDetails.isNotEmpty) {
              //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
              //           widget.customer.cable.boxDetails;
              //     }
              //     _offlineSubscriptionPayments[_currentPayment].created = [];
              //     _offlineSubscriptionPayments[_currentPayment].created.add(
              //           PurpleCreated(
              //             id: "",
              //             name: user.fullName,
              //             phoneNumber: "",
              //             emailId: "",
              //             userName: user.userName,
              //             password: "",
              //             userType: user.userType,
              //             activeStatus: true,
              //           ),
              //         );
              //     for (var i = 0; i < _customerList.length; i++) {
              //       if (_customerList[i].id == widget.customer.id) {
              //         _customerList[i].cable.cableOutstandingAmount =
              //             (double.tryParse(_customerList[i]
              //                         .cable
              //                         .cableOutstandingAmount) -
              //                     double.tryParse(payment.amountPaid))
              //                 .round()
              //                 .toString();
              //         _offlineSubscriptionPayments[_currentPayment]
              //                 .outstanding =
              //             _customerList[i].cable.cableOutstandingAmount;
              //       }
              //     }
              //     for (var i = 0; i < _billingList.length; i++) {
              //       if (_billingList[i].customerId == widget.customer.id) {
              //         if (double.tryParse(_billingList[i].outstandingAmount) <=
              //             double.tryParse(payment.amountPaid)) {
              //           _billingList[i].paidStatus = "Fully Paid";
              //         } else {
              //           _billingList[i].paidStatus = "Partial Paid";
              //         }
              //         _billingList[i].outstandingAmount =
              //             _offlineSubscriptionPayments[_currentPayment]
              //                 .outstanding;
              //         _billingList[i]
              //                 .customerData
              //                 .cable
              //                 .cableOutstandingAmount =
              //             _offlineSubscriptionPayments[_currentPayment]
              //                 .outstanding;
              //       }
              //     }
              //     _paymentList
              //         .add(_offlineSubscriptionPayments[_currentPayment]);
              //     AppSharedPreferences.setOfflineSubscriptionPayments(
              //         _offlineSubscriptionPayments);
              //     AppSharedPreferences.setCustomers(_customerList);
              //     AppSharedPreferences.setBillings(_billingList);
              //     AppSharedPreferences.setPayments(_paymentList);
              //   }
              //   if (payment.paymentFor == "Installation") {
              //     _offlineInstallationPayments.add(payment);
              //     _currentPayment = _offlineInstallationPayments.length - 1;
              //     _offlineInstallationPayments[_currentPayment].createdAt =
              //         DateTime.now().toLocal().toString();
              //     _offlineInstallationPayments[_currentPayment].invoiceId =
              //         "Offline";
              //     _offlineInstallationPayments[_currentPayment].customerData =
              //         widget.customer;
              //     if (widget.customer.cable.boxDetails != null &&
              //         widget.customer.cable.boxDetails.isNotEmpty) {
              //       _offlineInstallationPayments[_currentPayment].boxDetails =
              //           widget.customer.cable.boxDetails;
              //     }
              //     _offlineInstallationPayments[_currentPayment].created = [];
              //     _offlineInstallationPayments[_currentPayment].created.add(
              //           PurpleCreated(
              //             id: "",
              //             name: user.fullName,
              //             phoneNumber: "",
              //             emailId: "",
              //             userName: user.userName,
              //             password: "",
              //             userType: user.userType,
              //             activeStatus: true,
              //           ),
              //         );
              //     for (var i = 0; i < _customerList.length; i++) {
              //       if (_customerList[i].id == widget.customer.id) {
              //         _customerList[i].cable.cableAdvanceAmountPaid =
              //             (double.tryParse(_customerList[i]
              //                         .cable
              //                         .cableAdvanceAmountPaid) +
              //                     double.tryParse(payment.amountPaid))
              //                 .round()
              //                 .toString();
              //         _offlineInstallationPayments[_currentPayment]
              //             .outstanding = (double.tryParse(
              //                     _customerList[i].cable.cableAdvanceAmount) -
              //                 double.tryParse(_customerList[i]
              //                     .cable
              //                     .cableAdvanceAmountPaid))
              //             .round()
              //             .toString();
              //       }
              //     }
              //     _paymentList
              //         .add(_offlineInstallationPayments[_currentPayment]);
              //     AppSharedPreferences.setOfflineSubscriptionPayments(
              //         _offlineInstallationPayments);
              //     AppSharedPreferences.setCustomers(_customerList);
              //     AppSharedPreferences.setBillings(_billingList);
              //     AppSharedPreferences.setPayments(_paymentList);
              //   }
              //   if (payment.serviceType == "others") {
              //     _offlineOthersPayments.add(payment);
              //     _currentPayment = _offlineOthersPayments.length - 1;
              //     _offlineOthersPayments[_currentPayment].createdAt =
              //         DateTime.now().toLocal().toString();
              //     _offlineOthersPayments[_currentPayment].invoiceId = "Offline";
              //     _offlineOthersPayments[_currentPayment].customerData =
              //         widget.customer;
              //     if (widget.customer.cable.boxDetails != null &&
              //         widget.customer.cable.boxDetails.isNotEmpty) {
              //       _offlineOthersPayments[_currentPayment].boxDetails =
              //           widget.customer.cable.boxDetails;
              //     }
              //     _offlineOthersPayments[_currentPayment].created = [];
              //     _offlineOthersPayments[_currentPayment].created.add(
              //           PurpleCreated(
              //             id: "",
              //             name: user.fullName,
              //             phoneNumber: "",
              //             emailId: "",
              //             userName: user.userName,
              //             password: "",
              //             userType: user.userType,
              //             activeStatus: true,
              //           ),
              //         );
              //     _paymentList.add(_offlineOthersPayments[_currentPayment]);
              //     AppSharedPreferences.setOfflineSubscriptionPayments(
              //         _offlineOthersPayments);
              //     AppSharedPreferences.setCustomers(_customerList);
              //     AppSharedPreferences.setBillings(_billingList);
              //     AppSharedPreferences.setPayments(_paymentList);
              //   }
              // });
              // addPaymentKey.currentState.showSnackBar(new SnackBar(
              //   backgroundColor: Colors.blue,
              //   content: new Text("Offline Payment Added Successfully !!"),
              // ));
              // setState(() {
              //   _isAdding = false;
              //   _serviceType = "cable";
              //   _paymentForCable = "Subscription";
              //   _paymentForInternet = "Subscription";
              //   _paymentMode = "Cash";
              //   _paymentForOthers = null;
              //   _internetPlans = null;
              //   _generateInternetInvoice = true;
              //   _addInternetPayment = false;
              //   _setTextField();
              //   Navigator.pop(context);
              //   if (payment.paymentFor == "Subscription") {
              //     paymentView(context,
              //         _offlineSubscriptionPayments[_currentPayment], true);
              //   }
              //   if (payment.paymentFor == "Installation") {
              //     paymentView(context,
              //         _offlineInstallationPayments[_currentPayment], true);
              //   }
              //   if (payment.serviceType == "others") {
              //     paymentView(
              //         context, _offlineOthersPayments[_currentPayment], true);
              //   }
              // });
            });
          }
          if (_paymentForCable == "Installation") {
            saveInstallationPayment(payment).then((response) {
              paymentData =
                  paymentFromJson(Utf8Codec().decode(response.bodyBytes));
              if (response.statusCode == 201) {
                addPaymentKey.currentState.showSnackBar(new SnackBar(
                  backgroundColor: Colors.green,
                  content: new Text("Payment Added Successfully!!"),
                ));
                paymentData.customerData = widget.customer;
                setState(() {
                  _isAdding = false;
                  // _searchCustomer.text = "";

                  // barcode = "";
                  // pay = false;

                  _serviceType = "cable";
                  _paymentForCable = "Subscription";
                  _paymentForInternet = "Subscription";
                  _paymentMode = "Cash";
                  _paymentForOthers = null;
                  _internetPlans = null;
                  _generateInternetInvoice = true;
                  _addInternetPayment = false;
                  _setTextField();
                  Navigator.pop(context);
                  paymentView(context, paymentData, true);
                });
              } else {
                addPaymentKey.currentState.showSnackBar(new SnackBar(
                  backgroundColor: Colors.redAccent[400],
                  content: new Text("Something went wrong !!"),
                ));

                addPaymentKey.currentState.showSnackBar(new SnackBar(
                  backgroundColor: Colors.redAccent[400],
                  content: new Text("No Internet Connection !!"),
                ));
                // setState(() {
                //   if (payment.paymentFor == "Subscription") {
                //     _offlineSubscriptionPayments.add(payment);
                //     _currentPayment = _offlineSubscriptionPayments.length - 1;
                //     _offlineSubscriptionPayments[_currentPayment].createdAt =
                //         DateTime.now().toLocal().toString();
                //     _offlineSubscriptionPayments[_currentPayment].invoiceId =
                //         "Offline";
                //     _offlineSubscriptionPayments[_currentPayment].customerData =
                //         widget.customer;
                //     if (widget.customer.cable.boxDetails != null &&
                //         widget.customer.cable.boxDetails.isNotEmpty) {
                //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
                //           widget.customer.cable.boxDetails;
                //     }
                //     _offlineSubscriptionPayments[_currentPayment].created = [];
                //     _offlineSubscriptionPayments[_currentPayment].created.add(
                //           PurpleCreated(
                //             id: "",
                //             name: user.fullName,
                //             phoneNumber: "",
                //             emailId: "",
                //             userName: user.userName,
                //             password: "",
                //             userType: user.userType,
                //             activeStatus: true,
                //           ),
                //         );
                //     for (var i = 0; i < _customerList.length; i++) {
                //       if (_customerList[i].id == widget.customer.id) {
                //         _customerList[i].cable.cableOutstandingAmount =
                //             (double.tryParse(_customerList[i]
                //                         .cable
                //                         .cableOutstandingAmount) -
                //                     double.tryParse(payment.amountPaid))
                //                 .round()
                //                 .toString();
                //         _offlineSubscriptionPayments[_currentPayment]
                //                 .outstanding =
                //             _customerList[i].cable.cableOutstandingAmount;
                //       }
                //     }
                //     for (var i = 0; i < _billingList.length; i++) {
                //       if (_billingList[i].customerId == widget.customer.id) {
                //         if (double.tryParse(
                //                 _billingList[i].outstandingAmount) <=
                //             double.tryParse(payment.amountPaid)) {
                //           _billingList[i].paidStatus = "Fully Paid";
                //         } else {
                //           _billingList[i].paidStatus = "Partial Paid";
                //         }
                //         _billingList[i].outstandingAmount =
                //             _offlineSubscriptionPayments[_currentPayment]
                //                 .outstanding;
                //         _billingList[i]
                //                 .customerData
                //                 .cable
                //                 .cableOutstandingAmount =
                //             _offlineSubscriptionPayments[_currentPayment]
                //                 .outstanding;
                //       }
                //     }
                //     _paymentList
                //         .add(_offlineSubscriptionPayments[_currentPayment]);
                //     AppSharedPreferences.setOfflineSubscriptionPayments(
                //         _offlineSubscriptionPayments);
                //     AppSharedPreferences.setCustomers(_customerList);
                //     AppSharedPreferences.setBillings(_billingList);
                //     AppSharedPreferences.setPayments(_paymentList);
                //   }
                //   if (payment.paymentFor == "Installation") {
                //     _offlineInstallationPayments.add(payment);
                //     _currentPayment = _offlineInstallationPayments.length - 1;
                //     _offlineInstallationPayments[_currentPayment].createdAt =
                //         DateTime.now().toLocal().toString();
                //     _offlineInstallationPayments[_currentPayment].invoiceId =
                //         "Offline";
                //     _offlineInstallationPayments[_currentPayment].customerData =
                //         widget.customer;
                //     if (widget.customer.cable.boxDetails != null &&
                //         widget.customer.cable.boxDetails.isNotEmpty) {
                //       _offlineInstallationPayments[_currentPayment].boxDetails =
                //           widget.customer.cable.boxDetails;
                //     }
                //     _offlineInstallationPayments[_currentPayment].created = [];
                //     _offlineInstallationPayments[_currentPayment].created.add(
                //           PurpleCreated(
                //             id: "",
                //             name: user.fullName,
                //             phoneNumber: "",
                //             emailId: "",
                //             userName: user.userName,
                //             password: "",
                //             userType: user.userType,
                //             activeStatus: true,
                //           ),
                //         );
                //     for (var i = 0; i < _customerList.length; i++) {
                //       if (_customerList[i].id == widget.customer.id) {
                //         _customerList[i].cable.cableAdvanceAmountPaid =
                //             (double.tryParse(_customerList[i]
                //                         .cable
                //                         .cableAdvanceAmountPaid) +
                //                     double.tryParse(payment.amountPaid))
                //                 .round()
                //                 .toString();
                //         _offlineInstallationPayments[_currentPayment]
                //             .outstanding = (double.tryParse(
                //                     _customerList[i].cable.cableAdvanceAmount) -
                //                 double.tryParse(_customerList[i]
                //                     .cable
                //                     .cableAdvanceAmountPaid))
                //             .round()
                //             .toString();
                //       }
                //     }
                //     _paymentList
                //         .add(_offlineInstallationPayments[_currentPayment]);
                //     AppSharedPreferences.setOfflineSubscriptionPayments(
                //         _offlineInstallationPayments);
                //     AppSharedPreferences.setCustomers(_customerList);
                //     AppSharedPreferences.setBillings(_billingList);
                //     AppSharedPreferences.setPayments(_paymentList);
                //   }
                //   if (payment.serviceType == "others") {
                //     _offlineOthersPayments.add(payment);
                //     _currentPayment = _offlineOthersPayments.length - 1;
                //     _offlineOthersPayments[_currentPayment].createdAt =
                //         DateTime.now().toLocal().toString();
                //     _offlineOthersPayments[_currentPayment].invoiceId =
                //         "Offline";
                //     _offlineOthersPayments[_currentPayment].customerData =
                //         widget.customer;
                //     if (widget.customer.cable.boxDetails != null &&
                //         widget.customer.cable.boxDetails.isNotEmpty) {
                //       _offlineOthersPayments[_currentPayment].boxDetails =
                //           widget.customer.cable.boxDetails;
                //     }
                //     _offlineOthersPayments[_currentPayment].created = [];
                //     _offlineOthersPayments[_currentPayment].created.add(
                //           PurpleCreated(
                //             id: "",
                //             name: user.fullName,
                //             phoneNumber: "",
                //             emailId: "",
                //             userName: user.userName,
                //             password: "",
                //             userType: user.userType,
                //             activeStatus: true,
                //           ),
                //         );
                //     _paymentList.add(_offlineOthersPayments[_currentPayment]);
                //     AppSharedPreferences.setOfflineSubscriptionPayments(
                //         _offlineOthersPayments);
                //     AppSharedPreferences.setCustomers(_customerList);
                //     AppSharedPreferences.setBillings(_billingList);
                //     AppSharedPreferences.setPayments(_paymentList);
                //   }
                // });
                // addPaymentKey.currentState.showSnackBar(new SnackBar(
                //   backgroundColor: Colors.blue,
                //   content: new Text("Offline Payment Added Successfully !!"),
                // ));
                // setState(() {
                //   _isAdding = false;
                //   _serviceType = "cable";
                //   _paymentForCable = "Subscription";
                //   _paymentForInternet = "Subscription";
                //   _paymentMode = "Cash";
                //   _paymentForOthers = null;
                //   _internetPlans = null;
                //   _generateInternetInvoice = true;
                //   _addInternetPayment = false;
                //   _setTextField();
                //   Navigator.pop(context);
                //   if (payment.paymentFor == "Subscription") {
                //     paymentView(context,
                //         _offlineSubscriptionPayments[_currentPayment], true);
                //   }
                //   if (payment.paymentFor == "Installation") {
                //     paymentView(context,
                //         _offlineInstallationPayments[_currentPayment], true);
                //   }
                //   if (payment.serviceType == "others") {
                //     paymentView(
                //         context, _offlineOthersPayments[_currentPayment], true);
                //   }
                // });

                setState(() => _isAdding = false);
              }
            }).catchError((error) {
              print('error : $error');

              addPaymentKey.currentState.showSnackBar(new SnackBar(
                backgroundColor: Colors.redAccent[400],
                content: new Text("No Internet Connection !!"),
              ));
              // setState(() {
              //   if (payment.paymentFor == "Subscription") {
              //     _offlineSubscriptionPayments.add(payment);
              //     _currentPayment = _offlineSubscriptionPayments.length - 1;
              //     _offlineSubscriptionPayments[_currentPayment].createdAt =
              //         DateTime.now().toLocal().toString();
              //     _offlineSubscriptionPayments[_currentPayment].invoiceId =
              //         "Offline";
              //     _offlineSubscriptionPayments[_currentPayment].customerData =
              //         widget.customer;
              //     if (widget.customer.cable.boxDetails != null &&
              //         widget.customer.cable.boxDetails.isNotEmpty) {
              //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
              //           widget.customer.cable.boxDetails;
              //     }
              //     _offlineSubscriptionPayments[_currentPayment].created = [];
              //     _offlineSubscriptionPayments[_currentPayment].created.add(
              //           PurpleCreated(
              //             id: "",
              //             name: user.fullName,
              //             phoneNumber: "",
              //             emailId: "",
              //             userName: user.userName,
              //             password: "",
              //             userType: user.userType,
              //             activeStatus: true,
              //           ),
              //         );
              //     for (var i = 0; i < _customerList.length; i++) {
              //       if (_customerList[i].id == widget.customer.id) {
              //         _customerList[i].cable.cableOutstandingAmount =
              //             (double.tryParse(_customerList[i]
              //                         .cable
              //                         .cableOutstandingAmount) -
              //                     double.tryParse(payment.amountPaid))
              //                 .round()
              //                 .toString();
              //         _offlineSubscriptionPayments[_currentPayment]
              //                 .outstanding =
              //             _customerList[i].cable.cableOutstandingAmount;
              //       }
              //     }
              //     for (var i = 0; i < _billingList.length; i++) {
              //       if (_billingList[i].customerId == widget.customer.id) {
              //         if (double.tryParse(_billingList[i].outstandingAmount) <=
              //             double.tryParse(payment.amountPaid)) {
              //           _billingList[i].paidStatus = "Fully Paid";
              //         } else {
              //           _billingList[i].paidStatus = "Partial Paid";
              //         }
              //         _billingList[i].outstandingAmount =
              //             _offlineSubscriptionPayments[_currentPayment]
              //                 .outstanding;
              //         _billingList[i]
              //                 .customerData
              //                 .cable
              //                 .cableOutstandingAmount =
              //             _offlineSubscriptionPayments[_currentPayment]
              //                 .outstanding;
              //       }
              //     }
              //     _paymentList
              //         .add(_offlineSubscriptionPayments[_currentPayment]);
              //     AppSharedPreferences.setOfflineSubscriptionPayments(
              //         _offlineSubscriptionPayments);
              //     AppSharedPreferences.setCustomers(_customerList);
              //     AppSharedPreferences.setBillings(_billingList);
              //     AppSharedPreferences.setPayments(_paymentList);
              //   }
              //   if (payment.paymentFor == "Installation") {
              //     _offlineInstallationPayments.add(payment);
              //     _currentPayment = _offlineInstallationPayments.length - 1;
              //     _offlineInstallationPayments[_currentPayment].createdAt =
              //         DateTime.now().toLocal().toString();
              //     _offlineInstallationPayments[_currentPayment].invoiceId =
              //         "Offline";
              //     _offlineInstallationPayments[_currentPayment].customerData =
              //         widget.customer;
              //     if (widget.customer.cable.boxDetails != null &&
              //         widget.customer.cable.boxDetails.isNotEmpty) {
              //       _offlineInstallationPayments[_currentPayment].boxDetails =
              //           widget.customer.cable.boxDetails;
              //     }
              //     _offlineInstallationPayments[_currentPayment].created = [];
              //     _offlineInstallationPayments[_currentPayment].created.add(
              //           PurpleCreated(
              //             id: "",
              //             name: user.fullName,
              //             phoneNumber: "",
              //             emailId: "",
              //             userName: user.userName,
              //             password: "",
              //             userType: user.userType,
              //             activeStatus: true,
              //           ),
              //         );
              //     for (var i = 0; i < _customerList.length; i++) {
              //       if (_customerList[i].id == widget.customer.id) {
              //         _customerList[i].cable.cableAdvanceAmountPaid =
              //             (double.tryParse(_customerList[i]
              //                         .cable
              //                         .cableAdvanceAmountPaid) +
              //                     double.tryParse(payment.amountPaid))
              //                 .round()
              //                 .toString();
              //         _offlineInstallationPayments[_currentPayment]
              //             .outstanding = (double.tryParse(
              //                     _customerList[i].cable.cableAdvanceAmount) -
              //                 double.tryParse(_customerList[i]
              //                     .cable
              //                     .cableAdvanceAmountPaid))
              //             .round()
              //             .toString();
              //       }
              //     }
              //     _paymentList
              //         .add(_offlineInstallationPayments[_currentPayment]);
              //     AppSharedPreferences.setOfflineSubscriptionPayments(
              //         _offlineInstallationPayments);
              //     AppSharedPreferences.setCustomers(_customerList);
              //     AppSharedPreferences.setBillings(_billingList);
              //     AppSharedPreferences.setPayments(_paymentList);
              //   }
              //   if (payment.serviceType == "others") {
              //     _offlineOthersPayments.add(payment);
              //     _currentPayment = _offlineOthersPayments.length - 1;
              //     _offlineOthersPayments[_currentPayment].createdAt =
              //         DateTime.now().toLocal().toString();
              //     _offlineOthersPayments[_currentPayment].invoiceId = "Offline";
              //     _offlineOthersPayments[_currentPayment].customerData =
              //         widget.customer;
              //     if (widget.customer.cable.boxDetails != null &&
              //         widget.customer.cable.boxDetails.isNotEmpty) {
              //       _offlineOthersPayments[_currentPayment].boxDetails =
              //           widget.customer.cable.boxDetails;
              //     }
              //     _offlineOthersPayments[_currentPayment].created = [];
              //     _offlineOthersPayments[_currentPayment].created.add(
              //           PurpleCreated(
              //             id: "",
              //             name: user.fullName,
              //             phoneNumber: "",
              //             emailId: "",
              //             userName: user.userName,
              //             password: "",
              //             userType: user.userType,
              //             activeStatus: true,
              //           ),
              //         );
              //     _paymentList.add(_offlineOthersPayments[_currentPayment]);
              //     AppSharedPreferences.setOfflineSubscriptionPayments(
              //         _offlineOthersPayments);
              //     AppSharedPreferences.setCustomers(_customerList);
              //     AppSharedPreferences.setBillings(_billingList);
              //     AppSharedPreferences.setPayments(_paymentList);
              //   }
              // });
              // addPaymentKey.currentState.showSnackBar(new SnackBar(
              //   backgroundColor: Colors.blue,
              //   content: new Text("Offline Payment Added Successfully !!"),
              // ));
              // setState(() {
              //   _isAdding = false;
              //   _serviceType = "cable";
              //   _paymentForCable = "Subscription";
              //   _paymentForInternet = "Subscription";
              //   _paymentMode = "Cash";
              //   _paymentForOthers = null;
              //   _internetPlans = null;
              //   _generateInternetInvoice = true;
              //   _addInternetPayment = false;
              //   _setTextField();
              //   Navigator.pop(context);
              //   if (payment.paymentFor == "Subscription") {
              //     paymentView(context,
              //         _offlineSubscriptionPayments[_currentPayment], true);
              //   }
              //   if (payment.paymentFor == "Installation") {
              //     paymentView(context,
              //         _offlineInstallationPayments[_currentPayment], true);
              //   }
              //   if (payment.serviceType == "others") {
              //     paymentView(
              //         context, _offlineOthersPayments[_currentPayment], true);
              //   }
              // });
            });
          }
        }
        if (_serviceType == "internet") {
          if (_generateInternetInvoice == true) {
            saveInternetBilling(internetBillings).then((response) {
              if (_recordPayment == true) {
                paymentData =
                    paymentFromJson(Utf8Codec().decode(response.bodyBytes));
              }
              // else {
              //   billingData =
              //       billingsFromJson(Utf8Codec().decode(response.bodyBytes));
              // }

              if (response.statusCode == 201) {
                if (_recordPayment == true) {
                  addPaymentKey.currentState.showSnackBar(new SnackBar(
                    backgroundColor: Colors.green,
                    content: new Text("Payment Added Successfully!!"),
                  ));
                  paymentData.customerData = widget.customer;
                } else {
                  addPaymentKey.currentState.showSnackBar(new SnackBar(
                    backgroundColor: Colors.green,
                    content: new Text("Invoice Generated Successfully!!"),
                  ));
                  // billingData.customerData = customer;
                }

                setState(() {
                  _isAdding = false;
                  // _searchCustomer.text = "";

                  // barcode = "";
                  // pay = false;

                  _serviceType = "cable";
                  _paymentForCable = "Subscription";
                  _paymentForInternet = "Subscription";
                  _paymentMode = "Cash";
                  _paymentForOthers = null;
                  _internetPlans = null;
                  _generateInternetInvoice = true;
                  _addInternetPayment = false;
                  _setTextField();
                  Navigator.pop(context);
                  if (_recordPayment == true) {
                    paymentView(context, paymentData, true);
                  }
                  // else {
                  //   billingView(context, billingData);
                  // }
                });
              } else {
                addPaymentKey.currentState.showSnackBar(new SnackBar(
                  backgroundColor: Colors.redAccent[400],
                  content: new Text("Something went wrong !!"),
                ));
                setState(() => _isAdding = false);
              }
            }).catchError((error) {
              print('error : $error');
            });
          }
          if (_addInternetPayment == true) {
            if (_paymentForInternet == "Subscription") {
              saveSubscriptionPayment(payment).then((response) {
                paymentData =
                    paymentFromJson(Utf8Codec().decode(response.bodyBytes));
                if (response.statusCode == 201) {
                  addPaymentKey.currentState.showSnackBar(new SnackBar(
                    backgroundColor: Colors.green,
                    content: new Text("Payment Added Successfully!!"),
                  ));
                  paymentData.customerData = widget.customer;
                  setState(() {
                    _isAdding = false;
                    // _searchCustomer.text = "";

                    // barcode = "";
                    // pay = false;

                    _serviceType = "cable";
                    _paymentForCable = "Subscription";
                    _paymentForInternet = "Subscription";
                    _paymentMode = "Cash";
                    _paymentForOthers = null;
                    _internetPlans = null;
                    _generateInternetInvoice = true;
                    _addInternetPayment = false;
                    _setTextField();
                    Navigator.pop(context);
                    paymentView(context, paymentData, true);
                  });
                } else {
                  addPaymentKey.currentState.showSnackBar(new SnackBar(
                    backgroundColor: Colors.redAccent[400],
                    content: new Text("Something went wrong !!"),
                  ));

                  addPaymentKey.currentState.showSnackBar(new SnackBar(
                    backgroundColor: Colors.redAccent[400],
                    content: new Text("No Internet Connection !!"),
                  ));
                  // setState(() {
                  //   if (payment.paymentFor == "Subscription") {
                  //     _offlineSubscriptionPayments.add(payment);
                  //     _currentPayment = _offlineSubscriptionPayments.length - 1;
                  //     _offlineSubscriptionPayments[_currentPayment].createdAt =
                  //         DateTime.now().toLocal().toString();
                  //     _offlineSubscriptionPayments[_currentPayment].invoiceId =
                  //         "Offline";
                  //     _offlineSubscriptionPayments[_currentPayment]
                  //         .customerData = widget.customer;
                  //     if (widget.customer.cable.boxDetails != null &&
                  //         widget.customer.cable.boxDetails.isNotEmpty) {
                  //       _offlineSubscriptionPayments[_currentPayment]
                  //           .boxDetails = widget.customer.cable.boxDetails;
                  //     }
                  //     _offlineSubscriptionPayments[_currentPayment].created =
                  //         [];
                  //     _offlineSubscriptionPayments[_currentPayment].created.add(
                  //           PurpleCreated(
                  //             id: "",
                  //             name: user.fullName,
                  //             phoneNumber: "",
                  //             emailId: "",
                  //             userName: user.userName,
                  //             password: "",
                  //             userType: user.userType,
                  //             activeStatus: true,
                  //           ),
                  //         );
                  //     for (var i = 0; i < _customerList.length; i++) {
                  //       if (_customerList[i].id == widget.customer.id) {
                  //         _customerList[i].cable.cableOutstandingAmount =
                  //             (double.tryParse(_customerList[i]
                  //                         .cable
                  //                         .cableOutstandingAmount) -
                  //                     double.tryParse(payment.amountPaid))
                  //                 .round()
                  //                 .toString();
                  //         _offlineSubscriptionPayments[_currentPayment]
                  //                 .outstanding =
                  //             _customerList[i].cable.cableOutstandingAmount;
                  //       }
                  //     }
                  //     for (var i = 0; i < _billingList.length; i++) {
                  //       if (_billingList[i].customerId == widget.customer.id) {
                  //         if (double.tryParse(
                  //                 _billingList[i].outstandingAmount) <=
                  //             double.tryParse(payment.amountPaid)) {
                  //           _billingList[i].paidStatus = "Fully Paid";
                  //         } else {
                  //           _billingList[i].paidStatus = "Partial Paid";
                  //         }
                  //         _billingList[i].outstandingAmount =
                  //             _offlineSubscriptionPayments[_currentPayment]
                  //                 .outstanding;
                  //         _billingList[i]
                  //                 .customerData
                  //                 .cable
                  //                 .cableOutstandingAmount =
                  //             _offlineSubscriptionPayments[_currentPayment]
                  //                 .outstanding;
                  //       }
                  //     }
                  //     _paymentList
                  //         .add(_offlineSubscriptionPayments[_currentPayment]);
                  //     AppSharedPreferences.setOfflineSubscriptionPayments(
                  //         _offlineSubscriptionPayments);
                  //     AppSharedPreferences.setCustomers(_customerList);
                  //     AppSharedPreferences.setBillings(_billingList);
                  //     AppSharedPreferences.setPayments(_paymentList);
                  //   }
                  //   if (payment.paymentFor == "Installation") {
                  //     _offlineInstallationPayments.add(payment);
                  //     _currentPayment = _offlineInstallationPayments.length - 1;
                  //     _offlineInstallationPayments[_currentPayment].createdAt =
                  //         DateTime.now().toLocal().toString();
                  //     _offlineInstallationPayments[_currentPayment].invoiceId =
                  //         "Offline";
                  //     _offlineInstallationPayments[_currentPayment]
                  //         .customerData = widget.customer;
                  //     if (widget.customer.cable.boxDetails != null &&
                  //         widget.customer.cable.boxDetails.isNotEmpty) {
                  //       _offlineInstallationPayments[_currentPayment]
                  //           .boxDetails = widget.customer.cable.boxDetails;
                  //     }
                  //     _offlineInstallationPayments[_currentPayment].created =
                  //         [];
                  //     _offlineInstallationPayments[_currentPayment].created.add(
                  //           PurpleCreated(
                  //             id: "",
                  //             name: user.fullName,
                  //             phoneNumber: "",
                  //             emailId: "",
                  //             userName: user.userName,
                  //             password: "",
                  //             userType: user.userType,
                  //             activeStatus: true,
                  //           ),
                  //         );
                  //     for (var i = 0; i < _customerList.length; i++) {
                  //       if (_customerList[i].id == widget.customer.id) {
                  //         _customerList[i].cable.cableAdvanceAmountPaid =
                  //             (double.tryParse(_customerList[i]
                  //                         .cable
                  //                         .cableAdvanceAmountPaid) +
                  //                     double.tryParse(payment.amountPaid))
                  //                 .round()
                  //                 .toString();
                  //         _offlineInstallationPayments[_currentPayment]
                  //             .outstanding = (double.tryParse(_customerList[i]
                  //                     .cable
                  //                     .cableAdvanceAmount) -
                  //                 double.tryParse(_customerList[i]
                  //                     .cable
                  //                     .cableAdvanceAmountPaid))
                  //             .round()
                  //             .toString();
                  //       }
                  //     }
                  //     _paymentList
                  //         .add(_offlineInstallationPayments[_currentPayment]);
                  //     AppSharedPreferences.setOfflineSubscriptionPayments(
                  //         _offlineInstallationPayments);
                  //     AppSharedPreferences.setCustomers(_customerList);
                  //     AppSharedPreferences.setBillings(_billingList);
                  //     AppSharedPreferences.setPayments(_paymentList);
                  //   }
                  //   if (payment.serviceType == "others") {
                  //     _offlineOthersPayments.add(payment);
                  //     _currentPayment = _offlineOthersPayments.length - 1;
                  //     _offlineOthersPayments[_currentPayment].createdAt =
                  //         DateTime.now().toLocal().toString();
                  //     _offlineOthersPayments[_currentPayment].invoiceId =
                  //         "Offline";
                  //     _offlineOthersPayments[_currentPayment].customerData =
                  //         widget.customer;
                  //     if (widget.customer.cable.boxDetails != null &&
                  //         widget.customer.cable.boxDetails.isNotEmpty) {
                  //       _offlineOthersPayments[_currentPayment].boxDetails =
                  //           widget.customer.cable.boxDetails;
                  //     }
                  //     _offlineOthersPayments[_currentPayment].created = [];
                  //     _offlineOthersPayments[_currentPayment].created.add(
                  //           PurpleCreated(
                  //             id: "",
                  //             name: user.fullName,
                  //             phoneNumber: "",
                  //             emailId: "",
                  //             userName: user.userName,
                  //             password: "",
                  //             userType: user.userType,
                  //             activeStatus: true,
                  //           ),
                  //         );
                  //     _paymentList.add(_offlineOthersPayments[_currentPayment]);
                  //     AppSharedPreferences.setOfflineSubscriptionPayments(
                  //         _offlineOthersPayments);
                  //     AppSharedPreferences.setCustomers(_customerList);
                  //     AppSharedPreferences.setBillings(_billingList);
                  //     AppSharedPreferences.setPayments(_paymentList);
                  //   }
                  // });
                  // addPaymentKey.currentState.showSnackBar(new SnackBar(
                  //   backgroundColor: Colors.blue,
                  //   content: new Text("Offline Payment Added Successfully !!"),
                  // ));
                  // setState(() {
                  //   _isAdding = false;
                  //   _serviceType = "cable";
                  //   _paymentForCable = "Subscription";
                  //   _paymentForInternet = "Subscription";
                  //   _paymentMode = "Cash";
                  //   _paymentForOthers = null;
                  //   _internetPlans = null;
                  //   _generateInternetInvoice = true;
                  //   _addInternetPayment = false;
                  //   _setTextField();
                  //   Navigator.pop(context);
                  //   if (payment.paymentFor == "Subscription") {
                  //     paymentView(context,
                  //         _offlineSubscriptionPayments[_currentPayment], true);
                  //   }
                  //   if (payment.paymentFor == "Installation") {
                  //     paymentView(context,
                  //         _offlineInstallationPayments[_currentPayment], true);
                  //   }
                  //   if (payment.serviceType == "others") {
                  //     paymentView(context,
                  //         _offlineOthersPayments[_currentPayment], true);
                  //   }
                  // });

                  setState(() => _isAdding = false);
                }
              }).catchError((error) {
                print('error : $error');

                addPaymentKey.currentState.showSnackBar(new SnackBar(
                  backgroundColor: Colors.redAccent[400],
                  content: new Text("No Internet Connection !!"),
                ));
                // setState(() {
                //   if (payment.paymentFor == "Subscription") {
                //     _offlineSubscriptionPayments.add(payment);
                //     _currentPayment = _offlineSubscriptionPayments.length - 1;
                //     _offlineSubscriptionPayments[_currentPayment].createdAt =
                //         DateTime.now().toLocal().toString();
                //     _offlineSubscriptionPayments[_currentPayment].invoiceId =
                //         "Offline";
                //     _offlineSubscriptionPayments[_currentPayment].customerData =
                //         widget.customer;
                //     if (widget.customer.cable.boxDetails != null &&
                //         widget.customer.cable.boxDetails.isNotEmpty) {
                //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
                //           widget.customer.cable.boxDetails;
                //     }
                //     _offlineSubscriptionPayments[_currentPayment].created = [];
                //     _offlineSubscriptionPayments[_currentPayment].created.add(
                //           PurpleCreated(
                //             id: "",
                //             name: user.fullName,
                //             phoneNumber: "",
                //             emailId: "",
                //             userName: user.userName,
                //             password: "",
                //             userType: user.userType,
                //             activeStatus: true,
                //           ),
                //         );
                //     for (var i = 0; i < _customerList.length; i++) {
                //       if (_customerList[i].id == widget.customer.id) {
                //         _customerList[i].cable.cableOutstandingAmount =
                //             (double.tryParse(_customerList[i]
                //                         .cable
                //                         .cableOutstandingAmount) -
                //                     double.tryParse(payment.amountPaid))
                //                 .round()
                //                 .toString();
                //         _offlineSubscriptionPayments[_currentPayment]
                //                 .outstanding =
                //             _customerList[i].cable.cableOutstandingAmount;
                //       }
                //     }
                //     for (var i = 0; i < _billingList.length; i++) {
                //       if (_billingList[i].customerId == widget.customer.id) {
                //         if (double.tryParse(
                //                 _billingList[i].outstandingAmount) <=
                //             double.tryParse(payment.amountPaid)) {
                //           _billingList[i].paidStatus = "Fully Paid";
                //         } else {
                //           _billingList[i].paidStatus = "Partial Paid";
                //         }
                //         _billingList[i].outstandingAmount =
                //             _offlineSubscriptionPayments[_currentPayment]
                //                 .outstanding;
                //         _billingList[i]
                //                 .customerData
                //                 .cable
                //                 .cableOutstandingAmount =
                //             _offlineSubscriptionPayments[_currentPayment]
                //                 .outstanding;
                //       }
                //     }
                //     _paymentList
                //         .add(_offlineSubscriptionPayments[_currentPayment]);
                //     AppSharedPreferences.setOfflineSubscriptionPayments(
                //         _offlineSubscriptionPayments);
                //     AppSharedPreferences.setCustomers(_customerList);
                //     AppSharedPreferences.setBillings(_billingList);
                //     AppSharedPreferences.setPayments(_paymentList);
                //   }
                //   if (payment.paymentFor == "Installation") {
                //     _offlineInstallationPayments.add(payment);
                //     _currentPayment = _offlineInstallationPayments.length - 1;
                //     _offlineInstallationPayments[_currentPayment].createdAt =
                //         DateTime.now().toLocal().toString();
                //     _offlineInstallationPayments[_currentPayment].invoiceId =
                //         "Offline";
                //     _offlineInstallationPayments[_currentPayment].customerData =
                //         widget.customer;
                //     if (widget.customer.cable.boxDetails != null &&
                //         widget.customer.cable.boxDetails.isNotEmpty) {
                //       _offlineInstallationPayments[_currentPayment].boxDetails =
                //           widget.customer.cable.boxDetails;
                //     }
                //     _offlineInstallationPayments[_currentPayment].created = [];
                //     _offlineInstallationPayments[_currentPayment].created.add(
                //           PurpleCreated(
                //             id: "",
                //             name: user.fullName,
                //             phoneNumber: "",
                //             emailId: "",
                //             userName: user.userName,
                //             password: "",
                //             userType: user.userType,
                //             activeStatus: true,
                //           ),
                //         );
                //     for (var i = 0; i < _customerList.length; i++) {
                //       if (_customerList[i].id == widget.customer.id) {
                //         _customerList[i].cable.cableAdvanceAmountPaid =
                //             (double.tryParse(_customerList[i]
                //                         .cable
                //                         .cableAdvanceAmountPaid) +
                //                     double.tryParse(payment.amountPaid))
                //                 .round()
                //                 .toString();
                //         _offlineInstallationPayments[_currentPayment]
                //             .outstanding = (double.tryParse(
                //                     _customerList[i].cable.cableAdvanceAmount) -
                //                 double.tryParse(_customerList[i]
                //                     .cable
                //                     .cableAdvanceAmountPaid))
                //             .round()
                //             .toString();
                //       }
                //     }
                //     _paymentList
                //         .add(_offlineInstallationPayments[_currentPayment]);
                //     AppSharedPreferences.setOfflineSubscriptionPayments(
                //         _offlineInstallationPayments);
                //     AppSharedPreferences.setCustomers(_customerList);
                //     AppSharedPreferences.setBillings(_billingList);
                //     AppSharedPreferences.setPayments(_paymentList);
                //   }
                //   if (payment.serviceType == "others") {
                //     _offlineOthersPayments.add(payment);
                //     _currentPayment = _offlineOthersPayments.length - 1;
                //     _offlineOthersPayments[_currentPayment].createdAt =
                //         DateTime.now().toLocal().toString();
                //     _offlineOthersPayments[_currentPayment].invoiceId =
                //         "Offline";
                //     _offlineOthersPayments[_currentPayment].customerData =
                //         widget.customer;
                //     if (widget.customer.cable.boxDetails != null &&
                //         widget.customer.cable.boxDetails.isNotEmpty) {
                //       _offlineOthersPayments[_currentPayment].boxDetails =
                //           widget.customer.cable.boxDetails;
                //     }
                //     _offlineOthersPayments[_currentPayment].created = [];
                //     _offlineOthersPayments[_currentPayment].created.add(
                //           PurpleCreated(
                //             id: "",
                //             name: user.fullName,
                //             phoneNumber: "",
                //             emailId: "",
                //             userName: user.userName,
                //             password: "",
                //             userType: user.userType,
                //             activeStatus: true,
                //           ),
                //         );
                //     _paymentList.add(_offlineOthersPayments[_currentPayment]);
                //     AppSharedPreferences.setOfflineSubscriptionPayments(
                //         _offlineOthersPayments);
                //     AppSharedPreferences.setCustomers(_customerList);
                //     AppSharedPreferences.setBillings(_billingList);
                //     AppSharedPreferences.setPayments(_paymentList);
                //   }
                // });
                // addPaymentKey.currentState.showSnackBar(new SnackBar(
                //   backgroundColor: Colors.blue,
                //   content: new Text("Offline Payment Added Successfully !!"),
                // ));
                // setState(() {
                //   _isAdding = false;
                //   _serviceType = "cable";
                //   _paymentForCable = "Subscription";
                //   _paymentForInternet = "Subscription";
                //   _paymentMode = "Cash";
                //   _paymentForOthers = null;
                //   _internetPlans = null;
                //   _generateInternetInvoice = true;
                //   _addInternetPayment = false;
                //   _setTextField();
                //   Navigator.pop(context);
                //   if (payment.paymentFor == "Subscription") {
                //     paymentView(context,
                //         _offlineSubscriptionPayments[_currentPayment], true);
                //   }
                //   if (payment.paymentFor == "Installation") {
                //     paymentView(context,
                //         _offlineInstallationPayments[_currentPayment], true);
                //   }
                //   if (payment.serviceType == "others") {
                //     paymentView(
                //         context, _offlineOthersPayments[_currentPayment], true);
                //   }
                // });
              });
            }
            if (_paymentForInternet == "Installation") {
              saveInstallationPayment(payment).then((response) {
                paymentData =
                    paymentFromJson(Utf8Codec().decode(response.bodyBytes));
                if (response.statusCode == 201) {
                  addPaymentKey.currentState.showSnackBar(new SnackBar(
                    backgroundColor: Colors.green,
                    content: new Text("Payment Added Successfully!!"),
                  ));
                  paymentData.customerData = widget.customer;
                  setState(() {
                    _isAdding = false;
                    // _searchCustomer.text = "";

                    // barcode = "";
                    // pay = false;

                    _serviceType = "cable";
                    _paymentForCable = "Subscription";
                    _paymentForInternet = "Subscription";
                    _paymentMode = "Cash";
                    _paymentForOthers = null;
                    _internetPlans = null;
                    _generateInternetInvoice = true;
                    _addInternetPayment = false;
                    _setTextField();
                    Navigator.pop(context);
                    paymentView(context, paymentData, true);
                  });
                } else {
                  addPaymentKey.currentState.showSnackBar(new SnackBar(
                    backgroundColor: Colors.redAccent[400],
                    content: new Text("Something went wrong !!"),
                  ));

                  addPaymentKey.currentState.showSnackBar(new SnackBar(
                    backgroundColor: Colors.redAccent[400],
                    content: new Text("No Internet Connection !!"),
                  ));
                  // setState(() {
                  //   if (payment.paymentFor == "Subscription") {
                  //     _offlineSubscriptionPayments.add(payment);
                  //     _currentPayment = _offlineSubscriptionPayments.length - 1;
                  //     _offlineSubscriptionPayments[_currentPayment].createdAt =
                  //         DateTime.now().toLocal().toString();
                  //     _offlineSubscriptionPayments[_currentPayment].invoiceId =
                  //         "Offline";
                  //     _offlineSubscriptionPayments[_currentPayment]
                  //         .customerData = widget.customer;
                  //     if (widget.customer.cable.boxDetails != null &&
                  //         widget.customer.cable.boxDetails.isNotEmpty) {
                  //       _offlineSubscriptionPayments[_currentPayment]
                  //           .boxDetails = widget.customer.cable.boxDetails;
                  //     }
                  //     _offlineSubscriptionPayments[_currentPayment].created =
                  //         [];
                  //     _offlineSubscriptionPayments[_currentPayment].created.add(
                  //           PurpleCreated(
                  //             id: "",
                  //             name: user.fullName,
                  //             phoneNumber: "",
                  //             emailId: "",
                  //             userName: user.userName,
                  //             password: "",
                  //             userType: user.userType,
                  //             activeStatus: true,
                  //           ),
                  //         );
                  //     for (var i = 0; i < _customerList.length; i++) {
                  //       if (_customerList[i].id == widget.customer.id) {
                  //         _customerList[i].cable.cableOutstandingAmount =
                  //             (double.tryParse(_customerList[i]
                  //                         .cable
                  //                         .cableOutstandingAmount) -
                  //                     double.tryParse(payment.amountPaid))
                  //                 .round()
                  //                 .toString();
                  //         _offlineSubscriptionPayments[_currentPayment]
                  //                 .outstanding =
                  //             _customerList[i].cable.cableOutstandingAmount;
                  //       }
                  //     }
                  //     for (var i = 0; i < _billingList.length; i++) {
                  //       if (_billingList[i].customerId == widget.customer.id) {
                  //         if (double.tryParse(
                  //                 _billingList[i].outstandingAmount) <=
                  //             double.tryParse(payment.amountPaid)) {
                  //           _billingList[i].paidStatus = "Fully Paid";
                  //         } else {
                  //           _billingList[i].paidStatus = "Partial Paid";
                  //         }
                  //         _billingList[i].outstandingAmount =
                  //             _offlineSubscriptionPayments[_currentPayment]
                  //                 .outstanding;
                  //         _billingList[i]
                  //                 .customerData
                  //                 .cable
                  //                 .cableOutstandingAmount =
                  //             _offlineSubscriptionPayments[_currentPayment]
                  //                 .outstanding;
                  //       }
                  //     }
                  //     _paymentList
                  //         .add(_offlineSubscriptionPayments[_currentPayment]);
                  //     AppSharedPreferences.setOfflineSubscriptionPayments(
                  //         _offlineSubscriptionPayments);
                  //     AppSharedPreferences.setCustomers(_customerList);
                  //     AppSharedPreferences.setBillings(_billingList);
                  //     AppSharedPreferences.setPayments(_paymentList);
                  //   }
                  //   if (payment.paymentFor == "Installation") {
                  //     _offlineInstallationPayments.add(payment);
                  //     _currentPayment = _offlineInstallationPayments.length - 1;
                  //     _offlineInstallationPayments[_currentPayment].createdAt =
                  //         DateTime.now().toLocal().toString();
                  //     _offlineInstallationPayments[_currentPayment].invoiceId =
                  //         "Offline";
                  //     _offlineInstallationPayments[_currentPayment]
                  //         .customerData = widget.customer;
                  //     if (widget.customer.cable.boxDetails != null &&
                  //         widget.customer.cable.boxDetails.isNotEmpty) {
                  //       _offlineInstallationPayments[_currentPayment]
                  //           .boxDetails = widget.customer.cable.boxDetails;
                  //     }
                  //     _offlineInstallationPayments[_currentPayment].created =
                  //         [];
                  //     _offlineInstallationPayments[_currentPayment].created.add(
                  //           PurpleCreated(
                  //             id: "",
                  //             name: user.fullName,
                  //             phoneNumber: "",
                  //             emailId: "",
                  //             userName: user.userName,
                  //             password: "",
                  //             userType: user.userType,
                  //             activeStatus: true,
                  //           ),
                  //         );
                  //     for (var i = 0; i < _customerList.length; i++) {
                  //       if (_customerList[i].id == widget.customer.id) {
                  //         _customerList[i].cable.cableAdvanceAmountPaid =
                  //             (double.tryParse(_customerList[i]
                  //                         .cable
                  //                         .cableAdvanceAmountPaid) +
                  //                     double.tryParse(payment.amountPaid))
                  //                 .round()
                  //                 .toString();
                  //         _offlineInstallationPayments[_currentPayment]
                  //             .outstanding = (double.tryParse(_customerList[i]
                  //                     .cable
                  //                     .cableAdvanceAmount) -
                  //                 double.tryParse(_customerList[i]
                  //                     .cable
                  //                     .cableAdvanceAmountPaid))
                  //             .round()
                  //             .toString();
                  //       }
                  //     }
                  //     _paymentList
                  //         .add(_offlineInstallationPayments[_currentPayment]);
                  //     AppSharedPreferences.setOfflineSubscriptionPayments(
                  //         _offlineInstallationPayments);
                  //     AppSharedPreferences.setCustomers(_customerList);
                  //     AppSharedPreferences.setBillings(_billingList);
                  //     AppSharedPreferences.setPayments(_paymentList);
                  //   }
                  //   if (payment.serviceType == "others") {
                  //     _offlineOthersPayments.add(payment);
                  //     _currentPayment = _offlineOthersPayments.length - 1;
                  //     _offlineOthersPayments[_currentPayment].createdAt =
                  //         DateTime.now().toLocal().toString();
                  //     _offlineOthersPayments[_currentPayment].invoiceId =
                  //         "Offline";
                  //     _offlineOthersPayments[_currentPayment].customerData =
                  //         widget.customer;
                  //     if (widget.customer.cable.boxDetails != null &&
                  //         widget.customer.cable.boxDetails.isNotEmpty) {
                  //       _offlineOthersPayments[_currentPayment].boxDetails =
                  //           widget.customer.cable.boxDetails;
                  //     }
                  //     _offlineOthersPayments[_currentPayment].created = [];
                  //     _offlineOthersPayments[_currentPayment].created.add(
                  //           PurpleCreated(
                  //             id: "",
                  //             name: user.fullName,
                  //             phoneNumber: "",
                  //             emailId: "",
                  //             userName: user.userName,
                  //             password: "",
                  //             userType: user.userType,
                  //             activeStatus: true,
                  //           ),
                  //         );
                  //     _paymentList.add(_offlineOthersPayments[_currentPayment]);
                  //     AppSharedPreferences.setOfflineSubscriptionPayments(
                  //         _offlineOthersPayments);
                  //     AppSharedPreferences.setCustomers(_customerList);
                  //     AppSharedPreferences.setBillings(_billingList);
                  //     AppSharedPreferences.setPayments(_paymentList);
                  //   }
                  // });
                  // addPaymentKey.currentState.showSnackBar(new SnackBar(
                  //   backgroundColor: Colors.blue,
                  //   content: new Text("Offline Payment Added Successfully !!"),
                  // ));
                  // setState(() {
                  //   _isAdding = false;
                  //   _serviceType = "cable";
                  //   _paymentForCable = "Subscription";
                  //   _paymentForInternet = "Subscription";
                  //   _paymentMode = "Cash";
                  //   _paymentForOthers = null;
                  //   _internetPlans = null;
                  //   _generateInternetInvoice = true;
                  //   _addInternetPayment = false;
                  //   _setTextField();
                  //   Navigator.pop(context);
                  //   if (payment.paymentFor == "Subscription") {
                  //     paymentView(context,
                  //         _offlineSubscriptionPayments[_currentPayment], true);
                  //   }
                  //   if (payment.paymentFor == "Installation") {
                  //     paymentView(context,
                  //         _offlineInstallationPayments[_currentPayment], true);
                  //   }
                  //   if (payment.serviceType == "others") {
                  //     paymentView(context,
                  //         _offlineOthersPayments[_currentPayment], true);
                  //   }
                  // });

                  setState(() => _isAdding = false);
                }
              }).catchError((error) {
                print('error : $error');

                addPaymentKey.currentState.showSnackBar(new SnackBar(
                  backgroundColor: Colors.redAccent[400],
                  content: new Text("No Internet Connection !!"),
                ));
                // setState(() {
                //   if (payment.paymentFor == "Subscription") {
                //     _offlineSubscriptionPayments.add(payment);
                //     _currentPayment = _offlineSubscriptionPayments.length - 1;
                //     _offlineSubscriptionPayments[_currentPayment].createdAt =
                //         DateTime.now().toLocal().toString();
                //     _offlineSubscriptionPayments[_currentPayment].invoiceId =
                //         "Offline";
                //     _offlineSubscriptionPayments[_currentPayment].customerData =
                //         widget.customer;
                //     if (widget.customer.cable.boxDetails != null &&
                //         widget.customer.cable.boxDetails.isNotEmpty) {
                //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
                //           widget.customer.cable.boxDetails;
                //     }
                //     _offlineSubscriptionPayments[_currentPayment].created = [];
                //     _offlineSubscriptionPayments[_currentPayment].created.add(
                //           PurpleCreated(
                //             id: "",
                //             name: user.fullName,
                //             phoneNumber: "",
                //             emailId: "",
                //             userName: user.userName,
                //             password: "",
                //             userType: user.userType,
                //             activeStatus: true,
                //           ),
                //         );
                //     for (var i = 0; i < _customerList.length; i++) {
                //       if (_customerList[i].id == widget.customer.id) {
                //         _customerList[i].cable.cableOutstandingAmount =
                //             (double.tryParse(_customerList[i]
                //                         .cable
                //                         .cableOutstandingAmount) -
                //                     double.tryParse(payment.amountPaid))
                //                 .round()
                //                 .toString();
                //         _offlineSubscriptionPayments[_currentPayment]
                //                 .outstanding =
                //             _customerList[i].cable.cableOutstandingAmount;
                //       }
                //     }
                //     for (var i = 0; i < _billingList.length; i++) {
                //       if (_billingList[i].customerId == widget.customer.id) {
                //         if (double.tryParse(
                //                 _billingList[i].outstandingAmount) <=
                //             double.tryParse(payment.amountPaid)) {
                //           _billingList[i].paidStatus = "Fully Paid";
                //         } else {
                //           _billingList[i].paidStatus = "Partial Paid";
                //         }
                //         _billingList[i].outstandingAmount =
                //             _offlineSubscriptionPayments[_currentPayment]
                //                 .outstanding;
                //         _billingList[i]
                //                 .customerData
                //                 .cable
                //                 .cableOutstandingAmount =
                //             _offlineSubscriptionPayments[_currentPayment]
                //                 .outstanding;
                //       }
                //     }
                //     _paymentList
                //         .add(_offlineSubscriptionPayments[_currentPayment]);
                //     AppSharedPreferences.setOfflineSubscriptionPayments(
                //         _offlineSubscriptionPayments);
                //     AppSharedPreferences.setCustomers(_customerList);
                //     AppSharedPreferences.setBillings(_billingList);
                //     AppSharedPreferences.setPayments(_paymentList);
                //   }
                //   if (payment.paymentFor == "Installation") {
                //     _offlineInstallationPayments.add(payment);
                //     _currentPayment = _offlineInstallationPayments.length - 1;
                //     _offlineInstallationPayments[_currentPayment].createdAt =
                //         DateTime.now().toLocal().toString();
                //     _offlineInstallationPayments[_currentPayment].invoiceId =
                //         "Offline";
                //     _offlineInstallationPayments[_currentPayment].customerData =
                //         widget.customer;
                //     if (widget.customer.cable.boxDetails != null &&
                //         widget.customer.cable.boxDetails.isNotEmpty) {
                //       _offlineInstallationPayments[_currentPayment].boxDetails =
                //           widget.customer.cable.boxDetails;
                //     }
                //     _offlineInstallationPayments[_currentPayment].created = [];
                //     _offlineInstallationPayments[_currentPayment].created.add(
                //           PurpleCreated(
                //             id: "",
                //             name: user.fullName,
                //             phoneNumber: "",
                //             emailId: "",
                //             userName: user.userName,
                //             password: "",
                //             userType: user.userType,
                //             activeStatus: true,
                //           ),
                //         );
                //     for (var i = 0; i < _customerList.length; i++) {
                //       if (_customerList[i].id == widget.customer.id) {
                //         _customerList[i].cable.cableAdvanceAmountPaid =
                //             (double.tryParse(_customerList[i]
                //                         .cable
                //                         .cableAdvanceAmountPaid) +
                //                     double.tryParse(payment.amountPaid))
                //                 .round()
                //                 .toString();
                //         _offlineInstallationPayments[_currentPayment]
                //             .outstanding = (double.tryParse(
                //                     _customerList[i].cable.cableAdvanceAmount) -
                //                 double.tryParse(_customerList[i]
                //                     .cable
                //                     .cableAdvanceAmountPaid))
                //             .round()
                //             .toString();
                //       }
                //     }
                //     _paymentList
                //         .add(_offlineInstallationPayments[_currentPayment]);
                //     AppSharedPreferences.setOfflineSubscriptionPayments(
                //         _offlineInstallationPayments);
                //     AppSharedPreferences.setCustomers(_customerList);
                //     AppSharedPreferences.setBillings(_billingList);
                //     AppSharedPreferences.setPayments(_paymentList);
                //   }
                //   if (payment.serviceType == "others") {
                //     _offlineOthersPayments.add(payment);
                //     _currentPayment = _offlineOthersPayments.length - 1;
                //     _offlineOthersPayments[_currentPayment].createdAt =
                //         DateTime.now().toLocal().toString();
                //     _offlineOthersPayments[_currentPayment].invoiceId =
                //         "Offline";
                //     _offlineOthersPayments[_currentPayment].customerData =
                //         widget.customer;
                //     if (widget.customer.cable.boxDetails != null &&
                //         widget.customer.cable.boxDetails.isNotEmpty) {
                //       _offlineOthersPayments[_currentPayment].boxDetails =
                //           widget.customer.cable.boxDetails;
                //     }
                //     _offlineOthersPayments[_currentPayment].created = [];
                //     _offlineOthersPayments[_currentPayment].created.add(
                //           PurpleCreated(
                //             id: "",
                //             name: user.fullName,
                //             phoneNumber: "",
                //             emailId: "",
                //             userName: user.userName,
                //             password: "",
                //             userType: user.userType,
                //             activeStatus: true,
                //           ),
                //         );
                //     _paymentList.add(_offlineOthersPayments[_currentPayment]);
                //     AppSharedPreferences.setOfflineSubscriptionPayments(
                //         _offlineOthersPayments);
                //     AppSharedPreferences.setCustomers(_customerList);
                //     AppSharedPreferences.setBillings(_billingList);
                //     AppSharedPreferences.setPayments(_paymentList);
                //   }
                // });
                // addPaymentKey.currentState.showSnackBar(new SnackBar(
                //   backgroundColor: Colors.blue,
                //   content: new Text("Offline Payment Added Successfully !!"),
                // ));
                // setState(() {
                //   _isAdding = false;
                //   _serviceType = "cable";
                //   _paymentForCable = "Subscription";
                //   _paymentForInternet = "Subscription";
                //   _paymentMode = "Cash";
                //   _paymentForOthers = null;
                //   _internetPlans = null;
                //   _generateInternetInvoice = true;
                //   _addInternetPayment = false;
                //   _setTextField();
                //   Navigator.pop(context);
                //   if (payment.paymentFor == "Subscription") {
                //     paymentView(context,
                //         _offlineSubscriptionPayments[_currentPayment], true);
                //   }
                //   if (payment.paymentFor == "Installation") {
                //     paymentView(context,
                //         _offlineInstallationPayments[_currentPayment], true);
                //   }
                //   if (payment.serviceType == "others") {
                //     paymentView(
                //         context, _offlineOthersPayments[_currentPayment], true);
                //   }
                // });
              });
            }
          }
        }
        if (_serviceType == "others") {
          saveOthersPayment(payment).then((response) {
            paymentData =
                paymentFromJson(Utf8Codec().decode(response.bodyBytes));
            if (response.statusCode == 201) {
              addPaymentKey.currentState.showSnackBar(new SnackBar(
                backgroundColor: Colors.green,
                content: new Text("Payment Added Successfully!!"),
              ));
              paymentData.customerData = widget.customer;
              setState(() {
                _isAdding = false;
                // _searchCustomer.text = "";

                // barcode = "";
                // pay = false;

                _serviceType = "cable";
                _paymentForCable = "Subscription";
                _paymentForInternet = "Subscription";
                _paymentMode = "Cash";
                _paymentForOthers = null;
                _internetPlans = null;
                _generateInternetInvoice = true;
                _addInternetPayment = false;
                _setTextField();
                Navigator.pop(context);
                paymentView(context, paymentData, true);
              });
            } else {
              addPaymentKey.currentState.showSnackBar(new SnackBar(
                backgroundColor: Colors.redAccent[400],
                content: new Text("Something went wrong !!"),
              ));

              addPaymentKey.currentState.showSnackBar(new SnackBar(
                backgroundColor: Colors.redAccent[400],
                content: new Text("No Internet Connection !!"),
              ));
              // setState(() {
              //   if (payment.paymentFor == "Subscription") {
              //     _offlineSubscriptionPayments.add(payment);
              //     _currentPayment = _offlineSubscriptionPayments.length - 1;
              //     _offlineSubscriptionPayments[_currentPayment].createdAt =
              //         DateTime.now().toLocal().toString();
              //     _offlineSubscriptionPayments[_currentPayment].invoiceId =
              //         "Offline";
              //     _offlineSubscriptionPayments[_currentPayment].customerData =
              //         widget.customer;
              //     if (widget.customer.cable.boxDetails != null &&
              //         widget.customer.cable.boxDetails.isNotEmpty) {
              //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
              //           widget.customer.cable.boxDetails;
              //     }
              //     _offlineSubscriptionPayments[_currentPayment].created = [];
              //     _offlineSubscriptionPayments[_currentPayment].created.add(
              //           PurpleCreated(
              //             id: "",
              //             name: user.fullName,
              //             phoneNumber: "",
              //             emailId: "",
              //             userName: user.userName,
              //             password: "",
              //             userType: user.userType,
              //             activeStatus: true,
              //           ),
              //         );
              //     for (var i = 0; i < _customerList.length; i++) {
              //       if (_customerList[i].id == widget.customer.id) {
              //         _customerList[i].cable.cableOutstandingAmount =
              //             (double.tryParse(_customerList[i]
              //                         .cable
              //                         .cableOutstandingAmount) -
              //                     double.tryParse(payment.amountPaid))
              //                 .round()
              //                 .toString();
              //         _offlineSubscriptionPayments[_currentPayment]
              //                 .outstanding =
              //             _customerList[i].cable.cableOutstandingAmount;
              //       }
              //     }
              //     for (var i = 0; i < _billingList.length; i++) {
              //       if (_billingList[i].customerId == widget.customer.id) {
              //         if (double.tryParse(_billingList[i].outstandingAmount) <=
              //             double.tryParse(payment.amountPaid)) {
              //           _billingList[i].paidStatus = "Fully Paid";
              //         } else {
              //           _billingList[i].paidStatus = "Partial Paid";
              //         }
              //         _billingList[i].outstandingAmount =
              //             _offlineSubscriptionPayments[_currentPayment]
              //                 .outstanding;
              //         _billingList[i]
              //                 .customerData
              //                 .cable
              //                 .cableOutstandingAmount =
              //             _offlineSubscriptionPayments[_currentPayment]
              //                 .outstanding;
              //       }
              //     }
              //     _paymentList
              //         .add(_offlineSubscriptionPayments[_currentPayment]);
              //     AppSharedPreferences.setOfflineSubscriptionPayments(
              //         _offlineSubscriptionPayments);
              //     AppSharedPreferences.setCustomers(_customerList);
              //     AppSharedPreferences.setBillings(_billingList);
              //     AppSharedPreferences.setPayments(_paymentList);
              //   }
              //   if (payment.paymentFor == "Installation") {
              //     _offlineInstallationPayments.add(payment);
              //     _currentPayment = _offlineInstallationPayments.length - 1;
              //     _offlineInstallationPayments[_currentPayment].createdAt =
              //         DateTime.now().toLocal().toString();
              //     _offlineInstallationPayments[_currentPayment].invoiceId =
              //         "Offline";
              //     _offlineInstallationPayments[_currentPayment].customerData =
              //         widget.customer;
              //     if (widget.customer.cable.boxDetails != null &&
              //         widget.customer.cable.boxDetails.isNotEmpty) {
              //       _offlineInstallationPayments[_currentPayment].boxDetails =
              //           widget.customer.cable.boxDetails;
              //     }
              //     _offlineInstallationPayments[_currentPayment].created = [];
              //     _offlineInstallationPayments[_currentPayment].created.add(
              //           PurpleCreated(
              //             id: "",
              //             name: user.fullName,
              //             phoneNumber: "",
              //             emailId: "",
              //             userName: user.userName,
              //             password: "",
              //             userType: user.userType,
              //             activeStatus: true,
              //           ),
              //         );
              //     for (var i = 0; i < _customerList.length; i++) {
              //       if (_customerList[i].id == widget.customer.id) {
              //         _customerList[i].cable.cableAdvanceAmountPaid =
              //             (double.tryParse(_customerList[i]
              //                         .cable
              //                         .cableAdvanceAmountPaid) +
              //                     double.tryParse(payment.amountPaid))
              //                 .round()
              //                 .toString();
              //         _offlineInstallationPayments[_currentPayment]
              //             .outstanding = (double.tryParse(
              //                     _customerList[i].cable.cableAdvanceAmount) -
              //                 double.tryParse(_customerList[i]
              //                     .cable
              //                     .cableAdvanceAmountPaid))
              //             .round()
              //             .toString();
              //       }
              //     }
              //     _paymentList
              //         .add(_offlineInstallationPayments[_currentPayment]);
              //     AppSharedPreferences.setOfflineSubscriptionPayments(
              //         _offlineInstallationPayments);
              //     AppSharedPreferences.setCustomers(_customerList);
              //     AppSharedPreferences.setBillings(_billingList);
              //     AppSharedPreferences.setPayments(_paymentList);
              //   }
              //   if (payment.serviceType == "others") {
              //     _offlineOthersPayments.add(payment);
              //     _currentPayment = _offlineOthersPayments.length - 1;
              //     _offlineOthersPayments[_currentPayment].createdAt =
              //         DateTime.now().toLocal().toString();
              //     _offlineOthersPayments[_currentPayment].invoiceId = "Offline";
              //     _offlineOthersPayments[_currentPayment].customerData =
              //         widget.customer;
              //     if (widget.customer.cable.boxDetails != null &&
              //         widget.customer.cable.boxDetails.isNotEmpty) {
              //       _offlineOthersPayments[_currentPayment].boxDetails =
              //           widget.customer.cable.boxDetails;
              //     }
              //     _offlineOthersPayments[_currentPayment].created = [];
              //     _offlineOthersPayments[_currentPayment].created.add(
              //           PurpleCreated(
              //             id: "",
              //             name: user.fullName,
              //             phoneNumber: "",
              //             emailId: "",
              //             userName: user.userName,
              //             password: "",
              //             userType: user.userType,
              //             activeStatus: true,
              //           ),
              //         );
              //     _paymentList.add(_offlineOthersPayments[_currentPayment]);
              //     AppSharedPreferences.setOfflineSubscriptionPayments(
              //         _offlineOthersPayments);
              //     AppSharedPreferences.setCustomers(_customerList);
              //     AppSharedPreferences.setBillings(_billingList);
              //     AppSharedPreferences.setPayments(_paymentList);
              //   }
              // });
              // addPaymentKey.currentState.showSnackBar(new SnackBar(
              //   backgroundColor: Colors.blue,
              //   content: new Text("Offline Payment Added Successfully !!"),
              // ));
              // setState(() {
              //   _isAdding = false;
              //   _serviceType = "cable";
              //   _paymentForCable = "Subscription";
              //   _paymentForInternet = "Subscription";
              //   _paymentMode = "Cash";
              //   _paymentForOthers = null;
              //   _internetPlans = null;
              //   _generateInternetInvoice = true;
              //   _addInternetPayment = false;
              //   _setTextField();
              //   Navigator.pop(context);
              //   if (payment.paymentFor == "Subscription") {
              //     paymentView(context,
              //         _offlineSubscriptionPayments[_currentPayment], true);
              //   }
              //   if (payment.paymentFor == "Installation") {
              //     paymentView(context,
              //         _offlineInstallationPayments[_currentPayment], true);
              //   }
              //   if (payment.serviceType == "others") {
              //     paymentView(
              //         context, _offlineOthersPayments[_currentPayment], true);
              //   }
              // });

              setState(() => _isAdding = false);
            }
          }).catchError((error) {
            print('error : $error');

            addPaymentKey.currentState.showSnackBar(new SnackBar(
              backgroundColor: Colors.redAccent[400],
              content: new Text("No Internet Connection !!"),
            ));
            // setState(() {
            //   if (payment.paymentFor == "Subscription") {
            //     _offlineSubscriptionPayments.add(payment);
            //     _currentPayment = _offlineSubscriptionPayments.length - 1;
            //     _offlineSubscriptionPayments[_currentPayment].createdAt =
            //         DateTime.now().toLocal().toString();
            //     _offlineSubscriptionPayments[_currentPayment].invoiceId =
            //         "Offline";
            //     _offlineSubscriptionPayments[_currentPayment].customerData =
            //         widget.customer;
            //     if (widget.customer.cable.boxDetails != null &&
            //         widget.customer.cable.boxDetails.isNotEmpty) {
            //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
            //           widget.customer.cable.boxDetails;
            //     }
            //     _offlineSubscriptionPayments[_currentPayment].created = [];
            //     _offlineSubscriptionPayments[_currentPayment].created.add(
            //           PurpleCreated(
            //             id: "",
            //             name: user.fullName,
            //             phoneNumber: "",
            //             emailId: "",
            //             userName: user.userName,
            //             password: "",
            //             userType: user.userType,
            //             activeStatus: true,
            //           ),
            //         );
            //     for (var i = 0; i < _customerList.length; i++) {
            //       if (_customerList[i].id == widget.customer.id) {
            //         _customerList[i]
            //             .cable
            //             .cableOutstandingAmount = (double.tryParse(
            //                     _customerList[i].cable.cableOutstandingAmount) -
            //                 double.tryParse(payment.amountPaid))
            //             .round()
            //             .toString();
            //         _offlineSubscriptionPayments[_currentPayment].outstanding =
            //             _customerList[i].cable.cableOutstandingAmount;
            //       }
            //     }
            //     for (var i = 0; i < _billingList.length; i++) {
            //       if (_billingList[i].customerId == widget.customer.id) {
            //         if (double.tryParse(_billingList[i].outstandingAmount) <=
            //             double.tryParse(payment.amountPaid)) {
            //           _billingList[i].paidStatus = "Fully Paid";
            //         } else {
            //           _billingList[i].paidStatus = "Partial Paid";
            //         }
            //         _billingList[i].outstandingAmount =
            //             _offlineSubscriptionPayments[_currentPayment]
            //                 .outstanding;
            //         _billingList[i].customerData.cable.cableOutstandingAmount =
            //             _offlineSubscriptionPayments[_currentPayment]
            //                 .outstanding;
            //       }
            //     }
            //     _paymentList.add(_offlineSubscriptionPayments[_currentPayment]);
            //     AppSharedPreferences.setOfflineSubscriptionPayments(
            //         _offlineSubscriptionPayments);
            //     AppSharedPreferences.setCustomers(_customerList);
            //     AppSharedPreferences.setBillings(_billingList);
            //     AppSharedPreferences.setPayments(_paymentList);
            //   }
            //   if (payment.paymentFor == "Installation") {
            //     _offlineInstallationPayments.add(payment);
            //     _currentPayment = _offlineInstallationPayments.length - 1;
            //     _offlineInstallationPayments[_currentPayment].createdAt =
            //         DateTime.now().toLocal().toString();
            //     _offlineInstallationPayments[_currentPayment].invoiceId =
            //         "Offline";
            //     _offlineInstallationPayments[_currentPayment].customerData =
            //         widget.customer;
            //     if (widget.customer.cable.boxDetails != null &&
            //         widget.customer.cable.boxDetails.isNotEmpty) {
            //       _offlineInstallationPayments[_currentPayment].boxDetails =
            //           widget.customer.cable.boxDetails;
            //     }
            //     _offlineInstallationPayments[_currentPayment].created = [];
            //     _offlineInstallationPayments[_currentPayment].created.add(
            //           PurpleCreated(
            //             id: "",
            //             name: user.fullName,
            //             phoneNumber: "",
            //             emailId: "",
            //             userName: user.userName,
            //             password: "",
            //             userType: user.userType,
            //             activeStatus: true,
            //           ),
            //         );
            //     for (var i = 0; i < _customerList.length; i++) {
            //       if (_customerList[i].id == widget.customer.id) {
            //         _customerList[i]
            //             .cable
            //             .cableAdvanceAmountPaid = (double.tryParse(
            //                     _customerList[i].cable.cableAdvanceAmountPaid) +
            //                 double.tryParse(payment.amountPaid))
            //             .round()
            //             .toString();
            //         _offlineInstallationPayments[_currentPayment]
            //             .outstanding = (double.tryParse(
            //                     _customerList[i].cable.cableAdvanceAmount) -
            //                 double.tryParse(
            //                     _customerList[i].cable.cableAdvanceAmountPaid))
            //             .round()
            //             .toString();
            //       }
            //     }
            //     _paymentList.add(_offlineInstallationPayments[_currentPayment]);
            //     AppSharedPreferences.setOfflineSubscriptionPayments(
            //         _offlineInstallationPayments);
            //     AppSharedPreferences.setCustomers(_customerList);
            //     AppSharedPreferences.setBillings(_billingList);
            //     AppSharedPreferences.setPayments(_paymentList);
            //   }
            //   if (payment.serviceType == "others") {
            //     _offlineOthersPayments.add(payment);
            //     _currentPayment = _offlineOthersPayments.length - 1;
            //     _offlineOthersPayments[_currentPayment].createdAt =
            //         DateTime.now().toLocal().toString();
            //     _offlineOthersPayments[_currentPayment].invoiceId = "Offline";
            //     _offlineOthersPayments[_currentPayment].customerData =
            //         widget.customer;
            //     if (widget.customer.cable.boxDetails != null &&
            //         widget.customer.cable.boxDetails.isNotEmpty) {
            //       _offlineOthersPayments[_currentPayment].boxDetails =
            //           widget.customer.cable.boxDetails;
            //     }
            //     _offlineOthersPayments[_currentPayment].created = [];
            //     _offlineOthersPayments[_currentPayment].created.add(
            //           PurpleCreated(
            //             id: "",
            //             name: user.fullName,
            //             phoneNumber: "",
            //             emailId: "",
            //             userName: user.userName,
            //             password: "",
            //             userType: user.userType,
            //             activeStatus: true,
            //           ),
            //         );
            //     _paymentList.add(_offlineOthersPayments[_currentPayment]);
            //     AppSharedPreferences.setOfflineSubscriptionPayments(
            //         _offlineOthersPayments);
            //     AppSharedPreferences.setCustomers(_customerList);
            //     AppSharedPreferences.setBillings(_billingList);
            //     AppSharedPreferences.setPayments(_paymentList);
            //   }
            // });
            // addPaymentKey.currentState.showSnackBar(new SnackBar(
            //   backgroundColor: Colors.blue,
            //   content: new Text("Offline Payment Added Successfully !!"),
            // ));
            // setState(() {
            //   _isAdding = false;
            //   _serviceType = "cable";
            //   _paymentForCable = "Subscription";
            //   _paymentForInternet = "Subscription";
            //   _paymentMode = "Cash";
            //   _paymentForOthers = null;
            //   _internetPlans = null;
            //   _generateInternetInvoice = true;
            //   _addInternetPayment = false;
            //   _setTextField();
            //   Navigator.pop(context);
            //   if (payment.paymentFor == "Subscription") {
            //     paymentView(context,
            //         _offlineSubscriptionPayments[_currentPayment], true);
            //   }
            //   if (payment.paymentFor == "Installation") {
            //     paymentView(context,
            //         _offlineInstallationPayments[_currentPayment], true);
            //   }
            //   if (payment.serviceType == "others") {
            //     paymentView(
            //         context, _offlineOthersPayments[_currentPayment], true);
            //   }
            // });
          });
        }
      } else {
        addPaymentKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("No Internet Connection !!"),
        ));
        // setState(() {
        //   if (payment.paymentFor == "Subscription") {
        //     _offlineSubscriptionPayments.add(payment);
        //     _currentPayment = _offlineSubscriptionPayments.length - 1;
        //     _offlineSubscriptionPayments[_currentPayment].createdAt =
        //         DateTime.now().toLocal().toString();
        //     _offlineSubscriptionPayments[_currentPayment].invoiceId = "Offline";
        //     _offlineSubscriptionPayments[_currentPayment].customerData =
        //         widget.customer;
        //     if (widget.customer.cable.boxDetails != null &&
        //         widget.customer.cable.boxDetails.isNotEmpty) {
        //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
        //           widget.customer.cable.boxDetails;
        //     }
        //     _offlineSubscriptionPayments[_currentPayment].created = [];
        //     _offlineSubscriptionPayments[_currentPayment].created.add(
        //           PurpleCreated(
        //             id: "",
        //             name: user.fullName,
        //             phoneNumber: "",
        //             emailId: "",
        //             userName: user.userName,
        //             password: "",
        //             userType: user.userType,
        //             activeStatus: true,
        //           ),
        //         );
        //     for (var i = 0; i < _customerList.length; i++) {
        //       if (_customerList[i].id == widget.customer.id) {
        //         _customerList[i].cable.cableOutstandingAmount =
        //             (double.tryParse(
        //                         _customerList[i].cable.cableOutstandingAmount) -
        //                     double.tryParse(payment.amountPaid))
        //                 .round()
        //                 .toString();
        //         _offlineSubscriptionPayments[_currentPayment].outstanding =
        //             _customerList[i].cable.cableOutstandingAmount;
        //       }
        //     }
        //     for (var i = 0; i < _billingList.length; i++) {
        //       if (_billingList[i].customerId == widget.customer.id) {
        //         if (double.tryParse(_billingList[i].outstandingAmount) <=
        //             double.tryParse(payment.amountPaid)) {
        //           _billingList[i].paidStatus = "Fully Paid";
        //         } else {
        //           _billingList[i].paidStatus = "Partial Paid";
        //         }
        //         _billingList[i].outstandingAmount =
        //             _offlineSubscriptionPayments[_currentPayment].outstanding;
        //         _billingList[i].customerData.cable.cableOutstandingAmount =
        //             _offlineSubscriptionPayments[_currentPayment].outstanding;
        //       }
        //     }
        //     _paymentList.add(_offlineSubscriptionPayments[_currentPayment]);
        //     AppSharedPreferences.setOfflineSubscriptionPayments(
        //         _offlineSubscriptionPayments);
        //     AppSharedPreferences.setCustomers(_customerList);
        //     AppSharedPreferences.setBillings(_billingList);
        //     AppSharedPreferences.setPayments(_paymentList);
        //   }
        //   if (payment.paymentFor == "Installation") {
        //     _offlineInstallationPayments.add(payment);
        //     _currentPayment = _offlineInstallationPayments.length - 1;
        //     _offlineInstallationPayments[_currentPayment].createdAt =
        //         DateTime.now().toLocal().toString();
        //     _offlineInstallationPayments[_currentPayment].invoiceId = "Offline";
        //     _offlineInstallationPayments[_currentPayment].customerData =
        //         widget.customer;
        //     if (widget.customer.cable.boxDetails != null &&
        //         widget.customer.cable.boxDetails.isNotEmpty) {
        //       _offlineInstallationPayments[_currentPayment].boxDetails =
        //           widget.customer.cable.boxDetails;
        //     }
        //     _offlineInstallationPayments[_currentPayment].created = [];
        //     _offlineInstallationPayments[_currentPayment].created.add(
        //           PurpleCreated(
        //             id: "",
        //             name: user.fullName,
        //             phoneNumber: "",
        //             emailId: "",
        //             userName: user.userName,
        //             password: "",
        //             userType: user.userType,
        //             activeStatus: true,
        //           ),
        //         );
        //     for (var i = 0; i < _customerList.length; i++) {
        //       if (_customerList[i].id == widget.customer.id) {
        //         _customerList[i].cable.cableAdvanceAmountPaid =
        //             (double.tryParse(
        //                         _customerList[i].cable.cableAdvanceAmountPaid) +
        //                     double.tryParse(payment.amountPaid))
        //                 .round()
        //                 .toString();
        //         _offlineInstallationPayments[_currentPayment].outstanding =
        //             (double.tryParse(
        //                         _customerList[i].cable.cableAdvanceAmount) -
        //                     double.tryParse(
        //                         _customerList[i].cable.cableAdvanceAmountPaid))
        //                 .round()
        //                 .toString();
        //       }
        //     }
        //     _paymentList.add(_offlineInstallationPayments[_currentPayment]);
        //     AppSharedPreferences.setOfflineSubscriptionPayments(
        //         _offlineInstallationPayments);
        //     AppSharedPreferences.setCustomers(_customerList);
        //     AppSharedPreferences.setBillings(_billingList);
        //     AppSharedPreferences.setPayments(_paymentList);
        //   }
        //   if (payment.serviceType == "others") {
        //     _offlineOthersPayments.add(payment);
        //     _currentPayment = _offlineOthersPayments.length - 1;
        //     _offlineOthersPayments[_currentPayment].createdAt =
        //         DateTime.now().toLocal().toString();
        //     _offlineOthersPayments[_currentPayment].invoiceId = "Offline";
        //     _offlineOthersPayments[_currentPayment].customerData =
        //         widget.customer;
        //     if (widget.customer.cable.boxDetails != null &&
        //         widget.customer.cable.boxDetails.isNotEmpty) {
        //       _offlineOthersPayments[_currentPayment].boxDetails =
        //           widget.customer.cable.boxDetails;
        //     }
        //     _offlineOthersPayments[_currentPayment].created = [];
        //     _offlineOthersPayments[_currentPayment].created.add(
        //           PurpleCreated(
        //             id: "",
        //             name: user.fullName,
        //             phoneNumber: "",
        //             emailId: "",
        //             userName: user.userName,
        //             password: "",
        //             userType: user.userType,
        //             activeStatus: true,
        //           ),
        //         );
        //     _paymentList.add(_offlineOthersPayments[_currentPayment]);
        //     AppSharedPreferences.setOfflineSubscriptionPayments(
        //         _offlineOthersPayments);
        //     AppSharedPreferences.setCustomers(_customerList);
        //     AppSharedPreferences.setBillings(_billingList);
        //     AppSharedPreferences.setPayments(_paymentList);
        //   }
        // });
        // addPaymentKey.currentState.showSnackBar(new SnackBar(
        //   backgroundColor: Colors.blue,
        //   content: new Text("Offline Payment Added Successfully !!"),
        // ));
        // setState(() {
        //   _isAdding = false;
        //   _serviceType = "cable";
        //   _paymentForCable = "Subscription";
        //   _paymentForInternet = "Subscription";
        //   _paymentMode = "Cash";
        //   _paymentForOthers = null;
        //   _internetPlans = null;
        //   _generateInternetInvoice = true;
        //   _addInternetPayment = false;
        //   _setTextField();
        //   Navigator.pop(context);
        //   if (payment.paymentFor == "Subscription") {
        //     paymentView(
        //         context, _offlineSubscriptionPayments[_currentPayment], true);
        //   }
        //   if (payment.paymentFor == "Installation") {
        //     paymentView(
        //         context, _offlineInstallationPayments[_currentPayment], true);
        //   }
        //   if (payment.serviceType == "others") {
        //     paymentView(context, _offlineOthersPayments[_currentPayment], true);
        //   }
        // });
      
      }
    }
  }

  getInternetPlan() {
    internetPlan().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          internetPlans =
              internetPlanFromJson(Utf8Codec().decode(response.bodyBytes));
          payCustomer();
        });
        AppSharedPreferences.setInternetPlan(internetPlans);
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
        payCustomer();
      });
    });
  }

  Future getOldData() async {
    try {
      paymentCategories = await AppSharedPreferences.getPaymentCategory();
      internetPlans = await AppSharedPreferences.getInternetPlan();
      _internetBillingSettings =
          await AppSharedPreferences.getInternetBillingSetting();
      payCustomer();
    } catch (e) {
      print(e);
    }
  }

  payCustomer() {
    setState(() {
      // pay = true;
      if (widget.internet == true) {
        _serviceType = "internet";
      } else {
        widget.customer.cable.noCableConnection != null &&
                widget.customer.cable.noCableConnection > 0
            ? _serviceType = "cable"
            : widget.customer.internet.noInternetConnection != null &&
                    widget.customer.internet.noInternetConnection > 0
                ? _serviceType = "internet"
                : _serviceType = "others";
      }
      if (_serviceType == 'cable') {
        _outstanding = widget.customer.cable.cableOutstandingAmount;
      }
      if (_serviceType == 'internet') {
        if (widget.customer.internet.internetOutstandingAmount != null) {
          _outstanding = widget.customer.internet.internetOutstandingAmount;
        } else {
          _outstanding = '0';
        }
      }

      if (_internetBillingSettings == null ||
          _internetBillingSettings.isEmpty) {
        _generateInternetInvoice = false;
        _addInternetPayment = true;
      } else if (_internetBillingSettings[0].billingType == "Pre paid") {
        _generateInternetInvoice = true;
        _addInternetPayment = false;
      } else if (_internetBillingSettings[0].billingType == "Post paid") {
        _generateInternetInvoice = false;
        _addInternetPayment = true;
      } else {
        _generateInternetInvoice = false;
        _addInternetPayment = true;
      }
      _setAmountPaid();
      for (var i = 0; i < internetPlans.length; i++) {
        if (internetPlans[i].planName == widget.customer.internet.planName) {
          _internetPlans = internetPlans[i];
        }
      }
      if (_internetPlans == null) {
        _planAmountInternetController.text = "0";
      } else {
        _planAmountInternetController.text =
            widget.customer.internet.internetMonthlyRent.toString();
      }
      _expController.text = dateFormatter.format(
          DateTime.tryParse(DateTime.now().toString()).toLocal().add(Duration(
              days: _internetPlans.validityDays == 0 ||
                      _internetPlans.validityDays.isNegative ||
                      _internetPlans.validityDays == null ||
                      _internetPlans.validityDays < 1
                  ? 0
                  : _internetPlans.validityDays - 1)));
    });
  }

  @override
  Widget build(BuildContext context) {
    // payCustomer();
    // _setAmountPaid();
    return Scaffold(
      key: addPaymentKey,
      appBar: new AppBar(
        title: new Text('Add Payment'),
        backgroundColor: new Color(0xffae275f),
      ),
      backgroundColor: Color(0xFFdae2f0),
      body: _isLoading
          ? Loader()
          : Container(
              child: Column(children: <Widget>[
              payCard(context),
            ])),
    );
  }

  Widget payCard(BuildContext context) {
    return Expanded(
        child: Form(
            key: _addPaymentKey,
            child: ListView(
              children: <Widget>[
                Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    margin: new EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 3.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(64, 75, 96, .9),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          title: Row(children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 5.0),
                              height: 12.0,
                              width: 12.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: widget.customer.activeStatus == true
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            Container(
                                width: 235,
                                child: Text(
                                  widget.customer.customerName.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                          ]),
                          subtitle: Column(
                            children: <Widget>[
                              Container(height: 7.0),
                              Container(
                                width: 270,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                            "ID : " +
                                                widget.customer.customerId,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              Container(
                                height: 5.0,
                              ),
                              Text(
                                widget.customer.address.doorNo +
                                    ' ' +
                                    widget.customer.address.street +
                                    ' ' +
                                    widget.customer.address.area +
                                    ' ' +
                                    widget.customer.address.city,
                                style: TextStyle(color: Color(0xfff4f4f4)),
                              )
                            ],
                          ),
                        ))),
                Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    margin: new EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 3.0),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0)),
                        // margin: new EdgeInsets.symmetric(
                        //     horizontal: 10.0, vertical: 3.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  widget.customer.cable.noCableConnection !=
                                              null &&
                                          widget.customer.cable
                                                  .noCableConnection >
                                              0
                                      ? Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: _serviceType == "cable"
                                                    ? Color(0xffae275f)
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _serviceType = "cable";
                                                    if (_serviceType ==
                                                        'cable') {
                                                      _outstanding = widget
                                                          .customer
                                                          .cable
                                                          .cableOutstandingAmount;
                                                    }
                                                    if (_serviceType ==
                                                        'internet') {
                                                      if (widget
                                                              .customer
                                                              .internet
                                                              .internetOutstandingAmount !=
                                                          null) {
                                                        _outstanding = widget
                                                            .customer
                                                            .internet
                                                            .internetOutstandingAmount;
                                                      } else {
                                                        _outstanding = '0';
                                                      }
                                                    }
                                                    _paymentForCable =
                                                        "Subscription";
                                                    _paymentForInternet =
                                                        "Subscription";
                                                    if (_internetBillingSettings ==
                                                            null ||
                                                        _internetBillingSettings
                                                            .isEmpty) {
                                                      _generateInternetInvoice =
                                                          false;
                                                      _addInternetPayment =
                                                          true;
                                                    } else if (_internetBillingSettings[
                                                                0]
                                                            .billingType ==
                                                        "Pre paid") {
                                                      _generateInternetInvoice =
                                                          true;
                                                      _addInternetPayment =
                                                          false;
                                                    } else if (_internetBillingSettings[
                                                                0]
                                                            .billingType ==
                                                        "Post paid") {
                                                      _generateInternetInvoice =
                                                          false;
                                                      _addInternetPayment =
                                                          true;
                                                    } else {
                                                      _generateInternetInvoice =
                                                          false;
                                                      _addInternetPayment =
                                                          true;
                                                    }
                                                    _paymentForOthers = null;
                                                    for (var i = 0;
                                                        i <
                                                            internetPlans
                                                                .length;
                                                        i++) {
                                                      if (internetPlans[i]
                                                              .planName ==
                                                          widget
                                                              .customer
                                                              .internet
                                                              .planName) {
                                                        _internetPlans =
                                                            internetPlans[i];
                                                      }
                                                    }
                                                    _paymentMode = "Cash";
                                                    _setAmountPaid();
                                                    if (_internetPlans ==
                                                        null) {
                                                      _planAmountInternetController
                                                          .text = "0";
                                                    } else {
                                                      _planAmountInternetController
                                                              .text =
                                                          widget
                                                              .customer
                                                              .internet
                                                              .internetMonthlyRent
                                                              .toString();
                                                    }
                                                    _discountCableController
                                                        .text = "0";
                                                    _discountInternetController
                                                        .text = "0";
                                                    _discountOthersController
                                                        .text = "0";
                                                    _commentCableController
                                                        .text = "";
                                                    _commentInternetController
                                                        .text = "";
                                                    _commentOthersController
                                                        .text = "";
                                                    _discountCommentCableController
                                                        .text = "";
                                                    _discountCommentInternetController
                                                        .text = "";
                                                    _discountCommentOthersController
                                                        .text = "";
                                                    _isDiscount = false;
                                                  });
                                                },
                                                icon: Text(
                                                  "Cable",
                                                  style: TextStyle(
                                                    color:
                                                        _serviceType == "cable"
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )),
                                          ),
                                        )
                                      : Container(),
                                  widget.customer.internet
                                                  .noInternetConnection !=
                                              null &&
                                          widget.customer.internet
                                                  .noInternetConnection >
                                              0
                                      ? Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color:
                                                    _serviceType == "internet"
                                                        ? Color(0xffae275f)
                                                        : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _serviceType = "internet";
                                                    if (_serviceType ==
                                                        'cable') {
                                                      _outstanding = widget
                                                          .customer
                                                          .cable
                                                          .cableOutstandingAmount;
                                                    }
                                                    if (_serviceType ==
                                                        'internet') {
                                                      if (widget
                                                              .customer
                                                              .internet
                                                              .internetOutstandingAmount !=
                                                          null) {
                                                        _outstanding = widget
                                                            .customer
                                                            .internet
                                                            .internetOutstandingAmount;
                                                      } else {
                                                        _outstanding = '0';
                                                      }
                                                    }
                                                    _paymentForCable =
                                                        "Subscription";
                                                    _paymentForInternet =
                                                        "Subscription";
                                                    if (_internetBillingSettings ==
                                                            null ||
                                                        _internetBillingSettings
                                                            .isEmpty) {
                                                      _generateInternetInvoice =
                                                          false;
                                                      _addInternetPayment =
                                                          true;
                                                    } else if (_internetBillingSettings[
                                                                0]
                                                            .billingType ==
                                                        "Pre paid") {
                                                      _generateInternetInvoice =
                                                          true;
                                                      _addInternetPayment =
                                                          false;
                                                    } else if (_internetBillingSettings[
                                                                0]
                                                            .billingType ==
                                                        "Post paid") {
                                                      _generateInternetInvoice =
                                                          false;
                                                      _addInternetPayment =
                                                          true;
                                                    } else {
                                                      _generateInternetInvoice =
                                                          false;
                                                      _addInternetPayment =
                                                          true;
                                                    }
                                                    _paymentForOthers = null;
                                                    for (var i = 0;
                                                        i <
                                                            internetPlans
                                                                .length;
                                                        i++) {
                                                      if (internetPlans[i]
                                                              .planName ==
                                                          widget
                                                              .customer
                                                              .internet
                                                              .planName) {
                                                        _internetPlans =
                                                            internetPlans[i];
                                                      }
                                                    }
                                                    _paymentMode = "Cash";
                                                    _setAmountPaid();
                                                    if (_internetPlans ==
                                                        null) {
                                                      _planAmountInternetController
                                                          .text = "0";
                                                    } else {
                                                      _planAmountInternetController
                                                              .text =
                                                          widget
                                                              .customer
                                                              .internet
                                                              .internetMonthlyRent
                                                              .toString();
                                                    }
                                                    _discountCableController
                                                        .text = "0";
                                                    _discountInternetController
                                                        .text = "0";
                                                    _discountOthersController
                                                        .text = "0";
                                                    _commentCableController
                                                        .text = "";
                                                    _commentInternetController
                                                        .text = "";
                                                    _commentOthersController
                                                        .text = "";
                                                    _discountCommentCableController
                                                        .text = "";
                                                    _discountCommentInternetController
                                                        .text = "";
                                                    _discountCommentOthersController
                                                        .text = "";
                                                    _isDiscount = false;
                                                  });
                                                },
                                                icon: Text(
                                                  "Internet",
                                                  style: TextStyle(
                                                    color: _serviceType ==
                                                            "internet"
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )),
                                          ),
                                        )
                                      : Container(),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: _serviceType == "others"
                                              ? Color(0xffae275f)
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _serviceType = "others";
                                              if (_serviceType == 'cable') {
                                                _outstanding = widget
                                                    .customer
                                                    .cable
                                                    .cableOutstandingAmount;
                                              }
                                              if (_serviceType == 'internet') {
                                                if (widget.customer.internet
                                                        .internetOutstandingAmount !=
                                                    null) {
                                                  _outstanding = widget
                                                      .customer
                                                      .internet
                                                      .internetOutstandingAmount;
                                                } else {
                                                  _outstanding = '0';
                                                }
                                              }
                                              _paymentForCable = "Subscription";
                                              _paymentForInternet =
                                                  "Subscription";
                                              if (_internetBillingSettings ==
                                                      null ||
                                                  _internetBillingSettings
                                                      .isEmpty) {
                                                _generateInternetInvoice =
                                                    false;
                                                _addInternetPayment = true;
                                              } else if (_internetBillingSettings[
                                                          0]
                                                      .billingType ==
                                                  "Pre paid") {
                                                _generateInternetInvoice = true;
                                                _addInternetPayment = false;
                                              } else if (_internetBillingSettings[
                                                          0]
                                                      .billingType ==
                                                  "Post paid") {
                                                _generateInternetInvoice =
                                                    false;
                                                _addInternetPayment = true;
                                              } else {
                                                _generateInternetInvoice =
                                                    false;
                                                _addInternetPayment = true;
                                              }
                                              _paymentForOthers = null;
                                              for (var i = 0;
                                                  i < internetPlans.length;
                                                  i++) {
                                                if (internetPlans[i].planName ==
                                                    widget.customer.internet
                                                        .planName) {
                                                  _internetPlans =
                                                      internetPlans[i];
                                                }
                                              }
                                              _paymentMode = "Cash";
                                              _setAmountPaid();
                                              if (_internetPlans == null) {
                                                _planAmountInternetController
                                                    .text = "0";
                                              } else {
                                                _planAmountInternetController
                                                        .text =
                                                    widget.customer.internet
                                                        .internetMonthlyRent
                                                        .toString();
                                              }
                                              _discountCableController.text =
                                                  "0";
                                              _discountInternetController.text =
                                                  "0";
                                              _discountOthersController.text =
                                                  "0";
                                              _commentCableController.text = "";
                                              _commentInternetController.text =
                                                  "";
                                              _commentOthersController.text =
                                                  "";
                                              _discountCommentCableController
                                                  .text = "";
                                              _discountCommentInternetController
                                                  .text = "";
                                              _discountCommentOthersController
                                                  .text = "";
                                              _isDiscount = false;
                                            });
                                          },
                                          icon: Text(
                                            "Others",
                                            style: TextStyle(
                                              color: _serviceType == "others"
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          )),
                                    ),
                                  ),
                                ]),
                          ],
                        ))),
                _serviceType == "cable"
                    ? Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        margin: new EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 3.0),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0)),
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 3.0),
                            child: Column(
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    "Payment For",
                                    style: TextStyle(fontSize: 16.0),
                                  )),
                                  Expanded(
                                      flex: 1,
                                      child: DropdownButton<String>(
                                          isExpanded: true,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0),
                                          items: <String>[
                                            'Subscription',
                                            'Installation',
                                          ].map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(value),
                                            );
                                          }).toList(),
                                          value: _paymentForCable,
                                          onChanged: (newVal) {
                                            setState(() {
                                              _paymentForCable = newVal;
                                              _setAmountPaid();
                                            });
                                          }))
                                ]),
                                (double.tryParse(widget.customer.cable
                                                .cableAdvanceAmount) -
                                            double.tryParse(widget
                                                .customer
                                                .cable
                                                .cableAdvanceAmountPaid)) >
                                        0
                                    ? SizedBox(
                                        height: 15.0,
                                      )
                                    : Container(),
                                (double.tryParse(widget.customer.cable
                                                .cableAdvanceAmount) -
                                            double.tryParse(widget
                                                .customer
                                                .cable
                                                .cableAdvanceAmountPaid)) >
                                        0
                                    ? Row(children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          "Installation Due",
                                          style: TextStyle(fontSize: 16.0),
                                        )),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            _paymentForCable == "Installation"
                                                ? "Rs. " +
                                                    (double.tryParse(widget
                                                                .customer
                                                                .cable
                                                                .cableAdvanceAmount) -
                                                            double.tryParse(widget
                                                                .customer
                                                                .cable
                                                                .cableAdvanceAmountPaid))
                                                        .toInt()
                                                        .toString()
                                                : "Pending",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                        )
                                      ])
                                    : Container(),
                                (double.tryParse(widget.customer.cable
                                                .cableAdvanceAmount) -
                                            double.tryParse(widget
                                                .customer
                                                .cable
                                                .cableAdvanceAmountPaid)) >
                                        0
                                    ? SizedBox(
                                        height: 15.0,
                                      )
                                    : Container(),
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Text("Bill To",
                                          style: TextStyle(fontSize: 16.0))),
                                  Expanded(
                                      child: TextFormField(
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      _receiptPhoneNumber = value;
                                    },
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16.0),
                                    initialValue:
                                        widget.customer.address.mobile,
                                    decoration: InputDecoration(
                                      hintText: "Mobile Number",
                                    ),
                                  )),
                                ]),
                                SizedBox(
                                  height: 15.0,
                                ),
                                _paymentForCable == "Subscription"
                                    ? Row(children: <Widget>[
                                        Expanded(
                                            child: Text("Outstanding ",
                                                style:
                                                    TextStyle(fontSize: 16.0))),
                                        Expanded(
                                            child: Text(
                                                'Rs. ' +
                                                    widget.customer.cable
                                                        .cableOutstandingAmount,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red)))
                                      ])
                                    : Container(),
                                _paymentForCable == "Subscription"
                                    ? SizedBox(
                                        height: 15.0,
                                      )
                                    : Container(),
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Text("Amount Paid",
                                          style: TextStyle(fontSize: 16.0))),
                                  Expanded(
                                      child: TextFormField(
                                    controller: _amountPaidCableController,
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16.0),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter amount';
                                      }
                                      if (int.parse(value) <= 0) {
                                        return 'Amount incorrect';
                                      }
                                      _amountPaidCable = value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Enter Amount",
                                    ),
                                  )),
                                ]),
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Text("Payment Mode",
                                          style: TextStyle(fontSize: 16.0))),
                                  Expanded(
                                      child: DropdownButton<String>(
                                          isExpanded: true,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16.0),
                                          items: <String>[
                                            'Cash',
                                            'Card',
                                            'Debit Card',
                                            'Credit Card',
                                            'Cheque',
                                            'PayTM',
                                            'Google Pay',
                                            'Other'
                                          ].map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(value),
                                            );
                                          }).toList(),
                                          value: _paymentMode,
                                          onChanged: (newVal) {
                                            setState(() {
                                              _paymentMode = newVal;
                                            });
                                          }))
                                ]),
                                Row(children: <Widget>[
                                  // Expanded(
                                  //     child: Text("Comment",
                                  //         style: TextStyle(fontSize: 16.0))),
                                  Expanded(
                                      child: TextFormField(
                                    controller: _commentCableController,
                                    maxLines: 2,
                                    keyboardType: TextInputType.multiline,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16.0),
                                    validator: (value) {
                                      _commentCable = value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Comment",
                                    ),
                                  )),
                                ]),
                                Row(children: <Widget>[
                                  Checkbox(
                                    value: _isDiscount,
                                    onChanged: (value) {
                                      setState(() {
                                        _isDiscount = value;
                                        if (_isDiscount == false) {
                                          _discountCableController.text = "0";
                                          _discountInternetController.text =
                                              "0";
                                          _discountOthersController.text = "0";
                                          _commentCableController.text = "";
                                          _commentInternetController.text = "";
                                          _commentOthersController.text = "";
                                          _discountCommentCableController.text =
                                              "";
                                          _discountCommentInternetController
                                              .text = "";
                                          _discountCommentOthersController
                                              .text = "";
                                          _isDiscount = false;
                                        }
                                      });
                                    },
                                    activeColor: Color(0xffae275f),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (_isDiscount == false) {
                                          _isDiscount = true;
                                        } else {
                                          _isDiscount = false;
                                        }
                                        if (_isDiscount == false) {
                                          _discountCableController.text = "0";
                                          _discountInternetController.text =
                                              "0";
                                          _discountOthersController.text = "0";
                                          _commentCableController.text = "";
                                          _commentInternetController.text = "";
                                          _commentOthersController.text = "";
                                          _discountCommentCableController.text =
                                              "";
                                          _discountCommentInternetController
                                              .text = "";
                                          _discountCommentOthersController
                                              .text = "";
                                          _isDiscount = false;
                                        }
                                      });
                                    },
                                    child: Text("Add Discount",
                                        style: TextStyle(fontSize: 16.0)),
                                  ),
                                ]),
                                _isDiscount
                                    ? Row(children: <Widget>[
                                        Expanded(
                                            child: Text("Discount Amount",
                                                style:
                                                    TextStyle(fontSize: 16.0))),
                                        Expanded(
                                            child: TextFormField(
                                          controller: _discountCableController,
                                          maxLines: 1,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0),
                                          validator: (value) {
                                            if (int.parse(value) <= 0) {
                                              return 'Amount incorrect';
                                            }
                                            _discountCable = value;
                                          },
                                          decoration: InputDecoration(
                                            hintText: "Enter Amount",
                                          ),
                                        )),
                                      ])
                                    : Container(),
                                _isDiscount
                                    ? Row(children: <Widget>[
                                        // Expanded(
                                        //     child: Text("Discount Comment",
                                        //         style:
                                        //             TextStyle(fontSize: 16.0))),
                                        Expanded(
                                            child: TextFormField(
                                          controller:
                                              _discountCommentCableController,
                                          maxLines: 2,
                                          keyboardType: TextInputType.multiline,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0),
                                          validator: (value) {
                                            _discountCommentCable = value;
                                          },
                                          decoration: InputDecoration(
                                            hintText: "Comment",
                                          ),
                                        )),
                                      ])
                                    : Container(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                _isAdding
                                    ? new CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.green),
                                      )
                                    : Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 30.0),
                                        width: double.infinity,
                                        child: RaisedButton(
                                          padding: EdgeInsets.all(12.0),
                                          shape: StadiumBorder(),
                                          splashColor: Colors.green,
                                          child: Text(
                                            "SUBMIT",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          color: new Color(0xffae275f),
                                          onPressed: () {
                                            _addPayment(context);
                                          },
                                        ),
                                      ),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            )))
                    : _serviceType == "internet"
                        ? Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            margin: new EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 3.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0)),
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 3.0),
                                child: Column(
                                  children: <Widget>[
                                    _internetBillingSettings == null ||
                                            _internetBillingSettings.isEmpty
                                        ? Container()
                                        : _internetBillingSettings[0]
                                                    .billingType ==
                                                "Pre paid"
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                    Expanded(
                                                      child: Container(
                                                        child: RaisedButton(
                                                          shape:
                                                              StadiumBorder(),
                                                          splashColor:
                                                              Colors.green,
                                                          child: Text(
                                                            "Generate Invoice",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          color:
                                                              _generateInternetInvoice ==
                                                                      true
                                                                  ? Color(
                                                                      0xffae275f)
                                                                  : Colors.grey,
                                                          onPressed: () {
                                                            setState(() {
                                                              if (_serviceType ==
                                                                  'cable') {
                                                                _outstanding = widget
                                                                    .customer
                                                                    .cable
                                                                    .cableOutstandingAmount;
                                                              }
                                                              if (_serviceType ==
                                                                  'internet') {
                                                                if (widget
                                                                        .customer
                                                                        .internet
                                                                        .internetOutstandingAmount !=
                                                                    null) {
                                                                  _outstanding = widget
                                                                      .customer
                                                                      .internet
                                                                      .internetOutstandingAmount;
                                                                } else {
                                                                  _outstanding =
                                                                      '0';
                                                                }
                                                              }
                                                              _generateInternetInvoice =
                                                                  true;
                                                              _addInternetPayment =
                                                                  false;
                                                              for (var i = 0;
                                                                  i <
                                                                      internetPlans
                                                                          .length;
                                                                  i++) {
                                                                if (internetPlans[
                                                                            i]
                                                                        .planName ==
                                                                    widget
                                                                        .customer
                                                                        .internet
                                                                        .planName) {
                                                                  _internetPlans =
                                                                      internetPlans[
                                                                          i];
                                                                }
                                                              }
                                                              _setAmountPaid();
                                                              if (_internetPlans ==
                                                                  null) {
                                                                _planAmountInternetController
                                                                    .text = "0";
                                                              } else {
                                                                _planAmountInternetController
                                                                        .text =
                                                                    widget
                                                                        .customer
                                                                        .internet
                                                                        .internetMonthlyRent
                                                                        .toString();
                                                              }
                                                              _discountCableController
                                                                  .text = "0";
                                                              _discountInternetController
                                                                  .text = "0";
                                                              _discountOthersController
                                                                  .text = "0";
                                                              _commentCableController
                                                                  .text = "";
                                                              _commentInternetController
                                                                  .text = "";
                                                              _commentOthersController
                                                                  .text = "";
                                                              _discountCommentCableController
                                                                  .text = "";
                                                              _discountCommentInternetController
                                                                  .text = "";
                                                              _discountCommentOthersController
                                                                  .text = "";
                                                              _isDiscount =
                                                                  false;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 10.0,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: RaisedButton(
                                                          shape:
                                                              StadiumBorder(),
                                                          splashColor:
                                                              Colors.green,
                                                          child: Text(
                                                            "Add Payment",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          color:
                                                              _addInternetPayment ==
                                                                      true
                                                                  ? Color(
                                                                      0xffae275f)
                                                                  : Colors.grey,
                                                          onPressed: () {
                                                            setState(() {
                                                              if (_serviceType ==
                                                                  'cable') {
                                                                _outstanding = widget
                                                                    .customer
                                                                    .cable
                                                                    .cableOutstandingAmount;
                                                              }
                                                              if (_serviceType ==
                                                                  'internet') {
                                                                if (widget
                                                                        .customer
                                                                        .internet
                                                                        .internetOutstandingAmount !=
                                                                    null) {
                                                                  _outstanding = widget
                                                                      .customer
                                                                      .internet
                                                                      .internetOutstandingAmount;
                                                                } else {
                                                                  _outstanding =
                                                                      '0';
                                                                }
                                                              }
                                                              _generateInternetInvoice =
                                                                  false;
                                                              _addInternetPayment =
                                                                  true;
                                                              for (var i = 0;
                                                                  i <
                                                                      internetPlans
                                                                          .length;
                                                                  i++) {
                                                                if (internetPlans[
                                                                            i]
                                                                        .planName ==
                                                                    widget
                                                                        .customer
                                                                        .internet
                                                                        .planName) {
                                                                  _internetPlans =
                                                                      internetPlans[
                                                                          i];
                                                                }
                                                              }
                                                              _setAmountPaid();
                                                              if (_internetPlans ==
                                                                  null) {
                                                                _planAmountInternetController
                                                                    .text = "0";
                                                              } else {
                                                                _planAmountInternetController
                                                                        .text =
                                                                    widget
                                                                        .customer
                                                                        .internet
                                                                        .internetMonthlyRent
                                                                        .toString();
                                                              }
                                                              _discountCableController
                                                                  .text = "0";
                                                              _discountInternetController
                                                                  .text = "0";
                                                              _discountOthersController
                                                                  .text = "0";
                                                              _commentCableController
                                                                  .text = "";
                                                              _commentInternetController
                                                                  .text = "";
                                                              _commentOthersController
                                                                  .text = "";
                                                              _discountCommentCableController
                                                                  .text = "";
                                                              _discountCommentInternetController
                                                                  .text = "";
                                                              _discountCommentOthersController
                                                                  .text = "";
                                                              _isDiscount =
                                                                  false;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ])
                                            : Container(),
                                    _generateInternetInvoice == true
                                        ? Container(
                                            child: Column(
                                              children: <Widget>[
                                                Row(children: <Widget>[
                                                  Expanded(
                                                      child: Text(
                                                    "Choose Plan",
                                                    style: TextStyle(
                                                        fontSize: 16.0),
                                                  )),
                                                  Expanded(
                                                      flex: 1,
                                                      child: DropdownButton<
                                                              InternetPlan>(
                                                          disabledHint:
                                                              new Text(
                                                            "None",
                                                          ),
                                                          hint: new Text(
                                                            "Select Plan",
                                                          ),
                                                          isExpanded: true,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.0),
                                                          items: internetPlans
                                                              .map((InternetPlan
                                                                  value) {
                                                            return new DropdownMenuItem<
                                                                InternetPlan>(
                                                              value: value,
                                                              child: Text(
                                                                  value
                                                                      .planName,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible),
                                                            );
                                                          }).toList(),
                                                          value: _internetPlans,
                                                          onChanged: (newVal) {
                                                            setState(() {
                                                              _internetPlans =
                                                                  newVal;
                                                              _setAmountPaid();
                                                              _expController
                                                                  .text = dateFormatter.format(DateTime
                                                                      .tryParse(
                                                                          DateTime.now()
                                                                              .toString())
                                                                  .toLocal()
                                                                  .add(Duration(
                                                                      days: _internetPlans.validityDays == 0 ||
                                                                              _internetPlans.validityDays.isNegative ||
                                                                              _internetPlans.validityDays == null ||
                                                                              _internetPlans.validityDays < 1
                                                                          ? 0
                                                                          : _internetPlans.validityDays - 1)));
                                                            });
                                                          }))
                                                ]),
                                                Row(children: <Widget>[
                                                  Expanded(
                                                      // flex: 2,
                                                      child: Text(
                                                    "Activation Date",
                                                    style: TextStyle(
                                                        fontSize: 16.0),
                                                  )),
                                                  Expanded(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          // flex: 1,
                                                          child: TextFormField(
                                                            controller:
                                                                _actController,
                                                            maxLines: 1,
                                                            keyboardType:
                                                                TextInputType
                                                                    .datetime,
                                                            validator: (value) {
                                                              setState(() {
                                                                _actController
                                                                        .text =
                                                                    value;
                                                                _actdate =
                                                                    value;
                                                              });
                                                            },
                                                            decoration: InputDecoration(
                                                                labelText:
                                                                    "DD-MM-YYYY",
                                                                labelStyle:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            12.0)),
                                                          ),
                                                        ),
                                                        Container(width: 5.0),
                                                        InkWell(
                                                          onTap: () {
                                                            _selectActDate(
                                                                context);
                                                          },
                                                          highlightColor:
                                                              Colors.green,
                                                          child: Icon(
                                                            Icons.date_range,
                                                            size: 30.0,
                                                            color:
                                                                Colors.blueGrey,
                                                          ),
                                                        ),
                                                        Container(width: 5.0),
                                                      ],
                                                    ),
                                                  )
                                                ]),
                                                Row(children: <Widget>[
                                                  Expanded(
                                                      // flex: 2,
                                                      child: Text(
                                                    "Expiry Date",
                                                    style: TextStyle(
                                                        fontSize: 16.0),
                                                  )),
                                                  Expanded(
                                                      // flex: 1,
                                                      child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: TextFormField(
                                                          controller:
                                                              _expController,
                                                          maxLines: 1,
                                                          keyboardType:
                                                              TextInputType
                                                                  .datetime,
                                                          validator: (value) {
                                                            setState(() {
                                                              _expController
                                                                  .text = value;
                                                              _expdate = value;
                                                            });
                                                          },
                                                          decoration: InputDecoration(
                                                              labelText:
                                                                  "DD-MM-YYYY",
                                                              labelStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          12.0)),
                                                        ),
                                                      ),
                                                      Container(width: 5.0),
                                                      InkWell(
                                                        onTap: () {
                                                          _selectExpDate(
                                                              context);
                                                        },
                                                        highlightColor:
                                                            Colors.green,
                                                        child: Icon(
                                                          Icons.date_range,
                                                          size: 30.0,
                                                          color:
                                                              Colors.blueGrey,
                                                        ),
                                                      ),
                                                      Container(width: 5.0),
                                                    ],
                                                  )),
                                                ]),
                                                Row(children: <Widget>[
                                                  Expanded(
                                                      child: Text("Amount",
                                                          style: TextStyle(
                                                              fontSize: 16.0))),
                                                  Expanded(
                                                      child: TextFormField(
                                                    // initialValue: customer.internet.internetOutstandingAmount,
                                                    controller:
                                                        _planAmountInternetController,
                                                    maxLines: 1,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16.0),
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return 'Please enter amount';
                                                      }
                                                      if (int.parse(value) <=
                                                          0) {
                                                        return 'Amount incorrect';
                                                      }
                                                      _internetPlanAmount =
                                                          value;
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: "Enter Amount",
                                                    ),
                                                  )),
                                                ]),
                                                Row(children: <Widget>[
                                                  Checkbox(
                                                      activeColor:
                                                          Color(0xffae275f),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _recordPayment =
                                                              value;
                                                        });
                                                      },
                                                      value: _recordPayment),
                                                  Expanded(
                                                      child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (_recordPayment ==
                                                            false) {
                                                          _recordPayment = true;
                                                        } else {
                                                          _recordPayment =
                                                              false;
                                                        }
                                                      });
                                                    },
                                                    child: Text(
                                                      "Record Payment",
                                                      style: TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                  )),
                                                ]),
                                                SizedBox(
                                                  height: 20.0,
                                                ),
                                                _isAdding
                                                    ? new CircularProgressIndicator(
                                                        valueColor:
                                                            new AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.green),
                                                      )
                                                    : Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 0.0,
                                                                horizontal:
                                                                    30.0),
                                                        width: double.infinity,
                                                        child: RaisedButton(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          shape:
                                                              StadiumBorder(),
                                                          splashColor:
                                                              Colors.green,
                                                          child: Text(
                                                            "SUBMIT",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          color: new Color(
                                                              0xffae275f),
                                                          onPressed: () {
                                                            _addPayment(
                                                                context);
                                                          },
                                                        ),
                                                      ),
                                                SizedBox(
                                                  height: 20.0,
                                                ),
                                              ],
                                            ),
                                          )
                                        : _addInternetPayment == true
                                            ? Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(children: <Widget>[
                                                      Expanded(
                                                          child: Text(
                                                        "Payment For",
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      )),
                                                      Expanded(
                                                          flex: 1,
                                                          child: DropdownButton<
                                                                  String>(
                                                              isExpanded: true,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      16.0),
                                                              items: <String>[
                                                                'Subscription',
                                                                'Installation',
                                                              ].map((String
                                                                  value) {
                                                                return new DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child:
                                                                      new Text(
                                                                          value),
                                                                );
                                                              }).toList(),
                                                              value:
                                                                  _paymentForInternet,
                                                              onChanged:
                                                                  (newVal) {
                                                                setState(() {
                                                                  _paymentForInternet =
                                                                      newVal;
                                                                });
                                                              }))
                                                    ]),
                                                    Row(children: <Widget>[
                                                      Expanded(
                                                          child: Text("Bill To",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0))),
                                                      Expanded(
                                                          child: TextFormField(
                                                        maxLines: 1,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        validator: (value) {
                                                          _receiptPhoneNumber =
                                                              value;
                                                        },
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16.0),
                                                        initialValue: widget
                                                            .customer
                                                            .address
                                                            .mobile,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Mobile Number",
                                                        ),
                                                      )),
                                                    ]),
                                                    SizedBox(
                                                      height: 15.0,
                                                    ),
                                                    Row(children: <Widget>[
                                                      Expanded(
                                                          child: Text(
                                                              "Outstanding ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0))),
                                                      Expanded(
                                                          child: Text(
                                                              'Rs. ' +
                                                                  _outstanding,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red)))
                                                    ]),
                                                    SizedBox(
                                                      height: 15.0,
                                                    ),
                                                    Row(children: <Widget>[
                                                      Expanded(
                                                          child: Text(
                                                              "Amount Paid",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0))),
                                                      Expanded(
                                                          child: TextFormField(
                                                        // initialValue: customer.internet.internetOutstandingAmount,
                                                        controller:
                                                            _amountPaidInternetController,
                                                        maxLines: 1,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16.0),
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Please enter amount';
                                                          }
                                                          if (int.parse(
                                                                  value) <=
                                                              0) {
                                                            return 'Amount incorrect';
                                                          }
                                                          _amountPaidInternet =
                                                              value;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Enter Amount",
                                                        ),
                                                      )),
                                                    ]),
                                                    Row(children: <Widget>[
                                                      Expanded(
                                                          child: Text(
                                                              "Payment Mode",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0))),
                                                      Expanded(
                                                          child: DropdownButton<
                                                                  String>(
                                                              isExpanded: true,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize:
                                                                      16.0),
                                                              items: <String>[
                                                                'Cash',
                                                                'Card',
                                                                'Debit Card',
                                                                'Credit Card',
                                                                'Cheque',
                                                                'PayTM',
                                                                'Google Pay',
                                                                'Other'
                                                              ].map((String
                                                                  value) {
                                                                return new DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child:
                                                                      new Text(
                                                                          value),
                                                                );
                                                              }).toList(),
                                                              value:
                                                                  _paymentMode,
                                                              onChanged:
                                                                  (newVal) {
                                                                setState(() {
                                                                  _paymentMode =
                                                                      newVal;
                                                                });
                                                              }))
                                                    ]),
                                                    Row(children: <Widget>[
                                                      // Expanded(
                                                      //     child: Text("Comment",
                                                      //         style: TextStyle(
                                                      //             fontSize:
                                                      //                 16.0))),
                                                      Expanded(
                                                          child: TextFormField(
                                                        controller:
                                                            _commentInternetController,
                                                        maxLines: 2,
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16.0),
                                                        validator: (value) {
                                                          _commentInternet =
                                                              value;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: "Comment",
                                                        ),
                                                      )),
                                                    ]),
                                                    Row(children: <Widget>[
                                                      Checkbox(
                                                        value: _isDiscount,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _isDiscount = value;
                                                            if (_isDiscount ==
                                                                false) {
                                                              _discountCableController
                                                                  .text = "0";
                                                              _discountInternetController
                                                                  .text = "0";
                                                              _discountOthersController
                                                                  .text = "0";
                                                              _commentCableController
                                                                  .text = "";
                                                              _commentInternetController
                                                                  .text = "";
                                                              _commentOthersController
                                                                  .text = "";
                                                              _discountCommentCableController
                                                                  .text = "";
                                                              _discountCommentInternetController
                                                                  .text = "";
                                                              _discountCommentOthersController
                                                                  .text = "";
                                                              _isDiscount =
                                                                  false;
                                                            }
                                                          });
                                                        },
                                                        activeColor:
                                                            Color(0xffae275f),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            if (_isDiscount ==
                                                                false) {
                                                              _isDiscount =
                                                                  true;
                                                            } else {
                                                              _isDiscount =
                                                                  false;
                                                            }
                                                            if (_isDiscount ==
                                                                false) {
                                                              _discountCableController
                                                                  .text = "0";
                                                              _discountInternetController
                                                                  .text = "0";
                                                              _discountOthersController
                                                                  .text = "0";
                                                              _commentCableController
                                                                  .text = "";
                                                              _commentInternetController
                                                                  .text = "";
                                                              _commentOthersController
                                                                  .text = "";
                                                              _discountCommentCableController
                                                                  .text = "";
                                                              _discountCommentInternetController
                                                                  .text = "";
                                                              _discountCommentOthersController
                                                                  .text = "";
                                                              _isDiscount =
                                                                  false;
                                                            }
                                                          });
                                                        },
                                                        child: Text(
                                                            "Add Discount",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    16.0)),
                                                      ),
                                                    ]),
                                                    _isDiscount
                                                        ? Row(
                                                            children: <Widget>[
                                                                Expanded(
                                                                    child: Text(
                                                                        "Discount Amount",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16.0))),
                                                                Expanded(
                                                                    child:
                                                                        TextFormField(
                                                                  controller:
                                                                      _discountInternetController,
                                                                  maxLines: 1,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16.0),
                                                                  validator:
                                                                      (value) {
                                                                    if (int.parse(
                                                                            value) <=
                                                                        0) {
                                                                      return 'Amount incorrect';
                                                                    }
                                                                    _discountInternet =
                                                                        value;
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        "Enter Amount",
                                                                  ),
                                                                )),
                                                              ])
                                                        : Container(),
                                                    _isDiscount
                                                        ? Row(
                                                            children: <Widget>[
                                                                // Expanded(
                                                                //     child: Text(
                                                                //         "Discount Comment",
                                                                //         style: TextStyle(
                                                                //             fontSize:
                                                                //                 16.0))),
                                                                Expanded(
                                                                    child:
                                                                        TextFormField(
                                                                  controller:
                                                                      _discountCommentInternetController,
                                                                  maxLines: 2,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .multiline,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16.0),
                                                                  validator:
                                                                      (value) {
                                                                    _discountCommentInternet =
                                                                        value;
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        "Comment",
                                                                  ),
                                                                )),
                                                              ])
                                                        : Container(),
                                                    SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    _isAdding
                                                        ? new CircularProgressIndicator(
                                                            valueColor:
                                                                new AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Colors
                                                                        .green),
                                                          )
                                                        : Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        0.0,
                                                                    horizontal:
                                                                        30.0),
                                                            width:
                                                                double.infinity,
                                                            child: RaisedButton(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          12.0),
                                                              shape:
                                                                  StadiumBorder(),
                                                              splashColor:
                                                                  Colors.green,
                                                              child: Text(
                                                                "SUBMIT",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              color: new Color(
                                                                  0xffae275f),
                                                              onPressed: () {
                                                                _addPayment(
                                                                    context);
                                                              },
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      height: 20.0,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                  ],
                                )))
                        : _serviceType == "others"
                            ? Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 3.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    margin: new EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 3.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          Expanded(
                                              child: Text(
                                            "Payment For",
                                            style: TextStyle(fontSize: 16.0),
                                          )),
                                          Expanded(
                                              flex: 1,
                                              child: DropdownButton<
                                                      PaymentCategory>(
                                                  disabledHint: new Text(
                                                    "None",
                                                  ),
                                                  hint: new Text(
                                                    "Select Payment For",
                                                  ),
                                                  isExpanded: true,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16.0),
                                                  items: paymentCategories.map(
                                                      (PaymentCategory value) {
                                                    return new DropdownMenuItem<
                                                        PaymentCategory>(
                                                      value: value,
                                                      child: new Text(value
                                                          .paymentCategory),
                                                    );
                                                  }).toList(),
                                                  value: _paymentForOthers,
                                                  onChanged: (newVal) {
                                                    setState(() {
                                                      _paymentForOthers =
                                                          newVal;
                                                      _setAmountPaid();
                                                    });
                                                  }))
                                        ]),
                                        Row(children: <Widget>[
                                          Expanded(
                                              child: Text("Bill To",
                                                  style: TextStyle(
                                                      fontSize: 16.0))),
                                          Expanded(
                                              child: TextFormField(
                                            maxLines: 1,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              _receiptPhoneNumber = value;
                                            },
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0),
                                            initialValue:
                                                widget.customer.address.mobile,
                                            decoration: InputDecoration(
                                              hintText: "Mobile Number",
                                            ),
                                          )),
                                        ]),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Row(children: <Widget>[
                                          Expanded(
                                              child: Text("Amount Paid",
                                                  style: TextStyle(
                                                      fontSize: 16.0))),
                                          Expanded(
                                              child: TextFormField(
                                            controller:
                                                _amountPaidOthersController,
                                            maxLines: 1,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter amount';
                                              }
                                              if (int.parse(value) <= 0) {
                                                return 'Amount incorrect';
                                              }
                                              _amountPaidOthers = value;
                                            },
                                            decoration: InputDecoration(
                                              hintText: "Enter Amount",
                                            ),
                                          )),
                                        ]),
                                        Row(children: <Widget>[
                                          Expanded(
                                              child: Text("Payment Mode",
                                                  style: TextStyle(
                                                      fontSize: 16.0))),
                                          Expanded(
                                              child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 16.0),
                                                  items: <String>[
                                                    'Cash',
                                                    'Card',
                                                    'Debit Card',
                                                    'Credit Card',
                                                    'Cheque',
                                                    'PayTM',
                                                    'Google Pay',
                                                    'Other'
                                                  ].map((String value) {
                                                    return new DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: new Text(value),
                                                    );
                                                  }).toList(),
                                                  value: _paymentMode,
                                                  onChanged: (newVal) {
                                                    setState(() {
                                                      _paymentMode = newVal;
                                                    });
                                                  }))
                                        ]),
                                        Row(children: <Widget>[
                                          // Expanded(
                                          //     child: Text("Comment",
                                          //         style: TextStyle(
                                          //             fontSize: 16.0))),
                                          Expanded(
                                              child: TextFormField(
                                            controller:
                                                _commentOthersController,
                                            maxLines: 2,
                                            keyboardType:
                                                TextInputType.multiline,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0),
                                            validator: (value) {
                                              _commentOthers = value;
                                            },
                                            decoration: InputDecoration(
                                              hintText: "Comment",
                                            ),
                                          )),
                                        ]),
                                        Row(children: <Widget>[
                                          Checkbox(
                                            value: _isDiscount,
                                            onChanged: (value) {
                                              setState(() {
                                                _isDiscount = value;
                                                if (_isDiscount == false) {
                                                  _discountCableController
                                                      .text = "0";
                                                  _discountInternetController
                                                      .text = "0";
                                                  _discountOthersController
                                                      .text = "0";
                                                  _commentCableController.text =
                                                      "";
                                                  _commentInternetController
                                                      .text = "";
                                                  _commentOthersController
                                                      .text = "";
                                                  _discountCommentCableController
                                                      .text = "";
                                                  _discountCommentInternetController
                                                      .text = "";
                                                  _discountCommentOthersController
                                                      .text = "";
                                                  _isDiscount = false;
                                                }
                                              });
                                            },
                                            activeColor: Color(0xffae275f),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (_isDiscount == false) {
                                                  _isDiscount = true;
                                                } else {
                                                  _isDiscount = false;
                                                }
                                                if (_isDiscount == false) {
                                                  _discountCableController
                                                      .text = "0";
                                                  _discountInternetController
                                                      .text = "0";
                                                  _discountOthersController
                                                      .text = "0";
                                                  _commentCableController.text =
                                                      "";
                                                  _commentInternetController
                                                      .text = "";
                                                  _commentOthersController
                                                      .text = "";
                                                  _discountCommentCableController
                                                      .text = "";
                                                  _discountCommentInternetController
                                                      .text = "";
                                                  _discountCommentOthersController
                                                      .text = "";
                                                  _isDiscount = false;
                                                }
                                              });
                                            },
                                            child: Text("Add Discount",
                                                style:
                                                    TextStyle(fontSize: 16.0)),
                                          ),
                                        ]),
                                        _isDiscount
                                            ? Row(children: <Widget>[
                                                Expanded(
                                                    child: Text(
                                                        "Discount Amount",
                                                        style: TextStyle(
                                                            fontSize: 16.0))),
                                                Expanded(
                                                    child: TextFormField(
                                                  controller:
                                                      _discountOthersController,
                                                  maxLines: 1,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16.0),
                                                  validator: (value) {
                                                    if (int.parse(value) <= 0) {
                                                      return 'Amount incorrect';
                                                    }
                                                    _discountOthers = value;
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: "Enter Amount",
                                                  ),
                                                )),
                                              ])
                                            : Container(),
                                        _isDiscount
                                            ? Row(children: <Widget>[
                                                // Expanded(
                                                //     child: Text(
                                                //         "Discount Comment",
                                                //         style: TextStyle(
                                                //             fontSize: 16.0))),
                                                Expanded(
                                                    child: TextFormField(
                                                  controller:
                                                      _discountCommentOthersController,
                                                  maxLines: 2,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16.0),
                                                  validator: (value) {
                                                    _discountCommentOthers =
                                                        value;
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: "Comment",
                                                  ),
                                                )),
                                              ])
                                            : Container(),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        _isAdding
                                            ? new CircularProgressIndicator(
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                        Color>(Colors.green),
                                              )
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 30.0),
                                                width: double.infinity,
                                                child: RaisedButton(
                                                  padding: EdgeInsets.all(12.0),
                                                  shape: StadiumBorder(),
                                                  splashColor: Colors.green,
                                                  child: Text(
                                                    "SUBMIT",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  color: new Color(0xffae275f),
                                                  onPressed: () {
                                                    _paymentForOthers == null
                                                        ? addPaymentKey
                                                            .currentState
                                                            .showSnackBar(
                                                                new SnackBar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            content: new Text(
                                                                "Select Payment For"),
                                                          ))
                                                        : _addPayment(context);
                                                  },
                                                ),
                                              ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                      ],
                                    )))
                            : Container(),
              ],
            )));
  }
}
