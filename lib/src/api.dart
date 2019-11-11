library api;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

class API {
  String _base;
  Client _client;
  String _jwtToken;

  API(String base) {
    _base = base;
    _client = new Client();
  }

  Map<String, dynamic> responseHandler(Response response) {
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

  Future<Map<String, dynamic>> get(String endpoint, {bool private}) async {
    Response response;
    if (private != null && private) {
      response = await _client.get('$_base/$endpoint',
          headers: {"Authorization": "Bearer $_jwtToken"});
    } else {
      response = await _client.get('$_base/$endpoint');
    }
    return responseHandler(response);
  }

  Future<Map<String, dynamic>> post(String endpoint,
      {dynamic body, bool private}) async {
    Response response;
    if (private != null && private) {
      response = await _client.post('$_base/$endpoint',
          headers: {"Authorization": "Bearer $_jwtToken"}, body: body);
    } else {
      response = await _client.post('$_base/$endpoint', body: body);
    }
    return responseHandler(response);
  }

  Future<bool> loginRequest(String phoneNumber) async {
    Map<String, dynamic> resp =
        await post('login/request', body: {"phoneNumber": phoneNumber});
    if (resp["response"] == "ok") {
      return true;
    } else {
      throw 'Error! Login request failed - phoneNumber: $phoneNumber';
    }
  }

  Future<String> loginVerify(
      String phoneNumber, String verificationCode) async {
    Map<String, dynamic> resp = await post('login/verify',
        body: {"phoneNumber": phoneNumber, "code": verificationCode});
    if (resp["token"] != "") {
      _jwtToken = resp["token"];
      return _jwtToken;
    } else {
      throw 'Error! Login verify failed - phoneNumber: $phoneNumber, verificationCode: $verificationCode';
    }
  }

  Future<bool> createWallet(String accountAddress) async {
    Map<String, dynamic> resp =
        await post('wallets/$accountAddress', private: true);
    if (resp["response"] == "ok") {
      return true;
    } else {
      throw 'Error! Create wallet request failed - accountAddress: $accountAddress';
    }
  }

  Future<dynamic> getWallet() async {
    Map<String, dynamic> resp = await get('wallets', private: true);
    if (resp != null && resp["data"] != null) {
      return {
        "phoneNumber": resp["data"]["phoneNumber"],
        "accountAddress": resp["data"]["accountAddress"],
        "walletAddress": resp["data"]["walletAddress"],
        "createdAt": resp["data"]["createdAt"],
        "updatedAt": resp["data"]["updatedAt"]
      };
    } else {
      throw 'Error! Get wallet request failed';
    }
  }
}
