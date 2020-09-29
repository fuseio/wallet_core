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

  Future<List<dynamic>> getTransferEventsByAccountAddress(String address,
      {String sort = 'desc', int startblock = 0}) async {
    try {
      Map<String, dynamic> resp = await _get(
          '?module=account&action=tokentx&address=$address&startblock=$startblock&sort=$sort');
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
            'tokenAddress': transferEvent['contractAddress'],
            'type': transferEvent["from"].toString().toLowerCase() ==
                    address.toLowerCase()
                ? 'SEND'
                : 'RECEIVE',
          });
        }
        return transfers;
      } else {
        return [];
      }
    } catch (e) {
      throw 'Error! Get token transfers events failed for - address: $address --- $e';
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

  Future<Map<String, dynamic>> getTokenInfo(String tokenAddress) async {
    try {
      Map<String, dynamic> resp = await _get(
          '?module=token&action=getToken&contractaddress=$tokenAddress');
      if (resp['message'] == 'OK' && resp['status'] == '1') {
        return Map.from({
          ...resp['result'],
          'decimals': int.parse(resp['result']['decimals'])
        });
      }
      return Map();
    } catch (e) {
      throw 'Error! Get token failed $tokenAddress - $e';
    }
  }

  Future<List<dynamic>> getListOfTokensByAddress(String address) async {
    try {
      Map<String, dynamic> resp =
          await _get('?module=account&action=tokenlist&address=$address');
      if (resp['message'] == 'OK' && resp['status'] == '1') {
        List tokens = [];
        for (dynamic token in resp['result']) {
          tokens.add({
            "amount": token['balance'],
            "originNetwork": 'mainnet',
            "address": token['contractAddress'].toLowerCase(),
            "decimals": int.parse(token['decimals']),
            "name": token['name'],
            "symbol": token['symbol']
          });
        }
        return tokens;
      } else {
        return [];
      }
    } catch (e) {
      throw 'Error! Get token list failed for - address: $address --- $e';
    }
  }
}
