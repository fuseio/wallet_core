library api;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:wallet_core/src/web3.dart';

const String API_BASE_URL = 'http://localhost:3000/api';

class API {
  String _base;
  Client _client;
  String _jwtToken;
  String _phoneNumber;
  String _accountAddress;

  API({String base}) {
    _base = base ?? API_BASE_URL;
    _client = new Client();
  }

  Map<String, dynamic> _responseHandler(Response response) {
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

  Future<Map<String, dynamic>> _get(String endpoint, {bool private}) async {
    print('GET $endpoint');
    Response response;
    if (private != null && private) {
      response = await _client.get('$_base/$endpoint',
          headers: {"Authorization": "Bearer $_jwtToken"});
    } else {
      response = await _client.get('$_base/$endpoint');
    }
    return _responseHandler(response);
  }

  Future<Map<String, dynamic>> _post(String endpoint,
      {dynamic body, bool private}) async {
    print('POST $endpoint $body');
    Response response;
    if (private != null && private) {
      response = await _client.post('$_base/$endpoint',
          headers: {"Authorization": "Bearer $_jwtToken", "Content-Type": 'application/json'}, body: body);
    } else {
      response = await _client.post('$_base/$endpoint', body: body, headers: {"Content-Type": 'application/json'});
    }
    return _responseHandler(response);
  }

  Future<bool> loginRequest(String phoneNumber) async {
    Map<String, dynamic> resp =
        await _post('v2/login/request', body: {"phoneNumber": phoneNumber});
    if (resp["response"] == "ok") {
      return true;
    } else {
      throw 'Error! Login request failed - phoneNumber: $phoneNumber';
    }
  }

  Future<String> loginVerify(
      String phoneNumber, String verificationCode, String accountAddress) async {
    Map<String, dynamic> resp = await _post('v2/login/verify',
        body: {"phoneNumber": phoneNumber, "code": verificationCode, "accountAddress" : accountAddress});
    if (resp["token"] != "") {
      _jwtToken = resp["token"];
      _phoneNumber = phoneNumber;
      _accountAddress = accountAddress;
      return _jwtToken;
    } else {
      throw 'Error! Login verify failed - phoneNumber: $phoneNumber, verificationCode: $verificationCode';
    }
  }

  Future<bool> createWallet() async {
    dynamic wallet = await getWallet();
    if (wallet != null && wallet["walletAddress"] != null) {
      print('Wallet already exists - wallet: $wallet');
      return true;
    }

    Map<String, dynamic> resp =
        await _post('v2/wallets', private: true);
    if (resp["response"] == "ok") {
      return true;
    } else {
      throw 'Error! Create wallet request failed - accountAddress: $_accountAddress, phoneNumber: $_phoneNumber';
    }
  }

  Future<dynamic> getWallet() async {
    Map<String, dynamic> resp = await _get('v2/wallets', private: true);
    if (resp != null && resp["data"] != null) {
      return {
        "phoneNumber": resp["data"]["phoneNumber"],
        "accountAddress": resp["data"]["accountAddress"],
        "walletAddress": resp["data"]["walletAddress"],
        "createdAt": resp["data"]["createdAt"],
        "updatedAt": resp["data"]["updatedAt"]
      };
    } else {
      return {};
    }
  }

  Future<dynamic> getWalletByPhoneNumber(String phoneNumber) async {
    Map<String, dynamic> resp = await _get('v2/wallets/$phoneNumber', private: true);
    if (resp != null && resp["data"] != null) {
      return {
        "phoneNumber": resp["data"]["phoneNumber"],
        "accountAddress": resp["data"]["accountAddress"],
        "walletAddress": resp["data"]["walletAddress"],
        "createdAt": resp["data"]["createdAt"],
        "updatedAt": resp["data"]["updatedAt"]
      };
    } else {
      return {};
    }
  }

  Future<dynamic> joinCommunity(Web3 web3, String walletAddress, String communityAddress) async {
    Map<String, dynamic> data = await web3.joinCommunityOffChain(walletAddress, communityAddress);
    Map<String, dynamic> resp = await _post('v2/relay', body: json.encode(data));
    print(resp);
  }
}
