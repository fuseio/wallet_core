library graph;

import 'dart:async';

import 'package:graphql/client.dart';
import 'package:wallet_core/src/queries.dart';

const String BASE_URL = 'https://graph.fuse.io/subgraphs/name/fuseio';

class Graph {
  late GraphQLClient _clientFuse;
  late GraphQLClient _clientFuseEntities;
  late GraphQLClient _clientFuseRopstenBridge;
  late GraphQLClient _clientFuseMainnetBridge;

  Graph({
    String url = BASE_URL,
    String? subGraph,
  }) {
    Uri uri = Uri.parse('$url/$subGraph');
    _clientFuse =
        GraphQLClient(link: HttpLink('$url/$subGraph'), cache: GraphQLCache());
    _clientFuseEntities = GraphQLClient(
        link: HttpLink('$url/fuse-entities'), cache: GraphQLCache());
    _clientFuseRopstenBridge = GraphQLClient(
        link: HttpLink('$url/fuse-ropsten-bridge'), cache: GraphQLCache());
    _clientFuseMainnetBridge = GraphQLClient(
        link: HttpLink('$url/fuse-ethereum-bridge'), cache: GraphQLCache());
  }

  Future<dynamic> getCommunityByAddress(String communityAddress) async {
    QueryResult result = await _clientFuseEntities.query(QueryOptions(
      document: gql(getCommunityByAddressQuery),
      variables: <String, dynamic>{
        'address': communityAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get community request failed - communityAddress: $communityAddress';
    } else {
      return result.data!["communities"][0];
    }
  }

  Future<dynamic> getCommunityBusinesses(String communityAddress) async {
    QueryResult result = await _clientFuseEntities.query(QueryOptions(
      document: gql(getCommunityBusinessesQuery),
      variables: <String, dynamic>{
        'address': communityAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get community businesses request failed - communityAddress: $communityAddress';
    } else {
      return result.data!["communities"][0]['entitiesList']['communityEntities'];
    }
  }

  Future<dynamic> getHomeBridgedToken(
      String foreignTokenAddress, bool isRopsten) async {
    GraphQLClient client =
        isRopsten ? _clientFuseRopstenBridge : _clientFuseMainnetBridge;
    QueryResult result = await client.query(QueryOptions(
      document: gql(getHomeBridgedTokenQuery),
      variables: <String, dynamic>{
        'foreignAddress': foreignTokenAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get home bridge token request failed - foreignTokenAddress: $foreignTokenAddress ${result.exception!.linkException!.originalException.message}';
    } else {
      return result.data!["bridgedTokens"][0];
    }
  }

  Future<dynamic> getTokenOfCommunity(String communityAddress) async {
    QueryResult result = await _clientFuse.query(QueryOptions(
      document: gql(getTokenOfCommunityQuery),
      variables: <String, dynamic>{
        'address': communityAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get token of community request failed - communityAddress: $communityAddress';
    } else {
      return result.data!["tokens"][0];
    }
  }

  Future<bool?> isCommunityMember(
      String accountAddress, String entitiesListAddress) async {
    _clientFuseEntities.cache.store.reset();
    QueryResult result = await _clientFuseEntities.query(QueryOptions(
      document: gql(isCommunityMemberQuery),
      variables: <String, dynamic>{
        'address': accountAddress,
        'entitiesList': entitiesListAddress
      },
    ));
    if (result.hasException) {
      throw 'Error! Is community member request failed - accountAddress: $accountAddress, entitiesListAddress: $entitiesListAddress';
    } else {
      return result.data!["communityEntities"].length > 0;
    }
  }

  Future<dynamic> getTokenByAddress(String tokenAddress) async {
    _clientFuse.cache.store.reset();
    QueryResult result = await _clientFuse.query(QueryOptions(
      document: gql(getTokenByAddressQuery),
      variables: <String, dynamic>{
        'address': tokenAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get token failed - for $tokenAddress ${result.exception}';
    } else {
      return result.data!['tokens'];
    }
  }
}
