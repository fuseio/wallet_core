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
  String contractAddress = '0x782c578B5BC3b9A1B6E1E54f839B610Ac7036bA0'; // DAIPoints
  String receiverAddress = 'RECEIVER_ADDRESS';
  String feeReceiverAddress = 'FEE_RECEIVER_ADDRESS';
  num tokenAmount = 1;
  num feeAmount = 0.5;
  num tokenDecimals = 18;

  EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
  Decimal tokenAmountDecimal = Decimal.parse(tokenAmount.toString());
  Decimal decimals = Decimal.parse(pow(10, tokenDecimals).toString());
  BigInt amount = BigInt.parse((tokenAmountDecimal * decimals).toString());

  String getDAIPointsToAddressData = await web3.getEncodedDataForContractCall(
    'DAIPointsToken',
    contractAddress,
    'getDAIPointsToAddress',
    [amount, receiver]
  );
  print('getDAIPointsToAddressData: $getDAIPointsToAddressData');

  dynamic result = await api.transferAndCallWithFee(web3,
    walletAddress,
    tokenAddress,
    contractAddress,
    tokenAmount,
    feeReceiverAddress,
    feeAmount,
    getDAIPointsToAddressData,
    network: 'mainnet'
  );
  print('result: $result');
}