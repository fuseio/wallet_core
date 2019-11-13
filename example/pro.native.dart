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

  print('enter private key and press ENTER');
  String privateKey = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));

  // set web3 credentials with private key
  await web3.setCredentials(privateKey);

  // get address
  String address = await web3.getAddress();
  print('address: $address');

  // get balance before transfer
  EtherAmount balance = await web3.getBalance();
  print(
      'balance before transaction: ${balance.getInWei} wei (${balance.getValueInUnit(EtherUnit.ether)} ether)');

  // transfer 0.1 ETH to another address
  String receiverAddress = '0xF3a4C2862188781365966A040B1f47b9614b2DC7';
  num amount = 1e17;
  String txHash = await web3.transfer(receiverAddress, amount);
  print('transction $txHash successful');

  // get balance after transfer
  balance = await web3.getBalance();
  print(
      'balance after transaction: ${balance.getInWei} wei (${balance.getValueInUnit(EtherUnit.ether)} ether)');
}
