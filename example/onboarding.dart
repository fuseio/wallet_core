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
  String jwtToken =
      await api.loginVerify(phoneNumber, verificationCode, accountAddress);
  print('jwtToken: $jwtToken');

  // create wallet
  await api.createWallet();

  // get wallet
  dynamic wallet = await api.getWallet();
  print('wallet: $wallet');

  String walletAddress = wallet["walletAddress"];

  // init graph module
  Graph graph = new Graph();

  dynamic defaultCommunity = web3.getDefaultCommunity();
  // get default community details
  dynamic community = await graph.getCommunityByAddress(defaultCommunity);
  print('community: $community');

  // get default community token
  dynamic token = await graph.getTokenOfCommunity(defaultCommunity);
  print('token: $token');

  // check if member of default community
  bool isMember = await graph.isCommunityMember(
      walletAddress, community["entitiesList"]["address"]);
  print('isMember: $isMember');

  if (!isMember) {
    // join default community
    await api.joinCommunity(web3, walletAddress, defaultCommunity);
  }

  // get default community businesses
  dynamic businesses = await api.getBusinessList(web3.getDefaultCommunity());
  print('businesses: $businesses');

  String communityAddress = '0xc6Dae191309BB5efC1b15B96c68A197A0c600145';

  // get community details
  community =
      await graph.getCommunityByAddress(communityAddress);
  print('community: $community');

  // get community token
  token = await graph.getTokenOfCommunity(communityAddress);
  print('token: $token');

  // check if member of community
  isMember = await graph.isCommunityMember(
      walletAddress, community["entitiesList"]["address"]);
  print('isMember: $isMember');

  if (!isMember) {
    // join community
    await api.joinCommunity(web3, walletAddress, communityAddress);
  }

  // get community businesses
  businesses = await api.getBusinessList(communityAddress);
  print('businesses: $businesses');
}
