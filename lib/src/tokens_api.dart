library tokens_api;

import 'dart:async';

import 'package:http/http.dart';
import 'package:wallet_core/models/api.dart';

const String ETHEREUM_API_BASE_URL = 'https://api.etherscan.io/api';

class TokensApi extends Api {
  String _base;
  String _apiKey;
  Client _client;

  TokensApi({String etherscanBase, String etherscanApiKey}) {
    _base = etherscanBase ?? ETHEREUM_API_BASE_URL;
    _apiKey = etherscanApiKey;
    _client = new Client();
  }

  Future<Map<String, dynamic>> _get(String endpoint) async {
    Response response = await _client.get('$_base/$endpoint');
    return responseHandler(response);
  }

  Future<dynamic> getTransferEventsByAccountAddress(String accountAddress,
      {int startblock = 0, endBlock = 999999999, String sort = 'desc'}) async {
    try {
      Map<String, dynamic> resp = await _get(
          '?module=account&action=tokentx&address=$accountAddress&startblock=$startblock&endblock=$endBlock&sort=$sort&apikey=$_apiKey');
      return resp['result'];
    } catch (e) {
      throw e;
    }
  }

  Future<List<dynamic>> getTokenTransferEventsByAccountAddress(
      String tokenAddress, String accountAddress,
      {String sort = 'desc', int startblock = 0}) async {
    try {
      Map<String, dynamic> resp = await _get(
          '?module=account&action=tokentx&contractaddress=$tokenAddress&address=$accountAddress&startblock=$startblock&sort=$sort&apikey=$_apiKey');
      if (resp['message'] == 'OK' && resp['status'] == '1') {
        List transfers = [];
        for (dynamic transferEvent in resp['result']) {
          transfers.add({
            'blockNumber': int.parse(transferEvent['blockNumber'].toString()),
            'txHash': transferEvent['hash'],
            'to': transferEvent['to'],
            'from': transferEvent["from"],
            'status': "CONFIRMED",
            'timestamp': int.parse(transferEvent['timeStamp'].toString()),
            'value': BigInt.from(num.parse(transferEvent['value'])),
            'tokenAddress': tokenAddress,
            'type': transferEvent["from"].toString().toLowerCase() ==
                    accountAddress.toLowerCase()
                ? 'SEND'
                : 'RECEIVE',
          });
        }
        return transfers;
      } else {
        return [];
      }
    } catch (e) {
      throw e;
    }
  }

  Future<BigInt> getTokenBalanceByAccountAddress(
      String tokenAddress, String accountAddress,
      {int startblock = 0, endBlock = 999999999}) async {
    try {
      Map<String, dynamic> resp = await _get(
          '?module=account&action=tokenbalance&contractaddress=$tokenAddress&address=$accountAddress&tag=latest&apikey=$_apiKey');
      return BigInt.from(num.parse(resp['result']));
    } catch (e) {
      throw e;
    }
  }
}
