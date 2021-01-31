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
