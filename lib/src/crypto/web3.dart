import 'dart:async';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class Web3 {

  Web3Client _client;
  Future<bool> _approveCb;
  Credentials _credentials;
  int _networkId;

  Web3(String url, int networkId, Future<bool> approveCb()) {
    _client = new Web3Client(url, new Client());
    _approveCb = approveCb();
    _networkId = networkId;
  }

  Future<void> setCredentials(String pkey) async {
    _credentials = await _client.credentialsFromPrivateKey(pkey);
  }

  Future<String> sendTransactionAndWaitForReceipt(Transaction transaction) async {
    print('sendTransactionAndWaitForReceipt');    
    String txHash = await _client.sendTransaction(_credentials, transaction, chainId: _networkId);
    TransactionReceipt receipt = await _client.getTransactionReceipt(txHash);
    num delay = 1;
    num retries = 5;
    while(receipt == null) {
      print('waiting for receipt');
      await Future.delayed(new Duration(seconds: delay));
      delay*=2;
      retries--;
      if (retries == 0) {
        throw 'transaction $txHash not mined...';
      }
      try {
        receipt = await _client.getTransactionReceipt(txHash);
      } catch (err) {
        print('could not get $txHash receipt, try again');
      }
      
    }
    return txHash;
  }

  Future<String> transferNative(String _receiver, num _amountInWei) async {
    print('transferNative --> receiver: $_receiver, amountInWei: $_amountInWei');

    bool isApproved = await _approveCb;
    if (!isApproved) {
      throw 'transaction not approved';
    }

    EthereumAddress receiver = EthereumAddress.fromHex(_receiver);
    EtherAmount amount = EtherAmount.fromUnitAndValue(EtherUnit.wei, BigInt.from(_amountInWei));

    String txHash = await sendTransactionAndWaitForReceipt(Transaction(
      to: receiver,
      value: amount
    ));
    print('transction $txHash successful');
    return txHash;
  }

  Future<EthereumAddress> getAddress() async {
    return _credentials.extractAddress();
  }

  Future<EtherAmount> getBalance() async {
    EthereumAddress address = await getAddress();
    return _client.getBalance(address);
  }
}