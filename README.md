# wallet_core

### onboarding
```
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:wallet_core/wallet_core.dart';

const String RPC_ENDPOINT = 'https://rpc.fusenet.io';
const num NETWORK_ID = 122;
const String API_BASE_URL = 'https://studio-qa-ropsten.fusenet.io/api/v2';

Future<bool> approvalCallback() async {
  return true;
}

void main() async {
  // init web3 module
  Web3 web3 = new Web3(RPC_ENDPOINT, NETWORK_ID, approvalCallback);
  
  // generate mnemonic
  String mnemonic = web3.generateMnemonic();
  print('mnemonic: $mnemonic');
  
  // get private key from mnemonic
  String privateKey = web3.privateKeyFromMnemonic(mnemonic);
  print('privateKey: $privateKey');
  
  // set web3 credentials with private key
  await web3.setCredentials(privateKey);
  
  // get account address
  String accountAddress = await web3.getAddress();
  print('account address: $accountAddress');

  // init api module
  API api = new API(API_BASE_URL);
  
  // login
  print('enter phone number and press ENTER');
  String phoneNumber = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
  await api.loginRequest(phoneNumber);
  
  // verify
  print('enter sms verification code and press ENTER');
  String verificationCode = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
  String jwtToken = await api.loginVerify(phoneNumber, verificationCode);
  print('jwtToken: $jwtToken');
  
  // create wallet
  await api.createWallet(accountAddress);
  
  // get wallet
  dynamic wallet = await api.getWallet();
  print('wallet: $wallet');
}
```

### native
```
import 'dart:async';

import 'package:wallet_core/wallet_core.dart';

const String RPC_ENDPOINT = 'https://rpc.fusenet.io';
const num NETWORK_ID = 122;

Future<bool> approvalCallback() async {
  return true;
}

void main() async {
  // init web3 module
  Web3 web3 = new Web3(RPC_ENDPOINT, NETWORK_ID, approvalCallback);
  
  String privateKey = '...';
  
  // set web3 credentials with private key
  await web3.setCredentials(privateKey);

  // get address
  String address = await web3.getAddress();
  print('address: $address');

  // get balance before transfer
  EtherAmount balance = await web3.getBalance();
  print('balance before transaction: ${balance.getInWei} wei (${balance.getValueInUnit(EtherUnit.ether)} ether)');
  
  // transfer 0.1 ETH to another address
  String receiver = '0xF3a4C2862188781365966A040B1f47b9614b2DC7';
  num amount = 1e17;
  String txHash = await web3.transfer(receiver, amount);
  print('transction $txHash successful');

  // get balance after transfer
  balance = await web3.getBalance();
  print('balance after transaction: ${balance.getInWei} wei (${balance.getValueInUnit(EtherUnit.ether)} ether)');
}
```

### tokens
```
import 'dart:async';
import 'dart:math';

import 'package:wallet_core/wallet_core.dart';

const String RPC_ENDPOINT = 'https://rpc.fusenet.io';
const num NETWORK_ID = 122;

Future<bool> approvalCallback() async {
  return true;
}

void main() async {
  // init web3 module
  Web3 web3 = new Web3(RPC_ENDPOINT, NETWORK_ID, approvalCallback);
  
  String privateKey = '...';
  
  // set web3 credentials with private key
  await web3.setCredentials(privateKey);

  // get address
  String address = await web3.getAddress();
  print('address: $address');
  
  String tokenAddress = '0x0F99E2090D1511e0f2474A56141D9fAB952C19e2';
  String receiverAddress = '0xF3a4C2862188781365966A040B1f47b9614b2DC7';

  // get token details
  dynamic tokenDetails = await web3.getTokenDetails(tokenAddress);
  print('token details: $tokenDetails');

  String tokenName = tokenDetails["name"];
  String tokenSymbol = tokenDetails["symbol"];
  dynamic tokenDecimals = int.parse(tokenDetails["decimals"].toString());
  tokenDecimals = BigInt.from(pow(10, tokenDecimals));

  // get own token balance before transfer
  dynamic tokenBalance = await web3.getTokenBalance(tokenAddress);
  tokenBalance = (tokenBalance / tokenDecimals).toStringAsFixed(2);
  print('$address has $tokenBalance $tokenName($tokenSymbol) tokens before transfer');

  // get receiver token balance before transfer
  tokenBalance = await web3.getTokenBalance(tokenAddress, address: receiverAddress);
  tokenBalance = (tokenBalance / tokenDecimals).toStringAsFixed(2);
  print('$receiverAddress has $tokenBalance $tokenName($tokenSymbol) tokens before transfer');

  // transfer tokens
  String txHash = await web3.tokenTransfer(tokenAddress, receiverAddress, 2.5);
  print('transction $txHash successful');

  // get own token balance after transfer
  tokenBalance = await web3.getTokenBalance(tokenAddress);
  tokenBalance = (tokenBalance / tokenDecimals).toStringAsFixed(2);
  print('$address has $tokenBalance $tokenName($tokenSymbol) tokens after transfer');

  // get receiver token balance after transfer
  tokenBalance = await web3.getTokenBalance(tokenAddress, address: receiverAddress);
  tokenBalance = (tokenBalance / tokenDecimals).toStringAsFixed(2);
  print('$receiverAddress has $tokenBalance $tokenName($tokenSymbol) tokens after transfer');
}
```