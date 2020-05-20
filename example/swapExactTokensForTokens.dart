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

  String walletAddress = 'YOUR_WALLET_ADDRESS';
  String fromTokenAddress = '0x6B175474E89094C44Da98b954EedeAC495271d0F'; // DAI
  String toTokenAddress = '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48'; // USDC
  String receiverAddress = 'RECEIVER_ADDRESS';
  String uniswapRouterAddress = '0xf164fC0Ec4E93095b804a4795bBe1e041497b92a'; // UniswapV2Router01
  String wrappedEthAddress = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2'; // WETH
  num tokenAmountIn = 1;
  num tokenAmountOut = 0.9;
  DateTime deadlineTime = DateTime.now().add(new Duration(minutes: 15));
  int deadlineTimeInSecondsSinceEpoch = (deadlineTime.millisecondsSinceEpoch / 1000).round();

  EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
  EthereumAddress fromToken = EthereumAddress.fromHex(fromTokenAddress);
  EthereumAddress toToken = EthereumAddress.fromHex(toTokenAddress);
  EthereumAddress wETH = EthereumAddress.fromHex(wrappedEthAddress);
  Decimal tokensAmountInDecimal = Decimal.parse(tokenAmountIn.toString());
  Decimal tokensAmountOutDecimal = Decimal.parse(tokenAmountOut.toString());
  BigInt amountIn = BigInt.parse((tokensAmountInDecimal * Decimal.parse(pow(10, 18).toString())).toString());
  BigInt amountOut = BigInt.parse((tokensAmountOutDecimal * Decimal.parse(pow(10, 6).toString())).toString());
  BigInt deadline = BigInt.parse(deadlineTimeInSecondsSinceEpoch.toString());
  print('deadline: $deadline');

  String data = await web3.getEncodedDataForContractCall(
    'UniswapV2Router01',
    uniswapRouterAddress,
    'swapExactTokensForTokens',
    [amountIn, amountOut, [fromToken, wETH, toToken], receiver, deadline]
  );
  print('data: $data');

  dynamic result = await api.approveTokenAndCallContract(
    web3,
    walletAddress,
    fromTokenAddress,
    uniswapRouterAddress,
    tokenAmountIn,
    data,
    network: 'mainnet'
  );
  print('result: $result');
}