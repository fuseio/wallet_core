library graph;

import 'dart:async';

import 'package:graphql/client.dart';
import 'package:wallet_core/src/queries.dart';

const String BASE_URL = 'https://graph.fuse.io/subgraphs/name/fuseio';

class Graph {
  GraphQLClient _clientFuse;
  GraphQLClient _clientFuseEntities;
  GraphQLClient _clientFuseRopstenBridge;
  GraphQLClient _clientFuseMainnetBridge;

  Graph({
    String url = BASE_URL,
    String subGraph,
  }) {
    _clientFuse = GraphQLClient(
        link: HttpLink(uri: '$url/$subGraph'), cache: InMemoryCache());
    _clientFuseEntities = GraphQLClient(
        link: HttpLink(uri: '$url/fuse-entities'), cache: InMemoryCache());
    _clientFuseRopstenBridge = GraphQLClient(
        link: HttpLink(uri: '$url/fuse-ropsten-bridge'),
        cache: InMemoryCache());
    _clientFuseMainnetBridge = GraphQLClient(
        link: HttpLink(uri: '$url/fuse-ethereum-bridge'),
        cache: InMemoryCache());
  }

  Future<dynamic> getCommunityByAddress(String communityAddress) async {
    QueryResult result = await _clientFuseEntities.query(QueryOptions(
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
    QueryResult result = await _clientFuseEntities.query(QueryOptions(
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

  Future<dynamic> getHomeBridgedToken(
      String foreignTokenAddress, bool isRopsten) async {
    GraphQLClient client =
        isRopsten ? _clientFuseRopstenBridge : _clientFuseMainnetBridge;
    QueryResult result = await client.query(QueryOptions(
      documentNode: gql(getHomeBridgedTokenQuery),
      variables: <String, dynamic>{
        'foreignAddress': foreignTokenAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get home bridge token request failed - foreignTokenAddress: $foreignTokenAddress ${result.exception.clientException.message}';
    } else {
      return result.data["bridgedTokens"][0];
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
    _clientFuseEntities.cache.reset();
    QueryResult result = await _clientFuseEntities.query(QueryOptions(
      documentNode: gql(isCommunityMemberQuery),
      variables: <String, dynamic>{
        'address': accountAddress,
        'entitiesList': entitiesListAddress
      },
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
}
