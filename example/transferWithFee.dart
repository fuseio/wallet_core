import 'dart:async';

import 'package:wallet_core/wallet_core.dart';

Future<bool> approvalCallback() async {
  return true;
}

void main() async {
  // init web3 module
  Web3 web3 = new Web3(
    approvalCallback,
    url: 'https://mainnet.infura.io/v3/INFURA_API_KEY',
    networkId: 1,
    defaultCommunityAddress: 'DEFAULT_COMMUNITY_ADDRESS',
    communityManagerAddress: 'COMMUNITY_MANAGER_ADDRESS',
    transferManagerAddress: 'TRANSFER_MANAGER_ADDRESS',
    daiPointsManagerAddress: 'DAI_POINTS_MANAGER_ADDRESS',
    wrapperAddress: 'WRAPPER_ADDRESS'
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

  String walletAddress = 'YOUR_WALLET_ADDRESS';
  String tokenAddress = '0x6B175474E89094C44Da98b954EedeAC495271d0F'; // DAI
  String receiverAddress = 'RECEIVER_ADDRESS';
  String feeReceiverAddress = 'FEE_RECEIVER_ADDRESS';
  num tokenAmount = 1;
  num feeAmount = 0.5;

  dynamic result = await api.transferWithFee(web3,
    walletAddress,
    tokenAddress,
    receiverAddress,
    tokenAmount,
    feeReceiverAddress,
    feeAmount,
    network: 'mainnet'
  );
  print('result: $result');
}