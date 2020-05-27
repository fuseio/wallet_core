import 'dart:convert';

import 'package:http/http.dart';

abstract class Api {
  Map<String, dynamic> responseHandler(Response response) {
    print('response: ${response.statusCode}, ${response.reasonPhrase}');
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> obj = json.decode(response.body);
        return obj;
      case 401:
        throw 'Error! Unauthorized';
        break;
      default:
        throw 'Error! status: ${response.statusCode}, reason: ${response.reasonPhrase}';
    }
  }
}