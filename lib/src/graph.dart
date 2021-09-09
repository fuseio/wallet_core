library graph;

import 'dart:async';
import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:wallet_core/src/queries.dart';

class Graph {
  late final GraphQLClient _clientFuseEntities;
  late final GraphQLClient _clientFuseRopstenBridge;
  late final GraphQLClient _clientFuseMainnetBridge;
  late final GraphQLClient _clientNFT;

  Graph(
    String baseUrl,
    String nftSubgraph,
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

    _clientNFT = GraphQLClient(
      link: HttpLink(nftSubgraph),
      cache: GraphQLCache(),
    );
  }

  Future<dynamic> getCollectiblesByOwner(String owner) async {
    QueryResult result = await _clientNFT.query(QueryOptions(
      document: parseString(getCollectiblesByOwnerQuery),
      variables: <String, dynamic>{
        'owner': owner.toLowerCase(),
      },
    ));
    if (result.hasException) {
      throw 'Error! Get Collectibles By Owner request failed - owner: $owner ${result.exception.toString()}';
    } else {
      return result.data?["collectibles"];
    }
  }

  Future<dynamic> getCommunityByAddress(String communityAddress) async {
    QueryResult result = await _clientFuseEntities.query(QueryOptions(
      document: parseString(getCommunityByAddressQuery),
      variables: <String, dynamic>{
        'address': communityAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get community request failed - communityAddress: $communityAddress ${result.exception.toString()}';
    } else {
      return result.data?["communities"][0];
    }
  }

  Future<dynamic> getCommunityBusinesses(String communityAddress) async {
    QueryResult result = await _clientFuseEntities.query(QueryOptions(
      document: parseString(getCommunityBusinessesQuery),
      variables: <String, dynamic>{
        'address': communityAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get community businesses request failed - communityAddress: $communityAddress ${result.exception.toString()}';
    } else {
      return result.data?["communities"][0]['entitiesList']
          ['communityEntities'];
    }
  }

  Future<dynamic> getHomeBridgedToken(
    String foreignTokenAddress,
    bool isRopsten,
  ) async {
    GraphQLClient client =
        isRopsten ? _clientFuseRopstenBridge : _clientFuseMainnetBridge;
    QueryResult result = await client.query(QueryOptions(
      document: parseString(getHomeBridgedTokenQuery),
      variables: <String, dynamic>{
        'foreignAddress': foreignTokenAddress,
      },
    ));
    if (result.hasException) {
      throw 'Error! Get home bridge token request failed - foreignTokenAddress: $foreignTokenAddress ${result.exception.toString()}';
    } else {
      return result.data?["bridgedTokens"][0];
    }
  }

  Future<bool> isCommunityMember(
    String accountAddress,
    String entitiesListAddress,
  ) async {
    QueryResult result = await _clientFuseEntities.query(QueryOptions(
      document: parseString(isCommunityMemberQuery),
      variables: <String, dynamic>{
        'address': accountAddress,
        'entitiesList': entitiesListAddress
      },
    ));
    if (result.hasException) {
      throw 'Error! Is community member request failed - accountAddress: $accountAddress, entitiesListAddress: $entitiesListAddress ${result.exception.toString()}';
    } else {
      return result.data?["communityEntities"].length > 0;
    }
  }
}
