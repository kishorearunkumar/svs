import 'package:http/http.dart' as http;
import 'package:svs/utils/constants.dart';
import 'package:svs/models/user.dart';

import 'dart:io';

String apiUrl = APIConstants.API_BASE_URL;

Future<http.Response> login(User user) async {
  var response = await http.post(Uri.encodeFull(apiUrl + "authenticate"),
      body: userToJson(user),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'});
  return response;
}
