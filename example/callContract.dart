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
    daiPointsManagerAddress: 'DAI_POINTS_MANAGER_ADDRESS'
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

  api.setJwtToken('YOUR_JWT_TOKEN');

  dynamic wallet = await api.getWallet();
  print('wallet: $wallet');

  String data = await web3.getEncodedDataForContractCall('Community', web3.getDefaultCommunity(), 'join', []);
  print('data: $data');

  dynamic result = await api.callContract(
    web3,
    wallet["walletAddress"],
    web3.getDefaultCommunity(),
    0,
    data
  );
  print('result: $result');
}