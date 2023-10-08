import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:intl/intl.dart';
import 'package:svs/models/addon-package.dart';
import 'package:svs/models/billing.dart';
import 'package:svs/models/channel.dart';
import 'package:svs/models/customer.dart';
import 'package:svs/models/payment.dart';

// import 'package:svs/models/billing.dart';
import 'package:svs/services/basic_service.dart';
import 'dart:convert';
import 'package:svs/widgets/loader.dart';
import 'package:svs/widgets/payment_view.dart';

// import 'package:svs/widgets/billing_view.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:svs/models/login-response.dart';
import 'package:svs/models/payment-category.dart';
import 'package:svs/models/internet-plan.dart';
import 'package:svs/models/internet-billing.dart';
import 'package:svs/models/internet-billing-setting.dart';

class AddPaymentScreen extends StatefulWidget {
  _AddPaymentScreenState createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final TextEditingController _searchCustomer = new TextEditingController();
  final _addPaymentKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> addPaymentKey = new GlobalKey<ScaffoldState>();
  String barcode = "";
  List<InternetBillingSetting> _internetBillingSettings;
  Payment paymentData;

  // Billing billingData;
  List<Customer> customers;
  Customer customer;
  String _searchText = "";
  List searchList;
  bool pay = false;
  bool _isAdding = false;
  bool _isLoading = true;
  bool isBouquetChannel = true;
  String _internetPlanAmount;
  String _receiptPhoneNumber;
  String _serviceType = "cable";
  String _paymentForCable = "Subscription";
  String _paymentForInternet = "Subscription";
  PaymentCategory _paymentForOthers;
  String _paymentMode = "Cash";
  String _outstanding = '0';
  LoginResponse user;
  List<PaymentCategory> paymentCategories = [];
  InternetPlan _internetPlans;
  List<InternetPlan> internetPlans = [];
  final TextEditingController _planAmountInternetController =
      new TextEditingController();
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
  final TextEditingController _searchBouquetPackage =
      new TextEditingController();
  String _searchBouquetPackageText = "";
  final TextEditingController _searchChannel = new TextEditingController();
  String _searchChannelText = "";

  bool isEditBouquetChannelDetails = false;

  bool isEditInternetDetails = false;
  int _selectedBouquet;

  // List<Complaint> _complaintList = [];
  @override
  void initState() {
    super.initState();
    _searchCustomer.clear();
    // getListOldData();
    // getListData();
    getInternetBillingSetting();
    getData();
    _setTextField();
  }

  // getListData() {
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
  //   // try {
  //   //   _complaintList = await AppSharedPreferences.getComplaints();
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  //   // try {
  //   //   _offlineSubscriptionPayments =
  //   //       await AppSharedPreferences.getOfflineSubscriptionPayments();
  //   //   _offlineInstallationPayments =
  //   //       await AppSharedPreferences.getOfflineInstallationPayments();
  //   //   _offlineOthersPayments =
  //   //       await AppSharedPreferences.getOfflineOthersPayments();
  //   //   _paymentList = await AppSharedPreferences.getPayments();
  //   //   _billingList = await AppSharedPreferences.getBillings();
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  // }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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

  _AddPaymentScreenState() {
    _searchCustomer.addListener(() {
      if (_searchCustomer.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _searchCustomer.text;
        });
      }
    });
  }

  _setTextField() {
    setState(() {
      _amountPaidCableController.text = "0";
      _amountPaidInternetController.text = "0";
      _amountPaidOthersController.text = "0";
      _planAmountInternetController.text = "0";
      _commentCableController.text = "";
      _commentInternetController.text = "";
      _commentOthersController.text = "";
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
              customer.cable.cableOutstandingAmount;
        } else {
          _amountPaidCableController.text =
              (double.tryParse(customer.cable.cableAdvanceAmount) -
                      double.tryParse(customer.cable.cableAdvanceAmountPaid))
                  .toInt()
                  .toString();
        }
      }
      if (_serviceType == "internet") {
        _amountPaidInternetController.text =
            customer.internet.internetOutstandingAmount;

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
          customerId: customer.id,
          plan: _internetPlans.id,
          activationDate: _actdate,
          expiryDate: _expdate,
          amount: _internetPlanAmount,
          payment: _recordPayment,
        );
      } else if (_isDiscount) {
        payment = Payment(
          customerId: customer.id,
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
          // customDate:
          //     DateFormat("yyyyMMddHms").format(DateTime.now()).toString() +
          //         customer.id +
          //         _serviceType +
          //         _paymentMode +
          //         (_serviceType == "cable"
          //             ? (NumberFormat("##,##,###").format(
          //                     double.tryParse(_amountPaidCable) -
          //                         double.tryParse(_discountCable)))
          //                 .toString()
          //             : _serviceType == "internet"
          //                 ? (NumberFormat("##,##,###").format(
          //                         double.tryParse(_amountPaidInternet) -
          //                             double.tryParse(_discountInternet)))
          //                     .toString()
          //                 : (NumberFormat("##,##,###").format(
          //                         double.tryParse(_amountPaidOthers) -
          //                             double.tryParse(_discountOthers)))
          //                     .toString()),
        );
      } else {
        payment = Payment(
          customerId: customer.id,
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
          // customDate:
          //     DateFormat("yyyyMMddHms").format(DateTime.now()).toString() +
          //         customer.id +
          //         _serviceType +
          //         _paymentMode +
          //         (_serviceType == "cable"
          //             ? _amountPaidCable
          //             : _serviceType == "internet"
          //                 ? _amountPaidInternet
          //                 : _amountPaidOthers),
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
                paymentData.customerData = customer;
                setState(() {
                  _isAdding = false;
                  _searchCustomer.text = "";
                  _searchText = "";
                  barcode = "";
                  pay = false;
                  searchList = [];
                  _serviceType = "cable";
                  _paymentForCable = "Subscription";
                  _paymentForInternet = "Subscription";
                  _paymentMode = "Cash";
                  _paymentForOthers = null;
                  _internetPlans = null;
                  _generateInternetInvoice = true;
                  _addInternetPayment = false;
                  _setTextField();
                  paymentView(context, paymentData, true);
                });

                getData();
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
                //         customer;
                //     if (customer.cable.boxDetails != null &&
                //         customer.cable.boxDetails.isNotEmpty) {
                //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
                //           customer.cable.boxDetails;
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
                //       if (_customerList[i].id == customer.id) {
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
                //       if (_billingList[i].customerId == customer.id) {
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
                //         customer;
                //     if (customer.cable.boxDetails != null &&
                //         customer.cable.boxDetails.isNotEmpty) {
                //       _offlineInstallationPayments[_currentPayment].boxDetails =
                //           customer.cable.boxDetails;
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
                //       if (_customerList[i].id == customer.id) {
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
                //         customer;
                //     if (customer.cable.boxDetails != null &&
                //         customer.cable.boxDetails.isNotEmpty) {
                //       _offlineOthersPayments[_currentPayment].boxDetails =
                //           customer.cable.boxDetails;
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
              //         customer;
              //     if (customer.cable.boxDetails != null &&
              //         customer.cable.boxDetails.isNotEmpty) {
              //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
              //           customer.cable.boxDetails;
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
              //       if (_customerList[i].id == customer.id) {
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
              //       if (_billingList[i].customerId == customer.id) {
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
              //         customer;
              //     if (customer.cable.boxDetails != null &&
              //         customer.cable.boxDetails.isNotEmpty) {
              //       _offlineInstallationPayments[_currentPayment].boxDetails =
              //           customer.cable.boxDetails;
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
              //       if (_customerList[i].id == customer.id) {
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
              //         customer;
              //     if (customer.cable.boxDetails != null &&
              //         customer.cable.boxDetails.isNotEmpty) {
              //       _offlineOthersPayments[_currentPayment].boxDetails =
              //           customer.cable.boxDetails;
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
                paymentData.customerData = customer;
                setState(() {
                  _isAdding = false;
                  _searchCustomer.text = "";
                  _searchText = "";
                  barcode = "";
                  pay = false;
                  searchList = [];
                  _serviceType = "cable";
                  _paymentForCable = "Subscription";
                  _paymentForInternet = "Subscription";
                  _paymentMode = "Cash";
                  _paymentForOthers = null;
                  _internetPlans = null;
                  _generateInternetInvoice = true;
                  _addInternetPayment = false;
                  _setTextField();
                  paymentView(context, paymentData, true);
                });

                getData();
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
                //         customer;
                //     if (customer.cable.boxDetails != null &&
                //         customer.cable.boxDetails.isNotEmpty) {
                //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
                //           customer.cable.boxDetails;
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
                //       if (_customerList[i].id == customer.id) {
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
                //       if (_billingList[i].customerId == customer.id) {
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
                //         customer;
                //     if (customer.cable.boxDetails != null &&
                //         customer.cable.boxDetails.isNotEmpty) {
                //       _offlineInstallationPayments[_currentPayment].boxDetails =
                //           customer.cable.boxDetails;
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
                //       if (_customerList[i].id == customer.id) {
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
                //         customer;
                //     if (customer.cable.boxDetails != null &&
                //         customer.cable.boxDetails.isNotEmpty) {
                //       _offlineOthersPayments[_currentPayment].boxDetails =
                //           customer.cable.boxDetails;
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
              //         customer;
              //     if (customer.cable.boxDetails != null &&
              //         customer.cable.boxDetails.isNotEmpty) {
              //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
              //           customer.cable.boxDetails;
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
              //       if (_customerList[i].id == customer.id) {
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
              //       if (_billingList[i].customerId == customer.id) {
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
              //         customer;
              //     if (customer.cable.boxDetails != null &&
              //         customer.cable.boxDetails.isNotEmpty) {
              //       _offlineInstallationPayments[_currentPayment].boxDetails =
              //           customer.cable.boxDetails;
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
              //       if (_customerList[i].id == customer.id) {
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
              //         customer;
              //     if (customer.cable.boxDetails != null &&
              //         customer.cable.boxDetails.isNotEmpty) {
              //       _offlineOthersPayments[_currentPayment].boxDetails =
              //           customer.cable.boxDetails;
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
                  paymentData.customerData = customer;
                } else {
                  addPaymentKey.currentState.showSnackBar(new SnackBar(
                    backgroundColor: Colors.green,
                    content: new Text("Invoice Generated Successfully!!"),
                  ));
                  // billingData.customerData = customer;
                }

                setState(() {
                  _isAdding = false;
                  _searchCustomer.text = "";
                  _searchText = "";
                  barcode = "";
                  pay = false;
                  searchList = [];
                  _serviceType = "cable";
                  _paymentForCable = "Subscription";
                  _paymentForInternet = "Subscription";
                  _paymentMode = "Cash";
                  _paymentForOthers = null;
                  _internetPlans = null;
                  _generateInternetInvoice = true;
                  _addInternetPayment = false;
                  _setTextField();
                  if (_recordPayment == true) {
                    paymentView(context, paymentData, true);
                  }
                  // else {
                  //   billingView(context, billingData);
                  // }
                });

                getData();
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
                  paymentData.customerData = customer;
                  setState(() {
                    _isAdding = false;
                    _searchCustomer.text = "";
                    _searchText = "";
                    barcode = "";
                    pay = false;
                    searchList = [];
                    _serviceType = "cable";
                    _paymentForCable = "Subscription";
                    _paymentForInternet = "Subscription";
                    _paymentMode = "Cash";
                    _paymentForOthers = null;
                    _internetPlans = null;
                    _generateInternetInvoice = true;
                    _addInternetPayment = false;
                    _setTextField();
                    paymentView(context, paymentData, true);
                  });

                  getData();
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
                  //         .customerData = customer;
                  //     if (customer.cable.boxDetails != null &&
                  //         customer.cable.boxDetails.isNotEmpty) {
                  //       _offlineSubscriptionPayments[_currentPayment]
                  //           .boxDetails = customer.cable.boxDetails;
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
                  //       if (_customerList[i].id == customer.id) {
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
                  //       if (_billingList[i].customerId == customer.id) {
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
                  //         .customerData = customer;
                  //     if (customer.cable.boxDetails != null &&
                  //         customer.cable.boxDetails.isNotEmpty) {
                  //       _offlineInstallationPayments[_currentPayment]
                  //           .boxDetails = customer.cable.boxDetails;
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
                  //       if (_customerList[i].id == customer.id) {
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
                  //         customer;
                  //     if (customer.cable.boxDetails != null &&
                  //         customer.cable.boxDetails.isNotEmpty) {
                  //       _offlineOthersPayments[_currentPayment].boxDetails =
                  //           customer.cable.boxDetails;
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
                //         customer;
                //     if (customer.cable.boxDetails != null &&
                //         customer.cable.boxDetails.isNotEmpty) {
                //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
                //           customer.cable.boxDetails;
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
                //       if (_customerList[i].id == customer.id) {
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
                //       if (_billingList[i].customerId == customer.id) {
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
                //         customer;
                //     if (customer.cable.boxDetails != null &&
                //         customer.cable.boxDetails.isNotEmpty) {
                //       _offlineInstallationPayments[_currentPayment].boxDetails =
                //           customer.cable.boxDetails;
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
                //       if (_customerList[i].id == customer.id) {
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
                //         customer;
                //     if (customer.cable.boxDetails != null &&
                //         customer.cable.boxDetails.isNotEmpty) {
                //       _offlineOthersPayments[_currentPayment].boxDetails =
                //           customer.cable.boxDetails;
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
                  paymentData.customerData = customer;
                  setState(() {
                    _isAdding = false;
                    _searchCustomer.text = "";
                    _searchText = "";
                    barcode = "";
                    pay = false;
                    searchList = [];
                    _serviceType = "cable";
                    _paymentForCable = "Subscription";
                    _paymentForInternet = "Subscription";
                    _paymentMode = "Cash";
                    _paymentForOthers = null;
                    _internetPlans = null;
                    _generateInternetInvoice = true;
                    _addInternetPayment = false;
                    _setTextField();
                    paymentView(context, paymentData, true);
                  });

                  getData();
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
                  //         .customerData = customer;
                  //     if (customer.cable.boxDetails != null &&
                  //         customer.cable.boxDetails.isNotEmpty) {
                  //       _offlineSubscriptionPayments[_currentPayment]
                  //           .boxDetails = customer.cable.boxDetails;
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
                  //       if (_customerList[i].id == customer.id) {
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
                  //       if (_billingList[i].customerId == customer.id) {
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
                  //         .customerData = customer;
                  //     if (customer.cable.boxDetails != null &&
                  //         customer.cable.boxDetails.isNotEmpty) {
                  //       _offlineInstallationPayments[_currentPayment]
                  //           .boxDetails = customer.cable.boxDetails;
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
                  //       if (_customerList[i].id == customer.id) {
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
                  //         customer;
                  //     if (customer.cable.boxDetails != null &&
                  //         customer.cable.boxDetails.isNotEmpty) {
                  //       _offlineOthersPayments[_currentPayment].boxDetails =
                  //           customer.cable.boxDetails;
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
                //         customer;
                //     if (customer.cable.boxDetails != null &&
                //         customer.cable.boxDetails.isNotEmpty) {
                //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
                //           customer.cable.boxDetails;
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
                //       if (_customerList[i].id == customer.id) {
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
                //       if (_billingList[i].customerId == customer.id) {
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
                //         customer;
                //     if (customer.cable.boxDetails != null &&
                //         customer.cable.boxDetails.isNotEmpty) {
                //       _offlineInstallationPayments[_currentPayment].boxDetails =
                //           customer.cable.boxDetails;
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
                //       if (_customerList[i].id == customer.id) {
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
                //         customer;
                //     if (customer.cable.boxDetails != null &&
                //         customer.cable.boxDetails.isNotEmpty) {
                //       _offlineOthersPayments[_currentPayment].boxDetails =
                //           customer.cable.boxDetails;
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
              paymentData.customerData = customer;
              setState(() {
                _isAdding = false;
                _searchCustomer.text = "";
                _searchText = "";
                barcode = "";
                pay = false;
                searchList = [];
                _serviceType = "cable";
                _paymentForCable = "Subscription";
                _paymentForInternet = "Subscription";
                _paymentMode = "Cash";
                _paymentForOthers = null;
                _internetPlans = null;
                _generateInternetInvoice = true;
                _addInternetPayment = false;
                _setTextField();
                paymentView(context, paymentData, true);
              });

              getData();
            } else {
              addPaymentKey.currentState.showSnackBar(new SnackBar(
                backgroundColor: Colors.redAccent[400],
                content: new Text("No Internet Connection !!"),
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
              //         customer;
              //     if (customer.cable.boxDetails != null &&
              //         customer.cable.boxDetails.isNotEmpty) {
              //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
              //           customer.cable.boxDetails;
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
              //       if (_customerList[i].id == customer.id) {
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
              //       if (_billingList[i].customerId == customer.id) {
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
              //         customer;
              //     if (customer.cable.boxDetails != null &&
              //         customer.cable.boxDetails.isNotEmpty) {
              //       _offlineInstallationPayments[_currentPayment].boxDetails =
              //           customer.cable.boxDetails;
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
              //       if (_customerList[i].id == customer.id) {
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
              //         customer;
              //     if (customer.cable.boxDetails != null &&
              //         customer.cable.boxDetails.isNotEmpty) {
              //       _offlineOthersPayments[_currentPayment].boxDetails =
              //           customer.cable.boxDetails;
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
            //         customer;
            //     if (customer.cable.boxDetails != null &&
            //         customer.cable.boxDetails.isNotEmpty) {
            //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
            //           customer.cable.boxDetails;
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
            //       if (_customerList[i].id == customer.id) {
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
            //       if (_billingList[i].customerId == customer.id) {
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
            //         customer;
            //     if (customer.cable.boxDetails != null &&
            //         customer.cable.boxDetails.isNotEmpty) {
            //       _offlineInstallationPayments[_currentPayment].boxDetails =
            //           customer.cable.boxDetails;
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
            //       if (_customerList[i].id == customer.id) {
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
            //     _offlineOthersPayments[_currentPayment].customerData = customer;
            //     if (customer.cable.boxDetails != null &&
            //         customer.cable.boxDetails.isNotEmpty) {
            //       _offlineOthersPayments[_currentPayment].boxDetails =
            //           customer.cable.boxDetails;
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
        //         customer;
        //     if (customer.cable.boxDetails != null &&
        //         customer.cable.boxDetails.isNotEmpty) {
        //       _offlineSubscriptionPayments[_currentPayment].boxDetails =
        //           customer.cable.boxDetails;
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
        //       if (_customerList[i].id == customer.id) {
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
        //       if (_billingList[i].customerId == customer.id) {
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
        //         customer;
        //     if (customer.cable.boxDetails != null &&
        //         customer.cable.boxDetails.isNotEmpty) {
        //       _offlineInstallationPayments[_currentPayment].boxDetails =
        //           customer.cable.boxDetails;
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
        //       if (_customerList[i].id == customer.id) {
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
        //     _offlineOthersPayments[_currentPayment].customerData = customer;
        //     if (customer.cable.boxDetails != null &&
        //         customer.cable.boxDetails.isNotEmpty) {
        //       _offlineOthersPayments[_currentPayment].boxDetails =
        //           customer.cable.boxDetails;
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

  getInternetBillingSetting() {
    internetBillingSettings().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          _internetBillingSettings = internetBillingSettingFromJson(
              Utf8Codec().decode(response.bodyBytes));
        });
        AppSharedPreferences.setInternetBillingSetting(
            _internetBillingSettings);
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
      });
    });
  }

  getPaymentforData() {
    paymentCategoryList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          paymentCategories =
              paymentCategorysFromJson(Utf8Codec().decode(response.bodyBytes));
        });
        AppSharedPreferences.setPaymentCategory(paymentCategories);
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
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

  Future<void> getData() async {
    await initUserProfile();
    await getOldData();
    customerList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          customers = customerFromJson(Utf8Codec().decode(response.bodyBytes));
        });
        AppSharedPreferences.setCustomers(customers);
        _isLoading = false;
      } else {
        addPaymentKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("Something went wrong !!"),
        ));
      }
    }).catchError((error) {
      addPaymentKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.redAccent[400],
        content: new Text("No Internet Connection. Loading Offline Content."),
      ));
      setState(() {
        getOldData();
        _isLoading = false;
      });
    });
    getPaymentforData();
    getInternetPlan();
    // _setAmountPaid();
  }

  getInternetPlan() {
    internetPlan().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          internetPlans =
              internetPlanFromJson(Utf8Codec().decode(response.bodyBytes));
        });
        AppSharedPreferences.setInternetPlan(internetPlans);
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
      customers = await AppSharedPreferences.getCustomers();
      _isLoading = false;
      paymentCategories = await AppSharedPreferences.getPaymentCategory();
      internetPlans = await AppSharedPreferences.getInternetPlan();
      _internetBillingSettings =
          await AppSharedPreferences.getInternetBillingSetting();
      // _setAmountPaid();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: addPaymentKey,
      appBar: new AppBar(
        title: new Text('Add Payment'),
        backgroundColor: new Color(0xffae275f),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                _searchCustomer.text = "";
                _searchText = "";
                barcode = "";
                pay = false;
                searchList = [];
              });
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      backgroundColor: Color(0xFFdae2f0),
      body: _isLoading
          ? Loader()
          : Container(
              child: Column(children: <Widget>[
              !pay ? searchCard() : emptyCard(),
              _searchCustomer.text.isEmpty ? emptyCard() : _buildList(),
              pay ? payCard(context) : emptyCard()
            ])),
    );
  }

  Widget emptyCard() => Container();

  // Widget _boxDetailView(BoxDetail boxDetails, int i) {
  //   var addons = List<TableRow>();
  //   double addonsPackageCost = 0.0;

  //   for (var i = 0; i < boxDetails.addonPackage.subPackages.length; i++) {
  //     if (boxDetails.addonPackage.subPackages[i].packageCost.isNotEmpty) {
  //       addonsPackageCost = addonsPackageCost +
  //           double.tryParse(boxDetails.addonPackage.subPackages[i].packageCost);
  //     }

  //     var addon = _addonPackList(boxDetails.addonPackage.subPackages[i]);
  //     addons.add(addon);
  //   }
  //   var channels = List<TableRow>();
  //   double channelsPackageCost = 0.0;

  //   for (var i = 0; i < boxDetails.addonPackage.channels.length; i++) {
  //     if (boxDetails.addonPackage.channels[i].channelCost.isNotEmpty) {
  //       channelsPackageCost = channelsPackageCost +
  //           double.tryParse(boxDetails.addonPackage.channels[i].channelCost);
  //     }
  //     var channel = _addonChannelList(boxDetails.addonPackage.channels[i]);
  //     channels.add(channel);
  //   }
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
  //     child: Material(
  //       color: Colors.grey[100],
  //       elevation: 2.0,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(8.0))),
  //       child: GroovinExpansionTile(
  //         defaultTrailingIconColor: Colors.indigoAccent,
  //         leading: CircleAvatar(
  //           backgroundColor: Colors.indigoAccent,
  //           child: Icon(
  //             Icons.live_tv,
  //             color: Colors.white,
  //           ),
  //         ),
  //         title: Text(
  //           "Connection-" + (i + 1).toString(),
  //           softWrap: true,
  //           style: TextStyle(color: Colors.black),
  //         ),
  //         children: <Widget>[
  //           ClipRRect(
  //             borderRadius: BorderRadius.only(
  //               bottomLeft: Radius.circular(5.0),
  //               bottomRight: Radius.circular(5.0),
  //             ),
  //             child: Column(
  //               children: <Widget>[
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 ((boxDetails.vcNo != "" && boxDetails.vcNo != null) ||
  //                         (boxDetails.nuidNo != "" &&
  //                             boxDetails.nuidNo != null) ||
  //                         (boxDetails.irdNo != "" && boxDetails.irdNo != null))
  //                     ? Card(
  //                         color: Colors.indigo,
  //                         child: Column(
  //                           children: <Widget>[
  //                             SizedBox(
  //                               height: 10,
  //                             ),
  //                             boxDetails.vcNo != "" && boxDetails.vcNo != null
  //                                 ? Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.center,
  //                                     children: <Widget>[
  //                                       Text(
  //                                         "VC Number : " + boxDetails.vcNo,
  //                                         style: TextStyle(color: Colors.white),
  //                                       ),
  //                                       Container(
  //                                         height: 17.0,
  //                                         child: IconButton(
  //                                             padding: EdgeInsets.all(0.0),
  //                                             tooltip: "VC Number Copied",
  //                                             iconSize: 14.0,
  //                                             color: Colors.white,
  //                                             icon: Icon(Icons.content_copy),
  //                                             onPressed: () {
  //                                               Clipboard.setData(
  //                                                   new ClipboardData(
  //                                                       text: boxDetails.vcNo));
  //                                             }),
  //                                       )
  //                                     ],
  //                                   )
  //                                 : Container(),
  //                             boxDetails.vcNo != "" && boxDetails.vcNo != null
  //                                 ? Divider()
  //                                 : Container(),
  //                             boxDetails.nuidNo != "" &&
  //                                     boxDetails.nuidNo != null
  //                                 ? Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.center,
  //                                     children: <Widget>[
  //                                       Text(
  //                                           "NUID Number : " +
  //                                               boxDetails.nuidNo,
  //                                           style:
  //                                               TextStyle(color: Colors.white)),
  //                                       Container(
  //                                         height: 17.0,
  //                                         child: IconButton(
  //                                             padding: EdgeInsets.all(0.0),
  //                                             tooltip: "NUID Number Copied",
  //                                             iconSize: 14.0,
  //                                             color: Colors.white,
  //                                             icon: Icon(Icons.content_copy),
  //                                             onPressed: () {
  //                                               Clipboard.setData(
  //                                                   new ClipboardData(
  //                                                       text:
  //                                                           boxDetails.nuidNo));
  //                                             }),
  //                                       )
  //                                     ],
  //                                   )
  //                                 : Container(),
  //                             boxDetails.nuidNo != "" &&
  //                                     boxDetails.nuidNo != null
  //                                 ? Divider()
  //                                 : Container(),
  //                             boxDetails.irdNo != "" && boxDetails.irdNo != null
  //                                 ? Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.center,
  //                                     children: <Widget>[
  //                                       Text("IRD Number : " + boxDetails.irdNo,
  //                                           style:
  //                                               TextStyle(color: Colors.white)),
  //                                       Container(
  //                                         height: 17.0,
  //                                         child: IconButton(
  //                                             padding: EdgeInsets.all(0.0),
  //                                             tooltip: "IRD Number Copied",
  //                                             iconSize: 14.0,
  //                                             color: Colors.white,
  //                                             icon: Icon(Icons.content_copy),
  //                                             onPressed: () {
  //                                               Clipboard.setData(
  //                                                   new ClipboardData(
  //                                                       text:
  //                                                           boxDetails.irdNo));
  //                                             }),
  //                                       )
  //                                     ],
  //                                   )
  //                                 : Container(),
  //                             SizedBox(
  //                               height: 10,
  //                             )
  //                           ],
  //                         ))
  //                     : Container(),
  //                 boxDetails.msoId == null ? Container() : Divider(),
  //                 boxDetails.msoId == null
  //                     ? Container()
  //                     : Row(
  //                         children: <Widget>[
  //                           Container(
  //                             width: 5.0,
  //                           ),
  //                           Text(boxDetails.msoId == null ? '' : "MSO : "),
  //                           Expanded(
  //                               child: Text(boxDetails.msoId == null
  //                                   ? ''
  //                                   : boxDetails.msoId)),
  //                           Container(
  //                             width: 5.0,
  //                           ),
  //                         ],
  //                       ),
  //                 boxDetails.msoId == null ? Container() : Divider(),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 (boxDetails.mainPackage.packageCost != null &&
  //                         boxDetails.addonPackage.packageCost != null &&
  //                         boxDetails.mainPackage.packageCost != "" &&
  //                         boxDetails.addonPackage.packageCost != "")
  //                     ? Table(
  //                         border: TableBorder.all(
  //                             width: 1.0, color: Colors.black45),
  //                         children: [
  //                           TableRow(children: [
  //                             TableCell(
  //                               child: Row(
  //                                 mainAxisAlignment:
  //                                     MainAxisAlignment.spaceAround,
  //                                 children: <Widget>[
  //                                   SizedBox(
  //                                     child: Icon(
  //                                       Icons.keyboard_arrow_down,
  //                                       color: Colors.black54,
  //                                     ),
  //                                     width: 15.0,
  //                                   ),
  //                                   SizedBox(
  //                                       child: Text(
  //                                         "Subscription",
  //                                         style: TextStyle(
  //                                             fontWeight: FontWeight.bold),
  //                                       ),
  //                                       width: 100.0),
  //                                   SizedBox(
  //                                     child: Text(
  //                                       "MRP",
  //                                       style: TextStyle(
  //                                           fontWeight: FontWeight.bold),
  //                                       textAlign: TextAlign.right,
  //                                     ),
  //                                     width: 60.0,
  //                                   ),
  //                                   SizedBox(
  //                                     child: Text(
  //                                       "GST",
  //                                       style: TextStyle(
  //                                           fontWeight: FontWeight.bold),
  //                                       textAlign: TextAlign.right,
  //                                     ),
  //                                     width: 60.0,
  //                                   ),
  //                                   SizedBox(
  //                                     child: Text(
  //                                       "Total",
  //                                       style: TextStyle(
  //                                           fontWeight: FontWeight.bold),
  //                                       textAlign: TextAlign.right,
  //                                     ),
  //                                     width: 60.0,
  //                                   ),
  //                                 ],
  //                               ),
  //                             )
  //                           ]),
  //                           boxDetails.mainPackage.packageName != null
  //                               ? TableRow(children: [
  //                                   TableCell(
  //                                     child: Row(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.spaceAround,
  //                                       children: <Widget>[
  //                                         SizedBox(
  //                                           child: Icon(
  //                                             Icons.keyboard_arrow_right,
  //                                             color: Colors.black54,
  //                                           ),
  //                                           width: 15.0,
  //                                         ),
  //                                         SizedBox(
  //                                           child: Text(boxDetails
  //                                               .mainPackage.packageName),
  //                                           width: 100.0,
  //                                         ),
  //                                         SizedBox(
  //                                           child: Text(
  //                                             (formatter.format(double.tryParse(
  //                                                     boxDetails.mainPackage
  //                                                         .packageCost)))
  //                                                 .toString(),
  //                                             textAlign: TextAlign.right,
  //                                           ),
  //                                           width: 50.0,
  //                                         ),
  //                                         SizedBox(
  //                                           child: Text(
  //                                             (formatter.format((18 / 100) *
  //                                                     double.tryParse(boxDetails
  //                                                         .mainPackage
  //                                                         .packageCost)))
  //                                                 .toString(),
  //                                             textAlign: TextAlign.right,
  //                                           ),
  //                                           width: 60.0,
  //                                         ),
  //                                         SizedBox(
  //                                           child: Text(
  //                                             (formatter.format(((18 / 100) *
  //                                                         double.tryParse(
  //                                                             boxDetails
  //                                                                 .mainPackage
  //                                                                 .packageCost)) +
  //                                                     double.tryParse(boxDetails
  //                                                         .mainPackage
  //                                                         .packageCost)))
  //                                                 .toString(),
  //                                             textAlign: TextAlign.right,
  //                                           ),
  //                                           width: 60.0,
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   )
  //                                 ])
  //                               : TableRow(children: [
  //                                   TableCell(
  //                                     child: Row(),
  //                                   )
  //                                 ]),
  //                         ],
  //                       )
  //                     : Container(),
  //                 SizedBox(
  //                   height: 1.0,
  //                 ),
  //                 addons != null && addons.length > 0
  //                     ? Table(
  //                         border: TableBorder.all(
  //                             width: 1.0, color: Colors.black45),
  //                         children: addons)
  //                     : Container(),
  //                 addons != null && addons.length > 0
  //                     ? SizedBox(
  //                         height: 0.5,
  //                       )
  //                     : Container(),
  //                 channels != null && channels.length > 0
  //                     ? Table(
  //                         border: TableBorder.all(
  //                             width: 1.0, color: Colors.black45),
  //                         children: channels)
  //                     : Container(),
  //                 channels != null && channels.length > 0
  //                     ? SizedBox(
  //                         height: 1.0,
  //                       )
  //                     : Container(),
  //                 (boxDetails.mainPackage.packageCost != null &&
  //                         boxDetails.addonPackage.packageCost != null &&
  //                         boxDetails.mainPackage.packageCost != "" &&
  //                         boxDetails.addonPackage.packageCost != "")
  //                     ? Table(
  //                         border: TableBorder.all(
  //                             width: 1.0, color: Colors.black45),
  //                         children: [
  //                             TableRow(children: [
  //                               TableCell(
  //                                 child: Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceAround,
  //                                   children: <Widget>[
  //                                     SizedBox(
  //                                       child: Icon(
  //                                         Icons.keyboard_arrow_right,
  //                                         color: Colors.black,
  //                                       ),
  //                                       width: 15.0,
  //                                     ),
  //                                     SizedBox(
  //                                       child: Text("Total",
  //                                           style: TextStyle(
  //                                               fontWeight: FontWeight.bold)),
  //                                       width: 100.0,
  //                                     ),
  //                                     SizedBox(
  //                                       child: Text(
  //                                         (formatter.format(double.tryParse(
  //                                                     boxDetails.mainPackage
  //                                                         .packageCost) +
  //                                                 addonsPackageCost +
  //                                                 channelsPackageCost))
  //                                             .toString(),
  //                                         // (formatter.format(double.tryParse(box
  //                                         //             .mainPackage.packageCost) +
  //                                         //         double.tryParse(box
  //                                         //             .addonPackage.packageCost)))
  //                                         //     .toString(),
  //                                         style: TextStyle(
  //                                             fontWeight: FontWeight.bold),
  //                                         textAlign: TextAlign.right,
  //                                       ),
  //                                       width: 50.0,
  //                                     ),
  //                                     SizedBox(
  //                                       child: Text(
  //                                         (formatter.format((18 / 100) *
  //                                                 (double.tryParse(boxDetails
  //                                                         .mainPackage
  //                                                         .packageCost) +
  //                                                     addonsPackageCost +
  //                                                     channelsPackageCost)))
  //                                             .toString(),
  //                                         // (formatter.format((18 / 100) *
  //                                         //         (double.tryParse(box.mainPackage
  //                                         //                 .packageCost) +
  //                                         //             double.tryParse(box
  //                                         //                 .addonPackage
  //                                         //                 .packageCost))))
  //                                         //     .toString(),
  //                                         style: TextStyle(
  //                                             fontWeight: FontWeight.bold),
  //                                         textAlign: TextAlign.right,
  //                                       ),
  //                                       width: 60.0,
  //                                     ),
  //                                     SizedBox(
  //                                       child: Text(
  //                                         (formatter.format(((18 / 100) *
  //                                                     (double.tryParse(boxDetails
  //                                                             .mainPackage
  //                                                             .packageCost) +
  //                                                         addonsPackageCost +
  //                                                         channelsPackageCost)) +
  //                                                 (double.tryParse(boxDetails
  //                                                         .mainPackage
  //                                                         .packageCost) +
  //                                                     addonsPackageCost +
  //                                                     channelsPackageCost)))
  //                                             .toString(),
  //                                         style: TextStyle(
  //                                             fontWeight: FontWeight.bold),
  //                                         textAlign: TextAlign.right,
  //                                       ),
  //                                       width: 60.0,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               )
  //                             ])
  //                           ])
  //                     : Container(),
  //                 SizedBox(
  //                   height: 10.0,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: <Widget>[
  //                     RaisedButton(
  //                       color: Colors.purple,
  //                       shape: StadiumBorder(),
  //                       onPressed: () {
  //                         print("Edit");
  //                       },
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: <Widget>[
  //                           Icon(
  //                             Icons.edit,
  //                             size: 20.0,
  //                             color: Colors.white,
  //                           ),
  //                           Container(
  //                             width: 10.0,
  //                           ),
  //                           Text(
  //                             "Edit Package",
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // _addonPackList(Package addon) {
  //   if (addon.packageName != null && addon.packageCost != null) {
  //     return TableRow(children: [
  //       TableCell(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: <Widget>[
  //             SizedBox(
  //               child: Icon(
  //                 Icons.keyboard_arrow_right,
  //                 color: Colors.black54,
  //               ),
  //               width: 15.0,
  //             ),
  //             SizedBox(
  //               child: Text(addon.packageName),
  //               width: 100.0,
  //             ),
  //             SizedBox(
  //               child: Text(
  //                 (formatter.format(double.tryParse(addon.packageCost)))
  //                     .toString(),
  //                 textAlign: TextAlign.right,
  //               ),
  //               width: 50.0,
  //             ),
  //             SizedBox(
  //               child: Text(
  //                 (formatter.format(
  //                         (18 / 100) * double.tryParse(addon.packageCost)))
  //                     .toString(),
  //                 textAlign: TextAlign.right,
  //               ),
  //               width: 60.0,
  //             ),
  //             SizedBox(
  //               child: Text(
  //                 (formatter.format(
  //                         ((18 / 100) * double.tryParse(addon.packageCost)) +
  //                             double.tryParse(addon.packageCost)))
  //                     .toString(),
  //                 textAlign: TextAlign.right,
  //               ),
  //               width: 60.0,
  //             ),
  //           ],
  //         ),
  //       )
  //     ]);
  //   } else {
  //     return TableRow(children: [
  //       TableCell(
  //         child: Row(),
  //       )
  //     ]);
  //   }
  // }

  // _addonChannelList(AddonPackageChannel channel) {
  //   if (channel.channelName != null) {
  //     return TableRow(children: [
  //       TableCell(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: <Widget>[
  //             SizedBox(
  //               child: Icon(
  //                 Icons.keyboard_arrow_right,
  //                 color: Colors.black54,
  //               ),
  //               width: 15.0,
  //             ),
  //             SizedBox(
  //               child: Text(channel.channelName),
  //               width: 100.0,
  //             ),
  //             SizedBox(
  //               child: Text(
  //                 (formatter.format(double.tryParse(channel.channelCost)))
  //                     .toString(),
  //                 textAlign: TextAlign.right,
  //               ),
  //               width: 50.0,
  //             ),
  //             SizedBox(
  //               child: Text(
  //                 (formatter.format(
  //                         (18 / 100) * double.tryParse(channel.channelCost)))
  //                     .toString(),
  //                 textAlign: TextAlign.right,
  //               ),
  //               width: 60.0,
  //             ),
  //             SizedBox(
  //               child: Text(
  //                 (formatter.format(
  //                         ((18 / 100) * double.tryParse(channel.channelCost)) +
  //                             double.tryParse(channel.channelCost)))
  //                     .toString(),
  //                 textAlign: TextAlign.right,
  //               ),
  //               width: 60.0,
  //             ),
  //           ],
  //         ),
  //       )
  //     ]);
  //   } else {
  //     return TableRow(children: [
  //       TableCell(
  //         child: Row(),
  //       )
  //     ]);
  //   }
  // }

  // editBouquetChannel() {
  //   return Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Container(
  //           height: 5.0,
  //         ),
  //         Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
  //           Expanded(
  //             child: Container(
  //               decoration: BoxDecoration(
  //                   color: isBouquetChannel == true
  //                       ? Color(0xffae275f)
  //                       : Colors.white,
  //                   borderRadius: BorderRadius.circular(0.0)),
  //               child: IconButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       isBouquetChannel = true;
  //                     });
  //                   },
  //                   icon: Text(
  //                     "Bouquet/Add On List",
  //                     style: TextStyle(
  //                       color: isBouquetChannel == true
  //                           ? Colors.white
  //                           : Colors.black,
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   )),
  //             ),
  //           ),
  //           Expanded(
  //             child: Container(
  //               decoration: BoxDecoration(
  //                   color: isBouquetChannel == false
  //                       ? Color(0xffae275f)
  //                       : Colors.white,
  //                   borderRadius: BorderRadius.circular(0.0)),
  //               child: IconButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       isBouquetChannel = false;
  //                     });
  //                   },
  //                   icon: Text(
  //                     "Channel List",
  //                     style: TextStyle(
  //                       color: isBouquetChannel == false
  //                           ? Colors.white
  //                           : Colors.black,
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   )),
  //             ),
  //           ),
  //         ]),
  //         isBouquetChannel == true ? bouquetSearchBar() : channelSearchBar(),
  //         Container(
  //           height: 10.0,
  //         ),
  //         isBouquetChannel == true
  //             ? Container(
  //                 child: (_searchBouquetPackage.text.isEmpty)
  //                     ? bouquetListView()
  //                     : bouquetBuildList())
  //             : Container(
  //                 child: (_searchChannel.text.isEmpty)
  //                     ? channelListView()
  //                     : channelBuildList()),
  //         Container(
  //             child: Align(
  //                 alignment: FractionalOffset.bottomCenter,
  //                 child: Container(
  //                     child: Column(
  //                   children: <Widget>[
  //                     Divider(),
  //                     Row(
  //                       children: <Widget>[
  //                         Container(
  //                           width: 10.0,
  //                         ),
  //                         Expanded(
  //                           child: FloatingActionButton(
  //                             mini: true,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(5.0),
  //                               side: BorderSide(
  //                                 color: Color(0xffae275f),
  //                                 width: 1.0,
  //                               ),
  //                             ),
  //                             backgroundColor: Colors.white,
  //                             foregroundColor: Color(0xffae275f),
  //                             onPressed: () {
  //                               _onBackPressedCustomerEdit();
  //                             },
  //                             child: Text("Cancel"),
  //                           ),
  //                         ),
  //                         Container(
  //                           height: 20.0,
  //                           width: 1.0,
  //                           color: Colors.black38,
  //                           margin:
  //                               const EdgeInsets.only(left: 10.0, right: 10.0),
  //                         ),
  //                         Expanded(
  //                           child: FloatingActionButton(
  //                             mini: true,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(5.0),
  //                               side: BorderSide(
  //                                 color: Color.fromARGB(255, 41, 153, 102),
  //                                 width: 1.0,
  //                               ),
  //                             ),
  //                             backgroundColor: Colors.white,
  //                             foregroundColor:
  //                                 Color.fromARGB(255, 41, 153, 102),
  //                             onPressed: () {
  //                               setState(() {
  //                                 isEditBouquetChannelDetails = false;
  //                                 isEditInternetDetails = false;
  //                                 double totalSubpackageCost = 0.0;
  //                                 double totalChannelCost = 0.0;
  //                                 for (var i = 0;
  //                                     i <
  //                                         _customerCard
  //                                             .cable
  //                                             .boxDetails[_selectedBouquet]
  //                                             .addonPackage
  //                                             .subPackages
  //                                             .length;
  //                                     i++) {
  //                                   if (_customerCard
  //                                               .cable
  //                                               .boxDetails[_selectedBouquet]
  //                                               .addonPackage
  //                                               .subPackages[i]
  //                                               .packageCost !=
  //                                           null &&
  //                                       _customerCard
  //                                           .cable
  //                                           .boxDetails[_selectedBouquet]
  //                                           .addonPackage
  //                                           .subPackages[i]
  //                                           .packageCost
  //                                           .isNotEmpty &&
  //                                       _customerCard
  //                                               .cable
  //                                               .boxDetails[_selectedBouquet]
  //                                               .addonPackage
  //                                               .subPackages[i]
  //                                               .packageCost !=
  //                                           "") {
  //                                     totalSubpackageCost = double.tryParse(
  //                                             _customerCard
  //                                                 .cable
  //                                                 .boxDetails[_selectedBouquet]
  //                                                 .addonPackage
  //                                                 .subPackages[i]
  //                                                 .packageCost) +
  //                                         totalSubpackageCost;
  //                                   }
  //                                 }
  //                                 for (var i = 0;
  //                                     i <
  //                                         _customerCard
  //                                             .cable
  //                                             .boxDetails[_selectedBouquet]
  //                                             .addonPackage
  //                                             .channels
  //                                             .length;
  //                                     i++) {
  //                                   if (_customerCard
  //                                               .cable
  //                                               .boxDetails[_selectedBouquet]
  //                                               .addonPackage
  //                                               .channels[i]
  //                                               .channelCost !=
  //                                           null &&
  //                                       _customerCard
  //                                           .cable
  //                                           .boxDetails[_selectedBouquet]
  //                                           .addonPackage
  //                                           .channels[i]
  //                                           .channelCost
  //                                           .isNotEmpty &&
  //                                       _customerCard
  //                                               .cable
  //                                               .boxDetails[_selectedBouquet]
  //                                               .addonPackage
  //                                               .channels[i]
  //                                               .channelCost !=
  //                                           "") {
  //                                     totalChannelCost = double.tryParse(
  //                                             _customerCard
  //                                                 .cable
  //                                                 .boxDetails[_selectedBouquet]
  //                                                 .addonPackage
  //                                                 .channels[i]
  //                                                 .channelCost) +
  //                                         totalChannelCost;
  //                                   }
  //                                 }
  //                                 _customerCard
  //                                         .cable
  //                                         .boxDetails[_selectedBouquet]
  //                                         .addonPackage
  //                                         .packageCost =
  //                                     (totalSubpackageCost + totalChannelCost)
  //                                         .toString();
  //                                 setCableRent();
  //                               });
  //                             },
  //                             child: Text("Save"),
  //                           ),
  //                         ),
  //                         Container(
  //                           width: 5.0,
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 )))),
  //       ]);
  // }

  // bouquetListView() {
  //   if (addOnPackage != null) {
  //     setState(() {
  //       if (isBouquetSelected) {
  //         addOnPackage.sort(
  //             (a, b) => a.selected.toString().compareTo(b.selected.toString()));
  //         addOnPackage = addOnPackage.reversed.toList();
  //       } else {
  //         addOnPackage.sort((a, b) => a.packageName.compareTo(b.packageName));
  //       }
  //     });
  //   }

  //   return Expanded(
  //     child: new ListView.builder(
  //         itemCount: addOnPackage == null ? 0 : addOnPackage.length,
  //         itemBuilder: (BuildContext context, int i) {
  //           return bouquetView(addOnPackage[i]);
  //         }),
  //   );
  // }

  // bouquetView(AddOnPackage _addOnPackage) {
  //   return InkWell(
  //       onTap: () => showBouquetPackage(_addOnPackage),
  //       child: Card(
  //         elevation: 5.0,
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
  //         margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
  //         child: Container(
  //             decoration: BoxDecoration(
  //                 color: Color.fromRGBO(64, 75, 96, .9),
  //                 borderRadius: BorderRadius.circular(5.0)),
  //             child: ListTile(
  //               contentPadding:
  //                   EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
  //               title: Row(children: <Widget>[
  //                 Expanded(
  //                   child: Text(
  //                     _addOnPackage.packageName,
  //                     style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 18.0),
  //                   ),
  //                 ),
  //                 Theme(
  //                   data: Theme.of(context).copyWith(
  //                     unselectedWidgetColor: Colors.white,
  //                   ),
  //                   child: Checkbox(
  //                     value: _addOnPackage.selected,
  //                     onChanged: (value) {
  //                       setState(() {
  //                         if (value == true) {
  //                           _addOnPackage.selected = value;
  //                           _customerCard.cable.boxDetails[_selectedBouquet]
  //                               .addonPackage.subPackages
  //                               .add(Package(
  //                                   billable: "Repeat",
  //                                   channels: [],
  //                                   packageCost:
  //                                       _addOnPackage.packagecost.toString(),
  //                                   packageId: _addOnPackage.packageId,
  //                                   packageName: _addOnPackage.packageName));
  //                           for (var i = 0;
  //                               i <
  //                                   _customerCard
  //                                       .cable
  //                                       .boxDetails[_selectedBouquet]
  //                                       .addonPackage
  //                                       .subPackages
  //                                       .length;
  //                               i++) {
  //                             if (_addOnPackage.packageId ==
  //                                 _customerCard
  //                                     .cable
  //                                     .boxDetails[_selectedBouquet]
  //                                     .addonPackage
  //                                     .subPackages[i]
  //                                     .packageId) {
  //                               for (var j = 0;
  //                                   j < _addOnPackage.channels.length;
  //                                   j++) {
  //                                 _customerCard
  //                                     .cable
  //                                     .boxDetails[_selectedBouquet]
  //                                     .addonPackage
  //                                     .subPackages[i]
  //                                     .channels
  //                                     .add(MainPackageChannel(
  //                                         id: _addOnPackage.channels[j].id,
  //                                         name:
  //                                             _addOnPackage.channels[j].name));
  //                               }
  //                             }
  //                           }
  //                           editPackageDetails();
  //                         } else {
  //                           _addOnPackage.selected = value;
  //                           for (var i = 0;
  //                               i <
  //                                   _customerCard
  //                                       .cable
  //                                       .boxDetails[_selectedBouquet]
  //                                       .addonPackage
  //                                       .subPackages
  //                                       .length;
  //                               i++) {
  //                             if (_addOnPackage.packageId ==
  //                                 _customerCard
  //                                     .cable
  //                                     .boxDetails[_selectedBouquet]
  //                                     .addonPackage
  //                                     .subPackages[i]
  //                                     .packageId) {
  //                               _customerCard.cable.boxDetails[_selectedBouquet]
  //                                   .addonPackage.subPackages
  //                                   .remove(_customerCard
  //                                       .cable
  //                                       .boxDetails[_selectedBouquet]
  //                                       .addonPackage
  //                                       .subPackages[i]);
  //                             }
  //                           }
  //                           editPackageDetails();
  //                         }
  //                       });
  //                     },
  //                     activeColor: Color(0xffae275f),
  //                   ),
  //                 ),
  //               ]),
  //               subtitle: Column(
  //                 children: <Widget>[
  //                   Row(
  //                     children: <Widget>[
  //                       Expanded(
  //                           child: Text(
  //                               "Rs. " + _addOnPackage.packagecost.toString(),
  //                               style: TextStyle(
  //                                   fontSize: 18.0,
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.yellow))),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             )),
  //       ));
  // }

  // showBouquetPackage(AddOnPackage _addOnPackage) {
  //   var boxes = List<Widget>();
  //   _addOnPackage.channels.sort((a, b) => (a.name).compareTo(b.name));

  //   if (_addOnPackage.channels.isNotEmpty || _addOnPackage.channels != null) {
  //     for (var i = 0; i < _addOnPackage.channels.length; i++) {
  //       var box = Container(
  //           padding: EdgeInsets.symmetric(vertical: 5.0),
  //           child: Text(_addOnPackage.channels[i].name,
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)));
  //       boxes.add(box);
  //     }
  //   }
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => Center(
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   Container(
  //                     width: double.infinity,
  //                     padding: const EdgeInsets.all(16.0),
  //                     child: Material(
  //                       clipBehavior: Clip.antiAlias,
  //                       elevation: 2.0,
  //                       borderRadius: BorderRadius.circular(4.0),
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(10.0),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                           children: <Widget>[
  //                             ListTile(
  //                               trailing: Text(
  //                                   "Rs. " +
  //                                       _addOnPackage.packagecost.toString(),
  //                                   textAlign: TextAlign.right,
  //                                   style: TextStyle(
  //                                       fontSize: 20.0,
  //                                       fontWeight: FontWeight.bold,
  //                                       color: Colors.deepOrange)),
  //                               dense: true,
  //                               leading: Container(
  //                                   decoration: BoxDecoration(
  //                                       borderRadius:
  //                                           BorderRadius.circular(50.0),
  //                                       border: Border.all(
  //                                           width: 2.0, color: Colors.green)),
  //                                   child: CircleAvatar(
  //                                     radius: 20.0,
  //                                     child: Text(
  //                                       _addOnPackage.packageName[0],
  //                                       style: TextStyle(
  //                                           fontWeight: FontWeight.bold,
  //                                           fontSize: 26.0),
  //                                     ),
  //                                   )),
  //                               title: Text(
  //                                   _addOnPackage.packageName.toUpperCase(),
  //                                   style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                       fontSize: 20.0)),
  //                               subtitle: Text(_addOnPackage.packageType,
  //                                   style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                       fontSize: 18.0)),
  //                             ),
  //                             Divider(),
  //                             Material(
  //                               elevation: 2.0,
  //                               shape: RoundedRectangleBorder(
  //                                   borderRadius:
  //                                       BorderRadius.all(Radius.circular(8.0))),
  //                               child: GroovinExpansionTile(
  //                                 initiallyExpanded: true,
  //                                 defaultTrailingIconColor: Colors.indigoAccent,
  //                                 leading: CircleAvatar(
  //                                   backgroundColor: Colors.indigoAccent,
  //                                   child: Icon(
  //                                     Icons.live_tv,
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                                 title: Text(
  //                                   "List Of Channels",
  //                                   textAlign: TextAlign.center,
  //                                   softWrap: true,
  //                                   style: TextStyle(
  //                                       color: Colors.black,
  //                                       fontWeight: FontWeight.bold,
  //                                       fontSize: 20.0),
  //                                 ),
  //                                 children: <Widget>[
  //                                   ClipRRect(
  //                                     borderRadius: BorderRadius.only(
  //                                       bottomLeft: Radius.circular(5.0),
  //                                       bottomRight: Radius.circular(5.0),
  //                                     ),
  //                                     child: Column(
  //                                       children: boxes,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 10.0,
  //                   ),
  //                   FloatingActionButton(
  //                     backgroundColor: Colors.black,
  //                     child: Icon(
  //                       Icons.clear,
  //                       color: Colors.white,
  //                     ),
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ));
  // }

  // bouquetSearchBar() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: <Widget>[
  //       Container(
  //         width: 10.0,
  //       ),
  //       Expanded(
  //         child: TextFormField(
  //           controller: _searchBouquetPackage,
  //           decoration: InputDecoration(
  //             labelText: "Search Bouquet/Add On",
  //             labelStyle: TextStyle(color: Colors.blueGrey[400]),
  //             suffixIcon: Icon(
  //               Icons.search,
  //             ),
  //           ),
  //           cursorColor: Colors.blueGrey,
  //           style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
  //         ),
  //       ),
  //       Container(
  //         width: 10.0,
  //       ),
  //       Text("Show Selected"),
  //       Container(
  //         width: 5.0,
  //       ),
  //       Checkbox(
  //         value: isBouquetSelected,
  //         onChanged: (value) {
  //           setState(() {
  //             isBouquetSelected = value;
  //           });
  //         },
  //         activeColor: Color(0xffae275f),
  //       ),
  //     ],
  //   );
  // }

  // bouquetBuildList() {
  //   List<AddOnPackage> tempBouquetAddOnList = [];
  //   if (_searchBouquetPackageText.isNotEmpty) {
  //     for (int i = 0; i < addOnPackage.length; i++) {
  //       try {
  //         if (addOnPackage[i]
  //             .packageName
  //             .toLowerCase()
  //             .contains(_searchBouquetPackageText.toLowerCase())) {
  //           tempBouquetAddOnList.add(addOnPackage[i]);
  //         }
  //       } catch (error) {
  //         print(error);
  //       }
  //     }
  //   }

  //   searchBouquetPackageList = tempBouquetAddOnList;
  //   if (searchBouquetPackageList != null) {
  //     setState(() {
  //       if (isBouquetSelected) {
  //         searchBouquetPackageList.sort(
  //             (a, b) => a.selected.toString().compareTo(b.selected.toString()));
  //         searchBouquetPackageList = searchBouquetPackageList.reversed.toList();
  //       } else {
  //         searchBouquetPackageList
  //             .sort((a, b) => a.packageName.compareTo(b.packageName));
  //       }
  //     });
  //   }
  //   return Expanded(
  //     child: new ListView.builder(
  //         itemCount: searchBouquetPackageList == null
  //             ? 0
  //             : searchBouquetPackageList.length,
  //         itemBuilder: (BuildContext context, int i) {
  //           return bouquetView(searchBouquetPackageList[i]);
  //         }),
  //   );
  // }

  // channelListView() {
  //   if (channel != null) {
  //     setState(() {
  //       if (isChannelSelected) {
  //         channel.sort(
  //             (a, b) => a.selected.toString().compareTo(b.selected.toString()));
  //         channel = channel.reversed.toList();
  //       } else {
  //         channel.sort((a, b) => a.channelName.compareTo(b.channelName));
  //       }
  //     });
  //   }
  //   return Expanded(
  //     child: new ListView.builder(
  //         itemCount: channel == null ? 0 : channel.length,
  //         itemBuilder: (BuildContext context, int i) {
  //           return channelView(channel[i]);
  //         }),
  //   );
  // }

  // channelView(Channel _channel) {
  //   return InkWell(
  //       child: Card(
  //     elevation: 5.0,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
  //     margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
  //     child: Container(
  //         decoration: BoxDecoration(
  //             color: Color.fromRGBO(64, 75, 96, .9),
  //             borderRadius: BorderRadius.circular(5.0)),
  //         child: ListTile(
  //           contentPadding:
  //               EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
  //           title: Row(children: <Widget>[
  //             Expanded(
  //               child: Text(
  //                 _channel.channelName,
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 18.0),
  //               ),
  //             ),
  //             _channel.package == true
  //                 ? Text(
  //                     "(Included In Bouquet)",
  //                     textAlign: TextAlign.end,
  //                     style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 12.0),
  //                   )
  //                 : Container(),
  //             Theme(
  //               data: Theme.of(context).copyWith(
  //                 unselectedWidgetColor: Colors.white,
  //               ),
  //               child: Checkbox(
  //                 value: _channel.selected,
  //                 onChanged: (value) {
  //                   setState(() {
  //                     if (value == true) {
  //                       _channel.selected = value;
  //                       _customerCard.cable.boxDetails[_selectedBouquet]
  //                           .addonPackage.channels
  //                           .add(AddonPackageChannel(
  //                               billable: "Repeat",
  //                               channelCost: _channel.price.toString(),
  //                               channelId: _channel.channelId,
  //                               channelName: _channel.channelName));
  //                       editPackageDetails();
  //                     } else {
  //                       _channel.selected = value;
  //                       for (var i = 0;
  //                           i <
  //                               _customerCard.cable.boxDetails[_selectedBouquet]
  //                                   .addonPackage.channels.length;
  //                           i++) {
  //                         if (_customerCard.cable.boxDetails[_selectedBouquet]
  //                                 .addonPackage.channels[i].channelId ==
  //                             _channel.channelId) {
  //                           _customerCard.cable.boxDetails[_selectedBouquet]
  //                               .addonPackage.channels
  //                               .remove(_customerCard
  //                                   .cable
  //                                   .boxDetails[_selectedBouquet]
  //                                   .addonPackage
  //                                   .channels[i]);
  //                         }
  //                       }
  //                       editPackageDetails();
  //                     }
  //                   });
  //                 },
  //                 activeColor: Color(0xffae275f),
  //               ),
  //             ),
  //           ]),
  //           subtitle: Column(
  //             children: <Widget>[
  //               Row(
  //                 children: <Widget>[
  //                   Expanded(
  //                       child: Text("Rs. " + _channel.price.toString(),
  //                           style: TextStyle(
  //                               fontSize: 18.0,
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.yellow))),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         )),
  //   ));
  // }

  // channelSearchBar() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: <Widget>[
  //       Container(
  //         width: 10.0,
  //       ),
  //       Expanded(
  //         child: TextFormField(
  //           controller: _searchChannel,
  //           decoration: InputDecoration(
  //               labelText: "Search Channel",
  //               labelStyle: TextStyle(color: Colors.blueGrey[400]),
  //               suffixIcon: Icon(Icons.search)),
  //           cursorColor: Colors.blueGrey,
  //           style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
  //         ),
  //       ),
  //       Container(
  //         width: 10.0,
  //       ),
  //       Text("Show Selected"),
  //       Container(
  //         width: 5.0,
  //       ),
  //       Checkbox(
  //         value: isChannelSelected,
  //         onChanged: (value) {
  //           setState(() {
  //             isChannelSelected = value;
  //           });
  //         },
  //         activeColor: Color(0xffae275f),
  //       ),
  //     ],
  //   );
  // }

  // channelBuildList() {
  //   List<Channel> tempChannelList = [];
  //   if (_searchChannelText.isNotEmpty) {
  //     for (int i = 0; i < channel.length; i++) {
  //       try {
  //         if (channel[i]
  //             .channelName
  //             .toLowerCase()
  //             .contains(_searchChannelText.toLowerCase())) {
  //           tempChannelList.add(channel[i]);
  //         }
  //       } catch (error) {
  //         print(error);
  //       }
  //     }
  //   }

  //   searchChannelList = tempChannelList;
  //   if (searchChannelList != null) {
  //     setState(() {
  //       if (isChannelSelected) {
  //         searchChannelList.sort(
  //             (a, b) => a.selected.toString().compareTo(b.selected.toString()));
  //         searchChannelList = searchChannelList.reversed.toList();
  //       } else {
  //         searchChannelList
  //             .sort((a, b) => a.channelName.compareTo(b.channelName));
  //       }
  //     });
  //   }
  //   return Expanded(
  //     child: new ListView.builder(
  //         itemCount: searchChannelList == null ? 0 : searchChannelList.length,
  //         itemBuilder: (BuildContext context, int i) {
  //           return channelView(searchChannelList[i]);
  //         }),
  //   );
  // }

  Widget payCard(BuildContext context) {
    // var boxes = List<Widget>();

    // for (var i = 0; i < customer.cable.boxDetails.length; i++) {
    //   var box = _boxDetailView(customer.cable.boxDetails[i], i);
    //   boxes.add(box);
    // }
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
                                  color: customer.activeStatus == true
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            Container(
                                width: 300,
                                child: Text(
                                  customer.customerName.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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
                                    customer.address.area +
                                    ' ' +
                                    customer.address.city,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  customer.cable.noCableConnection != null &&
                                          customer.cable.noCableConnection > 0
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
                                                      _outstanding = customer
                                                          .cable
                                                          .cableOutstandingAmount;
                                                    }
                                                    if (_serviceType ==
                                                        'internet') {
                                                      if (customer.internet
                                                              .internetOutstandingAmount !=
                                                          null) {
                                                        _outstanding = customer
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
                                                          customer.internet
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
                                                          customer.internet
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
                                  customer.internet.noInternetConnection !=
                                              null &&
                                          customer.internet
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
                                                      _outstanding = customer
                                                          .cable
                                                          .cableOutstandingAmount;
                                                    }
                                                    if (_serviceType ==
                                                        'internet') {
                                                      if (customer.internet
                                                              .internetOutstandingAmount !=
                                                          null) {
                                                        _outstanding = customer
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
                                                          customer.internet
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
                                                          customer.internet
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
                                                _outstanding = customer.cable
                                                    .cableOutstandingAmount;
                                              }
                                              if (_serviceType == 'internet') {
                                                if (customer.internet
                                                        .internetOutstandingAmount !=
                                                    null) {
                                                  _outstanding = customer
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
                                                    customer
                                                        .internet.planName) {
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
                                                    customer.internet
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
                                // _internetBillingSettings == null ||
                                //         _internetBillingSettings.isEmpty
                                //     ? Container()
                                //     : _internetBillingSettings[0].billingType ==
                                //             "Pre paid"
                                //         ? Row(
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment.center,
                                //             children: <Widget>[
                                //                 Expanded(
                                //                   child: Container(
                                //                     child: RaisedButton(
                                //                       shape: StadiumBorder(),
                                //                       // splashColor: Colors.green,
                                //                       child: Text(
                                //                         "Generate Invoice",
                                //                         style: TextStyle(
                                //                             color:
                                //                                 Colors.white),
                                //                       ),
                                //                       color:
                                //                           _generateInternetInvoice ==
                                //                                   true
                                //                               ? Color(
                                //                                   0xffae275f)
                                //                               : Colors.grey,
                                //                       onPressed: () {
                                //                         setState(() {
                                //                           if (_serviceType ==
                                //                               'cable') {
                                //                             _outstanding = customer
                                //                                 .cable
                                //                                 .cableOutstandingAmount;
                                //                           }
                                //                           if (_serviceType ==
                                //                               'internet') {
                                //                             if (customer
                                //                                     .internet
                                //                                     .internetOutstandingAmount !=
                                //                                 null) {
                                //                               _outstanding =
                                //                                   customer
                                //                                       .internet
                                //                                       .internetOutstandingAmount;
                                //                             } else {
                                //                               _outstanding =
                                //                                   '0';
                                //                             }
                                //                           }
                                //                           _generateInternetInvoice =
                                //                               true;
                                //                           _addInternetPayment =
                                //                               false;
                                //                           for (var i = 0;
                                //                               i <
                                //                                   internetPlans
                                //                                       .length;
                                //                               i++) {
                                //                             if (internetPlans[i]
                                //                                     .planName ==
                                //                                 customer
                                //                                     .internet
                                //                                     .planName) {
                                //                               _internetPlans =
                                //                                   internetPlans[
                                //                                       i];
                                //                             }
                                //                           }
                                //                           _setAmountPaid();
                                //                           if (_internetPlans ==
                                //                               null) {
                                //                             _planAmountInternetController
                                //                                 .text = "0";
                                //                           } else {
                                //                             _planAmountInternetController
                                //                                     .text =
                                //                                 customer
                                //                                     .internet
                                //                                     .internetMonthlyRent
                                //                                     .toString();
                                //                           }
                                //                           _discountCableController
                                //                               .text = "0";
                                //                           _discountInternetController
                                //                               .text = "0";
                                //                           _discountOthersController
                                //                               .text = "0";
                                //                           _commentCableController
                                //                               .text = "";
                                //                           _commentInternetController
                                //                               .text = "";
                                //                           _commentOthersController
                                //                               .text = "";
                                //                           _discountCommentCableController
                                //                               .text = "";
                                //                           _discountCommentInternetController
                                //                               .text = "";
                                //                           _discountCommentOthersController
                                //                               .text = "";
                                //                           _isDiscount = false;
                                //                         });
                                //                       },
                                //                     ),
                                //                   ),
                                //                 ),
                                //                 Container(
                                //                   width: 10.0,
                                //                 ),
                                //                 Expanded(
                                //                   child: Container(
                                //                     child: RaisedButton(
                                //                       shape: StadiumBorder(),
                                //                       // splashColor: Colors.green,
                                //                       child: Text(
                                //                         "Add Payment",
                                //                         style: TextStyle(
                                //                             color:
                                //                                 Colors.white),
                                //                       ),
                                //                       color:
                                //                           _addInternetPayment ==
                                //                                   true
                                //                               ? Color(
                                //                                   0xffae275f)
                                //                               : Colors.grey,
                                //                       onPressed: () {
                                //                         setState(() {
                                //                           if (_serviceType ==
                                //                               'cable') {
                                //                             _outstanding = customer
                                //                                 .cable
                                //                                 .cableOutstandingAmount;
                                //                           }
                                //                           if (_serviceType ==
                                //                               'internet') {
                                //                             if (customer
                                //                                     .internet
                                //                                     .internetOutstandingAmount !=
                                //                                 null) {
                                //                               _outstanding =
                                //                                   customer
                                //                                       .internet
                                //                                       .internetOutstandingAmount;
                                //                             } else {
                                //                               _outstanding =
                                //                                   '0';
                                //                             }
                                //                           }
                                //                           _generateInternetInvoice =
                                //                               false;
                                //                           _addInternetPayment =
                                //                               true;
                                //                           for (var i = 0;
                                //                               i <
                                //                                   internetPlans
                                //                                       .length;
                                //                               i++) {
                                //                             if (internetPlans[i]
                                //                                     .planName ==
                                //                                 customer
                                //                                     .internet
                                //                                     .planName) {
                                //                               _internetPlans =
                                //                                   internetPlans[
                                //                                       i];
                                //                             }
                                //                           }
                                //                           _setAmountPaid();
                                //                           if (_internetPlans ==
                                //                               null) {
                                //                             _planAmountInternetController
                                //                                 .text = "0";
                                //                           } else {
                                //                             _planAmountInternetController
                                //                                     .text =
                                //                                 customer
                                //                                     .internet
                                //                                     .internetMonthlyRent
                                //                                     .toString();
                                //                           }
                                //                           _discountCableController
                                //                               .text = "0";
                                //                           _discountInternetController
                                //                               .text = "0";
                                //                           _discountOthersController
                                //                               .text = "0";
                                //                           _commentCableController
                                //                               .text = "";
                                //                           _commentInternetController
                                //                               .text = "";
                                //                           _commentOthersController
                                //                               .text = "";
                                //                           _discountCommentCableController
                                //                               .text = "";
                                //                           _discountCommentInternetController
                                //                               .text = "";
                                //                           _discountCommentOthersController
                                //                               .text = "";
                                //                           _isDiscount = false;
                                //                         });
                                //                       },
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ])
                                //         : Container(),
                                // _generateInternetInvoice == true
                                //     ? Container(
                                //         child: Column(
                                //           children: <Widget>[
                                //             Row(children: <Widget>[
                                //               Expanded(
                                //                   child: Container(
                                //                 padding: EdgeInsets.symmetric(
                                //                     vertical: 5.0,
                                //                     horizontal: 2.0),
                                //                 child: Material(
                                //                   elevation: 2.0,
                                //                   shape: RoundedRectangleBorder(
                                //                       borderRadius:
                                //                           BorderRadius.all(
                                //                               Radius.circular(
                                //                                   8.0))),
                                //                   child: GroovinExpansionTile(
                                //                     defaultTrailingIconColor:
                                //                         Colors.indigoAccent,
                                //                     leading: CircleAvatar(
                                //                       backgroundColor:
                                //                           Colors.indigoAccent,
                                //                       child: Icon(
                                //                         Icons.live_tv,
                                //                         color: Colors.white,
                                //                       ),
                                //                     ),
                                //                     title: Text(
                                //                       "Box Details",
                                //                       textAlign:
                                //                           TextAlign.center,
                                //                       softWrap: true,
                                //                       style: TextStyle(
                                //                           color: Colors.black),
                                //                     ),
                                //                     children: <Widget>[
                                //                       ClipRRect(
                                //                           borderRadius:
                                //                               BorderRadius.only(
                                //                             bottomLeft:
                                //                                 Radius.circular(
                                //                                     5.0),
                                //                             bottomRight:
                                //                                 Radius.circular(
                                //                                     5.0),
                                //                           ),
                                //                           child: Column(
                                //                             children: boxes,
                                //                           )),
                                //                     ],
                                //                   ),
                                //                 ),
                                //               )),
                                //             ]),
                                //             Row(children: <Widget>[
                                //               Expanded(
                                //                   // flex: 2,
                                //                   child: Text(
                                //                 "Activation Date",
                                //                 style:
                                //                     TextStyle(fontSize: 16.0),
                                //               )),
                                //               Expanded(
                                //                 child: Row(
                                //                   children: <Widget>[
                                //                     Expanded(
                                //                       // flex: 1,
                                //                       child: TextFormField(
                                //                         controller:
                                //                             _actController,
                                //                         maxLines: 1,
                                //                         keyboardType:
                                //                             TextInputType
                                //                                 .datetime,
                                //                         validator: (value) {
                                //                           setState(() {
                                //                             _actController
                                //                                 .text = value;
                                //                             _actdate = value;
                                //                           });
                                //                         },
                                //                         decoration: InputDecoration(
                                //                             labelText:
                                //                                 "DD-MM-YYYY",
                                //                             labelStyle:
                                //                                 TextStyle(
                                //                                     fontSize:
                                //                                         12.0)),
                                //                       ),
                                //                     ),
                                //                     Container(width: 5.0),
                                //                     InkWell(
                                //                       onTap: () {
                                //                         _selectActDate(context);
                                //                       },
                                //                       highlightColor:
                                //                           Colors.green,
                                //                       child: Icon(
                                //                         Icons.date_range,
                                //                         size: 30.0,
                                //                         color: Colors.blueGrey,
                                //                       ),
                                //                     ),
                                //                     Container(width: 5.0),
                                //                   ],
                                //                 ),
                                //               )
                                //             ]),
                                //             Row(children: <Widget>[
                                //               Expanded(
                                //                   // flex: 2,
                                //                   child: Text(
                                //                 "Expiry Date",
                                //                 style:
                                //                     TextStyle(fontSize: 16.0),
                                //               )),
                                //               Expanded(
                                //                   // flex: 1,
                                //                   child: Row(
                                //                 children: <Widget>[
                                //                   Expanded(
                                //                     child: TextFormField(
                                //                       controller:
                                //                           _expController,
                                //                       maxLines: 1,
                                //                       keyboardType:
                                //                           TextInputType
                                //                               .datetime,
                                //                       validator: (value) {
                                //                         setState(() {
                                //                           _expController.text =
                                //                               value;
                                //                           _expdate = value;
                                //                         });
                                //                       },
                                //                       decoration:
                                //                           InputDecoration(
                                //                               labelText:
                                //                                   "DD-MM-YYYY",
                                //                               labelStyle:
                                //                                   TextStyle(
                                //                                       fontSize:
                                //                                           12.0)),
                                //                     ),
                                //                   ),
                                //                   Container(width: 5.0),
                                //                   InkWell(
                                //                     onTap: () {
                                //                       _selectExpDate(context);
                                //                     },
                                //                     highlightColor:
                                //                         Colors.green,
                                //                     child: Icon(
                                //                       Icons.date_range,
                                //                       size: 30.0,
                                //                       color: Colors.blueGrey,
                                //                     ),
                                //                   ),
                                //                   Container(width: 5.0),
                                //                 ],
                                //               )),
                                //             ]),
                                //             Row(children: <Widget>[
                                //               Expanded(
                                //                   child: Text("Amount",
                                //                       style: TextStyle(
                                //                           fontSize: 16.0))),
                                //               Expanded(
                                //                   child: TextFormField(
                                //                 // initialValue: customer.internet.internetOutstandingAmount,
                                //                 controller:
                                //                     _planAmountInternetController,
                                //                 maxLines: 1,
                                //                 keyboardType:
                                //                     TextInputType.number,
                                //                 style: TextStyle(
                                //                     color: Colors.black,
                                //                     fontSize: 16.0),
                                //                 validator: (value) {
                                //                   if (value.isEmpty) {
                                //                     return 'Please enter amount';
                                //                   }
                                //                   if (int.parse(value) <= 0) {
                                //                     return 'Amount incorrect';
                                //                   }
                                //                   _internetPlanAmount = value;
                                //                 },
                                //                 decoration: InputDecoration(
                                //                   hintText: "Enter Amount",
                                //                 ),
                                //               )),
                                //             ]),
                                //             Row(children: <Widget>[
                                //               Checkbox(
                                //                   activeColor:
                                //                       Color(0xffae275f),
                                //                   onChanged: (value) {
                                //                     setState(() {
                                //                       _recordPayment = value;
                                //                     });
                                //                   },
                                //                   value: _recordPayment),
                                //               Expanded(
                                //                   child: GestureDetector(
                                //                 onTap: () {
                                //                   setState(() {
                                //                     if (_recordPayment ==
                                //                         false) {
                                //                       _recordPayment = true;
                                //                     } else {
                                //                       _recordPayment = false;
                                //                     }
                                //                   });
                                //                 },
                                //                 child: Text(
                                //                   "Record Payment",
                                //                   style:
                                //                       TextStyle(fontSize: 16.0),
                                //                 ),
                                //               )),
                                //             ]),
                                //             SizedBox(
                                //               height: 20.0,
                                //             ),
                                //             _isAdding
                                //                 ? new CircularProgressIndicator(
                                //                     valueColor:
                                //                         new AlwaysStoppedAnimation<
                                //                                 Color>(
                                //                             Colors.green),
                                //                   )
                                //                 : Container(
                                //                     padding:
                                //                         EdgeInsets.symmetric(
                                //                             vertical: 0.0,
                                //                             horizontal: 30.0),
                                //                     width: double.infinity,
                                //                     child: RaisedButton(
                                //                       padding:
                                //                           EdgeInsets.all(12.0),
                                //                       shape: StadiumBorder(),
                                //                       // splashColor: Colors.green,
                                //                       child: Text(
                                //                         "SUBMIT",
                                //                         style: TextStyle(
                                //                             color:
                                //                                 Colors.white),
                                //                       ),
                                //                       color:
                                //                           new Color(0xffae275f),
                                //                       onPressed: () {
                                //                         _addPayment(context);
                                //                       },
                                //                     ),
                                //                   ),
                                //             SizedBox(
                                //               height: 20.0,
                                //             ),
                                //           ],
                                //         ),
                                //       )
                                //     : _addInternetPayment == true
                                //         ?
                                Container(
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
                                                  return new DropdownMenuItem<
                                                      String>(
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
                                      (double.tryParse(customer.cable
                                                      .cableAdvanceAmount) -
                                                  double.tryParse(customer.cable
                                                      .cableAdvanceAmountPaid)) >
                                              0
                                          ? SizedBox(
                                              height: 15.0,
                                            )
                                          : Container(),
                                      (double.tryParse(customer.cable
                                                      .cableAdvanceAmount) -
                                                  double.tryParse(customer.cable
                                                      .cableAdvanceAmountPaid)) >
                                              0
                                          ? Row(children: <Widget>[
                                              Expanded(
                                                  child: Text(
                                                "Installation Due",
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              )),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  _paymentForCable ==
                                                          "Installation"
                                                      ? "Rs. " +
                                                          (double.tryParse(customer
                                                                      .cable
                                                                      .cableAdvanceAmount) -
                                                                  double.tryParse(
                                                                      customer
                                                                          .cable
                                                                          .cableAdvanceAmountPaid))
                                                              .toInt()
                                                              .toString()
                                                      : "Pending",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red),
                                                ),
                                              )
                                            ])
                                          : Container(),
                                      (double.tryParse(customer.cable
                                                      .cableAdvanceAmount) -
                                                  double.tryParse(customer.cable
                                                      .cableAdvanceAmountPaid)) >
                                              0
                                          ? SizedBox(
                                              height: 15.0,
                                            )
                                          : Container(),
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: Text("Bill To",
                                                style:
                                                    TextStyle(fontSize: 16.0))),
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
                                          initialValue: customer.address.mobile,
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
                                                      style: TextStyle(
                                                          fontSize: 16.0))),
                                              Expanded(
                                                  child: Text(
                                                      'Rs. ' +
                                                          customer.cable
                                                              .cableOutstandingAmount,
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                style:
                                                    TextStyle(fontSize: 16.0))),
                                        Expanded(
                                            child: TextFormField(
                                          controller:
                                              _amountPaidCableController,
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
                                                style:
                                                    TextStyle(fontSize: 16.0))),
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
                                        Expanded(
                                            child: TextFormField(
                                          controller: _commentCableController,
                                          maxLines: 2,
                                          keyboardType: TextInputType.multiline,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0),
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
                                                _discountCableController.text =
                                                    "0";
                                                _discountInternetController
                                                    .text = "0";
                                                _discountOthersController.text =
                                                    "0";
                                                _commentCableController.text =
                                                    "";
                                                _commentInternetController
                                                    .text = "";
                                                _commentOthersController.text =
                                                    "";
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
                                                _discountCableController.text =
                                                    "0";
                                                _discountInternetController
                                                    .text = "0";
                                                _discountOthersController.text =
                                                    "0";
                                                _commentCableController.text =
                                                    "";
                                                _commentInternetController
                                                    .text = "";
                                                _commentOthersController.text =
                                                    "";
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
                                              style: TextStyle(fontSize: 16.0)),
                                        ),
                                      ]),
                                      _isDiscount
                                          ? Row(children: <Widget>[
                                              Expanded(
                                                  child: Text("Discount Amount",
                                                      style: TextStyle(
                                                          fontSize: 16.0))),
                                              Expanded(
                                                  child: TextFormField(
                                                controller:
                                                    _discountCableController,
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
                                              Expanded(
                                                  child: TextFormField(
                                                controller:
                                                    _discountCommentCableController,
                                                maxLines: 2,
                                                keyboardType:
                                                    TextInputType.multiline,
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
                                                // splashColor:
                                                //     Colors.green,
                                                child: Text(
                                                  "SUBMIT",
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                                  ),
                                )
                                // : Container()
                                ,
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
                                                          // splashColor:
                                                          //     Colors.green,
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
                                                                _outstanding =
                                                                    customer
                                                                        .cable
                                                                        .cableOutstandingAmount;
                                                              }
                                                              if (_serviceType ==
                                                                  'internet') {
                                                                if (customer
                                                                        .internet
                                                                        .internetOutstandingAmount !=
                                                                    null) {
                                                                  _outstanding =
                                                                      customer
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
                                                                    customer
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
                                                                    customer
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
                                                          // splashColor:
                                                          //     Colors.green,
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
                                                                _outstanding =
                                                                    customer
                                                                        .cable
                                                                        .cableOutstandingAmount;
                                                              }
                                                              if (_serviceType ==
                                                                  'internet') {
                                                                if (customer
                                                                        .internet
                                                                        .internetOutstandingAmount !=
                                                                    null) {
                                                                  _outstanding =
                                                                      customer
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
                                                                    customer
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
                                                                    customer
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
                                                              child: new Text(
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
                                                          // splashColor:
                                                          //     Colors.green,
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
                                                        initialValue: customer
                                                            .address.mobile,
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
                                                              // splashColor:
                                                              //     Colors.green,
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
                                                customer.address.mobile,
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
                                                _commentInternetController,
                                            maxLines: 2,
                                            keyboardType:
                                                TextInputType.multiline,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0),
                                            validator: (value) {
                                              _commentInternet = value;
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
                                                  // splashColor: Colors.green,
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

  Widget searchCard() => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.search, size: 30.0, color: new Color(0xffae275f)),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: TextField(
                    controller: _searchCustomer,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Search Customer"),
                  ),
                ),
                InkWell(
                    onTap: scan,
                    highlightColor: Colors.green,
                    child: Icon(
                      Icons.center_focus_weak,
                      size: 40.0,
                      color: new Color(0xffae275f),
                    )),
              ],
            ),
          ),
        ),
      );

  Widget scanCard() => new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: RaisedButton(
                color: new Color(0xff383e4b),
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: scan,
                child: const Text('SCAN CODE')),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: Text(
              barcode,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      _searchCustomer.text = this.barcode;
      if (barcode.isNotEmpty) {
        List tempList = new List();
        for (int i = 0; i < customers.length; i++) {
          try {
            if (customers[i]
                    .barCode
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()) ||
                customers[i]
                    .customerId
                    .toLowerCase()
                    .contains(_searchText.toLowerCase())) {
              tempList.add(customers[i]);
            }
          } catch (error) {
            print(error);
          }
        }

        searchList = tempList;
      }
      return Expanded(
        child: new ListView.builder(
            itemCount: searchList == null ? 0 : searchList.length,
            itemBuilder: (BuildContext context, int i) {
              return _customerView(searchList[i]);
            }),
      );
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          Scaffold.of(context).showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("The user did not grant the camera permission!"),
          ));
        });
      } else {
        setState(() => Scaffold.of(context).showSnackBar(new SnackBar(
              backgroundColor: Colors.redAccent[400],
              content: new Text("Unknown error: $e'"),
            )));
      }
    } on FormatException {
      setState(() => Scaffold.of(context).showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text(
                '(User returned using the "back"-button before scanning anything. Result)'),
          )));
    } catch (e) {
      setState(() => Scaffold.of(context).showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("Unknown error: $e'"),
          )));
    }
  }

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
        child: Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
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
                  width: 235,
                  child: Text(
                    customer.customerName.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
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
                            child: Text("ID : " + customer.customerId,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        Expanded(
                          child: Text('Rs. ' + total.toString(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow)),
                        )
                      ],
                    )),
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
            trailing: new FloatingActionButton(
              heroTag: customer.id,
              backgroundColor: Colors.green,
              onPressed: () => payCustomer(customer),
              child: Text("Pay"),
              foregroundColor: Colors.white,
            ),
          )),
    ));
  }

  payCustomer(Customer cus) {
    setState(() {
      pay = true;
      searchList = [];
      _searchCustomer.text = "";
      customer = cus;

      customer.cable.noCableConnection != null &&
              customer.cable.noCableConnection > 0
          ? _serviceType = "cable"
          : customer.internet.noInternetConnection != null &&
                  customer.internet.noInternetConnection > 0
              ? _serviceType = "internet"
              : _serviceType = "others";
      if (_serviceType == 'cable') {
        _outstanding = customer.cable.cableOutstandingAmount;
      }
      if (_serviceType == 'internet') {
        if (customer.internet.internetOutstandingAmount != null) {
          _outstanding = customer.internet.internetOutstandingAmount;
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
        if (internetPlans[i].planName == customer.internet.planName) {
          _internetPlans = internetPlans[i];
        }
      }
      if (_internetPlans == null) {
        _planAmountInternetController.text = "0";
      } else {
        _planAmountInternetController.text =
            customer.internet.internetMonthlyRent.toString();
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

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List tempList = new List();
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
                  .barCode
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

      searchList = tempList;
    }
    return Expanded(
      child: new ListView.builder(
          itemCount: searchList == null ? 0 : searchList.length,
          itemBuilder: (BuildContext context, int i) {
            return _customerView(searchList[i]);
          }),
    );
  }

// Future<bool> _onBackPressedCustomerEdit() {
//   return showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: new Text(
//             isEditBouquetChannelDetails
//                 ? "Exit without saving Package ?"
//                 : "Exit without saving Customer ?",
//             style: TextStyle(fontSize: 16.0)),
//         actions: <Widget>[
//           Row(
//             children: <Widget>[
//               FloatingActionButton(
//                 mini: true,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5.0),
//                   side: BorderSide(
//                     color: Color(0xffae275f),
//                     width: 1.0,
//                   ),
//                 ),
//                 backgroundColor: Colors.white,
//                 foregroundColor: Color(0xffae275f),
//                 onPressed: () {
//                   setState(() {
//                     if (isEditBouquetChannelDetails) {
//                       isEditCustomer = false;
//                       isEditCustomerDetails = false;
//                       isEditContactDetails = false;
//                       isEditCableDetails = true;
//                       isEditBouquetChannelDetails = false;
//                       isEditInternetDetails = false;
//                       _customerCard.cable.boxDetails[_selectedBouquet]
//                           .addonPackage.subPackages
//                           .clear();
//                       for (var i = 0; i < tempAddOnPackage.length; i++) {
//                         _customerCard.cable.boxDetails[_selectedBouquet]
//                             .addonPackage.subPackages
//                             .add(Package(
//                                 packageId: tempAddOnPackage[i].packageId,
//                                 packageName: tempAddOnPackage[i].packageName,
//                                 packageCost: tempAddOnPackage[i].packageCost,
//                                 billable: tempAddOnPackage[i].billable,
//                                 channels: []));
//                         for (var j = 0;
//                             j < tempAddOnPackage[i].channels.length;
//                             j++) {
//                           _customerCard.cable.boxDetails[_selectedBouquet]
//                               .addonPackage.subPackages[i].channels
//                               .add(MainPackageChannel(
//                                   id: tempAddOnPackage[i].channels[j].id,
//                                   name:
//                                       tempAddOnPackage[i].channels[j].name));
//                         }
//                       }
//                       _customerCard.cable.boxDetails[_selectedBouquet]
//                           .addonPackage.channels
//                           .clear();
//                       for (var i = 0; i < tempChannel.length; i++) {
//                         _customerCard.cable.boxDetails[_selectedBouquet]
//                             .addonPackage.channels
//                             .add(AddonPackageChannel(
//                                 channelId: tempChannel[i].channelId,
//                                 channelName: tempChannel[i].channelName,
//                                 channelCost: tempChannel[i].channelCost,
//                                 billable: tempChannel[i].billable));
//                       }
//                       Navigator.pop(context, false);
//                     } else if (isEditCableDetails) {
//                       isEditCustomer = true;
//                       isEditCustomerDetails = false;
//                       isEditContactDetails = false;
//                       isEditCableDetails = false;
//                       isEditBouquetChannelDetails = false;
//                       isEditInternetDetails = false;
//                       _customerCard.cable = null;
//                       _customerCard.cable = Cable(
//                         boxDetails: [],
//                         cableAdvanceAmount:
//                             _tempCableDetails.cableAdvanceAmount,
//                         cableAdvanceAmountPaid:
//                             _tempCableDetails.cableAdvanceAmountPaid,
//                         cableAdvanceInstallment:
//                             _tempCableDetails.cableAdvanceInstallment,
//                         cableComments: _tempCableDetails.cableComments,
//                         cableDiscount: _tempCableDetails.cableDiscount,
//                         cableMonthlyRent: _tempCableDetails.cableMonthlyRent,
//                         cableOutstandingAmount:
//                             _tempCableDetails.cableOutstandingAmount,
//                         noCableConnection:
//                             _tempCableDetails.noCableConnection,
//                         sortcableOutstandingAmount:
//                             _tempCableDetails.sortcableOutstandingAmount,
//                       );
//                       _customerCard.cable.boxDetails.clear();
//                       for (var i = 0;
//                           i < _tempCableDetails.boxDetails.length;
//                           i++) {
//                         _customerCard.cable.boxDetails.add(BoxDetail(
//                           activationDate:
//                               _tempCableDetails.boxDetails[i].activationDate,
//                           addonPackage: AddonPackage(
//                             channels: [],
//                             packageCost: _tempCableDetails
//                                 .boxDetails[i].addonPackage.packageCost,
//                             subPackages: [],
//                           ),
//                           boxType: _tempCableDetails.boxDetails[i].boxType,
//                           cableType:
//                               _tempCableDetails.boxDetails[i].cableType,
//                           freeConnection:
//                               _tempCableDetails.boxDetails[i].freeConnection,
//                           irdNo: _tempCableDetails.boxDetails[i].irdNo,
//                           mainPackage: Package(
//                             billable: _tempCableDetails
//                                 .boxDetails[i].mainPackage.billable,
//                             channels: [],
//                             packageCost: _tempCableDetails
//                                 .boxDetails[i].mainPackage.packageCost,
//                             packageId: _tempCableDetails
//                                 .boxDetails[i].mainPackage.packageId,
//                             packageName: _tempCableDetails
//                                 .boxDetails[i].mainPackage.packageName,
//                           ),
//                           mainPackageBillable: _tempCableDetails
//                               .boxDetails[i].mainPackageBillable,
//                           mainPackageCost:
//                               _tempCableDetails.boxDetails[i].mainPackageCost,
//                           mainPackageId:
//                               _tempCableDetails.boxDetails[i].mainPackageId,
//                           mainPackageName:
//                               _tempCableDetails.boxDetails[i].mainPackageName,
//                           msoId: _tempCableDetails.boxDetails[i].msoId,
//                           nuidNo: _tempCableDetails.boxDetails[i].nuidNo,
//                           vcNo: _tempCableDetails.boxDetails[i].vcNo,
//                         ));
//                         _customerCard
//                             .cable.boxDetails[i].addonPackage.channels
//                             .clear();
//                         for (var j = 0;
//                             j <
//                                 _tempCableDetails.boxDetails[i].addonPackage
//                                     .channels.length;
//                             j++) {
//                           _customerCard
//                               .cable.boxDetails[i].addonPackage.channels
//                               .add(AddonPackageChannel(
//                             billable: _tempCableDetails.boxDetails[i]
//                                 .addonPackage.channels[j].billable,
//                             channelCost: _tempCableDetails.boxDetails[i]
//                                 .addonPackage.channels[j].channelCost,
//                             channelId: _tempCableDetails.boxDetails[i]
//                                 .addonPackage.channels[j].channelId,
//                             channelName: _tempCableDetails.boxDetails[i]
//                                 .addonPackage.channels[j].channelName,
//                           ));
//                         }
//                         _customerCard
//                             .cable.boxDetails[i].addonPackage.subPackages
//                             .clear();
//                         for (var j = 0;
//                             j <
//                                 _tempCableDetails.boxDetails[i].addonPackage
//                                     .subPackages.length;
//                             j++) {
//                           _customerCard
//                               .cable.boxDetails[i].addonPackage.subPackages
//                               .add(Package(
//                             billable: _tempCableDetails.boxDetails[i]
//                                 .addonPackage.subPackages[j].billable,
//                             channels: [],
//                             packageCost: _tempCableDetails.boxDetails[i]
//                                 .addonPackage.subPackages[j].packageCost,
//                             packageId: _tempCableDetails.boxDetails[i]
//                                 .addonPackage.subPackages[j].packageId,
//                             packageName: _tempCableDetails.boxDetails[i]
//                                 .addonPackage.subPackages[j].packageName,
//                           ));
//                           _customerCard.cable.boxDetails[i].addonPackage
//                               .subPackages[j].channels
//                               .clear();
//                           for (var k = 0;
//                               k <
//                                   _tempCableDetails.boxDetails[i].addonPackage
//                                       .subPackages[j].channels.length;
//                               k++) {
//                             _customerCard.cable.boxDetails[i].addonPackage
//                                 .subPackages[j].channels
//                                 .add(MainPackageChannel(
//                                     id: _tempCableDetails
//                                         .boxDetails[i]
//                                         .addonPackage
//                                         .subPackages[j]
//                                         .channels[k]
//                                         .id,
//                                     name: _tempCableDetails
//                                         .boxDetails[i]
//                                         .addonPackage
//                                         .subPackages[j]
//                                         .channels[k]
//                                         .name));
//                           }
//                         }
//                         _customerCard.cable.boxDetails[i].mainPackage.channels
//                             .clear();
//                         for (var j = 0;
//                             j <
//                                 _tempCableDetails.boxDetails[i].mainPackage
//                                     .channels.length;
//                             j++) {
//                           _customerCard
//                               .cable.boxDetails[i].mainPackage.channels
//                               .add(MainPackageChannel(
//                             id: _tempCableDetails
//                                 .boxDetails[i].mainPackage.channels[j].id,
//                             name: _tempCableDetails
//                                 .boxDetails[i].mainPackage.channels[j].name,
//                           ));
//                         }
//                       }
//                       autoPopulateData();
//                       Navigator.pop(context, false);
//                     } else {
//                       isEditCustomer = true;
//                       isEditCustomerDetails = false;
//                       isEditContactDetails = false;
//                       isEditCableDetails = false;
//                       isEditBouquetChannelDetails = false;
//                       isEditInternetDetails = false;
//                       autoPopulateData();
//                       Navigator.pop(context, false);
//                     }
//                   });
//                 },
//                 child: Text("Yes"),
//               ),
//               Container(
//                 height: 20.0,
//                 width: 1.0,
//                 color: Colors.black38,
//                 margin: const EdgeInsets.only(left: 10.0, right: 10.0),
//               ),
//               FloatingActionButton(
//                 mini: true,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5.0),
//                   side: BorderSide(
//                     color: Color.fromARGB(255, 41, 153, 102),
//                     width: 1.0,
//                   ),
//                 ),
//                 backgroundColor: Colors.white,
//                 foregroundColor: Color.fromARGB(255, 41, 153, 102),
//                 onPressed: () {
//                   Navigator.pop(context, false);
//                 },
//                 child: Text("No"),
//               ),
//             ],
//           ),
//         ],
//       );
//     },
//   );
// }

}
