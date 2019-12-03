import 'dart:async';
import 'dart:convert';
import 'dart:core' as prefix0;
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:wallet_core/wallet_core.dart';

Future<bool> approvalCallback() async {
  return true;
}


void main() async {
  // init web3 module
  Web3 web3 = new Web3(approvalCallback);

  print('enter private key and press ENTER');
  // String privateKey = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
  String privateKey = 'PK';
  // set web3 credentials with private key
  await web3.setCredentials(privateKey);

  // print('enter wallet address and press ENTER');
  // String walletAddress =
  //   stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
  String walletAddress = '0x054107D3836b03e91075613A841787B48D87b48A';
  String communityAddress = '0x5335373d3D02ac0FcE38795A62db3313F4F2a5D3';
  Uint8List methodData = Uint8List.fromList([]);

  BigInt amountInWei = BigInt.from(0);
  BigInt nonce = BigInt.from(0);
  BigInt gasPrice = BigInt.from(0);
  BigInt gasLimit = BigInt.from(7000000);

  Uint8List sig = await web3.signOffChain(communityAddress, amountInWei, methodData, nonce, gasPrice, gasLimit);
  print(sig);

  API api = new API();
  await api.relay(sig, walletAddress, methodData, nonce, gasPrice, gasLimit);
}

