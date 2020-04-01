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

const String getTokenBalanceQuery = r'''
  query getTokenBalance($account: String!, $token: String!) {
      accounts(where:{address: $account}) {
        id
        tokens(where:{tokenAddress: $token}){
          balance
        }
      }
  }
''';

const String getReceivedTransfersQuery = r'''
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
        data
      }
  }
''';

const String getTransfersQuery = r'''
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
        data
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
        data
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
      }
  }
''';

const String getAccountTokensQuery = r'''
  query getAccountTokens($accountAddress: String!) {
    accounts (where:{address: $accountAddress}) {
      balances {
        amount
        token {
          name
          imageUrl
          symbol
          decimals
          address
        }
      }
    }
  }
''';

const String getAccountTokenQuery = r'''
  query getAccountToken($accountAddress: String!, $tokenAddress: String!) {
    accounts (where:{address: $accountAddress}) {
      balances (where: {token: $tokenAddress}){
        amount
        token {
          name
          imageUrl
          symbol
          decimals
          address
        }
      }
    }
  }
''';
