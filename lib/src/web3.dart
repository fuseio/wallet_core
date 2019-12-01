library web3;

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

const String RPC_URL = 'https://rpc.fuse.io';
const num NETWORK_ID = 122;

const String DEFAULT_COMMUNITY_CONTRACT_ADDRESS =
    '0xbA01716EAD7989a00cC3b2AE6802b54eaF40fb72';

const String NATIVE_TOKEN_ADDRESS =
    '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE'; // For sending native (ETH/FUSE) using TransferManager

const String COMMUNITY_MANAGER_CONTRACT_ADDRESS =
    '0x306BB3f40BEa3710cAc4BD9F1Ef052aD999d7233';
const String TRANSFER_MANAGER_CONTRACT_ADDRESS =
    '0xBbE1EcEE01bBa382088E243624aE69C4D7F378A8';

class ABI {
  static String get(String name) {
    List<Map<String, Object>> abi;
    switch (name) {
      case "BasicToken":
        abi = [{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"spender","type":"address"},{"name":"value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"sender","type":"address"},{"name":"recipient","type":"address"},{"name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"spender","type":"address"},{"name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"tokenURI","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"account","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"renounceOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"isOwner","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"spender","type":"address"},{"name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"owner","type":"address"},{"name":"spender","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"name","type":"string"},{"name":"symbol","type":"string"},{"name":"initialSupply","type":"uint256"},{"name":"tokenURI","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"tokenURI","type":"string"}],"name":"TokenURIChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"},{"indexed":true,"name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"constant":false,"inputs":[{"name":"tokenURI","type":"string"}],"name":"setTokenURI","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}];
        break;
      case "Community":
        abi = [{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"adminMask","outputs":[{"name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"userMask","outputs":[{"name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"entitiesList","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_name","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"constant":false,"inputs":[{"name":"_entitiesList","type":"address"}],"name":"setEntitiesList","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"join","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_account","type":"address"},{"name":"_roles","type":"bytes32"}],"name":"addEntity","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_account","type":"address"}],"name":"removeEntity","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_account","type":"address"},{"name":"_entityRoles","type":"bytes32"}],"name":"addEnitityRoles","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_account","type":"address"},{"name":"_entityRoles","type":"bytes32"}],"name":"removeEnitityRoles","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_account","type":"address"},{"name":"_entityRoles","type":"bytes32"}],"name":"hasRoles","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"}];
        break;
      case "CommunityManager":
        abi = [{"constant":false,"inputs":[{"name":"_wallet","type":"address"}],"name":"init","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_wallet","type":"address"}],"name":"getNonce","outputs":[{"name":"nonce","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"},{"name":"_module","type":"address"}],"name":"addModule","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"recoverToken","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"},{"name":"_data","type":"bytes"},{"name":"_nonce","type":"uint256"},{"name":"_signatures","type":"bytes"},{"name":"_gasPrice","type":"uint256"},{"name":"_gasLimit","type":"uint256"}],"name":"execute","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"relayer","outputs":[{"name":"nonce","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"isOnlyOwnerModule","outputs":[{"name":"","type":"bytes4"}],"payable":false,"stateMutability":"pure","type":"function"},{"inputs":[{"name":"_registry","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"wallet","type":"address"},{"indexed":true,"name":"success","type":"bool"},{"indexed":false,"name":"signedHash","type":"bytes32"}],"name":"TransactionExecuted","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"name","type":"bytes32"}],"name":"ModuleCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"wallet","type":"address"}],"name":"ModuleInitialised","type":"event"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"},{"name":"_community","type":"address"}],"name":"joinCommunity","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}];
        break;
      case "TransferManager":
        abi = [{"constant":true,"inputs":[],"name":"securityWindow","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_wallet","type":"address"}],"name":"getNonce","outputs":[{"name":"nonce","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_wallet","type":"address"}],"name":"getCurrentLimit","outputs":[{"name":"_currentLimit","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"},{"name":"_module","type":"address"}],"name":"addModule","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_wallet","type":"address"}],"name":"getDailyUnspent","outputs":[{"name":"_unspent","type":"uint256"},{"name":"_periodEnd","type":"uint64"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"securityPeriod","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"oldLimitManager","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"transferStorage","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"recoverToken","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_wallet","type":"address"}],"name":"getPendingLimit","outputs":[{"name":"_pendingLimit","type":"uint256"},{"name":"_changeAfter","type":"uint64"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"},{"name":"_data","type":"bytes"},{"name":"_nonce","type":"uint256"},{"name":"_signatures","type":"bytes"},{"name":"_gasPrice","type":"uint256"},{"name":"_gasLimit","type":"uint256"}],"name":"execute","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"priceProvider","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"relayer","outputs":[{"name":"nonce","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"isOnlyOwnerModule","outputs":[{"name":"","type":"bytes4"}],"payable":false,"stateMutability":"pure","type":"function"},{"constant":true,"inputs":[],"name":"guardianStorage","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"defaultLimit","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_registry","type":"address"},{"name":"_transferStorage","type":"address"},{"name":"_guardianStorage","type":"address"},{"name":"_priceProvider","type":"address"},{"name":"_securityPeriod","type":"uint256"},{"name":"_securityWindow","type":"uint256"},{"name":"_defaultLimit","type":"uint256"},{"name":"_oldLimitManager","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"wallet","type":"address"},{"indexed":true,"name":"target","type":"address"},{"indexed":false,"name":"whitelistAfter","type":"uint64"}],"name":"AddedToWhitelist","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"wallet","type":"address"},{"indexed":true,"name":"target","type":"address"}],"name":"RemovedFromWhitelist","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"wallet","type":"address"},{"indexed":true,"name":"id","type":"bytes32"},{"indexed":true,"name":"executeAfter","type":"uint256"},{"indexed":false,"name":"token","type":"address"},{"indexed":false,"name":"to","type":"address"},{"indexed":false,"name":"amount","type":"uint256"},{"indexed":false,"name":"data","type":"bytes"}],"name":"PendingTransferCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"wallet","type":"address"},{"indexed":true,"name":"id","type":"bytes32"}],"name":"PendingTransferExecuted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"wallet","type":"address"},{"indexed":true,"name":"id","type":"bytes32"}],"name":"PendingTransferCanceled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"wallet","type":"address"},{"indexed":true,"name":"newLimit","type":"uint256"},{"indexed":true,"name":"startAfter","type":"uint64"}],"name":"LimitChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"wallet","type":"address"},{"indexed":true,"name":"token","type":"address"},{"indexed":true,"name":"amount","type":"uint256"},{"indexed":false,"name":"to","type":"address"},{"indexed":false,"name":"data","type":"bytes"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"wallet","type":"address"},{"indexed":true,"name":"token","type":"address"},{"indexed":false,"name":"amount","type":"uint256"},{"indexed":false,"name":"spender","type":"address"}],"name":"Approved","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"wallet","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"amount","type":"uint256"},{"indexed":false,"name":"data","type":"bytes"}],"name":"CalledContract","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"wallet","type":"address"},{"indexed":true,"name":"success","type":"bool"},{"indexed":false,"name":"signedHash","type":"bytes32"}],"name":"TransactionExecuted","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"name","type":"bytes32"}],"name":"ModuleCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"wallet","type":"address"}],"name":"ModuleInitialised","type":"event"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"}],"name":"init","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"},{"name":"_token","type":"address"},{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"},{"name":"_data","type":"bytes"}],"name":"transferToken","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"},{"name":"_token","type":"address"},{"name":"_spender","type":"address"},{"name":"_amount","type":"uint256"}],"name":"approveToken","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"},{"name":"_contract","type":"address"},{"name":"_value","type":"uint256"},{"name":"_data","type":"bytes"}],"name":"callContract","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"},{"name":"_target","type":"address"}],"name":"addToWhitelist","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"},{"name":"_target","type":"address"}],"name":"removeFromWhitelist","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"},{"name":"_token","type":"address"},{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"},{"name":"_data","type":"bytes"},{"name":"_block","type":"uint256"}],"name":"executePendingTransfer","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"},{"name":"_id","type":"bytes32"}],"name":"cancelPendingTransfer","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"},{"name":"_newLimit","type":"uint256"}],"name":"changeLimit","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_wallet","type":"address"}],"name":"disableLimit","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_wallet","type":"address"},{"name":"_target","type":"address"}],"name":"isWhitelisted","outputs":[{"name":"_isWhitelisted","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_wallet","type":"address"},{"name":"_id","type":"bytes32"}],"name":"getPendingTransfer","outputs":[{"name":"_executeAfter","type":"uint64"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_data","type":"bytes"},{"name":"_signature","type":"bytes"}],"name":"isValidSignature","outputs":[{"name":"","type":"bytes4"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_msgHash","type":"bytes32"},{"name":"_signature","type":"bytes"}],"name":"isValidSignature","outputs":[{"name":"","type":"bytes4"}],"payable":false,"stateMutability":"view","type":"function"}];
        break;
      default:
        throw 'ABI does not exists for $name';
    }

    return jsonEncode(abi);
  }
}

class Web3 {
  Web3Client _client;
  Future<bool> _approveCb;
  Credentials _credentials;
  num _networkId;

  Web3(Future<bool> approveCb(), {String url, num networkId}) {
    _client = new Web3Client(url ?? RPC_URL, new Client());
    _approveCb = approveCb();
    _networkId = networkId ?? NETWORK_ID;
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
    num delay = 1;
    num retries = 10;
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

  Future<String> transfer(String receiverAddress, num amountInWei) async {
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
    num tokenDecimals = int.parse(tokenDetails["decimals"].toString());
    BigInt amount = BigInt.from(tokensAmount * pow(10, tokenDecimals));
    return await _callContract(
        'BasicToken', tokenAddress, 'transfer', [receiver, amount]);
  }

  static String getDefaultCommunity() {
    return DEFAULT_COMMUNITY_CONTRACT_ADDRESS;
  }

  Future<String> joinCommunity(String walletAddress,
      {String communityAddress}) async {
    EthereumAddress wallet = EthereumAddress.fromHex(walletAddress);
    EthereumAddress community = EthereumAddress.fromHex(
        communityAddress ?? DEFAULT_COMMUNITY_CONTRACT_ADDRESS);
    return await _callContract(
        'CommunityManager',
        COMMUNITY_MANAGER_CONTRACT_ADDRESS,
        'joinCommunity',
        [wallet, community]);
  }

  // "old" join community
  Future<String> join(String communityAddress) async {
    return await _callContract('Community', communityAddress, 'join', []);
  }

  Future<EtherAmount> cashGetBalance(String walletAddress) async {
    return await getBalance(address: walletAddress);
  }

  Future<String> cashTransfer(
      String walletAddress, String receiverAddress, num amountInWei) async {
    EthereumAddress wallet = EthereumAddress.fromHex(walletAddress);
    EthereumAddress token = EthereumAddress.fromHex(NATIVE_TOKEN_ADDRESS);
    EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
    BigInt amount = BigInt.from(amountInWei);
    return await _callContract(
        'TransferManager',
        TRANSFER_MANAGER_CONTRACT_ADDRESS,
        'transferToken',
        [wallet, token, receiver, amount, hexToBytes('0x')]);
  }

  Future<String> cashTokenTransfer(String walletAddress, String tokenAddress,
      String receiverAddress, num tokensAmount) async {
    EthereumAddress wallet = EthereumAddress.fromHex(walletAddress);
    EthereumAddress token = EthereumAddress.fromHex(tokenAddress);
    EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
    dynamic tokenDetails = await getTokenDetails(tokenAddress);
    num tokenDecimals = int.parse(tokenDetails["decimals"].toString());
    BigInt amount = BigInt.from(tokensAmount * pow(10, tokenDecimals));
    return await _callContract(
        'TransferManager',
        TRANSFER_MANAGER_CONTRACT_ADDRESS,
        'transferToken',
        [wallet, token, receiver, amount, hexToBytes('0x')]);
  }

  Future<dynamic> cashGetTokenBalance(
      String walletAddress, String tokenAddress) async {
    return getTokenBalance(tokenAddress, address: walletAddress);
  }


  String signOffChain(String signer, String from, String to, num amountInWei, num nonce, num gasPrice, num gasLimit) {
    List<int> input = null;
    keccak256(Uint8List.fromList(input));
  }
}
