import 'dart:async';
import 'dart:convert';
import 'dart:core' as prefix0;
import 'dart:core';
import 'dart:io';

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

  print('enter community address and press ENTER');
  String communityAddress =
    stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
  
  API api = API();
  api.joinCommunity(web3, walletAddress, communityAddress);
}

