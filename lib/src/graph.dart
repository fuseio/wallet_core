library graph;

import 'dart:async';
import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:wallet_core/src/queries.dart';

class Graph {
  late final GraphQLClient _clientNFT;

  Graph(
    String baseUrl,
    String nftSubgraph,
  ) {
    _clientNFT = GraphQLClient(
      link: HttpLink(nftSubgraph),
      cache: GraphQLCache(),
    );
  }

  Future<dynamic> getCollectiblesByOwner(String owner) async {
    QueryResult result = await _clientNFT.query(QueryOptions(
      document: parseString(getCollectiblesByOwnerQuery),
      fetchPolicy: FetchPolicy.networkOnly,
      cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
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
}
