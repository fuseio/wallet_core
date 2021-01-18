library graph;

import 'dart:async';

import 'package:graphql/client.dart';
import 'package:wallet_core/src/queries.dart';

class Graph {
  GraphQLClient _clientFuseEntities;
  GraphQLClient _clientFuseRopstenBridge;
  GraphQLClient _clientFuseMainnetBridge;

  Graph({
    String baseUrl,
  }) {
    _clientFuseEntities = GraphQLClient(
      link: HttpLink(uri: '$baseUrl/fuse-entities'),
      cache: InMemoryCache(),
    );

    _clientFuseRopstenBridge = GraphQLClient(
      link: HttpLink(uri: '$baseUrl/fuse-ropsten-bridge'),
      cache: InMemoryCache(),
    );

    _clientFuseMainnetBridge = GraphQLClient(
      link: HttpLink(uri: '$baseUrl/fuse-ethereum-bridge'),
      cache: InMemoryCache(),
    );
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
}
