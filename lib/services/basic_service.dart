import 'package:http/http.dart' as http;
import 'package:svs/utils/constants.dart';
import 'package:svs/models/login-response.dart';
import 'package:svs/models/payment.dart';
import 'package:svs/models/customer.dart';
import 'package:svs/models/complaint.dart';
import 'package:svs/models/internet-billing.dart';
import 'dart:io';
import 'package:svs/utils/app_shared_preferences.dart';

String apiUrl = APIConstants.API_BASE_URL;

Future<http.Response> dashboard() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(Uri.encodeFull(apiUrl + "dashboard"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> customerList() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(Uri.encodeFull(apiUrl + "customer"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> saveCustomer(Customer customer) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.post(Uri.encodeFull(apiUrl + "customer"),
      body: customersToJson(customer),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });
  return response;
}

Future<http.Response> updateCustomerDetails(
    Customer customer, String id) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.put(Uri.encodeFull(apiUrl + "customer/" + id),
      body: customersToJson(customer),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });
  return response;
}

Future<http.Response> paymentList() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(Uri.encodeFull(apiUrl + "payment"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });

  return response;
}

Future<http.Response> paymentListDateRange(
    String fromDate, String toDate) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(
      Uri.encodeFull(
          apiUrl + "payment-daterange-filter/" + fromDate + "/" + toDate),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });

  return response;
}

Future<http.Response> invoiceListDateRange(
    String fromDate, String toDate) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(
      Uri.encodeFull(
          apiUrl + "invoice-daterange-filter/" + fromDate + "/" + toDate),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });

  return response;
}

Future<http.Response> billingList() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(Uri.encodeFull(apiUrl + "billing"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });

  return response;
}

Future<http.Response> saveSubscriptionPayment(Payment payment) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.post(Uri.encodeFull(apiUrl + "payment"),
      body: paymentToJson(payment),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });
  return response;
}

Future<http.Response> saveInstallationPayment(Payment payment) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.post(
      Uri.encodeFull(apiUrl + "installation-payment"),
      body: paymentToJson(payment),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });
  return response;
}

Future<http.Response> saveOthersPayment(Payment payment) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.post(Uri.encodeFull(apiUrl + "other-payment"),
      body: paymentToJson(payment),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });
  return response;
}

Future<http.Response> complaintList() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(Uri.encodeFull(apiUrl + "complaint"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });

  return response;
}

Future<http.Response> saveComplaint(Complaint complaint) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.post(Uri.encodeFull(apiUrl + "complaint"),
      body: complaintToJson(complaint),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });
  return response;
}

Future<http.Response> updateComplaint(Complaint complaint, String id) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.put(Uri.encodeFull(apiUrl + "complaint/" + id),
      body: complaintToJson(complaint),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });
  return response;
}

Future<http.Response> streetList() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(Uri.encodeFull(apiUrl + "street"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });

  return response;
}

Future<http.Response> areaList() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(Uri.encodeFull(apiUrl + "area"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });

  return response;
}

Future<http.Response> usernameList() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(Uri.encodeFull(apiUrl + "user"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> msoList() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(Uri.encodeFull(apiUrl + "mso"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> lastCustomerList() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response =
      await http.get(Uri.encodeFull(apiUrl + "customer-last-id"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> generalList(lcoid) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();
  if (lcoid == null) {
    lcoid = "null";
  }
  var response = await http
      .get(Uri.encodeFull(apiUrl + "general-bill/" + lcoid), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> mainPackageList() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response =
      await http.get(Uri.encodeFull(apiUrl + "package/main"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> subLcoList() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(Uri.encodeFull(apiUrl + "sub-lco"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> paymentCategoryList() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response =
      await http.get(Uri.encodeFull(apiUrl + "payment-category"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> channelList() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(Uri.encodeFull(apiUrl + "channel"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> addOnPackageList() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response =
      await http.get(Uri.encodeFull(apiUrl + "package/addon"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> customerPaymentHistory(customerId) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response =
      await http.get(Uri.encodeFull(apiUrl + "pays/" + customerId), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> customerInvoiceHistory(customerId) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response =
      await http.get(Uri.encodeFull(apiUrl + "bills/" + customerId), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> customerComplaintHistory(customerId) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(
      Uri.encodeFull(apiUrl + "customer-complaints/" + customerId),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });
  return response;
}

Future<http.Response> customerStatusHistory(customerId) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(
      Uri.encodeFull(apiUrl + "customer-status-history/" + customerId),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });
  return response;
}

Future<http.Response> taxSettings() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response =
      await http.get(Uri.encodeFull(apiUrl + "tax-settings"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> internetExpiring() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(Uri.encodeFull(apiUrl + "expiring"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> internetBillingSettings() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http
      .get(Uri.encodeFull(apiUrl + "internet-billing-settings"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> internetPlan() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(Uri.encodeFull(apiUrl + "plan"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> saveInternetBilling(
    InternetBilling internetBilling) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.post(
      Uri.encodeFull(apiUrl + "generate-internet-invoice"),
      body: internetBillingToJson(internetBilling),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });
  return response;
}

Future<http.Response> complaintCategory() async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response =
      await http.get(Uri.encodeFull(apiUrl + "complaint-category"), headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
  });
  return response;
}

Future<http.Response> customerIdVerify(customerId) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.get(
      Uri.encodeFull(apiUrl + "customer-id-verify/" + customerId),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });
  return response;
}

Future<http.Response> saveOfflineSubscriptionPayment(
    List<Payment> offlineSubscriptionPayments) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.post(Uri.encodeFull(apiUrl + "multi-payment"),
      body: paymentsToJson(offlineSubscriptionPayments),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });
  return response;
}

Future<http.Response> saveOfflineInstallationPayment(
    List<Payment> offlineInstallationPayments) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.post(
      Uri.encodeFull(apiUrl + "multi-installation-payment"),
      body: paymentsToJson(offlineInstallationPayments),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });
  return response;
}

Future<http.Response> saveOfflineOthersPayment(
    List<Payment> offlineOthersPayments) async {
  LoginResponse loginResponse = await AppSharedPreferences.getUserProfile();

  var response = await http.post(Uri.encodeFull(apiUrl + "multi-other-payment"),
      body: paymentsToJson(offlineOthersPayments),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + loginResponse.token
      });
  return response;
}
