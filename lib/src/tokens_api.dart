library tokens_api;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

const String ETHEREUM_API_BASE_URL = 'https://api.etherscan.io/api';
const String AMBER_DATA_API_BASE_URL = 'https://web3api.io/api';

class TokensApi {
  String _base;
  String _apiKey;
  String _amberbase;
  String _amberdataApiKey;
  Client _client;
  Client _amberDataclient;

  TokensApi({String etherscanBase, String etherscanApiKey, String amberdataBaseUri, String amberdataApiKey}) {
    _base = etherscanBase ?? ETHEREUM_API_BASE_URL;
    _amberbase = amberdataBaseUri ?? AMBER_DATA_API_BASE_URL;
    _apiKey = etherscanApiKey;
    _amberdataApiKey = amberdataApiKey;
    _client = new Client();
    _amberDataclient = new Client();
  }

  Future<Map<String, dynamic>> _get(String endpoint) async {
    Response response = await _client.get('$_base/$endpoint');
    return _responseHandler(response);
  }

  Future<Map<String, dynamic>> _amberDataGet(String endpoint) async {
    print('GET $_amberbase/$endpoint');
    Response response = await _amberDataclient.get('$_amberbase/$endpoint',
      headers: {"x-api-key": "$_amberdataApiKey"});
    return _responseHandler(response);
  }

  Map<String, dynamic> _responseHandler(Response response) {
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> obj = json.decode(response.body);
        return obj;
        break;
      default:
        throw 'Error! status: ${response.statusCode}, reason: ${response.reasonPhrase}';
    }
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

  Future<dynamic> getTokenTransferEventsByAccountAddress(String tokenAddress, String accountAddress,
      {String sort = 'desc', int startblock = 0}) async {
    try {
      Map<String, dynamic> resp = await _get(
          '?module=account&action=tokentx&contractaddress=$tokenAddress&address=$accountAddress&startblock=$startblock&sort=$sort&apikey=$_apiKey');
      return resp['result'];
    } catch (e) {
      throw e;
    }
  }

  Future<BigInt> getTokenBalanceByAccountAddress(String tokenAddress, String accountAddress,
      {int startblock = 0, endBlock = 999999999}) async {
    try {
      Map<String, dynamic> resp = await _get(
          '?module=account&action=tokenbalance&contractaddress=$tokenAddress&address=$accountAddress&tag=latest&apikey=$_apiKey');
      return BigInt.from(num.parse(resp['result']));
    } catch (e) {
      throw e;
    }
  }

  // Retrieves the tokens this accountAddress is holding.
  Future<List> geTokensUserHolding(String accountAddress) async {
    try {
      Map<String, dynamic> resp = await _amberDataGet('v1/addresses/$accountAddress/tokens');
      List tokens = [];
      if (resp['payload'] != null && resp['payload']['records'] != null) {
        for (dynamic record in resp['payload']['records']) {
          tokens.add({
            "address": record['address'],
            "decimals": int.parse(record['decimals'].toString()),
            "name": record['name'],
            "symbol": record['symbol'],
            "amount": BigInt.from(num.parse(record['amount']))
          });
        }
      }
      return tokens;
    } catch (e) {
      throw 'ERROR in tokens user holds $e';
    }
  }

  // Retrieves the latest account and token balances for the specified address
  Future<dynamic> getAddressBalances(String accountAddress) async {
    try {
      Map<String, dynamic> resp = await _amberDataGet('v2/addresses/$accountAddress/balances?includePrice=true');
      List tokens = [];
      if (resp['payload'] != null && resp['payload']['tokens'] != null) {
        for (dynamic record in resp['payload']['tokens']) {
          tokens.add({
            "address": record['address'],
            "decimals": record['decimals'],
            "name": record['name'],
            "timestamp": record["timestamp"],
            "symbol": record['symbol'],
            "amount": BigInt.from(num.parse(record['amount']))
          });
        }
      }
      return { "price": resp['payload']['price'] ?? {}, "tokens": tokens };
    } catch (e) {
      throw 'ERROR in get address balances $e';
    }
  }

  // Address Token Transfers [PRO]
  // Retrieves all token transfers involving the specified address.
  // /v2/addresses/hash/token-transfers
  // Future<dynamic> getTokenTransfersByAddress(String accountAddress, String tokenAddress, {int size = 100}) async {
  //   try {
  //     Map<String, dynamic> resp = await _amberDataGet('/v2/addresses/$accountAddress/token-transfers?tokenAddress=$tokenAddress&size=$size');
  //     List transfers = [];
  //     if (resp['payload'] != null && resp['payload']['records'] != null) {
  //       for (dynamic record in resp['payload']['records']) {
  //         transfers.add({
  //         "blockNumber": num.parse(record["blockNumber"].toString()),
  //         "from": record["from"]['address'],
  //         "to": record["to"][0]['address'],
  //         "tokenAddress": record["tokenAddress"],
  //         "txHash": record["transactionHash"],
  //         "value": BigInt.from(num.parse(record["amount"])),
  //         "type":  accountAddress.toLowerCase() == record["from"]['address'].toString().toLowerCase() ? "RECEIVE" : "SEND",
  //         "status": "CONFIRMED",
  //         "timestamp": int.parse(record['timestamp'].toString()),
  //         });
  //       }
  //     }
  //     return transfers;
  //   } catch (e) {
  //     throw e;
  //   }
  // }
}
