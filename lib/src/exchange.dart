library exchange;

import 'dart:async';

import 'package:http/http.dart';
import 'package:wallet_core/models/api.dart';

class Exchange extends Api {
  String _base;
  Client _client;

  Exchange({String base = 'https://api.1inch.exchange/v1.1'}) {
    _client = new Client();
    _base = base;
  }

  Future<Map<String, dynamic>> _get(String endpoint, {bool private, bool isRopsten = false}) async {
    print('Exchange - GET $_base/$endpoint');
    Response response = await _client.get('$_base/$endpoint');
    return responseHandler(response);
  }

  Future getQuote(String fromTokenAddress, String toTokenAddress, String amount, {String extraParams}) async {
    String uri = 'quote?fromTokenAddress=$fromTokenAddress&toTokenAddress=$toTokenAddress&amount=$amount';
    if (extraParams != null) {
      uri = '$uri$extraParams';
    }
    Map<String, dynamic> response = await _get(uri);
    return response;
  }
}