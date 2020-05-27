import 'dart:async';

import 'package:wallet_core/wallet_core.dart';

Future<bool> approvalCallback() async {
  return true;
}

void main() async {
  // init web3 module
  Web3 web3 = new Web3(
    approvalCallback,
    defaultCommunityAddress: 'DEFAULT_COMMUNITY_ADDRESS',
    communityManagerAddress: 'COMMUNITY_MANAGER_ADDRESS',
    transferManagerAddress: 'TRANSFER_MANAGER_ADDRESS',
    daiPointsManagerAddress: 'DAI_POINTS_MANAGER_ADDRESS',
    url: 'https://mainnet.infura.io/v3/INFURA_API_KEY',
    networkId: 1
  );

  // set web3 credentials with private key
  await web3.setCredentials('YOUR_PRIVATE_KEY');

  // get account address
  String accountAddress = await web3.getAddress();
  print('account address: $accountAddress');

  // init api module
  API api = new API(
    base: 'https://studio.fuse.io/api',
    funderBase: 'https://funder.fuse.io/api'
  );

  api.setJwtToken('YOUR_JWT');

  /*
  curl -X POST \
    https://api.totle.com/swap \
    -H 'content-type: Application/JSON' \
    -d '{ 
    "address": "YOUR_WALLET_ADDRESS",
    "config": {
      "transactions": true
    },
    "swap":{ 
        "sourceAsset":"DAI",
        "destinationAsset":"USDC",
        "sourceAmount":"500000000000000000"
    }
  }'
  */

  String walletAddress = 'YOUR_WALLET_ADDRESS';
  String tokenAddress = '0x6B175474E89094C44Da98b954EedeAC495271d0F'; // DAI
  num tokensAmount = 0.01; // DAI
  String approvalContractAddress = '0x74758AcFcE059f503a7E6B0fC2c8737600f9F2c4'; // TokenTransferProxy
  String swapContractAddress = 'SWAP_TX_ADDRESS_FROM_RESPONSE';
  String swapData = 'SWAP_TX_DATA_FROM_RESPONSE';

  dynamic result = await api.totleSwap(
    web3,
    walletAddress,
    tokenAddress,
    tokensAmount,
    approvalContractAddress, 
    swapContractAddress,
    swapData,
    network: 'mainnet'
  );
  print('result: $result');
}