import 'dart:convert';

import 'package:http/http.dart';

abstract class Api {
  Map<String, dynamic> responseHandler(Response response) {
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> obj = json.decode(response.body);
        return obj;
      case 401:
        throw 'Error! Unauthorized';
      case 400:
      case 403:
        Map<String, dynamic> obj = json.decode(response.body);
        throw obj['error'] ?? 'Error! Unauthorized';
      default:
        Map<String, dynamic> obj = json.decode(response.body);
        throw 'Error! status: ${response.statusCode}, reason: ${response.reasonPhrase} ${obj['error'] ?? obj.toString()}';
    }
  }

  String toRopsten(String baseURI) {
    if (baseURI.contains('qa')) {
      return baseURI;
    } else {
      return baseURI.replaceAll('studio', 'studio-ropsten');
    }
  }
}
