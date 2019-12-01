import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:wallet_core/wallet_core.dart';

Future<bool> approvalCallback() async {
  return true;
}

void main() async {
  // init web3 module
  Web3 web3 = new Web3(approvalCallback);

  print('enter private key and press ENTER');
  String privateKey = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));

  // set web3 credentials with private key
  await web3.setCredentials(privateKey);

  print('enter wallet address and press ENTER');
  String walletAddress =
      stdin.readLineSync(encoding: Encoding.getByName('utf-8'));

  String tokenAddress = '0x0F99E2090D1511e0f2474A56141D9fAB952C19e2';
  String receiverAddress = '0xF3a4C2862188781365966A040B1f47b9614b2DC7';

  // get token details
  dynamic tokenDetails = await web3.getTokenDetails(tokenAddress);
  print('token details: $tokenDetails');

  String tokenName = tokenDetails["name"];
  String tokenSymbol = tokenDetails["symbol"];
  dynamic tokenDecimals = int.parse(tokenDetails["decimals"].toString());
  tokenDecimals = BigInt.from(pow(10, tokenDecimals));

  // init graph module
  Graph graph = new Graph();

  // get own token balance before transfer
  dynamic tokenBalance =
      await graph.getTokenBalance(walletAddress, tokenAddress);
  tokenBalance = (tokenBalance / tokenDecimals).toStringAsFixed(2);
  print(
      '$walletAddress has $tokenBalance $tokenName($tokenSymbol) tokens before transfer');

  // get receiver token balance before transfer
  tokenBalance =
      await graph.getTokenBalance(receiverAddress, tokenAddress);
  tokenBalance = (tokenBalance / tokenDecimals).toStringAsFixed(2);
  print(
      '$receiverAddress has $tokenBalance $tokenName($tokenSymbol) tokens before transfer');

  // transfer tokens
  String txHash = await web3.cashTokenTransfer(
      walletAddress, tokenAddress, receiverAddress, 2.5);
  print('transction $txHash successful');

  // get own token balance after transfer
  tokenBalance = await graph.getTokenBalance(walletAddress, tokenAddress);
  tokenBalance = (tokenBalance / tokenDecimals).toStringAsFixed(2);
  print(
      '$walletAddress has $tokenBalance $tokenName($tokenSymbol) tokens after transfer');

  // get receiver token balance after transfer
  tokenBalance =
      await graph.getTokenBalance(receiverAddress, tokenAddress);
  tokenBalance = (tokenBalance / tokenDecimals).toStringAsFixed(2);
  print(
      '$receiverAddress has $tokenBalance $tokenName($tokenSymbol) tokens after transfer');

  // get token transfers
  Map<String, dynamic> transfers = await graph.getTransfers(walletAddress, tokenAddress);
  print('Found ${transfers["count"]} transfers for $walletAddress on $tokenSymbol token: ${transfers["data"]}');
}
