import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:wallet_core/wallet_core.dart';

Future<bool> approvalCallback() async {
  return true;
}

void main() async {
  // init web3 module
  Web3 web3 = new Web3(approvalCallback);

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
  API api = new API();

  // login
  print('enter phone number and press ENTER');
  String phoneNumber =
      stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
  await api.loginRequest(phoneNumber);

  // verify
  print('enter sms verification code and press ENTER');
  String verificationCode =
      stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
  String jwtToken = await api.loginVerify(phoneNumber, verificationCode);
  print('jwtToken: $jwtToken');

  // create wallet
  await api.createWallet(accountAddress);

  // get wallet
  dynamic wallet = await api.getWallet();
  print('wallet: $wallet');

  // join default community
  await web3.joinCommunity(wallet["walletAddress"]);

  // join community
  String communityAddress = '0xd4751Ad16b44410990a767E7c2A7bF0aF17f7d85';
  await web3.joinCommunity(wallet["walletAddress"],
      communityAddress: communityAddress);
}
