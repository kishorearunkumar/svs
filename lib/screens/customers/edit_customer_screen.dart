import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:svs/models/addon-package.dart';
import 'package:svs/models/box-details.dart';
import 'package:svs/models/channel.dart';
import 'package:svs/models/customer-id-verify.dart';
import 'package:svs/models/customer.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:intl/intl.dart';
import 'package:svs/models/area.dart';
import 'package:svs/models/internet-plan.dart';
import 'package:svs/models/mainpackage.dart';
import 'package:svs/models/mso.dart';
import 'package:svs/models/username.dart';
import 'package:svs/models/street.dart';
import 'package:svs/services/basic_service.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:svs/widgets/loader.dart';

class EditCustomerScreen extends StatefulWidget {
  final Customer customer;

  EditCustomerScreen({Key key, @required this.customer}) : super(key: key);
  _EditCustomerScreenState createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  Customer _customerCard;
  List<CustomerIdVerify> _customerIdVerify;
  bool isCustomerIdVerified = true;
  bool isEditCustomer = true;
  bool isEditCustomerDetails = false;
  bool isEditContactDetails = false;
  bool isEditCableDetails = false;
  bool isEditBouquetChannelDetails = false;
  bool isBouquetChannel = true;
  bool isEditInternetDetails = false;
  bool isAlterCurrentBill = false;
  final TextEditingController _fullnameController = new TextEditingController();
  String _fullname;
  final TextEditingController _customeridController =
      new TextEditingController();
  String _customerid;
  final TextEditingController _barcodeIDController =
      new TextEditingController();
  String barcodeid = "";
  String _barcodeid;
  final TextEditingController _cafnoController = new TextEditingController();
  String _cafno;
  final TextEditingController _dobController = new TextEditingController();
  String _dobdate = "";
  var formatter = new DateFormat('dd-MM-yyyy');
  var formatters = NumberFormat("##,##,##0.00");
  String _gender;
  List<Areas> areas = [];
  List<Username> collectionagents = [];
  List<Street> streets = [];
  String _residencetype = "Owned";
  final TextEditingController _flatnoController = new TextEditingController();
  String _flatno;
  final TextEditingController _flatnameController = new TextEditingController();
  String _flatname;
  final TextEditingController _streetController = new TextEditingController();
  String _street;
  final TextEditingController _areaController = new TextEditingController();
  String _area;
  final TextEditingController _landmarkController = new TextEditingController();
  String _landmark;
  final TextEditingController _cityController = new TextEditingController();
  String _city;
  final TextEditingController _stateController = new TextEditingController();
  String _state;
  final TextEditingController _pincodeController = new TextEditingController();
  String _pincode;
  final TextEditingController _emailController = new TextEditingController();
  String _email;
  final TextEditingController _mobnoController = new TextEditingController();
  String _mobno;
  final TextEditingController _altnoController = new TextEditingController();
  String _altno;
  final TextEditingController _ebnoController = new TextEditingController();
  String _ebno;
  final TextEditingController _postnoController = new TextEditingController();
  String _postno;
  String _collectionagent = "Select Collection Agent";
  List<InternetPlan> internetPlans = [];
  InternetPlan _internetPlans;
  List<Mso> msoname = [];
  List<MainPackage> mainpackage = [];
  List<AddOnPackage> addOnPackage = [];
  List<Channel> channel = [];
  List<AddOnPackage> tempAddOnPackage = [];
  List<Channel> tempChannel = [];
  final editCustomerDetailsKey = GlobalKey<FormState>();
  final editContactDetailsKey = GlobalKey<FormState>();
  final editCableDetailsKey = GlobalKey<FormState>();
  final editInternetDetailsKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> editCustomerKey =
      new GlobalKey<ScaffoldState>();
  List<String> _cabletype = [];
  List<bool> _freeconnectionCable = [];
  List<String> _msoname = [];
  List<String> _boxtype = [];
  final List<TextEditingController> _actDateCableController = [];
  List<String> _actdateCable = [];
  final List<TextEditingController> _vcnoController = [];
  List<String> vcno = [];
  List<String> _vcno = [];
  final List<TextEditingController> _nuidController = [];
  List<String> nuid = [];
  List<String> _nuid = [];
  final List<TextEditingController> _irdController = [];
  List<String> ird = [];
  List<String> _ird = [];
  final List<TextEditingController> _boxcommentController = [];
  List<String> _boxcomment = [];
  List<MainPackage> _mainpackage = [];
  List<String> _billing = [];
  final TextEditingController _instalamtCableController =
      new TextEditingController();
  String _instalamtCable = "0";
  String _instaltypeCable = "Fully Paid";
  bool isInstallmentCable = false;
  final TextEditingController _instalamtpaidCableController =
      new TextEditingController();
  String _instalamtpaidCable = "0";
  final TextEditingController _outstandbalanceCableController =
      new TextEditingController();
  String _outstandbalanceCable = "0";
  final TextEditingController _cableMonthlyRentController =
      new TextEditingController();
  String _cablemonthlyrent = "0";
  final TextEditingController _cableDiscountController =
      new TextEditingController();
  String _cablediscount = "0";
  String _cabletotalrental = "0";
  final TextEditingController _cableCommentController =
      new TextEditingController();
  String _cableComment;
  String _billType = "Pre Paid";
  String _ontNumber;
  final TextEditingController _ontNumberController =
      new TextEditingController();
  String _macId;
  final TextEditingController _macIdController = new TextEditingController();
  String _vLan;
  final TextEditingController _vLanController = new TextEditingController();
  String _voip;
  final TextEditingController _voipController = new TextEditingController();
  final TextEditingController _internetMonthlyRentController =
      new TextEditingController();
  String _internetmonthlyrent = "0";
  final TextEditingController _actDateInternetController =
      new TextEditingController();
  String _actdateInternet = "";
  final TextEditingController _instalamtInternetController =
      new TextEditingController();
  String _instalamtInternet = "0";
  bool _freeconnectionInternet = false;
  final TextEditingController _outstandbalanceInternetController =
      new TextEditingController();
  String _outstandbalanceInternet = "0";
  final TextEditingController _internetDiscountController =
      new TextEditingController();
  String _internetdiscount = "0";
  String _internettotalrental = "0";
  final TextEditingController _internetCommentController =
      new TextEditingController();
  String _internetComment;
  bool isBouquetSelected = false;
  final TextEditingController _searchBouquetPackage =
      new TextEditingController();
  String _searchBouquetPackageText = "";
  List<AddOnPackage> searchBouquetPackageList = [];
  bool isChannelSelected = false;
  final TextEditingController _searchChannel = new TextEditingController();
  String _searchChannelText = "";
  List<Channel> searchChannelList = [];
  int _selectedBouquet;
  Cables _tempCableDetails;

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _customerCard = widget.customer;
    getMainPackageData();
    getInternetPlan();
    getStreetData();
    getAreaData();
    getCollectionAgentData();
    getMSOData();
    // getMainPackageData();
    getAddonPackage();
    getChannel();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _EditCustomerScreenState() {
    _customeridController.addListener(() {
      verifyCustomerId(_customeridController.text);
    });
    _searchBouquetPackage.addListener(() {
      if (_searchBouquetPackage.text.isEmpty) {
        setState(() {
          _searchBouquetPackageText = "";
        });
      } else {
        setState(() {
          _searchBouquetPackageText = _searchBouquetPackage.text;
        });
      }
    });

    _searchChannel.addListener(() {
      if (_searchChannel.text.isEmpty) {
        setState(() {
          _searchChannelText = "";
        });
      } else {
        setState(() {
          _searchChannelText = _searchChannel.text;
        });
      }
    });

    _cableMonthlyRentController.addListener(() {
      if (_cableMonthlyRentController.text.isEmpty) {
        setState(() {
          _cablemonthlyrent = "";
          setTotalCableRent();
        });
      } else {
        setState(() {
          _cablemonthlyrent = _cableMonthlyRentController.text;
          setTotalCableRent();
        });
      }
    });

    _cableDiscountController.addListener(() {
      if (_cableDiscountController.text.isEmpty) {
        setState(() {
          _cablediscount = "";
          setTotalCableRent();
        });
      } else {
        setState(() {
          _cablediscount = _cableDiscountController.text;
          setTotalCableRent();
        });
      }
    });

    _internetMonthlyRentController.addListener(() {
      if (_internetMonthlyRentController.text.isEmpty) {
        setState(() {
          _internetmonthlyrent = "";
          setTotalInternetRent();
        });
      } else {
        setState(() {
          _internetmonthlyrent = _internetMonthlyRentController.text;
          setTotalInternetRent();
        });
      }
    });

    _internetDiscountController.addListener(() {
      if (_internetDiscountController.text.isEmpty) {
        setState(() {
          _internetdiscount = "";
          setTotalInternetRent();
        });
      } else {
        setState(() {
          _internetdiscount = _internetDiscountController.text;
          setTotalInternetRent();
        });
      }
    });
  }

  getInternetPlan() {
    internetPlan().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          internetPlans =
              internetPlanFromJson(Utf8Codec().decode(response.bodyBytes));
          internetPlans.sort((a, b) =>
              a.planName.toLowerCase().compareTo(b.planName.toLowerCase()));
          AppSharedPreferences.setInternetPlan(internetPlans);
          autoPopulateData();
        });
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
      });
    });
  }

  verifyCustomerId(String customerId) {
    customerIdVerify(customerId).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          _customerIdVerify =
              customerIdVerifyFromJson(Utf8Codec().decode(response.bodyBytes));
          if (_customerIdVerify != null && _customerIdVerify.isNotEmpty) {
            if (_customerIdVerify[0].customerId != _customerCard.customerId) {
              isCustomerIdVerified = false;
              editCustomerKey.currentState.showSnackBar(new SnackBar(
                backgroundColor: Colors.redAccent,
                content: new Text("Customer Id Already Exist!!!"),
              ));
            } else {
              isCustomerIdVerified = true;
            }
          } else {
            isCustomerIdVerified = true;
          }
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  getAddonPackage() {
    addOnPackageList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          addOnPackage =
              addOnPackagesFromJson(Utf8Codec().decode(response.bodyBytes));
          addOnPackage.sort((a, b) => a.packageName
              .toLowerCase()
              .compareTo(b.packageName.toLowerCase()));
          AppSharedPreferences.setAddOnPackage(addOnPackage);
          autoPopulateData();
        });
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
      });
    });
  }

  getChannel() {
    channelList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          channel = channelsFromJson(Utf8Codec().decode(response.bodyBytes));
          channel.sort((a, b) => a.channelName
              .toLowerCase()
              .compareTo(b.channelName.toLowerCase()));
          AppSharedPreferences.setChannel(channel);
          autoPopulateData();
        });
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
      });
    });
  }

  getMSOData() {
    msoList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          msoname = msosFromJson(Utf8Codec().decode(response.bodyBytes));
          msoname.sort((a, b) =>
              a.msoName.toLowerCase().compareTo(b.msoName.toLowerCase()));
          AppSharedPreferences.setMso(msoname);
          autoPopulateData();
        });
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
      });
    });
  }

  getMainPackageData() {
    mainPackageList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          mainpackage =
              mainPackagesFromJson(Utf8Codec().decode(response.bodyBytes));
          mainpackage.sort((a, b) => a.packageName
              .toLowerCase()
              .compareTo(b.packageName.toLowerCase()));
          AppSharedPreferences.setMainPackage(mainpackage);
          autoPopulateData();
        });
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
          streets.sort((a, b) =>
              a.street.toLowerCase().compareTo(b.street.toLowerCase()));
          AppSharedPreferences.setStreets(streets);
          autoPopulateData();
        });
      }
    }).catchError((error) {
      print(error);

      setState(() {
        getOldData();
      });
    });
  }

  getCollectionAgentData() {
    usernameList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          collectionagents =
              usernamesFromJson(Utf8Codec().decode(response.bodyBytes));
          collectionagents.sort((a, b) =>
              a.userName.toLowerCase().compareTo(b.userName.toLowerCase()));
          AppSharedPreferences.setUsername(collectionagents);
          autoPopulateData();
        });
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
          areas.sort(
              (a, b) => a.area.toLowerCase().compareTo(b.area.toLowerCase()));
          AppSharedPreferences.setAreas(areas);
          autoPopulateData();
        });
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
      streets = await AppSharedPreferences.getStreets();
      streets.sort(
          (a, b) => a.street.toLowerCase().compareTo(b.street.toLowerCase()));

      internetPlans = await AppSharedPreferences.getInternetPlan();
      internetPlans.sort((a, b) =>
          a.planName.toLowerCase().compareTo(b.planName.toLowerCase()));
      msoname = await AppSharedPreferences.getMso();
      msoname.sort(
          (a, b) => a.msoName.toLowerCase().compareTo(b.msoName.toLowerCase()));
      areas = await AppSharedPreferences.getAreas();
      areas
          .sort((a, b) => a.area.toLowerCase().compareTo(b.area.toLowerCase()));
      mainpackage = await AppSharedPreferences.getMainPackage();
      mainpackage.sort((a, b) =>
          a.packageName.toLowerCase().compareTo(b.packageName.toLowerCase()));
      collectionagents = await AppSharedPreferences.getUsername();
      collectionagents.sort((a, b) =>
          a.userName.toLowerCase().compareTo(b.userName.toLowerCase()));
      addOnPackage = await AppSharedPreferences.getAddOnPackage();
      addOnPackage.sort((a, b) =>
          a.packageName.toLowerCase().compareTo(b.packageName.toLowerCase()));
      channel = await AppSharedPreferences.getChannel();
      channel.sort((a, b) =>
          a.channelName.toLowerCase().compareTo(b.channelName.toLowerCase()));
      autoPopulateData();
    } catch (e) {
      print(e);
    }
  }

  Future pause(Duration d) => new Future.delayed(d);

  Future scanBarcodeID() async {
    try {
      barcodeid = await BarcodeScanner.scan();
      setState(() {
        _barcodeid = barcodeid;
      });
      _barcodeIDController.text = this.barcodeid;
    } catch (error) {
      print(error);
    }
  }

  Future scanVCNO(int i) async {
    try {
      vcno[i] = await BarcodeScanner.scan();
      setState(() {
        _vcno[i] = vcno[i];
      });
      _vcnoController[i].text = this.vcno[i];
      _customerCard.cable.boxDetails[i].vcNo = _vcno[i];
    } catch (error) {
      print(error);
    }
  }

  Future scanNUID(int i) async {
    try {
      nuid[i] = await BarcodeScanner.scan();
      setState(() {
        _nuid[i] = nuid[i];
      });
      _nuidController[i].text = this.nuid[i];
      _customerCard.cable.boxDetails[i].nuidNo = _nuid[i];
    } catch (error) {
      print(error);
    }
  }

  Future scanIRD(int i) async {
    try {
      ird[i] = await BarcodeScanner.scan();
      setState(() {
        _ird[i] = ird[i];
      });
      _irdController[i].text = this.ird[i];
      _customerCard.cable.boxDetails[i].irdNo = _ird[i];
    } catch (error) {
      print(error);
    }
  }

  Future<Null> _selectDOBDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2025));
    if (picked != null && picked != DateTime.tryParse(_dobdate.toString())) {
      setState(() {
        _dobdate = picked.toString();
        _dobController.text =
            formatter.format(DateTime.tryParse(_dobdate.toString()).toLocal());
      });
    }
  }

  Future<Null> _selectActDateCable(BuildContext context, int i) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2025));
    if (picked != null &&
        picked != DateTime.tryParse(_actdateCable[i].toString())) {
      setState(() {
        _actdateCable[i] = picked.toString();
        _actDateCableController[i].text = formatter
            .format(DateTime.tryParse(_actdateCable[i].toString()).toLocal());
        _customerCard.cable.boxDetails[i].activationDate = _actdateCable[i];
      });
    }
  }

  Future<Null> _selectActDateInternet(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2025));
    if (picked != null &&
        picked != DateTime.tryParse(_actdateInternet.toString())) {
      setState(() {
        _actdateInternet = picked.toString();
        _actDateInternetController.text = formatter
            .format(DateTime.tryParse(_actdateInternet.toString()).toLocal());
      });
    }
  }

  setStreetAutofill() {
    if (_streetController.text.isNotEmpty) {
      for (var i = 0; i < streets.length; i++) {
        if (streets[i].street == _street) {
          setState(() {
            _areaController.text = streets[i].area.area;
            _cityController.text = streets[i].area.city;
            _stateController.text = streets[i].area.state;
            _pincodeController.text = streets[i].area.pincode;
          });
        }
      }
    }
  }

  setAreaAutofill() {
    if (_areaController.text.isNotEmpty) {
      for (var i = 0; i < areas.length; i++) {
        if (areas[i].area == _area) {
          setState(() {
            _cityController.text = areas[i].city;
            _stateController.text = areas[i].state;
            _pincodeController.text = areas[i].pincode;
          });
        }
      }
    }
  }

  autoPopulateData() {
    setState(() {
      _cabletype.clear();
      _freeconnectionCable.clear();
      _msoname.clear();
      _boxtype.clear();
      _actDateCableController.clear();
      _actdateCable.clear();
      _vcnoController.clear();
      vcno.clear();
      _vcno.clear();
      _nuidController.clear();
      nuid.clear();
      _nuid.clear();
      _irdController.clear();
      ird.clear();
      _ird.clear();
      _boxcommentController.clear();
      _boxcomment.clear();
      _mainpackage.clear();
      _billing.clear();
      isAlterCurrentBill = false;
      _fullnameController.text = _customerCard.customerName;
      _customeridController.text = _customerCard.customerId;
      _barcodeIDController.text = _customerCard.barCode;
      _cafnoController.text = _customerCard.cafNo;
      _dobController.text = _customerCard.dob;
      _gender = _customerCard.gender;
      _residencetype = _customerCard.address.residenceType;
      _flatnoController.text = _customerCard.address.doorNo;
      _flatnameController.text = _customerCard.address.houseName;
      _streetController.text = _customerCard.address.street;
      _areaController.text = _customerCard.address.area;
      _landmarkController.text = _customerCard.address.landmark;
      _cityController.text = _customerCard.address.city;
      _stateController.text = _customerCard.address.state;
      _pincodeController.text = _customerCard.address.pincode;
      _emailController.text = _customerCard.address.emailId;
      _mobnoController.text = _customerCard.address.mobile;
      _altnoController.text = _customerCard.address.alternateNumber;
      _ebnoController.text = _customerCard.ebNumber;
      _postnoController.text = _customerCard.postNumber;
      _collectionagent = _customerCard.collectionAgent;
      for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
        _cabletype.add("Digital");
        _cabletype[i] = _customerCard.cable.boxDetails[i].cableType;
      }
      for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
        _freeconnectionCable.add(false);
        _freeconnectionCable[i] =
            _customerCard.cable.boxDetails[i].freeConnection == null
                ? false
                : _customerCard.cable.boxDetails[i].freeConnection;
      }
      for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
        _msoname.add("Select MSO");
        for (var j = 0; j < msoname.length; j++) {
          if (_customerCard.cable.boxDetails[i].msoId == msoname[j].msoName) {
            _msoname[i] = _customerCard.cable.boxDetails[i].msoId;
          }
        }
      }
      for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
        _boxtype.add("SD");
        _boxtype[i] = _customerCard.cable.boxDetails[i].boxType;
      }
      for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
        _actDateCableController.add(TextEditingController());
        _actdateCable.add("");
        _actDateCableController[i].text =
            _customerCard.cable.boxDetails[i].activationDate;
      }
      for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
        _vcnoController.add(TextEditingController());
        vcno.add("");
        _vcno.add("");
        _vcnoController[i].text = _customerCard.cable.boxDetails[i].vcNo;
      }
      for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
        _nuidController.add(TextEditingController());
        nuid.add("");
        _nuid.add("");
        _nuidController[i].text = _customerCard.cable.boxDetails[i].nuidNo;
      }
      for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
        _irdController.add(TextEditingController());
        ird.add("");
        _ird.add("");
        _irdController[i].text = _customerCard.cable.boxDetails[i].irdNo;
      }
      for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
        _boxcommentController.add(TextEditingController());
        _boxcomment.add("");
        _boxcommentController[i].text =
            _customerCard.cable.boxDetails[i].boxComment;
      }
      for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
        _mainpackage.add(MainPackage());
        if (_customerCard.cable.boxDetails[i].mainPackage.packageId == "") {
          _mainpackage[i] = null;
        } else {
          for (var j = 0; j < mainpackage.length; j++) {
            if (_customerCard.cable.boxDetails[i].mainPackage.packageId ==
                    mainpackage[j].id &&
                _customerCard.cable.boxDetails[i].mainPackage.packageName ==
                    mainpackage[j].packageName) {
              _mainpackage[i] = mainpackage[j];
            }
          }
        }
      }
      List<String> billing = [
        'Repeat',
        '1 Month',
        '2 Months',
        '3 Months',
        '6 Months',
        '1 Year'
      ];
      for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
        _billing.add("Repeat");
        for (var j = 0; j < billing.length; j++) {
          if (_customerCard.cable.boxDetails[i].mainPackage.billable ==
              billing[j]) {
            _billing[i] =
                _customerCard.cable.boxDetails[i].mainPackage.billable;
          }
        }
      }
      _instalamtCableController.text = _customerCard.cable.cableAdvanceAmount;
      _instaltypeCable = _customerCard.cable.cableAdvanceInstallment;
      _instalamtpaidCableController.text =
          _customerCard.cable.cableAdvanceAmountPaid;
      _outstandbalanceCableController.text =
          _customerCard.cable.cableOutstandingAmount;
      _cableMonthlyRentController.text = _customerCard.cable.cableMonthlyRent;
      _cableDiscountController.text = _customerCard.cable.cableDiscount;
      _cableCommentController.text = _customerCard.cable.cableComments;
      for (var i = 0; i < internetPlans.length; i++) {
        if (_customerCard.internet.planName == internetPlans[i].planName) {
          _internetPlans = internetPlans[i];
        }
      }
      _billType = _customerCard.internet.internetBillType;
      _ontNumberController.text = _customerCard.internet.ontNo;
      _macIdController.text = _customerCard.internet.macId;
      _vLanController.text = _customerCard.internet.vLan;
      _voipController.text = _customerCard.internet.voip;
      _actDateInternetController.text =
          _customerCard.internet.internetActivationDate;
      _instalamtInternetController.text =
          _customerCard.internet.internetAdvanceAmount;
      _freeconnectionInternet = _customerCard.internet.freeConnection != null
          ? _customerCard.internet.freeConnection
          : false;
      _outstandbalanceInternetController.text =
          _customerCard.internet.internetOutstandingAmount;
      _internetMonthlyRentController.text =
          _customerCard.internet.internetMonthlyRent;
      _internetDiscountController.text =
          _customerCard.internet.internetDiscount;
      _internetCommentController.text = _customerCard.internet.internetComments;
    });
  }

  setTotalCableRent() {
    var rent = 0;
    var discount = 0;
    if (_cableMonthlyRentController.text.isEmpty &&
        _cableDiscountController.text.isEmpty) {
      rent = 0;
      discount = 0;
      _cabletotalrental = (rent - discount).toString();
    } else if (_cableMonthlyRentController.text.isEmpty &&
        _cableDiscountController.text.isNotEmpty) {
      rent = 0;
      discount = int.parse(_cablediscount);
      _cabletotalrental = (rent - discount).toString();
    } else if (_cableMonthlyRentController.text.isNotEmpty &&
        _cableDiscountController.text.isEmpty) {
      rent = int.parse(_cablemonthlyrent);
      discount = 0;
      _cabletotalrental = (rent - discount).toString();
    } else {
      rent = int.parse(_cablemonthlyrent);
      discount = int.parse(_cablediscount);
      _cabletotalrental = (rent - discount).toString();
    }
  }

  setTotalInternetRent() {
    var rent = 0;
    var discount = 0;
    if (_internetMonthlyRentController.text.isEmpty &&
        _internetDiscountController.text.isEmpty) {
      rent = 0;
      discount = 0;
      _internettotalrental = (rent - discount).toString();
    } else if (_internetMonthlyRentController.text.isEmpty &&
        _internetDiscountController.text.isNotEmpty) {
      rent = 0;
      discount = int.parse(_internetdiscount);
      _internettotalrental = (rent - discount).toString();
    } else if (_internetMonthlyRentController.text.isNotEmpty &&
        _internetDiscountController.text.isEmpty) {
      rent = int.parse(_internetmonthlyrent);
      discount = 0;
      _internettotalrental = (rent - discount).toString();
    } else {
      rent = int.parse(_internetmonthlyrent);
      discount = int.parse(_internetdiscount);
      _internettotalrental = (rent - discount).toString();
    }
  }

  setCableRent() {
    setState(() {
      double _totalmainpackage = 0.0;
      for (var i = 0; i < _mainpackage.length; i++) {
        if (_mainpackage[i] != null) {
          if (_mainpackage[i].packageCost != null) {
            _totalmainpackage = _mainpackage[i].packageCost + _totalmainpackage;
          }
        }
      }
      double _totalsubpackages = 0.0;
      for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
        for (var j = 0;
            j <
                _customerCard
                    .cable.boxDetails[i].addonPackage.subPackages.length;
            j++) {
          if (_customerCard.cable.boxDetails[i].addonPackage.subPackages[j]
                      .packageCost !=
                  null &&
              _customerCard.cable.boxDetails[i].addonPackage.subPackages[j]
                  .packageCost.isNotEmpty &&
              _customerCard.cable.boxDetails[i].addonPackage.subPackages[j]
                      .packageCost !=
                  "") {
            _totalsubpackages = double.tryParse(_customerCard.cable
                    .boxDetails[i].addonPackage.subPackages[j].packageCost) +
                _totalsubpackages;
          }
        }
      }
      double _totalchannels = 0.0;
      for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
        for (var j = 0;
            j < _customerCard.cable.boxDetails[i].addonPackage.channels.length;
            j++) {
          if (_customerCard.cable.boxDetails[i].addonPackage.channels[j]
                      .channelCost !=
                  null &&
              _customerCard.cable.boxDetails[i].addonPackage.channels[j]
                  .channelCost.isNotEmpty &&
              _customerCard.cable.boxDetails[i].addonPackage.channels[j]
                      .channelCost !=
                  "") {
            _totalchannels = double.tryParse(_customerCard
                    .cable.boxDetails[i].addonPackage.channels[j].channelCost) +
                _totalchannels;
          }
        }
      }
      _cableMonthlyRentController.text = ((_totalmainpackage +
                  _totalsubpackages +
                  _totalchannels) +
              ((_totalmainpackage + _totalsubpackages + _totalchannels) * 0.18))
          .round()
          .toString();
      setTotalCableRent();
    });
  }

  editPackageDetails() {
    setState(() {
      for (var i = 0; i < addOnPackage.length; i++) {
        addOnPackage[i].selected = false;
      }
      for (var i = 0;
          i <
              _customerCard.cable.boxDetails[_selectedBouquet].addonPackage
                  .subPackages.length;
          i++) {
        for (var j = 0; j < addOnPackage.length; j++) {
          if (addOnPackage[j].packageId ==
              _customerCard.cable.boxDetails[_selectedBouquet].addonPackage
                  .subPackages[i].packageId) {
            addOnPackage[j].selected = true;
          }
        }
      }
      for (var i = 0; i < channel.length; i++) {
        channel[i].selected = false;
        channel[i].package = false;
      }
      for (var i = 0;
          i <
              _customerCard.cable.boxDetails[_selectedBouquet].addonPackage
                  .channels.length;
          i++) {
        for (var j = 0; j < channel.length; j++) {
          if (channel[j].channelId ==
              _customerCard.cable.boxDetails[_selectedBouquet].addonPackage
                  .channels[i].channelId) {
            channel[j].selected = true;
          }
        }
      }
      for (var i = 0;
          i <
              _customerCard.cable.boxDetails[_selectedBouquet].addonPackage
                  .subPackages.length;
          i++) {
        for (var j = 0; j < channel.length; j++) {
          for (var k = 0;
              k <
                  _customerCard.cable.boxDetails[_selectedBouquet].addonPackage
                      .subPackages[i].channels.length;
              k++) {
            if (channel[j].channelId ==
                _customerCard.cable.boxDetails[_selectedBouquet].addonPackage
                    .subPackages[i].channels[k].id) {
              channel[j].selected = true;
              channel[j].package = true;
            }
          }
        }
      }
    });
  }

  Future<bool> _onBackPressedCustomerEdit() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
              isEditBouquetChannelDetails
                  ? "Exit without saving Package ?"
                  : "Exit without saving Customer ?",
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
                    setState(() {
                      if (isEditBouquetChannelDetails) {
                        isEditCustomer = false;
                        isEditCustomerDetails = false;
                        isEditContactDetails = false;
                        isEditCableDetails = true;
                        isEditBouquetChannelDetails = false;
                        isEditInternetDetails = false;
                        _customerCard.cable.boxDetails[_selectedBouquet]
                            .addonPackage.subPackages
                            .clear();
                        for (var i = 0; i < tempAddOnPackage.length; i++) {
                          _customerCard.cable.boxDetails[_selectedBouquet]
                              .addonPackage.subPackages
                              .add(Package(
                                  packageId: tempAddOnPackage[i].packageId,
                                  packageName: tempAddOnPackage[i].packageName,
                                  packageCost: tempAddOnPackage[i].packageCost,
                                  billable: tempAddOnPackage[i].billable,
                                  channels: []));
                          for (var j = 0;
                              j < tempAddOnPackage[i].channels.length;
                              j++) {
                            _customerCard.cable.boxDetails[_selectedBouquet]
                                .addonPackage.subPackages[i].channels
                                .add(MainPackageChannel(
                                    id: tempAddOnPackage[i].channels[j].id,
                                    name:
                                        tempAddOnPackage[i].channels[j].name));
                          }
                        }
                        _customerCard.cable.boxDetails[_selectedBouquet]
                            .addonPackage.channels
                            .clear();
                        for (var i = 0; i < tempChannel.length; i++) {
                          _customerCard.cable.boxDetails[_selectedBouquet]
                              .addonPackage.channels
                              .add(AddonPackageChannel(
                                  channelId: tempChannel[i].channelId,
                                  channelName: tempChannel[i].channelName,
                                  channelCost: tempChannel[i].channelCost,
                                  billable: tempChannel[i].billable));
                        }
                        Navigator.pop(context, false);
                      } else if (isEditCableDetails) {
                        isEditCustomer = true;
                        isEditCustomerDetails = false;
                        isEditContactDetails = false;
                        isEditCableDetails = false;
                        isEditBouquetChannelDetails = false;
                        isEditInternetDetails = false;
                        _customerCard.cable = null;
                        _customerCard.cable = Cable(
                          boxDetails: [],
                          cableAdvanceAmount:
                              _tempCableDetails.cableAdvanceAmount,
                          cableAdvanceAmountPaid:
                              _tempCableDetails.cableAdvanceAmountPaid,
                          cableAdvanceInstallment:
                              _tempCableDetails.cableAdvanceInstallment,
                          cableComments: _tempCableDetails.cableComments,
                          cableDiscount: _tempCableDetails.cableDiscount,
                          cableMonthlyRent: _tempCableDetails.cableMonthlyRent,
                          cableOutstandingAmount:
                              _tempCableDetails.cableOutstandingAmount,
                          noCableConnection:
                              _tempCableDetails.noCableConnection,
                          sortcableOutstandingAmount:
                              _tempCableDetails.sortcableOutstandingAmount,
                        );
                        _customerCard.cable.boxDetails.clear();
                        for (var i = 0;
                            i < _tempCableDetails.boxDetails.length;
                            i++) {
                          _customerCard.cable.boxDetails.add(BoxDetail(
                            activationDate:
                                _tempCableDetails.boxDetails[i].activationDate,
                            addonPackage: AddonPackage(
                              channels: [],
                              packageCost: _tempCableDetails
                                  .boxDetails[i].addonPackage.packageCost,
                              subPackages: [],
                            ),
                            boxType: _tempCableDetails.boxDetails[i].boxType,
                            cableType:
                                _tempCableDetails.boxDetails[i].cableType,
                            freeConnection:
                                _tempCableDetails.boxDetails[i].freeConnection,
                            irdNo: _tempCableDetails.boxDetails[i].irdNo,
                            boxComment:
                                _tempCableDetails.boxDetails[i].boxComment,
                            mainPackage: Package(
                              billable: _tempCableDetails
                                  .boxDetails[i].mainPackage.billable,
                              channels: [],
                              packageCost: _tempCableDetails
                                  .boxDetails[i].mainPackage.packageCost,
                              packageId: _tempCableDetails
                                  .boxDetails[i].mainPackage.packageId,
                              packageName: _tempCableDetails
                                  .boxDetails[i].mainPackage.packageName,
                            ),
                            mainPackageBillable: _tempCableDetails
                                .boxDetails[i].mainPackageBillable,
                            mainPackageCost:
                                _tempCableDetails.boxDetails[i].mainPackageCost,
                            mainPackageId:
                                _tempCableDetails.boxDetails[i].mainPackageId,
                            mainPackageName:
                                _tempCableDetails.boxDetails[i].mainPackageName,
                            msoId: _tempCableDetails.boxDetails[i].msoId,
                            nuidNo: _tempCableDetails.boxDetails[i].nuidNo,
                            vcNo: _tempCableDetails.boxDetails[i].vcNo,
                          ));
                          _customerCard
                              .cable.boxDetails[i].addonPackage.channels
                              .clear();
                          for (var j = 0;
                              j <
                                  _tempCableDetails.boxDetails[i].addonPackage
                                      .channels.length;
                              j++) {
                            _customerCard
                                .cable.boxDetails[i].addonPackage.channels
                                .add(AddonPackageChannel(
                              billable: _tempCableDetails.boxDetails[i]
                                  .addonPackage.channels[j].billable,
                              channelCost: _tempCableDetails.boxDetails[i]
                                  .addonPackage.channels[j].channelCost,
                              channelId: _tempCableDetails.boxDetails[i]
                                  .addonPackage.channels[j].channelId,
                              channelName: _tempCableDetails.boxDetails[i]
                                  .addonPackage.channels[j].channelName,
                            ));
                          }
                          _customerCard
                              .cable.boxDetails[i].addonPackage.subPackages
                              .clear();
                          for (var j = 0;
                              j <
                                  _tempCableDetails.boxDetails[i].addonPackage
                                      .subPackages.length;
                              j++) {
                            _customerCard
                                .cable.boxDetails[i].addonPackage.subPackages
                                .add(Package(
                              billable: _tempCableDetails.boxDetails[i]
                                  .addonPackage.subPackages[j].billable,
                              channels: [],
                              packageCost: _tempCableDetails.boxDetails[i]
                                  .addonPackage.subPackages[j].packageCost,
                              packageId: _tempCableDetails.boxDetails[i]
                                  .addonPackage.subPackages[j].packageId,
                              packageName: _tempCableDetails.boxDetails[i]
                                  .addonPackage.subPackages[j].packageName,
                            ));
                            _customerCard.cable.boxDetails[i].addonPackage
                                .subPackages[j].channels
                                .clear();
                            for (var k = 0;
                                k <
                                    _tempCableDetails.boxDetails[i].addonPackage
                                        .subPackages[j].channels.length;
                                k++) {
                              _customerCard.cable.boxDetails[i].addonPackage
                                  .subPackages[j].channels
                                  .add(MainPackageChannel(
                                      id: _tempCableDetails
                                          .boxDetails[i]
                                          .addonPackage
                                          .subPackages[j]
                                          .channels[k]
                                          .id,
                                      name: _tempCableDetails
                                          .boxDetails[i]
                                          .addonPackage
                                          .subPackages[j]
                                          .channels[k]
                                          .name));
                            }
                          }
                          _customerCard.cable.boxDetails[i].mainPackage.channels
                              .clear();
                          for (var j = 0;
                              j <
                                  _tempCableDetails.boxDetails[i].mainPackage
                                      .channels.length;
                              j++) {
                            _customerCard
                                .cable.boxDetails[i].mainPackage.channels
                                .add(MainPackageChannel(
                              id: _tempCableDetails
                                  .boxDetails[i].mainPackage.channels[j].id,
                              name: _tempCableDetails
                                  .boxDetails[i].mainPackage.channels[j].name,
                            ));
                          }
                        }
                        autoPopulateData();
                        Navigator.pop(context, false);
                      } else {
                        isEditCustomer = true;
                        isEditCustomerDetails = false;
                        isEditContactDetails = false;
                        isEditCableDetails = false;
                        isEditBouquetChannelDetails = false;
                        isEditInternetDetails = false;
                        autoPopulateData();
                        Navigator.pop(context, false);
                      }
                    });
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
              ],
            ),
          ],
        );
      },
    );
  }

  _editCustomerDetails() async {
    if (!isCustomerIdVerified) {
      editCustomerKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.redAccent,
        content: new Text("Customer Id Already Exist!!!"),
      ));
    } else if (editCustomerDetailsKey.currentState.validate()) {
      Customer customer = _customerCard;
      customer.boxEdited = isAlterCurrentBill;
      customer.customerName = _fullname;
      customer.customerId = _customerid;
      customer.barCode = _barcodeid;
      customer.cafNo = _cafno;
      customer.dob = _dobdate == "" ? "" : _dobdate;
      customer.gender = _gender;
      if (editCustomerDetailsKey.currentState.validate()) {
        var connectivityResult = await (new Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          updateCustomerDetails(customer, _customerCard.id).then((response) {
            if (response.statusCode == 200) {
              isEditCustomer = true;
              isEditCustomerDetails = false;
              isEditContactDetails = false;
              isEditCableDetails = false;
              isEditBouquetChannelDetails = false;
              isEditInternetDetails = false;
              _customerCard = customer;
              autoPopulateData();
              editCustomerKey.currentState.showSnackBar(new SnackBar(
                backgroundColor: Colors.green,
                content: new Text("Edited Customer Details Successfully"),
              ));
            }
          });
        } else {
          editCustomerKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("Something went wrong !!"),
          ));
        }
      }
    }
  }

  _editContactDetails() async {
    if (editContactDetailsKey.currentState.validate()) {
      Customer customer = _customerCard;
      customer.boxEdited = isAlterCurrentBill;
      customer.address.doorNo = _flatno;
      customer.address.houseName = _flatname;
      customer.address.residenceType = _residencetype;
      customer.address.alternateNumber = _altno;
      customer.address.area = _areaController.text;
      customer.address.city = _city;
      customer.address.emailId = _email;
      customer.address.landmark = _landmark;
      customer.address.mobile = _mobno;
      customer.address.pincode = _pincode;
      customer.address.state = _state;
      customer.address.street = _streetController.text;
      customer.collectionAgent =
          _collectionagent == "Select Collection Agent" ? "" : _collectionagent;
      customer.ebNumber = _ebno;
      customer.postNumber = _postno;
      if (editContactDetailsKey.currentState.validate()) {
        var connectivityResult = await (new Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          updateCustomerDetails(customer, _customerCard.id).then((response) {
            if (response.statusCode == 200) {
              isEditCustomer = true;
              isEditCustomerDetails = false;
              isEditContactDetails = false;
              isEditCableDetails = false;
              isEditBouquetChannelDetails = false;
              isEditInternetDetails = false;
              _customerCard = customer;
              autoPopulateData();
              editCustomerKey.currentState.showSnackBar(new SnackBar(
                backgroundColor: Colors.green,
                content: new Text("Edited Customer Details Successfully"),
              ));
            }
          });
        } else {
          editCustomerKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("Something went wrong !!"),
          ));
        }
      }
    }
  }

  _editCableDetails() async {
    if (editCableDetailsKey.currentState.validate()) {
      Customer customer = _customerCard;
      customer.boxEdited = isAlterCurrentBill;
      customer.cable.noCableConnection = _cablemonthlyrent == null ||
              _cablemonthlyrent == "" ||
              _cablemonthlyrent == "0" ||
              double.tryParse(_cablemonthlyrent) <= 0
          ? 0
          : customer.cable.noCableConnection;
      customer.cable.cableAdvanceAmount =
          _instalamtCable == null || _instalamtCable == ""
              ? "0"
              : _instalamtCable;
      customer.cable.cableAdvanceInstallment = _instaltypeCable;
      customer.cable.cableAdvanceAmountPaid =
          _instalamtpaidCable == null || _instalamtpaidCable == ""
              ? "0"
              : _instalamtpaidCable;
      customer.cable.cableOutstandingAmount =
          _outstandbalanceCable == null || _outstandbalanceCable == ""
              ? "0"
              : _outstandbalanceCable;
      customer.cable.cableMonthlyRent =
          _cablemonthlyrent == null || _cablemonthlyrent == ""
              ? "0"
              : _cablemonthlyrent;
      customer.cable.cableDiscount =
          _cablediscount == null || _cablediscount == "" ? "0" : _cablediscount;
      customer.cable.cableComments = _cableComment;
      if (editCableDetailsKey.currentState.validate()) {
        var connectivityResult = await (new Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          updateCustomerDetails(customer, _customerCard.id).then((response) {
            if (response.statusCode == 200) {
              isEditCustomer = true;
              isEditCustomerDetails = false;
              isEditContactDetails = false;
              isEditCableDetails = false;
              isEditBouquetChannelDetails = false;
              isEditInternetDetails = false;
              _customerCard = customer;
              autoPopulateData();
              editCustomerKey.currentState.showSnackBar(new SnackBar(
                backgroundColor: Colors.green,
                content: new Text("Edited Customer Details Successfully"),
              ));
            }
          });
        } else {
          editCustomerKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("Something went wrong !!"),
          ));
        }
      }
    }
  }

  _editInternetDetails() async {
    if (editInternetDetailsKey.currentState.validate()) {
      Customer customer = _customerCard;
      customer.boxEdited = isAlterCurrentBill;
      customer.internet.noInternetConnection = _internetmonthlyrent == null ||
              _internetmonthlyrent == "" ||
              _internetmonthlyrent == "0" ||
              double.tryParse(_internetmonthlyrent) <= 0
          ? 0
          : 1;
      customer.internet.planName =
          _internetPlans != null && _internetPlans.planName.isNotEmpty
              ? _internetPlans.planName
              : "";
      customer.internet.internetBillType = _billType;
      customer.internet.ontNo = _ontNumber;
      customer.internet.macId = _macId;
      customer.internet.vLan = _vLan;
      customer.internet.voip = _voip;
      customer.internet.internetActivationDate =
          _actdateInternet == "" ? "" : _actdateInternet;
      customer.internet.internetAdvanceAmount =
          _instalamtInternet == null || _instalamtInternet == ""
              ? "0"
              : _instalamtInternet;
      customer.internet.freeConnection = _freeconnectionInternet;
      customer.internet.internetOutstandingAmount =
          _outstandbalanceInternet == null || _outstandbalanceInternet == ""
              ? "0"
              : _outstandbalanceInternet;
      customer.internet.internetMonthlyRent =
          _internetmonthlyrent == null || _internetmonthlyrent == ""
              ? "0"
              : _internetmonthlyrent;
      customer.internet.internetDiscount =
          _internetdiscount == null || _internetdiscount == ""
              ? "0"
              : _internetdiscount;
      customer.internet.internetComments = _internetComment;
      if (editInternetDetailsKey.currentState.validate()) {
        var connectivityResult = await (new Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          updateCustomerDetails(customer, _customerCard.id).then((response) {
            if (response.statusCode == 200) {
              isEditCustomer = true;
              isEditCustomerDetails = false;
              isEditContactDetails = false;
              isEditCableDetails = false;
              isEditBouquetChannelDetails = false;
              isEditInternetDetails = false;
              _customerCard = customer;
              autoPopulateData();
              editCustomerKey.currentState.showSnackBar(new SnackBar(
                backgroundColor: Colors.green,
                content: new Text("Edited Customer Details Successfully"),
              ));
            }
          });
        } else {
          editCustomerKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent[400],
            content: new Text("Something went wrong !!"),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: !isEditCustomer ? _onBackPressedCustomerEdit : null,
      child: Scaffold(
        key: editCustomerKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            isEditCustomer ? "Edit Customer" : _customerCard.customerName,
          ),
          backgroundColor: Color(0xffae275f),
        ),
        body: isLoading
            ? Loader()
            : Container(
                child: isEditCustomer
                    ? editCustomer()
                    : isEditCustomerDetails
                        ? editCustomerDetails()
                        : isEditContactDetails
                            ? editContactDetails()
                            : isEditCableDetails
                                ? editCableDetails()
                                : isEditBouquetChannelDetails
                                    ? editBouquetChannel()
                                    : isEditInternetDetails
                                        ? editInternetDetails()
                                        : Container(),
              ),
      ),
    );
  }

  editCustomer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 5.0,
        ),
        Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
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
                          color: _customerCard.activeStatus == true
                              ? Colors.green
                              : Colors.red),
                    ),
                    Container(
                        width: 235,
                        child: Text(
                          _customerCard.customerName.toUpperCase(),
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
                                child: Text("ID : " + _customerCard.customerId,
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
                        _customerCard.address.doorNo +
                            ' ' +
                            _customerCard.address.street +
                            ' ' +
                            _customerCard.address.area +
                            ' ' +
                            _customerCard.address.city,
                        style: TextStyle(color: Color(0xfff4f4f4)),
                      )
                    ],
                  ),
                ))),
        Container(
          height: 10.0,
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                isEditCustomer = false;
                isEditCustomerDetails = true;
                isEditContactDetails = false;
                isEditCableDetails = false;
                isEditBouquetChannelDetails = false;
                isEditInternetDetails = false;
                autoPopulateData();
              });
            },
            child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0)),
                margin: new EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 15.0,
                      height: 60.0,
                    ),
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 57, 175, 234),
                      child: Icon(
                        Icons.perm_identity,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 20.0,
                      height: 60.0,
                    ),
                    Expanded(
                      child: Text(
                        "Customer Details",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isEditCustomer = false;
                          isEditCustomerDetails = true;
                          isEditContactDetails = false;
                          isEditCableDetails = false;
                          isEditBouquetChannelDetails = false;
                          isEditInternetDetails = false;
                          autoPopulateData();
                        });
                      },
                    ),
                    Container(
                      width: 15.0,
                      height: 60.0,
                    ),
                  ],
                ))),
        Container(
          height: 10.0,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isEditCustomer = false;
              isEditCustomerDetails = false;
              isEditContactDetails = true;
              isEditCableDetails = false;
              isEditBouquetChannelDetails = false;
              isEditInternetDetails = false;
              autoPopulateData();
            });
          },
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0)),
            margin: new EdgeInsets.symmetric(vertical: 3.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 15.0,
                  height: 60.0,
                ),
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 238, 118, 36),
                  child: Icon(
                    Icons.contact_mail,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 20.0,
                  height: 60.0,
                ),
                Expanded(
                  child: Text(
                    "Contact Details",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isEditCustomer = false;
                      isEditCustomerDetails = false;
                      isEditContactDetails = true;
                      isEditCableDetails = false;
                      isEditBouquetChannelDetails = false;
                      isEditInternetDetails = false;
                      autoPopulateData();
                    });
                  },
                ),
                Container(
                  width: 15.0,
                  height: 60.0,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 10.0,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isEditCustomer = false;
              isEditCustomerDetails = false;
              isEditContactDetails = false;
              isEditCableDetails = true;
              isEditBouquetChannelDetails = false;
              isEditInternetDetails = false;
              double totalSubpackageCost = 0.0;
              double totalChannelCost = 0.0;
              for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
                totalSubpackageCost = 0.0;
                totalChannelCost = 0.0;
                for (var j = 0;
                    j <
                        _customerCard.cable.boxDetails[i].addonPackage
                            .subPackages.length;
                    j++) {
                  if (_customerCard.cable.boxDetails[i].addonPackage
                              .subPackages[j].packageCost !=
                          null &&
                      _customerCard.cable.boxDetails[i].addonPackage
                          .subPackages[j].packageCost.isNotEmpty &&
                      _customerCard.cable.boxDetails[i].addonPackage
                              .subPackages[j].packageCost !=
                          "") {
                    totalSubpackageCost = double.tryParse(_customerCard
                            .cable
                            .boxDetails[i]
                            .addonPackage
                            .subPackages[j]
                            .packageCost) +
                        totalSubpackageCost;
                  }
                }
                for (var j = 0;
                    j <
                        _customerCard
                            .cable.boxDetails[i].addonPackage.channels.length;
                    j++) {
                  if (_customerCard.cable.boxDetails[i].addonPackage.channels[j]
                              .channelCost !=
                          null &&
                      _customerCard.cable.boxDetails[i].addonPackage.channels[j]
                          .channelCost.isNotEmpty &&
                      _customerCard.cable.boxDetails[i].addonPackage.channels[j]
                              .channelCost !=
                          "") {
                    totalChannelCost = double.tryParse(_customerCard
                            .cable
                            .boxDetails[i]
                            .addonPackage
                            .channels[j]
                            .channelCost) +
                        totalChannelCost;
                  }
                }
                _customerCard.cable.boxDetails[i].addonPackage.packageCost =
                    (totalSubpackageCost + totalChannelCost).toString();
              }
              _tempCableDetails = null;
              _tempCableDetails = Cables(
                boxDetails: [],
                cableAdvanceAmount: _customerCard.cable.cableAdvanceAmount,
                cableAdvanceAmountPaid:
                    _customerCard.cable.cableAdvanceAmountPaid,
                cableAdvanceInstallment:
                    _customerCard.cable.cableAdvanceInstallment,
                cableComments: _customerCard.cable.cableComments,
                cableDiscount: _customerCard.cable.cableDiscount,
                cableMonthlyRent: _customerCard.cable.cableMonthlyRent,
                cableOutstandingAmount:
                    _customerCard.cable.cableOutstandingAmount,
                noCableConnection: _customerCard.cable.noCableConnection,
                sortcableOutstandingAmount:
                    _customerCard.cable.sortcableOutstandingAmount,
              );
              _tempCableDetails.boxDetails.clear();
              for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
                _tempCableDetails.boxDetails.add(BoxDetails(
                  activationDate:
                      _customerCard.cable.boxDetails[i].activationDate,
                  addonPackage: AddonPackages(
                    channels: [],
                    packageCost: _customerCard
                        .cable.boxDetails[i].addonPackage.packageCost,
                    subPackages: [],
                  ),
                  boxType: _customerCard.cable.boxDetails[i].boxType,
                  cableType: _customerCard.cable.boxDetails[i].cableType,
                  freeConnection:
                      _customerCard.cable.boxDetails[i].freeConnection,
                  irdNo: _customerCard.cable.boxDetails[i].irdNo,
                  boxComment: _customerCard.cable.boxDetails[i].boxComment,
                  mainPackage: Packages(
                    billable:
                        _customerCard.cable.boxDetails[i].mainPackage.billable,
                    channels: [],
                    packageCost: _customerCard
                        .cable.boxDetails[i].mainPackage.packageCost,
                    packageId:
                        _customerCard.cable.boxDetails[i].mainPackage.packageId,
                    packageName: _customerCard
                        .cable.boxDetails[i].mainPackage.packageName,
                  ),
                  mainPackageBillable:
                      _customerCard.cable.boxDetails[i].mainPackageBillable,
                  mainPackageCost:
                      _customerCard.cable.boxDetails[i].mainPackageCost,
                  mainPackageId:
                      _customerCard.cable.boxDetails[i].mainPackageId,
                  mainPackageName:
                      _customerCard.cable.boxDetails[i].mainPackageName,
                  msoId: _customerCard.cable.boxDetails[i].msoId,
                  nuidNo: _customerCard.cable.boxDetails[i].nuidNo,
                  vcNo: _customerCard.cable.boxDetails[i].vcNo,
                ));
                _tempCableDetails.boxDetails[i].addonPackage.channels.clear();
                for (var j = 0;
                    j <
                        _customerCard
                            .cable.boxDetails[i].addonPackage.channels.length;
                    j++) {
                  _tempCableDetails.boxDetails[i].addonPackage.channels
                      .add(AddonPackageChannels(
                    billable: _customerCard
                        .cable.boxDetails[i].addonPackage.channels[j].billable,
                    channelCost: _customerCard.cable.boxDetails[i].addonPackage
                        .channels[j].channelCost,
                    channelId: _customerCard
                        .cable.boxDetails[i].addonPackage.channels[j].channelId,
                    channelName: _customerCard.cable.boxDetails[i].addonPackage
                        .channels[j].channelName,
                  ));
                }
                _tempCableDetails.boxDetails[i].addonPackage.subPackages
                    .clear();
                for (var j = 0;
                    j <
                        _customerCard.cable.boxDetails[i].addonPackage
                            .subPackages.length;
                    j++) {
                  _tempCableDetails.boxDetails[i].addonPackage.subPackages
                      .add(Packages(
                    billable: _customerCard.cable.boxDetails[i].addonPackage
                        .subPackages[j].billable,
                    channels: [],
                    packageCost: _customerCard.cable.boxDetails[i].addonPackage
                        .subPackages[j].packageCost,
                    packageId: _customerCard.cable.boxDetails[i].addonPackage
                        .subPackages[j].packageId,
                    packageName: _customerCard.cable.boxDetails[i].addonPackage
                        .subPackages[j].packageName,
                  ));
                  _tempCableDetails
                      .boxDetails[i].addonPackage.subPackages[j].channels
                      .clear();
                  for (var k = 0;
                      k <
                          _customerCard.cable.boxDetails[i].addonPackage
                              .subPackages[j].channels.length;
                      k++) {
                    _tempCableDetails
                        .boxDetails[i].addonPackage.subPackages[j].channels
                        .add(MainPackageChannels(
                            id: _customerCard.cable.boxDetails[i].addonPackage
                                .subPackages[j].channels[k].id,
                            name: _customerCard.cable.boxDetails[i].addonPackage
                                .subPackages[j].channels[k].name));
                  }
                }
                _tempCableDetails.boxDetails[i].mainPackage.channels.clear();
                if (_customerCard.cable.boxDetails[i].mainPackage.channels !=
                    null) {
                  for (var j = 0;
                      j <
                          _customerCard
                              .cable.boxDetails[i].mainPackage.channels.length;
                      j++) {
                    _tempCableDetails.boxDetails[i].mainPackage.channels
                        .add(MainPackageChannels(
                      id: _customerCard
                          .cable.boxDetails[i].mainPackage.channels[j].id,
                      name: _customerCard
                          .cable.boxDetails[i].mainPackage.channels[j].name,
                    ));
                  }
                }
              }
              autoPopulateData();
            });
          },
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0)),
            margin: new EdgeInsets.symmetric(vertical: 3.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 15.0,
                  height: 60.0,
                ),
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 126, 116, 240),
                  child: Icon(
                    Icons.tv,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 20.0,
                  height: 60.0,
                ),
                Expanded(
                  child: Text(
                    "Cable Details",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isEditCustomer = false;
                      isEditCustomerDetails = false;
                      isEditContactDetails = false;
                      isEditCableDetails = true;
                      isEditBouquetChannelDetails = false;
                      isEditInternetDetails = false;
                      double totalSubpackageCost = 0.0;
                      double totalChannelCost = 0.0;
                      for (var i = 0;
                          i < _customerCard.cable.boxDetails.length;
                          i++) {
                        totalSubpackageCost = 0.0;
                        totalChannelCost = 0.0;
                        for (var j = 0;
                            j <
                                _customerCard.cable.boxDetails[i].addonPackage
                                    .subPackages.length;
                            j++) {
                          if (_customerCard.cable.boxDetails[i].addonPackage
                                      .subPackages[j].packageCost !=
                                  null &&
                              _customerCard.cable.boxDetails[i].addonPackage
                                  .subPackages[j].packageCost.isNotEmpty &&
                              _customerCard.cable.boxDetails[i].addonPackage
                                      .subPackages[j].packageCost !=
                                  "") {
                            totalSubpackageCost = double.tryParse(_customerCard
                                    .cable
                                    .boxDetails[i]
                                    .addonPackage
                                    .subPackages[j]
                                    .packageCost) +
                                totalSubpackageCost;
                          }
                        }
                        for (var j = 0;
                            j <
                                _customerCard.cable.boxDetails[i].addonPackage
                                    .channels.length;
                            j++) {
                          if (_customerCard.cable.boxDetails[i].addonPackage
                                      .channels[j].channelCost !=
                                  null &&
                              _customerCard.cable.boxDetails[i].addonPackage
                                  .channels[j].channelCost.isNotEmpty &&
                              _customerCard.cable.boxDetails[i].addonPackage
                                      .channels[j].channelCost !=
                                  "") {
                            totalChannelCost = double.tryParse(_customerCard
                                    .cable
                                    .boxDetails[i]
                                    .addonPackage
                                    .channels[j]
                                    .channelCost) +
                                totalChannelCost;
                          }
                        }
                        _customerCard
                                .cable.boxDetails[i].addonPackage.packageCost =
                            (totalSubpackageCost + totalChannelCost).toString();
                      }
                      _tempCableDetails = null;
                      _tempCableDetails = Cables(
                        boxDetails: [],
                        cableAdvanceAmount:
                            _customerCard.cable.cableAdvanceAmount,
                        cableAdvanceAmountPaid:
                            _customerCard.cable.cableAdvanceAmountPaid,
                        cableAdvanceInstallment:
                            _customerCard.cable.cableAdvanceInstallment,
                        cableComments: _customerCard.cable.cableComments,
                        cableDiscount: _customerCard.cable.cableDiscount,
                        cableMonthlyRent: _customerCard.cable.cableMonthlyRent,
                        cableOutstandingAmount:
                            _customerCard.cable.cableOutstandingAmount,
                        noCableConnection:
                            _customerCard.cable.noCableConnection,
                        sortcableOutstandingAmount:
                            _customerCard.cable.sortcableOutstandingAmount,
                      );
                      _tempCableDetails.boxDetails.clear();
                      for (var i = 0;
                          i < _customerCard.cable.boxDetails.length;
                          i++) {
                        _tempCableDetails.boxDetails.add(BoxDetails(
                          activationDate:
                              _customerCard.cable.boxDetails[i].activationDate,
                          addonPackage: AddonPackages(
                            channels: [],
                            packageCost: _customerCard
                                .cable.boxDetails[i].addonPackage.packageCost,
                            subPackages: [],
                          ),
                          boxType: _customerCard.cable.boxDetails[i].boxType,
                          cableType:
                              _customerCard.cable.boxDetails[i].cableType,
                          freeConnection:
                              _customerCard.cable.boxDetails[i].freeConnection,
                          irdNo: _customerCard.cable.boxDetails[i].irdNo,
                          boxComment:
                              _customerCard.cable.boxDetails[i].boxComment,
                          mainPackage: Packages(
                            billable: _customerCard
                                .cable.boxDetails[i].mainPackage.billable,
                            channels: [],
                            packageCost: _customerCard
                                .cable.boxDetails[i].mainPackage.packageCost,
                            packageId: _customerCard
                                .cable.boxDetails[i].mainPackage.packageId,
                            packageName: _customerCard
                                .cable.boxDetails[i].mainPackage.packageName,
                          ),
                          mainPackageBillable: _customerCard
                              .cable.boxDetails[i].mainPackageBillable,
                          mainPackageCost:
                              _customerCard.cable.boxDetails[i].mainPackageCost,
                          mainPackageId:
                              _customerCard.cable.boxDetails[i].mainPackageId,
                          mainPackageName:
                              _customerCard.cable.boxDetails[i].mainPackageName,
                          msoId: _customerCard.cable.boxDetails[i].msoId,
                          nuidNo: _customerCard.cable.boxDetails[i].nuidNo,
                          vcNo: _customerCard.cable.boxDetails[i].vcNo,
                        ));
                        _tempCableDetails.boxDetails[i].addonPackage.channels
                            .clear();
                        for (var j = 0;
                            j <
                                _customerCard.cable.boxDetails[i].addonPackage
                                    .channels.length;
                            j++) {
                          _tempCableDetails.boxDetails[i].addonPackage.channels
                              .add(AddonPackageChannels(
                            billable: _customerCard.cable.boxDetails[i]
                                .addonPackage.channels[j].billable,
                            channelCost: _customerCard.cable.boxDetails[i]
                                .addonPackage.channels[j].channelCost,
                            channelId: _customerCard.cable.boxDetails[i]
                                .addonPackage.channels[j].channelId,
                            channelName: _customerCard.cable.boxDetails[i]
                                .addonPackage.channels[j].channelName,
                          ));
                        }
                        _tempCableDetails.boxDetails[i].addonPackage.subPackages
                            .clear();
                        for (var j = 0;
                            j <
                                _customerCard.cable.boxDetails[i].addonPackage
                                    .subPackages.length;
                            j++) {
                          _tempCableDetails
                              .boxDetails[i].addonPackage.subPackages
                              .add(Packages(
                            billable: _customerCard.cable.boxDetails[i]
                                .addonPackage.subPackages[j].billable,
                            channels: [],
                            packageCost: _customerCard.cable.boxDetails[i]
                                .addonPackage.subPackages[j].packageCost,
                            packageId: _customerCard.cable.boxDetails[i]
                                .addonPackage.subPackages[j].packageId,
                            packageName: _customerCard.cable.boxDetails[i]
                                .addonPackage.subPackages[j].packageName,
                          ));
                          _tempCableDetails.boxDetails[i].addonPackage
                              .subPackages[j].channels
                              .clear();
                          for (var k = 0;
                              k <
                                  _customerCard.cable.boxDetails[i].addonPackage
                                      .subPackages[j].channels.length;
                              k++) {
                            _tempCableDetails.boxDetails[i].addonPackage
                                .subPackages[j].channels
                                .add(MainPackageChannels(
                                    id: _customerCard
                                        .cable
                                        .boxDetails[i]
                                        .addonPackage
                                        .subPackages[j]
                                        .channels[k]
                                        .id,
                                    name: _customerCard
                                        .cable
                                        .boxDetails[i]
                                        .addonPackage
                                        .subPackages[j]
                                        .channels[k]
                                        .name));
                          }
                        }
                        _tempCableDetails.boxDetails[i].mainPackage.channels
                            .clear();
                        for (var j = 0;
                            j <
                                _customerCard.cable.boxDetails[i].mainPackage
                                    .channels.length;
                            j++) {
                          _tempCableDetails.boxDetails[i].mainPackage.channels
                              .add(MainPackageChannels(
                            id: _customerCard
                                .cable.boxDetails[i].mainPackage.channels[j].id,
                            name: _customerCard.cable.boxDetails[i].mainPackage
                                .channels[j].name,
                          ));
                        }
                      }
                      autoPopulateData();
                    });
                  },
                ),
                Container(
                  width: 15.0,
                  height: 60.0,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 10.0,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isEditCustomer = false;
              isEditCustomerDetails = false;
              isEditContactDetails = false;
              isEditCableDetails = false;
              isEditBouquetChannelDetails = false;
              isEditInternetDetails = true;
              autoPopulateData();
            });
          },
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0)),
            margin: new EdgeInsets.symmetric(vertical: 3.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 15.0,
                  height: 60.0,
                ),
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 250, 187, 61),
                  child: Icon(
                    Icons.signal_wifi_4_bar,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 20.0,
                  height: 60.0,
                ),
                Expanded(
                  child: Text(
                    "Internet Details",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isEditCustomer = false;
                      isEditCustomerDetails = false;
                      isEditContactDetails = false;
                      isEditCableDetails = false;
                      isEditBouquetChannelDetails = false;
                      isEditInternetDetails = true;
                      autoPopulateData();
                    });
                  },
                ),
                Container(
                  width: 15.0,
                  height: 60.0,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 10.0,
        ),
      ],
    );
  }

  editCustomerDetails() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5.0,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  child: Card(
                    margin: new EdgeInsets.symmetric(vertical: 5.0),
                    shape: RoundedRectangleBorder(),
                    child: Form(
                      key: editCustomerDetailsKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 10.0),
                            child: TextFormField(
                              controller: _fullnameController,
                              textCapitalization: TextCapitalization.words,
                              maxLines: 1,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter full name";
                                }
                                setState(() {
                                  _fullnameController.text = value;
                                  _fullname = value;
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: "Full Name",
                                  labelStyle: TextStyle(fontSize: 12.0)),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _customeridController,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _customeridController.text = value;
                                      _customerid = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Customer Id",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  maxLines: 1,
                                  controller: _barcodeIDController,
                                  decoration: InputDecoration(
                                      labelText: "Barcode Id",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                              InkWell(
                                onTap: scanBarcodeID,
                                highlightColor: Colors.green,
                                child: Icon(
                                  Icons.center_focus_weak,
                                  size: 30.0,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              Container(width: 10.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _cafnoController,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _cafnoController.text = value;
                                      _cafno = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "CAF No",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                              Expanded(
                                flex: 0,
                                child: Text('Date Of Birth: '),
                              ),
                              Container(width: 5.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _dobController,
                                  maxLines: 1,
                                  keyboardType: TextInputType.datetime,
                                  validator: (value) {
                                    setState(() {
                                      _dobController.text = value;
                                      _dobdate = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "DD-MM-YYYY",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                              InkWell(
                                onTap: () {
                                  _selectDOBDate(context);
                                },
                                highlightColor: Colors.green,
                                child: Icon(
                                  Icons.date_range,
                                  size: 30.0,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              Container(width: 10.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0),
                                child: Text(
                                  "Gender : ",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Radio(
                                          value: "Male",
                                          groupValue: _gender,
                                          onChanged: (value) {
                                            setState(() {
                                              _gender = value;
                                            });
                                          },
                                          activeColor: Color(0xffae275f),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _gender = "Male";
                                            });
                                          },
                                          child: Text(
                                            "Male",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ),
                                        Radio(
                                          value: "Female",
                                          groupValue: _gender,
                                          onChanged: (value) {
                                            setState(() {
                                              _gender = value;
                                            });
                                          },
                                          activeColor: Color(0xffae275f),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _gender = "Female";
                                            });
                                          },
                                          child: Text(
                                            "Female",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ),
                                        Radio(
                                          value: "Others",
                                          groupValue: _gender,
                                          onChanged: (value) {
                                            setState(() {
                                              _gender = value;
                                            });
                                          },
                                          activeColor: Color(0xffae275f),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _gender = "Others";
                                            });
                                          },
                                          child: Text(
                                            "Others",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                                  _onBackPressedCustomerEdit();
                                });
                              },
                              child: Text("Cancel"),
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
                                  _editCustomerDetails();
                                });
                              },
                              child: Text("Save"),
                            ),
                          ),
                          Container(
                            width: 5.0,
                          ),
                        ],
                      ),
                    ],
                  )))),
        ]);
  }

  editContactDetails() {
    List<String> collectionAgentList = ['Select Collection Agent'];
    List<String> streetList = [];
    List<String> areaList = [];
    for (int i = 0; i < areas.length; i++) {
      areaList.add(areas[i].area);
    }
    for (int i = 0; i < collectionagents.length; i++) {
      collectionAgentList.add(collectionagents[i].userName);
    }
    for (int i = 0; i < streets.length; i++) {
      streetList.add(streets[i].street);
    }
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5.0,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    shape: RoundedRectangleBorder(),
                    child: Form(
                      key: editContactDetailsKey,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                value: "Owned",
                                groupValue: _residencetype,
                                onChanged: (value) {
                                  setState(() {
                                    _residencetype = value;
                                  });
                                },
                                activeColor: Color(0xffae275f),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _residencetype = "Owned";
                                  });
                                },
                                child: Text(
                                  "Owned",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ),
                              Radio(
                                value: "Rent",
                                groupValue: _residencetype,
                                onChanged: (value) {
                                  setState(() {
                                    _residencetype = value;
                                  });
                                },
                                activeColor: Color(0xffae275f),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _residencetype = "Rent";
                                  });
                                },
                                child: Text(
                                  "Rent",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ),
                              Container(width: 20.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _flatnoController,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _flatnoController.text = value;
                                      _flatno = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Door/Flat Number",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _flatnameController,
                                  textCapitalization: TextCapitalization.words,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _flatnameController.text = value;
                                      _flatname = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "House/Flat Name & Floor",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                              Expanded(
                                child: TypeAheadField<String>(
                                  hideOnEmpty: true,
                                  hideSuggestionsOnKeyboardHide: false,
                                  getImmediateSuggestions: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                          controller: _streetController,
                                          decoration: InputDecoration(
                                            labelText: "Street",
                                            labelStyle:
                                                TextStyle(fontSize: 12.0),
                                          )),
                                  suggestionsCallback: (String pattern) async {
                                    return streetList
                                        .where((item) => item
                                            .toLowerCase()
                                            .startsWith(pattern.toLowerCase()))
                                        .toList();
                                  },
                                  itemBuilder: (context, String suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  onSuggestionSelected: (String suggestion) {
                                    setState(() {
                                      _street = suggestion;
                                      _streetController.text = _street;
                                      setStreetAutofill();
                                    });
                                  },
                                ),
                              ),
                              Container(width: 10.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10.0),
                              Expanded(
                                child: TypeAheadField<String>(
                                  hideOnEmpty: true,
                                  hideSuggestionsOnKeyboardHide: false,
                                  getImmediateSuggestions: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                          controller: _areaController,
                                          decoration: InputDecoration(
                                            labelText: "Area",
                                            labelStyle:
                                                TextStyle(fontSize: 12.0),
                                          )),
                                  suggestionsCallback: (String pattern) async {
                                    return areaList
                                        .where((item) => item
                                            .toLowerCase()
                                            .startsWith(pattern.toLowerCase()))
                                        .toList();
                                  },
                                  itemBuilder: (context, String suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  onSuggestionSelected: (String suggestion) {
                                    setState(() {
                                      _area = suggestion;
                                      _areaController.text = _area;
                                      setAreaAutofill();
                                    });
                                  },
                                ),
                              ),
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _landmarkController,
                                  textCapitalization: TextCapitalization.words,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _landmarkController.text = value;
                                      _landmark = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "LandMark",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _cityController,
                                  textCapitalization: TextCapitalization.words,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _cityController.text = value;
                                      _city = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "City/District",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _stateController,
                                  textCapitalization: TextCapitalization.words,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _stateController.text = value;
                                      _state = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "State",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _pincodeController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _pincodeController.text = value;
                                      _pincode = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Pincode",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _emailController,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _emailController.text = value;
                                      _email = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Email",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _mobnoController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _mobnoController.text = value;
                                      _mobno = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Mobile Number",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _altnoController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _altnoController.text = value;
                                      _altno = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Alternate Number",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _ebnoController,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _ebnoController.text = value;
                                      _ebno = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "EB Number",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _postnoController,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _postnoController.text = value;
                                      _postno = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Post Number",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10.0),
                              Expanded(
                                  child: DropdownButton<String>(
                                      elevation: 8,
                                      isExpanded: true,
                                      items: collectionAgentList
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: 10.0,
                                              ),
                                              Text(
                                                value,
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12.0),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      value: _collectionagent,
                                      onChanged: (newVal) {
                                        _collectionagent = newVal;
                                        setState(() {});
                                      })),
                              Container(width: 10.0),
                            ],
                          ),
                          Container(height: 5.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                                  _onBackPressedCustomerEdit();
                                });
                              },
                              child: Text("Cancel"),
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
                                  _editContactDetails();
                                });
                              },
                              child: Text("Save"),
                            ),
                          ),
                          Container(
                            width: 5.0,
                          ),
                        ],
                      ),
                    ],
                  )))),
        ]);
  }

  editCableDetails() {
    var boxes = List<Widget>();
    for (var i = 0; i < _customerCard.cable.boxDetails.length; i++) {
      var box = new Container(
        margin: new EdgeInsets.symmetric(horizontal: 4.0),
        child: editBoxDetails(i),
      );
      boxes.add(box);
    }
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5.0,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  child: Card(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    shape: RoundedRectangleBorder(),
                    child: Form(
                      key: editCableDetailsKey,
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: boxes,
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _instalamtCableController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _instalamtCableController.text = value;
                                      _instalamtCable = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Installation Amount",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                              Row(
                                children: <Widget>[
                                  Radio(
                                    value: "Fully Paid",
                                    groupValue: _instaltypeCable,
                                    onChanged: (value) {
                                      setState(() {
                                        isInstallmentCable = false;
                                        _instaltypeCable = value;
                                        _instalamtpaidCableController.text = "";
                                      });
                                    },
                                    activeColor: Color(0xffae275f),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isInstallmentCable = false;
                                        _instaltypeCable = "Fully Paid";
                                        _instalamtpaidCableController.text = "";
                                      });
                                    },
                                    child: Text(
                                      "Fully Paid",
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                  Radio(
                                    value: "Installment",
                                    groupValue: _instaltypeCable,
                                    onChanged: (value) {
                                      setState(() {
                                        isInstallmentCable = true;
                                        _instaltypeCable = value;
                                        _instalamtpaidCableController.text =
                                            "0";
                                      });
                                    },
                                    activeColor: Color(0xffae275f),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isInstallmentCable = true;
                                        _instaltypeCable = "Installment";
                                        _instalamtpaidCableController.text =
                                            "0";
                                      });
                                    },
                                    child: Text(
                                      "Installment",
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                ],
                              ),
                              Container(width: 10.0),
                            ],
                          ),
                          isInstallmentCable
                              ? Row(
                                  children: <Widget>[
                                    Container(width: 210.0),
                                    Expanded(
                                      child: TextFormField(
                                        controller:
                                            _instalamtpaidCableController,
                                        keyboardType: TextInputType.number,
                                        maxLines: 1,
                                        validator: (value) {
                                          setState(() {
                                            _instalamtpaidCableController.text =
                                                value;
                                            _instalamtpaidCable = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            labelText:
                                                "Installation Amount Paid",
                                            labelStyle:
                                                TextStyle(fontSize: 12.0)),
                                      ),
                                    ),
                                    Container(width: 10.0),
                                  ],
                                )
                              : Row(
                                  children: <Widget>[
                                    Container(),
                                  ],
                                ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _outstandbalanceCableController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _outstandbalanceCableController.text =
                                          value;
                                      _outstandbalanceCable = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Outstanding Balance",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(
                                width: 5.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _cableMonthlyRentController,
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    setState(() {
                                      _cableMonthlyRentController.text = value;
                                      _cablemonthlyrent = value;
                                      setTotalCableRent();
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Monthly Rent",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(
                                width: 10.0,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _cableDiscountController,
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    setState(() {
                                      _cableDiscountController.text = value;
                                      _cablediscount = value;
                                      setTotalCableRent();
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Discount",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(
                                width: 5.0,
                              ),
                              Expanded(
                                child: Text(
                                    "Total Rental: Rs." + _cabletotalrental),
                              ),
                              Container(
                                width: 10.0,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _cableCommentController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _cableCommentController.text = value;
                                      _cableComment = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Cable Comment",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(
                                width: 10.0,
                              ),
                            ],
                          ),
                          Container(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              Checkbox(
                                onChanged: (value) {
                                  setState(() {
                                    isAlterCurrentBill = value;
                                  });
                                },
                                value: isAlterCurrentBill,
                                activeColor: Color(0xffae275f),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isAlterCurrentBill == false) {
                                      isAlterCurrentBill = true;
                                    } else {
                                      isAlterCurrentBill = false;
                                    }
                                  });
                                },
                                child: Text(
                                  "Alter Current Bill",
                                ),
                              ),
                              Container(
                                width: 10.0,
                              ),
                            ],
                          ),
                          Container(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                                  _onBackPressedCustomerEdit();
                                });
                              },
                              child: Text("Cancel"),
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
                                  _editCableDetails();
                                });
                              },
                              child: Text("Save"),
                            ),
                          ),
                          Container(
                            width: 5.0,
                          ),
                        ],
                      ),
                    ],
                  )))),
        ]);
  }

  editBoxDetails(i) {
    List<String> msoList = ['Select MSO'];

    for (int i = 0; i < msoname.length; i++) {
      msoList.add(msoname[i].msoName);
    }

    return Column(
      children: <Widget>[
        Container(
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xFFF9B224),
              ),
            ),
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Column(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF9B224),
                    ),
                    alignment: Alignment.centerLeft,
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    child: Text(
                      'Connection and Package Details - ' + (i + 1).toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Radio(
                      value: "Digital",
                      groupValue: _cabletype[i],
                      onChanged: (value) {
                        setState(() {
                          _cabletype[i] = value;
                          _customerCard.cable.boxDetails[i].cableType =
                              _cabletype[i];
                        });
                      },
                      activeColor: Color(0xffae275f),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _cabletype[i] = "Digital";
                          _customerCard.cable.boxDetails[i].cableType =
                              _cabletype[i];
                        });
                      },
                      child: Text(
                        "Digital",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Radio(
                      value: "Analog",
                      groupValue: _cabletype[i],
                      onChanged: (value) {
                        setState(() {
                          _cabletype[i] = value;
                          _customerCard.cable.boxDetails[i].cableType =
                              _cabletype[i];
                        });
                      },
                      activeColor: Color(0xffae275f),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _cabletype[i] = "Analog";
                          _customerCard.cable.boxDetails[i].cableType =
                              _cabletype[i];
                        });
                      },
                      child: Text(
                        "Analog",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Checkbox(
                      value: _freeconnectionCable[i],
                      onChanged: (value) {
                        setState(() {
                          _freeconnectionCable[i] = value;
                          _customerCard.cable.boxDetails[i].freeConnection =
                              _freeconnectionCable[i];
                        });
                      },
                      activeColor: Color(0xffae275f),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_freeconnectionCable[i] == false) {
                            _freeconnectionCable[i] = true;
                          } else {
                            _freeconnectionCable[i] = false;
                          }
                          _customerCard.cable.boxDetails[i].freeConnection =
                              _freeconnectionCable[i];
                        });
                      },
                      child: Text(
                        "Free Connection",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                        child: DropdownButton<String>(
                            elevation: 8,
                            isExpanded: true,
                            items: msoList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 10.0,
                                    ),
                                    Text(
                                      value,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            value: _msoname[i],
                            onChanged: (newVal) {
                              setState(() {
                                _msoname[i] = newVal;
                                _customerCard.cable.boxDetails[i].msoId =
                                    _msoname[i];
                              });
                            })),
                    Container(
                      width: 5.0,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(width: 5.0),
                    Expanded(
                      child: Radio(
                        value: "SD",
                        groupValue: _boxtype[i],
                        onChanged: (value) {
                          setState(() {
                            _boxtype[i] = value;
                            _customerCard.cable.boxDetails[i].boxType =
                                _boxtype[i];
                          });
                        },
                        activeColor: Color(0xffae275f),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _boxtype[i] = "SD";
                            _customerCard.cable.boxDetails[i].boxType =
                                _boxtype[i];
                          });
                        },
                        child: Text(
                          "SD",
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Radio(
                        value: "HD",
                        groupValue: _boxtype[i],
                        onChanged: (value) {
                          setState(() {
                            _boxtype[i] = value;
                            _customerCard.cable.boxDetails[i].boxType =
                                _boxtype[i];
                          });
                        },
                        activeColor: Color(0xffae275f),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _boxtype[i] = "HD";
                            _customerCard.cable.boxDetails[i].boxType =
                                _boxtype[i];
                          });
                        },
                        child: Text(
                          "HD",
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ),
                    Container(width: 5.0),
                    Expanded(
                      flex: 0,
                      child: Text('Activation Date : '),
                    ),
                    Container(width: 5.0),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: _actDateCableController[i],
                        maxLines: 1,
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          setState(() {
                            _actDateCableController[i].text = value;
                            _actdateCable[i] = value;
                            _customerCard.cable.boxDetails[i].activationDate =
                                _actdateCable[i];
                          });
                        },
                        decoration: InputDecoration(
                            labelText: "DD-MM-YYYY",
                            labelStyle: TextStyle(fontSize: 12.0)),
                      ),
                    ),
                    Container(width: 10.0),
                    InkWell(
                      onTap: () {
                        _selectActDateCable(context, i);
                      },
                      highlightColor: Colors.green,
                      child: Icon(
                        Icons.date_range,
                        size: 30.0,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Container(width: 5.0),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(width: 5.0),
                    Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        controller: _vcnoController[i],
                        validator: (value) {
                          setState(() {
                            _vcnoController[i].text = value;
                            _vcno[i] = value;
                            _customerCard.cable.boxDetails[i].vcNo = _vcno[i];
                          });
                        },
                        decoration: InputDecoration(
                            labelText: "VC Number",
                            labelStyle: TextStyle(fontSize: 12.0)),
                      ),
                    ),
                    Container(width: 10.0),
                    InkWell(
                      onTap: () {
                        setState(() {
                          scanVCNO(i);
                        });
                      },
                      highlightColor: Colors.green,
                      child: Icon(
                        Icons.center_focus_weak,
                        size: 30.0,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Container(width: 5.0),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(width: 5.0),
                    Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        controller: _nuidController[i],
                        validator: (value) {
                          setState(() {
                            _nuidController[i].text = value;
                            _nuid[i] = value;
                            _customerCard.cable.boxDetails[i].nuidNo = _nuid[i];
                          });
                        },
                        decoration: InputDecoration(
                            labelText: "NUID Number",
                            labelStyle: TextStyle(fontSize: 12.0)),
                      ),
                    ),
                    Container(width: 10.0),
                    InkWell(
                      onTap: () {
                        setState(() {
                          scanNUID(i);
                        });
                      },
                      highlightColor: Colors.green,
                      child: Icon(
                        Icons.center_focus_weak,
                        size: 30.0,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Container(width: 5.0),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(width: 5.0),
                    Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        controller: _irdController[i],
                        validator: (value) {
                          setState(() {
                            _irdController[i].text = value;
                            _ird[i] = value;
                            _customerCard.cable.boxDetails[i].irdNo = _ird[i];
                          });
                        },
                        decoration: InputDecoration(
                            labelText: "IRD Number",
                            labelStyle: TextStyle(fontSize: 12.0)),
                      ),
                    ),
                    Container(width: 10.0),
                    InkWell(
                      onTap: () {
                        setState(() {
                          scanIRD(i);
                        });
                      },
                      highlightColor: Colors.green,
                      child: Icon(
                        Icons.center_focus_weak,
                        size: 30.0,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Container(width: 5.0),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(width: 5.0),
                    Expanded(
                      child: TextFormField(
                        controller: _boxcommentController[i],
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 1,
                        validator: (value) {
                          _boxcommentController[i].text = value;
                          _boxcomment[i] = value;
                          _customerCard.cable.boxDetails[i].boxComment =
                              _boxcomment[i];
                        },
                        decoration: InputDecoration(
                            labelText: "Box Comment",
                            labelStyle: TextStyle(fontSize: 12.0)),
                      ),
                    ),
                    Container(width: 5.0),
                  ],
                ),
                Container(
                  height: 5.0,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(width: 5.0),
                      Expanded(
                          flex: 3,
                          child: DropdownButton<MainPackage>(
                            disabledHint: new Text(
                                      "None",
                                    ),
                              hint: new Text(
                                "Select Main Package",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12.0),
                              ),
                              elevation: 8,
                              isExpanded: true,
                              items: mainpackage.map((MainPackage value) {
                                return DropdownMenuItem<MainPackage>(
                                  value: value,
                                  child: Text(
                                    value.packageName +
                                        " - Rs. " +
                                        value.packageCost.toString(),
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12.0),
                                  ),
                                );
                              }).toList(),
                              value: _mainpackage[i],
                              onChanged: (newVal) {
                                setState(() {
                                  _mainpackage[i] = newVal;
                                  _customerCard.cable.boxDetails[i].mainPackage
                                          .packageId =
                                      _mainpackage[i] == null
                                          ? ""
                                          : _mainpackage[i].id;
                                  _customerCard.cable.boxDetails[i].mainPackage
                                      .billable = _billing[i];
                                  _customerCard.cable.boxDetails[i].mainPackage
                                      .channels = [];
                                  _customerCard.cable.boxDetails[i].mainPackage
                                      .packageCost = _mainpackage[i] ==
                                          null
                                      ? ""
                                      : _mainpackage[i].packageCost.toString();
                                  _customerCard.cable.boxDetails[i].mainPackage
                                          .packageName =
                                      _mainpackage[i] == null
                                          ? ""
                                          : _mainpackage[i].packageName;

                                  setCableRent();
                                });
                              })),
                      Container(width: 10.0),
                      _mainpackage[i] != null
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _mainpackage[i] = null;
                                  _customerCard.cable.boxDetails[i].mainPackage
                                          .packageId =
                                      _mainpackage[i] == null
                                          ? ""
                                          : _mainpackage[i].id;
                                  _customerCard.cable.boxDetails[i].mainPackage
                                      .billable = _billing[i];
                                  _customerCard.cable.boxDetails[i].mainPackage
                                      .channels = [];
                                  _customerCard.cable.boxDetails[i].mainPackage
                                      .packageCost = _mainpackage[i] ==
                                          null
                                      ? ""
                                      : _mainpackage[i].packageCost.toString();
                                  _customerCard.cable.boxDetails[i].mainPackage
                                          .packageName =
                                      _mainpackage[i] == null
                                          ? ""
                                          : _mainpackage[i].packageName;
                                  setCableRent();
                                });
                              },
                              icon: Icon(
                                Icons.remove_circle_outline,
                              ),
                            )
                          : Container(),
                      Container(width: 10.0),
                      Expanded(
                        flex: 1,
                        child: DropdownButton<String>(
                            isExpanded: true,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12.0),
                            items: <String>[
                              'Repeat',
                              '1 Month',
                              '2 Months',
                              '3 Months',
                              '6 Months',
                              '1 Year'
                            ].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            value: _billing[i],
                            onChanged: (newVal) {
                              setState(() {
                                _billing[i] = newVal;
                                _customerCard.cable.boxDetails[i]
                                    .mainPackageBillable = _billing[i];
                              });
                            }),
                      ),
                      Container(width: 5.0),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 40.0,
                    ),
                    Expanded(
                      child: FloatingActionButton(
                        elevation: 0.0,
                        mini: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(
                            color: Color(0XFF39afea),
                            width: 1.0,
                          ),
                        ),
                        backgroundColor: Color(0XFF39afea),
                        foregroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            isEditCustomer = false;
                            isEditCustomerDetails = false;
                            isEditContactDetails = false;
                            isEditCableDetails = false;
                            isEditBouquetChannelDetails = true;
                            isEditInternetDetails = false;
                            _selectedBouquet = i;
                            tempAddOnPackage.clear();
                            for (var i = 0;
                                i <
                                    _customerCard
                                        .cable
                                        .boxDetails[_selectedBouquet]
                                        .addonPackage
                                        .subPackages
                                        .length;
                                i++) {
                              tempAddOnPackage.add(AddOnPackage(
                                  packageId: _customerCard
                                      .cable
                                      .boxDetails[_selectedBouquet]
                                      .addonPackage
                                      .subPackages[i]
                                      .packageId,
                                  packageName: _customerCard
                                      .cable
                                      .boxDetails[_selectedBouquet]
                                      .addonPackage
                                      .subPackages[i]
                                      .packageName,
                                  packageCost: _customerCard
                                      .cable
                                      .boxDetails[_selectedBouquet]
                                      .addonPackage
                                      .subPackages[i]
                                      .packageCost,
                                  billable: _customerCard
                                      .cable
                                      .boxDetails[_selectedBouquet]
                                      .addonPackage
                                      .subPackages[i]
                                      .billable,
                                  channels: []));
                              for (var j = 0;
                                  j <
                                      _customerCard
                                          .cable
                                          .boxDetails[_selectedBouquet]
                                          .addonPackage
                                          .subPackages[i]
                                          .channels
                                          .length;
                                  j++) {
                                tempAddOnPackage[i].channels.add(
                                    AddOnPackageChannel(
                                        id: _customerCard
                                            .cable
                                            .boxDetails[_selectedBouquet]
                                            .addonPackage
                                            .subPackages[i]
                                            .channels[j]
                                            .id,
                                        name: _customerCard
                                            .cable
                                            .boxDetails[_selectedBouquet]
                                            .addonPackage
                                            .subPackages[i]
                                            .channels[j]
                                            .name));
                              }
                            }
                            tempChannel.clear();
                            for (var i = 0;
                                i <
                                    _customerCard
                                        .cable
                                        .boxDetails[_selectedBouquet]
                                        .addonPackage
                                        .channels
                                        .length;
                                i++) {
                              tempChannel.add(Channel(
                                  channelId: _customerCard
                                      .cable
                                      .boxDetails[_selectedBouquet]
                                      .addonPackage
                                      .channels[i]
                                      .channelId,
                                  channelName: _customerCard
                                      .cable
                                      .boxDetails[_selectedBouquet]
                                      .addonPackage
                                      .channels[i]
                                      .channelName,
                                  channelCost: _customerCard
                                      .cable
                                      .boxDetails[_selectedBouquet]
                                      .addonPackage
                                      .channels[i]
                                      .channelCost,
                                  billable: _customerCard
                                      .cable
                                      .boxDetails[_selectedBouquet]
                                      .addonPackage
                                      .channels[i]
                                      .billable));
                            }
                            isBouquetChannel = true;
                            isBouquetSelected = false;
                            isChannelSelected = false;
                            editPackageDetails();
                          });
                        },
                        child: Text(
                          "Add Bouquets/Add On/Ala Carte",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      width: 40.0,
                    ),
                  ],
                ),
                Container(height: 5.0),
                _mainpackage[i] == null &&
                        _customerCard.cable.boxDetails[i].addonPackage
                                .subPackages.length <
                            1 &&
                        _customerCard.cable.boxDetails[i].addonPackage.channels
                                .length <
                            1
                    ? Container()
                    : Column(
                        children: <Widget>[
                          Material(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: GroovinExpansionTile(
                              initiallyExpanded: true,
                              defaultTrailingIconColor: Colors.indigoAccent,
                              leading: CircleAvatar(
                                backgroundColor: Colors.indigoAccent,
                                child: Icon(
                                  Icons.live_tv,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                "Subscription Details",
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: TextStyle(color: Colors.black),
                              ),
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5.0),
                                    bottomRight: Radius.circular(5.0),
                                  ),
                                  child: Column(
                                    children: <Widget>[_subscriptionDetails(i)],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _subscriptionDetails(int selectedbouquet) {
    var addons = List<TableRow>();

    for (var i = 0;
        i <
            _customerCard.cable.boxDetails[selectedbouquet].addonPackage
                .subPackages.length;
        i++) {
      var addon = _addonPackList(_customerCard
          .cable.boxDetails[selectedbouquet].addonPackage.subPackages[i]);
      addons.add(addon);
    }
    var channels = List<TableRow>();

    for (var i = 0;
        i <
            _customerCard
                .cable.boxDetails[selectedbouquet].addonPackage.channels.length;
        i++) {
      var channel = _addonChannelList(_customerCard
          .cable.boxDetails[selectedbouquet].addonPackage.channels[i]);
      channels.add(channel);
    }
    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Table(
              border: TableBorder.all(width: 1.0, color: Colors.black45),
              children: [
                TableRow(children: [
                  TableCell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black54,
                          ),
                          width: 15.0,
                        ),
                        SizedBox(
                            child: Text(
                              "Subscription",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            width: 100.0),
                        SizedBox(
                          child: Text(
                            "MRP",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                          width: 60.0,
                        ),
                        SizedBox(
                          child: Text(
                            "GST",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                          width: 60.0,
                        ),
                        SizedBox(
                          child: Text(
                            "Total",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                          width: 60.0,
                        ),
                      ],
                    ),
                  )
                ]),
                _mainpackage[selectedbouquet] != null
                    ? TableRow(children: [
                        TableCell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black54,
                                ),
                                width: 15.0,
                              ),
                              SizedBox(
                                child: Text(
                                    _mainpackage[selectedbouquet].packageName),
                                width: 100.0,
                              ),
                              SizedBox(
                                child: Text(
                                  (formatters.format(
                                          _mainpackage[selectedbouquet]
                                              .packageCost))
                                      .toString(),
                                  textAlign: TextAlign.right,
                                ),
                                width: 50.0,
                              ),
                              SizedBox(
                                child: Text(
                                  (formatters.format((18 / 100) *
                                          _mainpackage[selectedbouquet]
                                              .packageCost))
                                      .toString(),
                                  textAlign: TextAlign.right,
                                ),
                                width: 60.0,
                              ),
                              SizedBox(
                                child: Text(
                                  (formatters.format(((18 / 100) *
                                              _mainpackage[selectedbouquet]
                                                  .packageCost) +
                                          _mainpackage[selectedbouquet]
                                              .packageCost))
                                      .toString(),
                                  textAlign: TextAlign.right,
                                ),
                                width: 60.0,
                              ),
                            ],
                          ),
                        )
                      ])
                    : TableRow(children: [
                        TableCell(
                          child: Row(),
                        )
                      ]),
              ],
            ),
            SizedBox(
              height: 1.0,
            ),
            Table(
                border: TableBorder.all(width: 1.0, color: Colors.black45),
                children: addons),
            SizedBox(
              height: 0.5,
            ),
            Table(
                border: TableBorder.all(width: 1.0, color: Colors.black45),
                children: channels),
            SizedBox(
              height: 1.0,
            ),
            Table(
                border: TableBorder.all(width: 1.0, color: Colors.black45),
                children: [
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black,
                            ),
                            width: 15.0,
                          ),
                          SizedBox(
                            child: Text("Total",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            width: 100.0,
                          ),
                          SizedBox(
                            child: Text(
                              (formatters.format(
                                      _mainpackage[selectedbouquet] !=
                                              null
                                          ? _mainpackage[selectedbouquet]
                                                  .packageCost +
                                              double.tryParse(_customerCard
                                                  .cable
                                                  .boxDetails[selectedbouquet]
                                                  .addonPackage
                                                  .packageCost)
                                          : double.tryParse(_customerCard
                                              .cable
                                              .boxDetails[selectedbouquet]
                                              .addonPackage
                                              .packageCost)))
                                  .toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
                            width: 50.0,
                          ),
                          SizedBox(
                            child: Text(
                              (formatters.format((18 / 100) *
                                      (_mainpackage[selectedbouquet] != null
                                          ? _mainpackage[selectedbouquet]
                                                  .packageCost +
                                              double.tryParse(_customerCard
                                                  .cable
                                                  .boxDetails[selectedbouquet]
                                                  .addonPackage
                                                  .packageCost)
                                          : double.tryParse(_customerCard
                                              .cable
                                              .boxDetails[selectedbouquet]
                                              .addonPackage
                                              .packageCost))))
                                  .toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
                            width: 60.0,
                          ),
                          SizedBox(
                            child: Text(
                              (formatters.format(((18 / 100) *
                                          (_mainpackage[selectedbouquet] != null
                                              ? _mainpackage[selectedbouquet]
                                                      .packageCost +
                                                  double.tryParse(_customerCard
                                                      .cable
                                                      .boxDetails[
                                                          selectedbouquet]
                                                      .addonPackage
                                                      .packageCost)
                                              : double.tryParse(_customerCard
                                                  .cable
                                                  .boxDetails[selectedbouquet]
                                                  .addonPackage
                                                  .packageCost))) +
                                      (_mainpackage[selectedbouquet] != null
                                          ? _mainpackage[selectedbouquet].packageCost +
                                              double.tryParse(
                                                  _customerCard.cable.boxDetails[selectedbouquet].addonPackage.packageCost)
                                          : double.tryParse(_customerCard.cable.boxDetails[selectedbouquet].addonPackage.packageCost))))
                                  .toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
                            width: 60.0,
                          ),
                        ],
                      ),
                    )
                  ])
                ]),
            SizedBox(
              height: 10.0,
            )
          ],
        )
      ],
    );
  }

  _addonPackList(Package addon) {
    if (addon.packageName != null && addon.packageCost != null) {
      return TableRow(children: [
        TableCell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black54,
                ),
                width: 15.0,
              ),
              SizedBox(
                child: Text(addon.packageName),
                width: 100.0,
              ),
              SizedBox(
                child: Text(
                  (formatters.format(double.tryParse(addon.packageCost)))
                      .toString(),
                  textAlign: TextAlign.right,
                ),
                width: 50.0,
              ),
              SizedBox(
                child: Text(
                  (formatters.format(
                          (18 / 100) * double.tryParse(addon.packageCost)))
                      .toString(),
                  textAlign: TextAlign.right,
                ),
                width: 60.0,
              ),
              SizedBox(
                child: Text(
                  (formatters.format(
                          ((18 / 100) * double.tryParse(addon.packageCost)) +
                              double.tryParse(addon.packageCost)))
                      .toString(),
                  textAlign: TextAlign.right,
                ),
                width: 60.0,
              ),
            ],
          ),
        )
      ]);
    } else {
      return TableRow(children: [
        TableCell(
          child: Row(),
        )
      ]);
    }
  }

  _addonChannelList(AddonPackageChannel channel) {
    if (channel.channelName != null) {
      return TableRow(children: [
        TableCell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black54,
                ),
                width: 15.0,
              ),
              SizedBox(
                child: Text(channel.channelName),
                width: 100.0,
              ),
              SizedBox(
                child: Text(
                  (formatters.format(double.tryParse(channel.channelCost)))
                      .toString(),
                  textAlign: TextAlign.right,
                ),
                width: 50.0,
              ),
              SizedBox(
                child: Text(
                  (formatters.format(
                          (18 / 100) * double.tryParse(channel.channelCost)))
                      .toString(),
                  textAlign: TextAlign.right,
                ),
                width: 60.0,
              ),
              SizedBox(
                child: Text(
                  (formatters.format(
                          ((18 / 100) * double.tryParse(channel.channelCost)) +
                              double.tryParse(channel.channelCost)))
                      .toString(),
                  textAlign: TextAlign.right,
                ),
                width: 60.0,
              ),
            ],
          ),
        )
      ]);
    } else {
      return TableRow(children: [
        TableCell(
          child: Row(),
        )
      ]);
    }
  }

  editBouquetChannel() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: isBouquetChannel == true
                        ? Color(0xffae275f)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(0.0)),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        isBouquetChannel = true;
                      });
                    },
                    icon: Text(
                      "Bouquet/Add On List",
                      style: TextStyle(
                        color: isBouquetChannel == true
                            ? Colors.white
                            : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    )),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: isBouquetChannel == false
                        ? Color(0xffae275f)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(0.0)),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        isBouquetChannel = false;
                      });
                    },
                    icon: Text(
                      "Channel List",
                      style: TextStyle(
                        color: isBouquetChannel == false
                            ? Colors.white
                            : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    )),
              ),
            ),
          ]),
          isBouquetChannel == true ? bouquetSearchBar() : channelSearchBar(),
          Container(
            height: 10.0,
          ),
          isBouquetChannel == true
              ? Container(
                  child: (_searchBouquetPackage.text.isEmpty)
                      ? bouquetListView()
                      : bouquetBuildList())
              : Container(
                  child: (_searchChannel.text.isEmpty)
                      ? channelListView()
                      : channelBuildList()),
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
                                _onBackPressedCustomerEdit();
                              },
                              child: Text("Cancel"),
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
                                  isEditCustomer = false;
                                  isEditCustomerDetails = false;
                                  isEditContactDetails = false;
                                  isEditCableDetails = true;
                                  isEditBouquetChannelDetails = false;
                                  isEditInternetDetails = false;
                                  double totalSubpackageCost = 0.0;
                                  double totalChannelCost = 0.0;
                                  for (var i = 0;
                                      i <
                                          _customerCard
                                              .cable
                                              .boxDetails[_selectedBouquet]
                                              .addonPackage
                                              .subPackages
                                              .length;
                                      i++) {
                                    if (_customerCard
                                                .cable
                                                .boxDetails[_selectedBouquet]
                                                .addonPackage
                                                .subPackages[i]
                                                .packageCost !=
                                            null &&
                                        _customerCard
                                            .cable
                                            .boxDetails[_selectedBouquet]
                                            .addonPackage
                                            .subPackages[i]
                                            .packageCost
                                            .isNotEmpty &&
                                        _customerCard
                                                .cable
                                                .boxDetails[_selectedBouquet]
                                                .addonPackage
                                                .subPackages[i]
                                                .packageCost !=
                                            "") {
                                      totalSubpackageCost = double.tryParse(
                                              _customerCard
                                                  .cable
                                                  .boxDetails[_selectedBouquet]
                                                  .addonPackage
                                                  .subPackages[i]
                                                  .packageCost) +
                                          totalSubpackageCost;
                                    }
                                  }
                                  for (var i = 0;
                                      i <
                                          _customerCard
                                              .cable
                                              .boxDetails[_selectedBouquet]
                                              .addonPackage
                                              .channels
                                              .length;
                                      i++) {
                                    if (_customerCard
                                                .cable
                                                .boxDetails[_selectedBouquet]
                                                .addonPackage
                                                .channels[i]
                                                .channelCost !=
                                            null &&
                                        _customerCard
                                            .cable
                                            .boxDetails[_selectedBouquet]
                                            .addonPackage
                                            .channels[i]
                                            .channelCost
                                            .isNotEmpty &&
                                        _customerCard
                                                .cable
                                                .boxDetails[_selectedBouquet]
                                                .addonPackage
                                                .channels[i]
                                                .channelCost !=
                                            "") {
                                      totalChannelCost = double.tryParse(
                                              _customerCard
                                                  .cable
                                                  .boxDetails[_selectedBouquet]
                                                  .addonPackage
                                                  .channels[i]
                                                  .channelCost) +
                                          totalChannelCost;
                                    }
                                  }
                                  _customerCard
                                          .cable
                                          .boxDetails[_selectedBouquet]
                                          .addonPackage
                                          .packageCost =
                                      (totalSubpackageCost + totalChannelCost)
                                          .toString();
                                  setCableRent();
                                });
                              },
                              child: Text("Save"),
                            ),
                          ),
                          Container(
                            width: 5.0,
                          ),
                        ],
                      ),
                    ],
                  )))),
        ]);
  }

  bouquetListView() {
    if (addOnPackage != null) {
      setState(() {
        if (isBouquetSelected) {
          addOnPackage.sort(
              (a, b) => a.selected.toString().compareTo(b.selected.toString()));
          addOnPackage = addOnPackage.reversed.toList();
        } else {
          addOnPackage.sort((a, b) => a.packageName.compareTo(b.packageName));
        }
      });
    }

    return Expanded(
      child: new ListView.builder(
          itemCount: addOnPackage == null ? 0 : addOnPackage.length,
          itemBuilder: (BuildContext context, int i) {
            return bouquetView(addOnPackage[i]);
          }),
    );
  }

  bouquetView(AddOnPackage _addOnPackage) {
    return InkWell(
        onTap: () => showBouquetPackage(_addOnPackage),
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
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                title: Row(children: <Widget>[
                  Expanded(
                    child: Text(
                      _addOnPackage.packageName,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.white,
                    ),
                    child: Checkbox(
                      value: _addOnPackage.selected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _addOnPackage.selected = value;
                            _customerCard.cable.boxDetails[_selectedBouquet]
                                .addonPackage.subPackages
                                .add(Package(
                                    billable: "Repeat",
                                    channels: [],
                                    packageCost:
                                        _addOnPackage.packagecost.toString(),
                                    packageId: _addOnPackage.packageId,
                                    packageName: _addOnPackage.packageName));
                            for (var i = 0;
                                i <
                                    _customerCard
                                        .cable
                                        .boxDetails[_selectedBouquet]
                                        .addonPackage
                                        .subPackages
                                        .length;
                                i++) {
                              if (_addOnPackage.packageId ==
                                  _customerCard
                                      .cable
                                      .boxDetails[_selectedBouquet]
                                      .addonPackage
                                      .subPackages[i]
                                      .packageId) {
                                for (var j = 0;
                                    j < _addOnPackage.channels.length;
                                    j++) {
                                  _customerCard
                                      .cable
                                      .boxDetails[_selectedBouquet]
                                      .addonPackage
                                      .subPackages[i]
                                      .channels
                                      .add(MainPackageChannel(
                                          id: _addOnPackage.channels[j].id,
                                          name:
                                              _addOnPackage.channels[j].name));
                                }
                              }
                            }
                            editPackageDetails();
                          } else {
                            _addOnPackage.selected = value;
                            for (var i = 0;
                                i <
                                    _customerCard
                                        .cable
                                        .boxDetails[_selectedBouquet]
                                        .addonPackage
                                        .subPackages
                                        .length;
                                i++) {
                              if (_addOnPackage.packageId ==
                                  _customerCard
                                      .cable
                                      .boxDetails[_selectedBouquet]
                                      .addonPackage
                                      .subPackages[i]
                                      .packageId) {
                                _customerCard.cable.boxDetails[_selectedBouquet]
                                    .addonPackage.subPackages
                                    .remove(_customerCard
                                        .cable
                                        .boxDetails[_selectedBouquet]
                                        .addonPackage
                                        .subPackages[i]);
                              }
                            }
                            editPackageDetails();
                          }
                        });
                      },
                      activeColor: Color(0xffae275f),
                    ),
                  ),
                ]),
                subtitle: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                                "Rs. " + _addOnPackage.packagecost.toString(),
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow))),
                      ],
                    ),
                  ],
                ),
              )),
        ));
  }

  showBouquetPackage(AddOnPackage _addOnPackage) {
    var boxes = List<Widget>();
    _addOnPackage.channels.sort((a, b) => (a.name).compareTo(b.name));

    if (_addOnPackage.channels.isNotEmpty || _addOnPackage.channels != null) {
      for (var i = 0; i < _addOnPackage.channels.length; i++) {
        var box = Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(_addOnPackage.channels[i].name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)));
        boxes.add(box);
      }
    }
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
                                trailing: Text(
                                    "Rs. " +
                                        _addOnPackage.packagecost.toString(),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange)),
                                dense: true,
                                leading: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        border: Border.all(
                                            width: 2.0, color: Colors.green)),
                                    child: CircleAvatar(
                                      radius: 20.0,
                                      child: Text(
                                        _addOnPackage.packageName[0],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26.0),
                                      ),
                                    )),
                                title: Text(
                                    _addOnPackage.packageName.toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0)),
                                subtitle: Text(_addOnPackage.packageType,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),
                              ),
                              Divider(),
                              Material(
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: GroovinExpansionTile(
                                  initiallyExpanded: true,
                                  defaultTrailingIconColor: Colors.indigoAccent,
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.indigoAccent,
                                    child: Icon(
                                      Icons.live_tv,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    "List Of Channels",
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5.0),
                                        bottomRight: Radius.circular(5.0),
                                      ),
                                      child: Column(
                                        children: boxes,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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

  bouquetSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 10.0,
        ),
        Expanded(
          child: TextFormField(
            controller: _searchBouquetPackage,
            decoration: InputDecoration(
              labelText: "Search Bouquet/Add On",
              labelStyle: TextStyle(color: Colors.blueGrey[400]),
              suffixIcon: Icon(
                Icons.search,
              ),
            ),
            cursorColor: Colors.blueGrey,
            style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
          ),
        ),
        Container(
          width: 10.0,
        ),
        Text("Show Selected"),
        Container(
          width: 5.0,
        ),
        Checkbox(
          value: isBouquetSelected,
          onChanged: (value) {
            setState(() {
              isBouquetSelected = value;
            });
          },
          activeColor: Color(0xffae275f),
        ),
      ],
    );
  }

  bouquetBuildList() {
    List<AddOnPackage> tempBouquetAddOnList = [];
    if (_searchBouquetPackageText.isNotEmpty) {
      for (int i = 0; i < addOnPackage.length; i++) {
        try {
          if (addOnPackage[i]
              .packageName
              .toLowerCase()
              .contains(_searchBouquetPackageText.toLowerCase())) {
            tempBouquetAddOnList.add(addOnPackage[i]);
          }
        } catch (error) {
          print(error);
        }
      }
    }

    searchBouquetPackageList = tempBouquetAddOnList;
    if (searchBouquetPackageList != null) {
      setState(() {
        if (isBouquetSelected) {
          searchBouquetPackageList.sort(
              (a, b) => a.selected.toString().compareTo(b.selected.toString()));
          searchBouquetPackageList = searchBouquetPackageList.reversed.toList();
        } else {
          searchBouquetPackageList
              .sort((a, b) => a.packageName.compareTo(b.packageName));
        }
      });
    }
    return Expanded(
      child: new ListView.builder(
          itemCount: searchBouquetPackageList == null
              ? 0
              : searchBouquetPackageList.length,
          itemBuilder: (BuildContext context, int i) {
            return bouquetView(searchBouquetPackageList[i]);
          }),
    );
  }

  channelListView() {
    if (channel != null) {
      setState(() {
        if (isChannelSelected) {
          channel.sort(
              (a, b) => a.selected.toString().compareTo(b.selected.toString()));
          channel = channel.reversed.toList();
        } else {
          channel.sort((a, b) => a.channelName.compareTo(b.channelName));
        }
      });
    }
    return Expanded(
      child: new ListView.builder(
          itemCount: channel == null ? 0 : channel.length,
          itemBuilder: (BuildContext context, int i) {
            return channelView(channel[i]);
          }),
    );
  }

  channelView(Channel _channel) {
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
                EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            title: Row(children: <Widget>[
              Expanded(
                child: Text(
                  _channel.channelName,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
              _channel.package == true
                  ? Text(
                      "(Included In Bouquet)",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0),
                    )
                  : Container(),
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.white,
                ),
                child: Checkbox(
                  value: _channel.selected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _channel.selected = value;
                        _customerCard.cable.boxDetails[_selectedBouquet]
                            .addonPackage.channels
                            .add(AddonPackageChannel(
                                billable: "Repeat",
                                channelCost: _channel.price.toString(),
                                channelId: _channel.channelId,
                                channelName: _channel.channelName));
                        editPackageDetails();
                      } else {
                        _channel.selected = value;
                        for (var i = 0;
                            i <
                                _customerCard.cable.boxDetails[_selectedBouquet]
                                    .addonPackage.channels.length;
                            i++) {
                          if (_customerCard.cable.boxDetails[_selectedBouquet]
                                  .addonPackage.channels[i].channelId ==
                              _channel.channelId) {
                            _customerCard.cable.boxDetails[_selectedBouquet]
                                .addonPackage.channels
                                .remove(_customerCard
                                    .cable
                                    .boxDetails[_selectedBouquet]
                                    .addonPackage
                                    .channels[i]);
                          }
                        }
                        editPackageDetails();
                      }
                    });
                  },
                  activeColor: Color(0xffae275f),
                ),
              ),
            ]),
            subtitle: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text("Rs. " + _channel.price.toString(),
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow))),
                  ],
                ),
              ],
            ),
          )),
    ));
  }

  channelSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 10.0,
        ),
        Expanded(
          child: TextFormField(
            controller: _searchChannel,
            decoration: InputDecoration(
                labelText: "Search Channel",
                labelStyle: TextStyle(color: Colors.blueGrey[400]),
                suffixIcon: Icon(Icons.search)),
            cursorColor: Colors.blueGrey,
            style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
          ),
        ),
        Container(
          width: 10.0,
        ),
        Text("Show Selected"),
        Container(
          width: 5.0,
        ),
        Checkbox(
          value: isChannelSelected,
          onChanged: (value) {
            setState(() {
              isChannelSelected = value;
            });
          },
          activeColor: Color(0xffae275f),
        ),
      ],
    );
  }

  channelBuildList() {
    List<Channel> tempChannelList = [];
    if (_searchChannelText.isNotEmpty) {
      for (int i = 0; i < channel.length; i++) {
        try {
          if (channel[i]
              .channelName
              .toLowerCase()
              .contains(_searchChannelText.toLowerCase())) {
            tempChannelList.add(channel[i]);
          }
        } catch (error) {
          print(error);
        }
      }
    }

    searchChannelList = tempChannelList;
    if (searchChannelList != null) {
      setState(() {
        if (isChannelSelected) {
          searchChannelList.sort(
              (a, b) => a.selected.toString().compareTo(b.selected.toString()));
          searchChannelList = searchChannelList.reversed.toList();
        } else {
          searchChannelList
              .sort((a, b) => a.channelName.compareTo(b.channelName));
        }
      });
    }
    return Expanded(
      child: new ListView.builder(
          itemCount: searchChannelList == null ? 0 : searchChannelList.length,
          itemBuilder: (BuildContext context, int i) {
            return channelView(searchChannelList[i]);
          }),
    );
  }

  editInternetDetails() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5.0,
          ),
          Form(
            key: editInternetDetailsKey,
            child: Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Card(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      shape: RoundedRectangleBorder(),
                      child: Column(
                        children: <Widget>[
                          Row(children: <Widget>[
                            Container(width: 10.0),
                            Expanded(
                                flex: 6,
                                child: DropdownButton<InternetPlan>(
                                    disabledHint: new Text(
                                      "None",
                                    ),
                                    hint: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 10.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Select Plan",
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    isExpanded: true,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14.0),
                                    items:
                                        internetPlans.map((InternetPlan value) {
                                      return new DropdownMenuItem<InternetPlan>(
                                        value: value,
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 10.0,
                                            ),
                                            Expanded(
                                              child: Text(
                                                value.planName,
                                                overflow: TextOverflow.visible,
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    value: _internetPlans,
                                    onChanged: (newVal) {
                                      setState(() {
                                        _internetPlans = newVal;
                                        _internetMonthlyRentController.text =
                                            _internetPlans.planCost.toString();
                                        _internetmonthlyrent =
                                            _internetMonthlyRentController.text;
                                        setTotalInternetRent();
                                      });
                                    })),
                            _internetPlans != null
                                ? Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _internetPlans = null;
                                          _internetMonthlyRentController.text =
                                              "";
                                          _internetmonthlyrent = "";
                                          setTotalInternetRent();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                    ),
                                  )
                                : Container(),
                            Expanded(
                              child: Radio(
                                value: "Pre Paid",
                                groupValue: _billType,
                                onChanged: (value) {
                                  setState(() {
                                    _billType = value;
                                  });
                                },
                                activeColor: Color(0xffae275f),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _billType = "Pre Paid";
                                  });
                                },
                                child: Text(
                                  "Pre Paid",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Radio(
                                value: "Post Paid",
                                groupValue: _billType,
                                onChanged: (value) {
                                  setState(() {
                                    _billType = value;
                                  });
                                },
                                activeColor: Color(0xffae275f),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _billType = "Post Paid";
                                  });
                                },
                                child: Text(
                                  "Post Paid",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ),
                            ),
                            Container(
                              width: 10.0,
                            ),
                          ]),
                          Row(
                            children: <Widget>[
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _ontNumberController,
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _ontNumberController.text = value;
                                      _ontNumber = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "ONT Number",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _macIdController,
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _macIdController.text = value;
                                      _macId = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "MAC ID",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _vLanController,
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _vLanController.text = value;
                                      _vLan = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "V LAN",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _voipController,
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _voipController.text = value;
                                      _voip = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "VOIP",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 10.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10.0),
                              Text('Activation Date : '),
                              Container(width: 5.0),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormField(
                                        controller: _actDateInternetController,
                                        maxLines: 1,
                                        keyboardType: TextInputType.datetime,
                                        validator: (value) {
                                          setState(() {
                                            _actDateInternetController.text =
                                                value;
                                            _actdateInternet = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            labelText: "DD-MM-YYYY",
                                            labelStyle:
                                                TextStyle(fontSize: 12.0)),
                                      ),
                                    ),
                                    Container(width: 10.0),
                                    InkWell(
                                      onTap: () {
                                        _selectActDateInternet(context);
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
                              Container(width: 5.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _instalamtInternetController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _instalamtInternetController.text = value;
                                      _instalamtInternet = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Installation Amount",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(width: 5.0),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: _freeconnectionInternet,
                                      onChanged: (value) {
                                        setState(() {
                                          _freeconnectionInternet = value;
                                        });
                                      },
                                      activeColor: Color(0xffae275f),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (_freeconnectionInternet ==
                                              false) {
                                            _freeconnectionInternet = true;
                                          } else {
                                            _freeconnectionInternet = false;
                                          }
                                        });
                                      },
                                      child: Text(
                                        "Free Connection",
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(width: 10.0),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller:
                                      _outstandbalanceInternetController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _outstandbalanceInternetController.text =
                                          value;
                                      _outstandbalanceInternet = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Outstanding Balance",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(
                                width: 5.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _internetMonthlyRentController,
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    setState(() {
                                      _internetMonthlyRentController.text =
                                          value;
                                      _internetmonthlyrent = value;
                                      setTotalInternetRent();
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Plan Amount",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(
                                width: 10.0,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _internetDiscountController,
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    setState(() {
                                      _internetDiscountController.text = value;
                                      _internetdiscount = value;
                                      setTotalInternetRent();
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Discount",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(
                                width: 5.0,
                              ),
                              Expanded(
                                child: Text(
                                    "Total Rental: Rs." + _internettotalrental),
                              ),
                              Container(
                                width: 10.0,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _internetCommentController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  maxLines: 1,
                                  validator: (value) {
                                    setState(() {
                                      _internetCommentController.text = value;
                                      _internetComment = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Internet Comment",
                                      labelStyle: TextStyle(fontSize: 12.0)),
                                ),
                              ),
                              Container(
                                width: 10.0,
                              ),
                            ],
                          ),
                          Container(
                            height: 5.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                                  _onBackPressedCustomerEdit();
                                });
                              },
                              child: Text("Cancel"),
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
                                  _editInternetDetails();
                                });
                              },
                              child: Text("Save"),
                            ),
                          ),
                          Container(
                            width: 5.0,
                          ),
                        ],
                      ),
                    ],
                  )))),
        ]);
  }
}
