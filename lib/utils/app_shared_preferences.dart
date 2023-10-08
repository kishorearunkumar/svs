import 'dart:async';
import 'dart:convert';
import 'package:svs/models/general.dart';
import 'package:svs/models/login-response.dart';
import 'package:svs/models/dashboard.dart';
import 'package:svs/models/customer.dart';
import 'package:svs/models/complaint.dart';
// import 'package:svs/models/last-customer.dart';
import 'package:svs/models/payment.dart';
import 'package:svs/models/billing.dart';
import 'package:svs/models/street.dart';
import 'package:svs/models/area.dart';
import 'package:svs/models/username.dart';
import 'package:svs/models/user.dart';
import 'package:svs/models/payment-category.dart';
import 'package:svs/models/mso.dart';
import 'package:svs/utils/constants.dart';
import 'package:svs/models/mainpackage.dart';
import 'package:svs/models/addon-package.dart';
import 'package:svs/models/channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:svs/models/sublco.dart';
import 'package:svs/models/internet-plan.dart';
import 'package:svs/models/internet-billing-setting.dart';
import 'package:svs/models/complaint-category.dart';

class AppSharedPreferences {
///////////////////////////////////////////////////////////////////////////////
  static Future<SharedPreferences> getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

///////////////////////////////////////////////////////////////////////////////
  static Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(SharedPreferenceKeys.IS_USER_LOGGED_IN, false);
    prefs.setBool(SharedPreferenceKeys.IS_GET_lIST_DATA, false);
    prefs.setString(SharedPreferenceKeys.USER, '');
    prefs.setString(SharedPreferenceKeys.CUSTOMERS, '');
    prefs.setString(SharedPreferenceKeys.DASHBOARD, '');
    prefs.setString(SharedPreferenceKeys.PAYMENTS, '');
    prefs.setString(SharedPreferenceKeys.COMPLAINTS, '');
    prefs.setString(SharedPreferenceKeys.BILLINGS, '');
    prefs.setString(SharedPreferenceKeys.STREETS, '');
    prefs.setString(SharedPreferenceKeys.AREAS, '');
    prefs.setString(SharedPreferenceKeys.AGENTS, '');
    prefs.setString(SharedPreferenceKeys.MSO, '');
    prefs.setString(SharedPreferenceKeys.DEVICENAME, '');
    prefs.setString(SharedPreferenceKeys.DEVICE, '');
    prefs.setString(SharedPreferenceKeys.PAPERSIZE, '');
    prefs.setString(SharedPreferenceKeys.MAINPACKAGE, '');
    prefs.setString(SharedPreferenceKeys.CUSTOMER_SUCCESS, '');
    prefs.setString(SharedPreferenceKeys.SUB_LCO, '');
    prefs.setString(SharedPreferenceKeys.PAYMENT_CATEGORY, '');
    prefs.setString(SharedPreferenceKeys.PACKAGE, '');
    prefs.setString(SharedPreferenceKeys.CHANNEL, '');
    prefs.setString(SharedPreferenceKeys.CUSTOMER_PAYMENTS, '');
    prefs.setString(SharedPreferenceKeys.CUSTOMER_INVOICES, '');
    prefs.setString(SharedPreferenceKeys.CUSTOMER_COMPLAINTS, '');
    prefs.setString(SharedPreferenceKeys.CUSTOMER_STATUS, '');
    prefs.setString(SharedPreferenceKeys.DETAILED_BILL, '');
    prefs.setString(SharedPreferenceKeys.TAX_SETTING, '');
    prefs.setString(SharedPreferenceKeys.INTERNET_EXPIRY, '');
    prefs.setString(SharedPreferenceKeys.INTERNET_PLAN, '');
    prefs.setString(SharedPreferenceKeys.INTERNET_BILLING_SETTING, '');
    prefs.setString(SharedPreferenceKeys.COMPLAINT_CATEGORY, '');
    prefs.setString(SharedPreferenceKeys.GENERAL_SETTINGS, '');

  }

  static Future<void> clearRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(SharedPreferenceKeys.REMEMBER_ME, '');
  }

///////////////////////////////////////////////////////////////////////////////
  static Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceKeys.IS_USER_LOGGED_IN);
  }

  static Future<void> setUserLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(SharedPreferenceKeys.IS_USER_LOGGED_IN, isLoggedIn);
  }

  static Future<bool> isGetListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPreferenceKeys.IS_GET_lIST_DATA);
  }

  static Future<void> setGetListData(bool isGetListData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(SharedPreferenceKeys.IS_GET_lIST_DATA, isGetListData);
  }

  static Future<String> getCustomerSuccess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.CUSTOMER_SUCCESS);
  }

  static Future<void> setCustomerSuccess(String customerAdd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(SharedPreferenceKeys.CUSTOMER_SUCCESS, customerAdd);
  }

  static Future<String> getDeviceName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.DEVICENAME);
  }

  static Future<void> setDeviceName(String deviceName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(SharedPreferenceKeys.DEVICENAME, deviceName);
  }

  static Future<String> getDetailedBill() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.DETAILED_BILL);
  }

  static Future<void> setDetailedBill(String detailedBill) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(SharedPreferenceKeys.DETAILED_BILL, detailedBill);
  }

  static Future<String> getTaxSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.TAX_SETTING);
  }

  static Future<void> setTaxSetting(String taxSetting) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(SharedPreferenceKeys.TAX_SETTING, taxSetting);
  }

  static Future<String> getPaperSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferenceKeys.PAPERSIZE);
  }

  static Future<void> setPaperSize(String paperSize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(SharedPreferenceKeys.PAPERSIZE, paperSize);
  }

///////////////////////////////////////////////////////////////////////////////

  static Future<LoginResponse> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return LoginResponse.fromJson(
        json.decode(prefs.getString(SharedPreferenceKeys.USER)));
  }

  static Future<void> setUserProfile(LoginResponse user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userProfileJson = json.encode(user);
    return prefs.setString(SharedPreferenceKeys.USER, userProfileJson);
  }

  static Future<User> getRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return User.fromJson(
        json.decode(prefs.getString(SharedPreferenceKeys.REMEMBER_ME)));
  }

  static Future<void> setRememberMe(User rememberMe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String rememberMeJson = json.encode(rememberMe);
    return prefs.setString(SharedPreferenceKeys.REMEMBER_ME, rememberMeJson);
  }

  // static Future<LastCustomer> getLastCustomerId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return LastCustomer.fromJson(
  //       json.decode(prefs.getString(SharedPreferenceKeys.LAST_CUSTOMER_ID)));
  // }

  // static Future<void> setLastCustomerId(LastCustomer lastCustomerId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String lastCustomerIdJson = json.encode(lastCustomerId);
  //   return prefs.setString(SharedPreferenceKeys.USER, lastCustomerIdJson);
  // }

  static Future<BluetoothDevice> getDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return BluetoothDevice.fromMap(
        json.decode(prefs.getString(SharedPreferenceKeys.DEVICE)));
  }

  static Future<void> setDevice(BluetoothDevice device) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceMap = json.encode(device);
    return prefs.setString(SharedPreferenceKeys.DEVICE, deviceMap);
  }

///////////////////////////////////////////////////////////////////////////////
  static Future<Dashboard> getDashboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Dashboard.fromJson(
        json.decode(prefs.getString(SharedPreferenceKeys.DASHBOARD)));
  }

  static Future<void> setDashboard(Dashboard dashboard) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dashbaordJson = json.encode(dashboard);
    return prefs.setString(SharedPreferenceKeys.DASHBOARD, dashbaordJson);
  }

  static Future<List<Customer>> getCustomers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return customerFromJson(prefs.getString(SharedPreferenceKeys.CUSTOMERS));
  }

  static Future<void> setCustomers(List<Customer> customer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String customersJson = json.encode(customer);
    return prefs.setString(SharedPreferenceKeys.CUSTOMERS, customersJson);
  }

  static Future<List<Payment>> getPayments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return paymentsFromJson(prefs.getString(SharedPreferenceKeys.PAYMENTS));
  }

  static Future<void> setPayments(List<Payment> payment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String paymentsJson = json.encode(payment);
    return prefs.setString(SharedPreferenceKeys.PAYMENTS, paymentsJson);
  }

  static Future<List<Complaint>> getComplaints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return complaintsFromJson(prefs.getString(SharedPreferenceKeys.COMPLAINTS));
  }

  static Future<void> setComplaints(List<Complaint> complaint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String complaintsJson = json.encode(complaint);
    return prefs.setString(SharedPreferenceKeys.COMPLAINTS, complaintsJson);
  }

  static Future<List<Billing>> getBillings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return billingFromJson(prefs.getString(SharedPreferenceKeys.BILLINGS));
  }

  static Future<void> setBillings(List<Billing> billing) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String billingsJson = json.encode(billing);
    return prefs.setString(SharedPreferenceKeys.BILLINGS, billingsJson);
  }

  static Future<List<Payment>> getOfflineSubscriptionPayments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return paymentsFromJson(
        prefs.getString(SharedPreferenceKeys.OFFSUBSCRIPTIONPAYMENTS));
  }

  static Future<void> setOfflineSubscriptionPayments(
      List<Payment> offSubscriptionPayment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String offSubscriptionPaymentsJson = json.encode(offSubscriptionPayment);
    return prefs.setString(SharedPreferenceKeys.OFFSUBSCRIPTIONPAYMENTS,
        offSubscriptionPaymentsJson);
  }

  static Future<List<Payment>> getOfflineInstallationPayments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return paymentsFromJson(
        prefs.getString(SharedPreferenceKeys.OFFINSTALLATIONPAYMENTS));
  }

  static Future<void> setOfflineInstallationPayments(
      List<Payment> offInstallationPayment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String offInstallationPaymentsJson = json.encode(offInstallationPayment);
    return prefs.setString(SharedPreferenceKeys.OFFINSTALLATIONPAYMENTS,
        offInstallationPaymentsJson);
  }

  static Future<List<Payment>> getOfflineOthersPayments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return paymentsFromJson(
        prefs.getString(SharedPreferenceKeys.OFFOTHERSPAYMENTS));
  }

  static Future<void> setOfflineOthersPayments(
      List<Payment> offOthersPayment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String offOthersPaymentsJson = json.encode(offOthersPayment);
    return prefs.setString(
        SharedPreferenceKeys.OFFOTHERSPAYMENTS, offOthersPaymentsJson);
  }

  static Future<List<Street>> getStreets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return streetsFromJson(prefs.getString(SharedPreferenceKeys.STREETS));
  }

  static Future<void> setStreets(List<Street> street) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String streetsJson = json.encode(street);
    return prefs.setString(SharedPreferenceKeys.STREETS, streetsJson);
  }

  static Future<List<Areas>> getAreas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return areasFromJson(prefs.getString(SharedPreferenceKeys.AREAS));
  }

  static Future<void> setAreas(List<Areas> area) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String areasJson = json.encode(area);
    return prefs.setString(SharedPreferenceKeys.AREAS, areasJson);
  }

  static Future<List<Username>> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return usernamesFromJson(prefs.getString(SharedPreferenceKeys.AGENTS));
  }

  static Future<void> setUsername(List<Username> agent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String agentJson = json.encode(agent);
    return prefs.setString(SharedPreferenceKeys.AGENTS, agentJson);
  }

  static Future<List<Mso>> getMso() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return msosFromJson(prefs.getString(SharedPreferenceKeys.MSO));
  }

  static Future<void> setMso(List<Mso> mso) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String msoJson = json.encode(mso);
    return prefs.setString(SharedPreferenceKeys.MSO, msoJson);
  }

  static Future<List<MainPackage>> getMainPackage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return mainPackagesFromJson(
        prefs.getString(SharedPreferenceKeys.MAINPACKAGE));
  }

  static Future<void> setMainPackage(List<MainPackage> mainPackage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainPackageJson = json.encode(mainPackage);
    return prefs.setString(SharedPreferenceKeys.MAINPACKAGE, mainPackageJson);
  }

  static Future<List<SubLco>> getSubLco() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return subLcosFromJson(prefs.getString(SharedPreferenceKeys.SUB_LCO));
  }

  static Future<void> setSubLco(List<SubLco> subLco) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String subLcoJson = json.encode(subLco);
    return prefs.setString(SharedPreferenceKeys.SUB_LCO, subLcoJson);
  }

  static Future<List<PaymentCategory>> getPaymentCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return paymentCategorysFromJson(
        prefs.getString(SharedPreferenceKeys.PAYMENT_CATEGORY));
  }

  static Future<void> setPaymentCategory(
      List<PaymentCategory> paymentCategory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String paymentCategoryJson = json.encode(paymentCategory);
    return prefs.setString(
        SharedPreferenceKeys.PAYMENT_CATEGORY, paymentCategoryJson);
  }

  static Future<List<AddOnPackage>> getAddOnPackage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return addOnPackagesFromJson(prefs.getString(SharedPreferenceKeys.PACKAGE));
  }

  static Future<void> setAddOnPackage(List<AddOnPackage> package) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String packageJson = json.encode(package);
    return prefs.setString(SharedPreferenceKeys.PACKAGE, packageJson);
  }

  static Future<List<Channel>> getChannel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return channelsFromJson(prefs.getString(SharedPreferenceKeys.CHANNEL));
  }

  static Future<void> setChannel(List<Channel> channel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String channelJson = json.encode(channel);
    return prefs.setString(SharedPreferenceKeys.CHANNEL, channelJson);
  }

  static Future<List<Customer>> getInternetExpiry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return customerFromJson(
        prefs.getString(SharedPreferenceKeys.INTERNET_EXPIRY));
  }

  static Future<void> setInternetExpiry(List<Customer> customer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String customersJson = json.encode(customer);
    return prefs.setString(SharedPreferenceKeys.INTERNET_EXPIRY, customersJson);
  }

  static Future<List<InternetPlan>> getInternetPlan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return internetPlanFromJson(
        prefs.getString(SharedPreferenceKeys.INTERNET_PLAN));
  }

  static Future<void> setInternetPlan(List<InternetPlan> internetPlan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String internetPlanJson = json.encode(internetPlan);
    return prefs.setString(
        SharedPreferenceKeys.INTERNET_PLAN, internetPlanJson);
  }

  static Future<List<InternetBillingSetting>>
      getInternetBillingSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return internetBillingSettingFromJson(
        prefs.getString(SharedPreferenceKeys.INTERNET_BILLING_SETTING));
  }

  static Future<void> setInternetBillingSetting(
      List<InternetBillingSetting> internetBillingSetting) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String internetBillingSettingJson = json.encode(internetBillingSetting);
    return prefs.setString(SharedPreferenceKeys.INTERNET_BILLING_SETTING,
        internetBillingSettingJson);
  }

  static Future<List<ComplaintCategory>> getComplaintCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return complaintCategoryFromJson(
        prefs.getString(SharedPreferenceKeys.COMPLAINT_CATEGORY));
  }

  static Future<void> setComplaintCategory(
      List<ComplaintCategory> complaintCategory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String complaintCategoryJson = json.encode(complaintCategory);
    return prefs.setString(
        SharedPreferenceKeys.COMPLAINT_CATEGORY, complaintCategoryJson);
  }

  static Future<List<General>> getGeneralSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return generalsFromJson(
        prefs.getString(SharedPreferenceKeys.GENERAL_SETTINGS));
  }

  static Future<void> setGeneralSettings(List<General> generalSettings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String generalSettingsJson = json.encode(generalSettings);
    return prefs.setString(
        SharedPreferenceKeys.GENERAL_SETTINGS, generalSettingsJson);
  }
}
