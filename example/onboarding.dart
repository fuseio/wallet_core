import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:wallet_core/wallet_core.dart';

Future<bool> approvalCallback() async {
  return true;
}

void main() async {
  // generate mnemonic
  String mnemonic = Web3.generateMnemonic();
  print('mnemonic: $mnemonic');

  // get private key from mnemonic
  String privateKey = Web3.privateKeyFromMnemonic(mnemonic);
  print('privateKey: $privateKey');

  // init web3 module
  Web3 web3 = new Web3(approvalCallback);

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

  String walletAddress = wallet["walletAddress"];

  // get default community details
  dynamic community = await api.getCommunity();
  print('community: $community');

  // join default community
  await web3.joinCommunity(walletAddress);

  String communityAddress = '0xd4751Ad16b44410990a767E7c2A7bF0aF17f7d85';

  // get community details
  community = await api.getCommunity(communityAddress: communityAddress);
  print('community: $community');

  // join community
  await web3.joinCommunity(walletAddress, communityAddress: communityAddress);
}
