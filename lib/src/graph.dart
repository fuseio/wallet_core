library graph;

import 'dart:async';

import 'package:graphql/client.dart';
import 'package:wallet_core/src/queries.dart';

const String BASE_URL = 'https://graph.fuse.io/subgraphs/name/fuseio';
const String TOKEN_REGISTRY_URI = 'https://api.thegraph.com/subgraphs/name/protofire/token-registry';
const String SUB_GRAPH = 'fuse-qa';

class Graph {
  GraphQLClient _clientFuse;
  GraphQLClient _clientRopsten;
  GraphQLClient _clientMainnet;
  GraphQLClient _clientTokenRegistry;

  Graph({String url, String subGraph, String tokenRegistryUri = TOKEN_REGISTRY_URI}) {
    _clientFuse = GraphQLClient(
        link: HttpLink(uri: '${url ?? BASE_URL}/${subGraph ?? SUB_GRAPH}'),
        cache: InMemoryCache());
    _clientRopsten = GraphQLClient(
        link: HttpLink(uri: '${url ?? BASE_URL}/fuse-ropsten'),
        cache: InMemoryCache());
    _clientMainnet = GraphQLClient(
        link: HttpLink(uri: '${url ?? BASE_URL}/fuse-mainnet'),
        cache: InMemoryCache());
    _clientTokenRegistry = GraphQLClient(
        link: HttpLink(uri: '${tokenRegistryUri}'),
        cache: InMemoryCache());
  }

  Future<dynamic> getCommunityByAddress(String communityAddress) async {

    QueryResult result = await _clientFuse.query(QueryOptions(
      documentNode: gql(getCommunityByAddressQuery),
      variables: <String, dynamic>{
        'address': communityAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get community request failed - communityAddress: $communityAddress';
    } else {
      return result.data["communities"][0];
    }
  }

  Future<dynamic> getCommunityBusinesses(String communityAddress) async {

    QueryResult result = await _clientFuse.query(QueryOptions(
      documentNode: gql(getCommunityBusinessesQuery),
      variables: <String, dynamic>{
        'address': communityAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get community businesses request failed - communityAddress: $communityAddress';
    } else {
      return result.data["communities"][0]['entitiesList']['communityEntities'];
    }
  }

  Future<dynamic> getTokenOfCommunity(String communityAddress) async {

    QueryResult result = await _clientFuse.query(QueryOptions(
      documentNode: gql(getTokenOfCommunityQuery),
      variables: <String, dynamic>{
        'address': communityAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get token of community request failed - communityAddress: $communityAddress';
    } else {
      return result.data["tokens"][0];
    }
  }

  Future<bool> isCommunityMember(
      String accountAddress, String entitiesListAddress) async {
    _clientFuse.cache.reset();
    QueryResult result = await _clientFuse.query(QueryOptions(
      documentNode: gql(isCommunityMemberQuery),
      variables: <String, dynamic>{'address': accountAddress, 'entitiesList': entitiesListAddress},
    ));
    if (result.hasException) {
      throw 'Error! Is community member request failed - accountAddress: $accountAddress, entitiesListAddress: $entitiesListAddress';
    } else {
      return result.data["communityEntities"].length > 0;
    }
  }

  Future<dynamic> getTokenByAddress(String tokenAddress) async {
    _clientFuse.cache.reset();
    QueryResult result = await _clientFuse.query(QueryOptions(
      documentNode: gql(getTokenByAddressQuery),
      variables: <String, dynamic>{
        'address': tokenAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get token failed - for $tokenAddress ${result.exception}';
    } else {
      return result.data['tokens'];
    }
  }

  Future<BigInt> getTokenBalance(
      String accountAddress, String tokenAddress) async {
    _clientFuse.cache.reset();
    QueryResult result = await _clientFuse.query(QueryOptions(
      documentNode: gql(getTokenBalanceQuery),
      variables: <String, dynamic>{
        'account': accountAddress,
        'token': tokenAddress
      },
    ));
    if (result.hasException) {
      throw 'Error! Get token balance request failed - accountAddress: $accountAddress, tokenAddress: $tokenAddress';
    } else {
      try {
        return BigInt.from(
            num.parse(result.data["accounts"][0]["tokens"][0]["balance"]));
      } catch (RangeError) {
        return BigInt.from(0);
      }
    }
  }

  Future<dynamic> getReceivedTransfers(
      String accountAddress, String tokenAddress, {int fromBlockNumber, int toBlockNumber}) async {
    _clientFuse.cache.reset();

    Map<String, dynamic> variables = <String, dynamic>{
        'account': accountAddress,
        'token': tokenAddress,
        'n': 20,
    };

    if (fromBlockNumber != null) {
      variables['fromBlockNumber'] = fromBlockNumber;
    }
    if (toBlockNumber != null) {
      variables['toBlockNumber'] = toBlockNumber;
    }
    QueryResult result = await _clientFuse.query(QueryOptions(
      documentNode: gql(getReceivedTransfersQuery),
      variables: variables,
    ));
    if (result.hasException) {
      throw 'Error! Get transfers request failed - accountAddress: $accountAddress, tokenAddress: $tokenAddress';
    } else {
      List transfers = [];

      for (dynamic t in result.data['transfersIn']) {
        transfers.add({
          "blockNumber": num.parse(t["blockNumber"]),
          "data": t["data"] ?? null,
          "from": t["from"],
          "id": t["id"],
          "to": t["to"],
          "tokenAddress": t["tokenAddress"],
          "txHash": t["txHash"],
          "value": t["value"],
          "type": "RECEIVE",
          "status": "CONFIRMED",
          "timestamp": t['timestamp']
        });
      }

      transfers.sort((a, b) => b["blockNumber"].compareTo(a["blockNumber"]));
      return {"count": transfers.length, "data": transfers};
    }
  }
  Future<dynamic> getTransfers(
      String accountAddress, String tokenAddress, {int fromBlockNumber, int toBlockNumber}) async {
    _clientFuse.cache.reset();

    Map<String, dynamic> variables = <String, dynamic>{
        'account': accountAddress,
        'token': tokenAddress,
        'n': 20,
    };

    if (fromBlockNumber != null) {
      variables['fromBlockNumber'] = fromBlockNumber;
    }
    if (toBlockNumber != null) {
      variables['toBlockNumber'] = toBlockNumber;
    }
    QueryResult result = await _clientFuse.query(QueryOptions(
      documentNode: gql(getTransfersQuery),
      variables: variables,
    ));
    if (result.hasException) {
      throw 'Error! Get transfers request failed - accountAddress: $accountAddress, tokenAddress: $tokenAddress';
    } else {
      List transfers = [];

      for (num i = 0; i < result.data["transfersIn"].length; i++) {
        dynamic t = result.data["transfersIn"][i];
        transfers.add({
          "blockNumber": num.parse(t["blockNumber"]),
          "data": t["data"] ?? null,
          "from": t["from"],
          "id": t["id"],
          "to": t["to"],
          "tokenAddress": t["tokenAddress"],
          "txHash": t["txHash"],
          "value": t["value"],
          "type": "RECEIVE",
          "status": "CONFIRMED",
          "timestamp": t['timestamp']
        });
      }

      for (num i = 0; i < result.data["transfersOut"].length; i++) {
        dynamic t = result.data["transfersOut"][i];
        transfers.add({
          "blockNumber": num.parse(t["blockNumber"]),
          "data": t["data"] ?? null,
          "from": t["from"],
          "id": t["id"],
          "to": t["to"],
          "tokenAddress": t["tokenAddress"],
          "txHash": t["txHash"],
          "value": t["value"],
          "type": "SEND",
          "status": "CONFIRMED",
          "timestamp": t['timestamp']
        });
      }
      transfers.sort((a, b) => b["blockNumber"].compareTo(a["blockNumber"]));
      return {"count": transfers.length, "data": transfers};
    }
  }

  Future<dynamic> getTransferEvents({
    String foreignNetwork,
    String to,
  }) async {
    // String from,
    // String tokenAddress,
    // int fromBlockNumber,
    // int toBlockNumber
    Map<String, dynamic> variables = <String, dynamic>{
        'to': to,
        'skip': 0,
        'first': 20,
    };

    // 'from': from,
    // 'tokenAddress': tokenAddress,

    // if (fromBlockNumber != null) {
    //   variables['fromBlockNumber'] = fromBlockNumber;
    // }
    // if (toBlockNumber != null) {
    //   variables['toBlockNumber'] = toBlockNumber;
    // }

    GraphQLClient foreignClient = foreignNetwork == 'mainnet' ? _clientMainnet : _clientRopsten;
    foreignClient.cache.reset();
    QueryResult result = await foreignClient.query(QueryOptions(
      documentNode: gql(getTransferEventsQuery),
      variables: variables,
    ));
    if (result.hasException) {
      throw 'Error! Get Transfers events failed - accountAddress: $to ${result.exception}';
    } else {
      return result.data["transferEvents"];
    }
  }

  Future<dynamic> getAccountToken(String accountAddress, String tokenAddress) async {
    _clientTokenRegistry.cache.reset();
    QueryResult result = await _clientTokenRegistry.query(QueryOptions(
      documentNode: gql(getAccountTokenQuery),
      variables: <String, dynamic>{
        'accountAddress': accountAddress,
        'tokenAddress': tokenAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get account tokens request failed - walletAddress: $accountAddress ${result.exception}';
    } else {
      return result.data["accounts"];
    }
  }

  Future<dynamic> getAccountTokens(String accountAddress) async {
    _clientTokenRegistry.cache.reset();
    QueryResult result = await _clientTokenRegistry.query(QueryOptions(
      documentNode: gql(getAccountTokensQuery),
      variables: <String, dynamic>{
        'accountAddress': accountAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get account tokens request failed - walletAddress: $accountAddress ${result.exception}';
    } else {
      return result.data["accounts"];
    }
  }
}
