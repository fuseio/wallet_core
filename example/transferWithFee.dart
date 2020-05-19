import 'dart:async';
import 'dart:math';

import 'package:decimal/decimal.dart';
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

  api.setJwtToken('YOUR_JWT');

  String walletAddress = "YOUR_WALLET_ADDRESS";
  String wrapperAddress = '0xbA0e6955FfDA897d7DE5b3710517fB060559934E'; // Wrapper on Mainnet
  String tokenAddress = '0x6B175474E89094C44Da98b954EedeAC495271d0F'; // DAI
  String receiverAddress = 'RECEIVER_ADDRESS';
  String feeReceiverAddress = 'FEE_RECEIVER_ADDRESS';
  num tokenAmount = 0.1;
  num feeAmount = 0.05;
  num tokenDecimals = 18;

  EthereumAddress token = EthereumAddress.fromHex(tokenAddress);
  EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
  EthereumAddress feeReceiver = EthereumAddress.fromHex(feeReceiverAddress);
  Decimal tokenAmountDecimal = Decimal.parse(tokenAmount.toString());
  Decimal feeAmountDecimal = Decimal.parse(feeAmount.toString());
  Decimal decimals = Decimal.parse(pow(10, tokenDecimals).toString());
  BigInt amount = BigInt.parse((tokenAmountDecimal * decimals).toString());
  BigInt fee = BigInt.parse((feeAmountDecimal * decimals).toString());

  String data = await web3.getEncodedDataForContractCall(
    'Wrapper',
    wrapperAddress,
    'transferWithFee',
    [token, receiver, amount, feeReceiver, fee]
  );
  print('data: $data');

  dynamic result = await api.approveTokenAndCallContract(
    web3,
    walletAddress,
    tokenAddress,
    wrapperAddress,
    tokenAmount + feeAmount,
    data,
    network: 'mainnet'
  );
  print('result: $result');
}