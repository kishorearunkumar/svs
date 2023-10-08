import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:svs/models/internet-plan.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'dart:convert';
import 'package:svs/models/street.dart';
import 'package:svs/models/customer.dart';
import 'package:intl/intl.dart';
import 'package:connectivity/connectivity.dart';
import 'package:svs/services/basic_service.dart';
import 'dart:core';
import 'package:svs/widgets/loader.dart';
import 'package:svs/models/username.dart';
import 'package:svs/models/mso.dart';
import 'package:svs/models/last-customer.dart';
import 'package:svs/models/mainpackage.dart';
import 'package:svs/utils/app_shared_preferences.dart';
import 'package:svs/models/area.dart';
import 'package:svs/models/login-response.dart';
import 'package:svs/models/addon-package.dart';
import 'package:svs/models/channel.dart';
import 'package:groovin_widgets/groovin_widgets.dart';

class AddCustomerScreen extends StatefulWidget {
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen>
    with SingleTickerProviderStateMixin {
  TabController tabcontroller;
  bool isAddCableInternet = true;
  InternetPlan _internetPlans;
  List<InternetPlan> internetPlans = [];
  String _billType = "Pre Paid";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = new TextEditingController();
  final TextEditingController _customeridController =
      new TextEditingController();
  final TextEditingController _cafnoController = new TextEditingController();
  final TextEditingController _flatnoController = new TextEditingController();
  final TextEditingController _flatnameController = new TextEditingController();
  final TextEditingController _streetController = new TextEditingController();
  final TextEditingController _areaController = new TextEditingController();
  final TextEditingController _cityController = new TextEditingController();
  final TextEditingController _stateController = new TextEditingController();
  final TextEditingController _pincodeController = new TextEditingController();
  final TextEditingController _boxcommentController =
      new TextEditingController();
  final TextEditingController _cableCommentController =
      new TextEditingController();
  final TextEditingController _outstandbalanceCableController =
      new TextEditingController();
  final TextEditingController _instalamtpaidCableController =
      new TextEditingController();
  final TextEditingController _instalamtCableController =
      new TextEditingController();
  final TextEditingController _instalamtInternetController =
      new TextEditingController();
  final TextEditingController _outstandbalanceInternetController =
      new TextEditingController();
  final TextEditingController _internetMonthlyRentController =
      new TextEditingController();
  final TextEditingController _internetDiscountController =
      new TextEditingController();
  final TextEditingController _internetCommentController =
      new TextEditingController();
  final TextEditingController _postnoController = new TextEditingController();
  final TextEditingController _ebnoController = new TextEditingController();
  final TextEditingController _altnoController = new TextEditingController();
  final TextEditingController _mobnoController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _landmarkController = new TextEditingController();
  final TextEditingController _dobController = new TextEditingController();
  final TextEditingController _actDateCableController =
      new TextEditingController();
  final TextEditingController _actDateInternetController =
      new TextEditingController();
  final TextEditingController _barcodeIDController =
      new TextEditingController();
  final TextEditingController _nuidController = new TextEditingController();
  final TextEditingController _irdController = new TextEditingController();
  final TextEditingController _vcnoController = new TextEditingController();
  final TextEditingController _cableMonthlyRentController =
      new TextEditingController();
  final TextEditingController _cableDiscountController =
      new TextEditingController();
  int _count = 1;
  final GlobalKey<ScaffoldState> addCustomerKey =
      new GlobalKey<ScaffoldState>();
  var formatter = new DateFormat('dd-MM-yyyy');
  var formatters = NumberFormat("##,##,##0.00");
  String _dobdate = "";
  String _actdateCable = "";
  String _actdateInternet = "";

  bool isInstallmentCable = false;

  LastCustomer lastCustomer = LastCustomer(customerId: 'Not Available');
  String _fullname;
  String _customerid;
  String _barcodeid;
  String _cafno;
  String _gender;
  // String _photo;
  String _residencetype = "Owned";
  String _flatno;
  String _flatname;
  String _street;
  String _area;
  String _landmark;
  String _city;
  String _state;
  String _pincode;
  String _email;
  String _mobno;
  String _altno;
  String _ontNumber;
  final TextEditingController _ontNumberController =
      new TextEditingController();
  String _macId;
  final TextEditingController _macIdController = new TextEditingController();
  String _vLan;
  final TextEditingController _vLanController = new TextEditingController();
  String _voip;
  final TextEditingController _voipController = new TextEditingController();
  // String _uploadidproof;
  String _ebno;
  String _postno;
  String _cabletype = "Digital";
  bool _freeconnectionCable = false;
  bool _freeconnectionInternet = false;
  String _msoname = "Select MSO";
  List<Mso> msoname = [];
  String _boxtype = "SD";
  String _nuid;
  String _ird;
  String _vcno;
  String _boxcomment;
  MainPackage _mainpackage;
  List<MainPackage> mainpackage = [];
  String _billing = "Repeat";
  String _instalamtCable = "0";
  String _instalamtInternet = "0";
  String _instaltypeCable = "Fully Paid";
  String _instalamtpaidCable = "0";
  String _cablediscount = "0";
  String _internetdiscount = "0";
  String _outstandbalanceCable = "0";
  String _outstandbalanceInternet = "0";
  String _cablemonthlyrent = "0";
  String _internetmonthlyrent = "0";
  String _cabletotalrental = "0";
  String _internettotalrental = "0";
  String _cableComment;
  String _internetComment;
  String _collectionagent = "Select Collection Agent";
  List<Username> collectionagents = [];
  // String _sublco = "Select SUB LCO";
  String barcodeid = "";
  String nuid = "";
  String ird = "";
  String vcno = "";
  bool isLoading = true;
  List<Street> streets = [];
  List<Areas> areas = [];
  bool reset = false;
  LoginResponse user;
  List<AddOnPackage> addOnPackage = [];
  List<Channel> channel = [];
  List<AddOnPackage> tempAddOnPackage = [];
  List<Channel> tempChannel = [];
  bool isSelectBouquetAddOnChannels = false;
  bool isBouquetAddOnList = true;
  List isAddBouquetAddon = [];
  List isAddChannel = [];
  List isselectedAddOnPackageChannelList = [];
  final TextEditingController _searchAddOnPackage = new TextEditingController();
  final TextEditingController _searchChannel = new TextEditingController();
  String _searchAddOnPackageText = "";
  String _searchChannelText = "";
  List<AddOnPackage> searchAddOnPackageList = [];
  List<Channel> searchChannelList = [];
  List<AddOnPackage> tempSelectedAddOnPackageList = [];
  List<Channel> tempSelectedChannelList = [];
  List<Package> selectedAddOnPackageList = [];
  List<AddonPackageChannel> selectedChannelList = [];
  double packageCost;
  bool bouquetSelected = false;
  bool channelSelected = false;

  @override
  void initState() {
    super.initState();

    AppSharedPreferences.setCustomerSuccess("");

    getLastCustomer();
    getInternetPlan();
    getStreetData();
    getAreaData();
    getCollectionAgentData();
    getMSOData();
    getMainPackageData();
    getAddonPackage();
    getChannel();
    resetAddCustomer();

    tabcontroller = new TabController(vsync: this, length: 2);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getInternetPlan() {
    internetPlan().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          internetPlans =
              internetPlanFromJson(Utf8Codec().decode(response.bodyBytes));
          internetPlans.sort((a, b) =>
              a.planName.toLowerCase().compareTo(b.planName.toLowerCase()));
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

  Future pause(Duration d) => new Future.delayed(d);

  _AddCustomerScreenState() {
    _searchAddOnPackage.addListener(() {
      if (_searchAddOnPackage.text.isEmpty) {
        setState(() {
          _searchAddOnPackageText = "";
        });
      } else {
        setState(() {
          _searchAddOnPackageText = _searchAddOnPackage.text;
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

  resetAddCustomer() {
    setState(() {
      _fullnameController.text = "";
      _customeridController.text = "";
      _cafnoController.text = "";
      _flatnoController.text = "";
      _flatnameController.text = "";
      _streetController.text = "";
      _areaController.text = "";
      _cityController.text = "";
      _stateController.text = "";
      _pincodeController.text = "";
      _boxcommentController.text = "";
      _cableCommentController.text = "";
      _outstandbalanceCableController.text = "0";
      _outstandbalanceInternetController.text = "0";
      _instalamtpaidCableController.text = "";
      _instalamtCableController.text = "0";
      _instalamtInternetController.text = "0";
      _postnoController.text = "";
      _ebnoController.text = "";
      _altnoController.text = "";
      _mobnoController.text = "";
      _emailController.text = "";
      _landmarkController.text = "";
      _dobController.text = "";
      _actDateCableController.text = "";
      _actDateInternetController.text = "";
      _barcodeIDController.text = "";
      _nuidController.text = "";
      _irdController.text = "";
      _vcnoController.text = "";
      _cableMonthlyRentController.text = "0";
      _internetMonthlyRentController.text = "0";
      _cableDiscountController.text = "0";
      _internetDiscountController.text = "0";
      _residencetype = "Owned";
      _cabletype = "Digital";
      _freeconnectionCable = false;
      _freeconnectionInternet = false;
      _msoname = "Select MSO";
      _boxtype = "SD";
      _mainpackage = null;
      packageCost = 0.0;
      _billing = "Repeat";
      _instaltypeCable = "Fully Paid";
      _collectionagent = "Select Collection Agent";
      _gender = "";
      _cabletotalrental = "0";
      resetPackageChannel();
    });
  }

  resetPackageChannel() {
    setState(() {
      cleartempPackage();
      cleartempChannels();
      selectedAddOnPackageList.clear();
      selectedChannelList.clear();
      isAddBouquetAddon.clear();
      isAddChannel.clear();
      isselectedAddOnPackageChannelList.clear();
    });
  }

  // Future<void> initUserProfile() async {
  //   try {
  //     LoginResponse up = await AppSharedPreferences.getUserProfile();
  //     setState(() {
  //       user = up;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

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

  Future<Null> _selectActDateCable(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2025));
    if (picked != null &&
        picked != DateTime.tryParse(_actdateCable.toString())) {
      setState(() {
        _actdateCable = picked.toString();
        _actDateCableController.text = formatter
            .format(DateTime.tryParse(_actdateCable.toString()).toLocal());
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

  Future scanNUID() async {
    try {
      nuid = await BarcodeScanner.scan();
      setState(() {
        _nuid = nuid;
      });
      _nuidController.text = this.nuid;
    } catch (error) {
      print(error);
    }
  }

  Future scanIRD() async {
    try {
      ird = await BarcodeScanner.scan();
      setState(() {
        _ird = ird;
      });
      _irdController.text = this.ird;
    } catch (error) {
      print(error);
    }
  }

  Future scanVCNO() async {
    try {
      vcno = await BarcodeScanner.scan();
      setState(() {
        _vcno = vcno;
      });
      _vcnoController.text = this.vcno;
    } catch (error) {
      print(error);
    }
  }

  // Future openCamera() async {
  //   var picture = await ImagePicker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     _photo = picture.path;
  //   });
  // }

  // Future openGallery() async {
  //   var gallery = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     _photo = gallery.path;
  //   });
  // }

  // Future<void> _optionsDialogBox() {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: new SingleChildScrollView(
  //           child: new ListBody(
  //             children: <Widget>[
  //               GestureDetector(
  //                 child: new Text('Take a picture'),
  //                 onTap: openCamera,
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.all(8.0),
  //               ),
  //               GestureDetector(
  //                 child: new Text('Select from gallery'),
  //                 onTap: openGallery,
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future openCameraid() async {
  //   var picture = await ImagePicker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     _uploadidproof = picture.path;
  //   });
  // }

  // Future openGalleryid() async {
  //   var gallery = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     _uploadidproof = gallery.path;
  //   });
  // }

  // Future<void> _optionsDialogBoxid() {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: new SingleChildScrollView(
  //           child: new ListBody(
  //             children: <Widget>[
  //               GestureDetector(
  //                 child: new Text('Take a picture'),
  //                 onTap: openCameraid,
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.all(8.0),
  //               ),
  //               GestureDetector(
  //                 child: new Text('Select from gallery'),
  //                 onTap: openGalleryid,
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
      packageCost = 0.0;
      if (tempSelectedAddOnPackageList.isNotEmpty ||
          tempSelectedAddOnPackageList != null) {
        for (var i = 0; i < tempSelectedAddOnPackageList.length; i++) {
          if (tempSelectedAddOnPackageList[i].selected == true) {
            packageCost =
                packageCost + tempSelectedAddOnPackageList[i].packagecost;
          }
        }
      }
      if (tempSelectedChannelList.isNotEmpty ||
          tempSelectedChannelList != null) {
        for (var j = 0; j < tempSelectedChannelList.length; j++) {
          if (tempSelectedChannelList[j].selected == true &&
              tempSelectedChannelList[j].package == false) {
            packageCost = packageCost + tempSelectedChannelList[j].price;
          }
        }
      }
      if (mainpackage.isNotEmpty &&
          mainpackage != null &&
          _mainpackage != null) {
        for (int i = 0; i < mainpackage.length; i++) {
          if (mainpackage[i].id == _mainpackage.id) {
            _cableMonthlyRentController.text =
                (((mainpackage[i].packageCost) + packageCost) +
                        (((mainpackage[i].packageCost) + packageCost) * 0.18))
                    .round()
                    .toString();
            _cablemonthlyrent = _cableMonthlyRentController.text;
            setTotalCableRent();
          }
        }
      } else {
        _cableMonthlyRentController.text =
            ((packageCost) + ((packageCost) * 0.18)).round().toString();
        _cablemonthlyrent = _cableMonthlyRentController.text;
        setTotalCableRent();
      }

      selectedPackageChannel();
    });
    print(packageCost);
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

  Future<void> getLastCustomer() async {
    // await initUserProfile();

    await getOldData();
    lastCustomerList().then((response) {
      if (response.statusCode == 200) {
        setState(() {
          lastCustomer =
              lastCustomerFromJson(Utf8Codec().decode(response.bodyBytes));
          isLoading = false;
        });
        // AppSharedPreferences.setLastCustomerId(lastCustomer);
      }
    }).catchError((error) {
      print(error);
      setState(() {
        getOldData();
        isLoading = false;
      });
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
          // setPackage();
          tempAddOnPackage = addOnPackage;
          tempSelectedAddOnPackageList = addOnPackage;
          cleartempPackage();
        });
        AppSharedPreferences.setAddOnPackage(addOnPackage);
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
          // setChannels();
          tempChannel = channel;
          tempSelectedChannelList = channel;
          cleartempChannels();
        });
        AppSharedPreferences.setChannel(channel);
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
        });
        AppSharedPreferences.setMso(msoname);
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
        });
        AppSharedPreferences.setMainPackage(mainpackage);
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
        });
        AppSharedPreferences.setStreets(streets);
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
        });
        AppSharedPreferences.setUsername(collectionagents);
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
        });
        AppSharedPreferences.setAreas(areas);
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
      // lastCustomer = await AppSharedPreferences.getLastCustomerId();
      // isLoading = false;
      streets = await AppSharedPreferences.getStreets();
      streets.sort(
          (a, b) => a.street.toLowerCase().compareTo(b.street.toLowerCase()));
      isLoading = false;
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
    } catch (e) {
      print(e);
    }
  }

  _addCustomer() async {
    if (_formKey.currentState.validate()) {
      AddonPackage addonpackage = AddonPackage(
        channels: selectedChannelList,
        subPackages: selectedAddOnPackageList,
        packageCost: packageCost.toString(),
      );
      Package mainPackage = Package(
        packageId: _mainpackage == null ? "" : _mainpackage.id,
        packageCost:
            _mainpackage == null ? "" : _mainpackage.packageCost.toString(),
        packageName: _mainpackage == null ? "" : _mainpackage.packageName,
        billable: _billing,
      );

      List<BoxDetail> boxDetail = [
        BoxDetail(
          cableType: _cabletype,
          boxType: _boxtype,
          activationDate: _actdateCable == "" ? "" : _actdateCable,
          freeConnection: _freeconnectionCable,
          irdNo: _ird,
          vcNo: _vcno,
          nuidNo: _nuid,
          msoId: _msoname == "Select MSO" ? "" : _msoname,
          mainPackage: mainPackage,
          addonPackage: addonpackage,
          boxComment: _boxcomment,
        )
      ];

      Internet internet = Internet(
        macId: _macId,
        ontNo: _ontNumber,
        vLan: _vLan,
        voip: _voip,
        freeConnection: _freeconnectionInternet,
        internetActivationDate: _actdateInternet == "" ? "" : _actdateInternet,
        internetAdvanceAmount:
            _instalamtInternet == null || _instalamtInternet == ""
                ? "0"
                : _instalamtInternet,
        internetBillType: _billType,
        internetComments: _internetComment,
        internetDiscount: _internetdiscount == null || _internetdiscount == ""
            ? "0"
            : _internetdiscount,
        internetMonthlyRent:
            _internetmonthlyrent == null || _internetmonthlyrent == ""
                ? "0"
                : _internetmonthlyrent,
        internetOutstandingAmount:
            _outstandbalanceInternet == null || _outstandbalanceInternet == ""
                ? "0"
                : _outstandbalanceInternet,
        noInternetConnection: _internetmonthlyrent == null ||
                _internetmonthlyrent == "" ||
                _internetmonthlyrent == "0" ||
                double.tryParse(_internetmonthlyrent) <= 0
            ? 0
            : 1,
        planName: _internetPlans != null && _internetPlans.planName.isNotEmpty
            ? _internetPlans.planName
            : "",
      );

      Cable cable = Cable(
        cableAdvanceAmountPaid:
            _instalamtpaidCable == null || _instalamtpaidCable == ""
                ? "0"
                : _instalamtpaidCable,
        cableOutstandingAmount:
            _outstandbalanceCable == null || _outstandbalanceCable == ""
                ? "0"
                : _outstandbalanceCable,
        noCableConnection: _cablemonthlyrent == null ||
                _cablemonthlyrent == "" ||
                _cablemonthlyrent == "0" ||
                double.tryParse(_cablemonthlyrent) <= 0
            ? 0
            : 1,
        boxDetails: boxDetail,
        cableAdvanceAmount: _instalamtCable == null || _instalamtCable == ""
            ? "0"
            : _instalamtCable,
        cableAdvanceInstallment: _instaltypeCable,
        cableMonthlyRent: _cablemonthlyrent == null || _cablemonthlyrent == ""
            ? "0"
            : _cablemonthlyrent,
        cableDiscount: _cablediscount == null || _cablediscount == ""
            ? "0"
            : _cablediscount,
        cableComments: _cableComment,
      );

      Address address = Address(
        doorNo: _flatno,
        houseName: _flatname,
        residenceType: _residencetype,
        alternateNumber: _altno,
        area: _areaController.text,
        city: _city,
        emailId: _email,
        landmark: _landmark,
        mobile: _mobno,
        pincode: _pincode,
        state: _state,
        street: _streetController.text,
      );

      Customer customer = Customer(
          customerName: _fullname,
          customerId: _customerid,
          barCode: _barcodeid,
          cafNo: _cafno,
          dob: _dobdate == "" ? "" : _dobdate,
          gender: _gender,
          collectionAgent: _collectionagent == "Select Collection Agent"
              ? ""
              : _collectionagent,
          activeStatus: true,
          ebNumber: _ebno,
          postNumber: _postno,
          cable: cable,
          internet: internet,
          address: address);

      var connectivityResult = await (new Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        saveCustomer(customer).then((response) {
          if (response.statusCode == 201) {
            _customerSaved(response.statusCode.toString());
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, "/customerlist");
          }
        });
      } else {
        addCustomerKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: new Text("Something went wrong !!"),
        ));
      }
    }
  }

  _customerSaved(String statusCode) {
    AppSharedPreferences.setCustomerSuccess(statusCode);
  }

  bottomActionBar() {
    return isSelectBouquetAddOnChannels
        ? Container(
            height: 58.0,
            color: Colors.white,
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                    child: Column(
                  children: <Widget>[
                    Divider(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 10.0,
                        ),
                        Expanded(
                          child: FloatingActionButton(
                            heroTag: "ResetBouquetDetails",
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
                                resetPackageChannel();
                              });
                            },
                            child: Text("Reset"),
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
                            heroTag: "SaveBouquetDetails",
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
                              setState(() {
                                setCableRent();
                                isSelectBouquetAddOnChannels = false;
                              });
                            },
                            child: Text("Save"),
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
                ))))
        : Container(
            height: 58.0,
            color: Colors.white,
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                    child: Column(
                  children: <Widget>[
                    Divider(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 10.0,
                        ),
                        Expanded(
                          child: FloatingActionButton(
                            heroTag: "ResetCustomerDetails",
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
                              resetAddCustomer();
                            },
                            child: Text("Reset"),
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
                            heroTag: "SubmitCustomerDetails",
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
                              _addCustomer();
                            },
                            child: Text("Submit"),
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
                ))));
  }

  bottomNavigation() => new TabBar(
        controller: tabcontroller,
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
              Text("Bouquet/Add On List", style: TextStyle(fontSize: 11.0))
            ],
          )),
          new Tab(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Channel List", style: TextStyle(fontSize: 11.0))
            ],
          )),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: isSelectBouquetAddOnChannels
          ? _onBackPressedBouquet
          : _onBackPressedCustomer,
      child: Scaffold(
        key: addCustomerKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: isSelectBouquetAddOnChannels
              ? Text('Add Bouquets/Add On/Channels')
              : Text('Add Customer'),
          backgroundColor: Color(0xffae275f),
          bottom: isSelectBouquetAddOnChannels ? bottomNavigation() : null,
        ),
        bottomNavigationBar: isLoading ? Loader() : bottomActionBar(),
        backgroundColor: Color(0xFFdae2f0),
        body: isLoading
            ? Loader()
            : isSelectBouquetAddOnChannels
                ? addBouquets()
                : Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(0.0),
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              child: addCustomer(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Future<bool> _onBackPressedCustomer() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Exit without saving Customer? ",
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
              ],
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onBackPressedBouquet() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Exit without saving Bouquet ? ",
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
                      resetPackageChannel();
                      isSelectBouquetAddOnChannels = false;
                      Navigator.pop(context, false);
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
                    isSelectBouquetAddOnChannels = true;
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

//================================================================//
  Widget bouquetAddOnListView() {
    if (addOnPackage != null) {
      setState(() {
        if (bouquetSelected) {
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
            return _bouquetAddOnView(addOnPackage[i]);
          }),
    );
  }

  showAddOnPackage(AddOnPackage _addOnPackage) {
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

  Widget _bouquetAddOnView(AddOnPackage _addOnPackage) {
    return InkWell(
        onTap: () => showAddOnPackage(_addOnPackage),
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
                            isAddBouquetAddon.add(_addOnPackage.packageId);
                            tempSelectPackageChannels();
                          } else {
                            _addOnPackage.selected = value;
                            isAddBouquetAddon.remove(_addOnPackage.packageId);
                            tempSelectPackageChannels();
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

  cleartempPackage() {
    setState(() {
      tempSelectedAddOnPackageList = tempAddOnPackage;

      for (var p = 0; p < tempAddOnPackage.length; p++) {
        tempSelectedAddOnPackageList[p].selected = false;
      }
    });
  }

  cleartempChannels() {
    setState(() {
      tempSelectedChannelList = tempChannel;

      for (var q = 0; q < tempChannel.length; q++) {
        // selectedChannelList[q].price = tempChannel[q].price;
        tempSelectedChannelList[q].package = false;
        tempSelectedChannelList[q].selected = false;
      }
    });
  }

  selectedPackageChannel() {
    setState(() {
      int l = 0;
      int m = 0;

      selectedAddOnPackageList.clear();
      selectedChannelList.clear();
      if (tempSelectedAddOnPackageList.isNotEmpty ||
          tempSelectedAddOnPackageList != null) {
        for (var i = 0; i < tempSelectedAddOnPackageList.length; i++) {
          if (tempSelectedAddOnPackageList[i].selected == true) {
            selectedAddOnPackageList.add(Package());
            selectedAddOnPackageList[l].packageId =
                tempSelectedAddOnPackageList[i].packageId;
            selectedAddOnPackageList[l].packageName =
                tempSelectedAddOnPackageList[i].packageName;
            selectedAddOnPackageList[l].packageCost =
                tempSelectedAddOnPackageList[i].packageCost;
            selectedAddOnPackageList[l].billable =
                tempSelectedAddOnPackageList[i].billable;
            selectedAddOnPackageList[l].channels = [];
            if (tempSelectedAddOnPackageList[i].channels.isNotEmpty ||
                tempSelectedAddOnPackageList[i].channels != null) {
              for (var j = 0;
                  j < tempSelectedAddOnPackageList[i].channels.length;
                  j++) {
                selectedAddOnPackageList[l].channels.add(MainPackageChannel());
                selectedAddOnPackageList[l].channels[j].id =
                    tempSelectedAddOnPackageList[i].channels[j].id;
                selectedAddOnPackageList[l].channels[j].name =
                    tempSelectedAddOnPackageList[i].channels[j].name;
              }
            }
            l++;
          }
        }
      }
      if (tempSelectedChannelList.isNotEmpty ||
          tempSelectedChannelList != null) {
        for (var k = 0; k < tempSelectedChannelList.length; k++) {
          if (tempSelectedChannelList[k].selected == true &&
              tempSelectedChannelList[k].package == false) {
            selectedChannelList.add(AddonPackageChannel());
            selectedChannelList[m].channelId =
                tempSelectedChannelList[k].channelId;
            selectedChannelList[m].channelName =
                tempSelectedChannelList[k].channelName;
            selectedChannelList[m].channelCost =
                tempSelectedChannelList[k].channelCost;
            selectedChannelList[m].billable =
                tempSelectedChannelList[k].billable;
            m++;
          }
        }
      }
    });
    for (var i = 0; i < selectedAddOnPackageList.length; i++) {
      print(selectedAddOnPackageList[i].packageId +
          " => " +
          selectedAddOnPackageList[i].packageName +
          " => " +
          selectedAddOnPackageList[i].packageCost);
      for (var j = 0; j < selectedAddOnPackageList[i].channels.length; j++) {
        print(selectedAddOnPackageList[i].channels[j].id +
            " => " +
            selectedAddOnPackageList[i].channels[j].name);
      }
    }
    for (var k = 0; k < selectedChannelList.length; k++) {
      print(selectedChannelList[k].channelId +
          " => " +
          selectedChannelList[k].channelName +
          " => " +
          selectedChannelList[k].channelCost);
    }
  }

  tempSelectPackageChannels() {
    setState(() {
      cleartempPackage();
      cleartempChannels();
      isselectedAddOnPackageChannelList.clear();
      print("Start");
      print("isAddBouquetAddon : ");
      print(isAddBouquetAddon);
      print("selectedAddOnPackageList : ");
      for (var i = 0; i < isAddBouquetAddon.length; i++) {
        for (var j = 0; j < tempAddOnPackage.length; j++) {
          if (tempAddOnPackage[j].packageId == isAddBouquetAddon[i]) {
            // tempSelectedAddOnPackageList[j].packageId = tempAddOnPackage[j].packageId;
            // tempSelectedAddOnPackageList[j].packageName =
            //     tempAddOnPackage[j].packageName;
            tempSelectedAddOnPackageList[j].packageCost =
                tempAddOnPackage[j].packagecost.toString();
            tempSelectedAddOnPackageList[j].selected = true;
            tempSelectedAddOnPackageList[j].billable = "Repeat";
            for (var m = 0; m < tempAddOnPackage[j].channels.length; m++) {
              isselectedAddOnPackageChannelList
                  .add(tempAddOnPackage[j].channels[m].id);
            }

            print("Package Id : " +
                tempSelectedAddOnPackageList[j].packageId +
                " => Package Name : " +
                tempSelectedAddOnPackageList[j].packageName +
                " => Package Price : " +
                tempSelectedAddOnPackageList[j].packageCost +
                " => Package Selected : " +
                tempSelectedAddOnPackageList[j].selected.toString() +
                " => Package Billable : " +
                tempSelectedAddOnPackageList[j].billable);
          }
        }
      }
      print("isAddChannel : ");
      print(isAddChannel);
      print("selectedChannelList : ");
      for (var k = 0; k < isAddChannel.length; k++) {
        for (var l = 0; l < tempChannel.length; l++) {
          if (tempChannel[l].channelId == isAddChannel[k]) {
            // tempSelectedChannelList[l].channelId = tempChannel[l].channelId;
            // tempSelectedChannelList[l].channelName = tempChannel[l].channelName;
            tempSelectedChannelList[l].channelCost =
                tempChannel[l].price.toString();
            tempSelectedChannelList[l].selected = true;
            tempSelectedChannelList[l].package = false;
            tempSelectedChannelList[l].billable = "Repeat";

            print("Channel Id : " +
                tempSelectedChannelList[l].channelId +
                " => Channel Name : " +
                tempSelectedChannelList[l].channelName +
                " => Channel Price : " +
                tempSelectedChannelList[l].channelCost +
                " => Channel Selected : " +
                tempSelectedChannelList[l].selected.toString() +
                " => Channel Package : " +
                tempSelectedChannelList[l].package.toString() +
                " => Channel Billable : " +
                tempSelectedChannelList[l].billable);
          }
        }
      }
      print("isselectedAddOnPackageChannelList : ");
      print(isselectedAddOnPackageChannelList);
      for (var n = 0; n < isselectedAddOnPackageChannelList.length; n++) {
        for (var o = 0; o < tempChannel.length; o++) {
          if (tempChannel[o].channelId ==
              isselectedAddOnPackageChannelList[n]) {
            // tempSelectedChannelList[o].channelId = tempChannel[o].channelId;
            // tempSelectedChannelList[o].channelName = tempChannel[o].channelName;
            tempSelectedChannelList[o].channelCost =
                tempChannel[o].price.toString();
            tempSelectedChannelList[o].selected = true;
            tempSelectedChannelList[o].package = true;

            print("Package Channel Id : " +
                tempSelectedChannelList[o].channelId +
                " => Package Channel Name : " +
                tempSelectedChannelList[o].channelName +
                " => Package Channel Price : " +
                tempSelectedChannelList[o].channelCost +
                " => Package Channel Selected : " +
                tempSelectedChannelList[o].selected.toString() +
                " => Package Channel isPackage : " +
                tempSelectedChannelList[o].package.toString());
          }
        }
      }
      print("End");
      addOnPackage = tempSelectedAddOnPackageList;
      channel = tempSelectedChannelList;
    });
  }

  Widget bouquetAddOnSearchBar() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 10.0,
          ),
          Expanded(
            child: TextFormField(
              controller: _searchAddOnPackage,
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
            value: bouquetSelected,
            onChanged: (value) {
              setState(() {
                bouquetSelected = value;
              });
            },
            activeColor: Color(0xffae275f),
          ),
        ],
      );

  Widget _bouquetAddOnBuildList() {
    List<AddOnPackage> tempBouquetAddOnList = [];
    if (_searchAddOnPackageText.isNotEmpty) {
      for (int i = 0; i < addOnPackage.length; i++) {
        try {
          if (addOnPackage[i]
              .packageName
              .toLowerCase()
              .contains(_searchAddOnPackageText.toLowerCase())) {
            tempBouquetAddOnList.add(addOnPackage[i]);
          }
        } catch (error) {
          print(error);
        }
      }
    }

    searchAddOnPackageList = tempBouquetAddOnList;
    if (searchAddOnPackageList != null) {
      setState(() {
        if (bouquetSelected) {
          searchAddOnPackageList.sort(
              (a, b) => a.selected.toString().compareTo(b.selected.toString()));
          searchAddOnPackageList = searchAddOnPackageList.reversed.toList();
        } else {
          searchAddOnPackageList
              .sort((a, b) => a.packageName.compareTo(b.packageName));
        }
      });
    }
    return Expanded(
      child: new ListView.builder(
          itemCount: searchAddOnPackageList == null
              ? 0
              : searchAddOnPackageList.length,
          itemBuilder: (BuildContext context, int i) {
            return _bouquetAddOnView(searchAddOnPackageList[i]);
          }),
    );
  }
//================================================================//

  Widget channelListView() {
    if (channel != null) {
      setState(() {
        if (channelSelected) {
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
            return _channelView(channel[i]);
          }),
    );
  }

  Widget _channelView(Channel _channel) {
    return InkWell(
        // onTap: () {},
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
                      "Included In Bouquet",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
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
                        isAddChannel.add(_channel.channelId);
                        tempSelectPackageChannels();
                      } else {
                        _channel.selected = value;
                        isAddChannel.remove(_channel.channelId);
                        tempSelectPackageChannels();
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

  Widget channelSearchBar() => Row(
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
            value: channelSelected,
            onChanged: (value) {
              setState(() {
                channelSelected = value;
              });
            },
            activeColor: Color(0xffae275f),
          ),
        ],
      );

  Widget _channelBuildList() {
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
        if (channelSelected) {
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
            return _channelView(searchChannelList[i]);
          }),
    );
  }
  //================================================================//

  addBouquets() {
    return TabBarView(
      controller: tabcontroller,
      children: <Widget>[
        Column(
          children: <Widget>[
            bouquetAddOnSearchBar(),
            Container(
              height: 10.0,
            ),
            (_searchAddOnPackage.text.isEmpty)
                ? bouquetAddOnListView()
                : _bouquetAddOnBuildList()
          ],
        ),
        Column(
          children: <Widget>[
            channelSearchBar(),
            Container(
              height: 10.0,
            ),
            (_searchChannel.text.isEmpty)
                ? channelListView()
                : _channelBuildList()
          ],
        )
      ],
    );
  }

  addCustomer() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5.0,
          ),
          lastInsertedCustomer(),
          Container(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Container(
                width: 10.0,
              ),
              Text(
                "Customer Details :",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Container(
            height: 5.0,
          ),
          addPersonalDetails(),
          Container(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Container(
                width: 10.0,
              ),
              Text(
                "Contact Details :",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Container(
            height: 5.0,
          ),
          addContactDetails(),
          Container(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Container(
                width: 10.0,
              ),
              Text(
                "Connection Details :",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Container(
            height: 5.0,
          ),
          Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              margin: new EdgeInsets.all(0.0),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.0),
                      border: Border.all(color: Colors.black12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: isAddCableInternet == true
                                        ? Color(0xffae275f)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(0.0)),
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isAddCableInternet = true;
                                      });
                                    },
                                    icon: Text(
                                      "Cable",
                                      style: TextStyle(
                                        color: isAddCableInternet == true
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
                                    color: isAddCableInternet == false
                                        ? Color(0xffae275f)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(0.0)),
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isAddCableInternet = false;
                                      });
                                    },
                                    icon: Text(
                                      "Internet",
                                      style: TextStyle(
                                        color: isAddCableInternet == false
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
          isAddCableInternet == true ? addCableDetails() : addInternetDetails(),
        ],
      );

  lastInsertedCustomer() {
    return Column(
      children: <Widget>[
        Container(
          child: Card(
            margin: new EdgeInsets.symmetric(vertical: 5.0),
            shape: RoundedRectangleBorder(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Row(
                //   children: <Widget>[
                //     Container(
                //       alignment: Alignment.centerLeft,
                //       padding: EdgeInsets.symmetric(
                //           vertical: 5.0, horizontal: 10.0),
                //       child: Text(
                //         "Last Inserted Customer Details",
                //         style: TextStyle(
                //           fontSize: 12.0,
                //           fontWeight: FontWeight.w900,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: Row(
                      children: <Widget>[
                        Text("Last Inserted Customer ID :"),
                        Text(
                          lastCustomer.customerId,
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ],
                    )),
                // Container(
                //     padding:
                //         EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                //     child: Row(children: <Widget>[
                //       Expanded(
                //         child: Text("Customer Name : "),
                //       ),
                //     ])),
              ],
            ),
          ),
        )
      ],
    );
  }

  addPersonalDetails() => Column(
        children: <Widget>[
          Container(
            child: Card(
              margin: new EdgeInsets.symmetric(vertical: 5.0),
              shape: RoundedRectangleBorder(),
              child: Column(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
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
                          // onSubmitted: (value) {
                          //   setState(() {
                          //     _dobController.text = value;
                          //     _dobdate = value;
                          //   });
                          // },
                          // onEditingComplete: () {
                          //   setState(() {
                          //     _dobdate = _dobController.text;
                          //   });
                          // },
                          validator: (value) {
                            // TextEditingController.fromValue(
                            //     new TextEditingValue(
                            //         text: _dobdate,
                            //         selection: new TextSelection.collapsed(
                            //             offset: _dobdate.length)));
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
                      // Expanded(
                      //   flex: 0,
                      // child: Text(_dobdate),
                      // child: isdobdate
                      //     ? Text(formatter.format(
                      //         DateTime.tryParse(_dobdate.toString())
                      //             .toLocal()))
                      //     : Text(_dobdate),
                      // ),
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
                              mainAxisAlignment: MainAxisAlignment.start,
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
                  // Row(
                  //   children: <Widget>[
                  //     Container(
                  //       alignment: Alignment.centerLeft,
                  //       padding: EdgeInsets.symmetric(
                  //           vertical: 0.0, horizontal: 5.0),
                  //       child: Text(
                  //         "Photo : ",
                  //         style: TextStyle(
                  //           fontSize: 12.0,
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       alignment: Alignment.centerLeft,
                  //       padding: EdgeInsets.all(3.0),
                  //       child: RaisedButton(
                  //         onPressed: _optionsDialogBox,
                  //         child: Icon(
                  //           Icons.file_upload,
                  //           color: Color(0xffae275f),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      );

  addContactDetails() {
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
      children: <Widget>[
        Container(
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            shape: RoundedRectangleBorder(),
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
                        textFieldConfiguration: TextFieldConfiguration(
                            controller: _streetController,
                            decoration: InputDecoration(
                              labelText: "Street",
                              labelStyle: TextStyle(fontSize: 12.0),
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
                        textFieldConfiguration: TextFieldConfiguration(
                            controller: _areaController,
                            decoration: InputDecoration(
                              labelText: "Area",
                              labelStyle: TextStyle(fontSize: 12.0),
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
                // Row(
                //   children: <Widget>[
                //     Container(
                //       alignment: Alignment.centerLeft,
                //       padding:
                //           EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                //       child: Text(
                //         "Upload Id Proof : ",
                //         style: TextStyle(
                //           fontSize: 12.0,
                //         ),
                //       ),
                //     ),
                //     Container(
                //       alignment: Alignment.centerLeft,
                //       padding: EdgeInsets.all(3.0),
                //       child: RaisedButton(
                //         onPressed: _optionsDialogBoxid,
                //         child: Icon(
                //           Icons.file_upload,
                //           color: Color(0xffae275f),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
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
                            items: collectionAgentList.map((String value) {
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
      ],
    );
  }

  addCableDetails() {
    // void _addBoxWidget() {
    //   setState(() {
    //     _count = _count + 1;
    //   });
    // }

    var boxes = List<Widget>();
    for (var i = 0; i < _count; i++) {
      var box = new Container(
        margin: new EdgeInsets.symmetric(horizontal: 4.0),
        child: addBoxDetails(i + 1),
      );
      boxes.add(box);
    }

    return Column(
      children: <Widget>[
        Container(
          child: Card(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
            shape: RoundedRectangleBorder(),
            child: Column(
              children: <Widget>[
                // Container(
                //   alignment: Alignment.centerLeft,
                //   padding:
                //       EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                //   child: Text(
                //     "Cable Details",
                //     style: TextStyle(
                //       fontSize: 12.0,
                //       fontWeight: FontWeight.w900,
                //     ),
                //   ),
                // ),
                Column(
                  children: boxes,
                ),
                // RaisedButton(
                //   onPressed: _addBoxWidget,
                //   child: Text(
                //     "Add Box",
                //     style: TextStyle(fontSize: 12.0),
                //   ),
                // ),
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
                              _instalamtpaidCableController.text = "0";
                            });
                          },
                          activeColor: Color(0xffae275f),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isInstallmentCable = true;
                              _instaltypeCable = "Installment";
                              _instalamtpaidCableController.text = "0";
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
                              controller: _instalamtpaidCableController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              validator: (value) {
                                setState(() {
                                  _instalamtpaidCableController.text = value;
                                  _instalamtpaidCable = value;
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: "Installation Amount Paid",
                                  labelStyle: TextStyle(fontSize: 12.0)),
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
                            _outstandbalanceCableController.text = value;
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
                        // textDirection: prefix0.TextDirection.rtl,
                        controller: _cableMonthlyRentController,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        // onSubmitted: (value) {
                        //   setState(() {
                        //     _cablemonthlyrent =
                        //         _cableMonthlyRentController.text;
                        //   });
                        // },
                        // onEditingComplete: () {
                        //   setState(() {
                        //     _cablemonthlyrent =
                        //         _cableMonthlyRentController.text;
                        //   });
                        // },
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
                      child: Text("Total Rental: Rs." + _cabletotalrental),
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
                        textCapitalization: TextCapitalization.sentences,
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
                  height: 5.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  addInternetDetails() {
    return Column(
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
                                      color: Colors.grey[600], fontSize: 12.0),
                                ),
                              ),
                            ],
                          ),
                          isExpanded: true,
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                          items: internetPlans.map((InternetPlan value) {
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
                                _internetMonthlyRentController.text = "";
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
                                  _actDateInternetController.text = value;
                                  _actdateInternet = value;
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
                                if (_freeconnectionInternet == false) {
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
                        controller: _outstandbalanceInternetController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        validator: (value) {
                          setState(() {
                            _outstandbalanceInternetController.text = value;
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
                            _internetMonthlyRentController.text = value;
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
                      child: Text("Total Rental: Rs." + _internettotalrental),
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
                        textCapitalization: TextCapitalization.sentences,
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
    );
  }

  Widget _subscriptionDetails() {
    var addons = List<TableRow>();

    for (var i = 0; i < selectedAddOnPackageList.length; i++) {
      var addon = _addonPackList(selectedAddOnPackageList[i]);
      addons.add(addon);
    }
    var channels = List<TableRow>();

    for (var i = 0; i < selectedChannelList.length; i++) {
      var channel = _addonChannelList(selectedChannelList[i]);
      channels.add(channel);
    }
    return selectedAddOnPackageList != null && selectedChannelList != null
        ? Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  (packageCost != null)
                      ? Table(
                          border: TableBorder.all(
                              width: 1.0, color: Colors.black45),
                          children: [
                            TableRow(children: [
                              TableCell(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        width: 100.0),
                                    SizedBox(
                                      child: Text(
                                        "MRP",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                      width: 60.0,
                                    ),
                                    SizedBox(
                                      child: Text(
                                        "GST",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                      width: 60.0,
                                    ),
                                    SizedBox(
                                      child: Text(
                                        "Total",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                      width: 60.0,
                                    ),
                                  ],
                                ),
                              )
                            ]),
                            _mainpackage != null
                                ? TableRow(children: [
                                    TableCell(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          SizedBox(
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: Colors.black54,
                                            ),
                                            width: 15.0,
                                          ),
                                          SizedBox(
                                            child:
                                                Text(_mainpackage.packageName),
                                            width: 100.0,
                                          ),
                                          SizedBox(
                                            child: Text(
                                              (formatters.format(
                                                      _mainpackage.packageCost))
                                                  .toString(),
                                              textAlign: TextAlign.right,
                                            ),
                                            width: 50.0,
                                          ),
                                          SizedBox(
                                            child: Text(
                                              (formatters.format((18 / 100) *
                                                      _mainpackage.packageCost))
                                                  .toString(),
                                              textAlign: TextAlign.right,
                                            ),
                                            width: 60.0,
                                          ),
                                          SizedBox(
                                            child: Text(
                                              (formatters.format(((18 / 100) *
                                                          _mainpackage
                                                              .packageCost) +
                                                      _mainpackage.packageCost))
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
                        )
                      : Container(),
                  SizedBox(
                    height: 1.0,
                  ),
                  Table(
                      border:
                          TableBorder.all(width: 1.0, color: Colors.black45),
                      children: addons),
                  SizedBox(
                    height: 0.5,
                  ),
                  Table(
                      border:
                          TableBorder.all(width: 1.0, color: Colors.black45),
                      children: channels),
                  SizedBox(
                    height: 1.0,
                  ),
                  (packageCost != null)
                      ? Table(
                          border: TableBorder.all(
                              width: 1.0, color: Colors.black45),
                          children: [
                              TableRow(children: [
                                TableCell(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        width: 100.0,
                                      ),
                                      SizedBox(
                                        child: Text(
                                          (formatters.format(_mainpackage !=
                                                      null
                                                  ? _mainpackage.packageCost +
                                                      packageCost
                                                  : packageCost))
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        ),
                                        width: 50.0,
                                      ),
                                      SizedBox(
                                        child: Text(
                                          (formatters.format((18 / 100) *
                                                  (_mainpackage != null
                                                      ? _mainpackage
                                                              .packageCost +
                                                          packageCost
                                                      : packageCost)))
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        ),
                                        width: 60.0,
                                      ),
                                      SizedBox(
                                        child: Text(
                                          (formatters.format(((18 / 100) *
                                                      (_mainpackage != null
                                                          ? _mainpackage
                                                                  .packageCost +
                                                              packageCost
                                                          : packageCost)) +
                                                  (_mainpackage != null
                                                      ? _mainpackage
                                                              .packageCost +
                                                          packageCost
                                                      : packageCost)))
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        ),
                                        width: 60.0,
                                      ),
                                    ],
                                  ),
                                )
                              ])
                            ])
                      : Container(),
                  SizedBox(
                    height: 10.0,
                  )
                ],
              )
            ],
          )
        : Container();
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

  addBoxDetails(i) {
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
                      // 'Connection and Package Details - $i',
                      'Connection and Package Details',
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
                      groupValue: _cabletype,
                      onChanged: (value) {
                        setState(() {
                          _cabletype = value;
                        });
                      },
                      activeColor: Color(0xffae275f),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _cabletype = "Digital";
                        });
                      },
                      child: Text(
                        "Digital",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Radio(
                      value: "Analog",
                      groupValue: _cabletype,
                      onChanged: (value) {
                        setState(() {
                          _cabletype = value;
                        });
                      },
                      activeColor: Color(0xffae275f),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _cabletype = "Analog";
                        });
                      },
                      child: Text(
                        "Analog",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Checkbox(
                      value: _freeconnectionCable,
                      onChanged: (value) {
                        setState(() {
                          _freeconnectionCable = value;
                        });
                      },
                      activeColor: Color(0xffae275f),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_freeconnectionCable == false) {
                            _freeconnectionCable = true;
                          } else {
                            _freeconnectionCable = false;
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
                            value: _msoname,
                            onChanged: (newVal) {
                              _msoname = newVal;
                              setState(() {});
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
                        groupValue: _boxtype,
                        onChanged: (value) {
                          setState(() {
                            _boxtype = value;
                          });
                        },
                        activeColor: Color(0xffae275f),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _boxtype = "SD";
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
                        groupValue: _boxtype,
                        onChanged: (value) {
                          setState(() {
                            _boxtype = value;
                          });
                        },
                        activeColor: Color(0xffae275f),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _boxtype = "HD";
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
                        controller: _actDateCableController,
                        maxLines: 1,
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          setState(() {
                            _actDateCableController.text = value;
                            _actdateCable = value;
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
                        _selectActDateCable(context);
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
                        controller: _vcnoController,
                        validator: (value) {
                          setState(() {
                            _vcnoController.text = value;
                            _vcno = value;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: "VC Number",
                            labelStyle: TextStyle(fontSize: 12.0)),
                      ),
                    ),
                    Container(width: 10.0),
                    InkWell(
                      onTap: scanVCNO,
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
                        controller: _nuidController,
                        validator: (value) {
                          setState(() {
                            _nuidController.text = value;
                            _nuid = value;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: "NUID Number",
                            labelStyle: TextStyle(fontSize: 12.0)),
                      ),
                    ),
                    Container(width: 10.0),
                    InkWell(
                      onTap: scanNUID,
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
                        controller: _irdController,
                        validator: (value) {
                          setState(() {
                            _irdController.text = value;
                            _ird = value;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: "IRD Number",
                            labelStyle: TextStyle(fontSize: 12.0)),
                      ),
                    ),
                    Container(width: 10.0),
                    InkWell(
                      onTap: scanIRD,
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
                        controller: _boxcommentController,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 1,
                        validator: (value) {
                          _boxcommentController.text = value;
                          _boxcomment = value;
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
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 10.0,
                                      ),
                                      Text(
                                        value.packageName +
                                            " - Rs. " +
                                            value.packageCost.toString(),
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              value: _mainpackage,
                              onChanged: (newVal) {
                                setState(() {
                                  _mainpackage = newVal;
                                  setCableRent();
                                });
                              })),
                      Container(width: 10.0),
                      _mainpackage != null
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _mainpackage = null;
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
                            value: _billing,
                            onChanged: (newVal) {
                              _billing = newVal;
                              setState(() {});
                            }),
                      ),
                      Container(width: 5.0),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 50.0,
                    ),
                    Expanded(
                      child: FloatingActionButton(
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
                            isSelectBouquetAddOnChannels = true;
                          });
                        },
                        child: Text(
                          "Add Bouquets/Add On/Ala Carte",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      width: 50.0,
                    ),
                  ],
                ),
                _mainpackage == null &&
                        selectedAddOnPackageList.length < 1 &&
                        selectedChannelList.length < 1
                    ? Container()
                    : Column(
                        children: <Widget>[
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
                                    children: <Widget>[_subscriptionDetails()],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                Container(height: 5.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
