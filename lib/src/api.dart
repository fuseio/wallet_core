library api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'package:wallet_core/models/api.dart';

class API extends Api {
  late String _base;
  late Client _client;
  String? _jwtToken;

  API(
    String base,
  )   : _base = base,
        _client = Client();

  void setJwtToken(String jwtToken) {
    _jwtToken = jwtToken;
  }

  Future<Map<String, dynamic>> _get(
    String endpoint, {
    bool private = false,
    bool isRopsten = false,
  }) async {
    print('GET $endpoint');
    Response response;
    String uri = isRopsten ? toRopsten(_base) : _base;
    if (private) {
      response = await _client.get(
        Uri.parse('$uri/$endpoint'),
        headers: {
          "Authorization": "Bearer $_jwtToken",
        },
      );
    } else {
      response = await _client.get(Uri.parse('$uri/$endpoint'));
    }
    return responseHandler(response);
  }

  Future<Map<String, dynamic>> _post(
    String endpoint, {
    dynamic body,
    bool private = false,
    bool isRopsten = false,
  }) async {
    print('POST $endpoint $body');
    Response response;
    body = body == null ? body : json.encode(body);
    String uri = isRopsten ? toRopsten(_base) : _base;
    if (private) {
      response = await _client.post(
        Uri.parse('$uri/$endpoint'),
        body: body,
        headers: {
          "Authorization": "Bearer $_jwtToken",
          "Content-Type": 'application/json'
        },
      );
    } else {
      response = await _client.post(
        Uri.parse('$uri/$endpoint'),
        body: body,
        headers: {
          "Content-Type": 'application/json',
        },
      );
    }
    return responseHandler(response);
  }

  Future<Map<String, dynamic>> _put(
    String endpoint, {
    dynamic body,
    bool private = false,
  }) async {
    print('PUT $endpoint $body');
    Response response;
    body = body == null ? body : json.encode(body);
    if (private) {
      response = await _client.put(
        Uri.parse('$_base/$endpoint'),
        body: body,
        headers: {
          "Authorization": "Bearer $_jwtToken",
          "Content-Type": 'application/json'
        },
      );
    } else {
      response = await _client.put(
        Uri.parse('$_base/$endpoint'),
        body: body,
        headers: {
          "Content-Type": 'application/json',
        },
      );
    }
    return responseHandler(response);
  }

  Future<dynamic> getCommunityData(
    String communityAddress, {
    bool isRopsten = false,
    String? walletAddress,
  }) async {
    String url = walletAddress != null
        ? 'v1/communities/$communityAddress/$walletAddress'
        : 'v1/communities/$communityAddress';
    Map<String, dynamic> resp = await _get(
      url,
      isRopsten: isRopsten,
    );
    return resp['data'];
  }

  Future<dynamic> getBusinessList(String communityAddress) async {
    Map<String, dynamic> resp = await _get(
      'v1/entities/$communityAddress?type=business&withMetadata=true',
    );
    return resp;
  }

  Future<dynamic> getEntityMetadata(
    String communityAddress,
    String account, {
    bool isRopsten = false,
  }) async {
    Map<String, dynamic> resp = await _get(
      'v1/entities/metadata/$communityAddress/$account',
      isRopsten: isRopsten,
    );
    return resp['data'];
  }

  Future<dynamic> saveUserToDb(Map body) async {
    Map<String, dynamic> resp = await _post(
      'v2/users',
      body: body,
    );
    return resp;
  }

  Future<dynamic> updateAvatar(
    String accountAddress,
    String avatarHash,
  ) async {
    Map<String, dynamic> resp = await _put(
      'v2/users/$accountAddress/avatar',
      body: {"avatarHash": avatarHash},
      private: true,
    );
    return resp;
  }

  Future<dynamic> updateDisplayName(
    String accountAddress,
    String displayName,
  ) async {
    Map<String, dynamic> resp = await _put(
      'v2/users/$accountAddress/name',
      body: {"displayName": displayName},
      private: true,
    );
    return resp;
  }

  Future<dynamic> uploadImage(
    File imageFile,
  ) async {
    MultipartRequest request =
        new MultipartRequest("POST", Uri.parse('$_base/v1/images'));
    request.files.add(await MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));
    StreamedResponse streamedResponse = await request.send();
    Response response = await Response.fromStream(streamedResponse);
    return responseHandler(response);
  }

  Future<dynamic> fetchMetadata(String uri, {bool isRopsten = false}) async {
    Map<String, dynamic> resp = await _get(
      'v1/metadata/$uri',
      isRopsten: isRopsten,
    );
    return resp['data'];
  }

  Future<Map<String, dynamic>> getWalletAddressByMajorAndMonirIds(int major, int minor) async {
    String url = 'v2/wallets/beacons/$major/$minor';
    Map<String, dynamic> resp = await _get(
      url,
      private: true,
    );
    print('omri:: walletcore response - ${resp}');
    return resp['data'];
  }
}
