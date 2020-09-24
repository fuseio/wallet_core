const String getHomeBridgedTokenQuery = r'''
  query getBridgedToken($foreignAddress: String!) {
      bridgedTokens(where: {foreignAddress: $foreignAddress}) {
        address
        name
        decimals
        symbol
        foreignAddress
      }
  }
''';

const String getTokenByAddressQuery = r'''
  query getTokenByAddress($address: String!) {
      tokens(where: {address: $address}) {
        name
        decimals
        symbol
        address
        totalSupply
        originNetwork
      }
  }
''';

const String getCommunityByAddressQuery = r'''
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
''';

const String getCommunityBusinessesQuery = r'''
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
''';

const String getTokenOfCommunityQuery = r'''
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
''';

const String isCommunityMemberQuery = r'''
  query getCommunityEntities($address: String!, $entitiesList: String!) {
      communityEntities(where:{address: $address, entitiesList: $entitiesList}) {
        id
        address
        isAdmin
        isApproved
      }
  }
''';

const String getTransferEventsQuery = r'''
  query getTransferEvents(
    $to: String!,
    $skip: Int,
    $first: Int,
  ) {
    transferEvents(where: {
        to: $to,
    }, skip: $skip, first: $first) {
        id
        from
        to
        value
        blockNumber
        txHash
        tokenAddress
        timestamp
      }
  }
''';
