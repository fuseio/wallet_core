library api;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:wallet_core/src/utils.dart';
import 'package:wallet_core/src/web3.dart';

const String API_BASE_URL = 'https://studio-qa-ropsten.fusenet.io/api';
const String FUNDER_BASE_URL = 'https://funder-qa.fuse.io/api';

class API {
  String _base;
  Client _client;
  String _jwtToken;
  String _phoneNumber;
  String _accountAddress;
  String _firebaseIdToken;
  String _funderBase;

  API({String base, String jwtToken, String funderBase}) {
    _base = base ?? API_BASE_URL;
    _jwtToken = jwtToken ?? null;
    _client = new Client();
    _funderBase = funderBase ?? FUNDER_BASE_URL;
  }

  void setJwtToken(String jwtToken) {
    _jwtToken = jwtToken;
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

  Future<Map<String, dynamic>> _get(String endpoint, {bool private, bool isRopsten = false}) async {
    print('GET $endpoint');
    Response response;
    String uri = isRopsten ? toRopsten(_base) : _base;
    if (private != null && private) {
      response = await _client.get('$uri/$endpoint',
          headers: {"Authorization": "Bearer $_jwtToken"});
    } else {
      response = await _client.get('$uri/$endpoint');
    }
    return _responseHandler(response);
  }

  Future<Map<String, dynamic>> _post(String endpoint,
      {dynamic body, bool private, bool isRopsten = false}) async {
    print('POST $endpoint $body');
    Response response;
    body = body == null ? body : json.encode(body);
    String uri = isRopsten ? toRopsten(_base) : _base;
    if (private != null && private) {
      response = await _client.post('$uri/$endpoint',
          headers: {
            "Authorization": "Bearer $_jwtToken",
            "Content-Type": 'application/json'
          },
          body: body);
    } else {
      response = await _client.post('$uri/$endpoint',
          body: body, headers: {"Content-Type": 'application/json'});
    }
    return _responseHandler(response);
  }

  Future<Map<String, dynamic>> _put(String endpoint,
      {dynamic body, bool private}) async {
    print('PUT $endpoint $body');
    Response response;
    body = body == null ? body : json.encode(body);
    if (private != null && private) {
      response = await _client.put('$_base/$endpoint',
          headers: {
            "Authorization": "Bearer $_jwtToken",
            "Content-Type": 'application/json'
          },
          body: body);
    } else {
      response = await _client.put('$_base/$endpoint',
          body: body, headers: {"Content-Type": 'application/json'});
    }
    return _responseHandler(response);
  }

  Future<String> login(String token, String accountAddress, String identifier, {String appName}) async {
    Map<String, dynamic> resp = await _post('v2/login', body: {
      "token": token,
      "accountAddress": accountAddress,
      "identifier": identifier,
      "appName": appName
    });
    if (resp["token"] != "") {
      _jwtToken = resp["token"];
      _firebaseIdToken = token;
      _accountAddress = accountAddress;
      return _jwtToken;
    } else {
      throw 'Error! Login verify failed - accountAddress: $accountAddress, token: $token, identifier: $identifier';
    }
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

  Future<String> loginVerify(String phoneNumber, String verificationCode,
      String accountAddress) async {
    Map<String, dynamic> resp = await _post('v2/login/verify', body: {
      "phoneNumber": phoneNumber,
      "code": verificationCode,
      "accountAddress": accountAddress
    });
    if (resp["token"] != "") {
      _jwtToken = resp["token"];
      _phoneNumber = phoneNumber;
      _accountAddress = accountAddress;
      return _jwtToken;
    } else {
      throw 'Error! Login verify failed - phoneNumber: $phoneNumber, verificationCode: $verificationCode';
    }
  }

  Future<dynamic> createWalletOnForeign() async {
    Map<String, dynamic> resp = await _post('v2/wallets/foreign', private: true);
    if (resp["job"] != null) {
      return resp;
    } else {
      throw 'Error! Create foreign wallet request failed - accountAddress: $_accountAddress, phoneNumber: $_phoneNumber';
    }
  }

  Future<dynamic> createWallet() async {
    dynamic wallet = await getWallet();
    if (wallet != null && wallet["walletAddress"] != null) {
      print('Wallet already exists - wallet: $wallet');
      return wallet;
    }

    Map<String, dynamic> resp = await _post('v2/wallets', private: true);
    if (resp["job"] != null) {
      return resp;
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
        "updatedAt": resp["data"]["updatedAt"],
        "communityManager": resp['data']['walletModules']['CommunityManager'],
        "transferManager": resp['data']['walletModules']['TransferManager'],
        "dAIPointsManager": resp['data']['walletModules']['DAIPointsManager'] ?? null,
        "networks": resp['data']['networks'],
        "backup": resp['backup'],
      };
    } else {
      return {};
    }
  }

  Future<dynamic> getJob(String id) async {
    Map<String, dynamic> resp = await _get('v2/jobs/$id', private: true);
    if (resp != null && resp["data"] != null) {
      return resp["data"];
    } else {
      return null;
    }
  }

  Future<dynamic> getWalletByPhoneNumber(String phoneNumber) async {
    Map<String, dynamic> resp =
        await _get('v2/wallets/$phoneNumber', private: true);
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

  Future<dynamic> updateFirebaseToken(String walletAddress, String firebaseToken) async {
    Map<String, dynamic> resp = await _put('v2/wallets/token/$walletAddress',
      body: {"firebaseToken": firebaseToken}, private: true);
    return resp;
  }

  Future<dynamic> backupWallet(String communityAddress) async {
    Map<String, dynamic> resp = await _post('v2/wallets/backup',
      body: {"communityAddress": communityAddress}, private: true);
    return resp;
  }

  Future<dynamic> joinCommunity(
      Web3 web3, String walletAddress, String communityAddress) async {
    Map<String, dynamic> data =
        await web3.joinCommunityOffChain(walletAddress, communityAddress);
    Map<String, dynamic> resp =
        await _post('v2/relay', private: true, body: data);
    return resp;
  }

  Future<dynamic> transfer(Web3 web3, String walletAddress,
      String receiverAddress, int amountInWei) async {
    Map<String, dynamic> data = await web3.transferOffChain(
        walletAddress, receiverAddress, amountInWei);
    Map<String, dynamic> resp =
        await _post('v2/relay', private: true, body: data);
    return resp;
  }

  Future<dynamic> tokenTransfer(Web3 web3, String walletAddress,
      String tokenAddress, String receiverAddress, num tokensAmount, {String network}) async {
    Map<String, dynamic> data = await web3.transferTokenOffChain(
        walletAddress, tokenAddress, receiverAddress, tokensAmount, network: network);
    Map<String, dynamic> resp =
        await _post('v2/relay', private: true, body: data);
    return resp;
  }

  Future<dynamic> approveTokenTransfer(Web3 web3, String walletAddress, String tokenAddress, num tokensAmount, {String network}) async {
    Map<String, dynamic> data = await web3.approveTokenOffChain(walletAddress, tokenAddress, tokensAmount, network: network);
    Map<String, dynamic> resp = await _post('v2/relay', private: true, body: data);
    return resp;
  }

  Future<dynamic> trasferDaiToDaiPointsOffChain(Web3 web3, String walletAddress, num tokensAmount, int tokenDecimals, {String network}) async {
    Map<String, dynamic> data = await web3.trasferDaiToDAIpOffChain(walletAddress, tokensAmount, tokenDecimals, network: network);
    Map<String, dynamic> resp = await _post('v2/relay', private: true, body: data);
    return resp;
  }

  Future<dynamic> getCommunityData(String communityAddress, {bool isRopsten = false, String walletAddress}) async {
    String url = walletAddress != null ? 'v1/communities/$communityAddress/$walletAddress' : 'v1/communities/$communityAddress';
    Map<String, dynamic> resp = await _get(
        url, private: false, isRopsten: isRopsten);
    return resp['data'];
  }

  Future<dynamic> getBusinessList(String communityAddress) async {
    Map<String, dynamic> resp = await _get(
        'v1/entities/$communityAddress?type=business&withMetadata=true');
    return resp;
  }

  Future<dynamic> getEntityMetadata(String communityAddress, String account, {bool isRopsten = false}) async {
    Map<String, dynamic> resp = await _get(
        'v1/entities/metadata/$communityAddress/$account', isRopsten: isRopsten);
    return resp['data'];
  }

  Future<dynamic> syncContacts(List<String> phoneNumbers) async {
    Map<String, dynamic> resp = await _post('v2/contacts', body: {"contacts": phoneNumbers}, private: true);
    return resp["data"];
  }

  Future<dynamic> ackSync(int nonce) async {
    Map<String, dynamic> resp = await _post('v2/contacts/$nonce', private: true);
    return resp;
  }

  Future<dynamic> invite(String phoneNumber, String communityAddress, {String name = '', String amount = '', String symbol = ''}) async {
    Map<String, dynamic> resp = await _post('v2/wallets/invite/$phoneNumber', body: {"communityAddress": communityAddress, "name": name, "amount": amount, "symbol": symbol}, private: true);
    return resp;
  }

  Future<dynamic> saveUserToDb(Map body) async {
    Map<String, dynamic> resp = await _post('v2/users', body: body, private: false);
    return resp;
  }

  Future<dynamic> createProfile(String communityAddress, Map publicData) async {
    Map<String, dynamic> resp = await _put('v1/profiles/$communityAddress', body: {"publicData": publicData}, private: false);
    return resp;
  }

  Future<dynamic> fetchMetadata(String uri) async {
    Map<String, dynamic> resp = await _get('v1/metadata/$uri', private: false);
    return resp['data'];
  }

  Future<dynamic> getFunderJob(String id) async {
    Client funderClient = new Client();
    Response response = await funderClient.get('$_funderBase/job/$id');
    Map<String, dynamic> data = _responseHandler(response);
    return data['data'];
  }
}
