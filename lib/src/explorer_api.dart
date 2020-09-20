library explorer_api;

import 'dart:async';

import 'package:http/http.dart';
import 'package:wallet_core/models/api.dart';

class ExplorerApi extends Api {
  String _base;
  String _apiKey;
  Client _client;

  ExplorerApi({String base, String apiKey}) {
    _base = base;
    _apiKey = apiKey;
    _client = new Client();
  }

  Future<Map<String, dynamic>> _get(String endpoint) async {
    Response response;
    if ([null, ''].contains(_apiKey)) {
      response = await _client.get('$_base$endpoint');
    } else {
      response = await _client.get('$_base$endpoint&apikey=$_apiKey');
    }
    return responseHandler(response);
  }

  Future<List<dynamic>> getTokenTransferEventsByAccountAddress(
      String tokenAddress, String accountAddress,
      {String sort = 'desc', int startblock = 0}) async {
    try {
      Map<String, dynamic> resp = await _get(
          '?module=account&action=tokentx&contractaddress=$tokenAddress&address=$accountAddress&startblock=$startblock&sort=$sort');
      if (resp['message'] == 'OK' && resp['status'] == '1') {
        List transfers = [];
        for (dynamic transferEvent in resp['result']) {
          transfers.add({
            'blockNumber': num.parse(transferEvent['blockNumber']),
            'txHash': transferEvent['hash'],
            'to': transferEvent['to'],
            'from': transferEvent["from"],
            'status': "CONFIRMED",
            'timestamp': DateTime.fromMillisecondsSinceEpoch(
                    DateTime.fromMillisecondsSinceEpoch(
                                int.parse(transferEvent['timeStamp']))
                            .millisecondsSinceEpoch *
                        1000)
                .millisecondsSinceEpoch,
            'value': transferEvent['value'],
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
      throw 'Error! Get token transfers events failed for - accountAddress: $accountAddress --- $e';
    }
  }

  Future<BigInt> getTokenBalanceByAccountAddress(
    String tokenAddress,
    String accountAddress,
  ) async {
    try {
      Map<String, dynamic> resp = await _get(
          '?module=account&action=tokenbalance&contractaddress=$tokenAddress&address=$accountAddress');
      return BigInt.from(num.parse(resp['result']));
    } catch (e) {
      throw 'Error! Get token balance failed for - accountAddress: $accountAddress --- $e';
    }
  }
}
