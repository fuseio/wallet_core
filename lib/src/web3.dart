library web3;

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:decimal/decimal.dart';
import './abi.dart';
import './utils.dart';

const String RPC_URL = 'https://rpc.fuse.io';
const int NETWORK_ID = 122;

const int DEFAULT_GAS_LIMIT = 700000;

const String NATIVE_TOKEN_ADDRESS =
    '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE'; // For sending native (ETH/FUSE) using TransferManager
const String DEFAULT_COMMUNITY_CONTRACT_ADDRESS =
    '0xbA01716EAD7989a00cC3b2AE6802b54eaF40fb72';
const String COMMUNITY_MANAGER_CONTRACT_ADDRESS =
    '0xE47204f722F1B0a1113C1fBAd772626A9621E61E';
const String TRANSFER_MANAGER_CONTRACT_ADDRESS =
    '0x5472F98b5A043F115eD5079810c0e8dc54304736';

class Web3 {
  Web3Client _client;
  Future<bool> _approveCb;
  Credentials _credentials;
  int _networkId;
  String _defaultCommunityContractAddress;
  String _communityManagerContractAddress;
  String _transferManagerContractAddress;
  int _defaultGasLimit;

  Web3(Future<bool> approveCb(), {
    String url,
    int networkId,
    String defaultCommunityAddress,
    String communityManagerAddress,
    String transferManagerAddress,
    int defaultGasLimit
  }) {
    _client = new Web3Client(url ?? RPC_URL, new Client());
    _approveCb = approveCb();
    _networkId = networkId ?? NETWORK_ID;
    _defaultCommunityContractAddress = defaultCommunityAddress ?? DEFAULT_COMMUNITY_CONTRACT_ADDRESS;
    _communityManagerContractAddress = communityManagerAddress ?? COMMUNITY_MANAGER_CONTRACT_ADDRESS;
    _transferManagerContractAddress = transferManagerAddress ?? TRANSFER_MANAGER_CONTRACT_ADDRESS;
    _defaultGasLimit = defaultGasLimit ?? DEFAULT_GAS_LIMIT;
  }

  static String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  static String privateKeyFromMnemonic(String mnemonic) {
    String seed = bip39.mnemonicToSeedHex(mnemonic);
    bip32.BIP32 root = bip32.BIP32.fromSeed(HEX.decode(seed));
    bip32.BIP32 child = root.derivePath("m/44'/60'/0'/0/0");
    String privateKey = HEX.encode(child.privateKey);
    return privateKey;
  }

  Future<void> setCredentials(String privateKey) async {
    _credentials = await _client.credentialsFromPrivateKey(privateKey);
  }

  Future<String> getAddress() async {
    return (await _credentials.extractAddress()).toString();
  }

  Future<int> getBlockNumber() async {
    return _client.getBlockNumber();
  }

  Future<String> _sendTransactionAndWaitForReceipt(
      Transaction transaction) async {
    print('sendTransactionAndWaitForReceipt');
    String txHash = await _client.sendTransaction(_credentials, transaction,
        chainId: _networkId);
    TransactionReceipt receipt;
    try {
      receipt = await _client.getTransactionReceipt(txHash);
    } catch (err) {
      print('could not get $txHash receipt, try again');
    }
    int delay = 1;
    int retries = 10;
    while (receipt == null) {
      print('waiting for receipt');
      await Future.delayed(new Duration(seconds: delay));
      delay *= 2;
      retries--;
      if (retries == 0) {
        throw 'transaction $txHash not mined yet...';
      }
      try {
        receipt = await _client.getTransactionReceipt(txHash);
      } catch (err) {
        print('could not get $txHash receipt, try again');
      }
    }
    return txHash;
  }

  Future<EtherAmount> getBalance({String address}) async {
    EthereumAddress a;
    if (address != null && address != "") {
      a = EthereumAddress.fromHex(address);
    } else {
      a = EthereumAddress.fromHex(await getAddress());
    }
    return await _client.getBalance(a);
  }

  Future<String> transfer(String receiverAddress, int amountInWei) async {
    print('transfer --> receiver: $receiverAddress, amountInWei: $amountInWei');

    bool isApproved = await _approveCb;
    if (!isApproved) {
      throw 'transaction not approved';
    }

    EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
    EtherAmount amount =
        EtherAmount.fromUnitAndValue(EtherUnit.wei, BigInt.from(amountInWei));

    String txHash = await _sendTransactionAndWaitForReceipt(
        Transaction(to: receiver, value: amount));
    print('transction $txHash successful');
    return txHash;
  }

  Future<DeployedContract> _contract(
      String contractName, String contractAddress) async {
    String abi = ABI.get(contractName);
    DeployedContract contract = DeployedContract(
        ContractAbi.fromJson(abi, contractName),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>> _readFromContract(String contractName,
      String contractAddress, String functionName, List<dynamic> params) async {
    DeployedContract contract = await _contract(contractName, contractAddress);
    return await _client.call(
        contract: contract,
        function: contract.function(functionName),
        params: params);
  }

  Future<String> _callContract(String contractName, String contractAddress,
      String functionName, List<dynamic> params) async {
    bool isApproved = await _approveCb;
    if (!isApproved) {
      throw 'transaction not approved';
    }
    DeployedContract contract = await _contract(contractName, contractAddress);
    Transaction tx = Transaction.callContract(
        contract: contract,
        function: contract.function(functionName),
        parameters: params);
    return await _sendTransactionAndWaitForReceipt(tx);
  }

  Future<dynamic> getTokenDetails(String tokenAddress) async {
    return {
      "name": (await _readFromContract('BasicToken', tokenAddress, 'name', []))
          .first,
      "symbol":
          (await _readFromContract('BasicToken', tokenAddress, 'symbol', []))
              .first,
      "decimals":
          (await _readFromContract('BasicToken', tokenAddress, 'decimals', []))
              .first
    };
  }

  Future<dynamic> getTokenBalance(String tokenAddress, {String address}) async {
    List<dynamic> params = [];
    if (address != null && address != "") {
      params = [EthereumAddress.fromHex(address)];
    } else {
      params = [EthereumAddress.fromHex(await getAddress())];
    }
    return (await _readFromContract(
            'BasicToken', tokenAddress, 'balanceOf', params))
        .first;
  }

  Future<String> tokenTransfer(
      String tokenAddress, String receiverAddress, num tokensAmount) async {
    EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
    dynamic tokenDetails = await getTokenDetails(tokenAddress);
    int tokenDecimals = int.parse(tokenDetails["decimals"].toString());
    Decimal tokensAmountDecimal = Decimal.parse(tokensAmount.toString());
    Decimal decimals = Decimal.parse(pow(10, tokenDecimals).toString());
    BigInt amount = BigInt.from((tokensAmountDecimal * decimals).toInt());
    return await _callContract(
        'BasicToken', tokenAddress, 'transfer', [receiver, amount]);
  }

  String getDefaultCommunity() {
    return _defaultCommunityContractAddress;
  }

  // "old" join community
  Future<String> join(String communityAddress) async {
    return await _callContract('Community', communityAddress, 'join', []);
  }

  Future<EtherAmount> cashGetBalance(String walletAddress) async {
    return await getBalance(address: walletAddress);
  }

  Future<String> getNonceForRelay() async {
    BigInt block = BigInt.from(await _client.getBlockNumber());
    print('block: $block');
    BigInt timestamp = BigInt.from(new DateTime.now().millisecondsSinceEpoch);
    print('timestamp: $timestamp');
    String blockHex = hexZeroPad(hexlify(block), 16);
    String timestampHex = hexZeroPad(hexlify(timestamp), 16);
    return '0x' +
        blockHex.substring(2, blockHex.length) +
        timestampHex.substring(2, timestampHex.length);
  }

  Future<String> signOffChain(String from, String to, BigInt value, String data,
      String nonce, BigInt gasPrice, BigInt gasLimit) async {
    dynamic inputArr = [
      '0x19',
      '0x00',
      from,
      to,
      hexZeroPad(hexlify(value), 32),
      data,
      nonce,
      hexZeroPad(hexlify(gasPrice), 32),
      hexZeroPad(hexlify(gasLimit), 32)
    ];
    String input = '0x' +
        inputArr.map((hexStr) => hexStr.toString().substring(2)).join('');
    print('input: $input');
    Uint8List hash = keccak256(hexToBytes(input));
    print('hash: ${HEX.encode(hash)}');
    print(
        'signing on message with accountAddress: ${await _credentials.extractAddress()}');
    Uint8List signature = await _credentials.signPersonalMessage(hash);
    return '0x' + HEX.encode(signature);
  }

  Future<Map<String, dynamic>> joinCommunityOffChain(
      String walletAddress, String communityAddress) async {
    String nonce = await getNonceForRelay();
    print('nonce: $nonce');

    DeployedContract contract =
        await _contract('CommunityManager', _communityManagerContractAddress);
    Uint8List data = contract.function('joinCommunity').encodeCall([
      EthereumAddress.fromHex(walletAddress),
      EthereumAddress.fromHex(communityAddress)
    ]);
    String encodedData = '0x' + HEX.encode(data);
    print('encodedData: $encodedData');

    String signature = await signOffChain(
        _communityManagerContractAddress,
        walletAddress,
        BigInt.from(0),
        encodedData,
        nonce,
        BigInt.from(0),
        BigInt.from(_defaultGasLimit));

    return {
      "walletAddress": walletAddress,
      "methodData": encodedData,
      "nonce": nonce,
      "gasPrice": 0,
      "gasLimit": _defaultGasLimit,
      "signature": signature,
      "walletModule": "CommunityManager"
    };
  }

  Future<Map<String, dynamic>> transferOffChain(
      String walletAddress, String receiverAddress, int amountInWei) async {
    EthereumAddress wallet = EthereumAddress.fromHex(walletAddress);
    EthereumAddress token = EthereumAddress.fromHex(NATIVE_TOKEN_ADDRESS);
    EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
    BigInt amount = BigInt.from(amountInWei);

    String nonce = await getNonceForRelay();
    DeployedContract contract =
        await _contract('TransferManager', _transferManagerContractAddress);
    Uint8List data = contract
        .function('transferToken')
        .encodeCall([wallet, token, receiver, amount, hexToBytes('0x')]);
    String encodedData = '0x' + HEX.encode(data);

    String signature = await signOffChain(
        _transferManagerContractAddress,
        walletAddress,
        BigInt.from(0),
        encodedData,
        nonce,
        BigInt.from(0),
        BigInt.from(_defaultGasLimit));

    return {
      "walletAddress": walletAddress,
      "methodData": encodedData,
      "nonce": nonce,
      "gasPrice": 0,
      "gasLimit": _defaultGasLimit,
      "signature": signature,
      "walletModule": "TransferManager"
    };
  }

  Future<Map<String, dynamic>> transferTokenOffChain(String walletAddress,
      String tokenAddress, String receiverAddress, num tokensAmount) async {
    EthereumAddress wallet = EthereumAddress.fromHex(walletAddress);
    EthereumAddress token = EthereumAddress.fromHex(tokenAddress);
    EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
    dynamic tokenDetails = await getTokenDetails(tokenAddress);
    int tokenDecimals = int.parse(tokenDetails["decimals"].toString());
    Decimal tokensAmountDecimal = Decimal.parse(tokensAmount.toString());
    Decimal decimals = Decimal.parse(pow(10, tokenDecimals).toString());
    BigInt amount = BigInt.from((tokensAmountDecimal * decimals).toInt());

    String nonce = await getNonceForRelay();
    DeployedContract contract =
        await _contract('TransferManager', _transferManagerContractAddress);
    Uint8List data = contract
        .function('transferToken')
        .encodeCall([wallet, token, receiver, amount, hexToBytes('0x')]);
    String encodedData = '0x' + HEX.encode(data);

    String signature = await signOffChain(
        _transferManagerContractAddress,
        walletAddress,
        BigInt.from(0),
        encodedData,
        nonce,
        BigInt.from(0),
        BigInt.from(_defaultGasLimit));

    return {
      "walletAddress": walletAddress,
      "methodData": encodedData,
      "nonce": nonce,
      "gasPrice": 0,
      "gasLimit": _defaultGasLimit,
      "signature": signature,
      "walletModule": "TransferManager"
    };
  }
}
