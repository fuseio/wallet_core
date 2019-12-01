library graph;

import 'dart:async';

import 'package:graphql/client.dart';
import 'package:wallet_core/src/web3.dart';

const String BASE_URL = 'https://graph.fuse.io/subgraphs/name/fuseio';

class Graph {
  GraphQLClient _clientFuse;
  GraphQLClient _clientRopsten;
  GraphQLClient _clientMainnet;

  Graph({String url}) {
    _clientFuse = GraphQLClient(link: HttpLink(uri: '${url ?? BASE_URL}/fuse-qa'), cache: InMemoryCache());
    _clientRopsten = GraphQLClient(link: HttpLink(uri: '${url ?? BASE_URL}/fuse-ropsten'), cache: InMemoryCache());
    _clientMainnet = GraphQLClient(link: HttpLink(uri: '${url ?? BASE_URL}/fuse-mainnet'), cache: InMemoryCache());
  }

  Future<dynamic> getCommunityByAddress({String communityAddress}) async {
    String community = communityAddress ?? Web3.getDefaultCommunity();

    QueryResult result = await _clientFuse.query(QueryOptions(
      document: r'''
      query getCommunityByAddress($address: String!) {
          communities(where:{address: $address}) {
            id
            address
            name
            entitiesList {
              address
            }
          }
      }
      ''',
      variables: <String, dynamic>{
        'address': community,
      },
    ));
    if (result.hasErrors) {
      throw 'Error! Get community request failed - communityAddress: $community';
    } else {
      return result.data["communities"][0];
    }
  }

  Future<dynamic> getTokenOfCommunity({String communityAddress}) async {
    String community = communityAddress ?? Web3.getDefaultCommunity();

    QueryResult result = await _clientFuse.query(QueryOptions(
      document: r'''
      query getTokenOfCommunity($address: String!) {
          tokens(where:{communityAddress: $address}) {
            id,
            symbol,
            name,
            address,
            decimals
          }
      }
      ''',
      variables: <String, dynamic>{
        'address': community,
      },
    ));
    if (result.hasErrors) {
      throw 'Error! Get token of community request failed - communityAddress: $community';
    } else {
      return result.data["tokens"][0];
    }
  }

  Future<bool> isCommunityMember(String accountAddress, String entitiesListAddress) async {
    String id = '${entitiesListAddress}_$accountAddress';

    QueryResult result = await _clientFuse.query(QueryOptions(
      document: r'''
      query getCommunityEntities($id: String!) {
          communityEntities(where:{id: $id}) {
            id
            address
            isAdmin
            isApproved
          }
      }
      ''',
      variables: <String, dynamic>{
        'id': id
      },
    ));
    if (result.hasErrors) {
      throw 'Error! Is community member request failed - accountAddress: $accountAddress, entitiesListAddress: $entitiesListAddress';
    } else {
      return result.data["communityEntities"].length > 0;
    }
  }

  Future<BigInt> getTokenBalance(String accountAddress, String tokenAddress) async {
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
      return BigInt.from(num.parse(result.data["accounts"][0]["tokens"][0]["balance"]));
    }
  }
}