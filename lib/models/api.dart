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
        throw Exception('Error! Unauthorized');
      case 403:
        Map<String, dynamic> obj = json.decode(response.body);
        throw Exception(obj['error'] ?? 'Error! Unauthorized');
      default:
        Map<String, dynamic> obj = json.decode(response.body);
        throw Exception(
            'Error! status: ${response.statusCode}, reason: ${response.reasonPhrase} ${obj['error'] ?? obj.toString()}');
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
