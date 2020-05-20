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

const String NATIVE_TOKEN_ADDRESS = '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE'; // For sending native (ETH/FUSE) using TransferManager

class Web3 {
  Web3Client _client;
  Future<bool> _approveCb;
  Credentials _credentials;
  int _networkId;
  String _defaultCommunityContractAddress;
  String _communityManagerContractAddress;
  String _daiPointsManagerContractAddress;
  String _transferManagerContractAddress;
  String _wrapperAddress;
  int _defaultGasLimit;

  Web3(Future<bool> approveCb(), {
    String url,
    int networkId,
    String defaultCommunityAddress,
    String communityManagerAddress,
    String transferManagerAddress,
    String daiPointsManagerAddress,
    String wrapperAddress,
    int defaultGasLimit
  }) {
    _client = new Web3Client(url ?? RPC_URL, new Client());
    _approveCb = approveCb();
    _networkId = networkId ?? NETWORK_ID;
    _defaultCommunityContractAddress = defaultCommunityAddress;
    _communityManagerContractAddress = communityManagerAddress;
    _transferManagerContractAddress = transferManagerAddress;
    _daiPointsManagerContractAddress = daiPointsManagerAddress;
    _wrapperAddress = wrapperAddress;
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
    BigInt amount = BigInt.parse((tokensAmountDecimal * decimals).toString());
    return await _callContract(
        'BasicToken', tokenAddress, 'transfer', [receiver, amount]);
  }

  String getDefaultCommunity() {
    return _defaultCommunityContractAddress;
  }

  String getWrapper() {
    return _wrapperAddress;
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

  Future<Map<String, dynamic>> trasferDaiToDAIpOffChain(String walletAddress, num tokenAmount, int tokenDecimals, {String network = "fuse"}) async {
    EthereumAddress wallet = EthereumAddress.fromHex(walletAddress);
    Decimal tokensAmountDecimal = Decimal.parse(tokenAmount.toString());
    Decimal decimals = Decimal.parse(pow(10, tokenDecimals).toString());
    BigInt amount = BigInt.parse((tokensAmountDecimal * decimals).toString());

    String nonce = await getNonceForRelay();
    print('nonce: $nonce');

    DeployedContract contract = await _contract('DAIPointsManager', _daiPointsManagerContractAddress);
    Uint8List data = contract.function('getDAIPoints').encodeCall([wallet, amount]);
    String encodedData = '0x' + HEX.encode(data);
    print('encodedData: $encodedData');

    String signature = await signOffChain(
        _daiPointsManagerContractAddress,
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
      "network": network,
      "gasPrice": 0,
      "gasLimit": _defaultGasLimit,
      "signature": signature,
      "walletModule": "DAIPointsManager"
    };
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
      String walletAddress, String receiverAddress, int amountInWei, {String network = "fuse"}) async {
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
      "network": network,
      "methodName": "transferToken",
      "gasPrice": 0,
      "gasLimit": _defaultGasLimit,
      "signature": signature,
      "walletModule": "TransferManager"
    };
  }

  Future<Map<String, dynamic>> transferTokenOffChain(String walletAddress,
      String tokenAddress, String receiverAddress, num tokensAmount, {String network = "fuse"}) async {
    EthereumAddress wallet = EthereumAddress.fromHex(walletAddress);
    EthereumAddress token = EthereumAddress.fromHex(tokenAddress);
    EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
    dynamic tokenDetails = await getTokenDetails(tokenAddress);
    int tokenDecimals = int.parse(tokenDetails["decimals"].toString());
    Decimal tokensAmountDecimal = Decimal.parse(tokensAmount.toString());
    Decimal decimals = Decimal.parse(pow(10, tokenDecimals).toString());
    BigInt amount = BigInt.parse((tokensAmountDecimal * decimals).toString());

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
      "network": network,
      "methodName": "transferToken",
      "gasPrice": 0,
      "gasLimit": _defaultGasLimit,
      "signature": signature,
      "walletModule": "TransferManager"
    };
  }

  Future<Map<String, dynamic>> approveTokenOffChain(String walletAddress, String tokenAddress, num tokensAmount, {String network = "fuse"}) async {
    EthereumAddress wallet = EthereumAddress.fromHex(walletAddress);
    EthereumAddress token = EthereumAddress.fromHex(tokenAddress);
    dynamic tokenDetails = await getTokenDetails(tokenAddress);
    int tokenDecimals = int.parse(tokenDetails["decimals"].toString());
    Decimal tokensAmountDecimal = Decimal.parse(tokensAmount.toString());
    Decimal decimals = Decimal.parse(pow(10, tokenDecimals).toString());
    BigInt amount = BigInt.parse((tokensAmountDecimal * decimals).toString());

    String nonce = await getNonceForRelay();
    DeployedContract contract =
        await _contract('TransferManager', _transferManagerContractAddress);
    Uint8List data = contract
        .function('approveToken')
        .encodeCall([wallet, token, wallet, amount]);
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
      "network": network,
      "methodName": "approveToken",
      "gasPrice": 0,
      "gasLimit": _defaultGasLimit,
      "signature": signature,
      "walletModule": "TransferManager"
    };
  }

  Future<Map<String, dynamic>> callContractOffChain(String walletAddress, String contractAddress, num ethAmount, String data, {String network = "fuse"}) async {
    EthereumAddress wallet = EthereumAddress.fromHex(walletAddress);
    EthereumAddress contract = EthereumAddress.fromHex(contractAddress);
    Decimal ethAmountDecimal = Decimal.parse(ethAmount.toString());
    Decimal decimals = Decimal.parse(pow(10, 18).toString());
    BigInt amount = BigInt.parse((ethAmountDecimal * decimals).toString());

    String nonce = await getNonceForRelay();
    DeployedContract TransferManagerContract =
        await _contract('TransferManager', _transferManagerContractAddress);
    Uint8List callContractData = TransferManagerContract
        .function('callContract')
        .encodeCall([wallet, contract, amount, HEX.decode(data)]);
    String encodedCallContractData = '0x' + HEX.encode(callContractData);

    String signature = await signOffChain(
        _transferManagerContractAddress,
        walletAddress,
        BigInt.from(0),
        encodedCallContractData,
        nonce,
        BigInt.from(0),
        BigInt.from(_defaultGasLimit));

    return {
      "walletAddress": walletAddress,
      "methodData": encodedCallContractData,
      "nonce": nonce,
      "network": network,
      "methodName": "callContract",
      "gasPrice": 0,
      "gasLimit": _defaultGasLimit,
      "signature": signature,
      "walletModule": "TransferManager"
    };
  }

  Future<Map<String, dynamic>> approveTokenAndCallContractOffChain(String walletAddress, String tokenAddress, String contractAddress, num tokensAmount, String data, {String network = "fuse"}) async {
    EthereumAddress wallet = EthereumAddress.fromHex(walletAddress);
    EthereumAddress token = EthereumAddress.fromHex(tokenAddress);
    EthereumAddress contract = EthereumAddress.fromHex(contractAddress);
    // dynamic tokenDetails = await getTokenDetails(tokenAddress);
    int tokenDecimals = 18;
    Decimal tokensAmountDecimal = Decimal.parse(tokensAmount.toString());
    Decimal decimals = Decimal.parse(pow(10, tokenDecimals).toString());
    BigInt amount = BigInt.parse((tokensAmountDecimal * decimals).toString());

    String nonce = await getNonceForRelay();
    DeployedContract TransferManagerContract =
        await _contract('TransferManager', _transferManagerContractAddress);
    Uint8List approveTokenAndCallContractData = TransferManagerContract
        .function('approveTokenAndCallContract')
        .encodeCall([wallet, token, contract, amount, HEX.decode(data)]);
    String encodedApproveTokenAndCallContractData = '0x' + HEX.encode(approveTokenAndCallContractData);

    String signature = await signOffChain(
        _transferManagerContractAddress,
        walletAddress,
        BigInt.from(0),
        encodedApproveTokenAndCallContractData,
        nonce,
        BigInt.from(0),
        BigInt.from(_defaultGasLimit));

    return {
      "walletAddress": walletAddress,
      "methodData": encodedApproveTokenAndCallContractData,
      "nonce": nonce,
      "network": network,
      "methodName": "approveTokenAndCallContract",
      "gasPrice": 0,
      "gasLimit": _defaultGasLimit,
      "signature": signature,
      "walletModule": "TransferManager"
    };
  }

  Future<String> getEncodedDataForContractCall(String contractName, String contractAddress, String methodName, List params) async {
    DeployedContract contract = await _contract(contractName, contractAddress);
    Uint8List data = contract.function(methodName).encodeCall(params);
    String encodedData = HEX.encode(data);
    return encodedData;
  }

  Future<String> getTransferWithFeeEncodedData(String tokenAddress, String receiverAddress, num tokenAmount, String feeReceiverAddress, num feeAmount) async {
    EthereumAddress token = EthereumAddress.fromHex(tokenAddress);
    EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
    EthereumAddress feeReceiver = EthereumAddress.fromHex(feeReceiverAddress);
    Decimal tokenAmountDecimal = Decimal.parse(tokenAmount.toString());
    Decimal feeAmountDecimal = Decimal.parse(feeAmount.toString());
    dynamic tokenDetails = await getTokenDetails(tokenAddress);
    int tokenDecimals = int.parse(tokenDetails["decimals"].toString());
    Decimal decimals = Decimal.parse(pow(10, tokenDecimals).toString());
    BigInt amount = BigInt.parse((tokenAmountDecimal * decimals).toString());
    BigInt fee = BigInt.parse((feeAmountDecimal * decimals).toString());
    
    String encodedData = await getEncodedDataForContractCall(
      'Wrapper', _wrapperAddress, 'transferWithFee', [token, receiver, amount, feeReceiver, fee]
    );
    return encodedData;
  }

  Future<String> getTransferAndCallWithFeeEncodedData(String tokenAddress, String contractAddress, num tokenAmount, String feeReceiverAddress, num feeAmount, String contractCallData) async {
    EthereumAddress token = EthereumAddress.fromHex(tokenAddress);
    EthereumAddress contract = EthereumAddress.fromHex(contractAddress);
    EthereumAddress feeReceiver = EthereumAddress.fromHex(feeReceiverAddress);
    Decimal tokenAmountDecimal = Decimal.parse(tokenAmount.toString());
    Decimal feeAmountDecimal = Decimal.parse(feeAmount.toString());
    dynamic tokenDetails = await getTokenDetails(tokenAddress);
    int tokenDecimals = int.parse(tokenDetails["decimals"].toString());
    Decimal decimals = Decimal.parse(pow(10, tokenDecimals).toString());
    BigInt amount = BigInt.parse((tokenAmountDecimal * decimals).toString());
    BigInt fee = BigInt.parse((feeAmountDecimal * decimals).toString());
    
    String encodedData = await getEncodedDataForContractCall(
      'Wrapper',
      _wrapperAddress,
      'transferAndCallWithFee',
      [token, contract, amount, feeReceiver, fee, HEX.decode(contractCallData)]
    );
    return encodedData;
  }
}
