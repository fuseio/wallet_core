library graph;

import 'dart:async';

import 'package:graphql/client.dart';
import 'package:wallet_core/src/queries.dart';

class Graph {
  late final GraphQLClient _clientFuseEntities;
  late final GraphQLClient _clientFuseRopstenBridge;
  late final GraphQLClient _clientFuseMainnetBridge;

  Graph(
    String baseUrl,
  ) {
    _clientFuseEntities = GraphQLClient(
      link: HttpLink('$baseUrl/fuse-entities'),
      cache: GraphQLCache(),
    );

    _clientFuseRopstenBridge = GraphQLClient(
      link: HttpLink('$baseUrl/fuse-ropsten-bridge'),
      cache: GraphQLCache(),
    );

    _clientFuseMainnetBridge = GraphQLClient(
      link: HttpLink('$baseUrl/fuse-ethereum-bridge'),
      cache: GraphQLCache(),
    );
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
      return result.data["communities"][0];
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
      return result.data["communities"][0]['entitiesList']['communityEntities'];
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
      throw 'Error! Get home bridge token request failed - foreignTokenAddress: $foreignTokenAddress ${result.exception.toString()}';
    } else {
      return result.data["bridgedTokens"][0];
    }
  }

  Future<bool> isCommunityMember(
      String accountAddress, String entitiesListAddress) async {
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
      return result.data["communityEntities"].length > 0;
    }
  }
}
