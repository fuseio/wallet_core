library graph;

import 'dart:async';

import 'package:graphql/client.dart';

const String BASE_URL = 'https://graph.fuse.io/subgraphs/name/fuseio';
const String SUB_GRAPH = 'fuse-qa';

class Graph {
  GraphQLClient _clientFuse;
  GraphQLClient _clientRopsten;
  GraphQLClient _clientMainnet;

  Graph({String url, String subGraph}) {
    _clientFuse = GraphQLClient(
        link: HttpLink(uri: '${url ?? BASE_URL}/${subGraph ?? SUB_GRAPH}'),
        cache: InMemoryCache());
    _clientRopsten = GraphQLClient(
        link: HttpLink(uri: '${url ?? BASE_URL}/fuse-ropsten'),
        cache: InMemoryCache());
    _clientMainnet = GraphQLClient(
        link: HttpLink(uri: '${url ?? BASE_URL}/fuse-mainnet'),
        cache: InMemoryCache());
  }

  Future<dynamic> getCommunityByAddress(String communityAddress) async {

    QueryResult result = await _clientFuse.query(QueryOptions(
      document: r'''
      query getCommunityByAddress($address: String!) {
          communities(where:{address: $address}) {
            id
            address
            name
            entitiesList {
              address
              communityEntities {
                address
                isAdmin
                isApproved
                isUser
                isBusiness
              }
            }
          }
      }
      ''',
      variables: <String, dynamic>{
        'address': communityAddress,
      },
    ));
    if (result.hasErrors) {
      throw 'Error! Get community request failed - communityAddress: $communityAddress';
    } else {
      return result.data["communities"][0];
    }
  }

  Future<dynamic> getCommunityBusinesses(String communityAddress) async {

    QueryResult result = await _clientFuse.query(QueryOptions(
      document: r'''
      query getCommunityBusinesses($address: String!) {
          communities(where:{address: $address}) {
            entitiesList {
              communityEntities(where:{isBusiness: true}) {
                address
                isAdmin
                isApproved
                isBusiness
              }
            }
          }
      }
      ''',
      variables: <String, dynamic>{
        'address': communityAddress,
      },
    ));
    if (result.hasErrors) {
      throw 'Error! Get community businesses request failed - communityAddress: $communityAddress';
    } else {
      return result.data["communities"][0]['entitiesList']['communityEntities'];
    }
  }

  Future<dynamic> getTokenOfCommunity(String communityAddress) async {

    QueryResult result = await _clientFuse.query(QueryOptions(
      document: r'''
      query getTokenOfCommunity($address: String!) {
          tokens(where:{communityAddress: $address}) {
            id,
            symbol,
            name,
            address,
            decimals,
            originNetwork
          }
      }
      ''',
      variables: <String, dynamic>{
        'address': communityAddress,
      },
    ));
    if (result.hasErrors) {
      throw 'Error! Get token of community request failed - communityAddress: $communityAddress';
    } else {
      return result.data["tokens"][0];
    }
  }

  Future<bool> isCommunityMember(
      String accountAddress, String entitiesListAddress) async {
    _clientFuse.cache.reset();
    QueryResult result = await _clientFuse.query(QueryOptions(
      document: r'''
      query getCommunityEntities($address: String!, $entitiesList: String!) {
          communityEntities(where:{address: $address, entitiesList: $entitiesList}) {
            id
            address
            isAdmin
            isApproved
          }
      }
      ''',
      variables: <String, dynamic>{'address': accountAddress, 'entitiesList': entitiesListAddress},
    ));
    if (result.hasErrors) {
      throw 'Error! Is community member request failed - accountAddress: $accountAddress, entitiesListAddress: $entitiesListAddress';
    } else {
      return result.data["communityEntities"].length > 0;
    }
  }

  Future<BigInt> getTokenBalance(
      String accountAddress, String tokenAddress) async {
    _clientFuse.cache.reset();
    QueryResult result = await _clientFuse.query(QueryOptions(
      document: r'''
      query getTokenBalance($account: String!, $token: String!) {
          accounts(where:{address: $account}) {
            id
            tokens(where:{tokenAddress: $token}){
              balance
            }
          }
      }
      ''',
      variables: <String, dynamic>{
        'account': accountAddress,
        'token': tokenAddress
      },
    ));
    if (result.hasErrors) {
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
      document: r'''
      query getTransfers($account: String!, $token: String!, $fromBlockNumber: Int, $toBlockNumber: Int) {
          transfersIn: transferEvents(orderBy: blockNumber, orderDirection: desc, first: $n, where: {
            tokenAddress: $token,
            to: $account,
            blockNumber_gt: $fromBlockNumber,
            blockNumber_lt: $toBlockNumber
          }) {
            id,
            blockNumber,
            txHash,
            tokenAddress,
            from,
            to,
            value,
            data,
            timestamp
          }
      }
      ''',
      variables: variables,
    ));
    if (result.hasErrors) {
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
      document: r'''
      query getTransfers($account: String!, $token: String!, $fromBlockNumber: Int, $toBlockNumber: Int) {
          transfersIn: transferEvents(orderBy: blockNumber, orderDirection: desc, first: $n, where: {
            tokenAddress: $token,
            to: $account,
            blockNumber_gt: $fromBlockNumber,
            blockNumber_lt: $toBlockNumber
          }) {
            id,
            blockNumber,
            txHash,
            tokenAddress,
            from,
            to,
            value,
            data,
            timestamp
          }

          transfersOut: transferEvents(orderBy: blockNumber, orderDirection: desc, first: $n, where: {
            tokenAddress: $token,
            from: $account,
            blockNumber_gt: $fromBlockNumber,
            blockNumber_lt: $toBlockNumber
          }) {
            id,
            blockNumber,
            txHash,
            tokenAddress,
            from,
            to,
            value,
            data,
            timestamp
          }
      }
      ''',
      variables: variables,
    ));
    if (result.hasErrors) {
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
}
