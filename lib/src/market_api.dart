library market_api;

import 'dart:async';

import 'package:http/http.dart';
import 'package:wallet_core/models/api.dart';

const String MARKET_API_BASE_URL = 'https://api.coingecko.com/api/v3';

class MarketApi extends Api {
  String? _base;
  late Client _client;

  MarketApi({String marketBaseApi = MARKET_API_BASE_URL}) {
    _base = marketBaseApi;
    _client = new Client();
  }

  Future<Map<String, dynamic>?> _get(String endpoint) async {
    Uri uri = Uri.parse('$_base/$endpoint');
    Response response = await _client.get(uri);
    return responseHandler(response);
  }

  // Get current price of tokens (using contract addresses) for a given platform in any other currency that you need.
  Future<dynamic> getCurrentPriceOfTokens(
      String contractAddresses, String vsCurrencies,
      {String networkId = 'ethereum'}) async {
    try {
      Map<String, dynamic>? response = await _get(
          'simple/token_price/$networkId?contract_addresses=$contractAddresses&vs_currencies=$vsCurrencies');
      return response;
    } catch (e) {
      throw e;
    }
  }

  // Get the current price of any cryptocurrencies in any other supported currencies that you need.
  Future<dynamic> getCurrentPriceOfToken(
    String ids,
    String vsCurrencies,
  ) async {
    try {
      Map<String, dynamic>? response =
          await _get('/simple/price?ids=$ids&vs_currencies=$vsCurrencies');
      return response;
    } catch (e) {
      throw e;
    }
  }

  // Get coin info from contract address
  Future<dynamic> getCoinInfoByAddress(String contractAddress,
      {String networkId = 'ethereum'}) async {
    try {
      Map<String, dynamic>? response =
          await _get('/coins/$networkId/contract/$contractAddress');
      return response;
    } catch (e) {
      throw e;
    }
  }
}
